// pages/setup.dart — Splash, Onboarding, Interests, City, Perms.

import 'dart:async';
import 'package:flutter/material.dart';
import '../atoms.dart';
import '../design.dart';
import '../molecules.dart';
import '../state.dart';
import '../utils.dart';

// ─── 01 Splash ────────────────────────────────────────────────────────────
class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});
  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  int _pct = 34;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 160), (_) {
      if (mounted) setState(() => _pct = _pct >= 100 ? 34 : _pct + 1);
    });
  }
  @override
  void dispose() { _timer?.cancel(); super.dispose(); }
  @override
  Widget build(BuildContext c) {
    final app = AppStateScope.of(c);
    return Container(
      color: Col.bg,
      child: Stack(fit: StackFit.expand, children: [
        const Halftone(color: Col.magenta, size: 6, opacity: 0.18),
        const Scanlines(opacity: 0.12),
        Column(children: [
          Expanded(child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Skull(size: 64, color: Col.ink),
              const SizedBox(height: 22),
              const Glitch('DEDSEC_BR', size: 24),
              const SizedBox(height: 12),
              Text('// CÉLULA CÍVICA LOCAL · v0.1.0',
                  style: Fonts.mono(size: 10, color: Col.inkDim, letterSpacing: 2)),
              const SizedBox(height: 40),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('BAIXANDO_CÉREBRO_LOCAL', style: Fonts.mono(size: 11, color: Col.acid)),
                Text('$_pct%', style: Fonts.mono(size: 11, color: Col.acid)),
              ]),
              const SizedBox(height: 6),
              PixelBar(value: _pct.toDouble(), color: Col.acid),
              const SizedBox(height: 8),
              Text('gemma-3-1b-it-q4.task · 530 MB · wifi recomendado',
                  style: Fonts.mono(size: 9, color: Col.inkMute, letterSpacing: 1)),
            ]),
          )),
          const CautionTape(text: 'NOS AGUARDE · NOS AGUARDE · NOS AGUARDE · ', color: Col.acid),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
            child: Row(children: [
              const Expanded(child: GhostBtn('CANCELAR', color: Col.inkDim, full: true)),
              const SizedBox(width: 10),
              Expanded(child: Btn('PULAR →', color: Col.magenta, fg: Colors.white, full: true, onTap: () => app.go('onb1'))),
            ]),
          ),
        ]),
      ]),
    );
  }
}

// ─── 02 Onboarding ────────────────────────────────────────────────────────
class ScreenOnboarding extends StatefulWidget {
  const ScreenOnboarding({super.key});
  @override
  State<ScreenOnboarding> createState() => _ScreenOnboardingState();
}

class _ScreenOnboardingState extends State<ScreenOnboarding> {
  int _step = 0;
  static const _cards = [
    (Col.magenta, 'VOCÊ É O\nVIGIA', 'Pautas da sua cidade chegam direto. Você decide quando, como e onde se manifestar.', '👁'),
    (Col.acid, 'NADA DE\nLOGIN', 'Sem CPF, sem e-mail, sem celular. Sem rastrear suas redes. Sua identidade nunca sai do seu aparelho.', '🛡'),
    (Col.alert, 'CÉLULA\nDISTRIBUÍDA', 'O cérebro do app é o seu próprio celular. Quando você quiser, ajuda outros usuários processando pautas.', '⚡'),
  ];
  @override
  Widget build(BuildContext c) {
    final app = AppStateScope.of(c);
    final card = _cards[_step];
    return Container(
      color: Col.bg,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
          child: Row(children: [
            for (var i = 0; i < _cards.length; i++) ...[
              if (i > 0) const SizedBox(width: 6),
              Expanded(child: Container(height: 4, color: i <= _step ? card.$1 : Col.line)),
            ],
          ]),
        ),
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ComicPanel(color: card.$1, height: 220, child: Stack(children: [
            Center(child: Opacity(opacity: 0.85, child: Text(card.$4, style: const TextStyle(fontSize: 110)))),
            Positioned(top: 12, left: 12, child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              color: Colors.black,
              child: Text('OP_${(_step + 1).toString().padLeft(2, '0')}', style: Fonts.pixel(size: 9, color: card.$1, letterSpacing: 1)),
            )),
            Positioned(bottom: 12, right: 12, child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              color: Colors.white,
              child: Text('${_step + 1}/3', style: Fonts.pixel(size: 9, color: Colors.black)),
            )),
          ])),
          const SizedBox(height: 18),
          Stencil(card.$2, size: 48, shadows: [Shadow(offset: const Offset(3, 3), color: card.$1)]),
          const SizedBox(height: 18),
          Text(card.$3, style: Fonts.body(size: 15, color: Col.inkDim, height: 1.5)),
        ]))),
        Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 24), child: Row(children: [
          GhostBtn('PULAR', color: Col.inkDim, onTap: () => app.go('interests')),
          const Spacer(),
          Btn(_step < 2 ? 'PRÓXIMO →' : 'COMEÇAR →', color: card.$1, onTap: () {
            if (_step < 2) setState(() => _step++); else app.go('interests');
          }),
        ])),
      ]),
    );
  }
}

