import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../design/colors.dart';
import '../design/fonts.dart';

// ─────────────────────────────────────────────────────────────────────
// Halftone — radial-gradient dotted texture
// ─────────────────────────────────────────────────────────────────────
class Halftone extends StatelessWidget {
  const Halftone({
    super.key,
    this.color = Colors.black,
    this.size = 4,
    this.opacity = 0.4,
    this.child,
  });

  final Color color;
  final double size;
  final double opacity;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _HalftonePainter(color: color, cell: size, opacity: opacity),
      child: child,
    );
  }
}

class _HalftonePainter extends CustomPainter {
  _HalftonePainter({required this.color, required this.cell, required this.opacity});
  final Color color;
  final double cell;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withValues(alpha: opacity);
    for (var y = 0.0; y < size.height; y += cell) {
      for (var x = 0.0; x < size.width; x += cell) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HalftonePainter old) =>
      old.color != color || old.cell != cell || old.opacity != opacity;
}

// ─────────────────────────────────────────────────────────────────────
// Scanlines — CRT scanline overlay
// ─────────────────────────────────────────────────────────────────────
class Scanlines extends StatelessWidget {
  const Scanlines({super.key, this.opacity = 0.18});
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _ScanlinesPainter(opacity: opacity),
        size: Size.infinite,
      ),
    );
  }
}

class _ScanlinesPainter extends CustomPainter {
  _ScanlinesPainter({required this.opacity});
  final double opacity;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withValues(alpha: 0.5 * opacity);
    for (var y = 0.0; y < size.height; y += 3) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 1), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ScanlinesPainter old) => old.opacity != opacity;
}

// ─────────────────────────────────────────────────────────────────────
// Grain — film-grain overlay (deterministic noise)
// ─────────────────────────────────────────────────────────────────────
class Grain extends StatelessWidget {
  const Grain({super.key, this.opacity = 0.08});
  final double opacity;
  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: Opacity(
          opacity: opacity,
          child: CustomPaint(painter: _GrainPainter(), size: Size.infinite),
        ),
      );
}

class _GrainPainter extends CustomPainter {
  static final _rng = math.Random(42);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (var i = 0; i < 600; i++) {
      paint.color = Colors.white.withValues(alpha: _rng.nextDouble() * 0.5);
      canvas.drawRect(
        Rect.fromLTWH(_rng.nextDouble() * size.width, _rng.nextDouble() * size.height, 1, 1),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GrainPainter old) => false;
}

// ─────────────────────────────────────────────────────────────────────
// Glitch — RGB-split text
// ─────────────────────────────────────────────────────────────────────
class Glitch extends StatelessWidget {
  const Glitch(
    this.text, {
    super.key,
    this.size = 24,
    this.color = DCol.ink,
  });

  final String text;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: DFont.pixel(
        size: size,
        color: color,
        letterSpacing: 1,
        height: 1,
      ).copyWith(
        shadows: const [
          Shadow(color: DCol.magenta, offset: Offset(2, 0)),
          Shadow(color: DCol.acid, offset: Offset(-2, 0)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Wordmark — DEDSEC + _BR badge
// ─────────────────────────────────────────────────────────────────────
class Wordmark extends StatelessWidget {
  const Wordmark({super.key, this.size = 16, this.color = DCol.ink});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text('DEDSEC', style: DFont.pixel(size: size, color: color, letterSpacing: 2)),
        SizedBox(width: size * 0.25),
        Container(
          color: DCol.magenta,
          padding: EdgeInsets.symmetric(horizontal: size * 0.3, vertical: size * 0.12),
          child: Text('_BR',
              style: DFont.pixel(size: size * 0.6, color: Colors.black, letterSpacing: 1)),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Stencil — Anton uppercase display
// ─────────────────────────────────────────────────────────────────────
class Stencil extends StatelessWidget {
  const Stencil(
    this.text, {
    super.key,
    this.size = 40,
    this.color = DCol.ink,
    this.textAlign,
    this.shadows,
    this.height = 0.9,
  });

  final String text;
  final double size;
  final Color color;
  final TextAlign? textAlign;
  final List<Shadow>? shadows;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      textAlign: textAlign,
      style: DFont.stencil(size: size, color: color, height: height, shadows: shadows),
    );
  }
}

/// Stencil where one mid-line is rendered in a different color
/// (the JSX pattern `LINE1<br/><span style={{color: c}}>LINE2</span>`).
class StencilTwoLine extends StatelessWidget {
  const StencilTwoLine({
    super.key,
    required this.first,
    required this.second,
    this.size = 40,
    this.firstColor = DCol.ink,
    this.secondColor = DCol.magenta,
    this.textAlign,
    this.secondShadows,
    this.height = 0.95,
  });

  final String first;
  final String second;
  final double size;
  final Color firstColor;
  final Color secondColor;
  final TextAlign? textAlign;
  final List<Shadow>? secondShadows;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '${first.toUpperCase()}\n',
            style: DFont.stencil(size: size, color: firstColor, height: height),
          ),
          TextSpan(
            text: second.toUpperCase(),
            style: DFont.stencil(
              size: size,
              color: secondColor,
              height: height,
              shadows: secondShadows,
            ),
          ),
        ],
      ),
      textAlign: textAlign,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// PixelChip — pixel-font label with bordered box
// ─────────────────────────────────────────────────────────────────────
class PixelChip extends StatelessWidget {
  const PixelChip(
    this.text, {
    super.key,
    this.color = DCol.acid,
    this.bg = Colors.black,
    this.size = 9,
  });

  final String text;
  final Color color;
  final Color bg;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: bg, border: Border.all(color: color, width: 1)),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      child: Text(text, style: DFont.pixel(size: size, color: color, letterSpacing: 1)),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// PixelBar — chunky progress bar
// ─────────────────────────────────────────────────────────────────────
class PixelBar extends StatelessWidget {
  const PixelBar({
    super.key,
    required this.value,
    this.color = DCol.acid,
    this.bg = const Color(0xFF1A1A1A),
    this.height = 14,
  });

  final double value; // 0..100
  final Color color;
  final Color bg;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(color: bg, border: Border.all(color: Colors.black, width: 1.5)),
      clipBehavior: Clip.antiAlias,
      child: AnimatedFractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: (value.clamp(0, 100)) / 100,
        duration: const Duration(milliseconds: 400),
        child: CustomPaint(painter: _BarStripesPainter(color: color)),
      ),
    );
  }
}

