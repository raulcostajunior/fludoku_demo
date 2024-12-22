import 'package:flutter/material.dart';

class BoardSettingsMaterial extends StatelessWidget {
  const BoardSettingsMaterial({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('New Sudoku Board'),
            ]),
      ),
    );
  }
}