// ─── 03 Interests ─────────────────────────────────────────────────────────
class ScreenInterests extends StatefulWidget {
  const ScreenInterests({super.key});
  @override
  State<ScreenInterests> createState() => _ScreenInterestsState();
}

class _ScreenInterestsState extends State<ScreenInterests> {
  static const _causes = [
    'Educação','Saúde','Transporte','Seg. Pública','Meio Ambiente',
    'Moradia','Cultura','Mobilidade','Saneamento','Orçamento',
    'LGBTQIA+','Indígenas','Mulheres','Negros','ECA',
    'Idosos','PCD','Trabalho','Hab. Popular','Corrupção',
  ];
  Set<String> _sel = {'Educação','Transporte','Corrupção','Orçamento'};
  @override
  Widget build(BuildContext c) {
    final app = AppStateScope.of(c);
    final ok = _sel.length >= 3;
    return Container(color: Col.bg, child: Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(20, 18, 20, 14), child: Align(
        alignment: Alignment.centerLeft,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const PixelChip('OP_02 / INTERESSES', color: Col.magenta),
          const SizedBox(height: 10),
          StencilSpan(TextSpan(children: [
            const TextSpan(text: 'ESCOLHA SUAS\n'),
            TextSpan(text: 'CAUSAS', style: TextStyle(color: Col.magenta)),
          ]), size: 40),
          const SizedBox(height: 8),
          Text('// mín. 3 marcadas · ${_sel.length}/3 ${ok ? '✓' : ''}',
              style: Fonts.mono(size: 11, color: Col.inkDim)),
        ]),
      )),
      ScrollArea(padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Wrap(spacing: 8, runSpacing: 8, children: [
          for (final cause in _causes) GestureDetector(
            onTap: () => setState(() => _sel.contains(cause) ? _sel.remove(cause) : _sel.add(cause)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
              decoration: BoxDecoration(
                color: _sel.contains(cause) ? Col.acid : Colors.transparent,
                border: Border.all(color: _sel.contains(cause) ? Col.acid : Col.line, width: 1.5),
              ),
              child: Text(cause, style: Fonts.pixel(size: 9, color: _sel.contains(cause) ? Colors.black : Col.ink, letterSpacing: 0.5)),
            ),
          ),
        ]),
      ),
      Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 24), child: Row(children: [
        GhostBtn('VOLTAR', color: Col.inkDim, onTap: () => app.go('onb1')),
        const Spacer(),
        Btn('CONTINUAR →', color: Col.acid, disabled: !ok, onTap: ok ? () => app.go('city') : null),
      ])),
    ]));
  }
}

// ─── 04 City ──────────────────────────────────────────────────────────────
class ScreenCity extends StatefulWidget {
  const ScreenCity({super.key});
  @override
  State<ScreenCity> createState() => _ScreenCityState();
}

