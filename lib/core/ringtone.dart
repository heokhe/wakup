import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const _channel = MethodChannel('io.hkh12.wakup/ringtone');

Future<String?> _getDefaultRingtoneUri() async {
  try {
    return await _channel.invokeMethod<String>('getDefaultRingtoneUri');
  } on PlatformException catch (e) {
    print('failed to get the default ringtone: ${e.message}');
  }
    return null;
}

/// returns the system's default ringtone, and null if there are errors. 
Future<UriAndroidNotificationSound?> getDefaultRingtone() async {
  return await _getDefaultRingtoneUri()
      .then((uri) => uri == null ? null : UriAndroidNotificationSound(uri));
}
