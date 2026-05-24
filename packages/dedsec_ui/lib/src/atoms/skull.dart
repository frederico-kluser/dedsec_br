import 'package:flutter/material.dart';
import '../tokens/colors.dart';

/// Original 16x16 pixel skull glyph (NOT a Watch_Dogs / Ubisoft asset).
class Skull extends StatelessWidget {
  final double size;
  final Color? color;
  const Skull({super.key, this.size = 20, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _SkullPainter(color ?? DedsecColors.ink)),
    );
  }
}

class _SkullPainter extends CustomPainter {
  final Color color;
  _SkullPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final black = Paint()..color = Colors.black;
    final s = size.width / 16;
    void rect(double x, double y, double w, double h, Paint p) =>
        canvas.drawRect(Rect.fromLTWH(x * s, y * s, w * s, h * s), p);

    rect(3, 2, 10, 2, paint);
    rect(2, 4, 12, 6, paint);
    rect(5, 6, 2, 2, black);
    rect(9, 6, 2, 2, black);
    rect(7, 9, 2, 1, black);
    rect(3, 10, 2, 2, paint);
    rect(6, 10, 1, 2, paint);
    rect(9, 10, 1, 2, paint);
    rect(11, 10, 2, 2, paint);
    rect(3, 12, 3, 1, paint);
    rect(10, 12, 3, 1, paint);
  }

  @override
  bool shouldRepaint(_SkullPainter old) => old.color != color;
}
