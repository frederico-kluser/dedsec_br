import 'dart:async';

import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/models.dart';
import '../design/colors.dart';
import '../design/fonts.dart';
import '../widgets/atoms.dart';
import '../widgets/overlays.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});
  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NPScope {
  const _NPScope({required this.id, required this.label, required this.color, required this.sub, required this.glyph});
  final TopicScope id;
  final String label;
  final Color color;
  final String sub;
  final String glyph;
}

const _scopes = <_NPScope>[
  _NPScope(id: TopicScope.mun, label: 'MUNICIPAL', color: DCol.magenta, sub: 'só sua cidade', glyph: '◉'),
  _NPScope(id: TopicScope.est, label: 'ESTADUAL', color: DCol.acid, sub: 'seu estado', glyph: '◐'),
  _NPScope(id: TopicScope.fed, label: 'FEDERAL', color: DCol.alert, sub: 'país inteiro', glyph: '◯'),
];

enum _Phase { idle, analyzing, preview }

class _NewPostScreenState extends State<NewPostScreen> {
  final _text = TextEditingController();
  final _url = TextEditingController();
  TopicScope _scope = TopicScope.mun;
  _Phase _phase = _Phase.idle;
  int _currentPhase = 0;
  AnalysisResult? _result;
  Timer? _phaseTimer;

  @override
  void dispose() {
    _text.dispose();
    _url.dispose();
    _phaseTimer?.cancel();
    super.dispose();
  }

  void _startAnalysis() {
    final txt = _text.text.trim();
    if (txt.isEmpty || _phase != _Phase.idle) return;
    setState(() {
      _phase = _Phase.analyzing;
      _currentPhase = 0;
    });
    var p = 0;
    _phaseTimer = Timer.periodic(const Duration(milliseconds: 950), (t) {
      p++;
      if (p < ANALYSIS_PHASES.length) {
        setState(() => _currentPhase = p);
      } else {
        t.cancel();
        setState(() {
          _result = _analyzeText(_text.text, _scope);
          _phase = _Phase.preview;
        });
      }
    });
  }

  void _regenerate() {
    _phaseTimer?.cancel();
    setState(() {
      _phase = _Phase.idle;
      _result = null;
    });
  }

  void _publish(AppState app) {
    final r = _result;
    if (r == null) return;
    app.addTopic(ForumTopic(
      id: 't${DateTime.now().millisecondsSinceEpoch}',
      tag: r.theme,
      title: r.title,
      body: r.desc,
      author: app.user.pseudonym,
      seed: app.user.seed,
      replies: 0,
      age: 'agora',
      live: true,
      scope: _scope,
    ));
    app.setForumScope(_scope);
    app.go(Screen.forumList);
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    if (_phase == _Phase.preview && _result != null) {
      return _previewView(app, _result!);
    }
    return _formView(app);
  }

  Widget _formView(AppState app) {
    return Container(
      color: DCol.bg,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                decoration:
                    const BoxDecoration(border: Border(bottom: BorderSide(color: DCol.line))),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => app.go(Screen.forumList),
                      child: Text('← PAUTAS',
                          style: DFont.pixel(size: 11, color: DCol.ink)),
                    ),
                    const Spacer(),
                    Text('NOVA PAUTA',
                        style: DFont.pixel(size: 9, color: DCol.acid)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
                  children: [
                    const StencilTwoLine(first: 'LEVANTE UMA', second: 'PAUTA', size: 32, height: 0.95),
                    const SizedBox(height: 6),
                    Text(
                      '// a IA local lê o conteúdo, classifica o tema,\n'
                      '// identifica autoridades e monta o post pra você.',
                      style: DFont.mono(size: 10, color: DCol.inkDim, height: 1.5),
                    ),
                    const SizedBox(height: 22),
                    Text('// ESCOPO DA PAUTA',
                        style: DFont.pixel(size: 9, color: DCol.inkMute, letterSpacing: 1.5)),
                    const SizedBox(height: 8),
                    ..._scopes.map((s) => _scopeRow(s, app)),
                    const SizedBox(height: 22),
                    _contentSection(),
                    const SizedBox(height: 18),
                    _urlSection(),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: DCol.panel,
                        border: Border.all(color: DCol.line, width: 1.5),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('// LEMBRE',
                              style: DFont.pixel(size: 8, color: DCol.acid)),
                          const SizedBox(height: 6),
                          Text(
                            'Você é responsável pelo que publica. A IA classifica e formata, mas não checa veracidade — anexe fontes confiáveis.',
                            style:
                                DFont.mono(size: 10, color: DCol.inkDim, height: 1.55),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: DCol.bg,
                  border: Border(top: BorderSide(color: DCol.line, width: 1.5)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _text.text.trim().isNotEmpty
                            ? 'PRONTO PRA ANALISAR'
                            : '↓ COLE O CONTEÚDO ↑',
                        style: DFont.pixel(size: 8, color: DCol.inkMute, letterSpacing: 1),
                      ),
                    ),
                    Btn(
                      label: 'ANALISAR COM IA →',
                      color: _text.text.trim().isNotEmpty ? DCol.magenta : DCol.line,
                      fg: _text.text.trim().isNotEmpty ? Colors.white : DCol.inkMute,
                      disabled: _text.text.trim().isEmpty,
                      onPressed: _startAnalysis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          AnalysisOverlay(
            phase: _phase == _Phase.analyzing
                ? AnalysisPhase.analyzing
                : AnalysisPhase.idle,
            currentPhase: _currentPhase,
            inputText: _text.text,
          ),
        ],
      ),
    );
  }

