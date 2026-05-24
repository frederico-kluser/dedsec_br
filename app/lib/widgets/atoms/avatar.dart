import 'package:flutter/material.dart';

import '../../theme/colors.dart';

/// `atoms/Avatar` — local deterministic identicon.
///
/// The JS prototype hit DiceBear over the network. To keep the app offline we
/// build a 5×5 symmetric identicon from a hash of the seed and render it with
/// a palette pulled from the brand colours.
class Avatar extends StatelessWidget {
  final String seed;
  final double size;
  final bool border;
  final Color? bg;

  const Avatar({
    super.key,
    required this.seed,
    this.size = 32,
    this.border = true,
    this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg ?? const Color(0xFF1C1C1C),
        border: border ? Border.all(color: Colors.black, width: 2) : null,
        boxShadow: border
            ? const [BoxShadow(color: COL.line, offset: Offset(2, 2))]
            : null,
      ),
      clipBehavior: Clip.hardEdge,
      child: CustomPaint(painter: _IdenticonPainter(seed)),
    );
  }
}

const _kAvatarPalette = <Color>[
  COL.magenta,
  COL.acid,
  COL.alert,
  COL.blue,
  Color(0xFF1A1A1A),
];

int _hash(String s) {
  // FNV-1a 32-bit
  var h = 0x811c9dc5;
  for (var i = 0; i < s.length; i++) {
    h ^= s.codeUnitAt(i);
    h = (h * 0x01000193) & 0xFFFFFFFF;
  }
  return h;
}

class _IdenticonPainter extends CustomPainter {
  final String seed;
  _IdenticonPainter(this.seed);

  @override
  void paint(Canvas canvas, Size size) {
    final h = _hash(seed);
    final fg = _kAvatarPalette[h % _kAvatarPalette.length];
    final bg = _kAvatarPalette[(h >> 16) % _kAvatarPalette.length];
    final bgPaint = Paint()..color = bg;
    canvas.drawRect(Offset.zero & size, bgPaint);

    final fgPaint = Paint()..color = fg;
    const grid = 5;
    final cell = size.width / grid;
    // 3 columns × 5 rows; mirrored
    var bits = h;
    for (var x = 0; x < 3; x++) {
      for (var y = 0; y < grid; y++) {
        final on = (bits & 1) == 1;
        bits >>= 1;
        if (!on) continue;
        canvas.drawRect(Rect.fromLTWH(x * cell, y * cell, cell, cell), fgPaint);
        if (x < 2) {
          final mx = (grid - 1 - x) * cell;
          canvas.drawRect(Rect.fromLTWH(mx, y * cell, cell, cell), fgPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _IdenticonPainter old) => old.seed != seed;
}
