// pages/comm.dart — Help, Achievements, ForumScope, ForumList, Topic, NewPost.

import 'dart:async';
import 'package:flutter/material.dart' hide Badge;
import '../atoms.dart';
import '../data.dart';
import '../design.dart';
import '../molecules.dart';
import '../organisms.dart';
import '../state.dart';
import '../utils.dart';

// ─── 10 Help (mutirão LLM) ────────────────────────────────────────────────
class ScreenHelp extends StatefulWidget {
  const ScreenHelp({super.key});
  @override
  State<ScreenHelp> createState() => _ScreenHelpState();
}

class _ScreenHelpState extends State<ScreenHelp> {
  bool _auto = true;
  String _proc = 'idle'; // idle | processing | done
  int _score = 12;
  Timer? _t1, _t2;

  void _start() {
    if (_proc != 'idle') return;
    setState(() => _proc = 'processing');
    _t1 = Timer(const Duration(milliseconds: 6500), () {
      if (!mounted) return;
      setState(() { _score++; _proc = 'done'; });
      _t2 = Timer(const Duration(milliseconds: 2400), () { if (mounted) setState(() => _proc = 'idle'); });
    });
  }

  @override
  void dispose() { _t1?.cancel(); _t2?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext c) {
    final app = AppStateScope.of(c);
    return Stack(children: [
      Column(children: [
        const TopBar(),
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(18, 22, 18, 90), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const PixelChip('MUTIRÃO_LLM', color: Col.magenta),
          const SizedBox(height: 12),
          StencilSpan(TextSpan(children: [
            const TextSpan(text: 'AJUDE A\n'),
            TextSpan(text: 'CÉLULA', style: TextStyle(color: Col.magenta, shadows: [Shadow(offset: Offset(3, 3), color: Col.acid)])),
          ]), size: 42),
          const SizedBox(height: 12),
          Text.rich(TextSpan(children: [
            TextSpan(text: 'Seu celular processa ', style: Fonts.body(size: 13, color: Col.inkDim, height: 1.55)),
            TextSpan(text: '1 pauta em ~60s', style: Fonts.body(size: 13, color: Col.ink, height: 1.55, weight: FontWeight.w700)),
            TextSpan(text: '. O resultado aparece no feed de outros usuários da sua cidade.', style: Fonts.body(size: 13, color: Col.inkDim, height: 1.55)),
          ])),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Col.panel,
              border: Border.all(color: Col.acid, width: 2),
              boxShadow: const [BoxShadow(offset: Offset(4, 4), color: Col.line)],
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(width: 12, height: 12, color: Col.acid),
                const SizedBox(width: 8),
                Text('DISPOSITIVO PRONTO', style: Fonts.pixel(size: 10, color: Col.acid, letterSpacing: 1.5)),
              ]),
              const SizedBox(height: 4),
              Text('wifi · 4.8GB livre · 34°C · 87% bateria',
                  style: Fonts.mono(size: 10, color: Col.inkDim)),
              const SizedBox(height: 16),
              Btn('▶ PROCESSAR 1 PAUTA', color: Col.magenta, fg: Colors.white, full: true,
                  disabled: _proc != 'idle', onTap: _start),
            ]),
          ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(color: Col.panel, border: Border.all(color: Col.line, width: 1.5)),
            child: Row(children: [
              Expanded(child: StatBox(label: 'VOCÊ HOJE', value: '$_score')),
              Container(width: 1, color: Col.line),
              Expanded(child: StatBox(label: 'COMUNIDADE', value: formatNum(scopeTotals['cidade']!), color: Col.acid)),
            ]),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(color: Col.panel, border: Border.all(color: Col.line, width: 1.5)),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Modo automático', style: Fonts.body(size: 13, color: Col.ink, weight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text('roda só plugado + wifi + tela apagada',
                    style: Fonts.mono(size: 10, color: Col.inkDim)),
              ])),
              Toggle(value: _auto, onChanged: () => setState(() => _auto = !_auto), size: 'sm'),
            ]),
          ),
          const SizedBox(height: 22),
          RankingPanel(user: app.user, score: _score),
          const SizedBox(height: 22),
          GestureDetector(
            onTap: () => app.go('achievements'),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Col.panel,
                border: Border.all(color: Col.magenta, width: 1.5),
                boxShadow: const [BoxShadow(offset: Offset(4, 4), color: Colors.black)],
              ),
              child: Row(children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(color: Col.magenta, border: Border.all(color: Colors.black, width: 2)),
                  alignment: Alignment.center,
                  child: const Text('🏅', style: TextStyle(fontSize: 26)),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('SUA COLEÇÃO', style: Fonts.pixel(size: 9, color: Col.magenta, letterSpacing: 1.2)),
                  const SizedBox(height: 4),
                  Text('Selos conquistados', style: Fonts.body(size: 13, color: Col.ink, weight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text.rich(TextSpan(children: [
                    TextSpan(text: '11/24 desbloqueados · ', style: Fonts.mono(size: 10, color: Col.inkDim)),
                    TextSpan(text: '3 novos pra abrir', style: Fonts.mono(size: 10, color: Col.magenta)),
                  ])),
                ])),
                Text('›', style: TextStyle(color: Col.inkMute, fontSize: 18)),
              ]),
            ),
          ),
        ]))),
        TabBarNav(active: app.tab, onTab: app.goTab),
      ]),
      if (_proc == 'processing') Positioned.fill(child: Container(
        color: const Color(0xFA020608),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: const BoxDecoration(color: Color(0xFF050A08), border: Border(bottom: BorderSide(color: Col.line))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(width: 8, height: 8, color: Col.acid),
                const SizedBox(width: 8),
                const PixelChip('MUTIRÃO · 1/1', color: Col.acid, size: 8),
                const Spacer(),
                GestureDetector(
                  onTap: () { _t1?.cancel(); setState(() => _proc = 'idle'); },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(border: Border.all(color: Col.line)),
                    child: Text('CANCELAR', style: Fonts.pixel(size: 8, color: Col.inkDim, letterSpacing: 1)),
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              StencilSpan(TextSpan(children: [
                const TextSpan(text: 'PROCESSANDO\n'),
                TextSpan(text: 'PAUTA DA FILA', style: TextStyle(color: Col.acid)),
              ]), size: 20),
            ]),
          ),
          const TokenStreamPanel(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: Col.line))),
            child: Text('// gemma-3-1b roda 100% local. seu celular contribui pra rede.',
                style: Fonts.mono(size: 10, color: Col.inkDim, height: 1.55)),
          ),
        ]),
      )),
      if (_proc == 'done') Positioned.fill(child: Container(
        color: Col.bg,
        padding: const EdgeInsets.all(22),
        child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 120, height: 120,
            decoration: BoxDecoration(
              color: Col.acid, border: Border.all(color: Colors.black, width: 4),
              boxShadow: const [BoxShadow(offset: Offset(6, 6), color: Colors.black)],
            ),
            alignment: Alignment.center,
            child: Text('✓', style: Fonts.pixel(size: 60, color: Colors.black)),
          ),
          const SizedBox(height: 26),
          StencilSpan(TextSpan(children: [
            const TextSpan(text: '+1 PAUTA\n'),
            TextSpan(text: 'PROCESSADA', style: TextStyle(color: Col.acid)),
          ]), size: 38, align: TextAlign.center),
          const SizedBox(height: 12),
          Text('obrigado por ajudar a célula.',
              style: Fonts.mono(size: 11, color: Col.inkDim, letterSpacing: 1)),
        ])),
      )),
    ]);
  }
}

