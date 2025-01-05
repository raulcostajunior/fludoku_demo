import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'board_settings_material.dart';
import 'board_settings_cupertino.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key, required this.title});

  final String title;

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        appBar: PlatformAppBar(
          backgroundColor: Colors.transparent,
          material: (_, __) => MaterialAppBarData(elevation: 2),
          trailingActions: <Widget>[
            IconButton(
                icon: const Icon(Icons.grid_on_rounded, size: 28),
                tooltip: 'New Board',
                onPressed: () {
                  showPlatformModalSheet(
                      context: context,
                      builder: (context) => PlatformWidget(
                          cupertino: (_, __) => const BoardSettingsCupertino(),
                          material: (_, __) => const BoardSettingsMaterial()));
                }),
            const IconButton(
              icon: Icon(Icons.tips_and_updates, size: 28),
              tooltip: 'Solve Board',
              onPressed: null,
            ),
          ],
          title: Text(widget.title),
        ),
        body: const Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.grid_on_rounded,
              size: 120,
            ),
            SizedBox(height: 20),
            Text(
              "To create a Board, \npress the grid icon in the top bar.",
              textAlign: TextAlign.center,
            )
          ],
        )));
  }
}
