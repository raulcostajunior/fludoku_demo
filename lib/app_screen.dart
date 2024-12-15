import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

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
              onPressed: () {},
            ),
            PlatformIconButton(
              icon: Icon(PlatformIcons(context).checkMarkCircledOutline),
              material: (_, __) =>
                  MaterialIconButtonData(tooltip: 'Solve Board'),
              onPressed: null,
            ),
            PlatformIconButton(
                icon: Icon(PlatformIcons(context).settings),
                material: (_, __) =>
                    MaterialIconButtonData(tooltip: 'Settings'),
                onPressed: () {}),
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
