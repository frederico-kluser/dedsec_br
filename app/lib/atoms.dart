// atoms.dart — 14 leaf widgets (Halftone, Grain, Scanlines, Glitch, Wordmark,
// Stencil, PixelChip, PixelBar, Btn, GhostBtn, CautionTape, Skull, Eye, Avatar).
//
// Each widget mirrors src/atoms/<Name>/index.jsx. Painters reproduce the CSS
// patterns (radial-gradient halftone, repeating-linear scanlines, etc.).

import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'design.dart';

// ─── Halftone — radial-gradient dotted texture ────────────────────────────
class Halftone extends StatelessWidget {
  final Color color;
  final double size;
  final double opacity;
  final Widget? child;
  const Halftone({super.key, this.color = Colors.black, this.size = 4, this.opacity = 0.4, this.child});
  @override
  Widget build(BuildContext c) => Opacity(
        opacity: opacity,
        child: CustomPaint(painter: _HalftonePainter(color, size), child: child ?? const SizedBox.expand()),
      );
}

class _HalftonePainter extends CustomPainter {
  final Color color; final double tile;
  _HalftonePainter(this.color, this.tile);
  @override
  void paint(Canvas canvas, Size sz) {
    final paint = Paint()..color = color;
    for (var y = 0.0; y < sz.height; y += tile) {
      for (var x = 0.0; x < sz.width; x += tile) {
        canvas.drawCircle(Offset(x, y), 1.2, paint);
      }
    }
  }
  @override
  bool shouldRepaint(_HalftonePainter old) => old.color != color || old.tile != tile;
}

// ─── Grain — fake film-grain noise overlay ────────────────────────────────
class Grain extends StatelessWidget {
  final double opacity;
  const Grain({super.key, this.opacity = 0.08});
  @override
  Widget build(BuildContext c) => IgnorePointer(
        child: Opacity(opacity: opacity, child: CustomPaint(painter: _GrainPainter(), child: const SizedBox.expand())),
      );
}

class _GrainPainter extends CustomPainter {
  static final _rng = math.Random(42);
  @override
  void paint(Canvas canvas, Size sz) {
    final paint = Paint();
    final n = (sz.width * sz.height / 18).toInt();
    for (var i = 0; i < n; i++) {
      paint.color = Color.fromRGBO(255, 255, 255, _rng.nextDouble() * 0.18);
      canvas.drawRect(Rect.fromLTWH(_rng.nextDouble() * sz.width, _rng.nextDouble() * sz.height, 1, 1), paint);
    }
  }
  @override
  bool shouldRepaint(_GrainPainter old) => false;
}

// ─── Scanlines — CRT scanlines ────────────────────────────────────────────
class Scanlines extends StatelessWidget {
  final double opacity;
  const Scanlines({super.key, this.opacity = 0.18});
  @override
  Widget build(BuildContext c) => IgnorePointer(
        child: Opacity(opacity: opacity, child: CustomPaint(painter: _ScanlinesPainter(), child: const SizedBox.expand())),
      );
}

class _ScanlinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size sz) {
    final p = Paint()..color = const Color(0x80000000);
    for (var y = 0.0; y < sz.height; y += 3) {
      canvas.drawRect(Rect.fromLTWH(0, y, sz.width, 1), p);
    }
  }
  @override
  bool shouldRepaint(_ScanlinesPainter old) => false;
}

// ─── Glitch — RGB-split text ──────────────────────────────────────────────
class Glitch extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final TextStyle? style;
  const Glitch(this.text, {super.key, this.size = 24, this.color = Col.ink, this.style});
  @override
  Widget build(BuildContext c) {
    final base = (style ?? Fonts.pixel(size: size, color: color, letterSpacing: 1)).copyWith(
      shadows: const [
        Shadow(offset: Offset(2, 0), color: Col.magenta),
        Shadow(offset: Offset(-2, 0), color: Col.acid),
      ],
    );
    return Text(text, style: base);
  }
}

// ─── Wordmark — DEDSEC + _BR pill ─────────────────────────────────────────
class Wordmark extends StatelessWidget {
  final double size;
  final Color color;
  const Wordmark({super.key, this.size = 16, this.color = Col.ink});
  @override
  Widget build(BuildContext c) => Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('DEDSEC', style: Fonts.pixel(size: size, color: color, letterSpacing: 2)),
          SizedBox(width: size * 0.25),
          Container(
            padding: EdgeInsets.symmetric(horizontal: size * 0.3, vertical: size * 0.12),
            color: Col.magenta,
            child: Text('_BR', style: Fonts.pixel(size: size * 0.6, color: Colors.black, letterSpacing: 1)),
          ),
        ],
      );
}

