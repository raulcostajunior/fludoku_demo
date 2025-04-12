import 'package:flutter/widgets.dart';
import 'package:fludoku/fludoku.dart';

class BoardProvider extends InheritedWidget {
  final Board _board;

  const BoardProvider({super.key, required super.child, required Board board})
      : _board = board;

  @override
  bool updateShouldNotify(covariant BoardProvider oldWidget) {
    // TODO: implement updateShouldNotify
    throw UnimplementedError();
  }

}