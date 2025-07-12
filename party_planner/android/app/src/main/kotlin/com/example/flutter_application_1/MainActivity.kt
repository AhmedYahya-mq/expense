package com.example.flutter_application_1

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.Build

class MainActivity: FlutterActivity() {
    private val CHANNEL = "device_info" // يجب أن يتطابق مع القناة في Flutter

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getAndroidVersion") {
                val androidVersion = getAndroidVersion()
                result.success(androidVersion)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getAndroidVersion(): String {
        return Build.VERSION.RELEASE 
    }
}