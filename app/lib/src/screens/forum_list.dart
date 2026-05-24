import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/models.dart';
import '../design/colors.dart';
import '../design/fonts.dart';
import '../widgets/atoms.dart';
import '../widgets/molecules.dart';
import 'forum_scope.dart';

class ForumListScreen extends StatelessWidget {
  const ForumListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final scope = FORUM_SCOPES.firstWhere(
      (s) => s.id == app.forumScope,
      orElse: () => FORUM_SCOPES[0],
    );
    final filtered = app.topics.where((t) => t.scope == app.forumScope).toList();
    final totalNew = filtered.fold<int>(0, (sum, t) => sum + t.newReplies);

    return Container(
      color: DCol.bg,
      child: Stack(
        children: [
          Column(
            children: [
              const TopBar(),
              Container(
                decoration:
                    const BoxDecoration(border: Border(bottom: BorderSide(color: DCol.line))),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => app.go(Screen.forumScope),
                          child: Text('← ESCOPO',
                              style: DFont.pixel(size: 10, color: DCol.ink, letterSpacing: 1)),
                        ),
                        const Spacer(),
                        PixelChip(scope.label, color: scope.color, size: 9),
                        const SizedBox(width: 6),
                        const PixelChip('● 312', color: DCol.acid, size: 7),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Stencil(scope.sub, size: 22, height: 1),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Avatar(seed: app.user.seed, size: 26),
                        const SizedBox(width: 8),
                        Text(app.user.pseudonym,
                            style: DFont.mono(size: 11, color: DCol.acid)),
                        if (totalNew > 0) ...[
                          const SizedBox(width: 6),
                          Text('· $totalNew NOVOS',
                              style: DFont.pixel(
                                  size: 8, color: DCol.magenta, letterSpacing: 1)),
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
                          decoration: BoxDecoration(border: Border.all(color: DCol.line, width: 1.5)),
                          alignment: Alignment.center,
                          child: Text(
                            '// nenhuma pauta nesse escopo ainda.\n// toque em "+ NOVA PAUTA" pra criar a primeira.',
                            textAlign: TextAlign.center,
                            style: DFont.mono(size: 11, color: DCol.inkMute, height: 1.55),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 90),
                        itemCount: filtered.length,
                        itemBuilder: (_, i) => _topicCard(filtered[i], app),
                      ),
              ),
              DTabBar(active: app.tab, onTab: app.goTab),
            ],
          ),
          if (app.forumScope == TopicScope.mun)
            Positioned(
              right: 16,
              bottom: 78 + 48,
              child: GestureDetector(
                onTap: () => app.go(Screen.newPost),
                child: Container(
                  decoration: BoxDecoration(
                    color: DCol.acid,
                    border: Border.all(color: Colors.black, width: 3),
                    boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Text('+ NOVA PAUTA',
                      style:
                          DFont.pixel(size: 11, color: Colors.black, letterSpacing: 1)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _topicCard(ForumTopic t, AppState app) {
    final newN = t.newReplies;
    return GestureDetector(
      onTap: () {
        app.setCurrentTopic(t);
        app.markTopicSeen(t.id);
        app.go(Screen.topic);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: DCol.panel,
          border: Border.all(color: newN > 0 ? DCol.acid : DCol.line, width: 1.5),
          boxShadow: newN > 0
              ? [BoxShadow(color: DCol.acid.withValues(alpha: 0.2), offset: const Offset(2, 2))]
              : null,
        ),
        padding: EdgeInsets.fromLTRB(12, 12, newN > 0 ? 44 : 12, 12),
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
                          PixelChip(t.tag, color: DCol.acid, size: 7),
                          if (t.hot) const PixelChip('🔥 QUENTE', color: DCol.danger, size: 7),
                          if (t.live)
                            Text('● AO VIVO',
                                style: DFont.pixel(size: 8, color: DCol.acid)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(t.title,
                          style: DFont.body(
                              size: 13,
                              color: DCol.ink,
                              weight: FontWeight.w600,
                              height: 1.4)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        children: [
                          Text(t.author,
                              overflow: TextOverflow.ellipsis,
                              style: DFont.mono(size: 10, color: DCol.inkDim)),
                          Text('·', style: DFont.mono(size: 10, color: DCol.inkDim)),
                          Text('↩ ${t.replies}',
                              style: DFont.mono(size: 10, color: DCol.magenta)),
                          Text('·', style: DFont.mono(size: 10, color: DCol.inkDim)),
                          Text(t.age, style: DFont.mono(size: 10, color: DCol.inkDim)),
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
                  decoration: BoxDecoration(
                    color: DCol.magenta,
                    border: Border.all(color: Colors.black, width: 1.5),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                  constraints: const BoxConstraints(minWidth: 22),
                  child: Text('+$newN',
                      textAlign: TextAlign.center,
                      style: DFont.pixel(
                          size: 9, color: Colors.white, letterSpacing: 0.5)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
