import 'package:flutter/widgets.dart';
import 'package:fludoku/fludoku.dart';

// TODO Go full blown on MVVM as we need the Board as a modifiable and
//      observable object. The existing Board provided by the fludoku package
//      can be the model, and a BoardViewModel type should be created. At this
//      point, it seems that having the BoardViewModel launching and communica-
//      ting with an isolate to generate the board in a background and cancella-
//      ble thread is a good approach (the state of the ViewModel should
//      reflect progress and state of the generation process). InheritedWidget
//      can still be used as a convenient encapsulation for ListenableBuilder:
//      allows retrieving the ViewModel from the context instead of having to
//      invoke ListenableBuilder passing the ViewModel as a listenable on every
//      widget interested in the ViewModel.
//      Reference to be used:
//          https://docs.flutter.dev/get-started/fundamentals/state-management
//
class BoardProvider extends InheritedWidget {
  final Board _board;

  const BoardProvider({super.key, required super.child, required Board board})
      : _board = board;

  static Board of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<BoardProvider>();
    if (provider == null) {
      throw Exception("Couldn't find any BoardProvider in the context");
    }
    return provider._board;
  }

  @override
  bool updateShouldNotify(covariant BoardProvider oldWidget) {
    return _board != oldWidget._board;
  }
}
