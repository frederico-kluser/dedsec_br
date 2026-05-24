import 'package:flutter/material.dart';

import '../app/app_scope.dart';
import '../app/app_state.dart';
import '../theme/colors.dart';
import '../theme/fonts.dart';
import '../widgets/atoms/avatar.dart';
import '../widgets/atoms/text_atoms.dart';
import '../widgets/molecules/bars.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final user = state.user;
    return Container(
      color: COL.bg,
      child: Stack(
        children: [
          Column(
            children: [
              const TopBar(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Stencil('CONFIG', size: 28),
                    const SizedBox(height: 4),
                    Text('// uuid local · ${user.seed}',
                        style: FONT.mono(size: 10, color: COL.inkDim)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 90),
                  children: [
                    _group('PERFIL ANÔNIMO', [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Avatar(seed: user.seed, size: 84),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user.pseudonym,
                                      style: FONT.body(size: 15, weight: FontWeight.w700)),
                                  const SizedBox(height: 4),
                                  Text.rich(
                                    TextSpan(children: [
                                      const TextSpan(text: 'seed: '),
                                      TextSpan(
                                          text: user.seed,
                                          style: const TextStyle(color: COL.acid)),
                                    ], style: FONT.mono(size: 10, color: COL.inkDim)),
                                  ),
                                  const SizedBox(height: 2),
                                  Text('via dicebear · identicon',
                                      style: FONT.mono(size: 10, color: COL.inkMute)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: state.regenerateUser,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                                decoration: const BoxDecoration(
                                  color: COL.magenta,
                                  boxShadow: [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                                ),
                                child: Text(
                                  '↻ REGERAR AVATAR',
                                  textAlign: TextAlign.center,
                                  style: FONT.pixel(size: 10, color: Colors.white, letterSpacing: 1.5),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text.rich(
                              TextSpan(children: [
                                const TextSpan(text: '// gera uma nova imagem aleatória.\n'),
                                const TextSpan(text: '// seu pseudônimo '),
                                TextSpan(text: user.pseudonym, style: const TextStyle(color: COL.acid)),
                                const TextSpan(text: ' não muda.'),
                              ], style: FONT.mono(size: 9, color: COL.inkMute, height: 1.5)),
                            ),
                          ],
                        ),
                      ),
                    ]),
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
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: DedsecTabBar(active: state.tab.name, onTab: (id) {
              switch (id) {
                case 'home':
                  state.goTab(AppTab.home);
                  break;
                case 'help':
                  state.goTab(AppTab.help);
                  break;
                case 'forum':
                  state.goTab(AppTab.forum);
                  break;
                case 'settings':
                  state.goTab(AppTab.settings);
                  break;
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _group(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('// $title',
              style: FONT.pixel(size: 8, color: COL.inkMute, letterSpacing: 1.5)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: COL.panel,
              border: Border.all(color: COL.line),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: COL.line)),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: FONT.body(size: 13))),
          Text(value, style: FONT.mono(size: 11, color: COL.inkDim)),
          const SizedBox(width: 8),
          Text('›', style: FONT.body(size: 14, color: COL.inkMute)),
        ],
      ),
    );
  }
}