// ─── 11 Achievements ──────────────────────────────────────────────────────
class ScreenAchievements extends StatefulWidget {
  const ScreenAchievements({super.key});
  @override
  State<ScreenAchievements> createState() => _ScreenAchievementsState();
}

class _ScreenAchievementsState extends State<ScreenAchievements> {
  Badge? _active;
  @override
  Widget build(BuildContext c) {
    final app = AppStateScope.of(c);
    final owned = app.ownedBadges;
    final unopened = app.unopenedBadges;
    void pick(Badge b) {
      if (owned.contains(b.id) && unopened.contains(b.id)) app.openBadge(b.id);
      setState(() => _active = b);
    }
    return Stack(children: [
      Column(children: [
        BackHeader(label: 'VOLTAR', onBack: () => app.go('help'),
            trailing: PixelChip('${owned.length}/${badges.length} SELOS', color: Col.acid, size: 8)),
        ScrollArea(padding: const EdgeInsets.fromLTRB(16, 18, 16, 80), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const PixelChip('// COLEÇÃO', color: Col.magenta),
          const SizedBox(height: 10),
          StencilSpan(TextSpan(children: [
            const TextSpan(text: 'SELOS\n'),
            TextSpan(text: 'CONQUISTADOS', style: TextStyle(color: Col.magenta, shadows: [Shadow(offset: Offset(3, 3), color: Col.acid)])),
          ]), size: 36),
          const SizedBox(height: 10),
          Text.rich(TextSpan(children: [
            TextSpan(text: 'Você desbloqueou ', style: Fonts.body(size: 13, color: Col.inkDim, height: 1.5)),
            TextSpan(text: '${owned.length}', style: Fonts.body(size: 13, color: Col.acid, height: 1.5, weight: FontWeight.w700)),
            TextSpan(text: ' de ${badges.length}. ', style: Fonts.body(size: 13, color: Col.inkDim, height: 1.5)),
            if (unopened.isNotEmpty) TextSpan(text: '${unopened.length} novos pra abrir.',
                style: Fonts.body(size: 13, color: Col.magenta, height: 1.5)),
          ])),
          const SizedBox(height: 18),
          Text('// SEUS SELOS', style: Fonts.pixel(size: 8, color: Col.inkMute, letterSpacing: 1.5)),
          const SizedBox(height: 4),
          BadgeCarousel(owned: owned, unopened: unopened, onPick: pick),
          const SizedBox(height: 14),
          Text('// MOSAICO DA COLEÇÃO · pinch / scroll p/ zoom',
              style: Fonts.pixel(size: 8, color: Col.inkMute, letterSpacing: 1.5)),
          const SizedBox(height: 8),
          BadgeMosaic(owned: owned, unopened: unopened, onPick: pick),
          const SizedBox(height: 14),
          Wrap(spacing: 6, runSpacing: 6, children: [
            for (final entry in badgeCategories.entries) ...[
              Builder(builder: (_) {
                final catBadges = badges.where((b) => b.category == entry.key).toList();
                final catOwned = catBadges.where((b) => owned.contains(b.id)).length;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(color: Colors.black, border: Border.all(color: Color(entry.value.color))),
                  child: Text('${entry.value.label} $catOwned/${catBadges.length}',
                      style: Fonts.pixel(size: 8, color: Color(entry.value.color), letterSpacing: 0.8)),
                );
              }),
            ],
          ]),
        ])),
      ]),
      if (_active != null) Positioned.fill(child: BadgeShareModal(
        badge: _active!, user: app.user,
        isLocked: !owned.contains(_active!.id),
        onClose: () => setState(() => _active = null),
      )),
    ]);
  }
}