// ─── Stencil — chunky display headline ────────────────────────────────────
class Stencil extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final TextAlign align;
  final List<Shadow> shadows;
  const Stencil(this.text, {super.key, this.size = 40, this.color = Col.ink, this.align = TextAlign.left, this.shadows = const []});
  @override
  Widget build(BuildContext c) => Text(
        text.toUpperCase(),
        textAlign: align,
        style: Fonts.stencil(size: size, color: color, height: 0.9, letterSpacing: 1).copyWith(shadows: shadows),
      );
}

/// Variant accepting an arbitrary rich TextSpan (for two-color headlines).
class StencilSpan extends StatelessWidget {
  final InlineSpan span;
  final double size;
  final TextAlign align;
  const StencilSpan(this.span, {super.key, this.size = 40, this.align = TextAlign.left});
  @override
  Widget build(BuildContext c) => Text.rich(span, textAlign: align, style: Fonts.stencil(size: size, height: 0.9, letterSpacing: 1));
}

// ─── PixelChip — small pixel-font label ───────────────────────────────────
class PixelChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color bg;
  final double size;
  const PixelChip(this.label, {super.key, this.color = Col.acid, this.bg = Colors.black, this.size = 9});
  @override
  Widget build(BuildContext c) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
        decoration: BoxDecoration(color: bg, border: Border.all(color: color, width: 1)),
        child: Text(label, style: Fonts.pixel(size: size, color: color, letterSpacing: 1)),
      );
}

// ─── PixelBar — chunky progress bar ───────────────────────────────────────
class PixelBar extends StatelessWidget {
  final double value;
  final Color color;
  final Color bg;
  final double height;
  const PixelBar({super.key, this.value = 0, this.color = Col.acid, this.bg = const Color(0xFF1A1A1A), this.height = 14});
  @override
  Widget build(BuildContext c) => Container(
        height: height,
        decoration: BoxDecoration(color: bg, border: Border.all(color: Colors.black, width: 1.5)),
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: (value / 100).clamp(0, 1),
            child: AnimatedContainer(duration: const Duration(milliseconds: 400), color: color),
          ),
        ),
      );
}

// ─── Btn — chunky push-button with offset shadow ──────────────────────────
class Btn extends StatefulWidget {
  final String label;
  final Color color;
  final Color fg;
  final VoidCallback? onTap;
  final bool full;
  final bool disabled;
  const Btn(this.label, {super.key, this.color = Col.acid, this.fg = Colors.black, this.onTap, this.full = false, this.disabled = false});
  @override
  State<Btn> createState() => _BtnState();
}

class _BtnState extends State<Btn> {
  bool _down = false;
  @override
  Widget build(BuildContext c) {
    final body = AnimatedContainer(
      duration: const Duration(milliseconds: 80),
      transform: Matrix4.translationValues(_down ? 2 : 0, _down ? 2 : 0, 0),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: widget.disabled ? widget.color.withValues(alpha: 0.4) : widget.color,
        boxShadow: const [BoxShadow(offset: Offset(4, 4), color: Colors.black)],
      ),
      child: Text(widget.label.toUpperCase(),
          textAlign: TextAlign.center,
          style: Fonts.pixel(size: 11, color: widget.fg, letterSpacing: 1.5)),
    );
    final w = widget.full ? SizedBox(width: double.infinity, child: body) : body;
    return GestureDetector(
      onTapDown: widget.disabled ? null : (_) => setState(() => _down = true),
      onTapUp: widget.disabled ? null : (_) => setState(() => _down = false),
      onTapCancel: widget.disabled ? null : () => setState(() => _down = false),
      onTap: widget.disabled ? null : widget.onTap,
      child: w,
    );
  }
}

// ─── GhostBtn — dashed-outline secondary button ───────────────────────────
class GhostBtn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final bool full;
  const GhostBtn(this.label, {super.key, this.color = Col.ink, this.onTap, this.full = false});
  @override
  Widget build(BuildContext c) {
    final body = DashedBox(
      color: color, width: 1.5,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(label.toUpperCase(),
            textAlign: TextAlign.center,
            style: Fonts.pixel(size: 10, color: color, letterSpacing: 1.5)),
      ),
    );
    final w = full ? SizedBox(width: double.infinity, child: body) : body;
    return GestureDetector(onTap: onTap, child: w);
  }
}

