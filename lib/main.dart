import 'package:flutter/material.dart';

void main() {
  runApp(const FludokuDemoApp());
}

class FludokuDemoApp extends StatelessWidget {
  const FludokuDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fludoku Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const BoardPage(title: 'Fludoku Demo'),
    );
  }
}

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
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 2,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.add_box_outlined),
                  tooltip: 'Generate Board',
                  onPressed: () {},
                ),
                const IconButton(
                    icon: Icon(Icons.tips_and_updates_rounded),
                    tooltip: 'Solve Board',
                    onPressed: null),
                IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    tooltip: 'Settings',
                    onPressed: () {}),
              ],
              title: Text(widget.title),
            ),
            body: const Center(
                child: Icon(
              Icons.grid_on_rounded,
              size: 150,
            ))));
  }
}
