package com.example.vroo_test

import android.content.Context
import android.graphics.Color
import android.location.Geocoder
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.SystemClock
import android.util.Log
import android.view.View
import android.view.ViewTreeObserver
import com.google.android.gms.maps.*
import com.google.android.gms.maps.model.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import java.util.*
import kotlinx.coroutines.*

class NativeMapView(
    private val context: Context,
    messenger: io.flutter.plugin.common.BinaryMessenger,
    viewId: Int,
    private val creationParams: Map<String, Any>?
) : PlatformView, OnMapReadyCallback, MethodChannel.MethodCallHandler {

    private val mapView: MapView = MapView(context)
    private var googleMap: GoogleMap? = null
    private val methodChannel: MethodChannel
    private val handler = Handler(Looper.getMainLooper())
    private val coroutineScope = CoroutineScope(Dispatchers.Main + Job())
    private var isMapReady = false
    private val pendingOperations = mutableListOf<() -> Unit>()

    // Marker colors
    private val START_MARKER_COLOR = BitmapDescriptorFactory.HUE_GREEN
    private val DEST_MARKER_COLOR = BitmapDescriptorFactory.HUE_RED
    private val SELECTED_MARKER_COLOR = BitmapDescriptorFactory.HUE_ORANGE
    private val MOVING_MARKER_COLOR = BitmapDescriptorFactory.HUE_BLUE
    private val SELECTED_ROUTE_COLOR = Color.parseColor("#EC8825")

    // Route visualization
    private var routeData: List<Map<String, Any>> = emptyList()
    private val allPolylines = mutableListOf<Polyline>()
    private var selectedPolyline: Polyline? = null
    private var selectedMarker: Marker? = null

    // Markers
    private var startMarker: Marker? = null
    private var destMarker: Marker? = null
    private var activeMarker: String? = null
    private var movingMarkers = mutableMapOf<String, Marker>()
    private var showMarkers: Boolean = false
    private var markerUpdateCallback: ((String, LatLng) -> Unit)? = null

    init {
        // Create a Bundle to properly handle the map's lifecycle
        val mapViewBundle = Bundle()
        creationParams?.get("mapViewBundle")?.let {
            if (it is Bundle) {
                mapViewBundle.putAll(it)
            }
        }
        
        // Initialize map with proper lifecycle handlers
        mapView.onCreate(mapViewBundle)
        mapView.onResume()  // Important to ensure map is visible
        
        // Set hardware acceleration for better performance
        mapView.setLayerType(View.LAYER_TYPE_HARDWARE, null)
        
        // Get map instance asynchronously
        mapView.getMapAsync(this)
        
        // Setup method channel for Flutter communication
        methodChannel = MethodChannel(messenger, "native_google_map_$viewId")
        methodChannel.setMethodCallHandler(this)
        
        // Get initial parameters
        showMarkers = creationParams?.get("showMarkers") as? Boolean ?: false
    }

    override fun getView(): View = mapView

    override fun dispose() {
        mapView.onPause()
        mapView.onStop()
        mapView.onDestroy()
        methodChannel.setMethodCallHandler(null)
        coroutineScope.cancel()
    }

    override fun onMapReady(map: GoogleMap) {
        googleMap = map
        isMapReady = true
        
        map.apply {
            uiSettings.apply {
                isZoomControlsEnabled = true
                isMyLocationButtonEnabled = true
                isMapToolbarEnabled = false
            }

            // Setup listeners
            setOnPolylineClickListener(::onPolylineClick)
            setOnMarkerClickListener(::onMarkerClick)
            setOnMapClickListener(::onMapClick)
            setOnMarkerDragListener(markerDragListener)
        }

        // Initialize with default position
        val initialPosition = LatLng(24.9312, 67.1239)
        safeMoveCamera(CameraUpdateFactory.newLatLngZoom(initialPosition, 12f))

        // Initialize markers
        updateStartMarker(LatLng(24.9412, 67.1139))
        updateDestMarker(initialPosition)

        // Process any pending operations
        pendingOperations.forEach { it() }
        pendingOperations.clear()
        
        // Notify Flutter that map is ready
        methodChannel.invokeMethod("onMapReady", null)
    }

    private fun safeMoveCamera(update: CameraUpdate) {
        if (isMapReady) {
            googleMap?.moveCamera(update)
        } else {
            pendingOperations.add { safeMoveCamera(update) }
        }
    }

    private val markerDragListener = object : GoogleMap.OnMarkerDragListener {
        override fun onMarkerDragStart(marker: Marker) {}
        override fun onMarkerDrag(marker: Marker) {}
        override fun onMarkerDragEnd(marker: Marker) {
            when {
                marker == startMarker -> {
                    updateMarkerPosition("start", marker.position)
                    drawRoutes()
                }
                marker == destMarker -> {
                    updateMarkerPosition("dest", marker.position)
                    drawRoutes()
                }
                else -> movingMarkers.entries.find { it.value == marker }?.let { (id, _) ->
                    markerUpdateCallback?.invoke(id, marker.position)
                }
            }
        }
    }

    private fun onMarkerClick(marker: Marker): Boolean {
        return when (marker) {
            startMarker -> { 
                if (activeMarker == "dest") {
                    destMarker?.setIcon(BitmapDescriptorFactory.defaultMarker(DEST_MARKER_COLOR))
                }
                activeMarker = "start"
                marker.setIcon(BitmapDescriptorFactory.defaultMarker(SELECTED_MARKER_COLOR))
                marker.showInfoWindow()
                true 
            }
            destMarker -> { 
                if (activeMarker == "start") {
                    startMarker?.setIcon(BitmapDescriptorFactory.defaultMarker(START_MARKER_COLOR))
                }
                activeMarker = "dest"
                marker.setIcon(BitmapDescriptorFactory.defaultMarker(SELECTED_MARKER_COLOR))
                marker.showInfoWindow()
                true 
            }
            else -> movingMarkers.entries.find { it.value == marker }?.let { (id, _) ->
                methodChannel.invokeMethod("onMovingMarkerClicked", mapOf("id" to id)).let { true }
            } ?: false
        }
    }

    private fun onMapClick(latLng: LatLng) {
        when (activeMarker) {
            "start" -> {
                startMarker?.setIcon(BitmapDescriptorFactory.defaultMarker(START_MARKER_COLOR))
                updateMarkerPosition("start", latLng)
            }
            "dest" -> {
                destMarker?.setIcon(BitmapDescriptorFactory.defaultMarker(DEST_MARKER_COLOR))
                updateMarkerPosition("dest", latLng)
            }
            else -> if (showMarkers) {
                when {
                    startMarker == null -> placeNewMarker("start", latLng)
                    destMarker == null -> placeNewMarker("dest", latLng)
                }
            }
        }
        activeMarker = null
    }

    private fun updateStartMarker(position: LatLng, title: String = "Start Location") {
        if (!isMapReady) {
            pendingOperations.add { updateStartMarker(position, title) }
            return
        }
        
        startMarker?.remove()
        startMarker = safeCreateMarker(position, title, START_MARKER_COLOR, "start")
        startMarker?.let { updateMarkerTitle(it, "start") }
    }

    private fun updateDestMarker(position: LatLng, title: String = "Destination") {
        if (!isMapReady) {
            pendingOperations.add { updateDestMarker(position, title) }
            return
        }
        
        destMarker?.remove()
        destMarker = safeCreateMarker(position, title, DEST_MARKER_COLOR, "dest")
        destMarker?.let { updateMarkerTitle(it, "dest") }
    }

    private fun safeCreateMarker(position: LatLng, title: String, color: Float, type: String? = null): Marker? {
        return try {
            googleMap?.addMarker(
                MarkerOptions()
                    .position(position)
                    .title(title)
                    .icon(BitmapDescriptorFactory.defaultMarker(color))
                    .draggable(true)
                    .visible(showMarkers)
            )?.apply {
                if (showMarkers) showInfoWindow()
                updateMarkerTitle(this, type)
            }
        } catch (e: Exception) {
            Log.e("NativeMapView", "Failed to create marker", e)
            null
        }
    }

    private fun updateMarkerTitle(marker: Marker, type: String? = null) {
        getAddressFromLocation(marker.position) { address ->
            handler.post {
                val prefix = when {
                    type == "start" -> "Start: "
                    type == "dest" -> "Destination: "
                    else -> ""
                }
                marker.title = "$prefix${address ?: "${marker.position.latitude}, ${marker.position.longitude}"}"
                marker.snippet = "${marker.position.latitude}, ${marker.position.longitude}"
                if (showMarkers) marker.showInfoWindow()
            }
        }
    }

    private fun getAddressFromLocation(position: LatLng, callback: (String?) -> Unit) {
        if (!Geocoder.isPresent()) {
            callback("${position.latitude}, ${position.longitude}")
            return
        }

        coroutineScope.launch(Dispatchers.IO) {
            try {
                val geocoder = Geocoder(context, Locale.getDefault())
                val addresses = geocoder.getFromLocation(
                    position.latitude,
                    position.longitude,
                    1
                )
                withContext(Dispatchers.Main) {
                    if (!addresses.isNullOrEmpty()) {
                        val address = addresses[0].getAddressLine(0)
                        callback(address)
                    } else {
                        callback("${position.latitude}, ${position.longitude}")
                    }
                }
            } catch (e: Exception) {
                Log.e("NativeMapView", "Geocoder error: ${e.message}")
                withContext(Dispatchers.Main) {
                    callback("${position.latitude}, ${position.longitude}")
                }
            }
        }
    }

    private fun placeNewMarker(type: String, position: LatLng) {
        when (type) {
            "start" -> updateStartMarker(position)
            "dest" -> updateDestMarker(position)
        }
        sendMarkerUpdate(type, position)
    }

    private fun updateMarkerPosition(type: String, position: LatLng) {
        when (type) {
            "start" -> {
                startMarker?.position = position
                startMarker?.let { updateMarkerTitle(it, "start") }
                sendMarkerUpdate("start", position)
            }
            "dest" -> {
                destMarker?.position = position
                destMarker?.let { updateMarkerTitle(it, "dest") }
                sendMarkerUpdate("dest", position)
            }
        }
    }

    private fun sendMarkerUpdate(type: String, position: LatLng) {
        methodChannel.invokeMethod("onMarkerMoved", mapOf(
            "type" to type,
            "lat" to position.latitude,
            "lng" to position.longitude
        ))
    }

    private fun onPolylineClick(polyline: Polyline) {
        (polyline.tag as? Map<*, *>)?.let { route ->
            allPolylines.forEach { it.color = Color.parseColor("#4285F4") }
            
            polyline.color = SELECTED_ROUTE_COLOR
            selectedPolyline = polyline

            showRouteInfoMarker(route as Map<String, Any>, "Selected Route")
            
            methodChannel.invokeMethod("routeSelected", route.mapKeys { it.key.toString() })
        }
    }

    private fun drawRoutes() {
        if (!isMapReady || routeData.isEmpty() || startMarker == null || destMarker == null) {
            return
        }

        clearRouteElements()

        val builder = LatLngBounds.Builder().apply {
            include(startMarker!!.position)
            include(destMarker!!.position)
        }

        val bestRoute = routeData.minWithOrNull(compareBy(
            { (it["duration"] as? Number)?.toDouble() ?: Double.MAX_VALUE },
            { (it["distance"] as? Number)?.toDouble() ?: Double.MAX_VALUE }
        ))

        routeData.forEach { route ->
            (route["coords"] as? List<List<Double>>)?.let { coords ->
                googleMap?.addPolyline(
                    PolylineOptions()
                        .color(Color.parseColor("#4285F4"))
                        .width(if (route == bestRoute) 10f else 7f)
                        .geodesic(true)
                        .clickable(true)
                        .addAll(coords.map { LatLng(it[0], it[1]) })
                )?.apply {
                    tag = route
                    allPolylines.add(this)
                    
                    coords.forEach { builder.include(LatLng(it[0], it[1])) }

                    if (route == bestRoute) {
                        color = SELECTED_ROUTE_COLOR
                        width = 12f
                        selectedPolyline = this
                        showRouteInfoMarker(route, "Best Route")
                    }
                }
            }
        }

        try {
            safeAnimateCameraWithBounds(builder.build(), 100)
        } catch (e: Exception) {
            Log.e("NativeMapView", "Camera update failed", e)
        }
    }

    private fun showRouteInfoMarker(route: Map<String, Any>, title: String) {
        selectedMarker?.remove()
        (route["coords"] as? List<List<Double>>)?.let { coords ->
            val position = coords[coords.size / 2].let { LatLng(it[0], it[1]) }
            selectedMarker = googleMap?.addMarker(
                MarkerOptions()
                    .position(position)
                    .title(title)
                    .snippet("Distance: ${route["distance"]}\nDuration: ${route["duration"]}")
                    .icon(BitmapDescriptorFactory.defaultMarker(SELECTED_MARKER_COLOR))
            )?.apply { 
                showInfoWindow()
                getAddressFromLocation(position) { address ->
                    handler.post {
                        this.title = "$title: ${address ?: "${position.latitude}, ${position.longitude}"}"
                        this.snippet = "Distance: ${route["distance"]}\nDuration: ${route["duration"]}\n${position.latitude}, ${position.longitude}"
                        showInfoWindow()
                    }
                }
            }
        }
    }

    private fun clearRouteElements() {
        allPolylines.forEach { it.remove() }
        allPolylines.clear()
        selectedMarker?.remove()
        selectedMarker = null
        selectedPolyline = null
    }

    private fun addMovingMarker(id: String, position: LatLng, title: String, iconRes: Int? = null) {
        if (!isMapReady) {
            pendingOperations.add { addMovingMarker(id, position, title, iconRes) }
            return
        }
        
        movingMarkers[id]?.remove()
        
        val markerOptions = MarkerOptions()
            .position(position)
            .title(title)
            .draggable(true)
            .icon(iconRes?.let { 
                BitmapDescriptorFactory.fromResource(it)
            } ?: BitmapDescriptorFactory.defaultMarker(MOVING_MARKER_COLOR))

        val marker = googleMap?.addMarker(markerOptions)?.apply { showInfoWindow() }
        if (marker != null) {
            movingMarkers[id] = marker
            getAddressFromLocation(position) { address ->
                handler.post {
                    marker.title = "$title: ${address ?: "${position.latitude}, ${position.longitude}"}"
                    marker.showInfoWindow()
                }
            }
        }
    }

    private fun updateMovingMarker(id: String, newPosition: LatLng, animate: Boolean = true) {
        if (!isMapReady) {
            pendingOperations.add { updateMovingMarker(id, newPosition, animate) }
            return
        }
        
        movingMarkers[id]?.let { marker ->
            if (animate) {
                animateMarkerMovement(marker, newPosition)
            } else {
                marker.position = newPosition
            }
            
            val cameraUpdate = CameraUpdateFactory.newLatLngZoom(newPosition, 15f)
            googleMap?.animateCamera(cameraUpdate)
            
            getAddressFromLocation(newPosition) { address ->
                handler.post {
                    marker.title = "Vehicle $id: ${address ?: "${newPosition.latitude}, ${newPosition.longitude}"}"
                    marker.showInfoWindow()
                }
            }
        } ?: run {
            addMovingMarker(id, newPosition, "Vehicle $id")
        }
    }
    
    private fun animateMarkerMovement(marker: Marker, finalPosition: LatLng, duration: Long = 1500) {
        val startPosition = marker.position
        val handler = Handler(Looper.getMainLooper())
        val start = SystemClock.uptimeMillis()
        
        handler.post(object : Runnable {
            override fun run() {
                val elapsed = SystemClock.uptimeMillis() - start
                val t = elapsed.toFloat() / duration
                
                if (t < 1.0) {
                    val lat = startPosition.latitude + (finalPosition.latitude - startPosition.latitude) * t
                    val lng = startPosition.longitude + (finalPosition.longitude - startPosition.longitude) * t
                    marker.position = LatLng(lat, lng)
                    handler.postDelayed(this, 16)
                } else {
                    marker.position = finalPosition
                }
            }
        })
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "setRouteData" -> {
                routeData = call.argument<List<Map<String, Any>>>("routeData") ?: emptyList()
                drawRoutes()
                result.success(null)
            }
            "updateMarkers" -> {
                val args = call.arguments as Map<String, Any?>
                args["startLat"]?.let { lat ->
                    args["startLng"]?.let { lng ->
                        updateStartMarker(LatLng(lat as Double, lng as Double))
                    }
                }
                args["destLat"]?.let { lat ->
                    args["destLng"]?.let { lng ->
                        updateDestMarker(LatLng(lat as Double, lng as Double))
                    }
                }
                result.success(null)
            }
            "clearMarkers" -> {
                startMarker?.remove()
                destMarker?.remove()
                startMarker = null
                destMarker = null
                result.success(null)
            }
            "addMovingMarker" -> {
                val id = call.argument<String>("id") ?: return result.error("INVALID_ARG", "Missing id", null)
                val lat = call.argument<Double>("lat") ?: return result.error("INVALID_ARG", "Missing lat", null)
                val lng = call.argument<Double>("lng") ?: return result.error("INVALID_ARG", "Missing lng", null)
                val title = call.argument<String>("title") ?: "Vehicle"
                val iconRes = call.argument<Int>("iconRes")
                
                addMovingMarker(id, LatLng(lat, lng), title, iconRes)
                result.success(null)
            }
            "updateMovingMarker" -> {
                val id = call.argument<String>("id") ?: return result.error("INVALID_ARG", "Missing id", null)
                val lat = call.argument<Double>("lat") ?: return result.error("INVALID_ARG", "Missing lat", null)
                val lng = call.argument<Double>("lng") ?: return result.error("INVALID_ARG", "Missing lng", null)
                val animate = call.argument<Boolean>("animate") ?: true
                
                updateMovingMarker(id, LatLng(lat, lng), animate)
                result.success(null)
            }
            "removeMovingMarker" -> {
                val id = call.argument<String>("id") ?: return result.error("INVALID_ARG", "Missing id", null)
                movingMarkers[id]?.remove()
                movingMarkers.remove(id)
                result.success(null)
            }
            "setMarkerUpdateCallback" -> {
                markerUpdateCallback = { id, position ->
                    methodChannel.invokeMethod("onMovingMarkerMoved", mapOf(
                        "id" to id,
                        "lat" to position.latitude,
                        "lng" to position.longitude
                    ))
                }
                result.success(null)
            }
            "getPlaceDetails" -> {
                val lat = call.argument<Double>("lat") ?: return result.error("INVALID_ARG", "Missing lat", null)
                val lng = call.argument<Double>("lng") ?: return result.error("INVALID_ARG", "Missing lng", null)
                val type = call.argument<String>("type") ?: "location"
                val id = call.argument<String>("id")
                
                coroutineScope.launch {
                    getAddressFromLocation(LatLng(lat, lng)) { address ->
                        val placeInfo = mutableMapOf<String, Any>(
                            "type" to type,
                            "placeName" to (address ?: "${lat}, ${lng}"),
                            "address" to (address ?: "${lat}, ${lng}"),
                            "lat" to lat,
                            "lng" to lng
                        )
                        
                        id?.let { placeInfo["markerId"] = it }
                        
                        methodChannel.invokeMethod("onPlaceInfo", placeInfo)
                    }
                    result.success(null)
                }
            }
            "setShowMarkers" -> {
                showMarkers = call.argument<Boolean>("show") ?: true
                startMarker?.isVisible = showMarkers
                destMarker?.isVisible = showMarkers
                result.success(null)
            }
            "batchUpdateMovingMarkers" -> {
                val updates = call.argument<List<Map<String, Any>>>("updates") ?: 
                    return result.error("INVALID_ARG", "Missing updates", null)
                
                for (update in updates) {
                    val id = update["id"] as? String ?: continue
                    val lat = update["lat"] as? Double ?: continue
                    val lng = update["lng"] as? Double ?: continue
                    val animate = update["animate"] as? Boolean ?: false
                    
                    updateMovingMarker(id, LatLng(lat, lng), animate)
                }
                result.success(null)
            }
            "optimizeMapRendering" -> {
                val enableHardwareAcceleration = call.argument<Boolean>("enableHardwareAcceleration") ?: true
                val reduceAnimations = call.argument<Boolean>("reduceAnimations") ?: false
                
                if (enableHardwareAcceleration) {
                    mapView.setLayerType(View.LAYER_TYPE_HARDWARE, null)
                }
                
                if (reduceAnimations) {
                    googleMap?.animateCamera(CameraUpdateFactory.zoomBy(0f))
                }
                
                result.success(null)
            }
            "invalidateMap" -> {
                // Force a redraw of the map
                mapView.invalidate()
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun safeAnimateCameraWithBounds(bounds: LatLngBounds, padding: Int) {
        if (!isMapReady) {
            pendingOperations.add { safeAnimateCameraWithBounds(bounds, padding) }
            return
        }
        
        if (mapView.width > 0 && mapView.height > 0) {
            try {
                googleMap?.animateCamera(CameraUpdateFactory.newLatLngBounds(bounds, padding))
            } catch (e: Exception) {
                Log.e("NativeMapView", "Camera update failed: ${e.message}")
                googleMap?.moveCamera(CameraUpdateFactory.newLatLngBounds(bounds, padding))
            }
        } else {
            mapView.viewTreeObserver.addOnGlobalLayoutListener(object : ViewTreeObserver.OnGlobalLayoutListener {
                override fun onGlobalLayout() {
                    mapView.viewTreeObserver.removeOnGlobalLayoutListener(this)
                    try {
                        googleMap?.animateCamera(CameraUpdateFactory.newLatLngBounds(bounds, padding))
                    } catch (e: Exception) {
                        Log.e("NativeMapView", "Camera update failed: ${e.message}")
                        googleMap?.moveCamera(CameraUpdateFactory.newLatLngBounds(bounds, padding))
                    }
                }
            })
        }
    }
    
    // Handle necessary map lifecycle events
    fun onResume() {
        mapView.onResume()
    }
    
    fun onPause() {
        mapView.onPause()
    }
    
    fun onStart() {
        mapView.onStart()
    }
    
    fun onStop() {
        mapView.onStop()
    }
    
    fun onLowMemory() {
        mapView.onLowMemory()
    }
    
    fun onSaveInstanceState(outState: Bundle) {
        mapView.onSaveInstanceState(outState)
    }
}