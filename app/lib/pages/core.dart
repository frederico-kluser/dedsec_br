// pages/core.dart — Home (feed), Detail (pauta), Generate (compose), Channels.

import 'dart:async';
import 'package:flutter/material.dart';
import '../atoms.dart';
import '../data.dart';
import '../design.dart';
import '../molecules.dart';
import '../state.dart';
import '../utils.dart';

// ─── 06 Home (feed) ───────────────────────────────────────────────────────
class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});
  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  String _scope = 'mun';
  @override
  Widget build(BuildContext c) {
    final app = AppStateScope.of(c);
    return Container(color: Col.bg, child: Stack(children: [
      Column(children: [
        const TopBar(),
        Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
          child: Column(children: [
            Row(children: [
              ScopeChip(label: 'MUNICIPAL', active: _scope == 'mun', color: Col.magenta, onTap: () => setState(() => _scope = 'mun')),
              const SizedBox(width: 6),
              ScopeChip(label: 'ESTADUAL', active: _scope == 'est', color: Col.acid, onTap: () => setState(() => _scope = 'est')),
              const SizedBox(width: 6),
              ScopeChip(label: 'FEDERAL', active: _scope == 'fed', color: Col.alert, onTap: () => setState(() => _scope = 'fed')),
            ]),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(color: Col.panel, border: Border.all(color: Col.line)),
              child: Row(children: [
                Text('◉ SÃO PAULO / SP', style: Fonts.pixel(size: 9, color: Col.acid)),
                const Spacer(),
                Text('4 pautas novas', style: Fonts.mono(size: 10, color: Col.inkDim)),
              ]),
            ),
          ]),
        ),
        Expanded(child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 90),
          children: [for (final n in news) NewsCard(n: n, onOpen: () => app.go('detail'))],
        )),
        TabBarNav(active: app.tab, onTab: app.goTab),
      ]),
      Positioned(right: 16, bottom: 78, child: GestureDetector(
        onTap: () => app.go('help'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Col.magenta,
            border: Border.all(color: Colors.black, width: 3),
            boxShadow: const [BoxShadow(offset: Offset(4, 4), color: Colors.black)],
          ),
          child: Text('✦ AJUDAR', style: Fonts.pixel(size: 10, color: Colors.white, letterSpacing: 1)),
        ),
      )),
    ]));
  }
}

// ─── 07 Detail ────────────────────────────────────────────────────────────
class ScreenDetail extends StatelessWidget {
  const ScreenDetail({super.key});
  @override
  Widget build(BuildContext c) {
    final app = AppStateScope.of(c);
    final n = news[0];
    const targets = [
      ('PREFEITO', 'Ricardo Nunes (MDB)', '@ricardo_nunes · X: @ricardonunes'),
      ('SEC. TRANSPORTES', 'Marcelo Branco', '@marcelo.branco'),
      ('VEREADOR · Eleito p/ Mobilidade', 'Eduardo Tuma (PSDB)', '@eduardo_tuma'),
    ];
    return Column(children: [
      BackHeader(label: 'VOLTAR', onBack: () => app.go('home'),
        trailing: const PixelChip('🔥 URGENTE', color: Col.danger, size: 8)),
      ScrollArea(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        ComicPanel(color: Color(n.color), height: 140, label: 'PAUTA · ${n.tag}',
          child: Center(child: Text(n.panel, style: const TextStyle(fontSize: 90)))),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stencil(n.title, size: 28),
          const SizedBox(height: 12),
          Text('${n.desc} A licitação inicial previa entrega para a Copa do Mundo de 2014. Sucessivos aditivos contratuais elevaram o custo total para R\$ 4,8 bilhões. Tribunal de Contas do Estado abriu processo de fiscalização em 2024.',
              style: Fonts.body(size: 13, color: Col.inkDim, height: 1.55)),
          const SizedBox(height: 18),
          Text('// FONTES ORIGINAIS', style: Fonts.pixel(size: 9, color: Col.acid, letterSpacing: 1.2)),
          for (final s in n.sources) Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Col.line))),
            child: Row(children: [
              Text('↗ ', style: Fonts.mono(size: 12, color: Col.acid)),
              Expanded(child: Text(s, style: Fonts.mono(size: 12, color: Col.ink))),
              Text('abrir', style: Fonts.mono(size: 10, color: Col.inkMute)),
            ]),
          ),
          const SizedBox(height: 18),
          Text('// QUEM DEVERIA SABER DISSO?', style: Fonts.pixel(size: 9, color: Col.magenta, letterSpacing: 1.2)),
          for (final t in targets) Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Col.line))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t.$1, style: Fonts.pixel(size: 8, color: Col.inkMute, letterSpacing: 1)),
              const SizedBox(height: 2),
              Text(t.$2, style: Fonts.body(size: 14, color: Col.ink, weight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(t.$3, style: Fonts.mono(size: 11, color: Col.acid)),
            ]),
          ),
          const SizedBox(height: 14),
          Text('reportar pauta enviesada',
              style: Fonts.mono(size: 10, color: Col.inkMute).copyWith(decoration: TextDecoration.underline)),
          const SizedBox(height: 100),
        ])),
      ])),
      StickyFooter(children: [Expanded(child: Btn('GERAR MENSAGEM →', color: Col.acid, full: true, onTap: () => app.go('generate')))]),
    ]);
  }
}

