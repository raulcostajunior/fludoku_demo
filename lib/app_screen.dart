import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'board_settings_material.dart';
import 'board_settings_cupertino.dart';
import 'state/board_provider.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key, required this.title});

  final String title;

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  void onNewBoardPressed() {
    showPlatformModalSheet(
        context: context,
        material:
            MaterialModalSheetData(showDragHandle: true, useSafeArea: false),
        builder: (context) => PlatformWidget(
            cupertino: (_, __) => const BoardSettingsCupertino(),
            material: (_, __) => const BoardSettingsMaterial()));
  }

  Widget _buildCommon(BuildContext context) {
    final boardViewModel = BoardProvider.of(context);
    return ListenableBuilder(
        listenable: boardViewModel,
        builder: (context, _) {
          return PlatformScaffold(
              appBar: PlatformAppBar(
                material: (_, __) => MaterialAppBarData(elevation: 2),
                cupertino: (_, __) =>
                    CupertinoNavigationBarData(brightness: Brightness.light),
                trailingActions: <Widget>[
                  IconButton(
                      icon:
                          const Icon(CupertinoIcons.square_grid_2x2, size: 28),
                      tooltip: 'Create New Board',
                      // Only one board generation at a time
                      onPressed: boardViewModel.generating
                          ? null
                          : () {
                              onNewBoardPressed();
                            }),
                  const IconButton(
                    icon: Icon(CupertinoIcons.lightbulb, size: 28),
                    tooltip: 'Solve Board',
                    onPressed: null,
                  ),
                ],
                title: Text(widget.title),
              ),
              body: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(CupertinoIcons.square_grid_2x2, size: 80),
                    onPressed: onNewBoardPressed,
                    tooltip: "Create New Board",
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Create New Board",
                    textAlign: TextAlign.center,
                  )
                ],
              )));
        });
  }

  @override
  Widget build(BuildContext context) {
    final boardViewModel = BoardProvider.of(context);
    return ListenableBuilder(
        listenable: boardViewModel,
        builder: (context, _) {
          if (Platform.isIOS) {
            // On iOS the use of SafeArea compromises the status bar visibility.
            // Couldn't find a solution, so working around it for now.
            return _buildCommon(context);
          } else {
            return SafeArea(child: _buildCommon(context));
          }
        });
  }
}
