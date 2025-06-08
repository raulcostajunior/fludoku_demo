import 'package:fludoku/fludoku.dart';
import 'package:flutter/material.dart';

class BoardWidget extends StatelessWidget {
  final Board _board;
  const BoardWidget(this._board, {super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: _board.dimension,
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
      children: _buildGrid(context),
    );
  }

  List<Widget> _buildGrid(BuildContext context) {
    var boxes = <Container>[];
    double fontSize = 12;
    if (_board.dimension == 4) {
      fontSize = 58;
    } else if (_board.dimension == 9) {
      fontSize = 24;
    }
    for (var r = 0; r < _board.dimension; r++) {
      for (var c = 0; c < _board.dimension; c++) {
        final value = _board.getAt(row: r, col: c);
        boxes.add(Container(
          //   width: 25,
          //   height: 25,
          decoration: BoxDecoration(
              border: BoxBorder.all(),
              color: (_board.readOnlyPositions.contains((row: r, col: c))
                  ? Colors.grey[300]
                  : Colors.white)),
          child: Text(
            value > 0 ? value.toString() : "",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: fontSize),
          ),
        ));
      }
    }
    return boxes;
  }
}
