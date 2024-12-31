import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'board_settings_material.dart';
import 'board_settings_cupertino.dart';

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
            PlatformIconButton(
                icon: Icon(PlatformIcons(context).addCircledOutline),
                material: (_, __) =>
                    MaterialIconButtonData(tooltip: 'Generate Board'),
                onPressed: () {
                  showPlatformModalSheet(
                      context: context,
                      builder: (context) => PlatformWidget(
                          cupertino: (_, __) => const BoardSettingsCupertino(),
                          material: (_, __) => const BoardSettingsMaterial()));
                }),
            PlatformIconButton(
              icon: Icon(PlatformIcons(context).checkMarkCircledOutline),
              material: (_, __) =>
                  MaterialIconButtonData(tooltip: 'Solve Board'),
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
