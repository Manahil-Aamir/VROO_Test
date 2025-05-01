package com.example.vroo_test

import android.content.Context
import android.graphics.*
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.View
import androidx.core.content.ContextCompat
import com.google.android.gms.maps.*
import com.google.android.gms.maps.model.*
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import java.util.concurrent.CopyOnWriteArrayList

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

    private val routePoints = CopyOnWriteArrayList<LatLng>()
    private val pickupPoints = mutableListOf<PickupDropoffPoint>()
    private val dropoffPoints = mutableListOf<PickupDropoffPoint>()
    private var sourcePoint: LatLng? = null
    private var destinationPoint: LatLng? = null
    private var isBottomSheetExpanded = false
    
    // Current vehicle position and marker
    private var vehicleMarker: Marker? = null
    private var vehiclePosition: LatLng? = null
    private var vehicleBearing: Float = 0f
    private var routePolyline: Polyline? = null
    private var completedRoutePolyline: Polyline? = null
    private val handler = Handler(Looper.getMainLooper())
    
    // Car bitmap for marker
    private var carBitmap: BitmapDescriptor? = null
    
    // Flag to prevent auto-zooming on first vehicle appearance
    private var isFirstVehicleUpdate = true
    private var shouldFocusOnVehicle = false

    init {
        Log.d("MapDebug", "RideTrackingMapView initialized")
        mapView.onCreate(null)
        mapView.onResume()
        mapView.getMapAsync(this)
        methodChannel.setMethodCallHandler(this)
        initCarBitmap()
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

            "updateVehiclePosition" -> {
                val positionData = call.arguments as? Map<*, *>
                if (positionData != null) {
                    val lat = positionData["lat"] as? Double ?: return result.error("INVALID_ARGS", "Missing latitude", null)
                    val lng = positionData["lng"] as? Double ?: return result.error("INVALID_ARGS", "Missing longitude", null)
                    val heading = (positionData["heading"] as? Double ?: 0.0).toFloat()
                    
                    updateVehiclePosition(LatLng(lat, lng), heading)
                    result.success(null)
                } else {
                    result.error("INVALID_ARGS", "Invalid position data", null)
                }
            }

            "addRoutePoint" -> {
                val pointData = call.arguments as? Map<*, *>
                if (pointData != null) {
                    val lat = pointData["lat"] as? Double ?: return result.error("INVALID_ARGS", "Missing latitude", null)
                    val lng = pointData["lng"] as? Double ?: return result.error("INVALID_ARGS", "Missing longitude", null)
                    
                    val newPoint = LatLng(lat, lng)
                    addRoutePoint(newPoint)
                    result.success(null)
                } else {
                    result.error("INVALID_ARGS", "Invalid point data", null)
                }
            }

            "centerOnVehicle" -> {
                // Set flag to ensure we maintain focus on the vehicle
                shouldFocusOnVehicle = true
                
                vehiclePosition?.let {
                    // Use a zoom level that clearly shows the vehicle (16f is better than 14f for this)
                    googleMap?.animateCamera(CameraUpdateFactory.newLatLngZoom(it, 16f))
                    Log.d("MapDebug", "Explicitly centering on vehicle per user request")
                }
                result.success(null)
            }

            "centerOnUserLocation" -> {
                // Make sure we stop following the vehicle
                shouldFocusOnVehicle = false
                // Center on the provided coordinates initially
                val initialLatLng = LatLng(24.9412, 67.1139)
                googleMap?.animateCamera(CameraUpdateFactory.newLatLngZoom(initialLatLng, 15f))
                Log.d("MapDebug", "Centering on user location, no longer following vehicle")
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
                shouldFocusOnVehicle = false
                zoomToShowAllPoints()
                result.success(null)
            }

            // Add this method within the onMethodCall function in your RideTrackingMapView.kt file
// Inside the when (call.method) block, add this case:

"updateRouteCoordinates" -> {
    val data = call.arguments as? Map<*, *>
    if (data != null) {
        val viewId = data["viewId"] as? Int
        val routeCoords = data["routeCoords"] as? List<*>
        
        if (routeCoords != null) {
            Log.d("MapDebug", "Updating route coordinates with ${routeCoords.size} points")
            
            // Clear existing route points and add new ones
            routePoints.clear()
            
            for (point in routeCoords) {
                if (point is List<*> && point.size >= 2) {
                    val lat = point[0] as? Double
                    val lng = point[1] as? Double
                    
                    if (lat != null && lng != null) {
                        routePoints.add(LatLng(lat, lng))
                    }
                }
            }
            
            // Update the route polylines with new points
            updateRoutePolylines()
            
            // If vehicle position is set, make sure it's at the latest point
            if (routePoints.isNotEmpty() && vehiclePosition != null) {
                val latestPoint = routePoints.last()
                
                // Calculate bearing if there are at least 2 points
                val bearing = if (routePoints.size > 1) {
                    val secondLastPoint = routePoints[routePoints.size - 2]
                    calculateBearing(secondLastPoint, latestPoint)
                } else {
                    vehicleBearing // Keep current bearing if only one point
                }
                
                // Update vehicle position
                updateVehiclePosition(latestPoint, bearing)
            }
            
            result.success(null)
        } else {
            result.error("INVALID_ARGS", "Missing or invalid route coordinates", null)
        }
    } else {
        result.error("INVALID_ARGS", "Invalid arguments for updating route coordinates", null)
    }
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
    
    private fun initCarBitmap() {
        try {
            // You can use a custom car icon drawable from your resources
            val drawable = ContextCompat.getDrawable(context, R.drawable.car) // Replace with an existing drawable
            
            if (drawable != null) {
                val bitmap = Bitmap.createBitmap(drawable.intrinsicWidth, 
                                              drawable.intrinsicHeight, 
                                              Bitmap.Config.ARGB_8888)
                val canvas = Canvas(bitmap)
                drawable.setBounds(0, 0, canvas.width, canvas.height)
                drawable.draw(canvas)
                carBitmap = BitmapDescriptorFactory.fromBitmap(bitmap)
            } else {
                // Fallback to default marker
                carBitmap = BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_AZURE)
            }
        } catch (e: Exception) {
            Log.e("MapDebug", "Error creating car bitmap", e)
            carBitmap = BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_AZURE)
        }
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
    
    private fun updateVehiclePosition(position: LatLng, heading: Float) {
        vehiclePosition = position
        vehicleBearing = heading
        
        if (vehicleMarker == null) {
            // Create the marker if it doesn't exist
            val markerOptions = MarkerOptions()
                .position(position)
                .flat(true)
                .anchor(0.5f, 0.5f)
                .rotation(heading)
                .icon(carBitmap ?: BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_AZURE))
                
            handler.post {
                vehicleMarker = googleMap?.addMarker(markerOptions)
                Log.d("MapDebug", "Vehicle marker created at ${position.latitude}, ${position.longitude}")
                
                // IMPORTANT: We need to focus on the vehicle when it first appears
                // Changed logic to ensure we focus on the vehicle
                if (isFirstVehicleUpdate) {
                    isFirstVehicleUpdate = false
                    // Instead of calling zoomToShowAllPoints, force focus on vehicle
                    shouldFocusOnVehicle = true
                    googleMap?.animateCamera(CameraUpdateFactory.newLatLngZoom(position, 16f))
                    Log.d("MapDebug", "First vehicle update - focusing camera on vehicle")
                } else if (shouldFocusOnVehicle) {
                    // Continue focusing on vehicle in subsequent updates
                    googleMap?.animateCamera(CameraUpdateFactory.newLatLngZoom(position, 16f))
                    Log.d("MapDebug", "Focusing camera on vehicle")
                }
            }
        } else {
            // Animate the marker movement
            handler.post {
                animateMarkerToPosition(position, heading)
                
                // Always focus on vehicle if shouldFocusOnVehicle is true
                if (shouldFocusOnVehicle) {
                    // Ensure we maintain focus on the vehicle
                    googleMap?.animateCamera(CameraUpdateFactory.newLatLng(position))
                    Log.d("MapDebug", "Keeping camera focused on moving vehicle")
                }
            }
        }
        
        // Add point to route and update polylines
        addRoutePoint(position)
    }
    
    private fun animateMarkerToPosition(targetPosition: LatLng, bearing: Float) {
        val marker = vehicleMarker ?: return
        val startPosition = marker.position
        
        // Use MarkerAnimation or ValueAnimator for smoother transition
        marker.rotation = bearing
        marker.position = targetPosition
        
        Log.d("MapDebug", "Vehicle moved to ${targetPosition.latitude}, ${targetPosition.longitude}")
    }
    
    private fun addRoutePoint(point: LatLng) {
        routePoints.add(point)
        
        // Update the polylines with new point
        updateRoutePolylines()
        
        Log.d("MapDebug", "Added route point: ${point.latitude}, ${point.longitude}, total points: ${routePoints.size}")
    }
    
    private fun updateRoutePolylines() {
        handler.post {
            // Clear existing polylines
            routePolyline?.remove()
            
            if (routePoints.size > 1) {
                // Draw updated route polyline
                routePolyline = googleMap?.addPolyline(PolylineOptions()
                    .addAll(routePoints)
                    .width(12f)
                    .color(0xFFEC8825.toInt()) // Orange color
                    .geodesic(true))
                
                Log.d("MapDebug", "Updated route polyline with ${routePoints.size} points")
            }
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
                    //Log.d("MapDebug", "Route point from map: $lat, $lng")
                }
            } else if (point is List<*>) {
                routePoints.add(LatLng(point[0] as Double, point[1] as Double))
                Log.d("MapDebug", "Route point from list: ${point[0]}, ${point[1]}")
            }
        }
        
        // ADDED: Position vehicle at first route point if route is not empty
        if (routePoints.isNotEmpty()) {
            val initialPosition = routePoints.first()
            vehiclePosition = initialPosition
            // Calculate initial bearing if there are at least 2 points
            vehicleBearing = if (routePoints.size > 1) {
                calculateBearing(routePoints[0], routePoints[1])
            } else {
                0f // Default bearing if only one point
            }
            Log.d("MapDebug", "Positioned vehicle at first route point: ${initialPosition.latitude}, ${initialPosition.longitude}")
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
            
            if(sameSource){
                if (dropoffCoords is List<*>) {
                dropoffPoints.add(PickupDropoffPoint(LatLng(dropoffCoords[0] as Double, dropoffCoords[1] as Double), name, false))
                Log.d("MapDebug", "Dropoff from list: ${dropoffCoords[0]}, ${dropoffCoords[1]} - Passenger: $name")
                } else if (dropoffLat != null && dropoffLng != null) {
                    dropoffPoints.add(PickupDropoffPoint(LatLng(dropoffLat as Double, dropoffLng as Double), name, false))
                    Log.d("MapDebug", "Dropoff from lat/lng: $dropoffLat, $dropoffLng - Passenger: $name")
                }
            }
        }
        
        Log.d("MapDebug", "Processed map data: Source: $sourcePoint, Destination: $destinationPoint, " +
                "Route points: ${routePoints.size}, Pickup points: ${pickupPoints.size}, " +
                "Dropoff points: ${dropoffPoints.size}")
        
        // Reset tracking flags when new map data is loaded
        isFirstVehicleUpdate = true
        shouldFocusOnVehicle = false
        
        mapView.post {
            googleMap?.let { drawMapElements() }
        }
    } catch (e: Exception) {
        Log.e("MapDebug", "Error processing map data: ${e.message}", e)
    }
}

