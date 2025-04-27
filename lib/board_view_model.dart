import 'dart:isolate';

import 'package:fludoku/fludoku.dart';
import 'package:flutter/foundation.dart';
import 'package:easy_isolate/easy_isolate.dart';

/// Handles board generation commands in the isolate kept by the worker internal
/// to the BoardViewModel.
///
/// Parameters:
/// - `command`: the command for the worker - a record with
///              the dimension and the difficulty of the board to be generated.
/// - `commandSenderPort`: a port to communicate back with the command sender.
/// - `sendError`: a function that can be used to send error information back
///                to the command sender without raising an exception (not used)
///
/// As this becomes the listener of the background Isolate kept by the worker,
/// it will be on a thread that is not the one from the Main Isolate (the thread
/// that contains the BoardViewModel instance). As a consequence, this function
/// either had to be a static method of the BoardViewModel (with no access to
/// the data of the BoardViewModel used by the application) or top-level
/// function. We opt for the latter, as it seems to be cleaner.
void _handleGenerationCommands(
    dynamic command, SendPort commandSenderPort, SendErrorFunction sendError) {
  // TODO: handle Generation command sent by the BoardViewModel - the sendError function will be used to communicate timedOutGenerations
}

class BoardViewModel extends ChangeNotifier {
  Board _board = Board();
  Worker? _worker;

  bool _generating = false;
  bool _generationCancelled = false;
  int _currGenStep = 0;
  int _totalGenSteps = 0;

  //#region Board Generation

  void generateBoard(
      {required PuzzleDifficulty level,
      required int dimension,
      int timeoutSecs = 15}) {
    if (_worker == null) {
      _worker = Worker();
      _worker!.init(_handleWorkerMessages,
          _handleGenerationCommands /* runs on the background Isolate managed by the Worker */,
          errorHandler: _handleGenerationError, exitHandler: _handleWorkerExit);
    }
    if (_generating) {
      // Only one board generation is possible at a given time.
      throw Exception("A board generation is already taking place!");
    }
    _generating = true;
    _generationCancelled = false;
    try {
      // TODO: send a message to the worker to trigger a board generation
      _generating = true;
    } finally {
      _generating = false;
    }
  }

  void cancelGeneration() {
    if (!_generating) {
      throw Exception("No board generation to be cancelled!");
    }
    // Note: As the generateBoard is not cancellable the cancel generation must terminate the worker.
    // TODO: dispose the worker (see how safe it is to do it immediately)
  }

  void _handleWorkerMessages(dynamic data, SendPort workerSendPort) {
    // TODO: handle progress messages sent by the Generator worker
  }

  void _handleGenerationError(dynamic data) {
    // TODO: handle generation errors - by setting the proper errMsg on the viewModel state (to be added)
  }

  void _handleWorkerExit(dynamic data) {
    // TODO: investigate if cancellation is the only way to reach this; no exception, except for the timeout, which should be handled by the _handleGenerationError, is expected
    _generationCancelled = true;
    // TODO: handle worker isolate termination - sets the worker back to null (if needed) and
  }

  //#endregion

  Board get board => _board;

  bool get generating => _generating;

  int get currentGenStep => _currGenStep;

  int get totalGenSteps => _totalGenSteps;

  bool get generationCancelled => _generationCancelled;
}
