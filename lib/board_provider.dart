import 'package:flutter/widgets.dart';
import 'board_view_model.dart';

class BoardProvider extends InheritedWidget {
  final BoardViewModel _viewModel;

  const BoardProvider(
      {super.key, required super.child, required BoardViewModel viewModel})
      : _viewModel = viewModel;

  static BoardViewModel of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<BoardProvider>();
    if (provider == null) {
      throw Exception("Couldn't find any BoardProvider in the context");
    }
    return provider._viewModel;
  }

  @override
  bool updateShouldNotify(covariant BoardProvider oldWidget) {
    return _viewModel != oldWidget._viewModel;
  }
}