/// Dashed-border wrapper (Flutter has no built-in dashed BoxDecoration).
/// Wrap any widget with DashedBox to paint a dashed outline around it.
class DashedBox extends StatelessWidget {
  final Widget child;
  final Color color;
  final double width;
  final double dash;
  final double gap;
  const DashedBox({super.key, required this.child, this.color = Col.line, this.width = 1, this.dash = 5, this.gap = 4});
  @override
  Widget build(BuildContext c) => CustomPaint(
        foregroundPainter: _DashedPainter(color, width, dash, gap),
        child: child,
      );
}

class _DashedPainter extends CustomPainter {
  final Color color; final double width; final double dash; final double gap;
  _DashedPainter(this.color, this.width, this.dash, this.gap);
  @override
  void paint(Canvas canvas, Size sz) {
    final paint = Paint()..color = color..strokeWidth = width..style = PaintingStyle.stroke;
    final path = Path()..addRect(Rect.fromLTWH(0, 0, sz.width, sz.height));
    for (final metric in path.computeMetrics()) {
      var dist = 0.0;
      while (dist < metric.length) {
        final next = math.min(dist + dash, metric.length);
        canvas.drawPath(metric.extractPath(dist, next), paint);
        dist = next + gap;
      }
    }
  }
  @override
  bool shouldRepaint(_DashedPainter old) => old.color != color || old.width != width;
}

// ─── CautionTape — scrolling diagonal warning band ────────────────────────
class CautionTape extends StatefulWidget {
  final String text;
  final Color color;
  const CautionTape({super.key, this.text = 'DEDSEC_BR / DEDSEC_BR / DEDSEC_BR / ', this.color = Col.alert});
  @override
  State<CautionTape> createState() => _CautionTapeState();
}

class _CautionTapeState extends State<CautionTape> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 20))..repeat();
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext c) {
    final repeated = widget.text * 8;
    return Transform.rotate(
      angle: -1.5 * math.pi / 180,
      child: Container(
        decoration: BoxDecoration(
          color: widget.color,
          border: const Border(top: BorderSide(width: 2), bottom: BorderSide(width: 2)),
        ),
        height: 26,
        clipBehavior: Clip.hardEdge,
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) => Transform.translate(
            offset: Offset(-MediaQuery.of(c).size.width * _ctrl.value, 0),
            child: Text(repeated,
                maxLines: 1, overflow: TextOverflow.visible,
                style: Fonts.pixel(size: 10, color: Colors.black, letterSpacing: 2)),
          ),
        ),
      ),
    );
  }
}

// ─── Skull — 16×16 pixel skull glyph ─────────────────────────────────────
class Skull extends StatelessWidget {
  final double size;
  final Color color;
  const Skull({super.key, this.size = 20, this.color = Col.ink});
  @override
  Widget build(BuildContext c) =>
      SizedBox(width: size, height: size, child: CustomPaint(painter: _SkullPainter(color)));
}

class _SkullPainter extends CustomPainter {
  final Color color;
  _SkullPainter(this.color);
  @override
  void paint(Canvas canvas, Size sz) {
    final unit = sz.width / 16;
    final c = Paint()..color = color;
    final k = Paint()..color = Colors.black;
    void cell(Paint p, int x, int y, int w, int h) =>
        canvas.drawRect(Rect.fromLTWH(x * unit, y * unit, w * unit, h * unit), p);
    cell(c, 3, 2, 10, 2);
    cell(c, 2, 4, 12, 6);
    cell(k, 5, 6, 2, 2);
    cell(k, 9, 6, 2, 2);
    cell(k, 7, 9, 2, 1);
    cell(c, 3, 10, 2, 2);
    cell(c, 6, 10, 1, 2);
    cell(c, 9, 10, 1, 2);
    cell(c, 11, 10, 2, 2);
    cell(c, 3, 12, 3, 1);
    cell(c, 10, 12, 3, 1);
  }
  @override
  bool shouldRepaint(_SkullPainter old) => old.color != color;
}

// ─── Eye — surveillance eye glyph ────────────────────────────────────────
class Eye extends StatelessWidget {
  final double size;
  final Color color;
  const Eye({super.key, this.size = 16, this.color = Col.acid});
  @override
  Widget build(BuildContext c) => SizedBox(width: size, height: size, child: CustomPaint(painter: _EyePainter(color)));
}

