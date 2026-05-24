import 'package:flutter/material.dart';

import '../design/colors.dart';

class DUser {
  DUser({required this.seed, required this.pseudonym, this.city = 'SP'});
  String seed;
  String pseudonym;
  String city;
}

class NewsItem {
  const NewsItem({
    required this.id,
    required this.urgent,
    required this.tag,
    required this.color,
    required this.title,
    required this.desc,
    required this.sources,
    required this.panel,
  });
  final String id;
  final bool urgent;
  final String tag;
  final Color color;
  final String title;
  final String desc;
  final List<String> sources;
  final String panel;
}

enum TopicScope { mun, est, fed }

class ForumTopic {
  ForumTopic({
    required this.id,
    required this.tag,
    required this.scope,
    required this.title,
    required this.body,
    required this.author,
    required this.replies,
    required this.age,
    this.live = false,
    this.hot = false,
    this.newReplies = 0,
    this.mine = false,
    this.seed,
  });
  final String id;
  final String tag;
  TopicScope scope;
  final String title;
  final String body;
  final String author;
  int replies;
  String age;
  bool live;
  bool hot;
  int newReplies;
  bool mine;
  String? seed;
}

class ForumReply {
  ForumReply({
    required this.id,
    required this.who,
    required this.age,
    required this.body,
    Map<String, int>? reacts,
    this.mine = false,
    this.seed,
  }) : reacts = reacts ?? {};
  final String id;
  final String who;
  final String age;
  final String body;
  final Map<String, int> reacts;
  final bool mine;
  final String? seed;
}

class Authority {
  const Authority({required this.role, required this.name, required this.handle});
  final String role;
  final String name;
  final String handle;
}

class AnalysisResult {
  const AnalysisResult({
    required this.theme,
    required this.color,
    required this.title,
    required this.desc,
    required this.authorities,
    required this.confidence,
  });
  final String theme;
  final Color color;
  final String title;
  final String desc;
  final List<Authority> authorities;
  final int confidence;
}

class DBadge {
  const DBadge({
    required this.id,
    required this.emoji,
    required this.title,
    required this.desc,
    required this.category,
    required this.tier,
  });
  final String id;
  final String emoji;
  final String title;
  final String desc;
  final String category;
  final int tier;
}

class BadgeCategory {
  const BadgeCategory({required this.label, required this.color});
  final String label;
  final Color color;
}

const BADGES = <DBadge>[
  DBadge(id: 'b01', emoji: '👁', title: 'Primeiro Vigia', desc: 'Completou o onboarding.', category: 'init', tier: 1),
  DBadge(id: 'b02', emoji: '⚡', title: 'Trincheira', desc: 'Escolheu sua cidade.', category: 'init', tier: 1),
  DBadge(id: 'b03', emoji: '🛡', title: 'Sem Login', desc: 'Aceitou usar o app sem ceder dados pessoais.', category: 'init', tier: 1),
  DBadge(id: 'b04', emoji: '🧠', title: 'Cérebro Local', desc: 'Baixou o modelo gemma-3-1b.', category: 'init', tier: 1),
  DBadge(id: 'b05', emoji: '🌱', title: 'Célula Nascendo', desc: 'Processou sua primeira pauta.', category: 'cell', tier: 1),
  DBadge(id: 'b06', emoji: '🔋', title: 'Célula Ativa', desc: '10 pautas processadas pelo seu aparelho.', category: 'cell', tier: 2),
  DBadge(id: 'b07', emoji: '⚙', title: 'Núcleo', desc: '100 pautas processadas.', category: 'cell', tier: 3),
  DBadge(id: 'b08', emoji: '👑', title: 'Célula-Mãe', desc: '500 pautas processadas.', category: 'cell', tier: 4),
  DBadge(id: 'b09', emoji: '🌐', title: 'Filho da Rede', desc: 'Ajudou peers em 5 cidades diferentes.', category: 'cell', tier: 3),
  DBadge(id: 'b10', emoji: '🚩', title: 'Primeira Pauta', desc: 'Publicou sua primeira pauta no fórum.', category: 'voice', tier: 1),
  DBadge(id: 'b11', emoji: '🔥', title: 'Viralizou', desc: 'Uma pauta sua passou de 100 reactions.', category: 'voice', tier: 3),
  DBadge(id: 'b12', emoji: '📣', title: 'Mobilizador', desc: 'Tópico seu passou de 50 replies.', category: 'voice', tier: 2),
  DBadge(id: 'b13', emoji: '🎯', title: 'Fiscal', desc: 'Cobrou 10 autoridades distintas.', category: 'voice', tier: 2),
  DBadge(id: 'b14', emoji: '⚖', title: 'Processo Aberto', desc: 'Sua pauta virou processo no MP ou TCE.', category: 'voice', tier: 4),
  DBadge(id: 'b15', emoji: '📰', title: 'Repórter', desc: 'Anexou fontes em 20 pautas.', category: 'sources', tier: 2),
  DBadge(id: 'b16', emoji: '🔍', title: 'Investigador', desc: 'Cruzou dados de 3 fontes oficiais.', category: 'sources', tier: 2),
  DBadge(id: 'b17', emoji: '📡', title: 'Antena', desc: 'Foi o primeiro a postar 5 pautas locais.', category: 'sources', tier: 3),
  DBadge(id: 'b18', emoji: '🤝', title: 'República', desc: 'Respondeu em 20 tópicos diferentes.', category: 'comm', tier: 2),
  DBadge(id: 'b19', emoji: '💬', title: 'Debatedor', desc: 'Recebeu 100 reactions em respostas.', category: 'comm', tier: 2),
  DBadge(id: 'b20', emoji: '🧑‍🏫', title: 'Mentor', desc: 'Resposta sua com mais de 50 reactions.', category: 'comm', tier: 3),
  DBadge(id: 'b21', emoji: '🌎', title: 'Voz Nacional', desc: 'Pauta federal sua virou trending.', category: 'comm', tier: 4),
  DBadge(id: 'b22', emoji: '🎖', title: 'Batismo', desc: '7 dias usando o app.', category: 'time', tier: 1),
  DBadge(id: 'b23', emoji: '⏳', title: 'Maratona', desc: '30 dias seguidos.', category: 'time', tier: 3),
  DBadge(id: 'b24', emoji: '🏛', title: 'Fundador', desc: 'Entrou entre os primeiros 1.000 da rede.', category: 'time', tier: 4),
];

const BADGE_CATEGORIES = <String, BadgeCategory>{
  'init': BadgeCategory(label: 'INÍCIO', color: DCol.alert),
  'cell': BadgeCategory(label: 'CÉLULA', color: DCol.acid),
  'voice': BadgeCategory(label: 'VOZ', color: DCol.magenta),
  'sources': BadgeCategory(label: 'FONTES', color: DCol.sources),
  'comm': BadgeCategory(label: 'COMUNIDADE', color: DCol.acidD),
  'time': BadgeCategory(label: 'TEMPO', color: DCol.time),
};
