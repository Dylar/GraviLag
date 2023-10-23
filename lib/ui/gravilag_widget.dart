import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:gravilag/core/gravilag_game.dart';

class GraviLagWidget extends StatefulWidget {
  const GraviLagWidget(this.game, {super.key});

  final GraviLagGame game;

  @override
  GraviLagWidgetState createState() => GraviLagWidgetState();
}

class GraviLagWidgetState extends State<GraviLagWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => widget.game.toggleRunning()),
            child: GameWidget(game: widget.game),
          ),
        ),
      ],
    );
  }
}
