import 'dart:math';
import 'package:flutter/material.dart';

/// Film-grain noise overlay (deterministic seed).
class Grain extends StatelessWidget {
  final double opacity;
  final int seed;
  const Grain({super.key, this.opacity = 0.08, this.seed = 42});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: opacity,
        child: CustomPaint(painter: _GrainPainter(seed), child: const SizedBox.expand()),
      ),
    );
  }
}

class _GrainPainter extends CustomPainter {
  final int seed;
  _GrainPainter(this.seed);

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = Random(seed);
    final paint = Paint();
    final dots = ((size.width * size.height) / 8).clamp(200, 4000).toInt();
    for (var i = 0; i < dots; i++) {
      final v = rnd.nextInt(255);
      paint.color = Color.fromARGB(rnd.nextInt(120), v, v, v);
      canvas.drawRect(
        Rect.fromLTWH(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height, 1, 1),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
