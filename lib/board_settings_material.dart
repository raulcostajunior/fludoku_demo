import 'package:flutter/material.dart';
import 'package:fludoku/fludoku.dart';

class BoardSettingsMaterial extends StatelessWidget {
  const BoardSettingsMaterial({super.key});

// TODO: Refactor Text captions into a single place - currently duplicated between Cupertino and Material

// TODO: Use predefined styles like Header and Body instead of the fontSizeFactor and fontWeightFactor currently used.
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                    segments: const <ButtonSegment<int>>[
                      ButtonSegment<int>(value: 4, label: Text('4')),
                      ButtonSegment<int>(value: 9, label: Text('9')),
                      ButtonSegment<int>(value: 16, label: Text('16')),
                      ButtonSegment<int>(value: 25, label: Text('25')),
                    ],
                    selected: const {
                      9,
                    },
                    onSelectionChanged: (selection) => {},
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
                    segments: const <ButtonSegment<PuzzleDifficulty>>[
                      ButtonSegment<PuzzleDifficulty>(
                          value: PuzzleDifficulty.easy, label: Text('Easy')),
                      ButtonSegment<PuzzleDifficulty>(
                          value: PuzzleDifficulty.medium,
                          label: Text('Medium')),
                      ButtonSegment<PuzzleDifficulty>(
                          value: PuzzleDifficulty.hard, label: Text('Hard'))
                    ],
                    selected: const {
                      PuzzleDifficulty.easy,
                    },
                    onSelectionChanged: (selection) => {},
                  ),
                ],
              ),
              Text(
                  'The harder the level, the more blank positions the generated board will have.',
                  style: DefaultTextStyle.of(context)
                      .style
                      .apply(fontSizeFactor: 0.9)),
              const Divider(),
            ]),
      ),
    );
  }
}
