import 'dart:async';

import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../design/colors.dart';
import '../design/fonts.dart';
import '../widgets/atoms.dart';
import '../widgets/utils.dart';

class GenerateScreen extends StatefulWidget {
  const GenerateScreen({super.key});
  @override
  State<GenerateScreen> createState() => _GenerateScreenState();
}

class _Tone {
  const _Tone({required this.id, required this.color, required this.desc});
  final String id;
  final Color color;
  final String desc;
}

const _tones = <_Tone>[
  _Tone(id: 'FORMAL', color: DCol.acid, desc: 'institucional, respeitoso'),
  _Tone(id: 'MOBILIZADORA', color: DCol.magenta, desc: 'engajada, chama à ação'),
  _Tone(id: 'IRÔNICA', color: DCol.alert, desc: 'sarcasmo cívico'),
  _Tone(id: 'TÉCNICA', color: DCol.sources, desc: 'fria, com números'),
  _Tone(id: 'POÉTICA', color: DCol.acidD, desc: 'literária, evocativa'),
];

class _Tag {
  const _Tag({required this.id, required this.glyph});
  final String id;
  final String glyph;
}

const _tags = <_Tag>[
  _Tag(id: 'URGÊNCIA', glyph: '⚡'),
  _Tag(id: 'DADOS', glyph: '📊'),
  _Tag(id: 'TRANSPARÊNCIA', glyph: '🔍'),
  _Tag(id: 'PRESSÃO', glyph: '🎯'),
  _Tag(id: 'HISTÓRICO', glyph: '📜'),
  _Tag(id: 'PESSOAL', glyph: '🙋'),
  _Tag(id: 'CITAÇÃO LEI', glyph: '⚖'),
  _Tag(id: 'COMPARAÇÃO', glyph: '↔'),
];

String _buildMessage(String tone, Set<String> tags) {
  final intro = {
        'FORMAL': 'Prezado Prefeito Ricardo Nunes,',
        'MOBILIZADORA': 'Prefeito Ricardo Nunes,',
        'IRÔNICA': 'Curiosidade pública:',
        'TÉCNICA': 'Sr. Prefeito,',
        'POÉTICA': 'Senhor Prefeito,',
      }[tone] ??
      'Prezado Prefeito,';
  final parts = <String>[intro];
  if (tags.contains('URGÊNCIA')) parts.add('a Linha 17-Ouro do metrô está atrasada há 14 anos e sem prazo realista.');
  if (tags.contains('HISTÓRICO')) parts.add('A obra foi licitada em 2011 com previsão para a Copa de 2014.');
  if (tags.contains('DADOS')) parts.add('O custo passou de R\$ 1,6 bi para R\$ 4,8 bi — alta de 200%.');
  if (tags.contains('TRANSPARÊNCIA')) parts.add('Exigimos publicação integral dos aditivos contratuais já assinados.');
  if (tags.contains('COMPARAÇÃO')) parts.add('Cidades como Curitiba e Belo Horizonte entregaram corredores no mesmo período.');
  if (tags.contains('CITAÇÃO LEI')) parts.add('A Lei 12.527/2011 (LAI) garante acesso público a esses documentos.');
  if (tags.contains('PRESSÃO')) parts.add('Caso a Prefeitura não se manifeste, levaremos a denúncia ao TCE-SP.');
  if (tags.contains('PESSOAL')) parts.add('Como cidadão de São Paulo, sou diretamente impactado pelo atraso.');
  final closer = {
        'FORMAL': 'Aguardo manifestação oficial. Atenciosamente,',
        'MOBILIZADORA': 'Não dá mais pra empurrar pra próxima gestão. Vamos cobrar.',
        'IRÔNICA': 'A esse ritmo, o metrô fica pronto antes do próximo eclipse. 🚇⏳',
        'TÉCNICA': 'Solicito resposta formal em até 20 dias úteis.',
        'POÉTICA': 'A cidade que não anda é a cidade que esquece de seus.',
      }[tone] ??
      'Atenciosamente.';
  parts.add(closer);
  return parts.join(' ');
}

enum _Phase { compose, working, done }

class _GenerateScreenState extends State<GenerateScreen> {
  final Set<String> _selectedTags = {'URGÊNCIA', 'DADOS'};
  String _tone = 'MOBILIZADORA';
  _Phase _phase = _Phase.compose;
  int _streamLen = 0;
  String _generated = '';
  Timer? _streamTimer;

