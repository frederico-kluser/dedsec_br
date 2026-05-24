import 'package:flutter/material.dart';

/// A dashed border around a child. Used by GhostBtn and any container
/// that needs the cyberpunk dashed look (// comments, hint boxes).
class DashedBox extends StatelessWidget {
  final Widget child;
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashGap;

  const DashedBox({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.strokeWidth = 1,
    this.dashWidth = 4,
    this.dashGap = 3,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedPainter(
        color: color,
        strokeWidth: strokeWidth,
        dashWidth: dashWidth,
        dashGap: dashGap,
      ),
      child: child,
    );
  }
}

class _DashedPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashGap;
  _DashedPainter({required this.color, required this.strokeWidth, required this.dashWidth, required this.dashGap});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    void dashedLine(Offset a, Offset b) {
      final dx = b.dx - a.dx;
      final dy = b.dy - a.dy;
      final dist = (dx.abs() + dy.abs());
      final stepX = dx / dist;
      final stepY = dy / dist;
      double traveled = 0;
      while (traveled < dist) {
        final segLen = (dashWidth).clamp(0.0, dist - traveled);
        canvas.drawLine(
          Offset(a.dx + stepX * traveled, a.dy + stepY * traveled),
          Offset(a.dx + stepX * (traveled + segLen), a.dy + stepY * (traveled + segLen)),
          paint,
        );
        traveled += dashWidth + dashGap;
      }
    }

    final r = Rect.fromLTWH(0, 0, size.width, size.height);
    dashedLine(r.topLeft, r.topRight);
    dashedLine(r.topRight, r.bottomRight);
    dashedLine(r.bottomRight, r.bottomLeft);
    dashedLine(r.bottomLeft, r.topLeft);
  }

  @override
  bool shouldRepaint(_DashedPainter old) =>
      old.color != color ||
      old.dashWidth != dashWidth ||
      old.dashGap != dashGap ||
      old.strokeWidth != strokeWidth;
}
