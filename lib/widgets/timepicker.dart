import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:wakup/themes.dart';
import 'package:wakup/utils.dart';

class _CustomScrollablePicker extends StatelessWidget {
  final List<Widget> children;
  final FixedExtentScrollController? controller;
  final void Function(int)? onChanged;
  const _CustomScrollablePicker(
      {Key? key, required this.children, this.controller, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView(
      physics: FixedExtentScrollPhysics(),
      useMagnifier: false,
      overAndUnderCenterOpacity: 0.54,
      perspective: 0.000000000001,
      itemExtent: 64,
      children: children,
      controller: controller,
      onSelectedItemChanged: onChanged,
    );
  }
}

class _PickerItem extends StatelessWidget {
  final String text;
  const _PickerItem({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .headline4
            ?.copyWith(fontWeight: FontWeight.w300, color: Colors.white),
      ),
    );
  }
}

class TimePicker extends StatefulWidget {
  final void Function(TimeOfDay) onChange;
  final TimeOfDay? initialTime;
  const TimePicker({Key? key, required this.onChange, this.initialTime})
      : super(key: key);

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  final _hourController = FixedExtentScrollController();
  final _minuteController = FixedExtentScrollController();
  final _amPmController = FixedExtentScrollController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration(milliseconds: 1500), _animateToInitialData);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool get _isPm => _amPmController.selectedItem == 1;
  int get _hour => (_hourController.selectedItem + 1) % 12 + (_isPm ? 12 : 0);
  int get _minute => _minuteController.selectedItem;

  void _animateToInitialData() {
    final duration = Duration(milliseconds: 250);
    final curve = Curves.easeInOutExpo;
    final initialTime = widget.initialTime;
    if (initialTime == null) return;
    _minuteController.animateToItem(
      initialTime.minute,
      duration: duration,
      curve: curve,
    );
    _amPmController.animateToItem(
      initialTime.hour >= 12 ? 1 : 0,
      duration: duration,
      curve: curve,
    );
    _hourController.animateToItem(
      initialTime.hour % 12 == 0 ? 11 : (initialTime.hour % 12) - 1,
      duration: duration,
      curve: curve,
    );
  }

  void _handleChange(_) {
    widget.onChange(TimeOfDay(hour: _hour, minute: _minute));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64 * 4,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(64),
              border: Border.all(
                color: primaryColor,
                width: 1.5,
              ),
            ),
          ),
          Row(
            children: [
              Flexible(child: Container(), flex: 1),
              Flexible(
                flex: 2,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: 0.14 * // hardcoded
                          Theme.of(context).textTheme.headline4!.fontSize!,
                    ),
                    child: Text(
                      ':',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          ?.copyWith(color: Colors.white38),
                    ),
                  ),
                ),
              ),
              Flexible(child: Container(), flex: 3)
            ],
          ),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: _CustomScrollablePicker(
                  controller: _hourController,
                  onChanged: _handleChange,
                  children: [
                    for (var i = 1; i <= 12; i++)
                      _PickerItem(text: padWithZeros(i))
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: _CustomScrollablePicker(
                  controller: _minuteController,
                  onChanged: _handleChange,
                  children: [
                    for (var i = 0; i < 60; i++)
                      _PickerItem(text: padWithZeros(i))
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: _CustomScrollablePicker(
                  controller: _amPmController,
                  onChanged: _handleChange,
                  children: [
                    _PickerItem(text: 'AM'),
                    _PickerItem(text: 'PM'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
