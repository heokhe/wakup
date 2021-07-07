import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wakup/core/ringtone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:wakup/themes.dart' show notificationColor;

const int _FLAG_INSISTENT = 0x00000004;
const int _FLAG_NO_CLEAR = 0x00000020;
const int _FLAG_ONGOING_EVENT = 0x00000002;

void scheduleNotification(DateTime dateTime, bool useRingtone) async {
  final zonedDateTime = tz.TZDateTime.from(dateTime, tz.local);
  final sound =
      useRingtone ? await getDefaultRingtone() : await getDefaultAlarmAlert();
  final channelId =
      !useRingtone || sound == null ? 'default_channel' : 'ringtone_channel';
  final channelName =
      !useRingtone || sound == null ? 'Alarms' : 'Alarms with ringtone sounds';

  await FlutterLocalNotificationsPlugin().zonedSchedule(
    0,
    'Wake up!',
    'Enough sleep',
    zonedDateTime,
    NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        'Alarm notifications',
        fullScreenIntent: true,
        visibility: NotificationVisibility.public,
        ongoing: true,
        sound: sound,
        autoCancel: false,
        category: 'alarm',
        channelShowBadge: true,
        priority: Priority.max,
        importance: Importance.max,
        color: notificationColor,
        additionalFlags: Int32List.fromList([
          _FLAG_INSISTENT,
          _FLAG_NO_CLEAR,
          _FLAG_ONGOING_EVENT,
        ]),
      ),
    ),
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    androidAllowWhileIdle: true,
  );
}
