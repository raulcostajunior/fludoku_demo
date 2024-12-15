import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import './app_themes.dart';
import 'app_screen.dart';

void main() {
  runApp(const FludokuDemoApp());
}

class FludokuDemoApp extends StatefulWidget {
  const FludokuDemoApp({super.key});

  @override
  State<FludokuDemoApp> createState() => _FludokuDemoAppState();
}

class _FludokuDemoAppState extends State<FludokuDemoApp> {
  ThemeMode? themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return PlatformProvider(
        settings: PlatformSettingsData(
            iosUsesMaterialWidgets: true,
            iosUseZeroPaddingForAppbarPlatformIcon: true),
        builder: (context) => PlatformTheme(
            themeMode: themeMode,
            materialLightTheme: materialLightTheme,
            materialDarkTheme: materialDarkTheme,
            cupertinoLightTheme: cupertinoLightTheme,
            cupertinoDarkTheme: cupertinoDarkTheme,
            matchCupertinoSystemChromeBrightness: true,
            onThemeModeChanged: (themeMode) {
              this.themeMode = themeMode; /* you can save to storage */
            },
            builder: (context) => const PlatformApp(
                  localizationsDelegates: <LocalizationsDelegate<dynamic>>[
                    DefaultMaterialLocalizations.delegate,
                    DefaultWidgetsLocalizations.delegate,
                    DefaultCupertinoLocalizations.delegate,
                  ],
                  title: 'Fludoku Demo',
                  home: AppScreen(title: 'Fludoku Demo'),
                )));
  }
}
