import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'board_settings_material.dart';
import 'board_settings_cupertino.dart';

import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key, required this.title});

  final String title;

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        appBar: PlatformAppBar(
          backgroundColor: Colors.transparent,
          material: (_, __) => MaterialAppBarData(elevation: 2),
          trailingActions: <Widget>[
            IconButton(
                icon: Iconify(MaterialSymbols.grid_view_outline_rounded,
                    color: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? Colors.white
                        : Colors.black),
                tooltip: 'New Board',
                onPressed: () {
                  showPlatformModalSheet(
                      context: context,
                      builder: (context) => PlatformWidget(
                          cupertino: (_, __) => const BoardSettingsCupertino(),
                          material: (_, __) => const BoardSettingsMaterial()));
                }),
            IconButton(
              icon: Iconify(MaterialSymbols.tips_and_updates_outline,
                  color: MediaQuery.of(context).platformBrightness ==
                          Brightness.dark
                      ? Colors.white
                      : Colors.black),
              tooltip: 'Solve Board',
              onPressed: null,
            ),
          ],
          title: Text(widget.title),
        ),
        body: Center(
            child: Icon(
          PlatformIcons(context).addCircledOutline,
          size: 150,
        )));
  }
}
