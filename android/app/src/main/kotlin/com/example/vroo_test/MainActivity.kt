package com.example.vroo_test

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.platform.PlatformViewRegistry
import io.flutter.embedding.engine.plugins.FlutterPlugin

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.platformViewsController.registry.registerViewFactory(
            "native_google_map",
            NativeMapFactory(flutterEngine.dartExecutor.binaryMessenger)
        )
    }
}
