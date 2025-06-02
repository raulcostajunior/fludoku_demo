import 'dart:isolate';

import 'package:fludoku/fludoku.dart';
import 'package:flutter/foundation.dart';
import 'package:easy_isolate/easy_isolate.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Handles puzzle generation commands in the isolate kept by the worker internal
/// to the BoardViewModel.
///
/// Parameters:
/// - `command`: the command for the worker - a record with
///              the difficulty, the dimension, and the timeout for the board
///              generation.
/// - `commandSenderPort`: a port to communicate back with the command sender.
/// - `sendError`: a function that can be used to send error information back
///                to the command sender without raising an exception.
///
/// As this becomes the listener of the background Isolate kept by the worker,
/// it will be on a thread that is not the one from the Main Isolate (the thread
/// that contains the BoardViewModel instance). As a consequence, this function
/// either had to be a static method of the BoardViewModel (with no access to
/// the data of the BoardViewModel used by the application) or top-level
/// function. We opt for the latter, cleaner approach.
void _handleGenerationCommands(
    dynamic command, SendPort commandSenderPort, SendErrorFunction sendError) {
  var (PuzzleDifficulty level, int dimension, int timeoutSecs) = command;

  var (Board? genBoard, String? errorMsg) = generateSudokuPuzzle(
      level: level,
      dimension: dimension,
      timeoutSecs: timeoutSecs,
      onProgress: ({int current = 1, int total = 1}) {
        commandSenderPort.send((current, total, null));
      });
  if (genBoard != null) {
    // The board generation process succeeded - send the "final progress" update
    // For the "final progress" update negative flagging values are used
    commandSenderPort.send((-1, -1, genBoard));
  } else {
    sendError(errorMsg);
  }
}

class BoardViewModel extends ChangeNotifier {
  Board _puzzle = Board();
  Worker? _worker;

  static const _defaultGenPuzzleSize = 9;
  static const _defaultGenPuzzleLevel = PuzzleDifficulty.medium;
  static const _defaultGenPuzzleTimeout = 15;

  int? _genPuzzleSize;
  PuzzleDifficulty? _genPuzzleLevel;
  int? _genPuzzleTimeout;

  bool _generating = false;
  bool _generationCancelled = false;
  String? _generationError;
  int _currGenStep = 0;
  int _totalGenSteps = 0;

  BoardViewModel() {
    _loadGenSettings();
  }

  //#region Board Generation

  Future<void> _loadGenSettings() async {
    final settings = await SharedPreferences.getInstance();
    _genPuzzleSize = settings.getInt('genPuzzleSize') ??
        BoardViewModel._defaultGenPuzzleSize;
    final levelIdx = settings.getInt('genPuzzleLevel') ??
        BoardViewModel._defaultGenPuzzleLevel.index;
    _genPuzzleLevel = PuzzleDifficulty.values[levelIdx];
    _genPuzzleTimeout = settings.getInt('genPuzzleTimeout') ??
        BoardViewModel._defaultGenPuzzleTimeout;
  }

  Future<void> _saveGenSettings() async {
    final settings = await SharedPreferences.getInstance();
    settings.setInt('genPuzzleSize', _genPuzzleSize!);
    settings.setInt('genPuzzleLevel', _genPuzzleLevel!.index);
    settings.setInt('genPuzzleTimeout', _genPuzzleTimeout!);
  }

  void generatePuzzle() {
    if (_generating) {
      // Only one puzzle generation is possible at a given time.
      throw Exception("A puzzle generation is already taking place!");
    }
    _generationCancelled = false;
    _generationError = null;
    _generating = true;
    if (_worker == null) {
      _worker = Worker();
      _worker!.init(_handleWorkerMessages,
          _handleGenerationCommands /* runs on the background Isolate managed by the Worker */,
          errorHandler: _handleGenerationError,
          exitHandler: _handleWorkerExit,
          initialMessage: (_genPuzzleLevel, _genPuzzleSize, _genPuzzleTimeout));
    } else {
      _worker!
          .sendMessage((_genPuzzleLevel, _genPuzzleSize, _genPuzzleTimeout));
    }
  }

  void cancelGeneration() {
    if (!_generating) {
      throw Exception("No puzzle generation to be cancelled!");
    }
    // Note: As the generatePuzzle from Fludoku is not cancellable the cancel generation must terminate the worker.
    _worker!.dispose(immediate: true);
    // Nullify our reference - internally the Worker class takes care of closing the isolate's sender port and kill it.
    _worker = null;
    _generationCancelled = true;
    _generating = false;
    notifyListeners();
  }

  void solvePuzzle() {
    if (_generating) {
      // Only one board generation is possible at a given time.
      throw Exception("No puzzle to solve yet!");
    }
    final solutions = findSolutions(_puzzle);
    assert(solutions.length == 1);
    _puzzle = solutions[0];
    notifyListeners();
  }

  /// Handles progress data sent by the Generator worker while generating the board and after it has been
  /// generated.
  ///
  /// Parameters:
  /// - `data`: progress data, a record with three parts, (int currentStep, int totalSteps, Board? genBoard).
  ///           the genBoard will be null during the generation and be the generated board upon successful
  ///           board generation (errors are sent to _handleGenerationError). For a completed board generation
  ///           "final" update the worker will send -1 for both currentStep and totalSteps.
  /// - `workSenderPort`: the port that can be used by the handler to communicate back with the Generator worker.
  ///
  void _handleWorkerMessages(dynamic data, SendPort workerSendPort) {
    var (int currentStep, int totalSteps, Board? genPuzzle) = data;

    if (genPuzzle != null) {
      _puzzle = genPuzzle;
      // Ensures that at the end currentStep equals totalSteps
      _currGenStep = _totalGenSteps;
      _generating = false;
      _generationError = null;
      _generationCancelled = false;
      debugPrint("Generated board:\n$genPuzzle");
    } else {
      _currGenStep = currentStep;
      _totalGenSteps = totalSteps;
    }
    notifyListeners();
  }

  void _handleGenerationError(dynamic data) {
    _generating = false;
    _generationError = data;
    _generationCancelled = false;
    debugPrint("Board generation error: $_generationError");
    notifyListeners();
  }

  void _handleWorkerExit(dynamic data) {
    debugPrint("Generation worker exited: $data");
    _generationCancelled = true;
    _generating = false;
    _generationError = null;
  }

  //#endregion

  Board get puzzle => _puzzle;

  int get genPuzzleSize =>
      _genPuzzleSize ?? BoardViewModel._defaultGenPuzzleSize;
  set genPuzzleSize(int value) {
    if (value != _genPuzzleSize) {
      _genPuzzleSize = value;
      _saveGenSettings();
      notifyListeners();
    }
  }

  PuzzleDifficulty get genPuzzleLevel =>
      _genPuzzleLevel ?? BoardViewModel._defaultGenPuzzleLevel;
  set genPuzzleLevel(PuzzleDifficulty value) {
    if (value != _genPuzzleLevel) {
      _genPuzzleLevel = value;
      _saveGenSettings();
      notifyListeners();
    }
  }

  int get genPuzzleTimeout =>
      _genPuzzleTimeout ?? BoardViewModel._defaultGenPuzzleTimeout;
  set genPuzzleTimeout(int value) {
    if (value != _genPuzzleTimeout) {
      _genPuzzleTimeout = value;
      _saveGenSettings();
      notifyListeners();
    }
  }

  bool get generating => _generating;

  int get currentGenStep => _currGenStep;

  int get totalGenSteps => _totalGenSteps;

  bool get generationCancelled => _generationCancelled;

  String? get generationError => _generationError;
}
