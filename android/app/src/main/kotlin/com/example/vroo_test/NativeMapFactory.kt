package com.example.vroo_test

import android.content.Context
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.common.MethodChannel

class NativeMapFactory(private val methodChannel: MethodChannel) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        return NativeMapView(context, methodChannel)
    }
}
