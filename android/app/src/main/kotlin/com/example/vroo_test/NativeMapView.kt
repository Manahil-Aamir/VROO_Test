package com.example.vroo_test

import android.content.Context
import android.view.View
import com.google.android.gms.maps.*
import com.google.android.gms.maps.model.LatLng
import io.flutter.plugin.platform.PlatformView

class NativeMapView(context: Context) : PlatformView, OnMapReadyCallback {

    private val mapView: MapView = MapView(context)

    init {
        mapView.onCreate(null)
        mapView.onResume()
        mapView.getMapAsync(this)
    }

    override fun getView(): View {
        return mapView
    }

    override fun dispose() {}

    override fun onMapReady(googleMap: GoogleMap) {
        googleMap.uiSettings.isZoomControlsEnabled = true
        googleMap.uiSettings.isMyLocationButtonEnabled = true
        googleMap.moveCamera(CameraUpdateFactory.newLatLngZoom(LatLng(24.941875, 67.114297), 15f))
    }
}
