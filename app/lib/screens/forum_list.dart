import 'package:flutter/material.dart';

import '../app/app_scope.dart';
import '../app/app_state.dart';
import '../models/forum.dart';
import '../theme/colors.dart';
import '../theme/fonts.dart';
import '../widgets/atoms/avatar.dart';
import '../widgets/atoms/text_atoms.dart';
import '../widgets/molecules/bars.dart';

class ForumListScreen extends StatelessWidget {
  const ForumListScreen({super.key});

  String _scopeLabel(TopicScope s) =>
      {TopicScope.mun: 'MUNICIPAL', TopicScope.est: 'ESTADUAL', TopicScope.fed: 'FEDERAL'}[s]!;
  Color _scopeColor(TopicScope s) =>
      {TopicScope.mun: COL.magenta, TopicScope.est: COL.acid, TopicScope.fed: COL.alert}[s]!;
  String _scopeSub(TopicScope s) => {
        TopicScope.mun: 'São Paulo / SP',
        TopicScope.est: 'Estado de São Paulo',
        TopicScope.fed: 'Brasil inteiro',
      }[s]!;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final scope = state.forumScope;
    final filtered = state.topics.where((t) => t.scope == scope).toList();
    final totalNew = filtered.fold<int>(0, (sum, t) => sum + t.newReplies);

    return Container(
      color: COL.bg,
      child: Stack(
        children: [
          Column(
            children: [
              const TopBar(),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: COL.line)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => state.go(AppRoute.forum),
                          child: Text('← ESCOPO',
                              style: FONT.pixel(size: 10, color: COL.ink, letterSpacing: 1)),
                        ),
                        const Spacer(),
                        PixelChip(_scopeLabel(scope), color: _scopeColor(scope), size: 9),
                        const SizedBox(width: 6),
                        const PixelChip('● 312', color: COL.acid, size: 7),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Stencil(_scopeSub(scope), size: 22, color: COL.ink, height: 1),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Avatar(seed: state.user.seed, size: 26),
                        const SizedBox(width: 8),
                        Text(state.user.pseudonym,
                            style: FONT.mono(size: 11, color: COL.acid)),
                        if (totalNew > 0) ...[
                          const SizedBox(width: 8),
                          Text('· $totalNew NOVOS',
                              style: FONT.pixel(size: 8, color: COL.magenta, letterSpacing: 1)),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(24),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            border: Border.all(color: COL.line, width: 1.5),
                          ),
                          child: Text(
                            '// nenhuma pauta nesse escopo ainda.\n// toque em "+ NOVA PAUTA" pra criar a primeira.',
                            textAlign: TextAlign.center,
                            style: FONT.mono(size: 11, color: COL.inkMute, height: 1.55),
                          ),
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 90),
                        children: [
                          for (final t in filtered) _topicCard(state, t),
                        ],
                      ),
              ),
            ],
          ),
          if (scope == TopicScope.mun)
            Positioned(
              right: 16,
              bottom: 78,
              child: GestureDetector(
                onTap: () => state.go(AppRoute.newpost),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: COL.acid,
                    border: Border.all(color: Colors.black, width: 3),
                    boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                  ),
                  child: Text('+ NOVA PAUTA',
                      style: FONT.pixel(size: 11, color: Colors.black, letterSpacing: 1)),
                ),
              ),
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: DedsecTabBar(active: state.tab.name, onTab: (id) {
              switch (id) {
                case 'home':
                  state.goTab(AppTab.home);
                  break;
                case 'help':
                  state.goTab(AppTab.help);
                  break;
                case 'forum':
                  state.goTab(AppTab.forum);
                  break;
                case 'settings':
                  state.goTab(AppTab.settings);
                  break;
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _topicCard(AppState state, ForumTopic t) {
    final newN = t.newReplies;
    return GestureDetector(
      onTap: () {
        state.setCurrentTopic(t);
        state.markTopicSeen(t.id);
        state.go(AppRoute.topic);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.fromLTRB(12, 12, newN > 0 ? 44 : 12, 12),
        decoration: BoxDecoration(
          color: COL.panel,
          border: Border.all(color: newN > 0 ? COL.acid : COL.line, width: 1.5),
          boxShadow: newN > 0
              ? [BoxShadow(color: COL.acid.withValues(alpha: 0.2), offset: const Offset(2, 2))]
              : null,
        ),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Avatar(seed: t.author, size: 36),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          PixelChip(t.tag, color: COL.acid, size: 7),
                          if (t.hot) const PixelChip('🔥 QUENTE', color: COL.danger, size: 7),
                          if (t.live)
                            Text('● AO VIVO',
                                style: FONT.pixel(size: 8, color: COL.acid)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(t.title,
                          style: FONT.body(size: 13, weight: FontWeight.w600, height: 1.4)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          Text(t.author, style: FONT.mono(size: 10, color: COL.inkDim)),
                          Text('·', style: FONT.mono(size: 10, color: COL.inkDim)),
                          Text('↩ ${t.replies}',
                              style: FONT.mono(size: 10, color: COL.magenta)),
                          Text('·', style: FONT.mono(size: 10, color: COL.inkDim)),
                          Text(t.age, style: FONT.mono(size: 10, color: COL.inkDim)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (newN > 0)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                  decoration: BoxDecoration(
                    color: COL.magenta,
                    border: Border.all(color: Colors.black, width: 1.5),
                  ),
                  child: Text('+$newN',
                      style: FONT.pixel(size: 9, color: Colors.white, letterSpacing: 0.5)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