// ─── 08 Generate ──────────────────────────────────────────────────────────
class _Tone { final String id; final Color color; final String desc; const _Tone(this.id, this.color, this.desc); }
const _tones = [
  _Tone('FORMAL', Col.acid, 'institucional, respeitoso'),
  _Tone('MOBILIZADORA', Col.magenta, 'engajada, chama à ação'),
  _Tone('IRÔNICA', Col.alert, 'sarcasmo cívico'),
  _Tone('TÉCNICA', Col.sky, 'fria, com números'),
  _Tone('POÉTICA', Col.acidD, 'literária, evocativa'),
];
const _allTags = [
  ('URGÊNCIA', '⚡'),  ('DADOS', '📊'), ('TRANSPARÊNCIA', '🔍'),
  ('PRESSÃO', '🎯'),   ('HISTÓRICO', '📜'), ('PESSOAL', '🙋'),
  ('CITAÇÃO LEI', '⚖'), ('COMPARAÇÃO', '↔'),
];

String _buildMessage(String tone, Set<String> tagSet) {
  final intro = const {
    'FORMAL': 'Prezado Prefeito Ricardo Nunes,',
    'MOBILIZADORA': 'Prefeito Ricardo Nunes,',
    'IRÔNICA': 'Curiosidade pública:',
    'TÉCNICA': 'Sr. Prefeito,',
    'POÉTICA': 'Senhor Prefeito,',
  }[tone] ?? 'Prezado Prefeito,';
  final parts = <String>[intro];
  bool has(String k) => tagSet.contains(k);
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

class ScreenGenerate extends StatefulWidget {
  const ScreenGenerate({super.key});
  @override
  State<ScreenGenerate> createState() => _ScreenGenerateState();
}

class _ScreenGenerateState extends State<ScreenGenerate> {
  Set<String> _tags = {'URGÊNCIA', 'DADOS'};
  String _tone = 'MOBILIZADORA';
  String _phase = 'compose';
  int _streamLen = 0;
  Timer? _timer;
  String get _generated => _buildMessage(_tone, _tags);

  void _start() {
    if (_tags.isEmpty) return;
    setState(() { _phase = 'working'; _streamLen = 0; });
    _timer = Timer.periodic(const Duration(milliseconds: 35), (t) {
      if (!mounted) return;
      setState(() {
        _streamLen += 6;
        if (_streamLen >= _generated.length) {
          _streamLen = _generated.length;
          _phase = 'done';
          t.cancel();
        }
      });
    });
  }
  void _regen() => setState(() { _phase = 'compose'; _streamLen = 0; _timer?.cancel(); });
  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext c) {
    final app = AppStateScope.of(c);
    final tone = _tones.firstWhere((t) => t.id == _tone, orElse: () => _tones[0]);
    final canGen = _tags.isNotEmpty;
    return Column(children: [
      BackHeader(label: 'VOLTAR', onBack: () => _phase == 'compose' ? app.go('detail') : _regen(),
        trailing: PixelChip(
          _phase == 'compose' ? 'COMPOR' : _phase == 'working' ? 'LLM_LOCAL · 12 tok/s' : 'LLM_LOCAL · OK',
          color: Col.acid, size: 8,
        ),
      ),
      if (_phase == 'compose') ...[
        ScrollArea(padding: const EdgeInsets.fromLTRB(18, 16, 18, 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const PixelChip('// COMPOR MENSAGEM', color: Col.magenta),
          const SizedBox(height: 10),
          StencilSpan(TextSpan(children: [
            const TextSpan(text: 'COBRAR\n'),
            TextSpan(text: 'O PREFEITO', style: TextStyle(color: Col.magenta)),
          ]), size: 32),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(color: Col.panel, border: Border.all(color: Col.line, width: 1.5)),
            child: Row(children: [
              const Text('🚇', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('SOBRE A PAUTA', style: Fonts.pixel(size: 7, color: Col.inkMute, letterSpacing: 1)),
                const SizedBox(height: 2),
                Text('Linha 17-Ouro: 14 anos de atraso, custo triplicado',
                    style: Fonts.body(size: 12, color: Col.ink, height: 1.3)),
              ])),
            ]),
          ),
          const SizedBox(height: 22),
          Row(children: [
            Text('// TOM · escolha 1', style: Fonts.pixel(size: 9, color: Col.inkMute, letterSpacing: 1.5)),
            const Spacer(),
            Text(tone.id, style: Fonts.mono(size: 10, color: Col.acid)),
          ]),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final t in _tones) GestureDetector(
              onTap: () => setState(() => _tone = t.id),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: _tone == t.id ? t.color : Colors.transparent,
                  border: Border.all(color: _tone == t.id ? t.color : Col.line, width: 1.5),
                ),
                child: Text(t.id, style: Fonts.pixel(size: 9, color: _tone == t.id ? Colors.black : Col.ink, letterSpacing: 1)),
              ),
            ),
          ]),
          const SizedBox(height: 6),
          Text('// ${tone.desc}', style: Fonts.mono(size: 10, color: Col.inkDim)),
          const SizedBox(height: 22),
          Row(children: [
            Text('// ARGUMENTOS · escolha quantos quiser',
                style: Fonts.pixel(size: 9, color: Col.inkMute, letterSpacing: 1.5)),
            const Spacer(),
            Text('${_tags.length} marcados', style: Fonts.mono(size: 10, color: Col.acid)),
          ]),
          const SizedBox(height: 8),
          Wrap(spacing: 6, runSpacing: 6, children: [
            for (final t in _tags_chips()) t,
          ]),
          if (_tags.isEmpty) Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text('// selecione pelo menos 1 argumento.', style: Fonts.mono(size: 10, color: Col.danger)),
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Col.panel, border: Border.all(color: Col.line, width: 1.5)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('// COMO FUNCIONA', style: Fonts.pixel(size: 9, color: Col.acid)),
              const SizedBox(height: 8),
              Text('A IA local junta o tom + os argumentos selecionados e escreve UMA mensagem só pra você revisar.',
                  style: Fonts.mono(size: 10, color: Col.inkDim, height: 1.55)),
            ]),
          ),
        ])),
        StickyFooter(children: [
          Expanded(child: Text(
            canGen ? 'PRONTO PRA GERAR' : '↑ ESCOLHA OS ARGUMENTOS',
            style: Fonts.pixel(size: 8, color: Col.inkMute, letterSpacing: 1))),
          Btn('GERAR →', color: canGen ? tone.color : Col.line, fg: canGen ? Colors.black : Col.inkMute, disabled: !canGen, onTap: _start),
        ]),
      ],
      if (_phase == 'working') Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(22), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: 160,
          decoration: BoxDecoration(color: Col.panel, border: Border.all(color: Col.line, width: 1.5)),
          child: const Stack(children: [
            Center(child: SizedBox(width: 90, height: 90, child: CircularProgressIndicator(strokeWidth: 2, color: Col.acid))),
            Positioned(top: 10, left: 10, child: Text('// GERANDO_MENSAGEM.exe')),
            Scanlines(opacity: 0.15),
          ]),
        ),
        const SizedBox(height: 14),
        Wrap(spacing: 6, runSpacing: 6, children: [
          PixelChip('TOM · $_tone', color: tone.color, size: 8),
          for (final t in _tags) Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            color: Col.acid,
            child: Text(t, style: Fonts.pixel(size: 8, color: Colors.black, letterSpacing: 0.5)),
          ),
        ]),
        const SizedBox(height: 16),
        Text.rich(TextSpan(children: [
          TextSpan(text: _generated.substring(0, _streamLen.clamp(0, _generated.length)),
              style: Fonts.mono(size: 12, color: Col.ink, height: 1.55)),
          TextSpan(text: '▮', style: Fonts.mono(size: 12, color: Col.acid)),
        ])),
      ]))),
      if (_phase == 'done') ...[
        ScrollArea(padding: const EdgeInsets.fromLTRB(18, 16, 18, 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(spacing: 6, runSpacing: 6, children: [
            PixelChip('TOM · $_tone', color: tone.color, size: 8),
            for (final t in _tags) Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              color: Col.acid,
              child: Text(t, style: Fonts.pixel(size: 8, color: Colors.black, letterSpacing: 0.5)),
            ),
          ]),
          const SizedBox(height: 12),
          StencilSpan(TextSpan(children: [
            const TextSpan(text: 'MENSAGEM\n'),
            TextSpan(text: 'PRONTA', style: TextStyle(color: tone.color)),
          ]), size: 22),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Col.panel,
              border: Border.all(color: tone.color, width: 2),
              boxShadow: const [BoxShadow(offset: Offset(4, 4), color: Colors.black)],
            ),
            child: Text(_generated, style: Fonts.body(size: 13.5, color: Col.ink, height: 1.55)),
          ),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: GhostBtn('↻ REFAZER', color: Col.inkDim, full: true, onTap: _regen)),
            const SizedBox(width: 8),
            const Expanded(child: GhostBtn('✎ EDITAR', color: Col.inkDim, full: true)),
          ]),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Col.panel, border: Border.all(color: Col.line, width: 1)),
            child: Text('// sua revisão importa. você sempre pode reescrever antes de postar.',
                style: Fonts.mono(size: 10, color: Col.inkDim, height: 1.5)),
          ),
        ])),
        StickyFooter(children: [
          Expanded(child: Btn('USAR ESTA → CANAIS', color: tone.color, full: true, onTap: () => app.go('channels'))),
        ]),
      ],
    ]);
  }

  List<Widget> _tags_chips() => [
        for (final t in _allTags) GestureDetector(
          onTap: () => setState(() => _tags.contains(t.$1) ? _tags.remove(t.$1) : _tags.add(t.$1)),
          child: _tagChip(t.$1, t.$2, _tags.contains(t.$1)),
        ),
      ];
}