// ─── 12 ForumScope ────────────────────────────────────────────────────────
const _forumScopes = [
  ('mun', 'MUNICIPAL', Col.magenta, 'São Paulo / SP', '◉'),
  ('est', 'ESTADUAL', Col.acid, 'Estado de São Paulo', '◐'),
  ('fed', 'FEDERAL', Col.alert, 'Brasil inteiro', '◯'),
];

class ScreenForumScope extends StatelessWidget {
  const ScreenForumScope({super.key});
  @override
  Widget build(BuildContext c) {
    final app = AppStateScope.of(c);
    ({int total, int newReplies, bool hot}) stats(String sid) {
      final list = app.topics.where((t) => t.scope == sid);
      return (
        total: list.length,
        newReplies: list.fold<int>(0, (s, t) => s + t.newReplies),
        hot: list.any((t) => t.hot),
      );
    }
    void pick(String sid) { app.setForumScope(sid); app.go('forum-list'); }
    return Column(children: [
      const TopBar(),
      Padding(padding: const EdgeInsets.fromLTRB(18, 22, 18, 14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const PixelChip('FÓRUM CÍVICO', color: Col.acid),
        const SizedBox(height: 12),
        StencilSpan(TextSpan(children: [
          const TextSpan(text: 'ESCOLHA O\n'),
          TextSpan(text: 'NÍVEL', style: TextStyle(color: Col.magenta, shadows: [Shadow(offset: Offset(3, 3), color: Col.acid)])),
        ]), size: 42),
        const SizedBox(height: 8),
        Text('// pautas separadas por escopo geográfico.\n// novos posts no seu escopo aparecem com badge.',
            style: Fonts.mono(size: 10, color: Col.inkDim, height: 1.5)),
      ])),
      ScrollArea(padding: const EdgeInsets.fromLTRB(18, 0, 18, 90), child: Column(children: [
        for (final s in _forumScopes) ...[
          _scopeCard(s, stats(s.$1), () => pick(s.$1)),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Col.panel, border: Border.all(color: Col.line, width: 1.5)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('// REGRA', style: Fonts.pixel(size: 9, color: Col.acid)),
            const SizedBox(height: 8),
            Text('Você só posta no escopo da sua cidade (municipal).\nEstadual e federal você lê + reage + vota.',
                style: Fonts.mono(size: 10, color: Col.inkDim, height: 1.55)),
          ]),
        ),
      ])),
      TabBarNav(active: app.tab, onTab: app.goTab),
    ]);
  }

  Widget _scopeCard((String, String, Color, String, String) s, ({int total, int newReplies, bool hot}) st, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Col.panel, border: Border.all(color: Col.line, width: 1.5),
            boxShadow: const [BoxShadow(offset: Offset(4, 4), color: Colors.black)],
          ),
          child: Row(children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(color: s.$3, border: Border.all(color: Colors.black, width: 2)),
              alignment: Alignment.center,
              child: Text(s.$5, style: Fonts.pixel(size: 22, color: Colors.black)),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(s.$2, style: Fonts.pixel(size: 12, color: s.$3, letterSpacing: 1.5)),
                if (st.hot) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    decoration: BoxDecoration(color: Colors.black, border: Border.all(color: Col.danger)),
                    child: Text('🔥 QUENTE', style: Fonts.pixel(size: 7, color: Col.danger, letterSpacing: 0.5)),
                  ),
                ],
              ]),
              const SizedBox(height: 4),
              Text(s.$4, style: Fonts.body(size: 13, color: Col.ink, weight: FontWeight.w600)),
              Text('${st.total} pauta${st.total != 1 ? 's' : ''} ativa${st.total != 1 ? 's' : ''}',
                  style: Fonts.mono(size: 10, color: Col.inkDim)),
            ])),
            Column(children: [
              if (st.newReplies > 0) Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(color: Col.magenta, border: Border.all(color: Colors.black, width: 2)),
                child: Text('+${st.newReplies}', style: Fonts.pixel(size: 10, color: Colors.white)),
              ),
              const SizedBox(height: 4),
              Text('›', style: TextStyle(color: Col.inkMute, fontSize: 18)),
            ]),
          ]),
        ),
      );
}

