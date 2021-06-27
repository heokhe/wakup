import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:wakup/pages/testing_page.dart';
import 'package:rxdart/subjects.dart';
import 'pages/waiting_page.dart';
import 'pages/running_page.dart';
import 'themes.dart';

final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();

enum AlarmState { running, waiting, testing }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: baseTheme.scaffoldBackgroundColor,
      systemNavigationBarDividerColor: baseTheme.scaffoldBackgroundColor,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  tzdata.initializeTimeZones();
  final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(currentTimeZone));

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final int? alarmTimeMs = prefs.getInt('alarm_time');
  final DateTime? alarmTime = alarmTimeMs != null
      ? DateTime.fromMillisecondsSinceEpoch(alarmTimeMs)
      : null;
  print('alarm time: $alarmTime');
  AlarmState initialState = alarmTime == null
      ? AlarmState.waiting
      : alarmTime.isBefore(DateTime.now())
          ? AlarmState.testing
          : AlarmState.running;
  print('initial state: $initialState');

  await FlutterLocalNotificationsPlugin().initialize(
    InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
    onSelectNotification: (payload) async {
      print('payload: $payload (${payload?.length})');
      print('he2');
      selectNotificationSubject.add(payload);
    },
  );

  runApp(_App(initialState: initialState, alarmTime: alarmTime));
}

class _App extends StatelessWidget {
  final AlarmState initialState;
  final DateTime? alarmTime;
  const _App({required this.initialState, required this.alarmTime});

  Widget build(BuildContext context) {
    final initialRoute = initialState == AlarmState.running
        ? '/running'
        : initialState == AlarmState.testing
            ? '/testing'
            : '/';
    return MaterialApp(
      title: 'wakup',
      theme: baseTheme,
      initialRoute: initialRoute,
      routes: {
        '/': (context) => WaitingPage(),
        '/running': (context) =>
            RunningPage(finishTime: alarmTime ?? DateTime.now()),
        '/testing': (context) => TestPage()
      },
    );
  }
}
