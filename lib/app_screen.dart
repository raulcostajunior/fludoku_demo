import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'board_settings_material.dart';
import 'board_settings_cupertino.dart';
import 'board_widget.dart';
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
            MaterialModalSheetData(showDragHandle: true, useSafeArea: true),
        builder: (context) => PlatformWidget(
            cupertino: (_, __) => const BoardSettingsCupertino(),
            material: (_, __) => const BoardSettingsMaterial()));
  }

  List<Widget> _buildBody(BuildContext context) {
    final boardViewModel = BoardProvider.of(context);
    if (boardViewModel.generationError != null) {
      // Some error happened during the generation - most likely the generation timed out
      boardViewModel.puzzle.clear();
      return [
        Text(boardViewModel.generationError!, textAlign: TextAlign.center),
        const SizedBox(height: 32),
        IconButton(
          icon: const Icon(CupertinoIcons.square_grid_2x2, size: 80),
          onPressed: onNewBoardPressed,
          tooltip: "Create New Puzzle",
        ),
        const SizedBox(height: 12),
        const Text(
          "Create New Puzzle",
          textAlign: TextAlign.center,
        )
      ];
    } else if (boardViewModel.generating) {
      return [
        PlatformCircularProgressIndicator(),
        const SizedBox(height: 12),
        Text(
            "Creating ${boardViewModel.genPuzzleLevel.name} puzzle with size ${boardViewModel.genPuzzleSize} x ${boardViewModel.genPuzzleSize} ..."),
        const SizedBox(height: 32),
        PlatformElevatedButton(
            child: PlatformText('Cancel Puzzle Creation'),
            onPressed: () {
              boardViewModel.cancelGeneration();
            }),
      ];
    } else if (boardViewModel.puzzle.isEmpty) {
      return [
        IconButton(
          icon: const Icon(CupertinoIcons.square_grid_2x2, size: 80),
          onPressed: onNewBoardPressed,
          tooltip: "Create New Puzzle",
        ),
        const SizedBox(height: 12),
        const Text(
          "Create New Puzzle",
          textAlign: TextAlign.center,
        )
      ];
    } else {
      // There's some puzzle to be displayed - probably along with its solution
      return [
        Expanded(
            child: Padding(
                padding: const EdgeInsetsGeometry.all(12),
                child: BoardWidget(boardViewModel.puzzle)))
      ];
    }
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
                      tooltip: 'Create New Puzzle',
                      // Only one board generation at a time
                      onPressed: boardViewModel.generating
                          ? null
                          : () {
                              onNewBoardPressed();
                            }),
                  IconButton(
                    icon: const Icon(CupertinoIcons.lightbulb, size: 28),
                    tooltip: 'Solve Puzzle',
                    onPressed: boardViewModel.generating ||
                            boardViewModel.puzzle.isEmpty ||
                            boardViewModel.puzzle.isComplete
                        ? null
                        : () {
                            boardViewModel.solvePuzzle();
                          },
                  ),
                ],
                title: Text(widget.title),
              ),
              body: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildBody(context))));
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
