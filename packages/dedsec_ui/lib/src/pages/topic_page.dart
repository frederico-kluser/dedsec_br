import 'dart:async';
import 'package:flutter/material.dart';
import '../atoms/avatar.dart';
import '../atoms/dashed_box.dart';
import '../atoms/pixel_chip.dart';
import '../atoms/stencil.dart';
import '../organisms/moderation_overlay.dart';
import '../state/app_state.dart';
import '../state/moderation.dart';
import '../state/topics.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';
import '../widgets/screen_root.dart';
import 'route.dart';

class TopicPage extends StatefulWidget {
  final ValueChanged<DedsecScreen> onGo;
  const TopicPage({super.key, required this.onGo});

  @override
  State<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  ModerationPhase _phase = ModerationPhase.idle;
  String _modText = '';
  String? _modWord;
  String? _confirmId;

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send(DedsecAppState state) {
    final txt = _input.text.trim();
    if (txt.isEmpty || _phase != ModerationPhase.idle) return;
    setState(() {
      _phase = ModerationPhase.checking;
      _modText = txt;
      _modWord = null;
    });
    Timer(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      final result = moderateText(txt);
      if (result.blocked) {
        setState(() {
          _phase = ModerationPhase.blocked;
          _modWord = result.word;
        });
      } else {
        state.addReply(txt);
        _input.clear();
        setState(() => _phase = ModerationPhase.idle);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scroll.hasClients) {
            _scroll.animateTo(_scroll.position.maxScrollExtent,
                duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = DedsecScope.of(context);
    final user = state.user;
    final replies = state.topicReplies;
    final t = state.currentTopic ??
        const ForumTopic(
          id: 't1', tag: 'TRANSPORTE', scope: TopicScope.mun, hot: true, live: true,
          title: 'Linha 17-Ouro: como cobrar o TCE-SP?',
          author: 'Cidadão_SP_4a7b', age: '12 min',
          body:
              'Pessoal, vi a pauta no app hoje. Já mandei minha mensagem pro Nunes mas acho que cobrar pelo TCE é mais efetivo. Alguém aqui já abriu processo de denúncia? Como funciona?',
        );
    final isUserPost = t.author == user.pseudonym;

    return ScreenRoot(
      child: Stack(children: [
        Column(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: DedsecColors.line)),
            ),
            child: Row(children: [
              GestureDetector(
                onTap: () => widget.onGo(DedsecScreen.forumList),
                child: Text('← PAUTAS',
                    style: DedsecFonts.pixel(size: 11, color: DedsecColors.ink)),
              ),
              const Spacer(),
              Text('● AO VIVO · 312',
                  style: DedsecFonts.pixel(size: 9, color: DedsecColors.acid)),
            ]),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scroll,
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: DedsecColors.panelHi,
                    border: Border(bottom: BorderSide(color: DedsecColors.magenta, width: 2)),
                  ),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Avatar(seed: t.author, size: 44),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Wrap(spacing: 6, runSpacing: 6, crossAxisAlignment: WrapCrossAlignment.center, children: [
                          PixelChip(t.tag, color: DedsecColors.acid, size: 7),
                          if (t.hot) const PixelChip('🔥 QUENTE', color: DedsecColors.danger, size: 7),
                          if (t.live)
                            Text('● AO VIVO', style: DedsecFonts.pixel(size: 8, color: DedsecColors.acid)),
                        ]),
                        const SizedBox(height: 8),
                        Stencil(t.title, size: 22),
                        const SizedBox(height: 10),
                        Text(t.body,
                            style: DedsecFonts.body(size: 13, color: DedsecColors.inkDim, height: 1.55)),
                        const SizedBox(height: 12),
                        Row(children: [
                          Text(t.author,
                              style: DedsecFonts.mono(size: 10,
                                  color: isUserPost ? DedsecColors.magenta : DedsecColors.acid)),
                          if (isUserPost) ...[
                            const SizedBox(width: 6),
                            const PixelChip('VOCÊ', color: DedsecColors.magenta, size: 6),
                          ],
                          const SizedBox(width: 6),
                          Text('· ${t.age}',
                              style: DedsecFonts.mono(size: 10, color: DedsecColors.inkDim)),
                        ]),
                        const SizedBox(height: 10),
                        Wrap(spacing: 6, runSpacing: 6, children: [
                          for (final r in ['⚡ 87', '🔥 42', '🤔 11', '👍 56'])
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              decoration: BoxDecoration(
                                color: DedsecColors.panel,
                                border: Border.all(color: DedsecColors.line),
                              ),
                              child: Text(r, style: DedsecFonts.pixel(size: 9, color: DedsecColors.ink)),
                            ),
                        ]),
                      ]),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: replies.isEmpty
                      ? DashedBox(
                          color: DedsecColors.line,
                          strokeWidth: 1.5,
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              '// ninguém respondeu ainda. seja o primeiro.',
                              textAlign: TextAlign.center,
                              style: DedsecFonts.mono(size: 11, color: DedsecColors.inkMute),
                            ),
                          ),
                        )
                      : Column(children: [for (final r in replies) _replyTile(r, user.pseudonym, state)]),
                ),
              ]),
            ),
          ),
          _composer(state, user.seed, user.pseudonym),
        ]),
        ModerationOverlay(
          phase: _phase,
          text: _modText,
          word: _modWord,
          onEdit: () => setState(() => _phase = ModerationPhase.idle),
          onDiscard: () {
            _input.clear();
            setState(() => _phase = ModerationPhase.idle);
          },
        ),
      ]),
    );
  }

  Widget _replyTile(ForumReply r, String me, DedsecAppState state) {
    final isMine = r.mine || r.who == me;
    final confirming = isMine && _confirmId == r.id;
    return Container(
      margin: const EdgeInsets.only(left: 12, bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMine ? const Color(0xFF161616) : DedsecColors.panel,
        border: Border(
          top: BorderSide(color: isMine ? DedsecColors.acid.withOpacity(0.33) : DedsecColors.line),
          right: BorderSide(color: isMine ? DedsecColors.acid.withOpacity(0.33) : DedsecColors.line),
          bottom: BorderSide(color: isMine ? DedsecColors.acid.withOpacity(0.33) : DedsecColors.line),
          left: BorderSide(color: isMine ? DedsecColors.magenta : DedsecColors.acid, width: 3),
        ),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Avatar(seed: r.seed ?? r.who, size: 32),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: Text(r.who,
                    overflow: TextOverflow.ellipsis,
                    style: DedsecFonts.mono(size: 10,
                        color: isMine ? DedsecColors.magenta : DedsecColors.acid)),
              ),
              if (isMine) const SizedBox(width: 6),
              if (isMine) const PixelChip('VOCÊ', color: DedsecColors.magenta, size: 6),
              const SizedBox(width: 6),
              Text('· ${r.age}',
                  style: DedsecFonts.mono(size: 10, color: DedsecColors.inkDim)),
              if (isMine && !confirming) ...[
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => setState(() => _confirmId = r.id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(border: Border.all(color: DedsecColors.line)),
                    child: Text('×', style: DedsecFonts.pixel(size: 9, color: DedsecColors.inkMute)),
                  ),
                ),
              ],
            ]),
            const SizedBox(height: 6),
            Text(r.body, style: DedsecFonts.body(size: 12.5, color: DedsecColors.ink, height: 1.5)),
            if (r.reacts.isNotEmpty && !confirming) ...[
              const SizedBox(height: 8),
              Wrap(spacing: 6, runSpacing: 6, children: [
                for (final e in r.reacts.entries)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: DedsecColors.panelHi,
                      border: Border.all(color: DedsecColors.line),
                    ),
                    child: Text('${e.key} ${e.value}',
                        style: DedsecFonts.pixel(size: 8, color: DedsecColors.ink)),
                  ),
              ]),
            ],
            if (confirming) ...[
              const SizedBox(height: 10),
              DashedBox(
                color: DedsecColors.danger,
                strokeWidth: 1.5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Row(children: [
                    Expanded(
                      child: Text('APAGAR ESTA RESPOSTA?',
                          style: DedsecFonts.pixel(
                              size: 8, color: DedsecColors.danger, letterSpacing: 1)),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _confirmId = null),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(border: Border.all(color: DedsecColors.line)),
                        child: Text('NÃO',
                            style: DedsecFonts.pixel(size: 9, color: DedsecColors.inkDim)),
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
                        color: DedsecColors.danger,
                        child: Text('SIM, APAGAR',
                            style: DedsecFonts.pixel(size: 9, color: Colors.black)),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ]),
        ),
      ]),
    );
  }

  Widget _composer(DedsecAppState state, String seed, String pseudonym) {
    final canSend = _input.text.trim().isNotEmpty && _phase == ModerationPhase.idle;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: const BoxDecoration(
        color: DedsecColors.bg2,
        border: Border(top: BorderSide(color: DedsecColors.line, width: 1.5)),
      ),
      child: Row(children: [
        Avatar(seed: seed, size: 32),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: _input,
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _send(state),
            style: DedsecFonts.body(size: 13, color: DedsecColors.ink),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: DedsecColors.panel,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              hintText: 'responder como $pseudonym',
              hintStyle: DedsecFonts.body(size: 13, color: DedsecColors.inkMute),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: DedsecColors.line),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: DedsecColors.line),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: DedsecColors.acid),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: canSend ? () => _send(state) : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            color: canSend ? DedsecColors.acid : DedsecColors.panelHi,
            child: Text('↳',
                style: DedsecFonts.pixel(
                  size: 10,
                  color: canSend ? Colors.black : DedsecColors.inkMute,
                  letterSpacing: 1,
                )),
          ),
        ),
      ]),
    );
  }
}