// ─── 13 ForumList ─────────────────────────────────────────────────────────
class ScreenForumList extends StatelessWidget {
  const ScreenForumList({super.key});
  @override
  Widget build(BuildContext c) {
    final app = AppStateScope.of(c);
    final si = _forumScopes.firstWhere((s) => s.$1 == app.forumScope, orElse: () => _forumScopes[0]);
    final filtered = app.topics.where((t) => t.scope == app.forumScope).toList();
    final totalNew = filtered.fold<int>(0, (s, t) => s + t.newReplies);
    return Stack(children: [
      Column(children: [
        const TopBar(),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Col.line))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              GestureDetector(
                onTap: () => app.go('forum'),
                child: Text('← ESCOPO', style: Fonts.pixel(size: 10, color: Col.ink, letterSpacing: 1)),
              ),
              const Spacer(),
              PixelChip(si.$2, color: si.$3, size: 9),
              const SizedBox(width: 6),
              const PixelChip('● 312', color: Col.acid, size: 7),
            ]),
            const SizedBox(height: 8),
            Stencil(si.$4, size: 22),
            const SizedBox(height: 8),
            Row(children: [
              Avatar(seed: app.user.seed, size: 26),
              const SizedBox(width: 8),
              Text(app.user.pseudonym, style: Fonts.mono(size: 11, color: Col.acid)),
              if (totalNew > 0) ...[
                const SizedBox(width: 6),
                Text('· $totalNew NOVOS',
                    style: Fonts.pixel(size: 8, color: Col.magenta, letterSpacing: 1)),
              ],
            ]),
          ]),
        ),
        Expanded(child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 90),
          children: [
            for (final t in filtered) _topicCard(app, t),
            if (filtered.isEmpty) Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.center,
              decoration: BoxDecoration(border: Border.all(color: Col.line, width: 1.5)),
              child: Text('// nenhuma pauta nesse escopo ainda.\n// toque em "+ NOVA PAUTA" pra criar a primeira.',
                  textAlign: TextAlign.center, style: Fonts.mono(size: 11, color: Col.inkMute, height: 1.55)),
            ),
          ],
        )),
        TabBarNav(active: app.tab, onTab: app.goTab),
      ]),
      if (app.forumScope == 'mun') Positioned(right: 16, bottom: 78, child: GestureDetector(
        onTap: () => app.go('newpost'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Col.acid,
            border: Border.all(color: Colors.black, width: 3),
            boxShadow: const [BoxShadow(offset: Offset(4, 4), color: Colors.black)],
          ),
          child: Text('+ NOVA PAUTA', style: Fonts.pixel(size: 11, color: Colors.black, letterSpacing: 1)),
        ),
      )),
    ]);
  }

  Widget _topicCard(AppState app, ForumTopic t) {
    final newN = t.newReplies;
    return GestureDetector(
      onTap: () { app.setCurrentTopic(t); app.markTopicSeen(t.id); app.go('topic'); },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.fromLTRB(12, 12, newN > 0 ? 44 : 12, 12),
        decoration: BoxDecoration(
          color: Col.panel,
          border: Border.all(color: newN > 0 ? Col.acid : Col.line, width: 1.5),
        ),
        child: Stack(children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Avatar(seed: t.author, size: 36),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Wrap(spacing: 6, runSpacing: 6, children: [
                PixelChip(t.tag, color: Col.acid, size: 7),
                if (t.hot) const PixelChip('🔥 QUENTE', color: Col.danger, size: 7),
                if (t.live) Text('● AO VIVO', style: Fonts.pixel(size: 8, color: Col.acid)),
              ]),
              const SizedBox(height: 6),
              Text(t.title, style: Fonts.body(size: 13, color: Col.ink, height: 1.4, weight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(spacing: 6, children: [
                Text(t.author, style: Fonts.mono(size: 10, color: Col.inkDim)),
                Text('·', style: Fonts.mono(size: 10, color: Col.inkDim)),
                Text('↩ ${t.replies}', style: Fonts.mono(size: 10, color: Col.magenta)),
                Text('·', style: Fonts.mono(size: 10, color: Col.inkDim)),
                Text(t.age, style: Fonts.mono(size: 10, color: Col.inkDim)),
              ]),
            ])),
          ]),
          if (newN > 0) Positioned(top: 0, right: 0, child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
            decoration: BoxDecoration(color: Col.magenta, border: Border.all(color: Colors.black, width: 1.5)),
            child: Text('+$newN', style: Fonts.pixel(size: 9, color: Colors.white)),
          )),
        ]),
      ),
    );
  }
}

// ─── 14 Topic ─────────────────────────────────────────────────────────────
class ScreenTopic extends StatefulWidget {
  const ScreenTopic({super.key});
  @override
  State<ScreenTopic> createState() => _ScreenTopicState();
}

