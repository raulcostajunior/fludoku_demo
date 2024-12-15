import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final materialLightTheme = ThemeData.light();
final materialDarkTheme = ThemeData.dark();

const darkDefaultCupertinoTheme =
    CupertinoThemeData(brightness: Brightness.dark);
final cupertinoDarkTheme = MaterialBasedCupertinoThemeData(
  materialTheme: materialDarkTheme.copyWith(
    cupertinoOverrideTheme: CupertinoThemeData(
      brightness: Brightness.dark,
      barBackgroundColor: darkDefaultCupertinoTheme.barBackgroundColor,
      textTheme: CupertinoTextThemeData(
        primaryColor: Colors.white,
        navActionTextStyle:
            darkDefaultCupertinoTheme.textTheme.navActionTextStyle.copyWith(
          color: const Color(0xF0F9F9F9),
        ),
        navLargeTitleTextStyle: darkDefaultCupertinoTheme
            .textTheme.navLargeTitleTextStyle
            .copyWith(color: const Color(0xF0F9F9F9)),
      ),
    ),
  ),
);
final cupertinoLightTheme =
    MaterialBasedCupertinoThemeData(materialTheme: materialLightTheme);
