// utils.dart — shared layout/UI primitives: ScreenRoot, ScrollArea, BackHeader,
// StickyFooter, Toggle, StatBox, RankingPanel. Mirrors src/utils/.

import 'package:flutter/material.dart';
import 'atoms.dart';
import 'data.dart';
import 'design.dart';
import 'state.dart';

class ScreenRoot extends StatelessWidget {
  final Widget child;
  final bool relative;
  const ScreenRoot({super.key, required this.child, this.relative = true});
  @override
  Widget build(BuildContext c) => Container(color: Col.bg, child: child);
}

class ScrollArea extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Widget child;
  final ScrollController? controller;
  const ScrollArea({super.key, this.padding = EdgeInsets.zero, required this.child, this.controller});
  @override
  Widget build(BuildContext c) => Expanded(
        child: SingleChildScrollView(
          controller: controller,
          padding: padding,
          child: child,
        ),
      );
}

class BackHeader extends StatelessWidget {
  final String label;
  final VoidCallback? onBack;
  final Widget? trailing;
  const BackHeader({super.key, this.label = 'VOLTAR', this.onBack, this.trailing});
  @override
  Widget build(BuildContext c) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: const BoxDecoration(color: Col.bg, border: Border(bottom: BorderSide(color: Col.line))),
        child: Row(children: [
          GestureDetector(
            onTap: onBack,
            child: Text('← $label', style: Fonts.pixel(size: 11, color: Col.ink, letterSpacing: 1)),
          ),
          const Spacer(),
          if (trailing != null) trailing!,
        ]),
      );
}

class StickyFooter extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  const StickyFooter({super.key, required this.children, this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 14)});
  @override
  Widget build(BuildContext c) => Container(
        padding: padding,
        decoration: const BoxDecoration(color: Col.bg, border: Border(top: BorderSide(color: Col.line))),
        child: Row(children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(width: 10),
            children[i],
          ],
        ]),
      );
}

class Toggle extends StatelessWidget {
  final bool value;
  final VoidCallback onChanged;
  final String size;
  final Color onColor;
  final Color offColor;
  const Toggle({super.key, required this.value, required this.onChanged, this.size = 'md', this.onColor = Col.acid, this.offColor = Col.panel});
  @override
  Widget build(BuildContext c) {
    final dims = size == 'sm' ? const (w: 46.0, h: 24.0, k: 16.0) : const (w: 50.0, h: 26.0, k: 18.0);
    return GestureDetector(
      onTap: onChanged,
      child: Container(
        width: dims.w, height: dims.h,
        decoration: BoxDecoration(
          color: value ? onColor : offColor,
          border: Border.all(color: value ? onColor : Col.line, width: 1.5),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 180),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Container(width: dims.k, height: dims.k, color: Colors.black),
          ),
        ),
      ),
    );
  }
}

class StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final double size;
  const StatBox({super.key, required this.label, required this.value, this.color = Col.ink, this.size = 22});
  @override
  Widget build(BuildContext c) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: Fonts.pixel(size: 8, color: Col.inkMute, letterSpacing: 1.2)),
          const SizedBox(height: 4),
          Text(value, style: Fonts.pixel(size: size, color: color)),
        ]),
      );
}

class RankingPanel extends StatelessWidget {
  final DedsecUser user;
  final int score;
  const RankingPanel({super.key, required this.user, required this.score});
  @override
  Widget build(BuildContext c) {
    final ranks = computeRanks(score);
    final scopes = [
      ('CIDADE', 'São Paulo / SP', Col.magenta, ranks['cidade']!),
      ('ESTADO', 'SP', Col.acid, ranks['estado']!),
      ('PAÍS', 'Brasil', Col.alert, ranks['pais']!),
    ];
    final top = leaderboardCity.take(5).toList();
    final showUser = !top.any((r) => r.who == user.pseudonym);
    final userRank = ranks['cidade']!.rank;

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text('// SEU RANKING', style: Fonts.pixel(size: 8, color: Col.inkMute, letterSpacing: 1.5)),
      ),
      Row(children: [
        for (var i = 0; i < scopes.length; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          Expanded(child: _rankCard(scopes[i])),
        ],
      ]),
      const SizedBox(height: 18),
      Text('// TOP DA CIDADE', style: Fonts.pixel(size: 8, color: Col.inkMute, letterSpacing: 1.5)),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(color: Col.panel, border: Border.all(color: Col.line, width: 1.5)),
        child: Column(children: [
          for (final row in top)
            Container(
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Col.line))),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(children: [
                SizedBox(
                  width: 22,
                  child: Text(
                    row.rank == 1 ? '🥇' : row.rank == 2 ? '🥈' : row.rank == 3 ? '🥉' : '#${row.rank}',
                    textAlign: TextAlign.center,
                    style: Fonts.pixel(size: 10, color: row.rank <= 3 ? Col.acid : Col.inkMute),
                  ),
                ),
                const SizedBox(width: 10),
                Avatar(seed: row.seed, size: 26),
                const SizedBox(width: 10),
                Expanded(child: Text(row.who, overflow: TextOverflow.ellipsis, style: Fonts.mono(size: 11, color: Col.ink))),
                Text('${row.score}', style: Fonts.pixel(size: 11, color: Col.acid)),
              ]),
            ),
          if (showUser) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              color: const Color(0xFF0A0A0A),
              alignment: Alignment.center,
              child: Text('···  vários ranks abaixo  ···',
                  style: Fonts.mono(size: 9, color: Col.inkMute, letterSpacing: 1)),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF1A0A14),
                border: Border(top: BorderSide(color: Col.magenta, width: 1.5)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(children: [
                SizedBox(width: 22, child: Text('#$userRank', textAlign: TextAlign.center, style: Fonts.pixel(size: 10, color: Col.magenta))),
                const SizedBox(width: 10),
                Avatar(seed: user.seed, size: 26),
                const SizedBox(width: 10),
                Expanded(child: Text(user.pseudonym, overflow: TextOverflow.ellipsis, style: Fonts.mono(size: 11, color: Col.ink))),
                const PixelChip('VOCÊ', color: Col.magenta, size: 6),
                const SizedBox(width: 8),
                Text('$score', style: Fonts.pixel(size: 11, color: Col.magenta)),
              ]),
            ),
          ],
        ]),
      ),
      const SizedBox(height: 10),
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(border: Border.all(color: Col.line, width: 1)),
        child: Text('ranking atualiza em tempo real conforme você processa pautas.',
            style: Fonts.mono(size: 10, color: Col.inkMute, height: 1.5)),
      ),
    ]);
  }

  Widget _rankCard((String, String, Color, ScopedRank) tuple) {
    final (label, _, color, data) = tuple;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Col.panel,
        border: Border(
          top: BorderSide(color: color, width: 3),
          left: const BorderSide(color: Col.line, width: 1.5),
          right: const BorderSide(color: Col.line, width: 1.5),
          bottom: const BorderSide(color: Col.line, width: 1.5),
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: Fonts.pixel(size: 7, color: color, letterSpacing: 1)),
        const SizedBox(height: 4),
        Text(formatRank(data.rank), style: Fonts.pixel(size: 16, color: Col.ink)),
        const SizedBox(height: 3),
        Text('de ${formatNum(data.total)}', style: Fonts.mono(size: 9, color: Col.inkDim)),
        Text('top ${topPercent(data.rank, data.total)}', style: Fonts.mono(size: 9, color: color)),
      ]),
    );
  }
}