class _ScreenTopicState extends State<ScreenTopic> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  String _modPhase = 'idle';
  String _modText = '', _modWord = '';
  String? _confirmId;

  void _send(AppState app) {
    final s = _ctrl.text.trim();
    if (s.isEmpty || _modPhase != 'idle') return;
    setState(() { _modPhase = 'checking'; _modText = s; });
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      final r = moderateText(s);
      if (r.blocked) setState(() { _modPhase = 'blocked'; _modWord = r.word; });
      else { app.addReply(s); _ctrl.clear(); setState(() => _modPhase = 'idle'); }
    });
  }

  @override
  void dispose() { _ctrl.dispose(); _scroll.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext c) {
    final app = AppStateScope.of(c);
    final t = app.currentTopic ?? const ForumTopic(
      id: 't1', tag: 'TRANSPORTE', scope: 'mun', hot: true, live: true,
      title: 'Linha 17-Ouro: como cobrar o TCE-SP?',
      author: 'Cidadão_SP_4a7b', age: '12 min',
      body: 'Pessoal, vi a pauta no app hoje. Já mandei minha mensagem pro Nunes mas acho que cobrar pelo TCE é mais efetivo. Alguém aqui já abriu processo de denúncia? Como funciona?',
    );
    final isUserPost = t.author == app.user.pseudonym;

    return Stack(children: [
      Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Col.line))),
          child: Row(children: [
            GestureDetector(
              onTap: () => app.go('forum-list'),
              child: Text('← PAUTAS', style: Fonts.pixel(size: 11, color: Col.ink)),
            ),
            const Spacer(),
            Text('● AO VIVO · 312', style: Fonts.pixel(size: 9, color: Col.acid)),
          ]),
        ),
        Expanded(child: SingleChildScrollView(
          controller: _scroll,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(color: Col.panelHi, border: Border(bottom: BorderSide(color: Col.magenta, width: 2))),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Avatar(seed: t.author, size: 44),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Wrap(spacing: 6, runSpacing: 6, children: [
                    PixelChip(t.tag, color: Col.acid, size: 7),
                    if (t.hot) const PixelChip('🔥 QUENTE', color: Col.danger, size: 7),
                    if (t.live) Text('● AO VIVO', style: Fonts.pixel(size: 8, color: Col.acid)),
                  ]),
                  const SizedBox(height: 8),
                  Stencil(t.title, size: 22),
                  const SizedBox(height: 10),
                  Text(t.body, style: Fonts.body(size: 13, color: Col.inkDim, height: 1.55)),
                  const SizedBox(height: 12),
                  Wrap(spacing: 6, children: [
                    Text(t.author, style: Fonts.mono(size: 10, color: isUserPost ? Col.magenta : Col.acid)),
                    if (isUserPost) const PixelChip('VOCÊ', color: Col.magenta, size: 6),
                    Text('· ${t.age}', style: Fonts.mono(size: 10, color: Col.inkDim)),
                  ]),
                  const SizedBox(height: 10),
                  Wrap(spacing: 6, runSpacing: 6, children: [
                    for (final r in const ['⚡ 87', '🔥 42', '🤔 11', '👍 56']) Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(color: Col.panel, border: Border.all(color: Col.line)),
                      child: Text(r, style: Fonts.pixel(size: 9, color: Col.ink)),
                    ),
                  ]),
                ])),
              ]),
            ),
            Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              for (final r in app.topicReplies) _reply(app, r),
              if (app.topicReplies.isEmpty) Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.center,
                decoration: BoxDecoration(border: Border.all(color: Col.line, width: 1.5)),
                child: Text('// ninguém respondeu ainda. seja o primeiro.',
                    style: Fonts.mono(size: 11, color: Col.inkMute)),
              ),
            ])),
          ]),
        )),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: const BoxDecoration(color: Col.bg2, border: Border(top: BorderSide(color: Col.line, width: 1.5))),
          child: Row(children: [
            Avatar(seed: app.user.seed, size: 32),
            const SizedBox(width: 8),
            Expanded(child: TextField(
              controller: _ctrl,
              onSubmitted: (_) => _send(app),
              style: Fonts.body(size: 13, color: Col.ink),
              decoration: InputDecoration(
                hintText: 'responder como ${app.user.pseudonym}',
                hintStyle: Fonts.body(size: 13, color: Col.inkMute),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                filled: true,
                fillColor: Col.panel,
                border: const OutlineInputBorder(borderSide: BorderSide(color: Col.line), borderRadius: BorderRadius.zero),
                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Col.acid), borderRadius: BorderRadius.zero),
                enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Col.line), borderRadius: BorderRadius.zero),
              ),
            )),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _send(app),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                color: Col.acid,
                child: Text('↳', style: Fonts.pixel(size: 10, color: Colors.black, letterSpacing: 1)),
              ),
            ),
          ]),
        ),
      ]),
      if (_modPhase != 'idle') Positioned.fill(child: ModerationOverlay(
        phase: _modPhase, text: _modText, word: _modWord,
        onEdit: () => setState(() => _modPhase = 'idle'),
        onDiscard: () { _ctrl.clear(); setState(() => _modPhase = 'idle'); },
      )),
    ]);
  }

  Widget _reply(AppState app, ForumReply r) {
    final isMine = r.mine || r.who == app.user.pseudonym;
    final confirming = isMine && _confirmId == r.id;
    return Container(
      margin: const EdgeInsets.only(left: 12, bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMine ? const Color(0xFF161616) : Col.panel,
        border: Border(
          top: BorderSide(color: isMine ? Col.acid.withValues(alpha: 0.33) : Col.line),
          right: BorderSide(color: isMine ? Col.acid.withValues(alpha: 0.33) : Col.line),
          bottom: BorderSide(color: isMine ? Col.acid.withValues(alpha: 0.33) : Col.line),
          left: BorderSide(color: isMine ? Col.magenta : Col.acid, width: 3),
        ),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Avatar(seed: r.seed ?? r.who, size: 32),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Wrap(spacing: 6, runSpacing: 4, children: [
              Text(r.who, style: Fonts.mono(size: 10, color: isMine ? Col.magenta : Col.acid)),
              if (isMine) const PixelChip('VOCÊ', color: Col.magenta, size: 6),
              Text('· ${r.age}', style: Fonts.mono(size: 10, color: Col.inkDim)),
            ])),
            if (isMine && !confirming) GestureDetector(
              onTap: () => setState(() => _confirmId = r.id),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(border: Border.all(color: Col.line)),
                child: Text('×', style: Fonts.pixel(size: 9, color: Col.inkMute)),
              ),
            ),
          ]),
          const SizedBox(height: 6),
          Text(r.body, style: Fonts.body(size: 12.5, color: Col.ink, height: 1.5)),
          if (r.reacts.isNotEmpty && !confirming) Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(spacing: 6, runSpacing: 6, children: [
              for (final entry in r.reacts.entries) Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(color: Col.panelHi, border: Border.all(color: Col.line)),
                child: Text('${entry.key} ${entry.value}', style: Fonts.pixel(size: 8, color: Col.ink)),
              ),
            ]),
          ),
          if (confirming) Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.black, border: Border.all(color: Col.danger, width: 1.5)),
            child: Row(children: [
              Expanded(child: Text('APAGAR ESTA RESPOSTA?',
                  style: Fonts.pixel(size: 8, color: Col.danger, letterSpacing: 1))),
              GestureDetector(
                onTap: () => setState(() => _confirmId = null),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(border: Border.all(color: Col.line)),
                  child: Text('NÃO', style: Fonts.pixel(size: 9, color: Col.inkDim)),
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () { app.deleteReply(r.id); setState(() => _confirmId = null); },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  color: Col.danger,
                  child: Text('SIM, APAGAR', style: Fonts.pixel(size: 9, color: Colors.black, letterSpacing: 1)),
                ),
              ),
            ]),
          ),
        ])),
      ]),
    );
  }
}

