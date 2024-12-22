import 'package:flutter/cupertino.dart';

class BoardSettingsCupertino extends StatelessWidget {
  const BoardSettingsCupertino({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('New Sudoku Board'),
      ),
      child: Center(
        child: Text('Cupertino Board Settings'),
      ),
    );
  }
}
