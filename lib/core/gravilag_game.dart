import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:gravilag/core/quadtree.dart';
import 'package:gravilag/data/atom.dart';

const MAX_SPEED = 50.0;

class GraviLagGame extends FlameGame {
  bool? isRunning;
  List<Atom> atoms = [];

  late Rect boundary;
  late Quadtree quadtree;

  void toggleRunning() => isRunning = !isRunning!;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    setUniverse();
  }

  @override
  void update(double dt) {
    if (isRunning != false) {
      isRunning = true;
      super.update(dt);
      updateAtoms(dt);
    }
  }

  void updateAtoms(double dt) {
    // for (final atom in atoms) {
    //   double sumOfInfluences = 0;
    //   for (final other in atoms) {
    //     if (atom != other) {
    //       double distance = atom.position.distanceTo(other.position);
    //       sumOfInfluences +=
    //           1 / (distance * distance); // Je näher, desto größerer Einfluss
    //     }
    //   }
    //   double minRate = 0.1;
    //   double maxRate = 3.0;
    //
    //   double rate = 1.0 / (1.0 + sumOfInfluences);
    //   atom.updateRate = rate.clamp(minRate, maxRate);
    // }

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
      atom.updateAtoms(dt, boundary);
    }
  }

  // void calculateCollision(Atom atomA, Atom atomB) {
  //   Vector2? contactPoint = getContactPoint(atomA, atomB);
  //
  //   // Wenn kein Kontaktvektor zurückgegeben wird, gibt es keine Kollision
  //   if (contactPoint == null) return;
  //
  //   atomA.collisionTimer = .1;
  //   atomB.collisionTimer = .1;
  //
  //   Vector2 normal = (atomB.position - atomA.position)..normalize();
  //   Vector2 relativeVelocity = atomA.velocity - atomB.velocity;
  //   double velocityAlongNormal = relativeVelocity.dot(normal);
  //
  //   // Überprüfe, ob die Atome sich voneinander wegbewegen
  //   if (velocityAlongNormal > 0) return;
  //
  //   // Reflektiere die Geschwindigkeit entlang des Normalvektors
  //   double j = -2 * relativeVelocity.dot(normal);
  //   Vector2 impulse = normal * j;
  //
  //   atomA.velocity += impulse / 2;
  //   atomB.velocity -= impulse / 2;
  //
  //   // Hier verschieben wir die Atome leicht auseinander, basierend auf dem Kontaktvektor, um den Überlapp zu korrigieren
  //   double correction = (atomA.radius + atomB.radius - atomA.position.distanceTo(atomB.position)) / 2.0;
  //   atomA.position -= normal * correction;
  //   atomB.position += normal * correction;
  //
  //   atomA.lastCollisionTime = DateTime.now();
  //   atomB.lastCollisionTime = atomA.lastCollisionTime;
  // }
  //
  // Vector2? getContactPoint(Atom atomA, Atom atomB) {
  //   Vector2 AB = atomB.position - atomA.position;
  //   double distance = AB.length;
  //
  //   // Wenn die Atome sich nicht berühren oder überlappen, gibt null zurück
  //   if (distance >= atomA.radius + atomB.radius) {
  //     return null;
  //   }
  //
  //   // Normalisierter Vektor von A nach B
  //   Vector2 n = AB.normalized();
  //
  //   // Kontaktvektor, der den Berührungspunkt zwischen A und B repräsentiert
  //   Vector2 contactPoint = atomA.position + n * atomA.radius;
  //
  //   return contactPoint;
  // }


  //
  // void calculateCollision(Atom atomA, Atom atomB) {
  //   double distance = atomA.position.distanceTo(atomB.position);
  //   double combinedRadius = atomA.radius + atomB.radius;
  //
  //   // Überprüfe, ob die Atome sich überlappen
  //   if (distance > combinedRadius) return;
  //
  //   Vector2 normal = (atomB.position - atomA.position)..normalize();
  //   Vector2 relativeVelocity = atomA.velocity - atomB.velocity;
  //   double velocityAlongNormal = relativeVelocity.dot(normal);
  //
  //   // Überprüfe, ob die Atome sich voneinander wegbewegen
  //   if (velocityAlongNormal > 0) return;
  //
  //   // Reflektiere die Geschwindigkeit entlang des Normalvektors
  //   double j = -2 * relativeVelocity.dot(normal);
  //   Vector2 impulse = normal * j;
  //
  //   atomA.velocity +=
  //       impulse / 2; // Da die Masse gleich ist, teilen wir den Impuls
  //   atomB.velocity -= impulse / 2;
  // }


