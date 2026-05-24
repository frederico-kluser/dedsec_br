import 'package:flutter/painting.dart';

import '../models/badge.dart';
import '../theme/colors.dart';

const List<DedsecBadge> kBadges = [
  // INIT
  DedsecBadge(id: 'b01', emoji: '👁', title: 'Primeiro Vigia', desc: 'Completou o onboarding.', category: BadgeCategory.init, tier: 1),
  DedsecBadge(id: 'b02', emoji: '⚡', title: 'Trincheira', desc: 'Escolheu sua cidade.', category: BadgeCategory.init, tier: 1),
  DedsecBadge(id: 'b03', emoji: '🛡', title: 'Sem Login', desc: 'Aceitou usar o app sem ceder dados pessoais.', category: BadgeCategory.init, tier: 1),
  DedsecBadge(id: 'b04', emoji: '🧠', title: 'Cérebro Local', desc: 'Baixou o modelo gemma-3-1b.', category: BadgeCategory.init, tier: 1),
  // CELL
  DedsecBadge(id: 'b05', emoji: '🌱', title: 'Célula Nascendo', desc: 'Processou sua primeira pauta.', category: BadgeCategory.cell, tier: 1),
  DedsecBadge(id: 'b06', emoji: '🔋', title: 'Célula Ativa', desc: '10 pautas processadas pelo seu aparelho.', category: BadgeCategory.cell, tier: 2),
  DedsecBadge(id: 'b07', emoji: '⚙', title: 'Núcleo', desc: '100 pautas processadas.', category: BadgeCategory.cell, tier: 3),
  DedsecBadge(id: 'b08', emoji: '👑', title: 'Célula-Mãe', desc: '500 pautas processadas.', category: BadgeCategory.cell, tier: 4),
  DedsecBadge(id: 'b09', emoji: '🌐', title: 'Filho da Rede', desc: 'Ajudou peers em 5 cidades diferentes.', category: BadgeCategory.cell, tier: 3),
  // VOICE
  DedsecBadge(id: 'b10', emoji: '🚩', title: 'Primeira Pauta', desc: 'Publicou sua primeira pauta no fórum.', category: BadgeCategory.voice, tier: 1),
  DedsecBadge(id: 'b11', emoji: '🔥', title: 'Viralizou', desc: 'Uma pauta sua passou de 100 reactions.', category: BadgeCategory.voice, tier: 3),
  DedsecBadge(id: 'b12', emoji: '📣', title: 'Mobilizador', desc: 'Tópico seu passou de 50 replies.', category: BadgeCategory.voice, tier: 2),
  DedsecBadge(id: 'b13', emoji: '🎯', title: 'Fiscal', desc: 'Cobrou 10 autoridades distintas.', category: BadgeCategory.voice, tier: 2),
  DedsecBadge(id: 'b14', emoji: '⚖', title: 'Processo Aberto', desc: 'Sua pauta virou processo no MP ou TCE.', category: BadgeCategory.voice, tier: 4),
  // SOURCES
  DedsecBadge(id: 'b15', emoji: '📰', title: 'Repórter', desc: 'Anexou fontes em 20 pautas.', category: BadgeCategory.sources, tier: 2),
  DedsecBadge(id: 'b16', emoji: '🔍', title: 'Investigador', desc: 'Cruzou dados de 3 fontes oficiais.', category: BadgeCategory.sources, tier: 2),
  DedsecBadge(id: 'b17', emoji: '📡', title: 'Antena', desc: 'Foi o primeiro a postar 5 pautas locais.', category: BadgeCategory.sources, tier: 3),
  // COMM
  DedsecBadge(id: 'b18', emoji: '🤝', title: 'República', desc: 'Respondeu em 20 tópicos diferentes.', category: BadgeCategory.comm, tier: 2),
  DedsecBadge(id: 'b19', emoji: '💬', title: 'Debatedor', desc: 'Recebeu 100 reactions em respostas.', category: BadgeCategory.comm, tier: 2),
  DedsecBadge(id: 'b20', emoji: '🧑‍🏫', title: 'Mentor', desc: 'Resposta sua com mais de 50 reactions.', category: BadgeCategory.comm, tier: 3),
  DedsecBadge(id: 'b21', emoji: '🌎', title: 'Voz Nacional', desc: 'Pauta federal sua virou trending.', category: BadgeCategory.comm, tier: 4),
  // TIME
  DedsecBadge(id: 'b22', emoji: '🎖', title: 'Batismo', desc: '7 dias usando o app.', category: BadgeCategory.time, tier: 1),
  DedsecBadge(id: 'b23', emoji: '⏳', title: 'Maratona', desc: '30 dias seguidos.', category: BadgeCategory.time, tier: 3),
  DedsecBadge(id: 'b24', emoji: '🏛', title: 'Fundador', desc: 'Entrou entre os primeiros 1.000 da rede.', category: BadgeCategory.time, tier: 4),
];

const Map<BadgeCategory, BadgeCategoryMeta> kBadgeCategories = {
  BadgeCategory.init: BadgeCategoryMeta('INÍCIO', COL.alert),
  BadgeCategory.cell: BadgeCategoryMeta('CÉLULA', COL.acid),
  BadgeCategory.voice: BadgeCategoryMeta('VOZ', COL.magenta),
  BadgeCategory.sources: BadgeCategoryMeta('FONTES', COL.blue),
  BadgeCategory.comm: BadgeCategoryMeta('COMUNIDADE', COL.acidD),
  BadgeCategory.time: BadgeCategoryMeta('TEMPO', Color(0xFFFF9933)),
};
