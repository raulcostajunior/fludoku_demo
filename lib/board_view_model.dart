import 'dart:isolate';

import 'package:fludoku/fludoku.dart';
import 'package:flutter/foundation.dart';
import 'package:easy_isolate/easy_isolate.dart';

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
  Worker? _worker;

  bool _generating = false;
  bool _generationCancelled = false;
  String? _generationError;
  int _currGenStep = 0;
  int _totalGenSteps = 0;

  //#region Board Generation

  void generateBoard(
      {required PuzzleDifficulty level,
      required int dimension,
      int timeoutSecs = 15}) {
    if (_generating) {
      // Only one board generation is possible at a given time.
      throw Exception("A board generation is already taking place!");
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
          initialMessage: (level, dimension, timeoutSecs));
    } else {
      _worker!.sendMessage((level, dimension, timeoutSecs));
    }
  }

  void cancelGeneration() {
    if (!_generating) {
      throw Exception("No board generation to be cancelled!");
    }
    // Note: As the generateBoard from Fludoku is not cancellable the cancel generation must terminate the worker.
    _worker!.dispose(immediate: true);
    _generationCancelled = true;
    _generating = false;
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
      // Ensures that at the end currentStep equals totalSteps
      _currGenStep = _totalGenSteps;
      _generating = false;
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

  Board get board => _board;

  bool get generating => _generating;

  int get currentGenStep => _currGenStep;

  int get totalGenSteps => _totalGenSteps;

  bool get generationCancelled => _generationCancelled;

  String? get generationError => _generationError;
}
