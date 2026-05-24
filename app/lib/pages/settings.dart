// pages/settings.dart — anonymous profile + LLM + about.

import 'package:flutter/material.dart';
import '../atoms.dart';
import '../design.dart';
import '../molecules.dart';
import '../state.dart';

class ScreenSettings extends StatelessWidget {
  const ScreenSettings({super.key});
  @override
  Widget build(BuildContext c) {
    final app = AppStateScope.of(c);
    Widget group(String title, List<Widget> children) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('// $title', style: Fonts.pixel(size: 8, color: Col.inkMute, letterSpacing: 1.5)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(color: Col.panel, border: Border.all(color: Col.line)),
            child: Column(children: children),
          ),
          const SizedBox(height: 22),
        ]);
    Widget row(String label, String value, {bool danger = false}) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Col.line))),
          child: Row(children: [
            Expanded(child: Text(label, style: Fonts.body(size: 13, color: danger ? Col.danger : Col.ink))),
            Text(value, style: Fonts.mono(size: 11, color: Col.inkDim)),
            const SizedBox(width: 4),
            Text('›', style: TextStyle(color: Col.inkMute)),
          ]),
        );
    return Column(children: [
      const TopBar(),
      Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 8), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Stencil('CONFIG', size: 28),
        const SizedBox(height: 4),
        Text('// uuid local · ${app.user.seed}', style: Fonts.mono(size: 10, color: Col.inkDim)),
      ])),
      Expanded(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(16, 14, 16, 90), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        group('PERFIL ANÔNIMO', [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Col.line))),
            child: Row(children: [
              Avatar(seed: app.user.seed, size: 84),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(app.user.pseudonym, style: Fonts.body(size: 15, color: Col.ink, weight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text.rich(TextSpan(children: [
                  TextSpan(text: 'seed: ', style: Fonts.mono(size: 10, color: Col.inkDim)),
                  TextSpan(text: app.user.seed, style: Fonts.mono(size: 10, color: Col.acid)),
                ])),
                Text('via dicebear · identicon', style: Fonts.mono(size: 10, color: Col.inkMute)),
              ])),
            ]),
          ),
          Padding(padding: const EdgeInsets.all(12), child: Column(children: [
            GestureDetector(
              onTap: app.regenerateUser,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: const BoxDecoration(
                  color: Col.magenta,
                  boxShadow: [BoxShadow(offset: Offset(4, 4), color: Colors.black)],
                ),
                child: Text('↻ REGERAR AVATAR',
                    textAlign: TextAlign.center,
                    style: Fonts.pixel(size: 10, color: Colors.white, letterSpacing: 1.5)),
              ),
            ),
            const SizedBox(height: 8),
            Text.rich(TextSpan(children: [
              TextSpan(text: '// gera uma nova imagem aleatória.\n// seu pseudônimo ', style: Fonts.mono(size: 9, color: Col.inkMute, height: 1.5)),
              TextSpan(text: app.user.pseudonym, style: Fonts.mono(size: 9, color: Col.acid, height: 1.5)),
              TextSpan(text: ' não muda.', style: Fonts.mono(size: 9, color: Col.inkMute, height: 1.5)),
            ])),
          ])),
        ]),
        group('LLM LOCAL', [
          row('Modelo', 'gemma-3-1b · q4'),
          row('Baixar de novo', '530 MB'),
          row('Atualizar p/ 4B', 'aparelho ok'),
        ]),
        group('QUANDO AJUDAR', [
          row('Bateria mínima', '50%'),
          row('Só plugado', 'ON'),
          row('Só wifi', 'ON'),
        ]),
        group('DADOS', [
          row('Notificações', 'ON'),
          row('Limpar dados locais', ''),
        ]),
        group('SOBRE', [
          row('Código aberto (AGPLv3)', 'github'),
          row('Política de privacidade', ''),
          row('Manifesto', ''),
          row('Versão', '0.1.0-beta'),
        ]),
      ]))),
      TabBarNav(active: app.tab, onTab: app.goTab),
    ]);
  }
}
