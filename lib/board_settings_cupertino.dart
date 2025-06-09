import 'package:flutter/cupertino.dart';
import 'package:fludoku/fludoku.dart';
import 'state/board_provider.dart';

class BoardSettingsCupertino extends StatefulWidget {
  const BoardSettingsCupertino({super.key});

  @override
  State<BoardSettingsCupertino> createState() => _BoardSettingsCupertinoState();
}

class _BoardSettingsCupertinoState extends State<BoardSettingsCupertino> {
  @override
  Widget build(BuildContext context) {
    final boardViewModel = BoardProvider.of(context);
    return ListenableBuilder(
        listenable: boardViewModel,
        builder: (context, _) {
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text('New Sudoku Puzzle'),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  boardViewModel.generatePuzzle();
                  Navigator.of(context).pop();
                },
                child: const Text('Create'),
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Column(
                  children: [
                    CupertinoFormSection(
                      footer: const Padding(
                        padding: EdgeInsets.only(top: 6.0),
                        child: Text(
                            'Number of rows and columns of the new puzzle.'),
                      ),
                      children: [
                        CupertinoFormRow(
                          prefix: const Text('New Puzzle Size'),
                          child: CupertinoSlidingSegmentedControl<int>(
                            children: const {
                              4: Text('4'),
                              9: Text('9'),
                              16: Text('16'),
                            },
                            groupValue: boardViewModel.genPuzzleSize == 4 ||
                                    boardViewModel.genPuzzleSize == 16
                                ? boardViewModel.genPuzzleSize
                                : 9,
                            onValueChanged: (int? value) {
                              setState(() {
                                boardViewModel.genPuzzleSize = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    CupertinoFormSection(
                      footer: const Padding(
                        padding: EdgeInsets.only(top: 6.0),
                        child: Text(
                            'The harder the level, the more blank positions the new puzzle will have.'),
                      ),
                      children: [
                        CupertinoFormRow(
                          prefix: const Text('New Puzzle Level'),
                          child: CupertinoSlidingSegmentedControl<
                              PuzzleDifficulty>(
                            children: const {
                              PuzzleDifficulty.easy: Text('Easy'),
                              PuzzleDifficulty.medium: Text('Medium'),
                              PuzzleDifficulty.hard: Text('Hard'),
                            },
                            groupValue: boardViewModel.genPuzzleLevel,
                            onValueChanged: (PuzzleDifficulty? value) {
                              setState(() {
                                boardViewModel.genPuzzleLevel = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    CupertinoFormSection(
                      footer: const Padding(
                        padding: EdgeInsets.only(top: 6.0),
                        child: Text(
                            'Maximum allowed time, in seconds, for the puzzle to be created.'),
                      ),
                      children: [
                        CupertinoFormRow(
                          prefix: const Text('Creation Timeout'),
                          child: CupertinoSlidingSegmentedControl<int>(
                            children: const {
                              60: Text('60'),
                              120: Text('120'),
                              -1: Text('∞'),
                            },
                            groupValue: boardViewModel.genPuzzleTimeout == 60 ||
                                    boardViewModel.genPuzzleTimeout == 120
                                ? boardViewModel.genPuzzleTimeout
                                : -1,
                            onValueChanged: (int? value) {
                              setState(() {
                                boardViewModel.genPuzzleTimeout = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
