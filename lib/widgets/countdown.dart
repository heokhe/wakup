import 'dart:async';

import 'package:flutter/widgets.dart';

class Countdown extends StatefulWidget {
  final DateTime finishTime;
  final Widget Function(Duration duration) builder;
  const Countdown({Key? key, required this.finishTime, required this.builder})
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
    return widget.builder(widget.finishTime.difference(DateTime.now()));
  }
}
