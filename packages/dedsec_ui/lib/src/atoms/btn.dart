import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';

/// Chunky push-button with offset 4px black shadow.
class Btn extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? color;
  final Color fg;
  final bool full;
  final bool disabled;
  final EdgeInsets padding;
  final double fontSize;
  final Widget? child;

  const Btn({
    super.key,
    required this.label,
    this.onPressed,
    this.color,
    this.fg = Colors.black,
    this.full = false,
    this.disabled = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
    this.fontSize = 11,
    this.child,
  });

  @override
  State<Btn> createState() => _BtnState();
}

class _BtnState extends State<Btn> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? DedsecColors.acid;
    final disabled = widget.disabled || widget.onPressed == null;

    Widget btn = Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: color,
        boxShadow: _down
            ? const []
            : const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
      ),
      child: widget.child ??
          Text(
            widget.label.toUpperCase(),
            textAlign: TextAlign.center,
            style: DedsecFonts.pixel(size: widget.fontSize, color: widget.fg, letterSpacing: 1.5),
          ),
    );

    btn = Transform.translate(
      offset: _down ? const Offset(2, 2) : Offset.zero,
      child: btn,
    );

    btn = Opacity(opacity: disabled ? 0.4 : 1, child: btn);

    btn = GestureDetector(
      onTapDown: disabled ? null : (_) => setState(() => _down = true),
      onTapCancel: disabled ? null : () => setState(() => _down = false),
      onTapUp: disabled ? null : (_) => setState(() => _down = false),
      onTap: disabled ? null : widget.onPressed,
      child: btn,
    );

    if (widget.full) return SizedBox(width: double.infinity, child: btn);
    return btn;
  }
}
