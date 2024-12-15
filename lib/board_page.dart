import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({super.key, required this.title});

  final String title;

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: PlatformScaffold(
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
            ))));
  }
}