// ─── 15 NewPost ───────────────────────────────────────────────────────────
const _newpostScopes = [
  ('mun', 'MUNICIPAL', Col.magenta, 'só sua cidade', '◉'),
  ('est', 'ESTADUAL', Col.acid, 'seu estado', '◐'),
  ('fed', 'FEDERAL', Col.alert, 'país inteiro', '◯'),
];

class _Analyzed {
  final String theme, title, desc;
  final Color color;
  final List<({String role, String name, String handle})> authorities;
  final int confidence;
  const _Analyzed({required this.theme, required this.color, required this.title, required this.desc, required this.authorities, required this.confidence});
}

_Analyzed _analyze(String text, String scope) {
  final l = text.toLowerCase();
  String theme = 'POLÍTICA'; Color color = Col.magenta;
  if (RegExp(r'metr[ôo]|[ôo]nibus|\btrans|mobil|rua|via|tr[áa]fego|congestion|cicl').hasMatch(l)) { theme = 'TRANSPORTE'; color = Col.magenta; }
  else if (RegExp(r'saud|hospital|\bubs|posto|m[ée]dic|\bsus|vacin|pediat|enferm').hasMatch(l)) { theme = 'SAÚDE'; color = Col.alert; }
  else if (RegExp(r'escol|educa|merenda|professor|aluno|creche|universid').hasMatch(l)) { theme = 'EDUCAÇÃO'; color = Col.magenta; }
  else if (RegExp(r'or[çc]ament|gasto|verba|licit|contrat|aditiv|caixa|impost').hasMatch(l)) { theme = 'ORÇAMENTO'; color = Col.acid; }
  else if (RegExp(r'ambient|polui|reciclag|lixo|enchente|desmat|verde|parque').hasMatch(l)) { theme = 'MEIO AMBIENTE'; color = Col.acid; }
  else if (RegExp(r'cultur|museu|teatro|biblio|arte|festiv').hasMatch(l)) { theme = 'CULTURA'; color = Col.magenta; }
  else if (RegExp(r'pol[íi]cia|seguran[çc]|crime|viol[êe]ncia|assalt').hasMatch(l)) { theme = 'SEGURANÇA'; color = Col.danger; }
  else if (RegExp(r'morad|habita|favel|cortic|despej').hasMatch(l)) { theme = 'MORADIA'; color = Col.alert; }
  else if (RegExp(r'corrup|propin|desvi|fraud|escândal').hasMatch(l)) { theme = 'CORRUPÇÃO'; color = Col.danger; }

  final fs = text.split(RegExp(r'[.!?\n]')).first.trim();
  final title = fs.length > 12 ? fs[0].toUpperCase() + fs.substring(1, fs.length > 110 ? 110 : fs.length) : 'Nova pauta de ${theme.toLowerCase()} levantada por cidadão';
  final trim = text.replaceAll(RegExp(r'\s+'), ' ').trim();
  final desc = trim.length > 280 ? '${trim.substring(0, 280).trim()} ...' : trim;

  final auths = {
    'mun': [
      (role: 'PREFEITO', name: 'Prefeitura de São Paulo', handle: '@prefsp'),
      (role: 'CÂMARA MUNICIPAL', name: 'CMSP — vereadores', handle: '@cmsp_oficial'),
    ],
    'est': [
      (role: 'GOVERNADOR', name: 'Governo do Estado de SP', handle: '@governosp'),
      (role: 'ASSEMBLEIA', name: 'ALESP', handle: '@alesp_oficial'),
    ],
    'fed': [
      (role: 'PRESIDÊNCIA', name: 'Planalto', handle: '@planalto'),
      (role: 'CÂMARA', name: 'Câmara dos Deputados', handle: '@camaradeputados'),
      (role: 'SENADO', name: 'Senado Federal', handle: '@senadofederal'),
    ],
  }[scope]!;
  return _Analyzed(theme: theme, color: color, title: title, desc: desc, authorities: auths, confidence: 78 + (text.length % 18));
}

class ScreenNewPost extends StatefulWidget {
  const ScreenNewPost({super.key});
  @override
  State<ScreenNewPost> createState() => _ScreenNewPostState();
}

