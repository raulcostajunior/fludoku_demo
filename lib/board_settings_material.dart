import 'package:flutter/material.dart';
import 'package:fludoku/fludoku.dart';
import 'board_provider.dart';

class BoardSettingsMaterial extends StatefulWidget {
  const BoardSettingsMaterial({super.key});

  @override
  State<BoardSettingsMaterial> createState() => _BoardSettingsMaterialState();
}

class _BoardSettingsMaterialState extends State<BoardSettingsMaterial> {
  // TODO: initialize state from stored settings
  Set<int> boardSize = {9};
  Set<PuzzleDifficulty> boardDifficulty = {PuzzleDifficulty.easy};

  // TODO: Refactor Text captions into a single place - currently duplicated between Cupertino and Material
  @override
  Widget build(BuildContext context) {
    final boardViewModel = BoardProvider.of(context);
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 4.0,
            children: <Widget>[
              Center(
                  child: Text('New Sudoku Board',
                      style: DefaultTextStyle.of(context)
                          .style
                          .apply(fontSizeFactor: 1.2))),
              const SizedBox(height: 8.0),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Board Size',
                      style: DefaultTextStyle.of(context)
                          .style
                          .apply(fontWeightDelta: 2)),
                  SegmentedButton<int>(
                    // When the tick of the selected icon is shown, the
                    // segments are rescaled to accomodate the icon and that
                    // causes an annoying "readjustment" of the lay-out.
                    showSelectedIcon: false,
                    segments: const <ButtonSegment<int>>[
                      ButtonSegment<int>(value: 4, label: Text('4')),
                      ButtonSegment<int>(value: 9, label: Text('9')),
                      ButtonSegment<int>(value: 16, label: Text('16')),
                      ButtonSegment<int>(value: 25, label: Text('25')),
                    ],
                    selected: boardSize,
                    onSelectionChanged: (selection) => {
                      setState(() {
                        boardSize = selection;
                      })
                    },
                  ),
                ],
              ),
              Text('Number of rows and columns on the created board.',
                  style: DefaultTextStyle.of(context)
                      .style
                      .apply(fontSizeFactor: 0.9)),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Board Difficulty',
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
                    selected: boardDifficulty,
                    onSelectionChanged: (selection) => {
                      setState(() {
                        boardDifficulty = selection;
                      })
                    },
                  ),
                ],
              ),
              Text(
                  'The harder the level, the more blank positions the generated board will have.',
                  style: DefaultTextStyle.of(context)
                      .style
                      .apply(fontSizeFactor: 0.9)),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    child: const Text('Create'),
                    onPressed: () {
                      // TODO: update stored settings for the state
                      boardViewModel.generateBoard(
                          level: boardDifficulty.first,
                          dimension: boardSize.first);
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
  }
}