Widget _tagChip(String id, String glyph, bool on) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: on ? Col.acid : Colors.transparent,
        border: Border.all(color: on ? Col.acid : Col.line, width: 1.5),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(glyph, style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 5),
        Text(id, style: Fonts.pixel(size: 9, color: on ? Colors.black : Col.ink, letterSpacing: 0.8)),
      ]),
    );

// ─── 09 Channels ──────────────────────────────────────────────────────────
class ScreenChannels extends StatefulWidget {
  const ScreenChannels({super.key});
  @override
  State<ScreenChannels> createState() => _ScreenChannelsState();
}

class _ScreenChannelsState extends State<ScreenChannels> {
  static const _channels = [
    ('INSTAGRAM', 'Prefeito Ricardo Nunes', '@ricardo_nunes', 0xFFE1306C, '📷'),
    ('X / TWITTER', 'Sec. de Transportes', '@sptransporte', 0xFF1DA1F2, '🐦'),
    ('INSTAGRAM', 'Câmara Municipal SP', '@cmsp_oficial', 0xFFE1306C, '📷'),
    ('X / TWITTER', 'Ver. Eduardo Tuma', '@eduardo_tuma', 0xFF1DA1F2, '🐦'),
    ('WHATSAPP', 'Compartilhar p/ grupos', 'enviar via WA', 0xFF25D366, '💬'),
  ];
  final Set<String> _posted = {};
  @override
  Widget build(BuildContext c) {
    final app = AppStateScope.of(c);
    return Column(children: [
      BackHeader(label: 'VOLTAR', onBack: () => app.go('generate'),
        trailing: const PixelChip('POSTAGEM MANUAL', color: Col.magenta, size: 8)),
      Padding(padding: const EdgeInsets.fromLTRB(18, 16, 18, 0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Stencil('ABRIR ONDE?', size: 26),
        const SizedBox(height: 6),
        Text('// o app copia o texto, abre o destino e você cola no comentário.',
            style: Fonts.mono(size: 11, color: Col.inkDim)),
      ])),
      ScrollArea(padding: const EdgeInsets.fromLTRB(18, 16, 18, 100), child: Column(children: [
        for (final ch in _channels) _row(ch),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Col.panel, border: Border.all(color: Col.acid, width: 1.5)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('// TOAST', style: Fonts.pixel(size: 9, color: Col.acid)),
            const SizedBox(height: 8),
            Text('mensagem copiada. cole no comentário do post mais recente do destinatário.',
                style: Fonts.mono(size: 11, color: Col.inkDim, height: 1.5)),
          ]),
        ),
      ])),
      StickyFooter(children: [
        Expanded(child: Text('POSTOU EM ${_posted.length}/${_channels.length}',
            style: Fonts.pixel(size: 10, color: Col.acid))),
        Btn('CONCLUÍDO', color: Col.acid, onTap: () => app.go('home')),
      ]),
    ]);
  }

  Widget _row((String, String, String, int, String) ch) {
    final sent = _posted.contains(ch.$3);
    return GestureDetector(
      onTap: () => setState(() => _posted.add(ch.$3)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: sent ? Col.panelHi : Col.panel,
          border: Border.all(color: sent ? Col.acid : Col.line, width: 1.5),
        ),
        child: Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: Color(ch.$4), border: Border.all(color: Colors.black, width: 2)),
            alignment: Alignment.center,
            child: Text(ch.$5, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(ch.$1, style: Fonts.pixel(size: 8, color: Col.inkMute, letterSpacing: 1)),
            const SizedBox(height: 2),
            Text(ch.$2, style: Fonts.body(size: 14, color: Col.ink, weight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(ch.$3, style: Fonts.mono(size: 11, color: Color(ch.$4))),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: sent ? Col.acid : Colors.transparent,
              border: Border.all(color: sent ? Col.acid : Col.line, width: 1.5),
            ),
            child: Text(sent ? '✓ COPIADO' : 'ABRIR →',
                style: Fonts.pixel(size: 9, color: sent ? Colors.black : Col.ink)),
          ),
        ]),
      ),
    );
  }
}
