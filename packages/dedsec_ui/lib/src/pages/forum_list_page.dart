import 'package:flutter/material.dart';
import '../atoms/avatar.dart';
import '../atoms/pixel_chip.dart';
import '../atoms/stencil.dart';
import '../molecules/tab_bar.dart';
import '../molecules/top_bar.dart';
import '../state/app_state.dart';
import '../state/topics.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';
import '../widgets/screen_root.dart';
import 'forum_scope_page.dart';
import 'route.dart';

class ForumListPage extends StatelessWidget {
  final ValueChanged<DedsecScreen> onGo;
  final String activeTab;
  final ValueChanged<String> onTab;
  const ForumListPage({super.key, required this.onGo, required this.activeTab, required this.onTab});

  @override
  Widget build(BuildContext context) {
    final state = DedsecScope.of(context);
    final user = state.user;
    final scopeInfo = forumScopes.firstWhere((s) => s.id == state.forumScope, orElse: () => forumScopes.first);
    final filtered = state.topics.where((t) => t.scope == state.forumScope).toList();
    final totalNew = filtered.fold<int>(0, (s, t) => s + t.newReplies);

    return ScreenRoot(
      child: Stack(children: [
        Column(children: [
          const DedsecTopBar(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: DedsecColors.line)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                GestureDetector(
                  onTap: () => onGo(DedsecScreen.forumScope),
                  child: Text('← ESCOPO',
                      style: DedsecFonts.pixel(size: 10, color: DedsecColors.ink, letterSpacing: 1)),
                ),
                const Spacer(),
                PixelChip(scopeInfo.label, color: scopeInfo.color, size: 9),
                const SizedBox(width: 6),
                const PixelChip('● 312', color: DedsecColors.acid, size: 7),
              ]),
              const SizedBox(height: 8),
              Stencil(scopeInfo.sub, size: 22),
              const SizedBox(height: 8),
              Row(children: [
                Avatar(seed: user.seed, size: 26),
                const SizedBox(width: 8),
                Text(user.pseudonym, style: DedsecFonts.mono(size: 11, color: DedsecColors.acid)),
                if (totalNew > 0) ...[
                  const SizedBox(width: 8),
                  Text('· $totalNew NOVOS',
                      style: DedsecFonts.pixel(size: 8, color: DedsecColors.magenta, letterSpacing: 1)),
                ],
              ]),
            ]),
          ),
          Expanded(
            child: filtered.isEmpty
                ? _empty()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 90),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => _topicTile(filtered[i], onGo, state),
                  ),
          ),
          DedsecTabBar(active: activeTab, onTab: onTab),
        ]),
        if (state.forumScope == TopicScope.mun)
          Positioned(
            right: 16,
            bottom: 78,
            child: GestureDetector(
              onTap: () => onGo(DedsecScreen.newPost),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: DedsecColors.acid,
                  border: Border.all(color: Colors.black, width: 3),
                  boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                ),
                child: Text('+ NOVA PAUTA',
                    style: DedsecFonts.pixel(size: 11, color: Colors.black, letterSpacing: 1)),
              ),
            ),
          ),
      ]),
    );
  }

  Widget _empty() => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            '// nenhuma pauta nesse escopo ainda.\n// toque em "+ NOVA PAUTA" pra criar a primeira.',
            textAlign: TextAlign.center,
            style: DedsecFonts.mono(size: 11, color: DedsecColors.inkMute, height: 1.55),
          ),
        ),
      );

  Widget _topicTile(ForumTopic t, ValueChanged<DedsecScreen> go, DedsecAppState state) {
    final newN = t.newReplies;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          state.setCurrentTopic(t);
          state.markTopicSeen(t.id);
          go(DedsecScreen.topic);
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(12, 12, newN > 0 ? 44 : 12, 12),
          decoration: BoxDecoration(
            color: DedsecColors.panel,
            border: Border.all(color: newN > 0 ? DedsecColors.acid : DedsecColors.line, width: 1.5),
          ),
          child: Stack(children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Avatar(seed: t.author, size: 36),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Wrap(spacing: 6, runSpacing: 6, crossAxisAlignment: WrapCrossAlignment.center, children: [
                    PixelChip(t.tag, color: DedsecColors.acid, size: 7),
                    if (t.hot) const PixelChip('🔥 QUENTE', color: DedsecColors.danger, size: 7),
                    if (t.live)
                      Text('● AO VIVO',
                          style: DedsecFonts.pixel(size: 8, color: DedsecColors.acid)),
                  ]),
                  const SizedBox(height: 6),
                  Text(t.title,
                      style: DedsecFonts.body(size: 13, weight: FontWeight.w600, height: 1.4)),
                  const SizedBox(height: 8),
                  Wrap(spacing: 6, runSpacing: 4, children: [
                    Text(t.author, style: DedsecFonts.mono(size: 10, color: DedsecColors.inkDim)),
                    Text('·', style: DedsecFonts.mono(size: 10, color: DedsecColors.inkDim)),
                    Text('↩ ${t.replies}',
                        style: DedsecFonts.mono(size: 10, color: DedsecColors.magenta)),
                    Text('·', style: DedsecFonts.mono(size: 10, color: DedsecColors.inkDim)),
                    Text(t.age, style: DedsecFonts.mono(size: 10, color: DedsecColors.inkDim)),
                  ]),
                ]),
              ),
            ]),
            if (newN > 0)
              Positioned(
                top: 0,
                right: -32,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                  decoration: BoxDecoration(
                    color: DedsecColors.magenta,
                    border: Border.all(color: Colors.black, width: 1.5),
                  ),
                  child: Text('+$newN',
                      style: DedsecFonts.pixel(size: 9, color: Colors.white)),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}
