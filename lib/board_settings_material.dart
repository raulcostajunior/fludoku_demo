import 'package:flutter/material.dart';
import 'package:fludoku/fludoku.dart';
import 'state/board_provider.dart';

class BoardSettingsMaterial extends StatefulWidget {
  const BoardSettingsMaterial({super.key});

  @override
  State<BoardSettingsMaterial> createState() => _BoardSettingsMaterialState();
}

class _BoardSettingsMaterialState extends State<BoardSettingsMaterial> {
  // TODO: Refactor Text captions into a single place - currently duplicated between Cupertino and Material
  @override
  Widget build(BuildContext context) {
    final boardViewModel = BoardProvider.of(context);
    return ListenableBuilder(
        listenable: boardViewModel,
        builder: (context, _) {
          return Material(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(children: <Widget>[
                Center(
                    child: Text('New Sudoku Puzzle',
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(fontSizeFactor: 1.2))),
                const Divider(),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Puzzle Size',
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(fontWeightDelta: 2)),
                    SegmentedButton<int>(
                      // When the tick of the selected icon is shown, the
                      // segments are rescaled to accommodate the icon and that
                      // causes an annoying "readjustment" of the lay-out.
                      showSelectedIcon: false,
                      segments: const <ButtonSegment<int>>[
                        ButtonSegment<int>(value: 4, label: Text('4')),
                        ButtonSegment<int>(value: 9, label: Text('9')),
                        ButtonSegment<int>(value: 16, label: Text('16')),
                      ],
                      selected: {
                        boardViewModel.genPuzzleSize == 4 ||
                                boardViewModel.genPuzzleSize == 16
                            ? boardViewModel.genPuzzleSize
                            : 9
                      },
                      onSelectionChanged: (selection) => {
                        setState(() {
                          boardViewModel.genPuzzleSize = selection.first;
                        })
                      },
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Puzzle Level',
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(fontWeightDelta: 2)),
                    SegmentedButton<PuzzleDifficulty>(
                      // The same note from the Board Size SegmentedButton applies
                      showSelectedIcon: false,
                      segments: const <ButtonSegment<PuzzleDifficulty>>[
                        ButtonSegment<PuzzleDifficulty>(
                            value: PuzzleDifficulty.easy, label: Text('Easy')),
                        ButtonSegment<PuzzleDifficulty>(
                            value: PuzzleDifficulty.medium,
                            label: Text('Medium')),
                        ButtonSegment<PuzzleDifficulty>(
                            value: PuzzleDifficulty.hard, label: Text('Hard'))
                      ],
                      selected: {boardViewModel.genPuzzleLevel},
                      onSelectionChanged: (selection) => {
                        setState(() {
                          boardViewModel.genPuzzleLevel = selection.first;
                        })
                      },
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Timeout (seconds)',
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(fontWeightDelta: 2)),
                    SegmentedButton<int>(
                      // When the tick of the selected icon is shown, the
                      // segments are rescaled to accommodate the icon and that
                      // causes an annoying "readjustment" of the lay-out.
                      showSelectedIcon: false,
                      segments: const <ButtonSegment<int>>[
                        ButtonSegment<int>(value: 60, label: Text('60')),
                        ButtonSegment<int>(value: 120, label: Text('120')),
                        ButtonSegment<int>(value: -1, label: Text('∞')),
                      ],
                      selected: {
                        boardViewModel.genPuzzleTimeout == 60 ||
                                boardViewModel.genPuzzleTimeout == 120
                            ? boardViewModel.genPuzzleTimeout
                            : -1
                      },
                      onSelectionChanged: (selection) => {
                        setState(() {
                          boardViewModel.genPuzzleTimeout = selection.first;
                        })
                      },
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 18.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      child: const Text('Create'),
                      onPressed: () {
                        boardViewModel.generatePuzzle();
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Dismiss'),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                )
              ]),
            ),
          );
        });
  }
}