class _BarStripesPainter extends CustomPainter {
  _BarStripesPainter({required this.color});
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = color);
    final dark = Paint()..color = Colors.black.withValues(alpha: 0.25);
    for (var x = 0.0; x < size.width; x += 6) {
      canvas.drawRect(Rect.fromLTWH(x, 0, 2, size.height), dark);
    }
  }

  @override
  bool shouldRepaint(covariant _BarStripesPainter old) => old.color != color;
}

// ─────────────────────────────────────────────────────────────────────
// Btn — chunky push-button
// ─────────────────────────────────────────────────────────────────────
class Btn extends StatefulWidget {
  const Btn({
    super.key,
    required this.label,
    this.color = DCol.acid,
    this.fg = Colors.black,
    this.full = false,
    this.disabled = false,
    this.onPressed,
  });

  final String label;
  final Color color;
  final Color fg;
  final bool full;
  final bool disabled;
  final VoidCallback? onPressed;

  @override
  State<Btn> createState() => _BtnState();
}

class _BtnState extends State<Btn> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final disabled = widget.disabled || widget.onPressed == null;
    final body = Container(
      width: widget.full ? double.infinity : null,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: widget.color,
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(4, 4), blurRadius: 0),
        ],
      ),
      child: Text(
        widget.label.toUpperCase(),
        textAlign: TextAlign.center,
        style: DFont.pixel(size: 11, color: widget.fg, letterSpacing: 1.5),
      ),
    );
    return Opacity(
      opacity: disabled ? 0.4 : 1,
      child: GestureDetector(
        onTapDown: disabled ? null : (_) => setState(() => _down = true),
        onTapUp: disabled ? null : (_) => setState(() => _down = false),
        onTapCancel: disabled ? null : () => setState(() => _down = false),
        onTap: disabled ? null : widget.onPressed,
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 80),
          offset: _down ? const Offset(0.02, 0.02) : Offset.zero,
          child: body,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// GhostBtn — dashed outline secondary button
// ─────────────────────────────────────────────────────────────────────
class GhostBtn extends StatelessWidget {
  const GhostBtn({
    super.key,
    required this.label,
    this.full = false,
    this.color = DCol.ink,
    this.onPressed,
  });

  final String label;
  final bool full;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: CustomPaint(
        painter: _DashedBorderPainter(color: color),
        child: Container(
          width: full ? double.infinity : null,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          alignment: Alignment.center,
          child: Text(
            label.toUpperCase(),
            style: DFont.pixel(size: 10, color: color, letterSpacing: 1.5),
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, this.dash = 5, this.gap = 4});
  final Color color;
  final double dash;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final rect = Offset.zero & size;
    final path = Path()..addRect(rect);
    final metrics = path.computeMetrics();
    for (final m in metrics) {
      var d = 0.0;
      while (d < m.length) {
        final next = math.min(d + dash, m.length);
        canvas.drawPath(m.extractPath(d, next), paint);
        d = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) => old.color != color;
}

// ─────────────────────────────────────────────────────────────────────
// CautionTape — scrolling diagonal caution band
// ─────────────────────────────────────────────────────────────────────
class CautionTape extends StatefulWidget {
  const CautionTape({
    super.key,
    this.text = 'DEDSEC_BR / DEDSEC_BR / DEDSEC_BR / ',
    this.color = DCol.alert,
  });

  final String text;
  final Color color;

  @override
  State<CautionTape> createState() => _CautionTapeState();
}

class _CautionTapeState extends State<CautionTape> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 20))..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repeated = widget.text * 8;
    return Transform.rotate(
      angle: -1.5 * math.pi / 180,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: -8),
        decoration: BoxDecoration(
          color: widget.color,
          border: const Border.symmetric(horizontal: BorderSide(color: Colors.black, width: 2)),
        ),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 26,
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) {
              return OverflowBox(
                alignment: Alignment.centerLeft,
                maxWidth: double.infinity,
                child: Transform.translate(
                  offset: Offset(-_ctrl.value * 600, 0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      repeated,
                      maxLines: 1,
                      softWrap: false,
                      style: DFont.pixel(size: 10, color: Colors.black, letterSpacing: 2),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Skull / Eye glyphs (pixel SVG → CustomPaint)
// ─────────────────────────────────────────────────────────────────────
class Skull extends StatelessWidget {
  const Skull({super.key, this.size = 20, this.color = DCol.ink});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(size, size), painter: _SkullPainter(color: color));
  }
}

class _SkullPainter extends CustomPainter {
  _SkullPainter({required this.color});
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.width / 16;
    final p = Paint()..color = color;
    final k = Paint()..color = Colors.black;
    void rect(double x, double y, double w, double h, Paint pp) {
      canvas.drawRect(Rect.fromLTWH(x * unit, y * unit, w * unit, h * unit), pp);
    }

    rect(3, 2, 10, 2, p);
    rect(2, 4, 12, 6, p);
    rect(5, 6, 2, 2, k);
    rect(9, 6, 2, 2, k);
    rect(7, 9, 2, 1, k);
    rect(3, 10, 2, 2, p);
    rect(6, 10, 1, 2, p);
    rect(9, 10, 1, 2, p);
    rect(11, 10, 2, 2, p);
    rect(3, 12, 3, 1, p);
    rect(10, 12, 3, 1, p);
  }

  @override
  bool shouldRepaint(covariant _SkullPainter old) => old.color != color;
}

class Eye extends StatelessWidget {
  const Eye({super.key, this.size = 16, this.color = DCol.acid});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(size, size), painter: _EyePainter(color: color));
  }
}

