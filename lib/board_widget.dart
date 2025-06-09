import 'package:fludoku/fludoku.dart';
import 'package:flutter/material.dart';

import 'dart:math';

class BoardWidget extends StatelessWidget {
  final Board _board;

  const BoardWidget(this._board, {super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: sqrt(_board.dimension).toInt(),
      crossAxisSpacing: 2,
      mainAxisSpacing: 2,
      children: _buildGrid(context),
    );
  }

  List<Widget> _buildGrid(BuildContext context) {
    var groups = <Container>[];
    double fontSize = 12;
    if (_board.dimension == 4) {
      fontSize = 58;
    } else if (_board.dimension == 9) {
      fontSize = 24;
    }
    final groupSize = sqrt(_board.dimension).toInt();
    for (var r = 0; r < _board.dimension; r += groupSize) {
      for (var c = 0; c < _board.dimension; c += groupSize) {
        var cells = <Container>[];
        for (var ri = r; ri < r + groupSize; ri++) {
          for (var ci = c; ci < c + groupSize; ci++) {
            final value = _board.getAt(row: ri, col: ci);
            final isReadOnly =
                _board.readOnlyPositions.contains((row: ri, col: ci));
            cells.add(Container(
                decoration: BoxDecoration(
                    border: BoxBorder.all(color: Colors.grey[400]!),
                    color: isReadOnly ? Colors.grey[200] : Colors.white),
                child: Center(
                  child: Text(
                    value > 0 ? value.toString() : "",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: fontSize),
                  ),
                )));
          }
        }
        groups.add(Container(
            decoration: BoxDecoration(
                border: BoxBorder.all(color: Colors.black, width: 1)),
            child: GridView.count(crossAxisCount: groupSize, children: cells)));
      }
    }
    return groups;
  }
}
