import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/fonts.dart';

/// `atoms/Glitch` — RGB-split text using textShadow analogue.
class Glitch extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final TextStyle Function({double size, Color color, double letterSpacing})? family;

  const Glitch({
    super.key,
    required this.text,
    this.size = 24,
    this.color = COL.ink,
    this.family,
  });

  @override
  Widget build(BuildContext context) {
    final fn = family ?? ({double size = 24, Color color = COL.ink, double letterSpacing = 1}) =>
        FONT.pixel(size: size, color: color, letterSpacing: letterSpacing);
    return Text(
      text,
      style: fn(size: size, color: color, letterSpacing: 1).copyWith(
        shadows: const [
          Shadow(offset: Offset(2, 0), color: COL.magenta),
          Shadow(offset: Offset(-2, 0), color: COL.acid),
        ],
      ),
    );
  }
}

/// `atoms/Wordmark` — "DEDSEC" + "_BR" badge.
class Wordmark extends StatelessWidget {
  final double size;
  final Color color;
  const Wordmark({super.key, this.size = 16, this.color = COL.ink});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text('DEDSEC',
            style: FONT.pixel(size: size, color: color, letterSpacing: 2)),
        SizedBox(width: size * 0.25),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: size * 0.3,
            vertical: size * 0.12,
          ),
          color: COL.magenta,
          child: Text(
            '_BR',
            style: FONT.pixel(size: size * 0.6, color: Colors.black, letterSpacing: 2),
          ),
        ),
      ],
    );
  }
}

/// `atoms/Stencil` — heavy stencil display headline.
class Stencil extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final TextAlign textAlign;
  final List<Shadow> shadows;
  final double height;

  const Stencil(
    this.text, {
    super.key,
    this.size = 40,
    this.color = COL.ink,
    this.textAlign = TextAlign.start,
    this.shadows = const [],
    this.height = 0.95,
  });

  /// Build text widget with optional inline coloured spans.
  /// The original JSX often embeds <span style={{color: ...}}> children;
  /// for the typical case we just pass plain text — call [Stencil.spans] for
  /// multi-colour headlines.
  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      textAlign: textAlign,
      style: FONT.stencil(
        size: size,
        color: color,
        letterSpacing: 1,
        height: height,
        shadows: shadows,
      ),
    );
  }
}

/// Multi-colour stencil headline composed of [TextSpan]s.
class StencilSpans extends StatelessWidget {
  final List<TextSpan> spans;
  final double size;
  final Color baseColor;
  final TextAlign textAlign;
  final List<Shadow> shadows;
  final double height;

  const StencilSpans({
    super.key,
    required this.spans,
    this.size = 40,
    this.baseColor = COL.ink,
    this.textAlign = TextAlign.start,
    this.shadows = const [],
    this.height = 0.95,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        children: spans,
        style: FONT.stencil(
          size: size,
          color: baseColor,
          letterSpacing: 1,
          height: height,
          shadows: shadows,
        ),
      ),
    );
  }
}

/// `atoms/PixelChip` — small pixel-font label.
class PixelChip extends StatelessWidget {
  final String text;
  final Color color;
  final Color bg;
  final double size;
  const PixelChip(
    this.text, {
    super.key,
    this.color = COL.acid,
    this.bg = Colors.black,
    this.size = 9,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(color: bg, border: Border.all(color: color, width: 1)),
      child: Text(text, style: FONT.pixel(size: size, color: color, letterSpacing: 1)),
    );
  }
}

/// `atoms/PixelBar` — chunky progress bar (0-100).
class PixelBar extends StatelessWidget {
  final double value;
  final Color color;
  final Color bg;
  final double height;
  const PixelBar({
    super.key,
    this.value = 0,
    this.color = COL.acid,
    this.bg = const Color(0xFF1A1A1A),
    this.height = 14,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (value.clamp(0, 100)) / 100.0;
    return Container(
      height: height,
      decoration: BoxDecoration(color: bg, border: Border.all(color: Colors.black, width: 1.5)),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: pct,
            child: Container(color: color),
          ),
          // diagonal stripes overlay
          IgnorePointer(
            child: CustomPaint(painter: _PixelBarStripes(opacity: 0.25), child: const SizedBox.expand()),
          ),
        ],
      ),
    );
  }
}

class _PixelBarStripes extends CustomPainter {
  final double opacity;
  _PixelBarStripes({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withValues(alpha: opacity);
    for (var x = 0.0; x < size.width; x += 6) {
      canvas.drawRect(Rect.fromLTWH(x, 0, 2, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _PixelBarStripes oldDelegate) => oldDelegate.opacity != opacity;
}
