import 'dart:async';

import 'package:flutter/material.dart';

import '../app/app_scope.dart';
import '../app/app_state.dart';
import '../models/forum.dart';
import '../theme/colors.dart';
import '../theme/fonts.dart';
import '../widgets/atoms/avatar.dart';
import '../widgets/atoms/buttons.dart';
import '../widgets/atoms/text_atoms.dart';
import '../widgets/organisms/analysis_overlay.dart';

class _Authority {
  final String role;
  final String name;
  final String handle;
  const _Authority(this.role, this.name, this.handle);
}

class _AnalysisResult {
  final String theme;
  final Color color;
  final String title;
  final String desc;
  final List<_Authority> authorities;
  final int confidence;
  const _AnalysisResult({
    required this.theme,
    required this.color,
    required this.title,
    required this.desc,
    required this.authorities,
    required this.confidence,
  });
}

_AnalysisResult _analyzeText(String text, TopicScope scope) {
  final lower = text.toLowerCase();
  String theme = 'POLÍTICA';
  Color color = COL.magenta;
  bool match(String pattern) => RegExp(pattern).hasMatch(lower);

  if (match(r'metr[ôo]|[ôo]nibus|\btrans|mobil|rua|via|tr[áa]fego|congestion|cicl')) {
    theme = 'TRANSPORTE';
    color = COL.magenta;
  } else if (match(r'saud|hospital|\bubs|posto|m[ée]dic|\bsus|vacin|pediat|enferm')) {
    theme = 'SAÚDE';
    color = COL.alert;
  } else if (match(r'escol|educa|merenda|professor|aluno|creche|universid')) {
    theme = 'EDUCAÇÃO';
    color = COL.magenta;
  } else if (match(r'or[çc]ament|gasto|verba|licit|contrat|aditiv|caixa|impost')) {
    theme = 'ORÇAMENTO';
    color = COL.acid;
  } else if (match(r'ambient|polui|reciclag|lixo|enchente|desmat|verde|parque')) {
    theme = 'MEIO AMBIENTE';
    color = COL.acid;
  } else if (match(r'cultur|museu|teatro|biblio|arte|festiv')) {
    theme = 'CULTURA';
    color = COL.magenta;
  } else if (match(r'pol[íi]cia|seguran[çc]|crime|viol[êe]ncia|assalt')) {
    theme = 'SEGURANÇA';
    color = COL.danger;
  } else if (match(r'morad|habita|favel|cortic|despej')) {
    theme = 'MORADIA';
    color = COL.alert;
  } else if (match(r'corrup|propin|desvi|fraud|escândal')) {
    theme = 'CORRUPÇÃO';
    color = COL.danger;
  }

  final firstSentence = text.split(RegExp(r'[.!?\n]')).first.trim();
  final title = firstSentence.length > 12
      ? firstSentence.substring(0, 1).toUpperCase() +
          firstSentence.substring(1, firstSentence.length > 110 ? 110 : firstSentence.length)
      : 'Nova pauta de ${theme.toLowerCase()} levantada por cidadão';

  final trim = text.replaceAll(RegExp(r'\s+'), ' ').trim();
  final desc = trim.length > 280 ? '${trim.substring(0, 280).trim()} ...' : trim;

  const auth = <TopicScope, List<_Authority>>{
    TopicScope.mun: [
      _Authority('PREFEITO', 'Prefeitura de São Paulo', '@prefsp'),
      _Authority('CÂMARA MUNICIPAL', 'CMSP — vereadores', '@cmsp_oficial'),
    ],
    TopicScope.est: [
      _Authority('GOVERNADOR', 'Governo do Estado de SP', '@governosp'),
      _Authority('ASSEMBLEIA', 'ALESP', '@alesp_oficial'),
    ],
    TopicScope.fed: [
      _Authority('PRESIDÊNCIA', 'Planalto', '@planalto'),
      _Authority('CÂMARA', 'Câmara dos Deputados', '@camaradeputados'),
      _Authority('SENADO', 'Senado Federal', '@senadofederal'),
    ],
  };

  return _AnalysisResult(
    theme: theme,
    color: color,
    title: title,
    desc: desc,
    authorities: auth[scope]!,
    confidence: 78 + (text.length % 18),
  );
}

enum _NPPhase { idle, analyzing, preview }

class _ScopeOption {
  final TopicScope id;
  final String label;
  final Color color;
  final String sub;
  final String glyph;
  const _ScopeOption(this.id, this.label, this.color, this.sub, this.glyph);
}

