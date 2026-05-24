// molecules.dart — composed widgets: TopBar, TabBar, ScopeChip, NewsCard,
// ComicPanel, TokenStreamPanel, BadgeCarousel, BadgeMosaic, LoaderShowcase.

import 'dart:math' as math;
import 'package:flutter/material.dart' hide Badge;
import 'atoms.dart';
import 'data.dart';
import 'design.dart';
import 'state.dart';

// ─── TopBar — wordmark + score + supporters ──────────────────────────────
class TopBar extends StatelessWidget {
  final int score;
  final int supporters;
  const TopBar({super.key, this.score = 12, this.supporters = 4328});
  @override
  Widget build(BuildContext c) => Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
        decoration: const BoxDecoration(color: Col.bg, border: Border(bottom: BorderSide(color: Col.line))),
        child: Row(children: [
          const Wordmark(size: 11),
          const Spacer(),
          Row(children: [
            const Eye(size: 11, color: Col.acid),
            const SizedBox(width: 4),
            Text('$score', style: Fonts.pixel(size: 8, color: Col.acid)),
          ]),
          const SizedBox(width: 8),
          Row(children: [
            const Skull(size: 11, color: Col.magenta),
            const SizedBox(width: 4),
            Text(formatNum(supporters), style: Fonts.pixel(size: 8, color: Col.magenta)),
          ]),
        ]),
      );
}

// ─── TabBar — bottom nav ─────────────────────────────────────────────────
class TabBarNav extends StatelessWidget {
  final String active;
  final ValueChanged<String> onTab;
  const TabBarNav({super.key, required this.active, required this.onTab});
  static const tabs = [
    ('home', 'PAUTAS', '▣'),
    ('help', 'AJUDAR', '✦'),
    ('forum', 'FÓRUM', '◉'),
    ('settings', 'CONFIG', '⚙'),
  ];
  @override
  Widget build(BuildContext c) => Container(
        decoration: const BoxDecoration(color: Colors.black, border: Border(top: BorderSide(color: Col.line, width: 2))),
        child: Row(children: [
          for (final t in tabs)
            Expanded(
              child: GestureDetector(
                onTap: () => onTab(t.$1),
                child: Container(
                  color: active == t.$1 ? Col.magenta : Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(t.$3, style: TextStyle(fontSize: 16, color: active == t.$1 ? Colors.black : Col.inkDim, height: 1)),
                    const SizedBox(height: 3),
                    Text(t.$2, style: Fonts.pixel(size: 7, color: active == t.$1 ? Colors.black : Col.inkDim, letterSpacing: 1)),
                  ]),
                ),
              ),
            ),
        ]),
      );
}

// ─── ScopeChip — municipal/estadual/federal toggle ───────────────────────
class ScopeChip extends StatelessWidget {
  final String label;
  final bool active;
  final Color color;
  final VoidCallback? onTap;
  const ScopeChip({super.key, required this.label, required this.active, required this.color, this.onTap});
  @override
  Widget build(BuildContext c) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: active ? color : Colors.transparent,
              border: Border.all(color: active ? color : Col.line, width: 1.5),
            ),
            alignment: Alignment.center,
            child: Text(label,
                style: Fonts.pixel(size: 9, color: active ? Colors.black : Col.inkDim, letterSpacing: 1.5)),
          ),
        ),
      );
}

// ─── ComicPanel — pop-art solid color card ───────────────────────────────
class ComicPanel extends StatelessWidget {
  final Color color;
  final Color halftoneColor;
  final Widget? child;
  final double height;
  final String? label;
  const ComicPanel({super.key, required this.color, this.halftoneColor = Colors.black, this.child, this.height = 120, this.label});
  @override
  Widget build(BuildContext c) => SizedBox(
        height: height,
        child: Stack(fit: StackFit.expand, children: [
          Container(decoration: BoxDecoration(color: color, border: Border.all(color: Colors.black, width: 2))),
          Halftone(color: halftoneColor, size: 5, opacity: 0.55),
          Container(decoration: const BoxDecoration(gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Colors.transparent, Color(0x8C000000)], stops: [0.6, 1.0],
          ))),
          if (child != null) child!,
          if (label != null)
            Positioned(left: 8, bottom: 8, child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              color: Colors.black,
              child: Text(label!, style: Fonts.pixel(size: 9, color: Colors.white, letterSpacing: 1)),
            )),
          const Grain(opacity: 0.12),
        ]),
      );
}