  Widget _scopeRow(_NPScope s, AppState app) {
    final on = _scope == s.id;
    return GestureDetector(
      onTap: () => setState(() => _scope = s.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: on ? DCol.panelHi : Colors.transparent,
          border: Border.all(color: on ? s.color : DCol.line, width: 1.5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: on ? s.color : DCol.panel,
                border: Border.all(color: on ? s.color : DCol.line, width: 1.5),
              ),
              child: Text(s.glyph,
                  style: DFont.pixel(
                      size: 14, color: on ? Colors.black : DCol.inkDim)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.label,
                      style: DFont.pixel(
                          size: 10, color: on ? s.color : DCol.ink, letterSpacing: 1.5)),
                  const SizedBox(height: 2),
                  Text(
                    '${s.sub} ${s.id == TopicScope.mun ? '· ${app.user.city == 'SP' ? 'São Paulo / SP' : app.user.city}' : ''}',
                    style: DFont.mono(size: 10, color: DCol.inkMute),
                  ),
                ],
              ),
            ),
            if (on) Text('●', style: DFont.pixel(size: 12, color: s.color)),
          ],
        ),
      ),
    );
  }

  Widget _contentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(
              child: Text('// CONTEÚDO DA NOTÍCIA',
                  style:
                      DFont.pixel(size: 9, color: DCol.inkMute, letterSpacing: 1.5)),
            ),
            Text('${_text.text.length}/2000',
                style: DFont.mono(size: 9, color: DCol.inkMute)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: DCol.line, width: 1.5),
          ),
          child: TextField(
            controller: _text,
            maxLines: 7,
            maxLength: 2000,
            onChanged: (_) => setState(() {}),
            style: DFont.body(size: 13, color: DCol.ink, height: 1.55),
            decoration: InputDecoration(
              border: InputBorder.none,
              counter: const SizedBox.shrink(),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              hintText:
                  'cole o texto da notícia, descreva o problema, ou conte o que tá acontecendo na sua quebrada...',
              hintStyle: DFont.body(size: 13, color: DCol.inkMute, height: 1.4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _urlSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('// FONTE (URL, opcional)',
            style: DFont.pixel(size: 9, color: DCol.inkMute, letterSpacing: 1.5)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: DCol.line, width: 1.5),
          ),
          child: TextField(
            controller: _url,
            style: DFont.mono(size: 12, color: DCol.acid),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              hintText: 'https://g1.globo.com/...',
              hintStyle: DFont.mono(size: 12, color: DCol.inkMute),
            ),
          ),
        ),
      ],
    );
  }

  Widget _previewView(AppState app, AnalysisResult r) {
    final scopeInfo = _scopes.firstWhere((s) => s.id == _scope);
    return Container(
      color: DCol.bg,
      child: Column(
        children: [
          Container(
            decoration:
                const BoxDecoration(border: Border(bottom: BorderSide(color: DCol.line))),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _regenerate,
                  child: Text('← REFAZER',
                      style: DFont.pixel(size: 11, color: DCol.ink)),
                ),
                const Spacer(),
                PixelChip('IA · ${r.confidence}% CONFIANÇA',
                    color: DCol.acid, size: 8),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
              children: [
                PixelChip('PRÉVIA DA PAUTA', color: r.color),
                const SizedBox(height: 12),
                StencilTwoLine(
                    first: 'ASSIM VAI',
                    second: 'APARECER',
                    secondColor: r.color,
                    size: 30,
                    height: 1.05),
                const SizedBox(height: 18),
                Container(
                  decoration: BoxDecoration(
                    color: DCol.panel,
                    border: Border.all(color: DCol.line, width: 1.5),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          PixelChip(r.theme, color: r.color, size: 7),
                          PixelChip(scopeInfo.label, color: DCol.acid, size: 7),
                          const PixelChip('● AO VIVO · agora',
                              color: DCol.inkMute, size: 7),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(r.title,
                          style: DFont.body(
                              size: 14,
                              color: DCol.ink,
                              weight: FontWeight.w700,
                              height: 1.3)),
                      const SizedBox(height: 8),
                      Text(r.desc,
                          style: DFont.body(
                              size: 12.5, color: DCol.inkDim, height: 1.55)),
                      if (_url.text.trim().isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text('↗ ${_url.text}',
                            style: DFont.mono(size: 10, color: DCol.acid)),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Avatar(seed: app.user.seed, size: 22),
                          const SizedBox(width: 8),
                          Text('${app.user.pseudonym} · agora',
                              style: DFont.mono(size: 10, color: DCol.inkDim)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Text('// AUTORIDADES IDENTIFICADAS PELA IA',
                    style: DFont.pixel(
                        size: 9, color: DCol.magenta, letterSpacing: 1.2)),
                ...r.authorities.map(
                  (a) => Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: DCol.line)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(a.role,
                            style: DFont.pixel(
                                size: 7, color: DCol.inkMute, letterSpacing: 1)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(a.name,
                                style: DFont.body(
                                    size: 13,
                                    color: DCol.ink,
                                    weight: FontWeight.w600)),
                            const SizedBox(width: 8),
                            Text(a.handle,
                                style: DFont.mono(size: 10, color: DCol.acid)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  decoration: BoxDecoration(
                    color: DCol.panel,
                    border: Border.all(color: DCol.acid, width: 1.5),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('// NOTA',
                          style: DFont.pixel(size: 9, color: DCol.acid)),
                      const SizedBox(height: 6),
                      Text(
                        'A IA classificou esta pauta automaticamente. Revise antes de publicar — você é responsável pelo conteúdo.',
                        style:
                            DFont.mono(size: 10, color: DCol.inkDim, height: 1.55),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: DCol.bg,
              border: Border(top: BorderSide(color: DCol.line, width: 1.5)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                GhostBtn(label: '↻ REFAZER', color: DCol.inkDim, onPressed: _regenerate),
                const Spacer(),
                Btn(
                  label: 'PUBLICAR ✓',
                  color: r.color,
                  onPressed: () => _publish(app),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

AnalysisResult _analyzeText(String text, TopicScope scope) {
  final lower = text.toLowerCase();
  var theme = 'POLÍTICA';
  var color = DCol.magenta;
  if (RegExp(r'metr[ôo]|[ôo]nibus|trans|mobil|rua|via|tr[áa]fego|congestion|cicl').hasMatch(lower)) {
    theme = 'TRANSPORTE';
    color = DCol.magenta;
  } else if (RegExp(r'saud|hospital|ubs|posto|m[ée]dic|sus|vacin|pediat|enferm').hasMatch(lower)) {
    theme = 'SAÚDE';
    color = DCol.alert;
  } else if (RegExp(r'escol|educa|merenda|professor|aluno|creche|universid').hasMatch(lower)) {
    theme = 'EDUCAÇÃO';
    color = DCol.magenta;
  } else if (RegExp(r'or[çc]ament|gasto|verba|licit|contrat|aditiv|caixa|impost').hasMatch(lower)) {
    theme = 'ORÇAMENTO';
    color = DCol.acid;
  } else if (RegExp(r'ambient|polui|reciclag|lixo|enchente|desmat|verde|parque').hasMatch(lower)) {
    theme = 'MEIO AMBIENTE';
    color = DCol.acid;
  } else if (RegExp(r'cultur|museu|teatro|biblio|arte|festiv').hasMatch(lower)) {
    theme = 'CULTURA';
    color = DCol.magenta;
  } else if (RegExp(r'pol[íi]cia|seguran[çc]|crime|viol[êe]ncia|assalt').hasMatch(lower)) {
    theme = 'SEGURANÇA';
    color = DCol.danger;
  } else if (RegExp(r'morad|habita|favel|cortic|despej').hasMatch(lower)) {
    theme = 'MORADIA';
    color = DCol.alert;
  } else if (RegExp(r'corrup|propin|desvi|fraud|escândal').hasMatch(lower)) {
    theme = 'CORRUPÇÃO';
    color = DCol.danger;
  }

  final firstSentence = text.split(RegExp(r'[.!?\n]')).first.trim();
  final title = firstSentence.length > 12
      ? '${firstSentence[0].toUpperCase()}${firstSentence.substring(1, firstSentence.length > 110 ? 110 : firstSentence.length)}'
      : 'Nova pauta de ${theme.toLowerCase()} levantada por cidadão';

  final trim = text.replaceAll(RegExp(r'\s+'), ' ').trim();
  final desc = trim.length > 280 ? '${trim.substring(0, 280).trim()} ...' : trim;

  final authorities = {
    TopicScope.mun: const [
      Authority(role: 'PREFEITO', name: 'Prefeitura de São Paulo', handle: '@prefsp'),
      Authority(role: 'CÂMARA MUNICIPAL', name: 'CMSP — vereadores', handle: '@cmsp_oficial'),
    ],
    TopicScope.est: const [
      Authority(role: 'GOVERNADOR', name: 'Governo do Estado de SP', handle: '@governosp'),
      Authority(role: 'ASSEMBLEIA', name: 'ALESP', handle: '@alesp_oficial'),
    ],
    TopicScope.fed: const [
      Authority(role: 'PRESIDÊNCIA', name: 'Planalto', handle: '@planalto'),
      Authority(role: 'CÂMARA', name: 'Câmara dos Deputados', handle: '@camaradeputados'),
      Authority(role: 'SENADO', name: 'Senado Federal', handle: '@senadofederal'),
    ],
  }[scope]!;

  final confidence = 78 + (text.length % 18);
  return AnalysisResult(
    theme: theme,
    color: color,
    title: title,
    desc: desc,
    authorities: authorities,
    confidence: confidence,
  );
}
