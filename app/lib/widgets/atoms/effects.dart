import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/fonts.dart';

/// `atoms/Halftone` — radial-gradient dotted texture.
class Halftone extends StatelessWidget {
  final Color color;
  final double size;
  final double opacity;
  final Widget? child;

  const Halftone({
    super.key,
    this.color = const Color(0xFF000000),
    this.size = 4,
    this.opacity = 0.4,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _HalftonePainter(color: color, size: size, opacity: opacity),
      child: child ?? const SizedBox.expand(),
    );
  }
}

class _HalftonePainter extends CustomPainter {
  final Color color;
  final double size;
  final double opacity;
  _HalftonePainter({required this.color, required this.size, required this.opacity});

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final paint = Paint()..color = color.withValues(alpha: opacity);
    final radius = math.max(0.6, size * 0.15);
    for (var y = size / 2; y < canvasSize.height; y += size) {
      for (var x = size / 2; x < canvasSize.width; x += size) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HalftonePainter old) =>
      old.color != color || old.size != size || old.opacity != opacity;
}

/// `atoms/Scanlines` — CRT scanlines overlay.
class Scanlines extends StatelessWidget {
  final double opacity;
  final Widget? child;
  const Scanlines({super.key, this.opacity = 0.18, this.child});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _ScanlinePainter(opacity: opacity),
        child: child ?? const SizedBox.expand(),
      ),
    );
  }
}

class _ScanlinePainter extends CustomPainter {
  final double opacity;
  _ScanlinePainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF000000).withValues(alpha: 0.5 * opacity);
    for (var y = 0.0; y < size.height; y += 3) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 1), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ScanlinePainter old) => old.opacity != opacity;
}

/// `atoms/Grain` — pseudo-random noise overlay (multiply-style).
class Grain extends StatelessWidget {
  final double opacity;
  const Grain({super.key, this.opacity = 0.08});

  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: CustomPaint(
          painter: _GrainPainter(opacity: opacity),
          child: const SizedBox.expand(),
        ),
      );
}

class _GrainPainter extends CustomPainter {
  final double opacity;
  final math.Random _rng = math.Random(42);
  _GrainPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..blendMode = ui.BlendMode.overlay;
    const cell = 2.0;
    for (var y = 0.0; y < size.height; y += cell) {
      for (var x = 0.0; x < size.width; x += cell) {
        final v = _rng.nextDouble();
        if (v < 0.5) continue;
        paint.color = Color.fromRGBO(255, 255, 255, (v - 0.5) * opacity * 2);
        canvas.drawRect(Rect.fromLTWH(x, y, cell, cell), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GrainPainter old) => old.opacity != opacity;
}

/// `atoms/CautionTape` — scrolling diagonal caution band.
class CautionTape extends StatefulWidget {
  final String text;
  final Color color;
  const CautionTape({
    super.key,
    this.text = 'DEDSEC_BR / DEDSEC_BR / DEDSEC_BR / ',
    this.color = COL.alert,
  });

  @override
  State<CautionTape> createState() => _CautionTapeState();
}

class _CautionTapeState extends State<CautionTape> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 20),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repeated = widget.text * 8;
    return SizedBox(
      height: 34,
      child: ClipRect(
        child: Transform.rotate(
          angle: -1.5 * math.pi / 180,
          child: Container(
            decoration: BoxDecoration(
              color: widget.color,
              border: const Border(
                top: BorderSide(width: 2, color: Colors.black),
                bottom: BorderSide(width: 2, color: Colors.black),
              ),
            ),
            clipBehavior: Clip.hardEdge,
            height: 30,
            child: AnimatedBuilder(
              animation: _c,
              builder: (_, _) {
                return OverflowBox(
                  maxWidth: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: Transform.translate(
                    offset: Offset(-400 * _c.value, 0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        repeated,
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.visible,
                        style: FONT.pixel(size: 10, color: Colors.black, letterSpacing: 2),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
