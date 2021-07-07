import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final _scaffoldBackground = Colors.grey.shade900;
final _paperBackground = Color(0xff303030); // grey shade 850
final _primaryColor = Colors.indigoAccent.shade100;
final notificationColor = Colors.indigoAccent.shade200;
final baseTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: _scaffoldBackground,
  appBarTheme: AppBarTheme(color: _paperBackground),
  iconTheme: IconThemeData(color: Colors.white54),
  accentColor: _primaryColor,
  dividerColor: Colors.white30,
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith<Color?>(
      (state) => state.contains(MaterialState.selected) &&
              !state.contains(MaterialState.disabled)
          ? _primaryColor
          : null,
    ),
    trackColor: MaterialStateProperty.resolveWith<Color?>(
      (state) => state.contains(MaterialState.selected) &&
              !state.contains(MaterialState.disabled)
          ? _primaryColor.withOpacity(0.5)
          : null,
    ),
  ),
  cardColor: _paperBackground,
  colorScheme: ColorScheme.dark(
    background: _paperBackground,
    surface: _paperBackground,
    primary: _primaryColor,
    primaryVariant: _darkPrimaryColor,
    onPrimary: Colors.white,
    secondary: _primaryColor,
  ),
);

final _darkPrimaryColor = Colors.deepPurple.shade800;
final _accentColor = Colors.lime;
final testingTheme = baseTheme.copyWith(
  scaffoldBackgroundColor: _darkPrimaryColor,
  appBarTheme: AppBarTheme(color: _darkPrimaryColor),
  primaryColor: _accentColor,
  accentColor: _accentColor,
  colorScheme: baseTheme.colorScheme.copyWith(
    background: _darkPrimaryColor,
    surface: _darkPrimaryColor,
    primary: _accentColor,
    secondary: _accentColor,
  ),
);
