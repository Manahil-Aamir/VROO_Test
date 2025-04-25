package com.example.vroo_test

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import android.os.PowerManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    private val CHANNEL = "sos.tracker/wakelock"
    private var wakeLock: PowerManager.WakeLock? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        // Register Native Google Map View
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory(
                "native_google_map",
                NativeMapFactory(flutterEngine.dartExecutor.binaryMessenger)
            )
            
        // Register Ride Tracking Map View
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory(
                "ride_tracking_map",
                RideTrackingMapFactory(flutterEngine.dartExecutor.binaryMessenger)
            )

        // Set up MethodChannel for WakeLock
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "enableWakeLock" -> {
                    enableWakeLock()
                    result.success("WakeLock enabled")
                }
                "disableWakeLock" -> {
                    disableWakeLock()
                    result.success("WakeLock disabled")
                }
                else -> result.notImplemented()
            }
        }

        // Create notification channel
        createNotificationChannel()
    }

    private fun enableWakeLock() {
        val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = powerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "SOS:WakeLock")
        wakeLock?.acquire()
    }

    private fun disableWakeLock() {
        wakeLock?.release()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                "sos_tracking",
                "SOS Tracking",
                NotificationManager.IMPORTANCE_LOW
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager?.createNotificationChannel(channel)
        }
    }
}
