import 'package:flutter/material.dart';

/// Radial-dot pattern. Stack on top of any widget with `Positioned.fill`.
class Halftone extends StatelessWidget {
  final Color color;
  final double size;
  final double opacity;
  final Widget? child;
  const Halftone({super.key, this.color = Colors.black, this.size = 4, this.opacity = 0.4, this.child});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: CustomPaint(
        painter: _HalftonePainter(color: color, gap: size),
        child: child ?? const SizedBox.expand(),
      ),
    );
  }
}

class _HalftonePainter extends CustomPainter {
  final Color color;
  final double gap;
  _HalftonePainter({required this.color, required this.gap});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final dotR = 0.6; // ~1.2px diameter
    for (double y = 0; y < size.height; y += gap) {
      for (double x = 0; x < size.width; x += gap) {
        canvas.drawCircle(Offset(x, y), dotR, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_HalftonePainter old) =>
      old.color != color || old.gap != gap;
}
