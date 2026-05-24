import 'package:flutter/material.dart';
import '../atoms/avatar.dart';
import '../atoms/dashed_box.dart';
import '../atoms/pixel_chip.dart';
import '../state/ranking.dart';
import '../state/user.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';

class RankingPanel extends StatelessWidget {
  final DedsecUser user;
  final int score;
  const RankingPanel({super.key, required this.user, required this.score});

  @override
  Widget build(BuildContext context) {
    final ranks = computeRanks(score);
    final scopes = [
      ('CIDADE', 'São Paulo / SP', DedsecColors.magenta, ranks.cidade),
      ('ESTADO', 'SP', DedsecColors.acid, ranks.estado),
      ('PAÍS', 'Brasil', DedsecColors.alert, ranks.pais),
    ];

    final userRow = (rank: ranks.cidade.rank, who: user.pseudonym, seed: user.seed, score: score);
    final top = leaderboardCity.take(5).toList();
    final showUserSeparately = !top.any((r) => r.who == user.pseudonym);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text('// SEU RANKING',
              style: DedsecFonts.pixel(size: 8, color: DedsecColors.inkMute, letterSpacing: 1.5)),
        ),
        Row(
          children: [
            for (var i = 0; i < scopes.length; i++) ...[
              if (i > 0) const SizedBox(width: 6),
              Expanded(child: _scopeCard(scopes[i])),
            ],
          ],
        ),
        const SizedBox(height: 18),
        Text('// TOP DA CIDADE',
            style: DedsecFonts.pixel(size: 8, color: DedsecColors.inkMute, letterSpacing: 1.5)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: DedsecColors.panel,
            border: Border.all(color: DedsecColors.line, width: 1.5),
          ),
          child: Column(children: [
            for (final row in top) _rankRow(row),
            if (showUserSeparately) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                color: const Color(0xFF0A0A0A),
                child: Text('···  vários ranks abaixo  ···',
                    textAlign: TextAlign.center,
                    style: DedsecFonts.mono(size: 9, color: DedsecColors.inkMute, letterSpacing: 1)),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF1A0A14),
                  border: Border(top: BorderSide(color: DedsecColors.magenta, width: 1.5)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(children: [
                  SizedBox(
                    width: 22,
                    child: Text('#${userRow.rank}',
                        textAlign: TextAlign.center,
                        style: DedsecFonts.pixel(size: 10, color: DedsecColors.magenta)),
                  ),
                  const SizedBox(width: 10),
                  Avatar(seed: userRow.seed, size: 26),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(userRow.who,
                        overflow: TextOverflow.ellipsis,
                        style: DedsecFonts.mono(size: 11, color: DedsecColors.ink)),
                  ),
                  const SizedBox(width: 6),
                  const PixelChip('VOCÊ', color: DedsecColors.magenta, size: 6),
                  const SizedBox(width: 6),
                  Text('${userRow.score}',
                      style: DedsecFonts.pixel(size: 11, color: DedsecColors.magenta)),
                ]),
              ),
            ],
          ]),
        ),
        const SizedBox(height: 10),
        DashedBox(
          color: DedsecColors.line,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'ranking atualiza em tempo real conforme você processa pautas.',
              style: DedsecFonts.mono(size: 10, color: DedsecColors.inkMute, letterSpacing: 0.4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _scopeCard((String, String, Color, ScopeRank) s) {
    final (label, _sub, color, data) = s;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: DedsecColors.panel,
        border: Border(
          top: BorderSide(color: color, width: 3),
          left: BorderSide(color: DedsecColors.line, width: 1.5),
          right: BorderSide(color: DedsecColors.line, width: 1.5),
          bottom: BorderSide(color: DedsecColors.line, width: 1.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: DedsecFonts.pixel(size: 7, color: color, letterSpacing: 1)),
          const SizedBox(height: 3),
          Text(formatRank(data.rank),
              style: DedsecFonts.pixel(size: 16, color: DedsecColors.ink)),
          const SizedBox(height: 3),
          Text('de ${formatNum(data.total)}',
              style: DedsecFonts.mono(size: 9, color: DedsecColors.inkDim)),
          Text('top ${topPercent(data.rank, data.total)}',
              style: DedsecFonts.mono(size: 9, color: color)),
        ],
      ),
    );
  }

  Widget _rankRow(RankRow row) {
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
        border: Border(bottom: BorderSide(color: DedsecColors.line)),
      ),
      child: Row(children: [
        SizedBox(
          width: 22,
          child: Text(
            medal ?? '#${row.rank}',
            textAlign: TextAlign.center,
            style: DedsecFonts.pixel(
              size: 10,
              color: row.rank <= 3 ? DedsecColors.acid : DedsecColors.inkMute,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Avatar(seed: row.seed, size: 26),
        const SizedBox(width: 10),
        Expanded(
          child: Text(row.who,
              overflow: TextOverflow.ellipsis,
              style: DedsecFonts.mono(size: 11, color: DedsecColors.ink)),
        ),
        Text('${row.score}', style: DedsecFonts.pixel(size: 11, color: DedsecColors.acid)),
      ]),
    );
  }
}
