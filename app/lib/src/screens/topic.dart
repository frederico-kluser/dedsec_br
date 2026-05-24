import 'dart:async';

import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/models.dart';
import '../design/colors.dart';
import '../design/fonts.dart';
import '../design/moderation.dart';
import '../widgets/atoms.dart';
import '../widgets/overlays.dart';

class TopicScreen extends StatefulWidget {
  const TopicScreen({super.key});
  @override
  State<TopicScreen> createState() => _TopicScreenState();
}

class _ModState {
  _ModState({this.phase = ModPhase.idle, this.text = '', this.word = ''});
  ModPhase phase;
  String text;
  String word;
}

class _TopicScreenState extends State<TopicScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  final _mod = _ModState();
  String? _confirmId;
  int _prevReplyLen = 0;

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send(AppState app) {
    final text = _input.text.trim();
    if (text.isEmpty || _mod.phase != ModPhase.idle) return;
    setState(() {
      _mod
        ..phase = ModPhase.checking
        ..text = text
        ..word = '';
    });
    Timer(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      final result = moderateText(text);
      if (result.blocked) {
        setState(() {
          _mod
            ..phase = ModPhase.blocked
            ..word = result.word ?? '';
        });
      } else {
        app.addReply(text);
        setState(() {
          _input.clear();
          _mod
            ..phase = ModPhase.idle
            ..text = ''
            ..word = '';
        });
      }
    });
  }

  void _dismissMod() => setState(() => _mod
    ..phase = ModPhase.idle
    ..text = ''
    ..word = '');

  void _discardInput() {
    _input.clear();
    _dismissMod();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = app.currentTopic ??
        ForumTopic(
          id: 't1',
          tag: 'TRANSPORTE',
          scope: TopicScope.mun,
          hot: true,
          live: true,
          title: 'Linha 17-Ouro: como cobrar o TCE-SP?',
          author: 'Cidadão_SP_4a7b',
          age: '12 min',
          replies: 87,
          body:
              'Pessoal, vi a pauta no app hoje. Já mandei minha mensagem pro Nunes mas acho que cobrar pelo TCE é mais efetivo. Alguém aqui já abriu processo de denúncia? Como funciona?',
        );

    final isUserPost = t.author == app.user.pseudonym;

    // Auto-scroll on new reply
    if (app.topicReplies.length > _prevReplyLen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scroll.hasClients) {
          _scroll.jumpTo(_scroll.position.maxScrollExtent);
        }
      });
    }
    _prevReplyLen = app.topicReplies.length;

    return Container(
      color: DCol.bg,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: DCol.line)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => app.go(Screen.forumList),
                      child: Text('← PAUTAS',
                          style: DFont.pixel(size: 11, color: DCol.ink)),
                    ),
                    const Spacer(),
                    Text('● AO VIVO · 312',
                        style: DFont.pixel(size: 9, color: DCol.acid)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: _scroll,
                  children: [
                    _topicHeader(t, isUserPost),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        children: [
                          ...app.topicReplies.map((r) => _replyTile(r, app)),
                          if (app.topicReplies.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration:
                                  BoxDecoration(border: Border.all(color: DCol.line, width: 1.5)),
                              alignment: Alignment.center,
                              child: Text(
                                '// ninguém respondeu ainda. seja o primeiro.',
                                style: DFont.mono(size: 11, color: DCol.inkMute),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _composer(app),
            ],
          ),
          ModerationOverlay(
            phase: _mod.phase,
            text: _mod.text,
            word: _mod.word,
            onEdit: _dismissMod,
            onDiscard: _discardInput,
          ),
        ],
      ),
    );
  }

  Widget _topicHeader(ForumTopic t, bool isUserPost) {
    return Container(
      color: DCol.panelHi,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: DCol.panelHi,
        border: Border(bottom: BorderSide(color: DCol.magenta, width: 2)),
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
                    PixelChip(t.tag, color: DCol.acid, size: 7),
                    if (t.hot) const PixelChip('🔥 QUENTE', color: DCol.danger, size: 7),
                    if (t.live)
                      Text('● AO VIVO',
                          style: DFont.pixel(size: 8, color: DCol.acid)),
                  ],
                ),
                const SizedBox(height: 8),
                Stencil(t.title, size: 22, height: 1.1),
                const SizedBox(height: 10),
                Text(t.body,
                    style: DFont.body(size: 13, color: DCol.inkDim, height: 1.55)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(t.author,
                        style: DFont.mono(
                            size: 10,
                            color: isUserPost ? DCol.magenta : DCol.acid)),
                    if (isUserPost) ...[
                      const SizedBox(width: 6),
                      const PixelChip('VOCÊ', color: DCol.magenta, size: 6),
                    ],
                    const SizedBox(width: 6),
                    Text('·', style: DFont.mono(size: 10, color: DCol.inkDim)),
                    const SizedBox(width: 6),
                    Text(t.age, style: DFont.mono(size: 10, color: DCol.inkDim)),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: ['⚡ 87', '🔥 42', '🤔 11', '👍 56'].map((r) {
                    return Container(
                      decoration: BoxDecoration(
                        color: DCol.panel,
                        border: Border.all(color: DCol.line),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Text(r,
                          style: DFont.pixel(size: 9, color: DCol.ink)),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _replyTile(ForumReply r, AppState app) {
    final isMine = r.mine || r.who == app.user.pseudonym;
    final confirming = isMine && _confirmId == r.id;
    return Container(
      margin: const EdgeInsets.only(bottom: 8, left: 12),
      decoration: BoxDecoration(
        color: isMine ? const Color(0xFF161616) : DCol.panel,
        border: Border(
          top: BorderSide(color: isMine ? DCol.acid.withValues(alpha: 0.33) : DCol.line),
          right: BorderSide(color: isMine ? DCol.acid.withValues(alpha: 0.33) : DCol.line),
          bottom: BorderSide(color: isMine ? DCol.acid.withValues(alpha: 0.33) : DCol.line),
          left: BorderSide(color: isMine ? DCol.magenta : DCol.acid, width: 3),
        ),
      ),
      padding: const EdgeInsets.all(12),
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
                        children: [
                          Text(r.who,
                              overflow: TextOverflow.ellipsis,
                              style: DFont.mono(
                                  size: 10, color: isMine ? DCol.magenta : DCol.acid)),
                          if (isMine) const PixelChip('VOCÊ', color: DCol.magenta, size: 6),
                          Text('·', style: DFont.mono(size: 10, color: DCol.inkDim)),
                          Text(r.age, style: DFont.mono(size: 10, color: DCol.inkDim)),
                        ],
                      ),
                    ),
                    if (isMine && !confirming)
                      GestureDetector(
                        onTap: () => setState(() => _confirmId = r.id),
                        child: Container(
                          decoration: BoxDecoration(border: Border.all(color: DCol.line)),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          child: Text('×',
                              style: DFont.pixel(size: 9, color: DCol.inkMute)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(r.body,
                    style:
                        DFont.body(size: 12.5, color: DCol.ink, height: 1.5)),
                if (r.reacts.isNotEmpty && !confirming) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: r.reacts.entries
                        .map((e) => Container(
                              color: DCol.panelHi,
                              decoration: BoxDecoration(
                                color: DCol.panelHi,
                                border: Border.all(color: DCol.line),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              child: Text('${e.key} ${e.value}',
                                  style: DFont.pixel(size: 8, color: DCol.ink)),
                            ))
                        .toList(),
                  ),
                ],
                if (confirming) ...[
                  const SizedBox(height: 10),
                  Container(
                    color: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: DCol.danger, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('APAGAR ESTA RESPOSTA?',
                              style: DFont.pixel(
                                  size: 8, color: DCol.danger, letterSpacing: 1)),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _confirmId = null),
                          child: Container(
                            decoration: BoxDecoration(border: Border.all(color: DCol.line)),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: Text('NÃO',
                                style: DFont.pixel(size: 9, color: DCol.inkDim)),
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            app.deleteReply(r.id);
                            setState(() => _confirmId = null);
                          },
                          child: Container(
                            color: DCol.danger,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: Text('SIM, APAGAR',
                                style: DFont.pixel(
                                    size: 9, color: Colors.black, letterSpacing: 1)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _composer(AppState app) {
    final canSend = _input.text.trim().isNotEmpty && _mod.phase == ModPhase.idle;
    return Container(
      decoration: const BoxDecoration(
        color: DCol.bg2,
        border: Border(top: BorderSide(color: DCol.line, width: 1.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Avatar(seed: app.user.seed, size: 32),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _input,
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _send(app),
              style: DFont.body(size: 13, color: DCol.ink),
              decoration: InputDecoration(
                isDense: true,
                fillColor: DCol.panel,
                filled: true,
                hintText: 'responder como ${app.user.pseudonym}',
                hintStyle: DFont.body(size: 13, color: DCol.inkMute),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: DCol.line),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: DCol.line),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: DCol.acid),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: canSend ? () => _send(app) : null,
            child: Container(
              color: canSend ? DCol.acid : DCol.panelHi,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Text('↳',
                  style: DFont.pixel(
                      size: 10,
                      color: canSend ? Colors.black : DCol.inkMute,
                      letterSpacing: 1)),
            ),
          ),
        ],
      ),
    );
  }
}
