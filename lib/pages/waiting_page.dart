import 'dart:typed_data';

import 'package:flutter/material.dart' hide Page;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:wakup/core/ringtone.dart';
import 'package:wakup/pages/running_page.dart';
import 'package:wakup/themes.dart';
import 'package:wakup/widgets/timepicker.dart';

const int _FLAG_INSISTENT = 0x00000004;
const int _FLAG_NO_CLEAR = 0x00000020;
const int _FLAG_ONGOING_EVENT = 0x00000002;

void _scheduleNotification(DateTime dateTime, bool useRingtone) async {
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
        color: primaryColor,
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

class WaitingPage extends StatefulWidget {
  const WaitingPage({Key? key}) : super(key: key);

  @override
  _WaitingPageState createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage> {
  TimeOfDay _timeOfDay = TimeOfDay.now();
  bool _useRingtone = true;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      bool? prefsUseRingtone = prefs.getBool('use_ringtone');
      if (prefsUseRingtone != null) {
        setState(() {
          _useRingtone = prefsUseRingtone;
        });
      }
    });
  }

  void _setTheAlarm(BuildContext context) async {
    final now = DateTime.now();
    var alarmTime = DateTime(
      now.year,
      now.month,
      now.day,
      _timeOfDay.hour,
      _timeOfDay.minute,
      0,
    );
    if (alarmTime.isBefore(now) || alarmTime.isAtSameMomentAs(now)) {
      alarmTime = alarmTime.add(Duration(days: 1));
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('alarm_time', alarmTime.millisecondsSinceEpoch);

    _scheduleNotification(alarmTime, _useRingtone);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => RunningPage(finishTime: alarmTime),
      ),
    );
  }

  void _setUseRingtone(bool value) async {
    setState(() {
      _useRingtone = value;
    });
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('use_ringtone', value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('wakup'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _setTheAlarm(context),
        label: const Text('SET THE ALARM'),
        icon: Icon(Icons.add_alarm_outlined),
      ),
      body: ListView(
        children: [
          TimePicker(
            initialTime: _timeOfDay,
            onChange: (td) {
              setState(() {
                _timeOfDay = td;
              });
            },
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Settings',
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  ?.copyWith(color: Colors.white70),
            ),
          ),
          SwitchListTile(
            isThreeLine: true,
            secondary: Icon(Icons.ring_volume_outlined),
            title: Text('Use ringtone sound'),
            subtitle:
                Text('Tricks you into thinking you have a call from someone'),
            value: _useRingtone,
            onChanged: _setUseRingtone,
          ),
        ],
      ),
    );
  }
}
