import 'dart:math' as math;

class LbRow {
  const LbRow({required this.rank, required this.who, required this.seed, required this.score});
  final int rank;
  final String who;
  final String seed;
  final int score;
}

const LEADERBOARD_CITY = <LbRow>[
  LbRow(rank: 1, who: 'Cidadão_SP_91cd', seed: 'Cidadão_SP_91cd', score: 247),
  LbRow(rank: 2, who: 'Cidadão_SP_bb22', seed: 'Cidadão_SP_bb22', score: 198),
  LbRow(rank: 3, who: 'Cidadão_SP_d013', seed: 'Cidadão_SP_d013', score: 156),
  LbRow(rank: 4, who: 'Cidadão_SP_aabb', seed: 'Cidadão_SP_aabb', score: 134),
  LbRow(rank: 5, who: 'Cidadão_SP_71fa', seed: 'Cidadão_SP_71fa', score: 118),
  LbRow(rank: 6, who: 'Cidadão_SP_ccdd', seed: 'Cidadão_SP_ccdd', score: 102),
];

const SCOPE_TOTALS = {'cidade': 4328, 'estado': 15918, 'pais': 89432};

class ScopeRank {
  const ScopeRank({required this.rank, required this.total});
  final int rank;
  final int total;
}

class RanksByScope {
  const RanksByScope({required this.cidade, required this.estado, required this.pais});
  final ScopeRank cidade;
  final ScopeRank estado;
  final ScopeRank pais;
}

RanksByScope computeRanks(int score) {
  const baseScore = 12;
  final delta = math.max(0, score - baseScore);
  return RanksByScope(
    cidade: ScopeRank(rank: math.max(1, 47 - delta * 2), total: SCOPE_TOTALS['cidade']!),
    estado: ScopeRank(rank: math.max(1, 312 - delta * 4), total: SCOPE_TOTALS['estado']!),
    pais: ScopeRank(rank: math.max(1, 2847 - delta * 9), total: SCOPE_TOTALS['pais']!),
  );
}

String formatRank(int n) => '#${_ptBR(n)}';
String formatNum(int n) => _ptBR(n);
String topPercent(int rank, int total) {
  if (total == 0) return '—';
  final pct = rank / total * 100;
  if (pct < 0.1) return '<0,1%';
  return '${pct.toStringAsFixed(1).replaceAll('.', ',')}%';
}

String _ptBR(int n) {
  final s = n.abs().toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return (n < 0 ? '-' : '') + buf.toString();
}
