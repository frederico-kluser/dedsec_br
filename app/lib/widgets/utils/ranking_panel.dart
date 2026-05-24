import 'package:flutter/material.dart';

import '../../data/ranking.dart';
import '../../models/user.dart';
import '../../theme/colors.dart';
import '../../theme/fonts.dart';
import '../../utils/format.dart';
import '../atoms/avatar.dart';
import '../atoms/text_atoms.dart';

/// `utils/RankingPanel` — user rank cards + city top-5.
class RankingPanel extends StatelessWidget {
  final DedsecUser user;
  final int score;
  const RankingPanel({super.key, required this.user, required this.score});

  @override
  Widget build(BuildContext context) {
    final ranks = computeRanks(score);
    final scopes = [
      _Scope(label: 'CIDADE', sub: 'São Paulo / SP', color: COL.magenta, data: ranks.cidade),
      _Scope(label: 'ESTADO', sub: 'SP', color: COL.acid, data: ranks.estado),
      _Scope(label: 'PAÍS', sub: 'Brasil', color: COL.alert, data: ranks.pais),
    ];

    final top = kLeaderboardCity.take(5).toList();
    final showUserSeparately = !top.any((r) => r.who == user.pseudonym);
    final userRow = LeaderboardRow(
      rank: ranks.cidade.rank,
      who: user.pseudonym,
      seed: user.seed,
      score: score,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('// SEU RANKING',
            style: FONT.pixel(size: 8, color: COL.inkMute, letterSpacing: 1.5)),
        const SizedBox(height: 8),
        Row(
          children: [
            for (var i = 0; i < scopes.length; i++) ...[
              if (i > 0) const SizedBox(width: 6),
              Expanded(child: _RankCard(scope: scopes[i])),
            ],
          ],
        ),
        const SizedBox(height: 18),
        Text('// TOP DA CIDADE',
            style: FONT.pixel(size: 8, color: COL.inkMute, letterSpacing: 1.5)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: COL.panel,
            border: Border.all(color: COL.line, width: 1.5),
          ),
          child: Column(
            children: [
              for (final row in top) _LeaderRow(row: row),
              if (showUserSeparately) ...[
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  color: const Color(0xFF0A0A0A),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    '···  vários ranks abaixo  ···',
                    style: FONT.mono(size: 9, color: COL.inkMute, letterSpacing: 1),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A0A14),
                    border: Border(top: BorderSide(color: COL.magenta, width: 1.5)),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 22,
                        child: Text(
                          '#${userRow.rank}',
                          textAlign: TextAlign.center,
                          style: FONT.pixel(size: 10, color: COL.magenta),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Avatar(seed: userRow.seed, size: 26),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          userRow.who,
                          overflow: TextOverflow.ellipsis,
                          style: FONT.mono(size: 11, color: COL.ink),
                        ),
                      ),
                      const PixelChip('VOCÊ', color: COL.magenta, size: 6),
                      const SizedBox(width: 6),
                      Text('${userRow.score}',
                          style: FONT.pixel(size: 11, color: COL.magenta)),
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
          decoration: BoxDecoration(
            border: Border.all(color: COL.line),
          ),
          child: Text(
            'ranking atualiza em tempo real conforme você processa pautas.',
            style: FONT.mono(size: 10, color: COL.inkMute, height: 1.5),
          ),
        ),
      ],
    );
  }
}

class _Scope {
  final String label;
  final String sub;
  final Color color;
  final ScopeRank data;
  const _Scope({required this.label, required this.sub, required this.color, required this.data});
}

class _RankCard extends StatelessWidget {
  final _Scope scope;
  const _RankCard({required this.scope});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: COL.panel,
        border: Border(
          top: BorderSide(color: scope.color, width: 3),
          left: const BorderSide(color: COL.line, width: 1.5),
          right: const BorderSide(color: COL.line, width: 1.5),
          bottom: const BorderSide(color: COL.line, width: 1.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(scope.label, style: FONT.pixel(size: 7, color: scope.color)),
          const SizedBox(height: 3),
          Text(formatRank(scope.data.rank),
              style: FONT.pixel(size: 16, color: COL.ink, letterSpacing: 0)),
          const SizedBox(height: 3),
          Text('de ${formatNum(scope.data.total)}',
              style: FONT.mono(size: 9, color: COL.inkDim)),
          const SizedBox(height: 3),
          Text('top ${topPercent(scope.data.rank, scope.data.total)}',
              style: FONT.mono(size: 9, color: scope.color)),
        ],
      ),
    );
  }
}

class _LeaderRow extends StatelessWidget {
  final LeaderboardRow row;
  const _LeaderRow({required this.row});

  @override
  Widget build(BuildContext context) {
    final medal = row.rank == 1
        ? '🥇'
        : row.rank == 2
            ? '🥈'
            : row.rank == 3
                ? '🥉'
                : null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: COL.line)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 22,
            child: Text(
              medal ?? '#${row.rank}',
              textAlign: TextAlign.center,
              style: FONT.pixel(
                size: 10,
                color: row.rank <= 3 ? COL.acid : COL.inkMute,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Avatar(seed: row.seed, size: 26),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              row.who,
              overflow: TextOverflow.ellipsis,
              style: FONT.mono(size: 11, color: COL.ink),
            ),
          ),
          Text('${row.score}', style: FONT.pixel(size: 11, color: COL.acid)),
        ],
      ),
    );
  }
}
