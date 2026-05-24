import 'dart:math' as math;

class RankRow {
  final int rank;
  final String who;
  final String seed;
  final int score;
  const RankRow({required this.rank, required this.who, required this.seed, required this.score});
}

class ScopeRank {
  final int rank;
  final int total;
  const ScopeRank(this.rank, this.total);
}

class Ranks {
  final ScopeRank cidade;
  final ScopeRank estado;
  final ScopeRank pais;
  const Ranks(this.cidade, this.estado, this.pais);
}

const leaderboardCity = <RankRow>[
  RankRow(rank: 1, who: 'Cidadão_SP_91cd', seed: 'Cidadão_SP_91cd', score: 247),
  RankRow(rank: 2, who: 'Cidadão_SP_bb22', seed: 'Cidadão_SP_bb22', score: 198),
  RankRow(rank: 3, who: 'Cidadão_SP_d013', seed: 'Cidadão_SP_d013', score: 156),
  RankRow(rank: 4, who: 'Cidadão_SP_aabb', seed: 'Cidadão_SP_aabb', score: 134),
  RankRow(rank: 5, who: 'Cidadão_SP_71fa', seed: 'Cidadão_SP_71fa', score: 118),
  RankRow(rank: 6, who: 'Cidadão_SP_ccdd', seed: 'Cidadão_SP_ccdd', score: 102),
];

const scopeTotals = {'cidade': 4328, 'estado': 15918, 'pais': 89432};

Ranks computeRanks(int score) {
  const baseScore = 12;
  final delta = math.max(0, score - baseScore);
  return Ranks(
    ScopeRank(math.max(1, 47 - delta * 2), scopeTotals['cidade']!),
    ScopeRank(math.max(1, 312 - delta * 4), scopeTotals['estado']!),
    ScopeRank(math.max(1, 2847 - delta * 9), scopeTotals['pais']!),
  );
}

String formatRank(int n) => '#${formatNum(n)}';

String formatNum(int n) {
  // pt-BR thousands separator
  final s = n.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return buf.toString();
}

String topPercent(int rank, int total) {
  if (total == 0) return '—';
  final pct = (rank / total) * 100;
  if (pct < 0.1) return '<0,1%';
  return '${pct.toStringAsFixed(1).replaceAll('.', ',')}%';
}
