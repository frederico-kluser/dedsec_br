import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/models.dart';
import '../data/ranking.dart';
import '../design/colors.dart';
import '../design/fonts.dart';
import 'atoms.dart';

// ─────────────────────────────────────────────────────────────────────
// TopBar — phone-internal status bar
// ─────────────────────────────────────────────────────────────────────
class TopBar extends StatelessWidget {
  const TopBar({super.key, this.score = 12, this.supporters = 4328});
  final int score;
  final int supporters;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: DCol.bg,
        border: Border(bottom: BorderSide(color: DCol.line)),
      ),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
      child: Row(
        children: [
          const Wordmark(size: 11),
          const Spacer(),
          const Eye(size: 11),
          const SizedBox(width: 4),
          Text('$score', style: DFont.pixel(size: 8, color: DCol.acid)),
          const SizedBox(width: 8),
          const Skull(size: 11, color: DCol.magenta),
          const SizedBox(width: 4),
          Text(formatNum(supporters), style: DFont.pixel(size: 8, color: DCol.magenta)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// TabBar — bottom navigation
// ─────────────────────────────────────────────────────────────────────
class DTabBar extends StatelessWidget {
  const DTabBar({super.key, required this.active, required this.onTab});
  final BottomTab active;
  final ValueChanged<BottomTab> onTab;

  static const _tabs = [
    (id: BottomTab.home, label: 'PAUTAS', glyph: '▣'),
    (id: BottomTab.help, label: 'AJUDAR', glyph: '✦'),
    (id: BottomTab.forum, label: 'FÓRUM', glyph: '◉'),
    (id: BottomTab.settings, label: 'CONFIG', glyph: '⚙'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: DCol.line, width: 2)),
      ),
      child: Row(
        children: _tabs.map((t) {
          final on = active == t.id;
          return Expanded(
            child: InkWell(
              onTap: () => onTab(t.id),
              child: Container(
                color: on ? DCol.magenta : Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Text(t.glyph, style: TextStyle(fontSize: 16, color: on ? Colors.black : DCol.inkDim, height: 1)),
                    const SizedBox(height: 3),
                    Text(t.label,
                        style: DFont.pixel(
                            size: 7,
                            color: on ? Colors.black : DCol.inkDim,
                            letterSpacing: 1)),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// ComicPanel — solid color card with halftone + corner label
// ─────────────────────────────────────────────────────────────────────
class ComicPanel extends StatelessWidget {
  const ComicPanel({
    super.key,
    this.color = DCol.magenta,
    this.halftone = Colors.black,
    this.height = 120,
    this.label,
    this.children = const [],
  });

  final Color color;
  final Color halftone;
  final double height;
  final String? label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(color: color, border: Border.all(color: Colors.black, width: 2)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(child: Halftone(color: halftone, size: 5, opacity: 0.55)),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.55)],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
          ),
          ...children,
          if (label != null)
            Positioned(
              left: 8,
              bottom: 8,
              child: Container(
                color: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Text(label!,
                    style: DFont.pixel(size: 9, color: Colors.white, letterSpacing: 1)),
              ),
            ),
          const Positioned.fill(child: Grain(opacity: 0.12)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// ScopeChip — toggle chip for Mun/Est/Fed
// ─────────────────────────────────────────────────────────────────────
class ScopeChip extends StatelessWidget {
  const ScopeChip({
    super.key,
    required this.label,
    required this.active,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? color : Colors.transparent,
            border: Border.all(color: active ? color : DCol.line, width: 1.5),
          ),
          child: Text(
            label,
            style: DFont.pixel(
              size: 9,
              color: active ? Colors.black : DCol.inkDim,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// NewsCard — single feed card
// ─────────────────────────────────────────────────────────────────────
class NewsCard extends StatelessWidget {
  const NewsCard({super.key, required this.item, required this.onOpen});
  final NewsItem item;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOpen,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: DCol.panel,
          border: Border.all(color: DCol.line, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ComicPanel(
              color: item.color,
              height: 96,
              label: 'PAUTA · ${item.tag}',
              children: [
                Positioned.fill(
                  child: Center(
                    child: Opacity(
                      opacity: 0.85,
                      child: Text(item.panel, style: const TextStyle(fontSize: 56)),
                    ),
                  ),
                ),
                if (item.urgent)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: DCol.danger),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: Text('🔥 URGENTE',
                          style: DFont.pixel(size: 8, color: DCol.danger, letterSpacing: 1)),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: DFont.body(
                          size: 14, color: DCol.ink, weight: FontWeight.w700, height: 1.3)),
                  const SizedBox(height: 6),
                  Text(item.desc,
                      style: DFont.body(size: 12, color: DCol.inkDim, height: 1.45)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.sources.join(' · '),
                          style: DFont.mono(size: 9, color: DCol.inkMute, letterSpacing: 0.5),
                        ),
                      ),
                      Container(
                        color: DCol.acid,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        child: Text('PROTESTAR →',
                            style:
                                DFont.pixel(size: 9, color: Colors.black, letterSpacing: 1)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// TokenStreamPanel — animated LLM token stream
// ─────────────────────────────────────────────────────────────────────
class TokenStreamPanel extends StatefulWidget {
  const TokenStreamPanel({
    super.key,
    this.inputTokens = const [
      '[BOS]', 'pauta:', 'linha', '17-', 'ouro', 'sp', 'atraso', '14', 'anos', 'custo', '3x', '[EOS]'
    ],
    this.outputTokens = const [
      'A', ' Linha', ' 17-Ouro', ' do', ' metrô', ' atrasou', ' 14', ' anos', ' e', ' o', ' custo',
      ' triplicou', '.', ' Quem', ' paga', '?'
    ],
    this.modelLabel = 'GEMMA-3-1B',
  });

  final List<String> inputTokens;
  final List<String> outputTokens;
  final String modelLabel;

  @override
  State<TokenStreamPanel> createState() => _TokenStreamPanelState();
}

class _TokenStreamPanelState extends State<TokenStreamPanel> {
  int _tick = 0;
  late final Stream<int> _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Stream.periodic(const Duration(milliseconds: 180), (i) => i);
    _ticker.listen((i) {
      if (mounted) setState(() => _tick = i);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cycleLength = widget.outputTokens.length + 6;
    final cycle = _tick % cycleLength;
    final visible = math.min(widget.outputTokens.length, cycle);
    final layer = ((_tick / 2).floor() % 16) + 1;
    final tokPerSec = (12 + math.sin(_tick * 0.3) * 2).toStringAsFixed(1);
    final attnPct = (visible / widget.outputTokens.length * 100).round();
    final kvKb = visible * 8 + widget.inputTokens.length * 4;

    return Expanded(
      child: Stack(
        children: [
          const Positioned.fill(child: Scanlines(opacity: 0.08)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    _Blink(color: DCol.acid, width: 8, height: 8),
                    const SizedBox(width: 6),
                    Text(widget.modelLabel,
                        style: DFont.pixel(size: 9, color: DCol.acid, letterSpacing: 1)),
                    const Spacer(),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(text: 'layer '),
                          TextSpan(
                            text: '$layer',
                            style: DFont.mono(size: 9, color: DCol.magenta),
                          ),
                          const TextSpan(text: '/16'),
                        ],
                        style: DFont.mono(size: 9, color: DCol.inkDim),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0D0A),
                    border: Border.all(color: DCol.line, width: 1.5),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('INPUT · ${widget.inputTokens.length} TOK',
                          style: DFont.pixel(size: 7, color: DCol.inkMute, letterSpacing: 1.5)),
                      const SizedBox(height: 5),
                      Wrap(
                        spacing: 3,
                        runSpacing: 3,
                        children: widget.inputTokens
                            .map((t) => Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    border: Border.all(color: DCol.line),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                  child: Text(t.trim().isEmpty ? '·' : t,
                                      style: DFont.mono(size: 10, color: DCol.inkDim)),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A0E0A),
                      border: Border.all(color: DCol.acid, width: 1.5),
                      boxShadow: [BoxShadow(color: DCol.acid.withValues(alpha: 0.2), blurRadius: 16)],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Text('GERANDO',
                                style: DFont.pixel(size: 7, color: DCol.acid, letterSpacing: 1.5)),
                            const Spacer(),
                            Text(
                              '$visible/${widget.outputTokens.length} · $tokPerSec tok/s',
                              style: DFont.mono(size: 9, color: DCol.acid),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: ClipRect(
                            child: Wrap(
                              spacing: 3,
                              runSpacing: 3,
                              children: [
                                for (var i = 0; i < visible; i++)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: DCol.acid,
                                      border: Border.all(color: Colors.black, width: 1.5),
                                      boxShadow: i == visible - 1
                                          ? const [
                                              BoxShadow(color: Colors.black, offset: Offset(2, 2))
                                            ]
                                          : null,
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    child: Text(
                                      widget.outputTokens[i].trim().isEmpty
                                          ? '·'
                                          : widget.outputTokens[i],
                                      style: DFont.mono(
                                        size: 11,
                                        color: Colors.black,
                                        weight: i == visible - 1 ? FontWeight.w700 : FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                if (visible < widget.outputTokens.length)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      border: Border.all(color: DCol.acid, width: 1.5),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    child: const _Blink(
                                      child: Text('▮',
                                          style: TextStyle(color: DCol.acid, fontSize: 11)),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    Text.rich(
                      TextSpan(children: [
                        const TextSpan(text: 'attn: '),
                        TextSpan(
                            text: '$attnPct%', style: DFont.mono(size: 9, color: DCol.acid)),
                      ], style: DFont.mono(size: 9, color: DCol.inkMute)),
                    ),
                    Text('·', style: DFont.mono(size: 9, color: DCol.inkMute)),
                    Text.rich(
                      TextSpan(children: [
                        const TextSpan(text: 'kv: '),
                        TextSpan(
                            text: '${kvKb}KB',
                            style: DFont.mono(size: 9, color: DCol.magenta)),
                        const TextSpan(text: '/256KB'),
                      ], style: DFont.mono(size: 9, color: DCol.inkMute)),
                    ),
                    Text('·', style: DFont.mono(size: 9, color: DCol.inkMute)),
                    Text('vocab: 32k', style: DFont.mono(size: 9, color: DCol.inkMute)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable blinking element — used for cursors and indicator dots.
class _Blink extends StatefulWidget {
  const _Blink({this.child, this.color, this.width, this.height});
  final Widget? child;
  final Color? color;
  final double? width;
  final double? height;

  @override
  State<_Blink> createState() => _BlinkState();
}

class _BlinkState extends State<_Blink> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        final on = _c.value < 0.5;
        if (widget.child != null) {
          return Opacity(opacity: on ? 1 : 0, child: widget.child);
        }
        return Opacity(
          opacity: on ? 1 : 0,
          child: Container(width: widget.width, height: widget.height, color: widget.color),
        );
      },
    );
  }
}

/// Public alias so screens can import Blink without an underscore prefix.
class Blink extends StatelessWidget {
  const Blink({super.key, this.child, this.color, this.width, this.height});
  final Widget? child;
  final Color? color;
  final double? width;
  final double? height;
  @override
  Widget build(BuildContext context) => _Blink(
        color: color,
        width: width,
        height: height,
        child: child,
      );
}

// ─────────────────────────────────────────────────────────────────────
// BadgeCarousel — horizontal owned badges
// ─────────────────────────────────────────────────────────────────────
class BadgeCarousel extends StatelessWidget {
  const BadgeCarousel({
    super.key,
    required this.badges,
    required this.owned,
    required this.unopened,
    required this.onPick,
  });

  final List<DBadge> badges;
  final Set<String> owned;
  final Set<String> unopened;
  final ValueChanged<DBadge> onPick;

  @override
  Widget build(BuildContext context) {
    final ownedBadges = badges.where((b) => owned.contains(b.id)).toList();
    if (ownedBadges.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(border: Border.all(color: DCol.line, width: 1.5)),
        alignment: Alignment.center,
        child: Text(
          '// nenhum selo ainda. processe sua primeira pauta.',
          style: DFont.mono(size: 11, color: DCol.inkMute),
        ),
      );
    }
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 4),
        itemCount: ownedBadges.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final b = ownedBadges[i];
          final isNew = unopened.contains(b.id);
          final cat = BADGE_CATEGORIES[b.category]!;
          return GestureDetector(
            onTap: () => onPick(b),
            child: SizedBox(
              width: 88,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: DCol.panel,
                      border: Border.all(color: cat.color, width: 2),
                      boxShadow: isNew
                          ? [BoxShadow(color: cat.color.withValues(alpha: 0.55), blurRadius: 14)]
                          : const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                    ),
                    padding: const EdgeInsets.fromLTRB(6, 12, 6, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(b.emoji, style: const TextStyle(fontSize: 32, height: 1)),
                        const SizedBox(height: 6),
                        SizedBox(
                          height: 22,
                          child: Center(
                            child: Text(
                              b.title.toUpperCase(),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: DFont.pixel(
                                  size: 7, color: DCol.ink, letterSpacing: 0.5, height: 1.2),
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
                      child: Container(
                        width: 18,
                        height: 18,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: DCol.magenta,
                          border: Border.all(color: Colors.black, width: 2),
                          shape: BoxShape.circle,
                        ),
                        child: Text('!',
                            style: DFont.pixel(size: 7, color: Colors.white)),
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

// ─────────────────────────────────────────────────────────────────────
// BadgeMosaic — hexagonal grid with pan + zoom
// ─────────────────────────────────────────────────────────────────────
class BadgeMosaic extends StatefulWidget {
  const BadgeMosaic({
    super.key,
    required this.badges,
    required this.owned,
    required this.unopened,
    required this.onBadgeClick,
  });

  final List<DBadge> badges;
  final Set<String> owned;
  final Set<String> unopened;
  final ValueChanged<DBadge> onBadgeClick;

  @override
  State<BadgeMosaic> createState() => _BadgeMosaicState();
}

class _BadgeMosaicState extends State<BadgeMosaic> {
  static const cols = 6;
  static const rows = 4;
  static const hexW = 52.0;
  static const hexH = 58.0;

  final _transformer = TransformationController();

  @override
  void dispose() {
    _transformer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalW = cols * hexW * 0.78 + hexW * 0.22;
    final totalH = rows * hexH + hexH * 0.5;

    return Container(
      height: 290,
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        border: Border.all(color: DCol.line, width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const Positioned.fill(child: Scanlines(opacity: 0.06)),
          Positioned.fill(
            child: InteractiveViewer(
              transformationController: _transformer,
              minScale: 0.7,
              maxScale: 2.5,
              boundaryMargin: const EdgeInsets.all(80),
              child: Center(
                child: SizedBox(
                  width: totalW,
                  height: totalH,
                  child: Stack(
                    children: List.generate(rows * cols, (idx) {
                      if (idx >= widget.badges.length) return const SizedBox.shrink();
                      final r = idx ~/ cols;
                      final c = idx % cols;
                      final badge = widget.badges[idx];
                      final isOwned = widget.owned.contains(badge.id);
                      final isNew = widget.unopened.contains(badge.id);
                      final y = r * hexH + (c.isOdd ? hexH * 0.5 : 0);
                      final x = c * hexW * 0.78;
                      return Positioned(
                        left: x,
                        top: y,
                        width: hexW,
                        height: hexH,
                        child: GestureDetector(
                          onTap: () => widget.onBadgeClick(badge),
                          child: CustomPaint(
                            painter: _HexPainter(
                              fill: isOwned ? DCol.magenta : const Color(0xFF0E1010),
                              stroke: isOwned ? Colors.black : DCol.acid.withValues(alpha: 0.33),
                              glow: isNew ? DCol.magenta : null,
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Opacity(
                                  opacity: isOwned ? 1 : 0.45,
                                  child: ColorFiltered(
                                    colorFilter: isOwned
                                        ? const ColorFilter.mode(Colors.transparent, BlendMode.dst)
                                        : const ColorFilter.matrix([
                                            0.33, 0.33, 0.33, 0, 0,
                                            0.33, 0.33, 0.33, 0, 0,
                                            0.33, 0.33, 0.33, 0, 0,
                                            0,    0,    0,    1, 0,
                                          ]),
                                    child: Text(
                                      isOwned ? badge.emoji : '?',
                                      style: const TextStyle(fontSize: 20, height: 1),
                                    ),
                                  ),
                                ),
                                if (isNew)
                                  Positioned(
                                    top: 4,
                                    right: 6,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: DCol.acid,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.black, width: 1.5),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 8,
            top: 8,
            child: Container(
              color: Colors.black.withValues(alpha: 0.6),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 8, height: 8, color: DCol.magenta),
                  const SizedBox(width: 3),
                  Text('SEU',
                      style:
                          DFont.pixel(size: 7, color: DCol.inkDim, letterSpacing: 1)),
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0E1010),
                      border: Border.all(color: DCol.acid, width: 1.5),
                    ),
                  ),
                  const SizedBox(width: 3),
                  Text('FALTA',
                      style:
                          DFont.pixel(size: 7, color: DCol.inkDim, letterSpacing: 1)),
                ],
              ),
            ),
          ),
          Positioned(
            right: 8,
            bottom: 8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _MosaicBtn(glyph: '+', onTap: () {
                  _transformer.value = _transformer.value.scaledByDouble(1.2, 1.2, 1.2, 1);
                }),
                const SizedBox(height: 4),
                _MosaicBtn(glyph: '−', onTap: () {
                  _transformer.value = _transformer.value.scaledByDouble(0.85, 0.85, 0.85, 1);
                }),
                const SizedBox(height: 4),
                _MosaicBtn(glyph: '↺', onTap: () {
                  _transformer.value = Matrix4.identity();
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MosaicBtn extends StatelessWidget {
  const _MosaicBtn({required this.glyph, required this.onTap});
  final String glyph;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: DCol.acid, width: 1.5),
        ),
        child: Text(glyph, style: DFont.pixel(size: 14, color: DCol.acid)),
      ),
    );
  }
}

class _HexPainter extends CustomPainter {
  _HexPainter({required this.fill, required this.stroke, this.glow});
  final Color fill;
  final Color stroke;
  final Color? glow;
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(w * 0.25, 0)
      ..lineTo(w * 0.75, 0)
      ..lineTo(w, h * 0.5)
      ..lineTo(w * 0.75, h)
      ..lineTo(w * 0.25, h)
      ..lineTo(0, h * 0.5)
      ..close();
    if (glow != null) {
      canvas.drawPath(
          path,
          Paint()
            ..color = glow!
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12));
    }
    canvas.drawPath(path, Paint()..color = fill);
    canvas.drawPath(
        path,
        Paint()
          ..color = stroke
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(covariant _HexPainter old) =>
      old.fill != fill || old.stroke != stroke || old.glow != glow;
}
