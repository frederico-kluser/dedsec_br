import 'package:flutter/material.dart';
import '../tokens/colors.dart';

class Eye extends StatelessWidget {
  final double size;
  final Color? color;
  const Eye({super.key, this.size = 16, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _EyePainter(color ?? DedsecColors.acid)),
    );
  }
}

class _EyePainter extends CustomPainter {
  final Color color;
  _EyePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = color;
    final black = Paint()..color = Colors.black;
    final s = size.width / 16;
    void rect(double x, double y, double w, double h, Paint paint) =>
        canvas.drawRect(Rect.fromLTWH(x * s, y * s, w * s, h * s), paint);

    rect(2, 6, 12, 4, p);
    rect(1, 7, 14, 2, p);
    rect(6, 6, 4, 4, black);
    rect(7, 7, 2, 2, p);
  }

  @override
  bool shouldRepaint(_EyePainter old) => old.color != color;
}