// ─── NewsCard — feed card ────────────────────────────────────────────────
class NewsCard extends StatelessWidget {
  final NewsItem n;
  final VoidCallback? onOpen;
  const NewsCard({super.key, required this.n, this.onOpen});
  @override
  Widget build(BuildContext c) => GestureDetector(
        onTap: onOpen,
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(color: Col.panel, border: Border.all(color: Col.line, width: 1.5)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            ComicPanel(
              color: Color(n.color),
              height: 96,
              label: 'PAUTA · ${n.tag}',
              child: Stack(children: [
                Center(child: Opacity(opacity: 0.85, child: Text(n.panel, style: const TextStyle(fontSize: 56)))),
                if (n.urgent)
                  Positioned(top: 8, right: 8, child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(color: Colors.black, border: Border.all(color: Col.danger, width: 1)),
                    child: Text('🔥 URGENTE', style: Fonts.pixel(size: 8, color: Col.danger, letterSpacing: 1)),
                  )),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(n.title, style: Fonts.body(size: 14, color: Col.ink, weight: FontWeight.w700, height: 1.3)),
                const SizedBox(height: 6),
                Text(n.desc, style: Fonts.body(size: 12, color: Col.inkDim, height: 1.45)),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(child: Text(n.sources.join(' · '),
                      style: Fonts.mono(size: 9, color: Col.inkMute, letterSpacing: 0.5))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    color: Col.acid,
                    child: Text('PROTESTAR →', style: Fonts.pixel(size: 9, color: Colors.black, letterSpacing: 1)),
                  ),
                ]),
              ]),
            ),
          ]),
        ),
      );
}

