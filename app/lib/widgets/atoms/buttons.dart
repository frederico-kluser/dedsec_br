import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/fonts.dart';

/// `atoms/Btn` — chunky push-button with offset shadow.
class Btn extends StatefulWidget {
  final Widget child;
  final Color color;
  final Color fg;
  final VoidCallback? onPressed;
  final bool full;
  final bool disabled;
  final EdgeInsetsGeometry padding;

  const Btn({
    super.key,
    required this.child,
    this.color = COL.acid,
    this.fg = Colors.black,
    this.onPressed,
    this.full = false,
    this.disabled = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
  });

  @override
  State<Btn> createState() => _BtnState();
}

class _BtnState extends State<Btn> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final disabled = widget.disabled || widget.onPressed == null;
    final child = DefaultTextStyle(
      style: FONT.pixel(
        size: 11,
        color: widget.fg,
        letterSpacing: 1.5,
      ),
      child: widget.child,
    );

    Widget btn = AnimatedSlide(
      offset: _pressed ? const Offset(0.04, 0.04) : Offset.zero,
      duration: const Duration(milliseconds: 80),
      child: Container(
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.color,
          boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
        ),
        child: child,
      ),
    );

    btn = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: disabled ? null : (_) => setState(() => _pressed = true),
      onTapUp: disabled ? null : (_) => setState(() => _pressed = false),
      onTapCancel: disabled ? null : () => setState(() => _pressed = false),
      onTap: disabled ? null : widget.onPressed,
      child: btn,
    );

    if (disabled) {
      btn = Opacity(opacity: 0.4, child: btn);
    }

    if (widget.full) {
      btn = SizedBox(width: double.infinity, child: btn);
    }
    return btn;
  }
}

/// `atoms/GhostBtn` — dashed-outline secondary button.
class GhostBtn extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool full;
  final Color color;
  final EdgeInsetsGeometry padding;

  const GhostBtn({
    super.key,
    required this.child,
    this.onPressed,
    this.full = false,
    this.color = COL.ink,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    Widget btn = GestureDetector(
      onTap: onPressed,
      child: CustomPaint(
        painter: _DashedBorder(color: color),
        child: Padding(
          padding: padding,
          child: DefaultTextStyle(
            style: FONT.pixel(size: 10, color: color, letterSpacing: 1.5),
            child: child,
          ),
        ),
      ),
    );
    if (full) btn = SizedBox(width: double.infinity, child: btn);
    return btn;
  }
}

class _DashedBorder extends CustomPainter {
  final Color color;
  _DashedBorder({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    const dash = 6.0;
    const gap = 4.0;
    final rect = Offset.zero & size;
    _drawDashedLine(canvas, paint, rect.topLeft, rect.topRight, dash, gap);
    _drawDashedLine(canvas, paint, rect.topRight, rect.bottomRight, dash, gap);
    _drawDashedLine(canvas, paint, rect.bottomRight, rect.bottomLeft, dash, gap);
    _drawDashedLine(canvas, paint, rect.bottomLeft, rect.topLeft, dash, gap);
  }

  void _drawDashedLine(Canvas canvas, Paint paint, Offset from, Offset to, double dash, double gap) {
    final dx = to.dx - from.dx;
    final dy = to.dy - from.dy;
    final dist = (dx * dx + dy * dy).clamp(1, double.infinity);
    final len = dist == 1 ? 0 : (dx * dx + dy * dy);
    final length = len == 0 ? 0 : (dx.abs() + dy.abs());
    if (length == 0) return;
    final ux = dx / length;
    final uy = dy / length;
    var travelled = 0.0;
    var draw = true;
    var x = from.dx, y = from.dy;
    while (travelled < length) {
      final step = (draw ? dash : gap).clamp(0, length - travelled).toDouble();
      final nx = x + ux * step;
      final ny = y + uy * step;
      if (draw) canvas.drawLine(Offset(x, y), Offset(nx, ny), paint);
      x = nx;
      y = ny;
      travelled += step;
      draw = !draw;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorder old) => old.color != color;
}