class _ScreenNewPostState extends State<ScreenNewPost> {
  String _scope = 'mun';
  final _text = TextEditingController();
  final _url = TextEditingController();
  String _phase = 'idle'; // idle | analyzing | preview
  int _currentPhase = 0;
  _Analyzed? _result;
  Timer? _t;

  void _start() {
    if (_text.text.trim().isEmpty || _phase != 'idle') return;
    setState(() { _phase = 'analyzing'; _currentPhase = 0; });
    _t = Timer.periodic(const Duration(milliseconds: 950), (timer) {
      if (!mounted) return;
      setState(() {
        _currentPhase++;
        if (_currentPhase >= analysisPhases.length) {
          _result = _analyze(_text.text, _scope);
          _phase = 'preview';
          timer.cancel();
        }
      });
    });
  }

  void _regen() { _t?.cancel(); setState(() { _phase = 'idle'; _result = null; }); }
  void _publish(AppState app) {
    final r = _result!;
    app.addTopic(ForumTopic(
      id: 't${DateTime.now().millisecondsSinceEpoch}',
      tag: r.theme, title: r.title, body: r.desc,
      author: app.user.pseudonym, seed: app.user.seed,
      replies: 0, age: 'agora', live: true, scope: _scope,
    ));
    app.setForumScope(_scope);
    app.go('forum-list');
  }

  @override
  void dispose() { _t?.cancel(); _text.dispose(); _url.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext c) {
    final app = AppStateScope.of(c);
    if (_phase == 'preview' && _result != null) return _preview(app, _result!);
    return Stack(children: [_form(app), if (_phase == 'analyzing') Positioned.fill(child: AnalysisOverlay(phase: 'analyzing', currentPhase: _currentPhase, inputText: _text.text))]);
  }