  bool get _canGenerate => _selectedTags.isNotEmpty;
  _Tone get _selectedTone => _tones.firstWhere((t) => t.id == _tone, orElse: () => _tones[0]);

  void _start() {
    if (_selectedTags.isEmpty) return;
    setState(() {
      _generated = _buildMessage(_tone, _selectedTags);
      _streamLen = 0;
      _phase = _Phase.working;
    });
    _streamTimer?.cancel();
    _streamTimer = Timer.periodic(const Duration(milliseconds: 35), (t) {
      setState(() {
        _streamLen += 6;
        if (_streamLen >= _generated.length) {
          _streamLen = _generated.length;
          _phase = _Phase.done;
          t.cancel();
        }
      });
    });
  }

  void _regenerate() {
    _streamTimer?.cancel();
    setState(() {
      _phase = _Phase.compose;
      _streamLen = 0;
    });
  }

  @override
  void dispose() {
    _streamTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return Container(
      color: DCol.bg,
      child: Column(
        children: [
          BackHeader(
            onBack: () => _phase == _Phase.compose ? app.go(Screen.detail) : _regenerate(),
            right: PixelChip(
              _phase == _Phase.compose
                  ? 'COMPOR'
                  : _phase == _Phase.working
                      ? 'LLM_LOCAL · 12 tok/s'
                      : 'LLM_LOCAL · OK',
              color: DCol.acid,
              size: 8,
            ),
          ),
          if (_phase == _Phase.compose) ..._compose(app),
          if (_phase == _Phase.working) Expanded(child: _working()),
          if (_phase == _Phase.done) ..._done(app),
        ],
      ),
    );
  }