class _ScreenCityState extends State<ScreenCity> {
  static const _cities = [
    ('São Paulo', 'SP', '11,4 mi'), ('Rio de Janeiro', 'RJ', '6,2 mi'),
    ('Belo Horizonte', 'MG', '2,5 mi'), ('Recife', 'PE', '1,5 mi'),
    ('Porto Alegre', 'RS', '1,3 mi'), ('Curitiba', 'PR', '1,7 mi'),
    ('Salvador', 'BA', '2,4 mi'), ('Fortaleza', 'CE', '2,6 mi'),
  ];
  String _sel = 'São Paulo';
  @override
  Widget build(BuildContext c) {
    final app = AppStateScope.of(c);
    return Container(color: Col.bg, child: Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(20, 18, 20, 12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const PixelChip('OP_03 / TRINCHEIRA', color: Col.acid),
        const SizedBox(height: 10),
        StencilSpan(TextSpan(children: [
          const TextSpan(text: 'QUAL É A SUA\n'),
          TextSpan(text: 'CIDADE?', style: TextStyle(color: Col.acid)),
        ]), size: 40),
        const SizedBox(height: 8),
        Text('// só o nome. nunca coordenadas.', style: Fonts.mono(size: 11, color: Col.inkDim)),
      ])),
      Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 14), child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(color: Col.panel, border: Border.all(color: Col.line, width: 1.5)),
        child: Row(children: [
          Text('>', style: Fonts.pixel(size: 14, color: Col.magenta)),
          const SizedBox(width: 10),
          Expanded(child: TextField(
            style: Fonts.mono(size: 13, color: Col.ink),
            decoration: InputDecoration(
              border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero,
              hintText: 'buscar entre 5.570 municípios...',
              hintStyle: Fonts.mono(size: 13, color: Col.inkMute),
            ),
          )),
        ]),
      )),
      Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 8), child: Align(alignment: Alignment.centerLeft,
          child: Text('// POPULARES', style: Fonts.pixel(size: 9, color: Col.inkMute, letterSpacing: 1)))),
      ScrollArea(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(children: [
        for (final entry in _cities) _row(entry),
      ])),
      Padding(padding: const EdgeInsets.fromLTRB(20, 14, 20, 24), child: Row(children: [
        GhostBtn('VOLTAR', color: Col.inkDim, onTap: () => app.go('interests')),
        const Spacer(),
        Btn('CONFIRMAR →', color: Col.acid, onTap: () => app.go('perms')),
      ])),
    ]));
  }

  Widget _row((String, String, String) e) {
    final on = _sel == e.$1;
    return GestureDetector(
      onTap: () => setState(() => _sel = e.$1),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
        decoration: BoxDecoration(
          color: on ? Col.panelHi : Colors.transparent,
          border: const Border(bottom: BorderSide(color: Col.line)),
        ),
        child: Row(children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              color: on ? Col.acid : Col.panel,
              border: Border.all(color: on ? Col.acid : Col.line, width: 1.5),
            ),
            alignment: Alignment.center,
            child: Text(e.$2, style: Fonts.pixel(size: 9, color: on ? Colors.black : Col.inkDim)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(e.$1, style: Fonts.body(size: 14, color: Col.ink, weight: FontWeight.w600)),
            Text('${e.$3} hab.', style: Fonts.mono(size: 10, color: Col.inkMute)),
          ])),
          if (on) Text('●', style: Fonts.pixel(size: 12, color: Col.acid)),
        ]),
      ),
    );
  }
}

// ─── 05 Perms ─────────────────────────────────────────────────────────────
class ScreenPerms extends StatefulWidget {
  const ScreenPerms({super.key});
  @override
  State<ScreenPerms> createState() => _ScreenPermsState();
}

class _ScreenPermsState extends State<ScreenPerms> {
  final _p = {'push': true, 'store': true, 'share': true};
  @override
  Widget build(BuildContext c) {
    final app = AppStateScope.of(c);
    Widget row(String k, String title, String sub) => Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Col.line))),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: Fonts.body(size: 14, color: Col.ink, weight: FontWeight.w600)),
              const SizedBox(height: 3),
              Text(sub, style: Fonts.mono(size: 10, color: Col.inkDim)),
            ])),
            Toggle(value: _p[k]!, onChanged: () => setState(() => _p[k] = !_p[k]!)),
          ]),
        );
    return Container(color: Col.bg, child: Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(20, 18, 20, 14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const PixelChip('OP_04 / PERMISSÕES', color: Col.alert),
        const SizedBox(height: 10),
        const Stencil('O MÍNIMO\nPOSSÍVEL.', size: 36),
      ])),
      ScrollArea(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        row('push', 'Notificações', 'Avisar quando tiver pauta urgente.'),
        row('store', 'Armazenamento', 'Modelo LLM local · 530 MB · gemma-3-1b'),
        row('share', 'Compartilhamento', 'Abrir Instagram / X / WhatsApp via deep link.'),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(border: Border.all(color: Col.acid, width: 1.5)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('// MANIFESTO', style: Fonts.pixel(size: 9, color: Col.acid)),
            const SizedBox(height: 12),
            Text('NÃO exigimos login.\nNÃO coletamos nome, e-mail, telefone.\nNÃO usamos localização exata.\nNÃO rastreamos suas redes sociais.\nNÃO postamos por você. Você revisa, você publica.',
                style: Fonts.mono(size: 11, color: Col.inkDim, height: 1.55)),
          ]),
        ),
        const SizedBox(height: 12),
        Text('ler política completa →',
            style: Fonts.mono(size: 10, color: Col.inkMute, height: 1).copyWith(decoration: TextDecoration.underline)),
      ])),
      Padding(padding: const EdgeInsets.fromLTRB(20, 14, 20, 24), child: Row(children: [
        GhostBtn('VOLTAR', color: Col.inkDim, onTap: () => app.go('city')),
        const Spacer(),
        Btn('ENTRAR →', color: Col.alert, onTap: () => app.go('home')),
      ])),
    ]));
  }
}
