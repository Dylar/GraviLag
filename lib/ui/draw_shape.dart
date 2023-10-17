import 'dart:ui';

Future<Image> createCircleImage(double radius, Color color) async {
  final recorder = PictureRecorder();
  final canvas = Canvas(recorder,
      Rect.fromPoints(const Offset(0, 0), Offset(radius * 2, radius * 2)));

  final paint = Paint()..color = color;
  canvas.drawCircle(Offset(radius, radius), radius, paint);

  final picture = recorder.endRecording();
  final img = await picture.toImage(radius.toInt() * 2, radius.toInt() * 2);
  return img;
}
