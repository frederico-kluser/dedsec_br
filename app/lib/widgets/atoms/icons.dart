import 'package:flutter/material.dart';

import '../../theme/colors.dart';

/// `atoms/Skull` — 16×16 original pixel skull glyph.
class Skull extends StatelessWidget {
  final double size;
  final Color color;
  const Skull({super.key, this.size = 20, this.color = COL.ink});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _SkullPainter(color: color)),
    );
  }
}

class _SkullPainter extends CustomPainter {
  final Color color;
  _SkullPainter({required this.color});

  static const _rects = <List<int>>[
    [3, 2, 10, 2],
    [2, 4, 12, 6],
  ];
  static const _holes = <List<int>>[
    [5, 6, 2, 2],
    [9, 6, 2, 2],
    [7, 9, 2, 1],
  ];
  static const _jaw = <List<int>>[
    [3, 10, 2, 2],
    [6, 10, 1, 2],
    [9, 10, 1, 2],
    [11, 10, 2, 2],
    [3, 12, 3, 1],
    [10, 12, 3, 1],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.width / 16;
    final pSkull = Paint()..color = color;
    final pHole = Paint()..color = Colors.black;
    for (final r in _rects) {
      canvas.drawRect(Rect.fromLTWH(r[0] * unit, r[1] * unit, r[2] * unit, r[3] * unit), pSkull);
    }
    for (final r in _holes) {
      canvas.drawRect(Rect.fromLTWH(r[0] * unit, r[1] * unit, r[2] * unit, r[3] * unit), pHole);
    }
    for (final r in _jaw) {
      canvas.drawRect(Rect.fromLTWH(r[0] * unit, r[1] * unit, r[2] * unit, r[3] * unit), pSkull);
    }
  }

  @override
  bool shouldRepaint(covariant _SkullPainter old) => old.color != color;
}

/// `atoms/Eye` — surveillance eye glyph.
class Eye extends StatelessWidget {
  final double size;
  final Color color;
  const Eye({super.key, this.size = 16, this.color = COL.acid});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _EyePainter(color: color)),
    );
  }
}

class _EyePainter extends CustomPainter {
  final Color color;
  _EyePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.width / 16;
    final p = Paint()..color = color;
    final h = Paint()..color = Colors.black;
    canvas.drawRect(Rect.fromLTWH(2 * unit, 6 * unit, 12 * unit, 4 * unit), p);
    canvas.drawRect(Rect.fromLTWH(1 * unit, 7 * unit, 14 * unit, 2 * unit), p);
    canvas.drawRect(Rect.fromLTWH(6 * unit, 6 * unit, 4 * unit, 4 * unit), h);
    canvas.drawRect(Rect.fromLTWH(7 * unit, 7 * unit, 2 * unit, 2 * unit), p);
  }

  @override
  bool shouldRepaint(covariant _EyePainter old) => old.color != color;
}
