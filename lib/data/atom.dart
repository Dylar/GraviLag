import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gravilag/ui/draw_shape.dart';

class Atom extends SpriteComponent {

  static Atom random(int id) {
    var rnd = Random();
    final pos = Vector2(rnd.nextDouble() * 1000, rnd.nextDouble() * 1000);
    final velo =
        Vector2(10.0 - rnd.nextDouble() * 20, 10.0 - rnd.nextDouble() * 20);
    return Atom(id: id, position: pos, velocity: velo);
  }

  int id;
  double radius;
  Vector2 velocity;
  double updateRate = 1.0;

  DateTime? lastCollisionTime;
  double collisionTimer = 0.0;
  Sprite? greenSprite;
  Sprite? redSprite;

  Atom({
    required this.id,
    required Vector2 position,
    required this.velocity,
    this.radius = 10.0,
  }) : super(
          position: position,
          size: Vector2.all(2 * radius),
        );

  @override
  Future<void> onLoad() async {
    redSprite = Sprite(await createCircleImage(
      radius,
      Colors.red,
      id.toString(),
    ));
    greenSprite = Sprite(await createCircleImage(
      radius,
      Colors.green,
      id.toString(),
    ));
    sprite = greenSprite;
    size = Vector2.all(radius * 2);
  }

  void updateAtoms(double dt, Rect boundary) {
    super.update(dt);
    position += velocity * updateRate * dt;
    _spawnOnOtherSide(boundary);
    _updateColor(dt);
  }

  void _updateColor(double dt) {
    if (collisionTimer > 0.0) {
      collisionTimer -= dt;
      sprite = collisionTimer > 0 ? redSprite : greenSprite;
    }
  }

  void _spawnOnOtherSide(Rect boundary) {
    if (position.x < 0) position.x += boundary.width;
    if (position.x > boundary.width) position.x -= boundary.width;
    if (position.y < 0) position.y += boundary.height;
    if (position.y > boundary.height) position.y -= boundary.height;
  }
}
