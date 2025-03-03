package com.example.vroo_test

import android.content.Context
import android.graphics.Color
import android.view.View
import com.google.android.gms.maps.*
import com.google.android.gms.maps.model.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class NativeMapView(
    context: Context,
    messenger: io.flutter.plugin.common.BinaryMessenger,
    viewId: Int
) : PlatformView, OnMapReadyCallback, MethodChannel.MethodCallHandler {

    private val mapView: MapView = MapView(context)
    private lateinit var googleMap: GoogleMap
    private val methodChannel: MethodChannel

    // Store route data at the class level
    private var routeData: List<Map<String, Any>> = emptyList()

    // Store all polylines
    private val allPolylines = mutableListOf<Polyline>()

    // Track currently selected polyline
    private var selectedPolyline: Polyline? = null

    // Define route colors
    private val routeColors = listOf(
        Color.parseColor("#8B008B"), // Dark Magenta
        Color.parseColor("#008B8B"), // Dark Cyan
        Color.parseColor("#B8860B"), // Dark Goldenrod
        Color.parseColor("#8B0000"), // Dark Red
        Color.parseColor("#00008B"), // Dark Blue
        Color.parseColor("#006400")  // Dark Green
    )

    init {
        mapView.onCreate(null)
        mapView.onResume()
        mapView.getMapAsync(this)

        methodChannel = MethodChannel(messenger, "native_google_map_$viewId")
        methodChannel.setMethodCallHandler(this)
    }

    override fun getView(): View {
        return mapView
    }

    override fun dispose() {}

    override fun onMapReady(map: GoogleMap) {
        googleMap = map
        googleMap.uiSettings.isZoomControlsEnabled = true
        googleMap.uiSettings.isMyLocationButtonEnabled = true

        // Set initial camera position
        val initialLatLng = LatLng(24.941875, 67.114297)
        googleMap.moveCamera(CameraUpdateFactory.newLatLngZoom(initialLatLng, 15f))
        println("Google Map is ready!")

        setupPolylineClickListener()
    }

    private fun setupPolylineClickListener() {
        googleMap.setOnPolylineClickListener { polyline ->
            val selectedRoute = polyline.tag as? Map<*, *>

            if (selectedRoute != null) {
                val convertedRoute = selectedRoute.mapKeys { it.key.toString() }
                methodChannel.invokeMethod("routeSelected", convertedRoute)

                // Reset all polyline colors (make all unselected)
                allPolylines.forEachIndexed { index, line ->
                    line.color = routeColors[index % routeColors.size]
                }

                // Highlight the newly selected polyline
                polyline.color = Color.parseColor("#EC8825")
                selectedPolyline = polyline
            }
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "setRouteData") {
            val newRouteData = call.argument<List<Map<String, Any>>>("routeData")
            if (newRouteData != null) {
                routeData = newRouteData
                drawRoutes(routeData)
            }
            result.success(null)
        } else {
            result.notImplemented()
        }
    }

    private fun drawRoutes(routeData: List<Map<String, Any>>) {
        println("Received ${routeData.size} routes to draw")

        googleMap.clear()
        allPolylines.clear()  // Clear polyline tracking list

        val builder = LatLngBounds.Builder()

        routeData.forEachIndexed { index, route ->
            val coords = route["coords"] as List<List<Double>>
            val color = routeColors[index % routeColors.size]

            val polylineOptions = PolylineOptions()
                .color(color)
                .width(8f)
                .geodesic(true)
                .clickable(true)

            coords.forEach { point ->
                val latLng = LatLng(point[0], point[1])
                polylineOptions.add(latLng)
                builder.include(latLng)
            }

            val polyline = googleMap.addPolyline(polylineOptions)
            polyline.tag = route  // Store the route data in the polyline
            allPolylines.add(polyline)  // Track this polyline
            println("Polyline added with ${coords.size} points, color: $color")
        }

        val bounds = builder.build()

        mapView.post {
            try {
                googleMap.animateCamera(CameraUpdateFactory.newLatLngBounds(bounds, 100))
            } catch (e: Exception) {
                println("Error adjusting camera: ${e.message}")
            }
        }
    }
}
