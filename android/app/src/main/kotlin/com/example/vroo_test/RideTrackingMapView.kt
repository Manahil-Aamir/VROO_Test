package com.example.vroo_test

import android.content.Context
import android.util.Log
import android.view.View
import com.google.android.gms.maps.*
import com.google.android.gms.maps.model.*
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

data class PickupDropoffPoint(
    val latLng: LatLng,
    val name: String,
    val isPickup: Boolean // true if it's a pickup point, false if it's a dropoff point
)


class RideTrackingMapView(
    private val context: Context,
    id: Int,
    creationParams: Map<String?, Any?>?,
    messenger: BinaryMessenger
) : PlatformView, MethodChannel.MethodCallHandler, OnMapReadyCallback {

    private val mapView: MapView = MapView(context)
    private val methodChannel = MethodChannel(messenger, "com.example.vroo_test/ride_map")
    private var googleMap: GoogleMap? = null

    private val routePoints = mutableListOf<LatLng>()
    private val pickupPoints = mutableListOf<PickupDropoffPoint>()
    private val dropoffPoints = mutableListOf<PickupDropoffPoint>()
    private var sourcePoint: LatLng? = null
    private var destinationPoint: LatLng? = null
    private var isBottomSheetExpanded = false

    init {
        Log.d("MapDebug", "RideTrackingMapView initialized")
        mapView.onCreate(null)
        mapView.onResume()
        mapView.getMapAsync(this)
        methodChannel.setMethodCallHandler(this)
    }

    override fun getView(): View = mapView

    override fun dispose() {
        methodChannel.setMethodCallHandler(null)
        mapView.onDestroy()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Log.d("MapDebug", "Method called: ${call.method}")
        when (call.method) {
            "initializeMap" -> {
                val mapData = call.arguments as? Map<*, *>
                if (mapData != null) {
                    Log.d("MapDebug", "Received map data: $mapData")
                    processMapData(mapData)
                } else {
                    Log.e("MapDebug", "Received null map data")
                }
                result.success(null)
            }

            "centerOnUserLocation" -> {
                // Center on the provided coordinates initially
                val initialLatLng = LatLng(24.9412, 67.1139)
                googleMap?.animateCamera(CameraUpdateFactory.newLatLngZoom(initialLatLng, 15f))
                result.success(null)
            }

            "zoomIn" -> {
                googleMap?.animateCamera(CameraUpdateFactory.zoomIn())
                result.success(null)
            }

            "zoomOut" -> {
                googleMap?.animateCamera(CameraUpdateFactory.zoomOut())
                result.success(null)
            }

            "fitRouteToScreen" -> {
                zoomToShowAllPoints()
                result.success(null)
            }

            else -> result.notImplemented()
        }
    }

    override fun onMapReady(map: GoogleMap) {
        Log.d("MapDebug", "Map is ready")
        googleMap = map
        applyMapSettings()
       // applyMapStyle()

        // Set default location while waiting for data
        val defaultLocation = LatLng(24.9412, 67.1139)  // Karachi coordinates
        googleMap?.moveCamera(CameraUpdateFactory.newLatLngZoom(defaultLocation, 10f))

        if (sourcePoint != null) {
            drawMapElements()
        }
        updateMapPadding()
    }

    private fun applyMapSettings() {
        googleMap?.uiSettings?.apply {
            isZoomControlsEnabled = false
            isMyLocationButtonEnabled = false
            isCompassEnabled = true
            isMapToolbarEnabled = false
            isRotateGesturesEnabled = true
            isScrollGesturesEnabled = true
            isTiltGesturesEnabled = true
            isZoomGesturesEnabled = true
        }
    }

    private fun applyMapStyle() {
        try {
            val styleResId = context.resources.getIdentifier("map_style", "raw", context.packageName)
            if (styleResId != 0) {
                val style = MapStyleOptions.loadRawResourceStyle(context, styleResId)
                if (!googleMap!!.setMapStyle(style)) {
                    Log.e("RideTrackingMapView", "Map style parsing failed.")
                }
            } else {
                Log.e("RideTrackingMapView", "Map style resource not found.")
            }
        } catch (e: Exception) {
            Log.e("RideTrackingMapView", "Failed to apply map style", e)
        }
    }

    private fun processMapData(mapData: Map<*, *>) {
    try {
        Log.d("MapDebug", "Processing map data")
        
        // Extract source coordinates (handling both list and map formats)
        val source = mapData["source"]
        if (source is Map<*, *>) {
            val lat = source["lat"] as? Double
            val lng = source["lng"] as? Double
            if (lat != null && lng != null) {
                sourcePoint = LatLng(lat, lng)
                Log.d("MapDebug", "Source from map: $lat, $lng")
            }
        } else if (source is List<*>) {
            sourcePoint = LatLng(source[0] as Double, source[1] as Double)
            Log.d("MapDebug", "Source from list: ${source[0]}, ${source[1]}")
        }
        
        // Extract destination coordinates (handling both list and map formats)
        val destination = mapData["destination"]
        if (destination is Map<*, *>) {
            val lat = destination["lat"] as? Double
            val lng = destination["lng"] as? Double
            if (lat != null && lng != null) {
                destinationPoint = LatLng(lat, lng)
                Log.d("MapDebug", "Destination from map: $lat, $lng")
            }
        } else if (destination is List<*>) {
            destinationPoint = LatLng(destination[0] as Double, destination[1] as Double)
            Log.d("MapDebug", "Destination from list: ${destination[0]}, ${destination[1]}")
        }
        
        // Process route coordinates
        routePoints.clear()
        val routeCoords = mapData["routeCoords"] as? List<*> ?: emptyList<Any>()
        for (point in routeCoords) {
            if (point is Map<*, *>) {
                val lat = point["lat"] as? Double
                val lng = point["lng"] as? Double
                if (lat != null && lng != null) {
                    routePoints.add(LatLng(lat, lng))
                    Log.d("MapDebug", "Route point from map: $lat, $lng")
                }
            } else if (point is List<*>) {
                routePoints.add(LatLng(point[0] as Double, point[1] as Double))
                Log.d("MapDebug", "Route point from list: ${point[0]}, ${point[1]}")
            }
        }
        
        // Process passenger data
        pickupPoints.clear()
        dropoffPoints.clear()
        val passengers = mapData["passengers"] as? List<*> ?: emptyList<Any>()
        Log.d("MapDebug", "Processing ${passengers.size} passengers")
        
        for (passenger in passengers) {
            val passengerMap = passenger as? Map<*, *> ?: continue
            val name = passengerMap["name"] as? String ?: "Unknown Passenger"
            val sameSource = passengerMap["sameSource"] as? Boolean ?: false
            
            if (!sameSource) {
                // Process pickup coordinates
                val pickupCoords = passengerMap["pickupCoords"]
                val pickupLat = passengerMap["pickupLat"]
                val pickupLng = passengerMap["pickupLng"]
                
                if (pickupCoords is List<*>) {
                    pickupPoints.add(PickupDropoffPoint(LatLng(pickupCoords[0] as Double, pickupCoords[1] as Double), name, true))
                    Log.d("MapDebug", "Pickup from list: ${pickupCoords[0]}, ${pickupCoords[1]} - Passenger: $name")
                } else if (pickupLat != null && pickupLng != null) {
                    pickupPoints.add(PickupDropoffPoint(LatLng(pickupLat as Double, pickupLng as Double), name, true))
                    Log.d("MapDebug", "Pickup from lat/lng: $pickupLat, $pickupLng - Passenger: $name")
                }
            }
            
            // Process dropoff coordinates
            val dropoffCoords = passengerMap["dropoffCoords"]
            val dropoffLat = passengerMap["dropoffLat"]
            val dropoffLng = passengerMap["dropoffLng"]
            
            if (dropoffCoords is List<*>) {
                dropoffPoints.add(PickupDropoffPoint(LatLng(dropoffCoords[0] as Double, dropoffCoords[1] as Double), name, false))
                Log.d("MapDebug", "Dropoff from list: ${dropoffCoords[0]}, ${dropoffCoords[1]} - Passenger: $name")
            } else if (dropoffLat != null && dropoffLng != null) {
                dropoffPoints.add(PickupDropoffPoint(LatLng(dropoffLat as Double, dropoffLng as Double), name, false))
                Log.d("MapDebug", "Dropoff from lat/lng: $dropoffLat, $dropoffLng - Passenger: $name")
            }
        }
        
        Log.d("MapDebug", "Processed map data: Source: $sourcePoint, Destination: $destinationPoint, " +
                "Route points: ${routePoints.size}, Pickup points: ${pickupPoints.size}, " +
                "Dropoff points: ${dropoffPoints.size}")
        
        mapView.post {
            googleMap?.let { drawMapElements() }
        }
    } catch (e: Exception) {
        Log.e("MapDebug", "Error processing map data: ${e.message}", e)
    }
}


    private fun drawMapElements() {
        Log.d("MapDebug", "Drawing map elements")
        googleMap?.apply {
            clear()
            
            // Draw route polyline if we have points
            if (routePoints.isNotEmpty()) {
                addPolyline(PolylineOptions()
                    .addAll(routePoints)
                    .width(12f)
                    .color(0xFFEC8825.toInt())
                    .geodesic(true)
                )
                Log.d("MapDebug", "Drew polyline with ${routePoints.size} points")
            }

            // Add markers
            addMarkerAt(sourcePoint, "Source", BitmapDescriptorFactory.HUE_GREEN)
            addMarkerAt(destinationPoint, "Destination", BitmapDescriptorFactory.HUE_RED)
            
            pickupPoints.forEach { 
                addMarkerAt(it.latLng, "Pickup ${it.name}", BitmapDescriptorFactory.HUE_YELLOW)
            }
            
            dropoffPoints.forEach { 
                addMarkerAt(it.latLng, "Dropoff ${it.name}", BitmapDescriptorFactory.HUE_BLUE)
            }

            // Zoom to show all points
            mapView.post {
                zoomToShowAllPoints()
            }
        }
    }

    private fun addMarkerAt(position: LatLng?, title: String, hue: Float) {
        position?.let {
            val marker = googleMap?.addMarker(
                MarkerOptions()
                    .position(it)
                    .title(title)
                    .icon(BitmapDescriptorFactory.defaultMarker(hue))
            )
                    marker?.let { m ->
            googleMap?.setOnMapLoadedCallback {
                m.showInfoWindow() // Show the info window immediately after adding the marker
            }
        }
            if (marker != null) {
                Log.d("MapDebug", "Added $title marker at ${it.latitude}, ${it.longitude}")
            }
        }
    }

    private fun zoomToShowAllPoints() {
        val allPoints = mutableListOf<LatLng>()
        sourcePoint?.let { allPoints.add(it) }
        destinationPoint?.let { allPoints.add(it) }
        pickupPoints.forEach { allPoints.add(it.latLng) }
        dropoffPoints.forEach { allPoints.add(it.latLng) }

        Log.d("MapDebug", "Zooming to show ${allPoints.size} points")
        
        if (allPoints.isEmpty()) {
            Log.w("MapDebug", "No points to zoom to")
            return
        }

        try {
            val bounds = LatLngBounds.builder().apply {
                allPoints.forEach { include(it) }
            }.build()

            val padding = 150
            mapView.post {
                try {
                    googleMap?.animateCamera(CameraUpdateFactory.newLatLngBounds(bounds, padding))
                    Log.d("MapDebug", "Camera updated with bounds")
                } catch (e: Exception) {
                    Log.e("MapDebug", "Failed to animate camera with bounds", e)
                    sourcePoint?.let {
                        googleMap?.animateCamera(CameraUpdateFactory.newLatLngZoom(it, 13f))
                        Log.d("MapDebug", "Fallback: Zoomed to source point")
                    }
                }
            }
        } catch (e: Exception) {
            Log.e("MapDebug", "Failed to build bounds", e)
            sourcePoint?.let {
                googleMap?.animateCamera(CameraUpdateFactory.newLatLngZoom(it, 13f))
            }
        }
    }

    private fun updateMapPadding() {
        val bottomPadding = if (isBottomSheetExpanded) {
            mapView.resources.displayMetrics.heightPixels * 0.8f
        } else {
            250 * mapView.resources.displayMetrics.density
        }
        googleMap?.setPadding(0, 0, 0, bottomPadding.toInt())
    }

    // Lifecycle handling
    fun onResume() = mapView.onResume()
    fun onPause() = mapView.onPause()
    fun onDestroy() = mapView.onDestroy()
    fun onLowMemory() = mapView.onLowMemory()
}