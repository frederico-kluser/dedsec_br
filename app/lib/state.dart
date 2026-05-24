// state.dart — central app state replacing the React hooks layer.
// One ChangeNotifier holds: user, topics, replies, screen/tab routing,
// forum scope + selected topic, achievements ownership.

import 'dart:math' as math;
import 'package:flutter/widgets.dart';

// ─── Models ──────────────────────────────────────────────────────────────
class DedsecUser {
  final String seed;
  final String style;
  final String pseudonym;
  final String city;
  const DedsecUser({required this.seed, this.style = 'identicon', required this.pseudonym, this.city = 'SP'});

  DedsecUser copyWith({String? seed, String? style, String? pseudonym, String? city}) =>
      DedsecUser(seed: seed ?? this.seed, style: style ?? this.style, pseudonym: pseudonym ?? this.pseudonym, city: city ?? this.city);
}

class ForumTopic {
  final String id;
  final String tag;
  final String scope; // 'mun' | 'est' | 'fed'
  final String title;
  final String body;
  final String author;
  final String? seed;
  final int replies;
  final String age;
  final bool live;
  final bool hot;
  final int newReplies;
  final bool mine;
  const ForumTopic({
    required this.id,
    required this.tag,
    required this.scope,
    required this.title,
    required this.body,
    required this.author,
    this.seed,
    this.replies = 0,
    this.age = 'agora',
    this.live = false,
    this.hot = false,
    this.newReplies = 0,
    this.mine = false,
  });
  ForumTopic copyWith({int? newReplies}) => ForumTopic(
        id: id, tag: tag, scope: scope, title: title, body: body, author: author, seed: seed,
        replies: replies, age: age, live: live, hot: hot, mine: mine,
        newReplies: newReplies ?? this.newReplies,
      );
}

class ForumReply {
  final String id;
  final String who;
  final String? seed;
  final String age;
  final String body;
  final Map<String, int> reacts;
  final bool mine;
  const ForumReply({
    required this.id, required this.who, this.seed,
    required this.age, required this.body, this.reacts = const {}, this.mine = false,
  });
}

class NewsItem {
  final String id;
  final bool urgent;
  final String tag;
  final int color;
  final String title;
  final String desc;
  final List<String> sources;
  final String panel;
  const NewsItem({required this.id, this.urgent = false, required this.tag, required this.color, required this.title, required this.desc, required this.sources, required this.panel});
}

// ─── Random seed + pseudonym (mirrors useUser) ───────────────────────────
String randomSeed() {
  const chars = 'abcdef0123456789';
  final r = math.Random();
  return List.generate(6, (_) => chars[r.nextInt(chars.length)]).join();
}

String pseudonymFromSeed(String seed, [String city = 'SP']) => 'Cidadão_${city}_${seed.substring(seed.length - 4)}';

// ─── App-wide state ──────────────────────────────────────────────────────
class AppState extends ChangeNotifier {
  // user
  late DedsecUser user;

  // routing
  String screen = 'splash';
  String tab = 'home';

  // forum nav
  String forumScope = 'mun';
  ForumTopic? currentTopic;

  // topics + replies (in-memory store)
  late List<ForumTopic> topics;
  late List<ForumReply> topicReplies;

  // achievements
  final Set<String> ownedBadges;
  final Set<String> unopenedBadges;

  AppState()
      : ownedBadges = {'b01','b02','b03','b04','b05','b06','b10','b13','b15','b18','b22'},
        unopenedBadges = {'b06','b13','b18'} {
    final s = randomSeed();
    user = DedsecUser(seed: s, pseudonym: pseudonymFromSeed(s));
    topics = List.of(_initialTopics);
    topicReplies = List.of(_initialReplies);
  }

  // ─── Navigation ────────────────────────────────────────────────────────
  void go(String s) {
    screen = s;
    if (s == 'home') tab = 'home';
    if (s == 'help') tab = 'help';
    if (s == 'forum' || s == 'forum-list' || s == 'topic' || s == 'newpost') tab = 'forum';
    if (s == 'settings') tab = 'settings';
    notifyListeners();
  }

  void goTab(String t) {
    tab = t;
    if (t == 'home') screen = 'home';
    if (t == 'help') screen = 'help';
    if (t == 'forum') screen = 'forum';
    if (t == 'settings') screen = 'settings';
    notifyListeners();
  }

  // ─── User ──────────────────────────────────────────────────────────────
  void regenerateUser() {
    user = user.copyWith(seed: randomSeed());
    notifyListeners();
  }

  // ─── Forum nav ─────────────────────────────────────────────────────────
  void setForumScope(String s) { forumScope = s; notifyListeners(); }
  void setCurrentTopic(ForumTopic t) { currentTopic = t; notifyListeners(); }

