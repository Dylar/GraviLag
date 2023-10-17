import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:gravilag/core/gravilag_game.dart';

class GraviLagWidget extends StatefulWidget {
  const GraviLagWidget({super.key});

  @override
  GraviLagWidgetState createState() => GraviLagWidgetState();
}

class GraviLagWidgetState extends State<GraviLagWidget> {
  final game = GraviLagGame();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            // Das Flame Widget, das dein Spiel rendert
            child: GameWidget(game: game),
            // Hier könnten auch zusätzliche Gestenerkennungen hinzugefügt werden
          ),
        ),
        Row(
          children: <Widget>[
            ElevatedButton(
              onPressed: () => setState(() => game.toggleRunning()),
              child: Text(game.isRunning ? "Stop" : "Start"),
            ),
          ],
        ),
      ],
    );
  }
}
