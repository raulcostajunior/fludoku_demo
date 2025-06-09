import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'app_screen.dart';
import 'state/board_provider.dart';
import 'state/board_view_model.dart';

void main() {
  runApp(const FludokuDemoApp());
}

class FludokuDemoApp extends StatefulWidget {
  const FludokuDemoApp({super.key});

  @override
  State<FludokuDemoApp> createState() => _FludokuDemoAppState();
}

class _FludokuDemoAppState extends State<FludokuDemoApp> {
  // The BoardProvider is instantiated outside of Build and in a Stateful
  // Widget to allow proper hot reload of widgets rendering the board.
  final _boardProvider = BoardProvider(
          viewModel: BoardViewModel(),
          child: PlatformProvider(
              settings: PlatformSettingsData(
                  iosUsesMaterialWidgets: true,
                  iosUseZeroPaddingForAppbarPlatformIcon: true),
              builder: (context) => const PlatformApp(
                    localizationsDelegates: <LocalizationsDelegate<dynamic>>[
                      DefaultMaterialLocalizations.delegate,
                      DefaultWidgetsLocalizations.delegate,
                      DefaultCupertinoLocalizations.delegate,
                    ],
                    title: 'Fludoku Demo',
                    home: AppScreen(title: 'Fludoku Demo'),
                    debugShowCheckedModeBanner: false,
                  ))) //)
      ;

  @override
  Widget build(BuildContext context) {
    return _boardProvider;
  }
}
