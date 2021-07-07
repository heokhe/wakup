import 'package:flutter/material.dart' hide Page;
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';
import 'package:wakup/pages/homepage.dart';
import 'package:wakup/themes.dart';
import 'package:wakup/core/utils.dart';

class TestingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(data: testingTheme, child: _TestPage());
  }
}

class _TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<_TestPage> {
  final _thingToType = getANounAndAdjective();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    SystemChrome.setSystemUIOverlayStyle(testingPageSystemUiOverlayStyle);
  }

  @override
  void dispose() {
    Wakelock.disable();
    SystemChrome.setSystemUIOverlayStyle(defaultSystemUiOverlayStyle);
    super.dispose();
  }

  void _onSuccess(BuildContext context) {
    _focusNode.unfocus();
    FlutterLocalNotificationsPlugin().cancelAll();
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('alarm_time');
    });
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppBar(
              elevation: 0,
              leading: Icon(
                Icons.notifications_active_outlined,
                color: Colors.white54,
              ),
              title: Text('Time\'s up'),
            ),
            Divider(height: 1),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 40, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Type the words below to end the alarm:',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.copyWith(color: Colors.white70),
                  ),
                  SizedBox(height: 16),
                  Text(
                    _thingToType,
                    style: Theme.of(context).textTheme.headline3?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    toolbarOptions: ToolbarOptions(paste: false),
                    autocorrect: false,
                    enableSuggestions: false,
                    autofocus: true,
                    textInputAction: TextInputAction.none,
                    focusNode: _focusNode,
                    onChanged: (value) {
                      if (value.toLowerCase().trim() ==
                          _thingToType.toLowerCase()) {
                        _onSuccess(context);
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Words here',
                      hintText: _thingToType.toLowerCase(),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
