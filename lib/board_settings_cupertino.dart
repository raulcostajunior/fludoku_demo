import 'package:flutter/cupertino.dart';
import 'package:fludoku/fludoku.dart';
import 'board_provider.dart';

class BoardSettingsCupertino extends StatefulWidget {
  const BoardSettingsCupertino({super.key});

  @override
  State<BoardSettingsCupertino> createState() => _BoardSettingsCupertinoState();
}

class _BoardSettingsCupertinoState extends State<BoardSettingsCupertino> {
  int boardSize = 9;
  PuzzleDifficulty boardDifficulty = PuzzleDifficulty.easy;

  @override
  Widget build(BuildContext context) {
    final boardViewModel = BoardProvider.of(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('New Sudoku Board'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            boardViewModel.generateBoard(
                level: boardDifficulty, dimension: boardSize);
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
                  child:
                      Text('Number of rows and columns on the created board.'),
                ),
                children: [
                  CupertinoFormRow(
                    prefix: const Text('Board Size'),
                    child: CupertinoSlidingSegmentedControl<int>(
                      children: const {
                        4: Text('4'),
                        9: Text('9'),
                        16: Text('16'),
                        25: Text('25'),
                      },
                      groupValue: boardSize,
                      onValueChanged: (int? value) {
                        setState(() {
                          boardSize = value!;
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
                      'The harder the level, the more blank positions the generated board will have'),
                ),
                children: [
                  CupertinoFormRow(
                    prefix: const Text('Board Difficulty'),
                    child: CupertinoSlidingSegmentedControl<PuzzleDifficulty>(
                      children: const {
                        PuzzleDifficulty.easy: Text('Easy'),
                        PuzzleDifficulty.medium: Text('Medium'),
                        PuzzleDifficulty.hard: Text('Hard'),
                      },
                      groupValue: boardDifficulty,
                      onValueChanged: (PuzzleDifficulty? value) {
                        setState(() {
                          boardDifficulty = value!;
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
  }
}
