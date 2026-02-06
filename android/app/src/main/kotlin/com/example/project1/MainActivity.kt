package com.example.project1

import android.view.WindowManager.LayoutParams
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Baris ini yang mencegah screenshot dan screen record
        window.addFlags(LayoutParams.FLAG_SECURE)
    }
}