private fun calculateBearing(start: LatLng, end: LatLng): Float {
    val startLat = Math.toRadians(start.latitude)
    val startLng = Math.toRadians(start.longitude)
    val endLat = Math.toRadians(end.latitude)
    val endLng = Math.toRadians(end.longitude)
    
    val dLng = endLng - startLng
    
    val y = Math.sin(dLng) * Math.cos(endLat)
    val x = Math.cos(startLat) * Math.sin(endLat) - 
            Math.sin(startLat) * Math.cos(endLat) * Math.cos(dLng)
    
    var bearing = Math.toDegrees(Math.atan2(y, x))
    
    // Normalize to 0-360
    bearing = (bearing + 360) % 360
    
    return bearing.toFloat()
}

    private fun drawMapElements() {
        Log.d("MapDebug", "Drawing map elements")
        googleMap?.apply {
            clear()
            
            // Draw route polyline if we have points
            if (routePoints.isNotEmpty()) {
                routePolyline = addPolyline(PolylineOptions()
                    .addAll(routePoints)
                    .width(12f)
                    .color(0xFFEC8825.toInt()) // Orange color
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
            
            // Initialize vehicle marker at the starting point if available
            if (vehiclePosition != null) {
                // Recreate vehicle marker after clearing the map
                val markerOptions = MarkerOptions()
                    .position(vehiclePosition!!)
                    .flat(true)
                    .anchor(0.5f, 0.5f)
                    .rotation(vehicleBearing)
                    .icon(carBitmap ?: BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_AZURE))
                    
                vehicleMarker = googleMap?.addMarker(markerOptions)
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
        vehiclePosition?.let { allPoints.add(it) }

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
                    
                    // If we want to enforce a maximum zoom level when showing all points
                    googleMap?.setOnCameraIdleListener {
                        val currentZoom = googleMap?.cameraPosition?.zoom ?: 0f
                        if (currentZoom > 15f) {
                            // If zoomed in too much, zoom out to a more reasonable level
                            googleMap?.animateCamera(CameraUpdateFactory.zoomTo(15f))
                        }
                        // Reset the listener to avoid continuous checks
                        googleMap?.setOnCameraIdleListener(null)
                    }
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