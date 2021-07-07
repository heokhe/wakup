import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakup/main.dart';
import 'package:wakup/pages/testing_page.dart';
import 'package:wakup/pages/homepage.dart';
import 'package:wakup/widgets/countdown.dart';

class RunningPage extends StatefulWidget {
  final DateTime finishTime;
  RunningPage({required this.finishTime});

  @override
  _RunningPageState createState() => _RunningPageState();
}

class _RunningPageState extends State<RunningPage> {
  @override
  void initState() {
    super.initState();
    selectNotificationSubject.listen((_) {
      FlutterLocalNotificationsPlugin().cancelAll();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => TestingPage()),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    selectNotificationSubject.close();
  }

  void _cancel(BuildContext context) async {
    FlutterLocalNotificationsPlugin().cancelAll();

    final prefs = await SharedPreferences.getInstance();
    prefs.remove('alarm_time');

    ScaffoldMessenger.of(context).clearSnackBars();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Alarm cancelled')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                _buildCircle(context, 144, 0.1),
                _buildCircle(context, 96, 0.14),
                Icon(Icons.nights_stay_outlined,
                    size: 64, color: Theme.of(context).colorScheme.primary)
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Sleep well!',
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  ?.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Countdown(
                finishTime: widget.finishTime,
                format: (duration) => prettyDuration(
                      duration.isNegative ? Duration.zero : duration,
                      abbreviated: false,
                      tersity: duration.inMinutes == 0
                          ? DurationTersity.second
                          : DurationTersity.minute,
                      conjunction: ' and ',
                      delimiter: ', ',
                    ),
                builder: (duration, _) => Text(
                    'The alarm goes off in $duration.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(color: Colors.white70),
                    textAlign: TextAlign.center)),
            const SizedBox(height: 16),
            OutlinedButton(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith(
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
        ),
      ),
    );
  }

  Container _buildCircle(BuildContext context, double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size),
        color: Theme.of(context).colorScheme.primary.withOpacity(opacity),
      ),
    );
  }
}
