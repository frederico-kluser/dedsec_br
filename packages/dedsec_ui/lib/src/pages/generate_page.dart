import 'dart:async';
import 'package:flutter/material.dart';
import '../atoms/btn.dart';
import '../atoms/dashed_box.dart';
import '../atoms/ghost_btn.dart';
import '../atoms/pixel_chip.dart';
import '../atoms/scanlines.dart';
import '../atoms/stencil.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';
import '../widgets/back_header.dart';
import '../widgets/screen_root.dart';
import '../widgets/sticky_footer.dart';
import 'route.dart';

class _Tone {
  final String id;
  final Color color;
  final String desc;
  const _Tone(this.id, this.color, this.desc);
}

const _tones = <_Tone>[
  _Tone('FORMAL', DedsecColors.acid, 'institucional, respeitoso'),
  _Tone('MOBILIZADORA', DedsecColors.magenta, 'engajada, chama à ação'),
  _Tone('IRÔNICA', DedsecColors.alert, 'sarcasmo cívico'),
  _Tone('TÉCNICA', DedsecColors.skyBlue, 'fria, com números'),
  _Tone('POÉTICA', DedsecColors.acidD, 'literária, evocativa'),
];

class _Tag {
  final String id;
  final String glyph;
  const _Tag(this.id, this.glyph);
}

