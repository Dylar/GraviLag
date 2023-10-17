import 'package:flame/image_composition.dart';
import 'package:gravilag/data/atom.dart';

class Quadtree {
  final Rect boundary;
  final int capacity;
  final List<Atom> atoms;
  bool divided = false;

  Quadtree? northwest;
  Quadtree? northeast;
  Quadtree? southwest;
  Quadtree? southeast;

  Quadtree(this.boundary, this.capacity) : atoms = [];

  void subdivide() {
    double x = boundary.left;
    double y = boundary.top;
    double w = boundary.width / 2;
    double h = boundary.height / 2;

    northwest = Quadtree(Rect.fromLTWH(x, y, w, h), capacity);
    northeast = Quadtree(Rect.fromLTWH(x + w, y, w, h), capacity);
    southwest = Quadtree(Rect.fromLTWH(x, y + h, w, h), capacity);
    southeast = Quadtree(Rect.fromLTWH(x + w, y + h, w, h), capacity);

    divided = true;
  }

  void insert(Atom atom) {
    if (!boundary.overlaps(atom.toRect())) return;

    if (atoms.length < capacity && !divided) {
      atoms.add(atom);
      return;
    }

    if (!divided) subdivide();

    northwest?.insert(atom);
    northeast?.insert(atom);
    southwest?.insert(atom);
    southeast?.insert(atom);
  }

  List<Atom> query(Rect range, [List<Atom>? found]) {
    found ??= [];

    if (!boundary.overlaps(range)) return found;

    for (var atom in atoms) {
      if (range.overlaps(atom.toRect())) {
        found.add(atom);
      }
    }

    if (divided) {
      northwest?.query(range, found);
      northeast?.query(range, found);
      southwest?.query(range, found);
      southeast?.query(range, found);
    }

    return found;
  }
}
