import 'package:flutter/material.dart';
import '../tokens/colors.dart';

class PixelBar extends StatelessWidget {
  /// 0..100
  final double value;
  final Color? color;
  final Color bg;
  final double height;
  const PixelBar({
    super.key,
    this.value = 0,
    this.color,
    this.bg = const Color(0xFF1A1A1A),
    this.height = 14,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? DedsecColors.acid;
    return Container(
      height: height,
      decoration: BoxDecoration(color: bg, border: Border.all(color: Colors.black, width: 1.5)),
      child: Stack(children: [
        AnimatedFractionallySizedBox(
          alignment: Alignment.centerLeft,
          duration: const Duration(milliseconds: 400),
          widthFactor: (value / 100).clamp(0.0, 1.0),
          heightFactor: 1,
          child: CustomPaint(painter: _StripePainter(c)),
        ),
      ]),
    );
  }
}

class _StripePainter extends CustomPainter {
  final Color color;
  _StripePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final base = Paint()..color = color;
    canvas.drawRect(Offset.zero & size, base);
    final stripe = Paint()..color = const Color(0x40000000);
    for (double x = 0; x < size.width; x += 6) {
      canvas.drawRect(Rect.fromLTWH(x, 0, 2, size.height), stripe);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