class _EyePainter extends CustomPainter {
  final Color color;
  _EyePainter(this.color);
  @override
  void paint(Canvas canvas, Size sz) {
    final unit = sz.width / 16;
    final cP = Paint()..color = color;
    final kP = Paint()..color = Colors.black;
    void cell(Paint p, int x, int y, int w, int h) =>
        canvas.drawRect(Rect.fromLTWH(x * unit, y * unit, w * unit, h * unit), p);
    cell(cP, 2, 6, 12, 4);
    cell(cP, 1, 7, 14, 2);
    cell(kP, 6, 6, 4, 4);
    cell(cP, 7, 7, 2, 2);
  }
  @override
  bool shouldRepaint(_EyePainter old) => old.color != color;
}

// ─── Avatar — DiceBear identicon (network fetch with seeded fallback) ────
class Avatar extends StatelessWidget {
  final String seed;
  final double size;
  final bool border;
  final Color bg;
  const Avatar({super.key, this.seed = 'anon', this.size = 32, this.border = true, this.bg = const Color(0xFF1C1C1C)});

  @override
  Widget build(BuildContext c) {
    final url = 'https://api.dicebear.com/9.x/identicon/png?seed=${Uri.encodeComponent(seed)}'
        '&backgroundColor=ff1466,b7ff2a,ffd60a,7fc8ff,1a1a1a';
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        color: bg,
        border: border ? Border.all(color: Colors.black, width: 2) : null,
        boxShadow: border ? const [BoxShadow(offset: Offset(2, 2), color: Col.line)] : null,
      ),
      child: ClipRect(
        child: Image.network(
          url, width: size, height: size, fit: BoxFit.cover, filterQuality: FilterQuality.none,
          errorBuilder: (_, __, ___) => _IdenticonFallback(seed: seed, size: size),
          loadingBuilder: (_, child, prog) => prog == null ? child : _IdenticonFallback(seed: seed, size: size),
        ),
      ),
    );
  }
}

/// Local 5x5 identicon generated from the seed — used as placeholder/offline.
class _IdenticonFallback extends StatelessWidget {
  final String seed;
  final double size;
  const _IdenticonFallback({required this.seed, required this.size});
  @override
  Widget build(BuildContext c) {
    final hash = seed.codeUnits.fold<int>(0, (a, b) => (a * 31 + b) & 0xFFFFFFFF);
    const palette = [Col.magenta, Col.acid, Col.alert, Col.sky];
    final col = palette[hash % palette.length];
    return CustomPaint(size: Size.square(size), painter: _IdenticonPainter(hash, col));
  }
}

class _IdenticonPainter extends CustomPainter {
  final int hash;
  final Color color;
  _IdenticonPainter(this.hash, this.color);
  @override
  void paint(Canvas canvas, Size sz) {
    canvas.drawRect(Offset.zero & sz, Paint()..color = const Color(0xFF0E0E0E));
    final p = Paint()..color = color;
    final cell = sz.width / 5;
    for (var y = 0; y < 5; y++) {
      for (var x = 0; x < 3; x++) {
        if (((hash >> (y * 3 + x)) & 1) == 1) {
          canvas.drawRect(Rect.fromLTWH(x * cell, y * cell, cell, cell), p);
          if (x < 2) canvas.drawRect(Rect.fromLTWH((4 - x) * cell, y * cell, cell, cell), p);
        }
      }
    }
  }
  @override
  bool shouldRepaint(_IdenticonPainter old) => old.hash != hash;
}

// ─── Animation ticker — replaces React `useTick` for loaders ──────────────
class TickerBuilder extends StatefulWidget {
  final Duration interval;
  final Widget Function(BuildContext, int) builder;
  const TickerBuilder({super.key, required this.interval, required this.builder});
  @override
  State<TickerBuilder> createState() => _TickerBuilderState();
}

class _TickerBuilderState extends State<TickerBuilder> {
  int _t = 0;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.interval, (_) {
      if (mounted) setState(() => _t++);
    });
  }
  @override
  void dispose() { _timer?.cancel(); super.dispose(); }
  @override
  Widget build(BuildContext c) => widget.builder(c, _t);
}

// ─── Scramble effect helper ───────────────────────────────────────────────
const _glyphs = r'!@#$%&*+=<>/\|0123456789ABCDEFXYZ';
String scramble(String target, int t, [int lock = 0]) {
  final buf = StringBuffer();
  for (var i = 0; i < target.length; i++) {
    final c = target[i];
    if (i < lock || c == ' ') {
      buf.write(c);
    } else {
      buf.write(_glyphs[(t * 7 + i * 13) % _glyphs.length]);
    }
  }
  return buf.toString();
}
