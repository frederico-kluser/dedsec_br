import 'package:flutter/material.dart';
import '../atoms/scanlines.dart';
import '../state/achievements.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';

/// Hexagonal mosaic. Supports pinch zoom + drag pan + +/- buttons.
class DedsecBadgeMosaic extends StatefulWidget {
  final Set<String> owned;
  final Set<String> unopened;
  final ValueChanged<DedsecBadge> onDedsecBadgeClick;
  const DedsecBadgeMosaic({
    super.key,
    required this.owned,
    required this.unopened,
    required this.onDedsecBadgeClick,
  });

  @override
  State<DedsecBadgeMosaic> createState() => _DedsecBadgeMosaicState();
}

class _DedsecBadgeMosaicState extends State<DedsecBadgeMosaic> {
  static const cols = 6;
  static const rows = 4;
  static const hexW = 52.0;
  static const hexH = 58.0;

  double _zoom = 1.0;
  double _zoomStart = 1.0;
  Offset _pan = Offset.zero;
  Offset _panStart = Offset.zero;

  void _setZoom(double v) => setState(() => _zoom = v.clamp(0.7, 2.5));

  @override
  Widget build(BuildContext context) {
    final cells = <_Cell>[];
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        final idx = r * cols + c;
        if (idx >= badges.length) continue;
        final y = r * hexH + (c.isOdd ? hexH * 0.5 : 0);
        final x = c * hexW * 0.78;
        cells.add(_Cell(x, y, badges[idx]));
      }
    }
    final totalW = cols * hexW * 0.78 + hexW * 0.22;
    final totalH = rows * hexH + hexH * 0.5;

    return SizedBox(
      height: 290,
      child: ClipRect(
        child: Stack(children: [
          Container(
            color: const Color(0xFF0A0A0A),
            child: Stack(children: [
              const Positioned.fill(child: Scanlines(opacity: 0.06)),
              Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onScaleStart: (d) {
                    _zoomStart = _zoom;
                    _panStart = _pan;
                  },
                  onScaleUpdate: (d) {
                    setState(() {
                      _zoom = (_zoomStart * d.scale).clamp(0.7, 2.5);
                      _pan = _panStart + d.focalPointDelta * 0; // we use focal delta below
                    });
                  },
                  onPanUpdate: (d) {
                    setState(() => _pan += d.delta);
                  },
                  child: Transform.translate(
                    offset: _pan,
                    child: Transform.scale(
                      scale: _zoom,
                      child: SizedBox(
                        width: totalW,
                        height: totalH,
                        child: Stack(children: [
                          for (final c in cells) _hex(c),
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 8, bottom: 8,
                child: Column(children: [
                  for (final btn in [
                    ('+', () => _setZoom(_zoom + 0.2)),
                    ('−', () => _setZoom(_zoom - 0.2)),
                    ('↺', () => setState(() {
                          _zoom = 1;
                          _pan = Offset.zero;
                        })),
                  ])
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: GestureDetector(
                        onTap: btn.$2,
                        child: Container(
                          width: 28, height: 28,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: DedsecColors.acid, width: 1.5),
                          ),
                          child: Center(
                            child: Text(btn.$1,
                                style: DedsecFonts.pixel(size: 14, color: DedsecColors.acid)),
                          ),
                        ),
                      ),
                    ),
                ]),
              ),
              Positioned(
                left: 8, bottom: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  color: Colors.black.withOpacity(0.6),
                  child: Text('${(_zoom * 100).round()}%',
                      style: DedsecFonts.pixel(size: 8, color: DedsecColors.acid, letterSpacing: 1)),
                ),
              ),
              Positioned(
                left: 8, top: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  color: Colors.black.withOpacity(0.6),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Container(width: 8, height: 8, color: DedsecColors.magenta),
                    const SizedBox(width: 3),
                    Text('SEU',
                        style: DedsecFonts.pixel(size: 7, color: DedsecColors.inkDim, letterSpacing: 1)),
                    const SizedBox(width: 8),
                    Container(
                      width: 8, height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0E1010),
                        border: Border.all(color: DedsecColors.acid, width: 1.5),
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text('FALTA',
                        style: DedsecFonts.pixel(size: 7, color: DedsecColors.inkDim, letterSpacing: 1)),
                  ]),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _hex(_Cell c) {
    final isOwned = widget.owned.contains(c.badge.id);
    final isNew = widget.unopened.contains(c.badge.id);
    return Positioned(
      left: c.x,
      top: c.y,
      child: GestureDetector(
        onTap: () => widget.onDedsecBadgeClick(c.badge),
        child: ClipPath(
          clipper: _HexClipper(),
          child: Container(
            width: hexW,
            height: hexH,
            decoration: BoxDecoration(
              color: isOwned ? DedsecColors.magenta : const Color(0xFF0E1010),
              border: Border.all(
                color: isOwned ? Colors.black : DedsecColors.acid.withOpacity(0.33),
                width: 2,
              ),
              boxShadow:
                  isNew ? [const BoxShadow(color: DedsecColors.magenta, blurRadius: 14)] : null,
            ),
            child: Center(
              child: ColorFiltered(
                colorFilter: isOwned
                    ? const ColorFilter.mode(Colors.transparent, BlendMode.dst)
                    : const ColorFilter.matrix(<double>[
                        0.45, 0.45, 0.45, 0, 0, 0.45, 0.45, 0.45, 0, 0, 0.45, 0.45, 0.45, 0, 0, 0, 0, 0, 0.45, 0,
                      ]),
                child: Text(
                  isOwned ? c.badge.emoji : '?',
                  style: const TextStyle(fontSize: 20, height: 1),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Cell {
  final double x;
  final double y;
  final DedsecBadge badge;
  _Cell(this.x, this.y, this.badge);
}

class _HexClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final p = Path()
      ..moveTo(w * 0.25, 0)
      ..lineTo(w * 0.75, 0)
      ..lineTo(w, h * 0.5)
      ..lineTo(w * 0.75, h)
      ..lineTo(w * 0.25, h)
      ..lineTo(0, h * 0.5)
      ..close();
    return p;
  }

  @override
  bool shouldReclip(_) => false;
}
