import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/models.dart';
import '../design/colors.dart';
import '../design/fonts.dart';
import '../widgets/atoms.dart';
import '../widgets/molecules.dart';

class _ScopeInfo {
  const _ScopeInfo({required this.id, required this.label, required this.color, required this.sub, required this.glyph});
  final TopicScope id;
  final String label;
  final Color color;
  final String sub;
  final String glyph;
}

const FORUM_SCOPES = <_ScopeInfo>[
  _ScopeInfo(id: TopicScope.mun, label: 'MUNICIPAL', color: DCol.magenta, sub: 'São Paulo / SP', glyph: '◉'),
  _ScopeInfo(id: TopicScope.est, label: 'ESTADUAL', color: DCol.acid, sub: 'Estado de São Paulo', glyph: '◐'),
  _ScopeInfo(id: TopicScope.fed, label: 'FEDERAL', color: DCol.alert, sub: 'Brasil inteiro', glyph: '◯'),
];

class ForumScopeScreen extends StatelessWidget {
  const ForumScopeScreen({super.key});

  ({int total, int newReplies, bool hot}) _stats(AppState app, TopicScope s) {
    final list = app.topics.where((t) => t.scope == s);
    return (
      total: list.length,
      newReplies: list.fold<int>(0, (sum, t) => sum + t.newReplies),
      hot: list.any((t) => t.hot),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    return Container(
      color: DCol.bg,
      child: Column(
        children: [
          const TopBar(),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 22, 18, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PixelChip('FÓRUM CÍVICO', color: DCol.acid),
                const SizedBox(height: 12),
                StencilTwoLine(
                  first: 'ESCOLHA O',
                  second: 'NÍVEL',
                  size: 42,
                  height: 0.92,
                  secondShadows: const [Shadow(color: DCol.acid, offset: Offset(3, 3))],
                ),
                const SizedBox(height: 8),
                Text(
                  '// pautas separadas por escopo geográfico.\n'
                  '// novos posts no seu escopo aparecem com badge.',
                  style: DFont.mono(size: 10, color: DCol.inkDim, height: 1.5),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 90),
              children: [
                ...FORUM_SCOPES.map((s) {
                  final st = _stats(app, s.id);
                  return _scopeCard(s, st, app);
                }),
                const SizedBox(height: 18),
                Container(
                  decoration: BoxDecoration(
                    color: DCol.panel,
                    border: Border.all(color: DCol.line, width: 1.5),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('// REGRA', style: DFont.pixel(size: 9, color: DCol.acid)),
                      const SizedBox(height: 6),
                      Text(
                        'Você só posta no escopo da sua cidade (municipal).\nEstadual e federal você lê + reage + vota.',
                        style: DFont.mono(size: 10, color: DCol.inkDim, height: 1.55),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          DTabBar(active: app.tab, onTab: app.goTab),
        ],
      ),
    );
  }

  Widget _scopeCard(_ScopeInfo s, ({int total, int newReplies, bool hot}) st, AppState app) {
    return GestureDetector(
      onTap: () {
        app.setForumScope(s.id);
        app.go(Screen.forumList);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: DCol.panel,
          border: Border.all(color: DCol.line, width: 1.5),
          boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: s.color,
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Text(s.glyph,
                  style: DFont.pixel(size: 22, color: Colors.black, letterSpacing: 0)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(s.label,
                          style:
                              DFont.pixel(size: 12, color: s.color, letterSpacing: 1.5)),
                      if (st.hot) ...[
                        const SizedBox(width: 6),
                        const PixelChip('🔥 QUENTE', color: DCol.danger, size: 7),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(s.sub,
                      style: DFont.body(
                          size: 13, color: DCol.ink, weight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    '${st.total} pauta${st.total != 1 ? 's' : ''} ativa${st.total != 1 ? 's' : ''}',
                    style: DFont.mono(size: 10, color: DCol.inkDim),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (st.newReplies > 0)
                  Container(
                    decoration: BoxDecoration(
                      color: DCol.magenta,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    constraints: const BoxConstraints(minWidth: 28),
                    child: Text('+${st.newReplies}',
                        textAlign: TextAlign.center,
                        style: DFont.pixel(
                            size: 10, color: Colors.white, letterSpacing: 0.5)),
                  ),
                const SizedBox(height: 4),
                const Text('›', style: TextStyle(color: DCol.inkMute, fontSize: 18, height: 1)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