//   void calculateCollision(Atom atomA, Atom atomB) {
//     double distance = atomA.position.distanceTo(atomB.position);
//     double combinedRadius = atomA.radius + atomB.radius;
//
//     // Überprüfe, ob die Atome sich überlappen
//     if (distance > combinedRadius) return;
//
//     atomA.collisionTimer = .1;
//     atomB.collisionTimer = .1;
//
//     // Überprüfe, ob es bereits kürzlich zu einer Kollision kam
//     final now = DateTime.now();
//     if (atomA.lastCollisionTime != null && atomB.lastCollisionTime != null) {
//       if (now.difference(atomA.lastCollisionTime!).inMilliseconds < 400) return;
//       if (now.difference(atomB.lastCollisionTime!).inMilliseconds < 400) return;
//     }
//
//     Vector2 normal = (atomB.position - atomA.position)..normalize();
//     Vector2 relativeVelocity = atomA.velocity - atomB.velocity;
//     double velocityAlongNormal = relativeVelocity.dot(normal);
//
//     double overlap1 = combinedRadius - distance;
//     Vector2 correction = normal * overlap1;
//
// // Korrigieren Sie die Positionen nur so weit wie nötig
//     atomA.position -= correction * (atomA.radius / combinedRadius);
//     atomB.position += correction * (atomB.radius / combinedRadius);
//
//     // Überprüfe, ob die Atome sich voneinander wegbewegen
//     if (velocityAlongNormal > 0) return;
//
//     // Reflektiere die Geschwindigkeit entlang des Normalvektors
//     double j = -2 * relativeVelocity.dot(normal);
//     Vector2 impulse = normal * j;
//
//     atomA.velocity +=
//         impulse / 2; // Da die Masse gleich ist, teilen wir den Impuls
//     atomB.velocity -= impulse / 2;
//
//     // Aktualisiere die Zeit der letzten Kollision
//     atomA.lastCollisionTime = now;
//     atomB.lastCollisionTime = now;
//
//     // Abstoßungsvektor hinzufügen, um Überlappung zu verhindern
//     double overlap = combinedRadius - distance;
//     Vector2 repulsionVector = normal * overlap;
//     atomA.position -= repulsionVector * 0.5;
//     atomB.position += repulsionVector * 0.5;
//   }
  //
  // void calculateCollision(Atom atomA, Atom atomB) {
  //   double distance = atomA.position.distanceTo(atomB.position);
  //   double combinedRadius = atomA.radius + atomB.radius;
  //
  //   // Überprüfe, ob die Atome sich überlappen
  //   if (distance > combinedRadius) return;
  //
  //   atomA.collisionTimer = .1;
  //   atomB.collisionTimer = .1;
  //
  //   // Überprüfe, ob es bereits kürzlich zu einer Kollision kam
  //   final now = DateTime.now();
  //   if (atomA.lastCollisionTime != null && atomB.lastCollisionTime != null) {
  //     if (now.difference(atomA.lastCollisionTime!).inMilliseconds < 400) return;
  //     if (now.difference(atomB.lastCollisionTime!).inMilliseconds < 400) return;
  //   }
  //
  //   Vector2 normal = (atomB.position - atomA.position)..normalize();
  //   Vector2 relativeVelocity = atomA.velocity - atomB.velocity;
  //   double velocityAlongNormal = relativeVelocity.dot(normal);
  //
  //   // Überprüfe, ob die Atome sich voneinander wegbewegen
  //   if (velocityAlongNormal > 0) return;
  //
  //   // Reflektiere die Geschwindigkeit entlang des Normalvektors
  //   double j = -2 * relativeVelocity.dot(normal);
  //   Vector2 impulse = normal * j;
  //
  //   atomA.velocity +=
  //       impulse / 2; // Da die Masse gleich ist, teilen wir den Impuls
  //   atomB.velocity -= impulse / 2;
  //
  //   // Aktualisiere die Zeit der letzten Kollision
  //   atomA.lastCollisionTime = now;
  //   atomB.lastCollisionTime = now;
  //
  //   // Abstoßungsvektor hinzufügen, um Überlappung zu verhindern
  //   double overlap = combinedRadius - distance;
  //   Vector2 repulsionVector = normal * overlap;
  //   atomA.position -= repulsionVector * 0.5;
  //   atomB.position += repulsionVector * 0.5;
  // }

  // void calculateCollision(Atom atomA, Atom atomB) {
  //   Pair<Atom, Atom> pair = Pair(atomA, atomB);
  //   if (lastCollisions.containsKey(pair)) {
  //     DateTime lastCollisionTime = lastCollisions[pair]!;
  //     if (DateTime.now().difference(lastCollisionTime) < Duration(milliseconds: 500)) {
  //       return;  // Überspringe die Kollision, wenn die Cooldown-Zeit noch nicht abgelaufen ist
  //     }
  //   }
  //   // Der restliche Code ...
  //   lastCollisions[pair] = DateTime.now();  // Aktualisiere den Zeitpunkt der letzten Kollision
  // }

  void calculateCollision(Atom atomA, Atom atomB) {
    // Schritt 1: Berechne den Normalvektor
    Vector2 n = atomB.position - atomA.position;
    double distance = atomA.position.distanceTo(atomB.position);

    // Überprüfe, ob die Atome sich überlappen
    if (distance > atomA.radius + atomB.radius) return;
    atomA.collisionTimer = .1;
    atomB.collisionTimer = .1;

    // Schritt 2: Berechne die relative Geschwindigkeit entlang des Normalvektors
    Vector2 relativeVelocity = atomA.velocity - atomB.velocity;
    double velocityAlongNormal = relativeVelocity.dot(n.normalized());

    // Überprüfe, ob die Atome sich voneinander wegbewegen
    if (velocityAlongNormal > 0) return;

    // Schritt 3: Berechne den Impuls
    double j = -2 * velocityAlongNormal;

    // Schritt 4: Wende den Impuls auf die Geschwindigkeiten an
    atomA.velocity.add(n.normalized()..scale(j));
    atomB.velocity.sub(n.normalized()..scale(j));

    // Schritt 5: Maximalgeschwindigkeit überprüfen
    atomA.velocity.clampLength(-MAX_SPEED, MAX_SPEED);
    atomB.velocity.clampLength(-MAX_SPEED, MAX_SPEED);

    // Schritt 6: Positionsanpassung, um überlappende Atome zu verhindern
    double overlap = (atomA.radius + atomB.radius) - distance;
    atomA.position -= n.normalized()..scale(overlap / 2.0);
    atomB.position += n.normalized()..scale(overlap / 2.0);
  }

  // void calculateCollision(Atom atomA, Atom atomB) {
  //   double distance = atomA.position.distanceTo(atomB.position);
  //   double combinedRadius = atomA.radius + atomB.radius;
  //
  //   if (distance > combinedRadius) return;
  //
  //   atomA.collisionTimer = .15;
  //   atomB.collisionTimer = .15;
  //
  //   Vector2 normal = (atomB.position - atomA.position)..normalize();
  //   double overlap = combinedRadius - distance;
  //
  //   atomA.position -= normal * (overlap / 2.0);
  //   atomB.position += normal * (overlap / 2.0);
  //
  //   Vector2 relativeVelocity = atomA.velocity - atomB.velocity;
  //   double velocityAlongNormal = relativeVelocity.dot(normal);
  //
  //   if (velocityAlongNormal > 0) return;
  //
  //   double j = -2 * velocityAlongNormal / 2.0;
  //   Vector2 impulse = normal * j;
  //
  //   atomA.velocity -= impulse;
  //   atomB.velocity += impulse;
  //
  //   // // Maximalgeschwindigkeit überprüfen
  //   // atomA.velocity.clampLength(-MAX_SPEED, MAX_SPEED);
  //   // atomB.velocity.clampLength(-MAX_SPEED, MAX_SPEED);
  // }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    boundary = Rect.fromLTWH(0, 0, size.x, size.y);
  }

  void setUniverse() {
    removeAll(atoms);
    atoms = [];
    quadtree = Quadtree(boundary, 4);
    // for (int i = 0; i < 20; i++) {
    //   final atom = Atom.random(i);
    //   addAtom(atom);
    // }
    var posX = boundary.width / 2;
    var posY = boundary.height / 3;
    final atom1 = Atom(
      id: 1,
      position: Vector2(posX-10, posY),
      velocity: Vector2(0, 30),
    );
    final atom2 = Atom(
      id: 2,
      position: Vector2(posX, boundary.height - posY),
      velocity: Vector2(0, -40),
    );
    _addAtom(atom1);
    _addAtom(atom2);
    isRunning = null;
  }

  void _addAtom(Atom atom) {
    atoms.add(atom);
    quadtree.insert(atom);
    add(atom);
  }
}
