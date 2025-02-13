package com.example.vroo_test

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "NativeMapViewChannel")

        flutterEngine.platformViewsController
            .registry
            .registerViewFactory("NativeMapView", NativeMapFactory(methodChannel))
    }
}