const _allTags = <_Tag>[
  _Tag('URGÊNCIA', '⚡'),
  _Tag('DADOS', '📊'),
  _Tag('TRANSPARÊNCIA', '🔍'),
  _Tag('PRESSÃO', '🎯'),
  _Tag('HISTÓRICO', '📜'),
  _Tag('PESSOAL', '🙋'),
  _Tag('CITAÇÃO LEI', '⚖'),
  _Tag('COMPARAÇÃO', '↔'),
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

class GeneratePage extends StatefulWidget {
  final ValueChanged<DedsecScreen> onGo;
  const GeneratePage({super.key, required this.onGo});

  @override
  State<GeneratePage> createState() => _GeneratePageState();
}

class _GeneratePageState extends State<GeneratePage> with SingleTickerProviderStateMixin {
  Set<String> _tags = {'URGÊNCIA', 'DADOS'};
  String _tone = 'MOBILIZADORA';
  _Phase _phase = _Phase.compose;
  int _streamLen = 0;
  Timer? _streamTimer;
  late final AnimationController _radar = AnimationController(
    vsync: this, duration: const Duration(milliseconds: 2400),
  )..repeat();

  @override
  void dispose() {
    _streamTimer?.cancel();
    _radar.dispose();
    super.dispose();
  }

  String get _generatedText => _buildMessage(_tone, _tags);
  bool get _canGenerate => _tags.isNotEmpty;
  _Tone get _selectedTone => _tones.firstWhere((t) => t.id == _tone, orElse: () => _tones.first);

  void _start() {
    if (!_canGenerate) return;
    setState(() {
      _phase = _Phase.working;
      _streamLen = 0;
    });
    _streamTimer?.cancel();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      _streamTimer = Timer.periodic(const Duration(milliseconds: 35), (t) {
        if (!mounted) {
          t.cancel();
          return;
        }
        setState(() {
          _streamLen += 6;
          if (_streamLen >= _generatedText.length) {
            _streamLen = _generatedText.length;
            _phase = _Phase.done;
            t.cancel();
          }
        });
      });
    });
  }

  void _regen() {
    _streamTimer?.cancel();
    setState(() {
      _phase = _Phase.compose;
      _streamLen = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenRoot(
      child: Column(children: [
        BackHeader(
          onBack: () => _phase == _Phase.compose ? widget.onGo(DedsecScreen.detail) : _regen(),
          trailing: PixelChip(
            switch (_phase) {
              _Phase.compose => 'COMPOR',
              _Phase.working => 'LLM_LOCAL · 12 tok/s',
              _Phase.done => 'LLM_LOCAL · OK',
            },
            color: DedsecColors.acid,
            size: 8,
          ),
        ),
        if (_phase == _Phase.compose) _compose() else if (_phase == _Phase.working) _working() else _done(),
      ]),
    );
  }

  Widget _compose() {
    final st = _selectedTone;
    return Expanded(
      child: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const PixelChip('// COMPOR MENSAGEM', color: DedsecColors.magenta),
              const SizedBox(height: 10),
              const StencilRich(size: 32, spans: [
                TextSpan(text: 'COBRAR\n'),
                TextSpan(text: 'O PREFEITO', style: TextStyle(color: DedsecColors.magenta)),
              ]),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: DedsecColors.panel,
                  border: Border.all(color: DedsecColors.line, width: 1.5),
                ),
                child: Row(children: [
                  const Text('🚇', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('SOBRE A PAUTA',
                          style: DedsecFonts.pixel(size: 7, color: DedsecColors.inkMute, letterSpacing: 1)),
                      const SizedBox(height: 2),
                      Text('Linha 17-Ouro: 14 anos de atraso, custo triplicado',
                          style: DedsecFonts.body(size: 12, color: DedsecColors.ink, height: 1.3)),
                    ]),
                  ),
                ]),
              ),
              const SizedBox(height: 22),
              Row(children: [
                Text('// TOM · escolha 1',
                    style: DedsecFonts.pixel(size: 9, color: DedsecColors.inkMute, letterSpacing: 1.5)),
                const Spacer(),
                Text(st.id, style: DedsecFonts.mono(size: 10, color: DedsecColors.acid)),
              ]),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8, children: [
                for (final t in _tones)
                  GestureDetector(
                    onTap: () => setState(() => _tone = t.id),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: _tone == t.id ? t.color : Colors.transparent,
                        border: Border.all(color: _tone == t.id ? t.color : DedsecColors.line, width: 1.5),
                      ),
                      child: Text(t.id,
                          style: DedsecFonts.pixel(
                            size: 9,
                            color: _tone == t.id ? Colors.black : DedsecColors.ink,
                            letterSpacing: 1,
                          )),
                    ),
                  ),
              ]),
              const SizedBox(height: 6),
              Text('// ${st.desc}',
                  style: DedsecFonts.mono(size: 10, color: DedsecColors.inkDim)),
              const SizedBox(height: 22),
              Row(children: [
                Text('// ARGUMENTOS · escolha quantos quiser',
                    style: DedsecFonts.pixel(size: 9, color: DedsecColors.inkMute, letterSpacing: 1.5)),
                const Spacer(),
                Text('${_tags.length} marcados',
                    style: DedsecFonts.mono(size: 10, color: DedsecColors.acid)),
              ]),
              const SizedBox(height: 8),
              Wrap(spacing: 6, runSpacing: 6, children: _allTagButtons()),
              if (_tags.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('// selecione pelo menos 1 argumento.',
                      style: DedsecFonts.mono(size: 10, color: DedsecColors.danger)),
                ),
              const SizedBox(height: 22),
              DashedBox(
                color: DedsecColors.line,
                strokeWidth: 1.5,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('// COMO FUNCIONA',
                        style: DedsecFonts.pixel(size: 9, color: DedsecColors.acid)),
                    const SizedBox(height: 6),
                    Text(
                      'A IA local junta o tom + os argumentos selecionados e escreve UMA mensagem só pra você revisar.',
                      style: DedsecFonts.mono(size: 10, color: DedsecColors.inkDim, letterSpacing: 0.4),
                    ),
                  ]),
                ),
              ),
            ]),
          ),
        ),
        StickyFooter(children: [
          Text(_canGenerate ? 'PRONTO PRA GERAR' : '↑ ESCOLHA OS ARGUMENTOS',
              style: DedsecFonts.pixel(size: 8, color: DedsecColors.inkMute, letterSpacing: 1)),
          const Spacer(),
          Btn(
            label: 'GERAR →',
            color: _canGenerate ? st.color : DedsecColors.line,
            fg: _canGenerate ? Colors.black : DedsecColors.inkMute,
            onPressed: _canGenerate ? _start : null,
            disabled: !_canGenerate,
          ),
        ]),
      ]),
    );
  }

  List<Widget> _allTagButtons() {
    return [
      for (final tg in _allTags)
        GestureDetector(
          onTap: () => setState(() {
            _tags.contains(tg.id) ? _tags.remove(tg.id) : _tags.add(tg.id);
          }),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: _tags.contains(tg.id) ? DedsecColors.acid : Colors.transparent,
              border: Border.all(
                color: _tags.contains(tg.id) ? DedsecColors.acid : DedsecColors.line,
                width: 1.5,
              ),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(tg.glyph, style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 5),
              Text(tg.id,
                  style: DedsecFonts.pixel(
                    size: 9,
                    color: _tags.contains(tg.id) ? Colors.black : DedsecColors.ink,
                    letterSpacing: 0.8,
                  )),
            ]),
          ),
        ),
    ];
  }

  Widget _working() {
    final st = _selectedTone;
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: DedsecColors.panel,
              border: Border.all(color: DedsecColors.line, width: 1.5),
            ),
            child: Stack(children: [
              Center(
                child: RotationTransition(
                  turns: _radar,
                  child: Container(
                    width: 90, height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: DedsecColors.acid, width: 2),
                      boxShadow: [BoxShadow(color: DedsecColors.acid.withOpacity(0.5), blurRadius: 30)],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10, left: 10,
                child: Text('// GERANDO_MENSAGEM.exe',
                    style: DedsecFonts.pixel(size: 9, color: DedsecColors.acid)),
              ),
              Positioned(
                bottom: 10, right: 10,
                child: Text('gemma-3-1b-it · q4',
                    style: DedsecFonts.mono(size: 10, color: DedsecColors.inkDim)),
              ),
              const Positioned.fill(child: IgnorePointer(child: Scanlines(opacity: 0.15))),
            ]),
          ),
          const SizedBox(height: 14),
          Wrap(spacing: 6, runSpacing: 6, children: [
            PixelChip('TOM · $_tone', color: st.color, size: 8),
            for (final t in _tags)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                color: DedsecColors.acid,
                child: Text(t,
                    style: DedsecFonts.pixel(size: 8, color: Colors.black, letterSpacing: 0.5)),
              ),
          ]),
          const SizedBox(height: 16),
          Container(
            constraints: const BoxConstraints(minHeight: 120),
            child: RichText(
              text: TextSpan(
                style: DedsecFonts.mono(size: 12, color: DedsecColors.ink, letterSpacing: 0.4),
                children: [
                  TextSpan(text: _generatedText.substring(0, _streamLen.clamp(0, _generatedText.length))),
                  const TextSpan(text: '▮', style: TextStyle(color: DedsecColors.acid)),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _done() {
    final st = _selectedTone;
    return Expanded(
      child: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Wrap(spacing: 6, runSpacing: 6, children: [
                PixelChip('TOM · $_tone', color: st.color, size: 8),
                for (final t in _tags)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    color: DedsecColors.acid,
                    child: Text(t,
                        style: DedsecFonts.pixel(size: 8, color: Colors.black, letterSpacing: 0.5)),
                  ),
              ]),
              const SizedBox(height: 12),
              StencilRich(
                size: 22,
                spans: [
                  const TextSpan(text: 'MENSAGEM\n'),
                  TextSpan(text: 'PRONTA', style: TextStyle(color: st.color)),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: DedsecColors.panel,
                  border: Border.all(color: st.color, width: 2),
                  boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                ),
                child: Text(_generatedText,
                    style: DedsecFonts.body(size: 13.5, height: 1.55, color: DedsecColors.ink)),
              ),
              const SizedBox(height: 14),
              Row(children: [
                Expanded(child: GhostBtn(label: '↻ REFAZER', color: DedsecColors.inkDim, full: true, onPressed: _regen)),
                const SizedBox(width: 8),
                const Expanded(child: GhostBtn(label: '✎ EDITAR', color: DedsecColors.inkDim, full: true)),
              ]),
              const SizedBox(height: 14),
              DashedBox(
                color: DedsecColors.line,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    '// sua revisão importa. você sempre pode reescrever antes de postar.',
                    style: DedsecFonts.mono(size: 10, color: DedsecColors.inkDim, letterSpacing: 0.4),
                  ),
                ),
              ),
            ]),
          ),
        ),
        StickyFooter(children: [
          Expanded(child: Btn(label: 'USAR ESTA → CANAIS', color: st.color, full: true, onPressed: () => widget.onGo(DedsecScreen.channels))),
        ]),
      ]),
    );
  }
}
