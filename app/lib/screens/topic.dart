import 'package:flutter/material.dart';

import '../app/app_scope.dart';
import '../app/app_state.dart';
import '../data/moderation.dart';
import '../models/forum.dart';
import '../theme/colors.dart';
import '../theme/fonts.dart';
import '../widgets/atoms/avatar.dart';
import '../widgets/atoms/text_atoms.dart';
import '../widgets/organisms/moderation_overlay.dart';

class TopicScreen extends StatefulWidget {
  const TopicScreen({super.key});
  @override
  State<TopicScreen> createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  ModerationPhase _modPhase = ModerationPhase.idle;
  String _modText = '';
  String? _modWord;
  String? _confirmId;
  int? _lastReplyCount;

  static const _fallback = ForumTopic(
    id: 't1',
    tag: 'TRANSPORTE',
    scope: TopicScope.mun,
    hot: true,
    live: true,
    title: 'Linha 17-Ouro: como cobrar o TCE-SP?',
    body:
        'Pessoal, vi a pauta no app hoje. Já mandei minha mensagem pro Nunes mas acho que cobrar pelo TCE é mais efetivo. Alguém aqui já abriu processo de denúncia? Como funciona?',
    author: 'Cidadão_SP_4a7b',
    age: '12 min',
  );

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send(AppState state) {
    final text = _input.text.trim();
    if (text.isEmpty || _modPhase != ModerationPhase.idle) return;
    setState(() {
      _modPhase = ModerationPhase.checking;
      _modText = text;
      _modWord = null;
    });
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      final r = moderateText(text);
      if (r.blocked) {
        setState(() {
          _modPhase = ModerationPhase.blocked;
          _modWord = r.word;
        });
      } else {
        state.addReply(text);
        _input.clear();
        setState(() {
          _modPhase = ModerationPhase.idle;
          _modWord = null;
          _modText = '';
        });
      }
    });
  }

  void _dismiss() => setState(() {
        _modPhase = ModerationPhase.idle;
        _modWord = null;
      });
  void _discard() {
    _input.clear();
    _dismiss();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final replies = state.replies;
    final t = state.currentTopic ?? _fallback;
    final isUserPost = t.author == state.user.pseudonym;

    // auto-scroll on new reply
    final count = replies.length;
    if (_lastReplyCount != null && count > _lastReplyCount!) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scroll.hasClients) {
          _scroll.animateTo(
            _scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    }
    _lastReplyCount = count;

    return Container(
      color: COL.bg,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: COL.line)),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => state.go(AppRoute.forumList),
                      child: Text('← PAUTAS',
                          style: FONT.pixel(size: 11, color: COL.ink, letterSpacing: 1)),
                    ),
                    const Spacer(),
                    Text('● AO VIVO · 312', style: FONT.pixel(size: 9, color: COL.acid)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: _scroll,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: COL.panelHi,
                        border: Border(bottom: BorderSide(color: COL.magenta, width: 2)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Avatar(seed: t.author, size: 44),
                          const SizedBox(width: 12),
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
                                      Text('● AO VIVO', style: FONT.pixel(size: 8, color: COL.acid)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Stencil(t.title, size: 22, height: 1.1),
                                const SizedBox(height: 10),
                                Text(t.body,
                                    style: FONT.body(size: 13, color: COL.inkDim, height: 1.55)),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(t.author,
                                        style: FONT.mono(
                                          size: 10,
                                          color: isUserPost ? COL.magenta : COL.acid,
                                        )),
                                    if (isUserPost) const PixelChip('VOCÊ', color: COL.magenta, size: 6),
                                    Text('·', style: FONT.mono(size: 10, color: COL.inkDim)),
                                    Text(t.age, style: FONT.mono(size: 10, color: COL.inkDim)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: [
                                    for (final r in ['⚡ 87', '🔥 42', '🤔 11', '👍 56'])
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: COL.panel,
                                          border: Border.all(color: COL.line),
                                        ),
                                        child: Text(r, style: FONT.pixel(size: 9, color: COL.ink)),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        children: [
                          if (replies.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(border: Border.all(color: COL.line, width: 1.5)),
                              child: Text(
                                '// ninguém respondeu ainda. seja o primeiro.',
                                textAlign: TextAlign.center,
                                style: FONT.mono(size: 11, color: COL.inkMute),
                              ),
                            )
                          else
                            for (final r in replies) _replyTile(state, r),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: const BoxDecoration(
                  color: COL.bg2,
                  border: Border(top: BorderSide(color: COL.line, width: 1.5)),
                ),
                child: Row(
                  children: [
                    Avatar(seed: state.user.seed, size: 32),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: COL.panel,
                          border: Border.all(color: COL.line),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: TextField(
                          controller: _input,
                          onSubmitted: (_) => _send(state),
                          decoration: InputDecoration(
                            hintText: 'responder como ${state.user.pseudonym}',
                            hintStyle: FONT.body(size: 13, color: COL.inkMute),
                            isCollapsed: true,
                            border: InputBorder.none,
                          ),
                          style: FONT.body(size: 13, color: COL.ink),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _send(state),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        color: _input.text.trim().isEmpty || _modPhase != ModerationPhase.idle
                            ? COL.panelHi
                            : COL.acid,
                        child: Text(
                          '↳',
                          style: FONT.pixel(
                            size: 10,
                            color: _input.text.trim().isEmpty || _modPhase != ModerationPhase.idle
                                ? COL.inkMute
                                : Colors.black,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ModerationOverlay(
            phase: _modPhase,
            text: _modText,
            word: _modWord,
            onEdit: _dismiss,
            onDiscard: _discard,
          ),
        ],
      ),
    );
  }

  Widget _replyTile(AppState state, ForumReply r) {
    final isMine = r.mine || r.who == state.user.pseudonym;
    final confirming = isMine && _confirmId == r.id;
    return Container(
      margin: const EdgeInsets.only(bottom: 8, left: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMine ? const Color(0xFF161616) : COL.panel,
        border: Border(
          left: BorderSide(color: isMine ? COL.magenta : COL.acid, width: 3),
          top: BorderSide(color: isMine ? COL.acid.withValues(alpha: 0.33) : COL.line),
          right: BorderSide(color: isMine ? COL.acid.withValues(alpha: 0.33) : COL.line),
          bottom: BorderSide(color: isMine ? COL.acid.withValues(alpha: 0.33) : COL.line),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Avatar(seed: r.seed ?? r.who, size: 32),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(r.who,
                              overflow: TextOverflow.ellipsis,
                              style: FONT.mono(
                                size: 10,
                                color: isMine ? COL.magenta : COL.acid,
                              )),
                          if (isMine) const PixelChip('VOCÊ', color: COL.magenta, size: 6),
                          Text('·', style: FONT.mono(size: 10, color: COL.inkDim)),
                          Text(r.age, style: FONT.mono(size: 10, color: COL.inkDim)),
                        ],
                      ),
                    ),
                    if (isMine && !confirming)
                      GestureDetector(
                        onTap: () => setState(() => _confirmId = r.id),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(border: Border.all(color: COL.line)),
                          child: Text('×', style: FONT.pixel(size: 9, color: COL.inkMute)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(r.body, style: FONT.body(size: 12.5, color: COL.ink, height: 1.5)),
                if (r.reacts.isNotEmpty && !confirming)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final e in r.reacts.entries)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                            decoration: BoxDecoration(
                              color: COL.panelHi,
                              border: Border.all(color: COL.line),
                            ),
                            child: Text('${e.key} ${e.value}',
                                style: FONT.pixel(size: 8, color: COL.ink)),
                          ),
                      ],
                    ),
                  ),
                if (confirming)
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: COL.danger, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('APAGAR ESTA RESPOSTA?',
                              style: FONT.pixel(size: 8, color: COL.danger, letterSpacing: 1)),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _confirmId = null),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(border: Border.all(color: COL.line)),
                            child: Text('NÃO',
                                style: FONT.pixel(size: 9, color: COL.inkDim)),
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            state.deleteReply(r.id);
                            setState(() => _confirmId = null);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            color: COL.danger,
                            child: Text('SIM, APAGAR',
                                style: FONT.pixel(size: 9, color: Colors.black, letterSpacing: 1)),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
