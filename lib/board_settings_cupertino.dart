import 'package:flutter/cupertino.dart';

class BoardSettingsCupertino extends StatefulWidget {
  const BoardSettingsCupertino({super.key});

  @override
  State<BoardSettingsCupertino> createState() => _BoardSettingsCupertinoState();
}

class _BoardSettingsCupertinoState extends State<BoardSettingsCupertino> {
  int boardSize = 9;
  String boardDifficulty = 'Easy';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('New Sudoku Board'),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            children: [
              CupertinoFormSection(
                footer: const Padding(
                  padding: EdgeInsets.only(top: 6.0),
                  child: Text(
                      'Number of rows and columns of the board to be generated.'),
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
                      'Difficulty level for the board to be generated.\n'
                      'Harder levels generate boards with more blank positions.'),
                ),
                children: [
                  CupertinoFormRow(
                    prefix: const Text('Difficulty'),
                    child: CupertinoSlidingSegmentedControl<String>(
                      children: const {
                        'Easy': Text('Easy'),
                        'Medium': Text('Medium'),
                        'Hard': Text('Hard'),
                      },
                      groupValue: boardDifficulty,
                      onValueChanged: (String? value) {
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
