import 'dart:math' as math;

class LeaderboardRow {
  final int rank;
  final String who;
  final String seed;
  final int score;
  const LeaderboardRow({
    required this.rank,
    required this.who,
    required this.seed,
    required this.score,
  });
}

const List<LeaderboardRow> kLeaderboardCity = [
  LeaderboardRow(rank: 1, who: 'Cidadão_SP_91cd', seed: 'Cidadão_SP_91cd', score: 247),
  LeaderboardRow(rank: 2, who: 'Cidadão_SP_bb22', seed: 'Cidadão_SP_bb22', score: 198),
  LeaderboardRow(rank: 3, who: 'Cidadão_SP_d013', seed: 'Cidadão_SP_d013', score: 156),
  LeaderboardRow(rank: 4, who: 'Cidadão_SP_aabb', seed: 'Cidadão_SP_aabb', score: 134),
  LeaderboardRow(rank: 5, who: 'Cidadão_SP_71fa', seed: 'Cidadão_SP_71fa', score: 118),
  LeaderboardRow(rank: 6, who: 'Cidadão_SP_ccdd', seed: 'Cidadão_SP_ccdd', score: 102),
];

const Map<String, int> kScopeTotals = {
  'cidade': 4328,
  'estado': 15918,
  'pais': 89432,
};

class ScopeRank {
  final int rank;
  final int total;
  const ScopeRank(this.rank, this.total);
}

class Ranks {
  final ScopeRank cidade;
  final ScopeRank estado;
  final ScopeRank pais;
  const Ranks({required this.cidade, required this.estado, required this.pais});
}

Ranks computeRanks(int score) {
  const baseScore = 12;
  final delta = math.max(0, score - baseScore);
  return Ranks(
    cidade: ScopeRank(math.max(1, 47 - delta * 2), kScopeTotals['cidade']!),
    estado: ScopeRank(math.max(1, 312 - delta * 4), kScopeTotals['estado']!),
    pais: ScopeRank(math.max(1, 2847 - delta * 9), kScopeTotals['pais']!),
  );
}
