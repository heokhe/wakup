package io.hkh12.wakup

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.provider.Settings

class MainActivity: FlutterActivity() {
  private val CHANNEL = "io.hkh12.wakup/ringtone"

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      call, result ->
      if (call.method == "getDefaultRingtoneUri") {
        result.success(Settings.System.DEFAULT_RINGTONE_URI.toString())
      } else {
        result.notImplemented()
      }
    }
  }
}
