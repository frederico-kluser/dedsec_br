import 'dart:async';
import 'package:flutter/material.dart';
import '../atoms/avatar.dart';
import '../atoms/btn.dart';
import '../atoms/dashed_box.dart';
import '../atoms/ghost_btn.dart';
import '../atoms/pixel_chip.dart';
import '../atoms/stencil.dart';
import '../organisms/analysis_overlay.dart';
import '../state/analysis.dart';
import '../state/app_state.dart';
import '../state/topics.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';
import '../widgets/screen_root.dart';
import 'route.dart';

enum _NPPhase { idle, analyzing, preview }

class NewPostPage extends StatefulWidget {
  final ValueChanged<DedsecScreen> onGo;
  const NewPostPage({super.key, required this.onGo});

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  TopicScope _scope = TopicScope.mun;
  final _textCtrl = TextEditingController();
  final _urlCtrl = TextEditingController();
  _NPPhase _phase = _NPPhase.idle;
  int _currentPhase = 0;
  AnalysisResult? _result;
  Timer? _phaseTimer;

  @override
  void dispose() {
    _textCtrl.dispose();
    _urlCtrl.dispose();
    _phaseTimer?.cancel();
    super.dispose();
  }

  void _start() {
    if (_textCtrl.text.trim().isEmpty) return;
    setState(() {
      _phase = _NPPhase.analyzing;
      _currentPhase = 0;
    });
    var p = 0;
    _phaseTimer = Timer.periodic(const Duration(milliseconds: 950), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      p++;
      if (p < analysisPhases.length) {
        setState(() => _currentPhase = p);
      } else {
        t.cancel();
        setState(() {
          _result = analyzeText(_textCtrl.text, _scope);
          _phase = _NPPhase.preview;
        });
      }
    });
  }

  void _regen() {
    _phaseTimer?.cancel();
    setState(() {
      _phase = _NPPhase.idle;
      _result = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = DedsecScope.of(context);
    final user = state.user;

    if (_phase == _NPPhase.preview && _result != null) {
      return _previewView(state, user.pseudonym, user.seed);
    }
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
                child: Text('← PAUTAS', style: DedsecFonts.pixel(size: 11)),
              ),
              const Spacer(),
              Text('NOVA PAUTA',
                  style: DedsecFonts.pixel(size: 9, color: DedsecColors.acid)),
            ]),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const StencilRich(size: 32, spans: [
                  TextSpan(text: 'LEVANTE UMA\n'),
                  TextSpan(text: 'PAUTA', style: TextStyle(color: DedsecColors.magenta)),
                ]),
                const SizedBox(height: 6),
                Text(
                  '// a IA local lê o conteúdo, classifica o tema,\n// identifica autoridades e monta o post pra você.',
                  style: DedsecFonts.mono(size: 10, color: DedsecColors.inkDim, height: 1.5),
                ),
                const SizedBox(height: 22),
                Text('// ESCOPO DA PAUTA',
                    style: DedsecFonts.pixel(size: 9, color: DedsecColors.inkMute, letterSpacing: 1.5)),
                const SizedBox(height: 8),
                for (final s in newPostScopes) _scopeRow(s, user.city),
                const SizedBox(height: 22),
                Row(children: [
                  Text('// CONTEÚDO DA NOTÍCIA',
                      style: DedsecFonts.pixel(size: 9, color: DedsecColors.inkMute, letterSpacing: 1.5)),
                  const Spacer(),
                  Text('${_textCtrl.text.length}/2000',
                      style: DedsecFonts.mono(size: 9, color: DedsecColors.inkMute)),
                ]),
                const SizedBox(height: 8),
                TextField(
                  controller: _textCtrl,
                  maxLength: 2000,
                  maxLines: 6,
                  minLines: 4,
                  onChanged: (_) => setState(() {}),
                  style: DedsecFonts.body(size: 13, color: DedsecColors.ink, height: 1.55),
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: Colors.black,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    hintText:
                        'cole o texto da notícia, descreva o problema, ou conte o que tá acontecendo na sua quebrada...',
                    hintStyle: DedsecFonts.body(size: 13, color: DedsecColors.inkMute),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(color: DedsecColors.line, width: 1.5),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(color: DedsecColors.line, width: 1.5),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(color: DedsecColors.acid),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text('// FONTE (URL, opcional)',
                    style: DedsecFonts.pixel(size: 9, color: DedsecColors.inkMute, letterSpacing: 1.5)),
                const SizedBox(height: 8),
                TextField(
                  controller: _urlCtrl,
                  style: DedsecFonts.mono(size: 12, color: DedsecColors.acid),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.black,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    hintText: 'https://g1.globo.com/...',
                    hintStyle: DedsecFonts.mono(size: 12, color: DedsecColors.inkMute),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(color: DedsecColors.line, width: 1.5),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(color: DedsecColors.line, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DashedBox(
                  color: DedsecColors.line,
                  strokeWidth: 1.5,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('// LEMBRE',
                          style: DedsecFonts.pixel(size: 8, color: DedsecColors.acid)),
                      const SizedBox(height: 6),
                      Text(
                        'Você é responsável pelo que publica. A IA classifica e formata, mas não checa veracidade — anexe fontes confiáveis.',
                        style: DedsecFonts.mono(size: 10, color: DedsecColors.inkDim, height: 1.55),
                      ),
                    ]),
                  ),
                ),
              ]),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: const BoxDecoration(
              color: DedsecColors.bg,
              border: Border(top: BorderSide(color: DedsecColors.line, width: 1.5)),
            ),
            child: Row(children: [
              Text(_textCtrl.text.trim().isNotEmpty ? 'PRONTO PRA ANALISAR' : '↓ COLE O CONTEÚDO ↑',
                  style: DedsecFonts.pixel(size: 8, color: DedsecColors.inkMute, letterSpacing: 1)),
              const Spacer(),
              Btn(
                label: 'ANALISAR COM IA →',
                color: _textCtrl.text.trim().isNotEmpty ? DedsecColors.magenta : DedsecColors.line,
                fg: _textCtrl.text.trim().isNotEmpty ? Colors.white : DedsecColors.inkMute,
                onPressed: _textCtrl.text.trim().isNotEmpty ? _start : null,
                disabled: _textCtrl.text.trim().isEmpty,
              ),
            ]),
          ),
        ]),
        AnalysisOverlay(
          active: _phase == _NPPhase.analyzing,
          currentPhase: _currentPhase,
          inputText: _textCtrl.text,
        ),
      ]),
    );
  }

  Widget _scopeRow(NewPostScopeInfo s, String city) {
    final on = _scope == s.id;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () => setState(() => _scope = s.id),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: on ? DedsecColors.panelHi : Colors.transparent,
            border: Border.all(color: on ? s.color : DedsecColors.line, width: 1.5),
          ),
          child: Row(children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: on ? s.color : DedsecColors.panel,
                border: Border.all(color: on ? s.color : DedsecColors.line, width: 1.5),
              ),
              child: Center(
                child: Text(
                  s.id == TopicScope.mun ? '◉' : s.id == TopicScope.est ? '◐' : '◯',
                  style: DedsecFonts.pixel(size: 14, color: on ? Colors.black : DedsecColors.inkDim),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s.label,
                    style: DedsecFonts.pixel(size: 10, color: on ? s.color : DedsecColors.ink, letterSpacing: 1.5)),
                const SizedBox(height: 2),
                Text(
                  '${s.sub}${s.id == TopicScope.mun ? ' · ${city == 'SP' ? 'São Paulo / SP' : city}' : ''}',
                  style: DedsecFonts.mono(size: 10, color: DedsecColors.inkMute),
                ),
              ]),
            ),
            if (on) Text('●', style: DedsecFonts.pixel(size: 12, color: s.color)),
          ]),
        ),
      ),
    );
  }

  Widget _previewView(DedsecAppState state, String pseudonym, String seed) {
    final r = _result!;
    final scopeLabel = newPostScopes.firstWhere((s) => s.id == _scope).label;
    return ScreenRoot(
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: DedsecColors.line)),
          ),
          child: Row(children: [
            GestureDetector(
              onTap: _regen,
              child: Text('← REFAZER', style: DedsecFonts.pixel(size: 11)),
            ),
            const Spacer(),
            PixelChip('IA · ${r.confidence}% CONFIANÇA', color: DedsecColors.acid, size: 8),
          ]),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              PixelChip('PRÉVIA DA PAUTA', color: r.color),
              const SizedBox(height: 12),
              StencilRich(size: 30, spans: [
                const TextSpan(text: 'ASSIM VAI\n'),
                TextSpan(text: 'APARECER', style: TextStyle(color: r.color)),
              ]),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: DedsecColors.panel,
                  border: Border.all(color: DedsecColors.line, width: 1.5),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Wrap(spacing: 6, runSpacing: 6, children: [
                    PixelChip(r.theme, color: r.color, size: 7),
                    PixelChip(scopeLabel, color: DedsecColors.acid, size: 7),
                    const PixelChip('● AO VIVO · agora', color: DedsecColors.inkMute, size: 7),
                  ]),
                  const SizedBox(height: 10),
                  Text(r.title, style: DedsecFonts.body(size: 14, weight: FontWeight.w700, height: 1.3)),
                  const SizedBox(height: 8),
                  Text(r.desc, style: DedsecFonts.body(size: 12.5, color: DedsecColors.inkDim, height: 1.55)),
                  if (_urlCtrl.text.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text('↗ ${_urlCtrl.text}',
                        style: DedsecFonts.mono(size: 10, color: DedsecColors.acid)),
                  ],
                  const SizedBox(height: 12),
                  Row(children: [
                    Avatar(seed: seed, size: 22),
                    const SizedBox(width: 8),
                    Text('$pseudonym · agora',
                        style: DedsecFonts.mono(size: 10, color: DedsecColors.inkDim)),
                  ]),
                ]),
              ),
              const SizedBox(height: 18),
              Text('// AUTORIDADES IDENTIFICADAS PELA IA',
                  style: DedsecFonts.pixel(size: 9, color: DedsecColors.magenta, letterSpacing: 1.2)),
              for (final a in r.authorities)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: DedsecColors.line)),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(a.role,
                        style: DedsecFonts.pixel(size: 7, color: DedsecColors.inkMute, letterSpacing: 1)),
                    const SizedBox(height: 4),
                    Row(children: [
                      Text(a.name,
                          style: DedsecFonts.body(size: 13, weight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      Text(a.handle, style: DedsecFonts.mono(size: 10, color: DedsecColors.acid)),
                    ]),
                  ]),
                ),
              const SizedBox(height: 18),
              DashedBox(
                color: DedsecColors.acid,
                strokeWidth: 1.5,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('// NOTA',
                        style: DedsecFonts.pixel(size: 9, color: DedsecColors.acid)),
                    const SizedBox(height: 6),
                    Text(
                      'A IA classificou esta pauta automaticamente. Revise antes de publicar — você é responsável pelo conteúdo.',
                      style: DedsecFonts.mono(size: 10, color: DedsecColors.inkDim, height: 1.55),
                    ),
                  ]),
                ),
              ),
            ]),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: const BoxDecoration(
            color: DedsecColors.bg,
            border: Border(top: BorderSide(color: DedsecColors.line, width: 1.5)),
          ),
          child: Row(children: [
            GhostBtn(label: '↻ REFAZER', color: DedsecColors.inkDim, onPressed: _regen),
            const Spacer(),
            Btn(
              label: 'PUBLICAR ✓',
              color: r.color,
              onPressed: () {
                state.addTopic(ForumTopic(
                  id: 't${DateTime.now().millisecondsSinceEpoch}',
                  tag: r.theme,
                  scope: _scope,
                  title: r.title,
                  body: r.desc,
                  author: state.user.pseudonym,
                  seed: state.user.seed,
                  age: 'agora',
                  live: true,
                ));
                state.setForumScope(_scope);
                widget.onGo(DedsecScreen.forumList);
              },
            ),
          ]),
        ),
      ]),
    );
  }
}
