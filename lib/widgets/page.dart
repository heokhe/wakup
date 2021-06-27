import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Page extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  final List<Widget>? children;
  const Page(
      {Key? key,
      required this.icon,
      required this.title,
      required this.text,
      this.children})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 128),
          const SizedBox(height: 24),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headline4
                ?.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(text,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(color: Colors.white70),
              textAlign: TextAlign.center),
          if (children != null) ...[const SizedBox(height: 16), ...children!]
        ]);
  }
}