  Widget _form(AppState app) => Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Col.line))),
          child: Row(children: [
            GestureDetector(
              onTap: () => app.go('forum-list'),
              child: Text('← PAUTAS', style: Fonts.pixel(size: 11, color: Col.ink)),
            ),
            const Spacer(),
            Text('NOVA PAUTA', style: Fonts.pixel(size: 9, color: Col.acid)),
          ]),
        ),
        ScrollArea(padding: const EdgeInsets.fromLTRB(18, 16, 18, 12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          StencilSpan(TextSpan(children: [
            const TextSpan(text: 'LEVANTE UMA\n'),
            TextSpan(text: 'PAUTA', style: TextStyle(color: Col.magenta)),
          ]), size: 32),
          const SizedBox(height: 6),
          Text('// a IA local lê o conteúdo, classifica o tema,\n// identifica autoridades e monta o post pra você.',
              style: Fonts.mono(size: 10, color: Col.inkDim, height: 1.5)),
          const SizedBox(height: 22),
          Text('// ESCOPO DA PAUTA', style: Fonts.pixel(size: 9, color: Col.inkMute, letterSpacing: 1.5)),
          const SizedBox(height: 8),
          for (final s in _newpostScopes) ...[
            GestureDetector(
              onTap: () => setState(() => _scope = s.$1),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: _scope == s.$1 ? Col.panelHi : Colors.transparent,
                  border: Border.all(color: _scope == s.$1 ? s.$3 : Col.line, width: 1.5),
                ),
                child: Row(children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: _scope == s.$1 ? s.$3 : Col.panel,
                      border: Border.all(color: _scope == s.$1 ? s.$3 : Col.line, width: 1.5),
                    ),
                    alignment: Alignment.center,
                    child: Text(s.$5, style: Fonts.pixel(size: 14, color: _scope == s.$1 ? Colors.black : Col.inkDim)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(s.$2, style: Fonts.pixel(size: 10, color: _scope == s.$1 ? s.$3 : Col.ink, letterSpacing: 1.5)),
                    const SizedBox(height: 2),
                    Text('${s.$4}${s.$1 == 'mun' ? ' · São Paulo / SP' : ''}',
                        style: Fonts.mono(size: 10, color: Col.inkMute)),
                  ])),
                  if (_scope == s.$1) Text('●', style: Fonts.pixel(size: 12, color: s.$3)),
                ]),
              ),
            ),
          ],
          const SizedBox(height: 14),
          Row(children: [
            Text('// CONTEÚDO DA NOTÍCIA', style: Fonts.pixel(size: 9, color: Col.inkMute, letterSpacing: 1.5)),
            const Spacer(),
            ValueListenableBuilder(valueListenable: _text, builder: (_, v, __) => Text('${v.text.length}/2000', style: Fonts.mono(size: 9, color: Col.inkMute))),
          ]),
          const SizedBox(height: 8),
          TextField(
            controller: _text,
            maxLines: 6,
            maxLength: 2000,
            style: Fonts.body(size: 13, color: Col.ink, height: 1.55),
            decoration: InputDecoration(
              counterText: '',
              hintText: 'cole o texto da notícia, descreva o problema, ou conte o que tá acontecendo na sua quebrada...',
              hintStyle: Fonts.body(size: 13, color: Col.inkMute),
              filled: true, fillColor: Colors.black,
              contentPadding: const EdgeInsets.all(12),
              border: const OutlineInputBorder(borderSide: BorderSide(color: Col.line, width: 1.5), borderRadius: BorderRadius.zero),
              enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Col.line, width: 1.5), borderRadius: BorderRadius.zero),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Col.acid, width: 1.5), borderRadius: BorderRadius.zero),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 18),
          Text('// FONTE (URL, opcional)', style: Fonts.pixel(size: 9, color: Col.inkMute, letterSpacing: 1.5)),
          const SizedBox(height: 8),
          TextField(
            controller: _url,
            style: Fonts.mono(size: 12, color: Col.acid),
            decoration: InputDecoration(
              hintText: 'https://g1.globo.com/...',
              hintStyle: Fonts.mono(size: 12, color: Col.inkMute),
              filled: true, fillColor: Colors.black,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: const OutlineInputBorder(borderSide: BorderSide(color: Col.line, width: 1.5), borderRadius: BorderRadius.zero),
              enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Col.line, width: 1.5), borderRadius: BorderRadius.zero),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Col.acid, width: 1.5), borderRadius: BorderRadius.zero),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Col.panel, border: Border.all(color: Col.line, width: 1.5)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('// LEMBRE', style: Fonts.pixel(size: 8, color: Col.acid)),
              const SizedBox(height: 8),
              Text('Você é responsável pelo que publica. A IA classifica e formata, mas não checa veracidade — anexe fontes confiáveis.',
                  style: Fonts.mono(size: 10, color: Col.inkDim, height: 1.55)),
            ]),
          ),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: const BoxDecoration(color: Col.bg, border: Border(top: BorderSide(color: Col.line, width: 1.5))),
          child: Row(children: [
            Expanded(child: Text(_text.text.trim().isNotEmpty ? 'PRONTO PRA ANALISAR' : '↓ COLE O CONTEÚDO ↑',
                style: Fonts.pixel(size: 8, color: Col.inkMute, letterSpacing: 1))),
            Btn('ANALISAR COM IA →',
                color: _text.text.trim().isNotEmpty ? Col.magenta : Col.line,
                fg: _text.text.trim().isNotEmpty ? Colors.white : Col.inkMute,
                disabled: _text.text.trim().isEmpty, onTap: _start),
          ]),
        ),
      ]);

  Widget _preview(AppState app, _Analyzed r) {
    final scopeLabel = _newpostScopes.firstWhere((s) => s.$1 == _scope).$2;
    return Column(children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Col.line))),
        child: Row(children: [
          GestureDetector(onTap: _regen, child: Text('← REFAZER', style: Fonts.pixel(size: 11, color: Col.ink))),
          const Spacer(),
          PixelChip('IA · ${r.confidence}% CONFIANÇA', color: Col.acid, size: 8),
        ]),
      ),
      ScrollArea(padding: const EdgeInsets.fromLTRB(18, 16, 18, 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        PixelChip('PRÉVIA DA PAUTA', color: r.color),
        const SizedBox(height: 12),
        StencilSpan(TextSpan(children: [
          const TextSpan(text: 'ASSIM VAI\n'),
          TextSpan(text: 'APARECER', style: TextStyle(color: r.color)),
        ]), size: 30),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Col.panel, border: Border.all(color: Col.line, width: 1.5)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Wrap(spacing: 6, runSpacing: 6, children: [
              PixelChip(r.theme, color: r.color, size: 7),
              PixelChip(scopeLabel, color: Col.acid, size: 7),
              const PixelChip('● AO VIVO · agora', color: Col.inkMute, size: 7),
            ]),
            const SizedBox(height: 10),
            Text(r.title, style: Fonts.body(size: 14, color: Col.ink, weight: FontWeight.w700, height: 1.3)),
            const SizedBox(height: 8),
            Text(r.desc, style: Fonts.body(size: 12.5, color: Col.inkDim, height: 1.55)),
            if (_url.text.isNotEmpty) Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text('↗ ${_url.text}', style: Fonts.mono(size: 10, color: Col.acid)),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Avatar(seed: app.user.seed, size: 22),
              const SizedBox(width: 8),
              Text('${app.user.pseudonym} · agora', style: Fonts.mono(size: 10, color: Col.inkDim)),
            ]),
          ]),
        ),
        const SizedBox(height: 18),
        Text('// AUTORIDADES IDENTIFICADAS PELA IA', style: Fonts.pixel(size: 9, color: Col.magenta, letterSpacing: 1.2)),
        for (final a in r.authorities) Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Col.line))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(a.role, style: Fonts.pixel(size: 7, color: Col.inkMute, letterSpacing: 1)),
            const SizedBox(height: 4),
            Row(children: [
              Text(a.name, style: Fonts.body(size: 13, color: Col.ink, weight: FontWeight.w600)),
              const SizedBox(width: 8),
              Text(a.handle, style: Fonts.mono(size: 10, color: Col.acid)),
            ]),
          ]),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Col.panel, border: Border.all(color: Col.acid, width: 1.5)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('// NOTA', style: Fonts.pixel(size: 9, color: Col.acid)),
            const SizedBox(height: 8),
            Text('A IA classificou esta pauta automaticamente. Revise antes de publicar — você é responsável pelo conteúdo.',
                style: Fonts.mono(size: 10, color: Col.inkDim, height: 1.55)),
          ]),
        ),
      ])),
      StickyFooter(children: [
        GhostBtn('↻ REFAZER', color: Col.inkDim, onTap: _regen),
        const Spacer(),
        Btn('PUBLICAR ✓', color: r.color, onTap: () => _publish(app)),
      ]),
    ]);
  }
}
