package com.example.vroo_test

import android.content.Context
import android.view.View
import com.google.android.gms.maps.*
import com.google.android.gms.maps.model.*
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray

class NativeMapView(context: Context, private val methodChannel: MethodChannel) : PlatformView, OnMapReadyCallback {

    private val mapView: MapView = MapView(context)
    private var googleMap: GoogleMap? = null
    private var selectedPolyline: Polyline? = null
    private val markers = mutableListOf<Marker>()

    // Different colors for routes
    private val routeColors = listOf(
        0xFFFFC0CB.toInt(), // Pink
        0xFFFFA500.toInt(), // Orange
        0xFF32CD32.toInt(), // Lime Green
        0xFF800080.toInt(), // Purple
        0xFFA52A2A.toInt()  // Brown
    )

    init {
        mapView.onCreate(null)
        mapView.onResume()
        mapView.getMapAsync(this)
    }

    override fun getView(): View = mapView

    override fun dispose() {}

    override fun onMapReady(map: GoogleMap) {
        googleMap = map
        googleMap?.uiSettings?.isZoomControlsEnabled = true
        googleMap?.uiSettings?.isMyLocationButtonEnabled = true

        // Default camera position
        googleMap?.moveCamera(CameraUpdateFactory.newLatLngZoom(LatLng(24.941875, 67.114297), 12f))

        // Listen for route selection from Flutter
        methodChannel.setMethodCallHandler { call, result ->
            if (call.method == "drawRoutes") {
                val routeData = call.arguments as String
                drawRoutes(routeData)
                result.success(null)
            }
        }
    }

   private fun drawRoutes(routeData: String) {
    // Clear previous overlays.
    googleMap?.clear()
    markers.clear()

    // Parse the routes data.
    val routesArray = JSONArray(routeData)
    // Create a bounds builder to calculate the area that includes all points.
    val boundsBuilder = LatLngBounds.builder()

    for (i in 0 until routesArray.length()) {
        val routeObj = routesArray.getJSONObject(i)
        val coordsArray = routeObj.getJSONArray("coords")

        // Choose a color for the route.
        val routeColor = routeColors[i % routeColors.size]

        // Build the polyline options.
        val polylineOptions = PolylineOptions()
            .color(routeColor)
            .width(8f)
            .clickable(true)

        // Add each coordinate to the polyline and the bounds.
        for (j in 0 until coordsArray.length()) {
            val latLngArray = coordsArray.getJSONArray(j)
            val lat = latLngArray.getDouble(0)
            val lng = latLngArray.getDouble(1)
            val latLng = LatLng(lat, lng)
            polylineOptions.add(latLng)
            boundsBuilder.include(latLng)
        }

        // Draw the polyline on the map.
        googleMap?.addPolyline(polylineOptions)

        // Add markers for the start and end points.
        if (coordsArray.length() > 0) {
            val firstCoord = coordsArray.getJSONArray(0)
            val startLatLng = LatLng(firstCoord.getDouble(0), firstCoord.getDouble(1))
            val lastCoord = coordsArray.getJSONArray(coordsArray.length() - 1)
            val endLatLng = LatLng(lastCoord.getDouble(0), lastCoord.getDouble(1))

            val startMarker = googleMap?.addMarker(
                MarkerOptions()
                    .position(startLatLng)
                    .title("Start Point")
                    .icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_GREEN))
            )
            val endMarker = googleMap?.addMarker(
                MarkerOptions()
                    .position(endLatLng)
                    .title("End Point")
                    .icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_RED))
            )

            startMarker?.let { markers.add(it) }
            endMarker?.let { markers.add(it) }
        }

        // Set a click listener for polyline selection.
        googleMap?.setOnPolylineClickListener { clickedPolyline ->
            // Change the clicked polyline's color to indicate selection.
            clickedPolyline.color = 0xFF0000FF.toInt() // Blue color for selection.
            methodChannel.invokeMethod("onRouteSelected", routeObj.toString())
        }
    }

    // Adjust the camera to show all routes.
    try {
        print("hello map");
        val bounds = boundsBuilder.build()
        googleMap?.animateCamera(CameraUpdateFactory.newLatLngBounds(bounds, 100))
    } catch (e: Exception) {
        e.printStackTrace()
    }
}

}
