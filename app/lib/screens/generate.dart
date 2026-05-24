import 'dart:async';

import 'package:flutter/material.dart';

import '../app/app_scope.dart';
import '../app/app_state.dart';
import '../theme/colors.dart';
import '../theme/fonts.dart';
import '../widgets/atoms/buttons.dart';
import '../widgets/atoms/effects.dart';
import '../widgets/atoms/text_atoms.dart';
import '../widgets/utils/layout.dart';

class _Tone {
  final String id;
  final Color color;
  final String desc;
  const _Tone(this.id, this.color, this.desc);
}

const _kTones = <_Tone>[
  _Tone('FORMAL', COL.acid, 'institucional, respeitoso'),
  _Tone('MOBILIZADORA', COL.magenta, 'engajada, chama à ação'),
  _Tone('IRÔNICA', COL.alert, 'sarcasmo cívico'),
  _Tone('TÉCNICA', COL.blue, 'fria, com números'),
  _Tone('POÉTICA', COL.acidD, 'literária, evocativa'),
];

const _kTags = <List<String>>[
  ['URGÊNCIA', '⚡'],
  ['DADOS', '📊'],
  ['TRANSPARÊNCIA', '🔍'],
  ['PRESSÃO', '🎯'],
  ['HISTÓRICO', '📜'],
  ['PESSOAL', '🙋'],
  ['CITAÇÃO LEI', '⚖'],
  ['COMPARAÇÃO', '↔'],
];

String _buildMessage(String tone, Set<String> tags) {
  final intro = const {
    'FORMAL': 'Prezado Prefeito Ricardo Nunes,',
    'MOBILIZADORA': 'Prefeito Ricardo Nunes,',
    'IRÔNICA': 'Curiosidade pública:',
    'TÉCNICA': 'Sr. Prefeito,',
    'POÉTICA': 'Senhor Prefeito,',
  }[tone] ?? 'Prezado Prefeito,';

  final parts = [intro];
  bool has(String k) => tags.contains(k);
  if (has('URGÊNCIA')) parts.add('a Linha 17-Ouro do metrô está atrasada há 14 anos e sem prazo realista.');
  if (has('HISTÓRICO')) parts.add('A obra foi licitada em 2011 com previsão para a Copa de 2014.');
  if (has('DADOS')) parts.add('O custo passou de R\$ 1,6 bi para R\$ 4,8 bi — alta de 200%.');
  if (has('TRANSPARÊNCIA')) parts.add('Exigimos publicação integral dos aditivos contratuais já assinados.');
  if (has('COMPARAÇÃO')) parts.add('Cidades como Curitiba e Belo Horizonte entregaram corredores no mesmo período.');
  if (has('CITAÇÃO LEI')) parts.add('A Lei 12.527/2011 (LAI) garante acesso público a esses documentos.');
  if (has('PRESSÃO')) parts.add('Caso a Prefeitura não se manifeste, levaremos a denúncia ao TCE-SP.');
  if (has('PESSOAL')) parts.add('Como cidadão de São Paulo, sou diretamente impactado pelo atraso.');
  final closer = const {
    'FORMAL': 'Aguardo manifestação oficial. Atenciosamente,',
    'MOBILIZADORA': 'Não dá mais pra empurrar pra próxima gestão. Vamos cobrar.',
    'IRÔNICA': 'A esse ritmo, o metrô fica pronto antes do próximo eclipse. 🚇⏳',
    'TÉCNICA': 'Solicito resposta formal em até 20 dias úteis.',
    'POÉTICA': 'A cidade que não anda é a cidade que esquece de seus.',
  }[tone] ?? 'Atenciosamente.';
  parts.add(closer);
  return parts.join(' ');
}

enum _Phase { compose, working, done }

