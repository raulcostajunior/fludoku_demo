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
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 4.0,
                  children: <Widget>[
                    Center(
                        child: Text('New Sudoku Puzzle',
                            style: DefaultTextStyle.of(context)
                                .style
                                .apply(fontSizeFactor: 1.2))),
                    // const Divider(),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('New Puzzle Size',
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
                          selected: {boardViewModel.genPuzzleSize},
                          onSelectionChanged: (selection) => {
                            setState(() {
                              boardViewModel.genPuzzleSize = selection.first;
                            })
                          },
                        ),
                      ],
                    ),
                    const Text('Number of rows and columns of the new puzzle.'),
                    // const Divider(),
                    const SizedBox(height: 12.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('New Puzzle Level',
                            style: DefaultTextStyle.of(context)
                                .style
                                .apply(fontWeightDelta: 2)),
                        SegmentedButton<PuzzleDifficulty>(
                          // The same note from the Board Size SegmentedButton applies
                          showSelectedIcon: false,
                          segments: const <ButtonSegment<PuzzleDifficulty>>[
                            ButtonSegment<PuzzleDifficulty>(
                                value: PuzzleDifficulty.easy,
                                label: Text('Easy')),
                            ButtonSegment<PuzzleDifficulty>(
                                value: PuzzleDifficulty.medium,
                                label: Text('Medium')),
                            ButtonSegment<PuzzleDifficulty>(
                                value: PuzzleDifficulty.hard,
                                label: Text('Hard'))
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
                    const Text(
                        'The harder the level, the more blank positions the new puzzle will have.'),
                    // const Divider(),
                    const SizedBox(height: 12.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Creation Timeout',
                            style: DefaultTextStyle.of(context)
                                .style
                                .apply(fontWeightDelta: 2)),
                        SegmentedButton<int>(
                          // When the tick of the selected icon is shown, the
                          // segments are rescaled to accommodate the icon and that
                          // causes an annoying "readjustment" of the lay-out.
                          showSelectedIcon: false,
                          segments: const <ButtonSegment<int>>[
                            ButtonSegment<int>(value: 30, label: Text('30')),
                            ButtonSegment<int>(value: 120, label: Text('120')),
                            ButtonSegment<int>(value: 300, label: Text('300')),
                            ButtonSegment<int>(value: -1, label: Text('∞')),
                          ],
                          selected: {boardViewModel.genPuzzleTimeout},
                          onSelectionChanged: (selection) => {
                            setState(() {
                              boardViewModel.genPuzzleTimeout = selection.first;
                            })
                          },
                        ),
                      ],
                    ),
                    const Text(
                        'Maximum allowed time, in seconds, for the puzzle to be created.'),
                    // const Divider(),
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
