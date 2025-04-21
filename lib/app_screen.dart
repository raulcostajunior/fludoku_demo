import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'board_settings_material.dart';
import 'board_settings_cupertino.dart';
import 'board_provider.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key, required this.title});

  final String title;

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  void onNewBoardPressed() {
    showPlatformModalSheet(
        context: context,
        material:
            MaterialModalSheetData(showDragHandle: true, useSafeArea: true),
        builder: (context) => PlatformWidget(
            cupertino: (_, __) => const BoardSettingsCupertino(),
            material: (_, __) => const BoardSettingsMaterial()));
  }

  @override
  Widget build(BuildContext context) {
    final boardViewModel = BoardProvider.of(context);
    return ListenableBuilder(
        listenable: boardViewModel,
        builder: (context, _) {
          return PlatformScaffold(
              appBar: PlatformAppBar(
                backgroundColor: Colors.transparent,
                material: (_, __) => MaterialAppBarData(elevation: 2),
                trailingActions: <Widget>[
                  IconButton(
                      icon: PlatformWidget(
                          material: (_, __) =>
                              const Icon(Icons.grid_view_rounded, size: 28),
                          cupertino: (_, __) => const Icon(
                              CupertinoIcons.square_grid_2x2,
                              size: 28)),
                      //const Icon(Icons.grid_on_rounded, size: 28),
                      tooltip: 'Create New Board',
                      onPressed: onNewBoardPressed),
                  IconButton(
                    icon: PlatformWidget(
                        material: (_, __) =>
                            const Icon(Icons.lightbulb_rounded, size: 28),
                        cupertino: (_, __) =>
                            const Icon(CupertinoIcons.lightbulb, size: 28)),
                    tooltip: 'Solve Board',
                    onPressed: null,
                  ),
                ],
                title: Text(widget.title),
              ),
              body: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: PlatformWidget(
                        material: (_, __) =>
                            const Icon(Icons.grid_view_rounded, size: 80),
                        cupertino: (_, __) => const Icon(
                            CupertinoIcons.square_grid_2x2,
                            size: 80)),
                    onPressed: onNewBoardPressed,
                    tooltip: "Create New Board",
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Create New Board",
                    textAlign: TextAlign.center,
                  )
                ],
              )));
        });
  }
}
