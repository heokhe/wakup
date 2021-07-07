import 'package:flutter/material.dart' hide Page;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakup/core/notification.dart';
import 'package:wakup/core/utils.dart';
import 'package:wakup/pages/running_page.dart';
import 'package:wakup/widgets/timepicker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _initialTimeOfDay = TimeOfDay.now();
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
    final alarmTime = findNextOccurrenceOfTimeOfDay(_timeOfDay);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('alarm_time', alarmTime.millisecondsSinceEpoch);

    scheduleNotification(alarmTime, _useRingtone);
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
          Card(
            color: Theme.of(context).appBarTheme.color?.withOpacity(0.6),
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: TimePicker(
                initialTime: _initialTimeOfDay,
                onChange: (td) {
                  setState(() {
                    _timeOfDay = td;
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Settings',
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                  color: Colors.white70, fontWeight: FontWeight.w500),
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
