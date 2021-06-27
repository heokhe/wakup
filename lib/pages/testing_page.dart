import 'package:flutter/material.dart' hide Page;
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakup/pages/waiting_page.dart';
import 'package:wakup/themes.dart';
import 'package:wakup/widgets/page.dart';
import 'package:wakup/utils.dart';

class TestPage extends StatelessWidget {
  final thingToType = getANounAndAdjective();
  final _focusNode = FocusNode();
  TestPage({Key? key}) : super(key: key);

  void _onSuccess(BuildContext context) {
    _focusNode.unfocus();
    FlutterLocalNotificationsPlugin().cancelAll();
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('alarm_time');
    });
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => WaitingPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: smellyTheme,
      child: Scaffold(
        body: Center(
          child: Expanded(
            child: SingleChildScrollView(
              clipBehavior: Clip.none,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(24),
              child: Page(
                icon: Icons.notifications_active_outlined,
                title: 'Time\'s up!',
                text: 'Write "$thingToType" and I\'ll let you go:',
                children: [
                  TextField(
                    toolbarOptions: ToolbarOptions(paste: false),
                    autocorrect: false,
                    enableSuggestions: false,
                    autofocus: true,
                    textInputAction: TextInputAction.none,
                    focusNode: _focusNode,
                    onChanged: (value) {
                      if (value.toLowerCase() == thingToType.toLowerCase()) {
                        _onSuccess(context);
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      filled: true,
                      hintText: thingToType,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