// ─── TokenStreamPanel — animated LLM token stream ────────────────────────
class TokenStreamPanel extends StatelessWidget {
  final List<String> inputTokens;
  final List<String> outputTokens;
  final String modelLabel;
  const TokenStreamPanel({
    super.key,
    this.inputTokens = const ['[BOS]','pauta:','linha','17-','ouro','sp','atraso','14','anos','custo','3x','[EOS]'],
    this.outputTokens = const ['A',' Linha',' 17-Ouro',' do',' metrô',' atrasou',' 14',' anos',' e',' o',' custo',' triplicou','.',' Quem',' paga','?'],
    this.modelLabel = 'GEMMA-3-1B',
  });
  @override
  Widget build(BuildContext c) => Expanded(
        child: TickerBuilder(
          interval: const Duration(milliseconds: 180),
          builder: (_, t) {
            final cycle = t % (outputTokens.length + 6);
            final visible = cycle.clamp(0, outputTokens.length);
            final layer = ((t / 2).floor() % 16) + 1;
            final tokPerSec = (12 + math.sin(t * 0.3) * 2).toStringAsFixed(1);
            final attnPct = (visible / outputTokens.length * 100).round();
            final kvKb = visible * 8 + inputTokens.length * 4;
            return Stack(children: [
              const Scanlines(opacity: 0.08),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Row(children: [
                    _Blink(),
                    const SizedBox(width: 6),
                    Text(modelLabel, style: Fonts.pixel(size: 9, color: Col.acid, letterSpacing: 1)),
                    const Spacer(),
                    Text.rich(TextSpan(children: [
                      TextSpan(text: 'layer ', style: Fonts.mono(size: 9, color: Col.inkDim)),
                      TextSpan(text: '$layer', style: Fonts.mono(size: 9, color: Col.magenta)),
                      TextSpan(text: '/16', style: Fonts.mono(size: 9, color: Col.inkDim)),
                    ])),
                  ]),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFF0A0D0A), border: Border.all(color: Col.line, width: 1.5)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('INPUT · ${inputTokens.length} TOK',
                          style: Fonts.pixel(size: 7, color: Col.inkMute, letterSpacing: 1.5)),
                      const SizedBox(height: 5),
                      Wrap(spacing: 3, runSpacing: 3, children: [
                        for (final tk in inputTokens)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(color: Colors.black, border: Border.all(color: Col.line)),
                            child: Text(tk.trim().isEmpty ? '·' : tk, style: Fonts.mono(size: 10, color: Col.inkDim)),
                          ),
                      ]),
                    ]),
                  ),
                  const SizedBox(height: 8),
                  Expanded(child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A0E0A),
                      border: Border.all(color: Col.acid, width: 1.5),
                      boxShadow: [BoxShadow(color: Col.acid.withValues(alpha: 0.2), blurRadius: 16)],
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Text('GERANDO', style: Fonts.pixel(size: 7, color: Col.acid, letterSpacing: 1.5)),
                        const Spacer(),
                        Text('$visible/${outputTokens.length} · $tokPerSec tok/s', style: Fonts.mono(size: 9, color: Col.acid)),
                      ]),
                      const SizedBox(height: 6),
                      Expanded(child: SingleChildScrollView(
                        child: Wrap(spacing: 3, runSpacing: 3, children: [
                          for (var i = 0; i < visible; i++)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: Col.acid, border: Border.all(color: Colors.black, width: 1.5)),
                              child: Text(outputTokens[i].trim().isEmpty ? '·' : outputTokens[i],
                                  style: Fonts.mono(size: 11, color: Colors.black, weight: i == visible - 1 ? FontWeight.w700 : FontWeight.w400)),
                            ),
                          if (visible < outputTokens.length)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: Colors.black, border: Border.all(color: Col.acid, width: 1.5)),
                              child: const _BlinkText(text: '▮', color: Col.acid),
                            ),
                        ]),
                      )),
                    ]),
                  )),
                  const SizedBox(height: 8),
                  Wrap(spacing: 8, children: [
                    Text.rich(TextSpan(children: [
                      TextSpan(text: 'attn: ', style: Fonts.mono(size: 9, color: Col.inkMute)),
                      TextSpan(text: '$attnPct%', style: Fonts.mono(size: 9, color: Col.acid)),
                    ])),
                    Text('·', style: Fonts.mono(size: 9, color: Col.inkMute)),
                    Text.rich(TextSpan(children: [
                      TextSpan(text: 'kv: ', style: Fonts.mono(size: 9, color: Col.inkMute)),
                      TextSpan(text: '${kvKb}KB', style: Fonts.mono(size: 9, color: Col.magenta)),
                      TextSpan(text: '/256KB', style: Fonts.mono(size: 9, color: Col.inkMute)),
                    ])),
                    Text('·', style: Fonts.mono(size: 9, color: Col.inkMute)),
                    Text('vocab: 32k', style: Fonts.mono(size: 9, color: Col.inkMute)),
                  ]),
                ]),
              ),
            ]);
          },
        ),
      );
}

class _Blink extends StatefulWidget { @override State<_Blink> createState() => _BlinkState(); }
class _BlinkState extends State<_Blink> {
  bool _on = true;
  late final t = TickerBuilder(
    interval: const Duration(milliseconds: 600),
    builder: (_, x) => Container(width: 8, height: 8, color: x.isEven ? Col.acid : Colors.transparent),
  );
  @override
  Widget build(BuildContext c) => t;
}

class _BlinkText extends StatelessWidget {
  final String text; final Color color;
  const _BlinkText({required this.text, required this.color});
  @override
  Widget build(BuildContext c) => TickerBuilder(
        interval: const Duration(milliseconds: 500),
        builder: (_, t) => Opacity(opacity: t.isEven ? 1 : 0, child: Text(text, style: Fonts.mono(size: 11, color: color))),
      );
}