  List<Widget> _compose(AppState app) {
    final tone = _selectedTone;
    return [
      Expanded(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
          children: [
            const PixelChip('// COMPOR MENSAGEM', color: DCol.magenta),
            const SizedBox(height: 10),
            const StencilTwoLine(first: 'COBRAR', second: 'O PREFEITO', size: 32, height: 0.95),
            const SizedBox(height: 14),
            Container(
              decoration: BoxDecoration(
                color: DCol.panel,
                border: Border.all(color: DCol.line, width: 1.5),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  const Text('🚇', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('SOBRE A PAUTA',
                            style: DFont.pixel(
                                size: 7, color: DCol.inkMute, letterSpacing: 1)),
                        const SizedBox(height: 2),
                        Text('Linha 17-Ouro: 14 anos de atraso, custo triplicado',
                            style: DFont.body(size: 12, color: DCol.ink, height: 1.3)),
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
                Expanded(
                  child: Text('// TOM · escolha 1',
                      style:
                          DFont.pixel(size: 9, color: DCol.inkMute, letterSpacing: 1.5)),
                ),
                Text(tone.id, style: DFont.mono(size: 10, color: DCol.acid)),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _tones.map((t) {
                final on = _tone == t.id;
                return GestureDetector(
                  onTap: () => setState(() => _tone = t.id),
                  child: Container(
                    decoration: BoxDecoration(
                      color: on ? t.color : Colors.transparent,
                      border: Border.all(color: on ? t.color : DCol.line, width: 1.5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Text(t.id,
                        style: DFont.pixel(
                            size: 9,
                            color: on ? Colors.black : DCol.ink,
                            letterSpacing: 1)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 6),
            Text('// ${tone.desc}', style: DFont.mono(size: 10, color: DCol.inkDim)),
            const SizedBox(height: 22),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(
                  child: Text('// ARGUMENTOS · escolha quantos quiser',
                      style: DFont.pixel(
                          size: 9, color: DCol.inkMute, letterSpacing: 1.5)),
                ),
                Text('${_selectedTags.length} marcados',
                    style: DFont.mono(size: 10, color: DCol.acid)),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _tags.map((t) {
                final on = _selectedTags.contains(t.id);
                return GestureDetector(
                  onTap: () => setState(() {
                    on ? _selectedTags.remove(t.id) : _selectedTags.add(t.id);
                  }),
                  child: Container(
                    decoration: BoxDecoration(
                      color: on ? DCol.acid : Colors.transparent,
                      border: Border.all(color: on ? DCol.acid : DCol.line, width: 1.5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(t.glyph, style: const TextStyle(fontSize: 12)),
                        const SizedBox(width: 5),
                        Text(t.id,
                            style: DFont.pixel(
                                size: 9,
                                color: on ? Colors.black : DCol.ink,
                                letterSpacing: 0.8)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            if (_selectedTags.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text('// selecione pelo menos 1 argumento.',
                    style: DFont.mono(size: 10, color: DCol.danger)),
              ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: DCol.panel,
                border: Border.all(color: DCol.line, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('// COMO FUNCIONA',
                      style: DFont.pixel(size: 9, color: DCol.acid)),
                  const SizedBox(height: 6),
                  Text(
                    'A IA local junta o tom + os argumentos selecionados e escreve UMA mensagem só pra você revisar.',
                    style: DFont.mono(size: 10, color: DCol.inkDim, height: 1.55),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      StickyFooter(
        children: [
          Expanded(
            child: Text(
              _canGenerate ? 'PRONTO PRA GERAR' : '↑ ESCOLHA OS ARGUMENTOS',
              style: DFont.pixel(size: 8, color: DCol.inkMute, letterSpacing: 1),
            ),
          ),
          Btn(
            label: 'GERAR →',
            color: _canGenerate ? tone.color : DCol.line,
            fg: _canGenerate ? Colors.black : DCol.inkMute,
            disabled: !_canGenerate,
            onPressed: _canGenerate ? _start : null,
          ),
        ],
      ),
    ];
  }

  Widget _working() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: DCol.panel,
              border: Border.all(color: DCol.line, width: 1.5),
            ),
            child: Stack(
              children: [
                const Positioned.fill(child: Scanlines(opacity: 0.15)),
                const Center(child: _Radar()),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Text('// GERANDO_MENSAGEM.exe',
                      style: DFont.pixel(size: 9, color: DCol.acid)),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Text('gemma-3-1b-it · q4',
                      style: DFont.mono(size: 10, color: DCol.inkDim)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              PixelChip('TOM · $_tone', color: _selectedTone.color, size: 8),
              ..._selectedTags.map((t) => Container(
                    color: DCol.acid,
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: Text(t,
                        style: DFont.pixel(
                            size: 8, color: Colors.black, letterSpacing: 0.5)),
                  )),
            ],
          ),
          const SizedBox(height: 16),
          Text.rich(
            TextSpan(children: [
              TextSpan(text: _generated.substring(0, _streamLen)),
              TextSpan(text: '▮', style: DFont.mono(size: 12, color: DCol.acid)),
            ], style: DFont.mono(size: 12, color: DCol.ink, height: 1.55)),
          ),
        ],
      ),
    );
  }

  List<Widget> _done(AppState app) {
    final tone = _selectedTone;
    return [
      Expanded(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
          children: [
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                PixelChip('TOM · $_tone', color: tone.color, size: 8),
                ..._selectedTags.map((t) => Container(
                      color: DCol.acid,
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: Text(t,
                          style: DFont.pixel(
                              size: 8, color: Colors.black, letterSpacing: 0.5)),
                    )),
              ],
            ),
            const SizedBox(height: 12),
            StencilTwoLine(first: 'MENSAGEM', second: 'PRONTA', secondColor: tone.color, size: 22, height: 1),
            const SizedBox(height: 14),
            Container(
              decoration: BoxDecoration(
                color: DCol.panel,
                border: Border.all(color: tone.color, width: 2),
                boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
              ),
              padding: const EdgeInsets.all(16),
              child: Text(_generated,
                  style: DFont.body(size: 13.5, color: DCol.ink, height: 1.55)),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                    child: GhostBtn(
                        label: '↻ REFAZER', full: true, color: DCol.inkDim, onPressed: _regenerate)),
                const SizedBox(width: 8),
                const Expanded(child: GhostBtn(label: '✎ EDITAR', full: true, color: DCol.inkDim)),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: DCol.panel,
                border: Border.all(color: DCol.line),
              ),
              child: Text(
                '// sua revisão importa. você sempre pode reescrever antes de postar.',
                style: DFont.mono(size: 10, color: DCol.inkDim, height: 1.5),
              ),
            ),
          ],
        ),
      ),
      StickyFooter(
        children: [
          Expanded(
            child: Btn(
              label: 'USAR ESTA → CANAIS',
              full: true,
              color: tone.color,
              onPressed: () => app.go(Screen.channels),
            ),
          ),
        ],
      ),
    ];
  }
}

class _Radar extends StatefulWidget {
  const _Radar();
  @override
  State<_Radar> createState() => _RadarState();
}

class _RadarState extends State<_Radar> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400))
      ..repeat();
  }

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
        angle: _c.value * 6.2831,
        child: Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: DCol.acid, width: 2),
            boxShadow: [BoxShadow(color: DCol.acid.withValues(alpha: 0.5), blurRadius: 30)],
          ),
        ),
      ),
    );
  }
}