class _EyePainter extends CustomPainter {
  _EyePainter({required this.color});
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.width / 16;
    final p = Paint()..color = color;
    final k = Paint()..color = Colors.black;
    void rect(double x, double y, double w, double h, Paint pp) {
      canvas.drawRect(Rect.fromLTWH(x * unit, y * unit, w * unit, h * unit), pp);
    }

    rect(2, 6, 12, 4, p);
    rect(1, 7, 14, 2, p);
    rect(6, 6, 4, 4, k);
    rect(7, 7, 2, 2, p);
  }

  @override
  bool shouldRepaint(covariant _EyePainter old) => old.color != color;
}

// ─────────────────────────────────────────────────────────────────────
// Avatar — deterministic pixel identicon from a string seed
// (Replaces DiceBear network call so the app runs fully offline.)
// ─────────────────────────────────────────────────────────────────────
class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.seed,
    this.size = 32,
    this.border = true,
    this.bg = const Color(0xFF1C1C1C),
  });

  final String seed;
  final double size;
  final bool border;
  final Color bg;

  static const _palette = [
    DCol.magenta, DCol.acid, DCol.alert, DCol.sources, Color(0xFF1A1A1A),
  ];

  @override
  Widget build(BuildContext context) {
    // Hash the seed deterministically.
    final hash = _hashSeed(seed);
    final fg = _palette[hash % _palette.length];
    final box = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        border: border ? Border.all(color: Colors.black, width: 2) : null,
        boxShadow: border
            ? const [BoxShadow(color: DCol.line, offset: Offset(2, 2), blurRadius: 0)]
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: CustomPaint(
        painter: _IdenticonPainter(seedHash: hash, fg: fg, bg: bg),
        size: Size(size, size),
      ),
    );
    return box;
  }
}

int _hashSeed(String s) {
  var h = 0x811c9dc5;
  for (var i = 0; i < s.length; i++) {
    h ^= s.codeUnitAt(i);
    h = (h * 0x01000193) & 0xFFFFFFFF;
  }
  return h;
}

class _IdenticonPainter extends CustomPainter {
  _IdenticonPainter({required this.seedHash, required this.fg, required this.bg});
  final int seedHash;
  final Color fg;
  final Color bg;

  @override
  void paint(Canvas canvas, Size size) {
    const cols = 5; // 5×5 symmetric
    final cell = size.width / cols;
    final fill = Paint()..color = fg;
    var h = seedHash;
    for (var x = 0; x < (cols / 2).ceil(); x++) {
      for (var y = 0; y < cols; y++) {
        h = (h * 1103515245 + 12345) & 0x7fffffff;
        if (h & 1 == 1) {
          canvas.drawRect(Rect.fromLTWH(x * cell, y * cell, cell, cell), fill);
          // mirror
          final mx = cols - 1 - x;
          if (mx != x) {
            canvas.drawRect(Rect.fromLTWH(mx * cell, y * cell, cell, cell), fill);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _IdenticonPainter old) =>
      old.seedHash != seedHash || old.fg != fg || old.bg != bg;
}