// ─── BadgeCarousel — horizontal owned badges ─────────────────────────────
class BadgeCarousel extends StatelessWidget {
  final Set<String> owned;
  final Set<String> unopened;
  final ValueChanged<Badge> onPick;
  const BadgeCarousel({super.key, required this.owned, required this.unopened, required this.onPick});
  @override
  Widget build(BuildContext c) {
    final list = badges.where((b) => owned.contains(b.id)).toList();
    if (list.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(14),
        alignment: Alignment.center,
        decoration: BoxDecoration(border: Border.all(color: Col.line, width: 1.5)),
        child: Text('// nenhum selo ainda. processe sua primeira pauta.',
            style: Fonts.mono(size: 11, color: Col.inkMute), textAlign: TextAlign.center),
      );
    }
    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        children: [
          for (final b in list) ...[
            _badgeTile(b),
            const SizedBox(width: 10),
          ],
        ],
      ),
    );
  }

  Widget _badgeTile(Badge b) {
    final isNew = unopened.contains(b.id);
    final cat = badgeCategories[b.category]!;
    return GestureDetector(
      onTap: () => onPick(b),
      child: Stack(clipBehavior: Clip.none, children: [
        Container(
          width: 88,
          padding: const EdgeInsets.fromLTRB(6, 12, 6, 10),
          decoration: BoxDecoration(
            color: Col.panel,
            border: Border.all(color: Color(cat.color), width: 2),
            boxShadow: isNew
                ? [BoxShadow(color: Color(cat.color).withValues(alpha: 0.55), blurRadius: 14)]
                : const [BoxShadow(offset: Offset(4, 4), color: Colors.black)],
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(b.emoji, style: const TextStyle(fontSize: 32, height: 1)),
            const SizedBox(height: 6),
            SizedBox(
              height: 18,
              child: Text(b.title.toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: Fonts.pixel(size: 7, color: Col.ink, letterSpacing: 0.5)),
            ),
          ]),
        ),
        if (isNew)
          Positioned(top: -6, right: -6, child: Container(
            width: 18, height: 18,
            decoration: BoxDecoration(color: Col.magenta, shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 2)),
            alignment: Alignment.center,
            child: Text('!', style: Fonts.pixel(size: 7, color: Colors.white)),
          )),
      ]),
    );
  }
}

// ─── BadgeMosaic — hex grid 6x4 with pan/zoom ────────────────────────────
class BadgeMosaic extends StatefulWidget {
  final Set<String> owned;
  final Set<String> unopened;
  final ValueChanged<Badge> onPick;
  const BadgeMosaic({super.key, required this.owned, required this.unopened, required this.onPick});
  @override
  State<BadgeMosaic> createState() => _BadgeMosaicState();
}

class _BadgeMosaicState extends State<BadgeMosaic> {
  static const cols = 6, rows = 4, hexW = 52.0, hexH = 58.0;
  double _zoom = 1.0;
  Offset _pan = Offset.zero;
  Offset _start = Offset.zero;
  double _zoomStart = 1.0;

