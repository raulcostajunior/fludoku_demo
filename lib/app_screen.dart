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

  List<Widget> _buildBody(BuildContext context) {
    final boardViewModel = BoardProvider.of(context);
    if (boardViewModel.generationError != null) {
      // Some error happened during the generation - most likely the generation timed out
      boardViewModel.board.clear();
      return [
        Text(boardViewModel.generationError!, textAlign: TextAlign.center),
        const SizedBox(height: 32),
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
      ];
    } else if (boardViewModel.generating) {
      return [
        PlatformCircularProgressIndicator(),
        const SizedBox(height: 12),
        Text(
            "Creating ${boardViewModel.genBoardLevel.name} board with size ${boardViewModel.genBoardSize} x ${boardViewModel.genBoardSize} ..."),
        const SizedBox(height: 32),
        PlatformElevatedButton(
            child: PlatformText('Cancel Board Creation'),
            onPressed: () {
              boardViewModel.cancelGeneration();
              // Clears any board that was being displayed when
              // the just cancelled generation was started.
              boardViewModel.board.clear();
            }),
      ];
    } else if (boardViewModel.board.isEmpty) {
      return [
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
      ];
    } else {
      // There's some board to be displayed - probably along with its solution
      // TODO: instantiate a Board Widget to render the board;
      //       both the board and the solved board from the view model must be
      //       passed to the widget. It can use the board to derive the read-only
      //       positions from the 0's in the generated board to output them
      //       differently.
      return [
        boardViewModel.solvedBoard != null
            ? Text(boardViewModel.solvedBoard.toString())
            : Text(boardViewModel.board.toString())
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
                      tooltip: 'Create New Board',
                      // Only one board generation at a time
                      onPressed: boardViewModel.generating
                          ? null
                          : () {
                              onNewBoardPressed();
                            }),
                  IconButton(
                    icon: const Icon(CupertinoIcons.lightbulb, size: 28),
                    tooltip: 'Solve Board',
                    onPressed: boardViewModel.generating ||
                            boardViewModel.board.isEmpty ||
                            boardViewModel.board.isComplete
                        ? null
                        : () {
                            boardViewModel.solveBoard();
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
