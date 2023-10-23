// Future<Image> createCircleImage(double radius, Color color) async {
//   final recorder = PictureRecorder();
//   final canvas = Canvas(recorder,
//       Rect.fromPoints(const Offset(0, 0), Offset(radius * 2, radius * 2)));
//
//   final paint = Paint()..color = color;
//   canvas.drawCircle(Offset(radius, radius), radius, paint);
//
//   final picture = recorder.endRecording();
//   final img = await picture.toImage(radius.toInt() * 2, radius.toInt() * 2);
//   return img;
// }

import 'dart:ui' as ui;

import 'package:flutter/material.dart';

Future<ui.Image> createCircleImage(
    double radius, Color color, String number) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder,
      Rect.fromPoints(const Offset(0, 0), Offset(radius * 2, radius * 2)));

  final paint = Paint()..color = color;
  canvas.drawCircle(Offset(radius, radius), radius, paint);

  // Draw the number in the middle
  final textPainter = TextPainter(
    text: TextSpan(
      text: number,
      style: TextStyle(
        color: Colors.amberAccent,
        // You can adjust this to your preferred color
        fontSize: radius, // Adjust font size according to your preference
      ),
    ),
    textDirection: TextDirection.ltr,
  );

  textPainter.layout();
  final offset = Offset(
    radius - textPainter.width / 2,
    radius - textPainter.height / 2,
  );
  textPainter.paint(canvas, offset);

  final picture = recorder.endRecording();
  final img = await picture.toImage(radius.toInt() * 2, radius.toInt() * 2);
  return img;
}
