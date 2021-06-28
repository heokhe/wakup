import 'package:duration/duration.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakup/pages/waiting_page.dart';
import 'package:wakup/widgets/countdown.dart';
import 'package:wakup/widgets/page.dart';

class RunningPage extends StatelessWidget {
  final DateTime finishTime;
  RunningPage({required this.finishTime});

  void _cancel(BuildContext context) async {
    FlutterLocalNotificationsPlugin().cancelAll();

    final prefs = await SharedPreferences.getInstance();
    prefs.remove('alarm_time');

    ScaffoldMessenger.of(context).clearSnackBars();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => WaitingPage(),
      ),
    );
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Alarm cancelled')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Countdown(
          finishTime: finishTime,
          builder: (Duration duration) {
            final durationAsString = prettyDuration(
              duration.isNegative ? Duration.zero : duration,
              abbreviated: false,
              tersity: duration.inMinutes == 0
                  ? DurationTersity.second
                  : DurationTersity.minute,
              conjunction: ' and ',
              delimiter: ', ',
            );
            return Page(
              icon: Icons.nights_stay_outlined,
              text: 'The alarm goes off in $durationAsString.',
              title: 'Have a good sleep!',
              children: [
                OutlinedButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                        (_) => Theme.of(context).accentColor),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'I don\'t trust you so long-press this button to cancel the alarm',
                        ),
                      ),
                    );
                  },
                  onLongPress: () => _cancel(context),
                  child: const Text('CANCEL'),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
