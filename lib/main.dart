import 'package:flutter/material.dart';
import 'package:gravilag/core/gravilag_game.dart';
import 'package:gravilag/ui/gravilag_widget.dart';

main() => runApp(const GraviLagApp());

class GraviLagApp extends StatefulWidget {
  const GraviLagApp({super.key});

  @override
  State<GraviLagApp> createState() => _GraviLagAppState();
}

class _GraviLagAppState extends State<GraviLagApp> {
  final game = GraviLagGame();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    game.boundary = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    return MaterialApp(
      title: 'Gravity Simulator',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Gravity Simulator'),
          actions: [
            IconButton(
              icon: const Icon(Icons.restart_alt),
              onPressed: game.setUniverse,
            )
          ],
        ),
        body: GraviLagWidget(game),
      ),
    );
  }
}
