import 'package:flutter/material.dart';

import '../app/app_scope.dart';
import '../app/app_state.dart';
import '../theme/colors.dart';
import '../theme/fonts.dart';
import '../widgets/atoms/buttons.dart';
import '../widgets/atoms/text_atoms.dart';
import '../widgets/molecules/comic_panel.dart';

class _OnbCard {
  final Color color;
  final String title;
  final String body;
  final String panel;
  const _OnbCard(this.color, this.title, this.body, this.panel);
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;
  static const _cards = <_OnbCard>[
    _OnbCard(COL.magenta, 'VOCÊ É O\nVIGIA',
        'Pautas da sua cidade chegam direto. Você decide quando, como e onde se manifestar.', '👁'),
    _OnbCard(COL.acid, 'NADA DE\nLOGIN',
        'Sem CPF, sem e-mail, sem celular. Sem rastrear suas redes. Sua identidade nunca sai do seu aparelho.', '🛡'),
    _OnbCard(COL.alert, 'CÉLULA\nDISTRIBUÍDA',
        'O cérebro do app é o seu próprio celular. Quando você quiser, ajuda outros usuários processando pautas.', '⚡'),
  ];

  @override
  Widget build(BuildContext context) {
    final state = AppScope.read(context);
    final c = _cards[_step];
    return Container(
      color: COL.bg,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
            child: Row(
              children: [
                for (var i = 0; i < _cards.length; i++) ...[
                  if (i > 0) const SizedBox(width: 6),
                  Expanded(
                    child: Container(
                      height: 4,
                      color: i <= _step ? c.color : COL.line,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ComicPanel(
                    color: c.color,
                    halftoneColor: Colors.black,
                    height: 220,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                            color: Colors.black,
                            child: Text(
                              'OP_${(_step + 1).toString().padLeft(2, '0')}',
                              style: FONT.pixel(size: 9, color: c.color, letterSpacing: 1),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                            color: Colors.white,
                            child: Text('${_step + 1}/3',
                                style: FONT.pixel(size: 9, color: Colors.black)),
                          ),
                        ),
                        Center(
                          child: Opacity(
                            opacity: 0.85,
                            child: Text(c.panel, style: const TextStyle(fontSize: 110)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Stencil(
                    c.title,
                    size: 48,
                    shadows: [Shadow(offset: const Offset(3, 3), color: c.color)],
                  ),
                  const SizedBox(height: 18),
                  Text(c.body, style: FONT.body(size: 15, color: COL.inkDim, height: 1.5)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Row(
              children: [
                GhostBtn(
                  color: COL.inkDim,
                  onPressed: () => state.go(AppRoute.interests),
                  child: const Text('PULAR'),
                ),
                const Spacer(),
                Btn(
                  color: c.color,
                  onPressed: () {
                    if (_step < 2) {
                      setState(() => _step++);
                    } else {
                      state.go(AppRoute.interests);
                    }
                  },
                  child: Text(_step < 2 ? 'PRÓXIMO →' : 'COMEÇAR →'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
