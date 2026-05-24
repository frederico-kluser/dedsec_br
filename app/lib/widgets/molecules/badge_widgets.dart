import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../data/achievements_data.dart';
import '../../models/badge.dart';
import '../../theme/colors.dart';
import '../../theme/fonts.dart';
import '../atoms/effects.dart';
import 'token_stream_panel.dart' show Blink;

/// `molecules/BadgeCarousel` — horizontal strip of owned badges.
class BadgeCarousel extends StatelessWidget {
  final List<DedsecBadge> badges;
  final Set<String> owned;
  final Set<String> unopened;
  final ValueChanged<DedsecBadge> onPick;

  const BadgeCarousel({
    super.key,
    required this.badges,
    required this.owned,
    required this.unopened,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    final ownedList = badges.where((b) => owned.contains(b.id)).toList();
    if (ownedList.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(border: Border.all(color: COL.line, width: 1.5)),
        alignment: Alignment.center,
        child: Text(
          '// nenhum selo ainda. processe sua primeira pauta.',
          style: FONT.mono(size: 11, color: COL.inkMute),
        ),
      );
    }
    return SizedBox(
      height: 116,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        itemCount: ownedList.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final b = ownedList[i];
          final isNew = unopened.contains(b.id);
          final cat = kBadgeCategories[b.category]!;
          return GestureDetector(
            onTap: () => onPick(b),
            child: SizedBox(
              width: 88,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(6, 12, 6, 10),
                    decoration: BoxDecoration(
                      color: COL.panel,
                      border: Border.all(color: cat.color, width: 2),
                      boxShadow: isNew
                          ? [BoxShadow(color: cat.color.withValues(alpha: 0.55), blurRadius: 14)]
                          : const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                    ),
                    child: Column(
                      children: [
                        Text(b.emoji, style: const TextStyle(fontSize: 32)),
                        const SizedBox(height: 6),
                        SizedBox(
                          height: 18,
                          child: Center(
                            child: Text(
                              b.title.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: FONT.pixel(size: 7, color: COL.ink, letterSpacing: 0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isNew)
                    Positioned(
                      top: -6,
                      right: -6,
                      child: Blink(
                        period: const Duration(milliseconds: 1500),
                        child: Container(
                          width: 18,
                          height: 18,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: COL.magenta,
                            border: Border.all(color: Colors.black, width: 2),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '!',
                            style: FONT.pixel(size: 7, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// `molecules/BadgeMosaic` — hex grid with pinch+drag panning.
class BadgeMosaic extends StatefulWidget {
  final List<DedsecBadge> badges;
  final Set<String> owned;
  final Set<String> unopened;
  final ValueChanged<DedsecBadge> onBadgeClick;

  const BadgeMosaic({
    super.key,
    required this.badges,
    required this.owned,
    required this.unopened,
    required this.onBadgeClick,
  });

  @override
  State<BadgeMosaic> createState() => _BadgeMosaicState();
}

class _BadgeMosaicState extends State<BadgeMosaic> {
  static const _cols = 6;
  static const _rows = 4;
  static const _hexW = 52.0;
  static const _hexH = 58.0;

  double _zoom = 1;
  Offset _pan = Offset.zero;
  Offset? _panStart;
  Offset? _panOrigin;
  double? _pinchStart;
  double? _zoomStart;

  double get _totalW => _cols * _hexW * 0.78 + _hexW * 0.22;
  double get _totalH => _rows * _hexH + _hexH * 0.5;

  void _setZoom(double z) => setState(() => _zoom = z.clamp(0.7, 2.5));

  @override
  Widget build(BuildContext context) {
    final cells = <_HexCell>[];
    for (var r = 0; r < _rows; r++) {
      for (var c = 0; c < _cols; c++) {
        final idx = r * _cols + c;
        if (idx >= widget.badges.length) continue;
        final y = r * _hexH + (c % 2 == 1 ? _hexH * 0.5 : 0);
        final x = c * _hexW * 0.78;
        cells.add(_HexCell(x.toDouble(), y.toDouble(), widget.badges[idx]));
      }
    }

    return SizedBox(
      height: 290,
      child: ClipRect(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onScaleStart: (d) {
            _panStart = d.focalPoint;
            _panOrigin = _pan;
            _pinchStart = null;
            _zoomStart = _zoom;
          },
          onScaleUpdate: (d) {
            if (d.pointerCount >= 2) {
              if (_pinchStart == null) _pinchStart = d.scale;
              _setZoom(_zoomStart! * d.scale / (_pinchStart ?? 1));
            } else if (_panStart != null && _panOrigin != null) {
              setState(() => _pan = _panOrigin! + (d.focalPoint - _panStart!));
            }
          },
          child: Container(
            color: const Color(0xFF0A0A0A),
            decoration: BoxDecoration(border: Border.all(color: COL.line, width: 1.5)),
            child: Stack(
              children: [
                const Scanlines(opacity: 0.06),
                Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    transformAlignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..translate(_pan.dx, _pan.dy)
                      ..scale(_zoom),
                    child: SizedBox(
                      width: _totalW,
                      height: _totalH,
                      child: Stack(
                        children: [
                          for (final c in cells) _buildCell(c),
                        ],
                      ),
                    ),
                  ),
                ),
                // zoom controls
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: Column(
                    children: [
                      _zoomBtn('+', () => _setZoom(_zoom + 0.2)),
                      const SizedBox(height: 4),
                      _zoomBtn('−', () => _setZoom(_zoom - 0.2)),
                      const SizedBox(height: 4),
                      _zoomBtn('↺', () {
                        setState(() {
                          _zoom = 1;
                          _pan = Offset.zero;
                        });
                      }),
                    ],
                  ),
                ),
                Positioned(
                  left: 8,
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    color: const Color(0x99000000),
                    child: Text(
                      '${(_zoom * 100).round()}%',
                      style: FONT.pixel(size: 8, color: COL.acid, letterSpacing: 1),
                    ),
                  ),
                ),
                Positioned(
                  left: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    color: const Color(0x99000000),
                    child: Row(
                      children: [
                        Container(width: 8, height: 8, color: COL.magenta),
                        const SizedBox(width: 3),
                        Text('SEU',
                            style: FONT.pixel(size: 7, color: COL.inkDim, letterSpacing: 1)),
                        const SizedBox(width: 8),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0E1010),
                            border: Border.all(color: COL.acid, width: 1.5),
                          ),
                        ),
                        const SizedBox(width: 3),
                        Text('FALTA',
                            style: FONT.pixel(size: 7, color: COL.inkDim, letterSpacing: 1)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _zoomBtn(String glyph, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: COL.acid, width: 1.5),
        ),
        child: Text(glyph, style: FONT.pixel(size: 14, color: COL.acid)),
      ),
    );
  }

  Widget _buildCell(_HexCell cell) {
    final isOwned = widget.owned.contains(cell.badge.id);
    final isNew = widget.unopened.contains(cell.badge.id);
    return Positioned(
      left: cell.x,
      top: cell.y,
      width: _hexW,
      height: _hexH,
      child: GestureDetector(
        onTap: () => widget.onBadgeClick(cell.badge),
        child: ClipPath(
          clipper: _HexClipper(),
          child: Container(
            decoration: BoxDecoration(
              color: isOwned ? COL.magenta : const Color(0xFF0E1010),
              border: Border.all(
                color: isOwned ? Colors.black : COL.acid.withValues(alpha: 0.33),
                width: 2,
              ),
              boxShadow: isNew ? [BoxShadow(color: COL.magenta, blurRadius: 14)] : null,
            ),
            alignment: Alignment.center,
            child: Text(
              isOwned ? cell.badge.emoji : '?',
              style: TextStyle(
                fontSize: 20,
                color: isOwned ? Colors.black : COL.acidD,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HexCell {
  final double x, y;
  final DedsecBadge badge;
  _HexCell(this.x, this.y, this.badge);
}

class _HexClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    return Path()
      ..moveTo(w * 0.25, 0)
      ..lineTo(w * 0.75, 0)
      ..lineTo(w, h * 0.5)
      ..lineTo(w * 0.75, h)
      ..lineTo(w * 0.25, h)
      ..lineTo(0, h * 0.5)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

double atan2(num y, num x) => math.atan2(y.toDouble(), x.toDouble());
