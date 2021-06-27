import 'dart:math';

import 'package:vibration/vibration.dart';

class _ContinuousVibration {
  static const duration = 250;
  static const delay = 250;

  var _enabled = false;

  void start() {
    _enabled = true;
    _vibrate();
  }

  void stop() {
    Vibration.cancel();
    _enabled = false;
  }

  void _vibrate() async {
    if (!_enabled) return;
    Vibration.vibrate(
        duration: duration, amplitude: Random().nextInt(100) + 156);
    await Future.delayed(Duration(milliseconds: duration + delay));
    _vibrate();
  }
}

final cv = _ContinuousVibration();
