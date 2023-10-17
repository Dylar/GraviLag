import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:gravilag/core/quadtree.dart';
import 'package:gravilag/data/atom.dart';

const boundary = Rect.fromLTWH(0, 0, 1000, 1000);

class GraviLagGame extends FlameGame {
  bool isRunning = false;
  List<Atom> atoms = [];

  late Quadtree quadtree;

  void toggleRunning() => isRunning = !isRunning;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    quadtree = Quadtree(boundary, 4);
    for (int i = 0; i < 1000; i++) {
      final atom = Atom.random();
      atoms.add(atom);
      quadtree.insert(atom);
      add(atom);
    }
  }

  @override
  void update(double dt) {
    if (isRunning) {
      super.update(dt);
      updateAtoms(dt);
    }
  }

  void updateAtoms(double dt) {
    for (final atom in atoms) {
      double sumOfInfluences = 0;
      for (final other in atoms) {
        if (atom != other) {
          double distance = atom.position.distanceTo(other.position);
          sumOfInfluences +=
              1 / (distance * distance); // Je näher, desto größerer Einfluss
        }
      }
      double minRate = 0.1;
      double maxRate = 3.0;

      double rate = 1.0 / (1.0 + sumOfInfluences);
      atom.updateRate = rate.clamp(minRate, maxRate);
    }

    quadtree = Quadtree(boundary, 4);
    for (Atom atom in atoms) {
      quadtree.insert(atom);
    }
    // Kollisionsprüfung zwischen Atomen (dies ist ein einfacher Ansatz und könnte optimiert werden)
    for (Atom atom in atoms) {
      List<Atom> nearbyAtoms = quadtree.query(atom.toRect());
      for (Atom nearbyAtom in nearbyAtoms) {
        if (atom != nearbyAtom) {
          calculateCollision(atom, nearbyAtom);
        }
      }
    }

    // Aktualisiere die Atome
    for (final atom in atoms) {
      atom.update(dt);
    }
  }

  void calculateCollision(Atom atom1, Atom atom2) {
    if (!atom1.toRect().overlaps(atom2.toRect())) return;

    final now = DateTime.now();
    atom1.lastCollisionTime = now;
    atom2.lastCollisionTime = now;

    Vector2 n = atom2.position.clone()..sub(atom1.position);
    Vector2 un = n.clone()..normalize();
    Vector2 ut = Vector2(-un.y, un.x);

    double v1n = un.dot(atom1.velocity);
    double v1t = ut.dot(atom1.velocity);
    double v2n = un.dot(atom2.velocity);
    double v2t = ut.dot(atom2.velocity);

    double v1tPrime = v1t;
    double v2tPrime = v2t;

    atom1.velocity.setFrom(un
      ..scale(v2n)
      ..add(ut..scale(v1tPrime)));
    atom2.velocity.setFrom(un
      ..scale(v1n)
      ..add(ut..scale(v2tPrime)));
  }
}