  // ─── Topics + replies ──────────────────────────────────────────────────
  void addTopic(ForumTopic t) { topics = [t, ...topics]; notifyListeners(); }
  void markTopicSeen(String id) {
    topics = topics.map((t) => t.id == id ? t.copyWith(newReplies: 0) : t).toList();
    notifyListeners();
  }
  void addReply(String text) {
    final s = text.trim();
    if (s.isEmpty) return;
    topicReplies = [
      ...topicReplies,
      ForumReply(
        id: 'r${DateTime.now().millisecondsSinceEpoch}',
        who: user.pseudonym, seed: user.seed, age: 'agora', body: s, reacts: const {}, mine: true,
      ),
    ];
    notifyListeners();
  }
  void deleteReply(String id) {
    topicReplies = topicReplies.where((r) => r.id != id).toList();
    notifyListeners();
  }

  // ─── Achievements ──────────────────────────────────────────────────────
  void openBadge(String id) {
    if (unopenedBadges.remove(id)) notifyListeners();
  }
}

/// InheritedNotifier so descendants `AppState.of(context)` and rebuild on change.
class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({super.key, required AppState state, required super.child}) : super(notifier: state);
  static AppState of(BuildContext c) {
    final w = c.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(w != null, 'AppStateScope.of called with a context that does not contain one.');
    return w!.notifier!;
  }
}

// ─── Seed data ───────────────────────────────────────────────────────────
const _initialTopics = <ForumTopic>[
  ForumTopic(id: 't1', live: true, tag: 'TRANSPORTE', scope: 'mun', title: 'Linha 17-Ouro: como cobrar o TCE-SP?', author: 'Cidadão_SP_4a7b', replies: 87, age: '12 min', hot: true, newReplies: 5,
      body: 'Pessoal, vi a pauta no app hoje. Já mandei minha mensagem pro Nunes mas acho que cobrar pelo TCE é mais efetivo. Alguém aqui já abriu processo de denúncia? Como funciona?'),
  ForumTopic(id: 't2', tag: 'ORÇAMENTO', scope: 'mun', title: 'Audiência pública pulada — vamos ao MP?', author: 'Cidadão_SP_91cd', replies: 34, age: '1h', newReplies: 2,
      body: 'Vereadores aprovaram o orçamento 2026 em sessão extraordinária sem audiências públicas. Quem topa redigir representação pro Ministério Público?'),
  ForumTopic(id: 't3', live: true, tag: 'SAÚDE', scope: 'mun', title: 'Mutirão para denunciar falta de pediatra em Capão Redondo', author: 'Cidadão_SP_bb22', replies: 56, age: '2h', newReplies: 7,
      body: 'UBS sem pediatra há 3 meses. Vamos coordenar denúncia simultânea na Ouvidoria-SUS, no MP e na imprensa local.'),
  ForumTopic(id: 't4', tag: 'MEIO AMBIENTE', scope: 'est', title: 'Corte na fiscalização ambiental: alguém viu o edital?', author: 'Cidadão_SP_d013', replies: 12, age: '4h', newReplies: 1,
      body: 'Boato circulando que vão cortar 40% dos fiscais ambientais do estado. Tem confirmação? Vamos achar o edital ou D.O.'),
  ForumTopic(id: 't5', live: true, tag: 'CORRUPÇÃO', scope: 'est', title: 'CPI dos pedágios — sumiço de documentos?', author: 'Cidadão_SP_aabb', replies: 28, age: '7h', newReplies: 3, hot: true,
      body: 'Documentos requisitados pela CPI dos pedágios não chegaram à ALESP. Alguém sabe quem é o relator?'),
  ForumTopic(id: 't6', tag: 'CULTURA', scope: 'fed', title: 'Repasse pra museus suspenso há 4 meses — fontes?', author: 'Cidadão_SP_71fa', replies: 9, age: '6h',
      body: 'MINC anunciou retomada do repasse, mas museus dizem que nada chegou. Vamos cruzar dados do SIAFI.'),
  ForumTopic(id: 't7', live: true, tag: 'EDUCAÇÃO', scope: 'fed', title: 'PEC do FUNDEB: como pressionar pelos R\$ 7 bi', author: 'Cidadão_SP_ccdd', replies: 41, age: '1d', newReplies: 4,
      body: 'Senado adiou votação da PEC do FUNDEB pela 3ª vez. Lista de senadores indecisos: 22 nomes. Quem topa redigir e-mail conjunto?'),
];

const _initialReplies = <ForumReply>[
  ForumReply(id: 'r1', who: 'Cidadão_SP_91cd', seed: 'Cidadão_SP_91cd', age: '8 min', body: 'Já mandei pra ouvidoria do TCE-SP. Protocolo é OUVI-2026-001234. Quem quiser comentar lá, link no perfil oficial.', reacts: {'⚡': 23, '🔥': 12}),
  ForumReply(id: 'r2', who: 'Cidadão_SP_bb22', seed: 'Cidadão_SP_bb22', age: '6 min', body: 'Boa! Importante lembrar que o prazo de resposta da Ouvidoria do TCE é 20 dias úteis pela Lei 12.527. Vale acompanhar.', reacts: {'👍': 18}),
  ForumReply(id: 'r3', who: 'Cidadão_SP_d013', seed: 'Cidadão_SP_d013', age: '3 min', body: 'Tem alguém que entende de licitação e pode olhar os aditivos do contrato? Tá tudo público no D.O. mas é denso.', reacts: {'🤔': 9}),
];