const _kScopeOptions = <_ScopeOption>[
  _ScopeOption(TopicScope.mun, 'MUNICIPAL', COL.magenta, 'só sua cidade', '◉'),
  _ScopeOption(TopicScope.est, 'ESTADUAL', COL.acid, 'seu estado', '◐'),
  _ScopeOption(TopicScope.fed, 'FEDERAL', COL.alert, 'país inteiro', '◯'),
];

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});
  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  TopicScope _scope = TopicScope.mun;
  final _text = TextEditingController();
  final _url = TextEditingController();
  _NPPhase _phase = _NPPhase.idle;
  int _currentPhase = 0;
  _AnalysisResult? _result;
  Timer? _phaseTimer;

  @override
  void dispose() {
    _text.dispose();
    _url.dispose();
    _phaseTimer?.cancel();
    super.dispose();
  }

  void _start() {
    if (_text.text.trim().isEmpty || _phase != _NPPhase.idle) return;
    setState(() {
      _phase = _NPPhase.analyzing;
      _currentPhase = 0;
    });
    var p = 0;
    _phaseTimer = Timer.periodic(const Duration(milliseconds: 950), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      p++;
      if (p < kAnalysisPhases.length) {
        setState(() => _currentPhase = p);
      } else {
        timer.cancel();
        setState(() {
          _result = _analyzeText(_text.text, _scope);
          _phase = _NPPhase.preview;
        });
      }
    });
  }

  void _regenerate() {
    _phaseTimer?.cancel();
    setState(() {
      _phase = _NPPhase.idle;
      _result = null;
      _currentPhase = 0;
    });
  }

  void _publish(AppState state) {
    final r = _result!;
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
    state.go(AppRoute.forumList);
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.read(context);
    if (_phase == _NPPhase.preview && _result != null) {
      return _preview(state, _result!);
    }
    return _form(state);
  }

  Widget _form(AppState state) {
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
                    Text('NOVA PAUTA',
                        style: FONT.pixel(size: 9, color: COL.acid)),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const StencilSpans(
                        spans: [
                          TextSpan(text: 'LEVANTE UMA\n'),
                          TextSpan(text: 'PAUTA', style: TextStyle(color: COL.magenta)),
                        ],
                        size: 32,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '// a IA local lê o conteúdo, classifica o tema,\n// identifica autoridades e monta o post pra você.',
                        style: FONT.mono(size: 10, color: COL.inkDim, height: 1.5),
                      ),
                      const SizedBox(height: 22),
                      Text('// ESCOPO DA PAUTA',
                          style: FONT.pixel(size: 9, color: COL.inkMute, letterSpacing: 1.5)),
                      const SizedBox(height: 8),
                      Column(
                        children: [
                          for (final s in _kScopeOptions) _scopeRow(s, state),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text('// CONTEÚDO DA NOTÍCIA',
                              style: FONT.pixel(size: 9, color: COL.inkMute, letterSpacing: 1.5)),
                          const Spacer(),
                          ValueListenableBuilder(
                            valueListenable: _text,
                            builder: (_, v, __) => Text('${v.text.length}/2000',
                                style: FONT.mono(size: 9, color: COL.inkMute)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _text,
                        maxLength: 2000,
                        maxLines: 8,
                        decoration: InputDecoration(
                          hintText:
                              'cole o texto da notícia, descreva o problema, ou conte o que tá acontecendo na sua quebrada...',
                          hintStyle: FONT.body(size: 13, color: COL.inkMute),
                          filled: true,
                          fillColor: Colors.black,
                          counterText: '',
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: COL.line, width: 1.5),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: COL.line, width: 1.5),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: COL.acid, width: 1.5),
                          ),
                        ),
                        style: FONT.body(size: 13, color: COL.ink, height: 1.55),
                      ),
                      const SizedBox(height: 18),
                      Text('// FONTE (URL, opcional)',
                          style: FONT.pixel(size: 9, color: COL.inkMute, letterSpacing: 1.5)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _url,
                        decoration: const InputDecoration(
                          hintText: 'https://g1.globo.com/...',
                          filled: true,
                          fillColor: Colors.black,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: COL.line, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: COL.line, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: COL.acid, width: 1.5),
                          ),
                        ),
                        style: FONT.mono(size: 12, color: COL.acid),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: COL.panel,
                          border: Border.all(color: COL.line, width: 1.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('// LEMBRE',
                                style: FONT.pixel(size: 8, color: COL.acid)),
                            const SizedBox(height: 4),
                            Text(
                              'Você é responsável pelo que publica. A IA classifica e formata, mas não checa veracidade — anexe fontes confiáveis.',
                              style: FONT.mono(size: 10, color: COL.inkDim, height: 1.55),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: COL.line, width: 1.5)),
                ),
                child: ValueListenableBuilder(
                  valueListenable: _text,
                  builder: (_, v, __) {
                    final ok = v.text.trim().isNotEmpty;
                    return Row(
                      children: [
                        Text(ok ? 'PRONTO PRA ANALISAR' : '↓ COLE O CONTEÚDO ↑',
                            style: FONT.pixel(size: 8, color: COL.inkMute, letterSpacing: 1)),
                        const Spacer(),
                        Btn(
                          color: ok ? COL.magenta : COL.line,
                          fg: ok ? Colors.white : COL.inkMute,
                          disabled: !ok,
                          onPressed: ok ? _start : null,
                          child: const Text('ANALISAR COM IA →'),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          AnalysisOverlay(
            phase: _phase == _NPPhase.analyzing ? AnalysisPhaseState.analyzing : AnalysisPhaseState.idle,
            currentPhase: _currentPhase,
            inputText: _text.text,
          ),
        ],
      ),
    );
  }

  Widget _scopeRow(_ScopeOption s, AppState state) {
    final on = _scope == s.id;
    return GestureDetector(
      onTap: () => setState(() => _scope = s.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: on ? COL.panelHi : Colors.transparent,
          border: Border.all(color: on ? s.color : COL.line, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: on ? s.color : COL.panel,
                border: Border.all(color: on ? s.color : COL.line, width: 1.5),
              ),
              child: Text(s.glyph,
                  style: FONT.pixel(
                    size: 14,
                    color: on ? Colors.black : COL.inkDim,
                  )),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.label,
                      style: FONT.pixel(
                        size: 10,
                        color: on ? s.color : COL.ink,
                        letterSpacing: 1.5,
                      )),
                  const SizedBox(height: 2),
                  Text(
                    '${s.sub}${s.id == TopicScope.mun ? ' · ${state.user.city == 'SP' ? 'São Paulo / SP' : state.user.city}' : ''}',
                    style: FONT.mono(size: 10, color: COL.inkMute),
                  ),
                ],
              ),
            ),
            if (on) Text('●', style: FONT.pixel(size: 12, color: s.color)),
          ],
        ),
      ),
    );
  }

  Widget _preview(AppState state, _AnalysisResult r) {
    final scopeLabel = _kScopeOptions.firstWhere((s) => s.id == _scope).label;
    return Container(
      color: COL.bg,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: COL.line)),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _regenerate,
                  child: Text('← REFAZER',
                      style: FONT.pixel(size: 11, color: COL.ink, letterSpacing: 1)),
                ),
                const Spacer(),
                PixelChip('IA · ${r.confidence}% CONFIANÇA', color: COL.acid, size: 8),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PixelChip('PRÉVIA DA PAUTA', color: r.color),
                  const SizedBox(height: 12),
                  StencilSpans(
                    spans: [
                      const TextSpan(text: 'ASSIM VAI\n'),
                      TextSpan(
                        text: 'APARECER',
                        style: TextStyle(color: r.color),
                      ),
                    ],
                    size: 30,
                    height: 1.05,
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: COL.panel,
                      border: Border.all(color: COL.line, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            PixelChip(r.theme, color: r.color, size: 7),
                            PixelChip(scopeLabel, color: COL.acid, size: 7),
                            const PixelChip('● AO VIVO · agora', color: COL.inkMute, size: 7),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(r.title,
                            style: FONT.body(size: 14, weight: FontWeight.w700, height: 1.3)),
                        const SizedBox(height: 8),
                        Text(r.desc,
                            style: FONT.body(size: 12.5, color: COL.inkDim, height: 1.55)),
                        if (_url.text.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Text('↗ ${_url.text}',
                              style: FONT.mono(size: 10, color: COL.acid)),
                        ],
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Avatar(seed: state.user.seed, size: 22),
                            const SizedBox(width: 8),
                            Text('${state.user.pseudonym} · agora',
                                style: FONT.mono(size: 10, color: COL.inkDim)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text('// AUTORIDADES IDENTIFICADAS PELA IA',
                      style: FONT.pixel(size: 9, color: COL.magenta, letterSpacing: 1.2)),
                  for (final a in r.authorities)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: COL.line)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a.role,
                              style: FONT.pixel(size: 7, color: COL.inkMute, letterSpacing: 1)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(a.name,
                                  style: FONT.body(size: 13, weight: FontWeight.w600)),
                              const SizedBox(width: 8),
                              Text(a.handle,
                                  style: FONT.mono(size: 10, color: COL.acid)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: COL.panel,
                      border: Border.all(color: COL.acid, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('// NOTA',
                            style: FONT.pixel(size: 9, color: COL.acid)),
                        const SizedBox(height: 4),
                        Text(
                          'A IA classificou esta pauta automaticamente. Revise antes de publicar — você é responsável pelo conteúdo.',
                          style: FONT.mono(size: 10, color: COL.inkDim, height: 1.55),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: const BoxDecoration(
              color: COL.bg,
              border: Border(top: BorderSide(color: COL.line, width: 1.5)),
            ),
            child: Row(
              children: [
                GhostBtn(
                  color: COL.inkDim,
                  onPressed: _regenerate,
                  child: const Text('↻ REFAZER'),
                ),
                const Spacer(),
                Btn(
                  color: r.color,
                  onPressed: () => _publish(state),
                  child: const Text('PUBLICAR ✓'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
