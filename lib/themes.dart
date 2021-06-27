import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const primaryColor = Color(0xff807cf7);
const darkPrimaryColor = Color(0xff3833cc);
final accentColor = Colors.indigoAccent.shade100;
final _scaffoldBackground = Colors.grey.shade900;
final _paperBackground = Color(0xff303030); // grey shade 850

final baseTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: _scaffoldBackground,
  appBarTheme: AppBarTheme(color: _paperBackground),
  iconTheme: IconThemeData(color: Colors.white54),
  accentColor: accentColor,
  dividerColor: Colors.white30,
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith<Color?>(
      (state) => state.contains(MaterialState.selected) &&
              !state.contains(MaterialState.disabled)
          ? accentColor
          : null,
    ),
    trackColor: MaterialStateProperty.resolveWith<Color?>(
      (state) => state.contains(MaterialState.selected) &&
              !state.contains(MaterialState.disabled)
          ? accentColor.withOpacity(0.5)
          : null,
    ),
  ),
  cardColor: _paperBackground,
  colorScheme: ColorScheme.dark(
    background: _paperBackground,
    surface: _paperBackground,
    primary: primaryColor,
    primaryVariant: darkPrimaryColor,
    onPrimary: Colors.white,
    secondary: accentColor,
  ),
);

final smellyTheme = baseTheme.copyWith(
  scaffoldBackgroundColor: darkPrimaryColor,
  appBarTheme: AppBarTheme(color: darkPrimaryColor),
  iconTheme: IconThemeData(color: accentColor),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: accentColor,
    selectionHandleColor: accentColor,
    selectionColor: accentColor.withOpacity(0.5),
  ),
  colorScheme: baseTheme.colorScheme.copyWith(
    background: darkPrimaryColor,
    surface: darkPrimaryColor,
  ),
);
