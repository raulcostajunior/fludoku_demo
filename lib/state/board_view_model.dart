import 'dart:isolate';

import 'package:fludoku/fludoku.dart';
import 'package:flutter/foundation.dart';
import 'package:easy_isolate/easy_isolate.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Handles board generation commands in the isolate kept by the worker internal
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
/// function. We opt for the latter, as it seems to be cleaner.
void _handleGenerationCommands(
    dynamic command, SendPort commandSenderPort, SendErrorFunction sendError) {
  var (PuzzleDifficulty level, int dimension, int timeoutSecs) = command;

  var (Board? genBoard, String? errorMsg) = generateBoard(
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
  Board _board = Board();
  // TODO: Board (in the Sudoku package) must have a special constructor, fromPuzzleBoard
  //       that stores a "baseline", read-only version of the puzzleBoard. There must be
  //       a parameter "verifySolutionUnicity" defaulting to true that checks at construction
  //       time that the puzzleBoard has only one solution (condition to be a true Sudoku
  //       board). The baseline property must be accessible via getter and the new constructor
  //       is the one to be adopted by the application. The "_solvedBoard" machinery must then
  //       be removed from the ViewModel.
  Board? _solvedBoard;
  Worker? _worker;

  static const _defaultGenBoardSize = 9;
  static const _defaultGenBoardLevel = PuzzleDifficulty.medium;
  static const _defaultGenBoardTimeout = 15;

  int? _genBoardSize;
  PuzzleDifficulty? _genBoardLevel;
  int? _genBoardTimeout;

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
    _genBoardSize =
        settings.getInt('genBoardSize') ?? BoardViewModel._defaultGenBoardSize;
    final levelIdx = settings.getInt('genBoardLevel') ??
        BoardViewModel._defaultGenBoardLevel.index;
    _genBoardLevel = PuzzleDifficulty.values[levelIdx];
    _genBoardTimeout = settings.getInt('genBoardTimeout') ??
        BoardViewModel._defaultGenBoardTimeout;
  }

  Future<void> _saveGenSettings() async {
    final settings = await SharedPreferences.getInstance();
    settings.setInt('genBoardSize', _genBoardSize!);
    settings.setInt('genBoardLevel', _genBoardLevel!.index);
    settings.setInt('genBoardTimeout', _genBoardTimeout!);
  }

  void generateBoard() {
    if (_generating) {
      // Only one board generation is possible at a given time.
      throw Exception("A board generation is already taking place!");
    }
    _solvedBoard = null;
    _generationCancelled = false;
    _generationError = null;
    _generating = true;
    if (_worker == null) {
      _worker = Worker();
      _worker!.init(_handleWorkerMessages,
          _handleGenerationCommands /* runs on the background Isolate managed by the Worker */,
          errorHandler: _handleGenerationError,
          exitHandler: _handleWorkerExit,
          initialMessage: (_genBoardLevel, _genBoardSize, _genBoardTimeout));
    } else {
      _worker!.sendMessage((_genBoardLevel, _genBoardSize, _genBoardTimeout));
    }
  }

  void cancelGeneration() {
    if (!_generating) {
      throw Exception("No board generation to be cancelled!");
    }
    // Note: As the generateBoard from Fludoku is not cancellable the cancel generation must terminate the worker.
    _worker!.dispose(immediate: true);
    // Nullify our reference - internally the Worker class takes care of closing the isolate's sender port and kill it.
    _worker = null;
    _generationCancelled = true;
    _generating = false;
    _solvedBoard = null;
    notifyListeners();
  }

  void solveBoard() {
    if (_generating) {
      // Only one board generation is possible at a given time.
      throw Exception("No board to solve yet!");
    }
    final solutions = findSolutions(_board);
    _solvedBoard = solutions[0];
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
    var (int currentStep, int totalSteps, Board? genBoard) = data;

    if (genBoard != null) {
      _board = genBoard;
      _solvedBoard = null;
      // Ensures that at the end currentStep equals totalSteps
      _currGenStep = _totalGenSteps;
      _generating = false;
      _generationError = null;
      _generationCancelled = false;
      debugPrint("Generated board:\n$genBoard");
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
    _solvedBoard = null;
    debugPrint("Board generation error: $_generationError");
    notifyListeners();
  }

  void _handleWorkerExit(dynamic data) {
    debugPrint("Generation worker exited: $data");
    _generationCancelled = true;
    _generating = false;
    _generationError = null;
    _solvedBoard = null;
  }

  //#endregion

  Board get board => _board;
  Board? get solvedBoard => _solvedBoard;

  int get genBoardSize => _genBoardSize ?? BoardViewModel._defaultGenBoardSize;
  set genBoardSize(int value) {
    if (value != _genBoardSize) {
      _genBoardSize = value;
      _saveGenSettings();
      notifyListeners();
    }
  }

  PuzzleDifficulty get genBoardLevel =>
      _genBoardLevel ?? BoardViewModel._defaultGenBoardLevel;
  set genBoardLevel(PuzzleDifficulty value) {
    if (value != _genBoardLevel) {
      _genBoardLevel = value;
      _saveGenSettings();
      notifyListeners();
    }
  }

  int get genBoardTimeout =>
      _genBoardTimeout ?? BoardViewModel._defaultGenBoardTimeout;
  set genBoardTimeout(int value) {
    if (value != _genBoardTimeout) {
      _genBoardTimeout = value;
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
