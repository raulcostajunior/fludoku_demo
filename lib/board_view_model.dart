import 'package:fludoku/fludoku.dart';
import 'package:flutter/foundation.dart';

class BoardViewModel extends ChangeNotifier {
  Board _board = Board();

  bool _generating = false;
  int _currGenStep = 0;
  int _totalGenSteps = 0;

  void generateBoard(
      {required PuzzleDifficulty level,
      required int dimension,
      int timeoutSecs = 15}) {
    _generating = true;
    try {
      // TODO: launch fludoku's board generation method on an isolate and
      // provide a progress callback that will notify listeners on every
      // progress report
    } finally {
      _generating = false;
    }
  }

  Board get board => _board;

  bool get generating => _generating;

  int get currentGenStep => _currGenStep;

  int get totalGenSteps => _totalGenSteps;
}
