import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gravilag/ui/draw_shape.dart';

class Atom extends SpriteComponent {
  static Atom random() {
    var rnd = Random();
    final pos = Vector2(rnd.nextDouble() * 1000, rnd.nextDouble() * 1000);
    final velo = Vector2(rnd.nextDouble() * 10, rnd.nextDouble() * 10);
    return Atom(position: pos, velocity: velo);
  }

  final double radius = 1.0;
  Vector2 velocity;
  double updateRate = 1.0;

  DateTime? lastCollisionTime;
  Color color = Colors.green;

  Atom({
    required Vector2 position,
    required this.velocity,
  }) : super(
          position: position,
          size: Vector2.all(2 * 5.0),
        );

  @override
  Future<void> onLoad() async {
    final img = await createCircleImage(radius, Colors.grey);
    sprite = Sprite(img);
    size = Vector2.all(radius * 2);
  }

  @override
  void render(Canvas canvas) {
    paint.color = color;
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Aktualisiere die Position basierend auf Geschwindigkeit und updateRate
    position += velocity * updateRate * dt;

    // spawn on the other side
    if (position.x < 0) position.x += 1000;
    if (position.x > 1000) position.x -= 1000;
    if (position.y < 0) position.y += 1000;
    if (position.y > 1000) position.y -= 1000;

    updateColor();
  }

  void updateColor() {
    if (lastCollisionTime != null) {
      final difference = DateTime.now().difference(lastCollisionTime!).inMilliseconds;
      if (difference < 500) {
        color = Colors.red;
      } else {
        color = Colors.green;
        lastCollisionTime = null; // Setze es zurück, um zukünftige Checks zu vermeiden
      }
    }
  }
}
