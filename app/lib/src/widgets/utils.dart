import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/ranking.dart';
import '../design/colors.dart';
import '../design/fonts.dart';
import 'atoms.dart';

// ─────────────────────────────────────────────────────────────────────
// ScreenRoot — base page layout (flex column + relative root)
// ─────────────────────────────────────────────────────────────────────
class ScreenRoot extends StatelessWidget {
  const ScreenRoot({super.key, required this.child, this.relative = true});
  final Widget child;
  final bool relative;

  @override
  Widget build(BuildContext context) {
    return Container(color: DCol.bg, child: child);
  }
}

// ─────────────────────────────────────────────────────────────────────
// BackHeader — header with back button + right slot
// ─────────────────────────────────────────────────────────────────────
class BackHeader extends StatelessWidget {
  const BackHeader({super.key, this.label = 'VOLTAR', this.onBack, this.right});
  final String label;
  final VoidCallback? onBack;
  final Widget? right;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: DCol.bg,
        border: Border(bottom: BorderSide(color: DCol.line)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          TextButton(
            onPressed: onBack,
            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0)),
            child: Text('← $label',
                style: DFont.pixel(size: 11, color: DCol.ink, letterSpacing: 1)),
          ),
          const Spacer(),
          if (right != null) right!,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// StickyFooter — bottom action row
// ─────────────────────────────────────────────────────────────────────
class StickyFooter extends StatelessWidget {
  const StickyFooter({super.key, required this.children, this.padding});
  final List<Widget> children;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: DCol.bg,
        border: Border(top: BorderSide(color: DCol.line)),
      ),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(children: children),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Toggle — on/off switch
// ─────────────────────────────────────────────────────────────────────
class Toggle extends StatelessWidget {
  const Toggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = ToggleSize.md,
    this.onColor = DCol.acid,
    this.offColor = DCol.panel,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final ToggleSize size;
  final Color onColor;
  final Color offColor;

