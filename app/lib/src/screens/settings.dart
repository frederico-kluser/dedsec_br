import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../design/colors.dart';
import '../design/fonts.dart';
import '../widgets/atoms.dart';
import '../widgets/molecules.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return Container(
      color: DCol.bg,
      child: Column(
        children: [
          const TopBar(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Stencil('CONFIG', size: 28),
                const SizedBox(height: 4),
                Text('// uuid local · ${app.user.seed}',
                    style: DFont.mono(size: 10, color: DCol.inkDim)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 90),
              children: [
                _profileGroup(app),
                _group('LLM LOCAL', [
                  _row('Modelo', 'gemma-3-1b · q4'),
                  _row('Baixar de novo', '530 MB'),
                  _row('Atualizar p/ 4B', 'aparelho ok'),
                ]),
                _group('QUANDO AJUDAR', [
                  _row('Bateria mínima', '50%'),
                  _row('Só plugado', 'ON'),
                  _row('Só wifi', 'ON'),
                ]),
                _group('DADOS', [
                  _row('Notificações', 'ON'),
                  _row('Limpar dados locais', ''),
                ]),
                _group('SOBRE', [
                  _row('Código aberto (AGPLv3)', 'github'),
                  _row('Política de privacidade', ''),
                  _row('Manifesto', ''),
                  _row('Versão', '0.1.0-beta'),
                ]),
              ],
            ),
          ),
          DTabBar(active: app.tab, onTab: app.goTab),
        ],
      ),
    );
  }

  Widget _profileGroup(AppState app) {
    return _group('PERFIL ANÔNIMO', [
      Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: DCol.line)),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Avatar(seed: app.user.seed, size: 84),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(app.user.pseudonym,
                      style: DFont.body(
                          size: 15,
                          color: DCol.ink,
                          weight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text.rich(
                    TextSpan(children: [
                      const TextSpan(text: 'seed: '),
                      TextSpan(
                          text: app.user.seed,
                          style: DFont.mono(size: 10, color: DCol.acid)),
                    ], style: DFont.mono(size: 10, color: DCol.inkDim)),
                  ),
                  const SizedBox(height: 2),
                  Text('via dicebear · identicon',
                      style: DFont.mono(size: 10, color: DCol.inkMute)),
                ],
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Btn(
              label: '↻ REGERAR AVATAR',
              color: DCol.magenta,
              fg: Colors.white,
              full: true,
              onPressed: app.regenerateUser,
            ),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(children: [
                const TextSpan(text: '// gera uma nova imagem aleatória.\n// seu pseudônimo '),
                TextSpan(text: app.user.pseudonym, style: DFont.mono(size: 9, color: DCol.acid)),
                const TextSpan(text: ' não muda.'),
              ], style: DFont.mono(size: 9, color: DCol.inkMute, height: 1.5)),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _group(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text('// $title',
                style: DFont.pixel(size: 8, color: DCol.inkMute, letterSpacing: 1.5)),
          ),
          Container(
            decoration: BoxDecoration(
              color: DCol.panel,
              border: Border.all(color: DCol.line),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: DCol.line)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(
        children: [
          Expanded(child: Text(label, style: DFont.body(size: 13, color: DCol.ink))),
          Text(value, style: DFont.mono(size: 11, color: DCol.inkDim)),
          const SizedBox(width: 6),
          const Text('›', style: TextStyle(color: DCol.inkMute, height: 1)),
        ],
      ),
    );
  }
}
