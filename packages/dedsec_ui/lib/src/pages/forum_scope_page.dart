import 'package:flutter/material.dart';
import '../atoms/dashed_box.dart';
import '../atoms/pixel_chip.dart';
import '../atoms/stencil.dart';
import '../molecules/tab_bar.dart';
import '../molecules/top_bar.dart';
import '../state/app_state.dart';
import '../state/topics.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';
import '../widgets/screen_root.dart';
import 'route.dart';

class _ScopeInfo {
  final TopicScope id;
  final String label;
  final Color color;
  final String sub;
  final String glyph;
  const _ScopeInfo(this.id, this.label, this.color, this.sub, this.glyph);
}

const forumScopes = <_ScopeInfo>[
  _ScopeInfo(TopicScope.mun, 'MUNICIPAL', DedsecColors.magenta, 'São Paulo / SP', '◉'),
  _ScopeInfo(TopicScope.est, 'ESTADUAL', DedsecColors.acid, 'Estado de São Paulo', '◐'),
  _ScopeInfo(TopicScope.fed, 'FEDERAL', DedsecColors.alert, 'Brasil inteiro', '◯'),
];

class ForumScopePage extends StatelessWidget {
  final ValueChanged<DedsecScreen> onGo;
  final String activeTab;
  final ValueChanged<String> onTab;
  const ForumScopePage({super.key, required this.onGo, required this.activeTab, required this.onTab});

  @override
  Widget build(BuildContext context) {
    final state = DedsecScope.of(context);

    ({int total, int newReplies, bool hot}) statsFor(TopicScope sid) {
      final list = state.topics.where((t) => t.scope == sid).toList();
      return (
        total: list.length,
        newReplies: list.fold<int>(0, (s, t) => s + t.newReplies),
        hot: list.any((t) => t.hot),
      );
    }

    return ScreenRoot(
      child: Column(children: [
        const DedsecTopBar(),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 22, 18, 14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const PixelChip('FÓRUM CÍVICO', color: DedsecColors.acid),
            const SizedBox(height: 12),
            StencilRich(size: 42, spans: const [
              TextSpan(text: 'ESCOLHA O\n'),
              TextSpan(text: 'NÍVEL',
                  style: TextStyle(
                    color: DedsecColors.magenta,
                    shadows: [Shadow(color: DedsecColors.acid, offset: Offset(3, 3))],
                  )),
            ]),
            const SizedBox(height: 8),
            Text(
              '// pautas separadas por escopo geográfico.\n// novos posts no seu escopo aparecem com badge.',
              style: DedsecFonts.mono(size: 10, color: DedsecColors.inkDim, height: 1.5),
            ),
          ]),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 90),
            itemCount: forumScopes.length + 1,
            itemBuilder: (_, i) {
              if (i == forumScopes.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: DashedBox(
                    color: DedsecColors.line,
                    strokeWidth: 1.5,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('// REGRA',
                            style: DedsecFonts.pixel(size: 9, color: DedsecColors.acid)),
                        const SizedBox(height: 6),
                        Text(
                          'Você só posta no escopo da sua cidade (municipal).\nEstadual e federal você lê + reage + vota.',
                          style: DedsecFonts.mono(size: 10, color: DedsecColors.inkDim, height: 1.5),
                        ),
                      ]),
                    ),
                  ),
                );
              }
              final s = forumScopes[i];
              final st = statsFor(s.id);
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () {
                    state.setForumScope(s.id);
                    onGo(DedsecScreen.forumList);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: DedsecColors.panel,
                      border: Border.all(color: DedsecColors.line, width: 1.5),
                      boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                    ),
                    child: Row(children: [
                      Container(
                        width: 52, height: 52,
                        decoration: BoxDecoration(color: s.color, border: Border.all(color: Colors.black, width: 2)),
                        child: Center(
                          child: Text(s.glyph,
                              style: DedsecFonts.pixel(size: 22, color: Colors.black)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Text(s.label,
                                style: DedsecFonts.pixel(size: 12, color: s.color, letterSpacing: 1.5)),
                            if (st.hot) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  border: Border.all(color: DedsecColors.danger),
                                ),
                                child: Text('🔥 QUENTE',
                                    style: DedsecFonts.pixel(size: 7, color: DedsecColors.danger)),
                              ),
                            ],
                          ]),
                          const SizedBox(height: 4),
                          Text(s.sub, style: DedsecFonts.body(size: 13, weight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(
                            '${st.total} pauta${st.total != 1 ? 's' : ''} ativa${st.total != 1 ? 's' : ''}',
                            style: DedsecFonts.mono(size: 10, color: DedsecColors.inkDim),
                          ),
                        ]),
                      ),
                      Column(children: [
                        if (st.newReplies > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                            decoration: BoxDecoration(
                              color: DedsecColors.magenta,
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                            child: Text('+${st.newReplies}',
                                style: DedsecFonts.pixel(size: 10, color: Colors.white)),
                          ),
                        const SizedBox(height: 4),
                        Text('›', style: TextStyle(color: DedsecColors.inkMute, fontSize: 18)),
                      ]),
                    ]),
                  ),
                ),
              );
            },
          ),
        ),
        DedsecTabBar(active: activeTab, onTab: onTab),
      ]),
    );
  }
}
