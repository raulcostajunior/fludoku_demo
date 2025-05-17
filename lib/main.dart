import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'app_screen.dart';
import 'board_provider.dart';
import 'board_view_model.dart';

void main() {
  runApp(const FludokuDemoApp());
}

class FludokuDemoApp extends StatelessWidget {
  const FludokuDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BoardProvider(
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
  }
}