  @override
  Widget build(BuildContext context) {
    final dim = size == ToggleSize.sm ? (w: 46.0, h: 24.0, k: 16.0) : (w: 50.0, h: 26.0, k: 18.0);
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: dim.w,
        height: dim.h,
        decoration: BoxDecoration(
          color: value ? onColor : offColor,
          border: Border.all(color: value ? onColor : DCol.line, width: 1.5),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 180),
              top: 2,
              left: value ? dim.w - dim.k - 4 : 2,
              child: Container(width: dim.k, height: dim.k, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

enum ToggleSize { sm, md }

// ─────────────────────────────────────────────────────────────────────
// StatBox — pixel label + big pixel number
// ─────────────────────────────────────────────────────────────────────
class StatBox extends StatelessWidget {
  const StatBox({
    super.key,
    required this.label,
    required this.value,
    this.color = DCol.ink,
    this.size = 22,
  });

  final String label;
  final String value;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: DFont.pixel(size: 8, color: DCol.inkMute, letterSpacing: 1.2)),
          const SizedBox(height: 4),
          Text(value, style: DFont.pixel(size: size, color: color)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// RankingPanel — your-rank cards + city top-5
// ─────────────────────────────────────────────────────────────────────
class RankingPanel extends StatelessWidget {
  const RankingPanel({super.key, required this.user, required this.score});
  final DUser user;
  final int score;

  @override
  Widget build(BuildContext context) {
    final ranks = computeRanks(score);
    final scopes = <_ScopeData>[
      _ScopeData(key: 'cidade', label: 'CIDADE', sub: 'São Paulo / SP', color: DCol.magenta, rank: ranks.cidade),
      _ScopeData(key: 'estado', label: 'ESTADO', sub: 'SP', color: DCol.acid, rank: ranks.estado),
      _ScopeData(key: 'pais', label: 'PAÍS', sub: 'Brasil', color: DCol.alert, rank: ranks.pais),
    ];

    final userRow = LbRow(rank: ranks.cidade.rank, who: user.pseudonym, seed: user.seed, score: score);
    final top = LEADERBOARD_CITY.take(5).toList();
    final showUserSeparately = !top.any((r) => r.who == user.pseudonym);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text('// SEU RANKING',
              style: DFont.pixel(size: 8, color: DCol.inkMute, letterSpacing: 1.5)),
        ),
        Row(
          children: [
            for (var i = 0; i < scopes.length; i++) ...[
              Expanded(child: _RankCard(s: scopes[i])),
              if (i < scopes.length - 1) const SizedBox(width: 6),
            ],
          ],
        ),
        const SizedBox(height: 18),
        Text('// TOP DA CIDADE',
            style: DFont.pixel(size: 8, color: DCol.inkMute, letterSpacing: 1.5)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: DCol.panel,
            border: Border.all(color: DCol.line, width: 1.5),
          ),
          child: Column(
            children: [
              ...top.map((row) => _topRow(row)),
              if (showUserSeparately) ...[
                Container(
                  color: const Color(0xFF0A0A0A),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  alignment: Alignment.center,
                  child: Text(
                    '···  vários ranks abaixo  ···',
                    style: DFont.mono(size: 9, color: DCol.inkMute, letterSpacing: 1),
                  ),
                ),
                Container(
                  color: const Color(0xFF1A0A14),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A0A14),
                    border: Border(top: BorderSide(color: DCol.magenta, width: 1.5)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 22,
                        child: Text('#${userRow.rank}',
                            textAlign: TextAlign.center,
                            style: DFont.pixel(size: 10, color: DCol.magenta)),
                      ),
                      const SizedBox(width: 10),
                      Avatar(seed: userRow.seed, size: 26),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(userRow.who,
                            overflow: TextOverflow.ellipsis,
                            style: DFont.mono(size: 11, color: DCol.ink)),
                      ),
                      const SizedBox(width: 6),
                      const PixelChip('VOCÊ', color: DCol.magenta, size: 6),
                      const SizedBox(width: 6),
                      Text('${userRow.score}',
                          style: DFont.pixel(size: 11, color: DCol.magenta)),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(border: Border.all(color: DCol.line)),
          child: Text(
            'ranking atualiza em tempo real conforme você processa pautas.',
            style: DFont.mono(size: 10, color: DCol.inkMute, height: 1.5),
          ),
        ),
      ],
    );
  }

  Widget _topRow(LbRow row) {
    final medal = row.rank == 1 ? '🥇' : row.rank == 2 ? '🥈' : row.rank == 3 ? '🥉' : null;
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: DCol.line)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 22,
            child: Text(
              medal ?? '#${row.rank}',
              textAlign: TextAlign.center,
              style: DFont.pixel(size: 10, color: row.rank <= 3 ? DCol.acid : DCol.inkMute),
            ),
          ),
          const SizedBox(width: 10),
          Avatar(seed: row.seed, size: 26),
          const SizedBox(width: 10),
          Expanded(
            child: Text(row.who,
                overflow: TextOverflow.ellipsis,
                style: DFont.mono(size: 11, color: DCol.ink)),
          ),
          Text('${row.score}', style: DFont.pixel(size: 11, color: DCol.acid)),
        ],
      ),
    );
  }
}

class _ScopeData {
  _ScopeData({required this.key, required this.label, required this.sub, required this.color, required this.rank});
  final String key;
  final String label;
  final String sub;
  final Color color;
  final ScopeRank rank;
}

class _RankCard extends StatelessWidget {
  const _RankCard({required this.s});
  final _ScopeData s;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: DCol.panel,
        border: Border(
          top: BorderSide(color: s.color, width: 3),
          left: const BorderSide(color: DCol.line, width: 1.5),
          right: const BorderSide(color: DCol.line, width: 1.5),
          bottom: const BorderSide(color: DCol.line, width: 1.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.label, style: DFont.pixel(size: 7, color: s.color, letterSpacing: 1)),
          const SizedBox(height: 3),
          Text(formatRank(s.rank.rank), style: DFont.pixel(size: 16, color: DCol.ink, height: 1)),
          const SizedBox(height: 3),
          Text('de ${formatNum(s.rank.total)}', style: DFont.mono(size: 9, color: DCol.inkDim)),
          Text('top ${topPercent(s.rank.rank, s.rank.total)}',
              style: DFont.mono(size: 9, color: s.color)),
        ],
      ),
    );
  }
}
