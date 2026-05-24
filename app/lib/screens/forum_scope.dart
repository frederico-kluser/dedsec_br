import 'package:flutter/material.dart';

import '../app/app_scope.dart';
import '../app/app_state.dart';
import '../models/forum.dart';
import '../theme/colors.dart';
import '../theme/fonts.dart';
import '../widgets/atoms/text_atoms.dart';
import '../widgets/molecules/bars.dart';

class _ScopeCard {
  final TopicScope id;
  final String label;
  final Color color;
  final String sub;
  final String glyph;
  const _ScopeCard(this.id, this.label, this.color, this.sub, this.glyph);
}

const _kScopeCards = <_ScopeCard>[
  _ScopeCard(TopicScope.mun, 'MUNICIPAL', COL.magenta, 'São Paulo / SP', '◉'),
  _ScopeCard(TopicScope.est, 'ESTADUAL', COL.acid, 'Estado de São Paulo', '◐'),
  _ScopeCard(TopicScope.fed, 'FEDERAL', COL.alert, 'Brasil inteiro', '◯'),
];

class ForumScopeScreen extends StatelessWidget {
  const ForumScopeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Container(
      color: COL.bg,
      child: Stack(
        children: [
          Column(
            children: [
              const TopBar(),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PixelChip('FÓRUM CÍVICO', color: COL.acid),
                    const SizedBox(height: 12),
                    const StencilSpans(
                      spans: [
                        TextSpan(text: 'ESCOLHA O\n'),
                        TextSpan(
                          text: 'NÍVEL',
                          style: TextStyle(
                            color: COL.magenta,
                            shadows: [Shadow(offset: Offset(3, 3), color: COL.acid)],
                          ),
                        ),
                      ],
                      size: 42,
                      height: 0.92,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '// pautas separadas por escopo geográfico.\n// novos posts no seu escopo aparecem com badge.',
                      style: FONT.mono(size: 10, color: COL.inkDim, height: 1.5),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 90),
                  children: [
                    for (final s in _kScopeCards) _scopeCard(state, s),
                    Container(
                      margin: const EdgeInsets.only(top: 18),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: COL.panel,
                        border: Border.all(color: COL.line, width: 1.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('// REGRA',
                              style: FONT.pixel(size: 9, color: COL.acid)),
                          const SizedBox(height: 4),
                          Text(
                            'Você só posta no escopo da sua cidade (municipal).\nEstadual e federal você lê + reage + vota.',
                            style: FONT.mono(size: 10, color: COL.inkDim, height: 1.55),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: DedsecTabBar(active: state.tab.name, onTab: (id) {
              final s = state;
              switch (id) {
                case 'home':
                  s.goTab(AppTab.home);
                  break;
                case 'help':
                  s.goTab(AppTab.help);
                  break;
                case 'forum':
                  s.goTab(AppTab.forum);
                  break;
                case 'settings':
                  s.goTab(AppTab.settings);
                  break;
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _scopeCard(AppState state, _ScopeCard s) {
    final list = state.topics.where((t) => t.scope == s.id).toList();
    final newReplies = list.fold<int>(0, (sum, t) => sum + t.newReplies);
    final hot = list.any((t) => t.hot);
    return GestureDetector(
      onTap: () {
        state.setForumScope(s.id);
        state.go(AppRoute.forumList);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: COL.panel,
          border: Border.all(color: COL.line, width: 1.5),
          boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
        ),
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
                  style: FONT.pixel(size: 22, color: Colors.black)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(s.label,
                          style: FONT.pixel(size: 12, color: s.color, letterSpacing: 1.5)),
                      if (hot)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: COL.danger),
                          ),
                          child: Text('🔥 QUENTE',
                              style: FONT.pixel(size: 7, color: COL.danger, letterSpacing: 0.5)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(s.sub, style: FONT.body(size: 13, weight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    '${list.length} pauta${list.length != 1 ? 's' : ''} ativa${list.length != 1 ? 's' : ''}',
                    style: FONT.mono(size: 10, color: COL.inkDim),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (newReplies > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: COL.magenta,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Text('+$newReplies',
                        style: FONT.pixel(size: 10, color: Colors.white, letterSpacing: 0.5)),
                  ),
                const SizedBox(height: 4),
                Text('›', style: FONT.body(size: 18, color: COL.inkMute, height: 1)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