  @override
  Widget build(BuildContext c) {
    final totalW = cols * hexW * 0.78 + hexW * 0.22;
    final totalH = rows * hexH + hexH * 0.5;
    return Container(
      height: 290,
      decoration: BoxDecoration(color: const Color(0xFF0A0A0A), border: Border.all(color: Col.line, width: 1.5)),
      clipBehavior: Clip.hardEdge,
      child: GestureDetector(
        onScaleStart: (d) { _start = _pan; _zoomStart = _zoom; },
        onScaleUpdate: (d) => setState(() {
          _zoom = (_zoomStart * d.scale).clamp(0.7, 2.5);
          _pan = _start + d.focalPointDelta;
        }),
        child: Stack(children: [
          const Scanlines(opacity: 0.06),
          Center(child: Transform.translate(
            offset: _pan,
            child: Transform.scale(
              scale: _zoom,
              child: SizedBox(width: totalW, height: totalH, child: Stack(children: [
                for (var r = 0; r < rows; r++)
                  for (var c = 0; c < cols; c++)
                    if (r * cols + c < badges.length) _hex(badges[r * cols + c], c, r),
              ])),
            ),
          )),
          Positioned(left: 8, top: 8, child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            color: const Color(0x99000000),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 8, height: 8, color: Col.magenta),
              const SizedBox(width: 3),
              Text(' SEU', style: Fonts.pixel(size: 7, color: Col.inkDim)),
              const SizedBox(width: 8),
              Container(width: 8, height: 8, decoration: BoxDecoration(color: const Color(0xFF0E1010), border: Border.all(color: Col.acid, width: 1.5))),
              const SizedBox(width: 3),
              Text(' FALTA', style: Fonts.pixel(size: 7, color: Col.inkDim)),
            ]),
          )),
          Positioned(left: 8, bottom: 8, child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            color: const Color(0x99000000),
            child: Text('${(_zoom * 100).round()}%', style: Fonts.pixel(size: 8, color: Col.acid, letterSpacing: 1)),
          )),
          Positioned(right: 8, bottom: 8, child: Column(children: [
            _zoomBtn('+', () => setState(() => _zoom = (_zoom + 0.2).clamp(0.7, 2.5))),
            const SizedBox(height: 4),
            _zoomBtn('−', () => setState(() => _zoom = (_zoom - 0.2).clamp(0.7, 2.5))),
            const SizedBox(height: 4),
            _zoomBtn('↺', () => setState(() { _zoom = 1; _pan = Offset.zero; })),
          ])),
        ]),
      ),
    );
  }

  Widget _zoomBtn(String glyph, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 28, height: 28,
          decoration: BoxDecoration(color: Colors.black, border: Border.all(color: Col.acid, width: 1.5)),
          alignment: Alignment.center,
          child: Text(glyph, style: Fonts.pixel(size: 14, color: Col.acid)),
        ),
      );

  Widget _hex(Badge b, int c, int r) {
    final isOwned = widget.owned.contains(b.id);
    final isNew = widget.unopened.contains(b.id);
    final x = c * hexW * 0.78;
    final y = r * hexH + (c.isOdd ? hexH * 0.5 : 0);
    return Positioned(
      left: x, top: y, width: hexW, height: hexH,
      child: GestureDetector(
        onTap: () => widget.onPick(b),
        child: ClipPath(
          clipper: _HexClipper(),
          child: Container(
            color: isOwned ? Col.magenta : const Color(0xFF0E1010),
            alignment: Alignment.center,
            child: Stack(alignment: Alignment.center, children: [
              if (!isOwned) Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(border: Border.all(color: Col.acid.withValues(alpha: 0.4), width: 2)),
              ),
              Text(isOwned ? b.emoji : '?', style: TextStyle(fontSize: 20, color: isOwned ? Colors.black : Col.acidD)),
              if (isNew) Positioned(top: 4, right: 6, child: Container(
                width: 8, height: 8,
                decoration: BoxDecoration(color: Col.acid, shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 1.5)),
              )),
            ]),
          ),
        ),
      ),
    );
  }
}

class _HexClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size sz) {
    final w = sz.width, h = sz.height;
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
  bool shouldReclip(_) => false;
}

// ─── LoaderShowcase — chrome wrapper to preview a loader widget ──────────
class LoaderShowcase extends StatelessWidget {
  final String id;
  final String title;
  final String subtitle;
  final Widget loader;
  const LoaderShowcase({super.key, required this.id, required this.title, required this.subtitle, required this.loader});
  @override
  Widget build(BuildContext c) => Container(
        color: Colors.black,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Col.line))),
            child: Row(children: [
              Text(id, style: Fonts.pixel(size: 9, color: Col.acid, letterSpacing: 1.5)),
              const SizedBox(width: 10),
              Expanded(child: Text(title, style: Fonts.body(size: 13, color: Col.ink, weight: FontWeight.w600))),
              Text(subtitle, style: Fonts.mono(size: 10, color: Col.inkMute)),
            ]),
          ),
          Expanded(child: loader),
        ]),
      );
}
