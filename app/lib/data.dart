// data.dart — static prototype data: news feed, leaderboard, badges.

import 'design.dart';
import 'state.dart';

const news = <NewsItem>[
  NewsItem(id: 'n1', urgent: true, tag: 'TRANSPORTE', color: 0xFFFF1466,
      title: 'Linha 17-Ouro do metrô de SP atrasa mais 4 anos e custo triplica',
      desc: 'Obra licitada em 2011 com previsão para a Copa de 2014 agora tem entrega prevista para 2028. Custo passou de R\$ 1,6 bi para R\$ 4,8 bi.',
      sources: ['G1 SP', 'Folha · Cotidiano', 'D.O. Municipal'], panel: '🚇'),
  NewsItem(id: 'n2', tag: 'ORÇAMENTO', color: 0xFFB7FF2A,
      title: 'Câmara aprova orçamento 2026 sem ouvir audiências públicas',
      desc: 'Votação relâmpago em sessão extraordinária. Vereadores da oposição denunciam falta de tempo de análise.',
      sources: ['G1 SP', 'D.O. Câmara'], panel: '📑'),
  NewsItem(id: 'n3', tag: 'SAÚDE', color: 0xFFFFD60A,
      title: 'UBS do Capão Redondo sem pediatra há 3 meses, denuncia conselho',
      desc: 'Concurso de 2024 não foi homologado. Mais de 1.200 crianças cadastradas sem atendimento regular.',
      sources: ['Agência Pública', 'G1 SP'], panel: '🏥'),
  NewsItem(id: 'n4', tag: 'EDUCAÇÃO', color: 0xFFFF1466,
      title: 'Merenda escolar tem corte de 18% no orçamento da prefeitura',
      desc: 'Secretaria justifica com queda de matrículas. Sindicato aponta números inconsistentes.',
      sources: ['Folha', 'D.O. Municipal'], panel: '🍎'),
];

class RankRow {
  final int rank;
  final String who;
  final String seed;
  final int score;
  const RankRow({required this.rank, required this.who, required this.seed, required this.score});
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

class ScopedRank { final int rank; final int total; const ScopedRank(this.rank, this.total); }
Map<String, ScopedRank> computeRanks(int score) {
  const baseScore = 12;
  final delta = score > baseScore ? (score - baseScore) : 0;
  return {
    'cidade': ScopedRank((47 - delta * 2).clamp(1, 4328), scopeTotals['cidade']!),
    'estado': ScopedRank((312 - delta * 4).clamp(1, 15918), scopeTotals['estado']!),
    'pais': ScopedRank((2847 - delta * 9).clamp(1, 89432), scopeTotals['pais']!),
  };
}

class Badge {
  final String id;
  final String emoji;
  final String title;
  final String desc;
  final String category;
  final int tier;
  const Badge({required this.id, required this.emoji, required this.title, required this.desc, required this.category, required this.tier});
}

const badges = <Badge>[
  Badge(id: 'b01', emoji: '👁', title: 'Primeiro Vigia', desc: 'Completou o onboarding.', category: 'init', tier: 1),
  Badge(id: 'b02', emoji: '⚡', title: 'Trincheira', desc: 'Escolheu sua cidade.', category: 'init', tier: 1),
  Badge(id: 'b03', emoji: '🛡', title: 'Sem Login', desc: 'Aceitou usar o app sem ceder dados pessoais.', category: 'init', tier: 1),
  Badge(id: 'b04', emoji: '🧠', title: 'Cérebro Local', desc: 'Baixou o modelo gemma-3-1b.', category: 'init', tier: 1),
  Badge(id: 'b05', emoji: '🌱', title: 'Célula Nascendo', desc: 'Processou sua primeira pauta.', category: 'cell', tier: 1),
  Badge(id: 'b06', emoji: '🔋', title: 'Célula Ativa', desc: '10 pautas processadas pelo seu aparelho.', category: 'cell', tier: 2),
  Badge(id: 'b07', emoji: '⚙', title: 'Núcleo', desc: '100 pautas processadas.', category: 'cell', tier: 3),
  Badge(id: 'b08', emoji: '👑', title: 'Célula-Mãe', desc: '500 pautas processadas.', category: 'cell', tier: 4),
  Badge(id: 'b09', emoji: '🌐', title: 'Filho da Rede', desc: 'Ajudou peers em 5 cidades diferentes.', category: 'cell', tier: 3),
  Badge(id: 'b10', emoji: '🚩', title: 'Primeira Pauta', desc: 'Publicou sua primeira pauta no fórum.', category: 'voice', tier: 1),
  Badge(id: 'b11', emoji: '🔥', title: 'Viralizou', desc: 'Uma pauta sua passou de 100 reactions.', category: 'voice', tier: 3),
  Badge(id: 'b12', emoji: '📣', title: 'Mobilizador', desc: 'Tópico seu passou de 50 replies.', category: 'voice', tier: 2),
  Badge(id: 'b13', emoji: '🎯', title: 'Fiscal', desc: 'Cobrou 10 autoridades distintas.', category: 'voice', tier: 2),
  Badge(id: 'b14', emoji: '⚖', title: 'Processo Aberto', desc: 'Sua pauta virou processo no MP ou TCE.', category: 'voice', tier: 4),
  Badge(id: 'b15', emoji: '📰', title: 'Repórter', desc: 'Anexou fontes em 20 pautas.', category: 'sources', tier: 2),
  Badge(id: 'b16', emoji: '🔍', title: 'Investigador', desc: 'Cruzou dados de 3 fontes oficiais.', category: 'sources', tier: 2),
  Badge(id: 'b17', emoji: '📡', title: 'Antena', desc: 'Foi o primeiro a postar 5 pautas locais.', category: 'sources', tier: 3),
  Badge(id: 'b18', emoji: '🤝', title: 'República', desc: 'Respondeu em 20 tópicos diferentes.', category: 'comm', tier: 2),
  Badge(id: 'b19', emoji: '💬', title: 'Debatedor', desc: 'Recebeu 100 reactions em respostas.', category: 'comm', tier: 2),
  Badge(id: 'b20', emoji: '🧑‍🏫', title: 'Mentor', desc: 'Resposta sua com mais de 50 reactions.', category: 'comm', tier: 3),
  Badge(id: 'b21', emoji: '🌎', title: 'Voz Nacional', desc: 'Pauta federal sua virou trending.', category: 'comm', tier: 4),
  Badge(id: 'b22', emoji: '🎖', title: 'Batismo', desc: '7 dias usando o app.', category: 'time', tier: 1),
  Badge(id: 'b23', emoji: '⏳', title: 'Maratona', desc: '30 dias seguidos.', category: 'time', tier: 3),
  Badge(id: 'b24', emoji: '🏛', title: 'Fundador', desc: 'Entrou entre os primeiros 1.000 da rede.', category: 'time', tier: 4),
];

class BadgeCat { final String label; final int color; const BadgeCat(this.label, this.color); }
const badgeCategories = {
  'init': BadgeCat('INÍCIO', 0xFFFFD60A),
  'cell': BadgeCat('CÉLULA', 0xFFB7FF2A),
  'voice': BadgeCat('VOZ', 0xFFFF1466),
  'sources': BadgeCat('FONTES', 0xFF7FC8FF),
  'comm': BadgeCat('COMUNIDADE', 0xFF7FB800),
  'time': BadgeCat('TEMPO', 0xFFFF9933),
};
