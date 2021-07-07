import 'dart:async';

import 'package:flutter/widgets.dart';

class Countdown extends StatefulWidget {
  final DateTime finishTime;
  final Widget Function(String formattedDuration, Duration duration) builder;
  final String Function(Duration) format;
  const Countdown(
      {Key? key,
      required this.finishTime,
      required this.format,
      required this.builder})
      : super(key: key);

  @override
  _CountdownState createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Duration duration = widget.finishTime.difference(DateTime.now());
    return widget.builder(widget.format(duration), duration);
  }
}