class GenerateScreen extends StatefulWidget {
  const GenerateScreen({super.key});
  @override
  State<GenerateScreen> createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {
  final Set<String> _tags = {'URGÊNCIA', 'DADOS'};
  String _tone = 'MOBILIZADORA';
  _Phase _phase = _Phase.compose;
  int _streamLen = 0;
  Timer? _streamTimer;

  _Tone get _selectedTone => _kTones.firstWhere((t) => t.id == _tone, orElse: () => _kTones[0]);
  String get _generated => _buildMessage(_tone, _tags);
  bool get _canGenerate => _tags.isNotEmpty;

  @override
  void dispose() {
    _streamTimer?.cancel();
    super.dispose();
  }

  void _start() {
    if (!_canGenerate) return;
    setState(() {
      _streamLen = 0;
      _phase = _Phase.working;
    });
    _streamTimer?.cancel();
    _streamTimer = Timer.periodic(const Duration(milliseconds: 35), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _streamLen = _streamLen + 6;
        if (_streamLen >= _generated.length) {
          _streamLen = _generated.length;
          _phase = _Phase.done;
          timer.cancel();
        }
      });
    });
  }

  void _regenerate() {
    _streamTimer?.cancel();
    setState(() {
      _streamLen = 0;
      _phase = _Phase.compose;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.read(context);
    final chipLabel = _phase == _Phase.compose
        ? 'COMPOR'
        : _phase == _Phase.working
            ? 'LLM_LOCAL · 12 tok/s'
            : 'LLM_LOCAL · OK';
    return Container(
      color: COL.bg,
      child: Column(
        children: [
          BackHeader(
            onBack: () => _phase == _Phase.compose ? state.go(AppRoute.detail) : _regenerate(),
            trailing: PixelChip(chipLabel, color: COL.acid, size: 8),
          ),
          if (_phase == _Phase.compose) _compose(state) else if (_phase == _Phase.working) _working() else _done(state),
        ],
      ),
    );
  }

  Widget _compose(AppState state) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PixelChip('// COMPOR MENSAGEM', color: COL.magenta),
                  const SizedBox(height: 10),
                  const StencilSpans(
                    spans: [
                      TextSpan(text: 'COBRAR\n'),
                      TextSpan(text: 'O PREFEITO', style: TextStyle(color: COL.magenta)),
                    ],
                    size: 32,
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: COL.panel,
                      border: Border.all(color: COL.line, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        const Text('🚇', style: TextStyle(fontSize: 22)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('SOBRE A PAUTA',
                                  style: FONT.pixel(size: 7, color: COL.inkMute, letterSpacing: 1)),
                              const SizedBox(height: 2),
                              Text('Linha 17-Ouro: 14 anos de atraso, custo triplicado',
                                  style: FONT.body(size: 12, height: 1.3)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('// TOM · escolha 1',
                          style: FONT.pixel(size: 9, color: COL.inkMute, letterSpacing: 1.5)),
                      const Spacer(),
                      Text(_selectedTone.id, style: FONT.mono(size: 10, color: COL.acid)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final t in _kTones)
                        GestureDetector(
                          onTap: () => setState(() => _tone = t.id),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: _tone == t.id ? t.color : Colors.transparent,
                              border: Border.all(
                                color: _tone == t.id ? t.color : COL.line,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              t.id,
                              style: FONT.pixel(
                                size: 9,
                                color: _tone == t.id ? Colors.black : COL.ink,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('// ${_selectedTone.desc}',
                      style: FONT.mono(size: 10, color: COL.inkDim)),
                  const SizedBox(height: 22),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('// ARGUMENTOS · escolha quantos quiser',
                          style: FONT.pixel(size: 9, color: COL.inkMute, letterSpacing: 1.5)),
                      const Spacer(),
                      Text('${_tags.length} marcados',
                          style: FONT.mono(size: 10, color: COL.acid)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final t in _kTags)
                        GestureDetector(
                          onTap: () => setState(() {
                            _tags.contains(t[0]) ? _tags.remove(t[0]) : _tags.add(t[0]);
                          }),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: _tags.contains(t[0]) ? COL.acid : Colors.transparent,
                              border: Border.all(
                                color: _tags.contains(t[0]) ? COL.acid : COL.line,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(t[1], style: const TextStyle(fontSize: 12)),
                                const SizedBox(width: 5),
                                Text(
                                  t[0],
                                  style: FONT.pixel(
                                    size: 9,
                                    color: _tags.contains(t[0]) ? Colors.black : COL.ink,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (_tags.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text('// selecione pelo menos 1 argumento.',
                          style: FONT.mono(size: 10, color: COL.danger)),
                    ),
                  const SizedBox(height: 22),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: COL.panel,
                      border: Border.all(color: COL.line, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('// COMO FUNCIONA',
                            style: FONT.pixel(size: 9, color: COL.acid)),
                        const SizedBox(height: 4),
                        Text(
                          'A IA local junta o tom + os argumentos selecionados e escreve UMA mensagem só pra você revisar.',
                          style: FONT.mono(size: 10, color: COL.inkDim, height: 1.55),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          StickyFooter(
            children: [
              Text(_canGenerate ? 'PRONTO PRA GERAR' : '↑ ESCOLHA OS ARGUMENTOS',
                  style: FONT.pixel(size: 8, color: COL.inkMute, letterSpacing: 1)),
              const Spacer(),
              Btn(
                color: _canGenerate ? _selectedTone.color : COL.line,
                fg: _canGenerate ? Colors.black : COL.inkMute,
                onPressed: _canGenerate ? _start : null,
                disabled: !_canGenerate,
                child: const Text('GERAR →'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _working() {
    final streamingText = _generated.substring(0, _streamLen.clamp(0, _generated.length));
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: COL.panel,
                border: Border.all(color: COL.line, width: 1.5),
              ),
              child: const Stack(
                children: [
                  Center(child: _RadarSpin()),
                  Scanlines(opacity: 0.15),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                PixelChip('TOM · $_tone', color: _selectedTone.color, size: 8),
                for (final t in _tags)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    color: COL.acid,
                    child: Text(t,
                        style: FONT.pixel(size: 8, color: Colors.black, letterSpacing: 0.5)),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text.rich(
              TextSpan(children: [
                TextSpan(text: streamingText),
                const TextSpan(text: '▮', style: TextStyle(color: COL.acid)),
              ], style: FONT.mono(size: 12, color: COL.ink, height: 1.55)),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _done(AppState state) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      PixelChip('TOM · $_tone', color: _selectedTone.color, size: 8),
                      for (final t in _tags)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          color: COL.acid,
                          child: Text(t,
                              style: FONT.pixel(size: 8, color: Colors.black, letterSpacing: 0.5)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  StencilSpans(
                    spans: [
                      const TextSpan(text: 'MENSAGEM\n'),
                      TextSpan(
                        text: 'PRONTA',
                        style: TextStyle(color: _selectedTone.color),
                      ),
                    ],
                    size: 22,
                    height: 1,
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: COL.panel,
                      border: Border.all(color: _selectedTone.color, width: 2),
                      boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                    ),
                    child: Text(_generated,
                        style: FONT.body(size: 13.5, color: COL.ink, height: 1.55)),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: GhostBtn(
                          full: true,
                          color: COL.inkDim,
                          onPressed: _regenerate,
                          child: const Text('↻ REFAZER'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: GhostBtn(full: true, color: COL.inkDim, child: Text('✎ EDITAR')),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: COL.panel,
                      border: Border.all(color: COL.line),
                    ),
                    child: Text(
                      '// sua revisão importa. você sempre pode reescrever antes de postar.',
                      style: FONT.mono(size: 10, color: COL.inkDim, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          StickyFooter(
            children: [
              Expanded(
                child: Btn(
                  full: true,
                  color: _selectedTone.color,
                  onPressed: () => state.go(AppRoute.channels),
                  child: const Text('USAR ESTA → CANAIS'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RadarSpin extends StatefulWidget {
  const _RadarSpin();
  @override
  State<_RadarSpin> createState() => _RadarSpinState();
}

class _RadarSpinState extends State<_RadarSpin> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) => Transform.rotate(
        angle: _c.value * 6.28318,
        child: Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: COL.acid, width: 2),
            boxShadow: [BoxShadow(color: COL.acid, blurRadius: 30)],
          ),
        ),
      ),
    );
  }
}
