import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../design/colors.dart';
import '../design/fonts.dart';
import '../widgets/atoms.dart';
import '../widgets/molecules.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _Card {
  const _Card({required this.color, required this.title, required this.body, required this.panel});
  final Color color;
  final String title;
  final String body;
  final String panel;
}

const _cards = <_Card>[
  _Card(
    color: DCol.magenta,
    title: 'VOCÊ É O\nVIGIA',
    body:
        'Pautas da sua cidade chegam direto. Você decide quando, como e onde se manifestar.',
    panel: '👁',
  ),
  _Card(
    color: DCol.acid,
    title: 'NADA DE\nLOGIN',
    body:
        'Sem CPF, sem e-mail, sem celular. Sem rastrear suas redes. Sua identidade nunca sai do seu aparelho.',
    panel: '🛡',
  ),
  _Card(
    color: DCol.alert,
    title: 'CÉLULA\nDISTRIBUÍDA',
    body:
        'O cérebro do app é o seu próprio celular. Quando você quiser, ajuda outros usuários processando pautas.',
    panel: '⚡',
  ),
];

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final c = _cards[_step];
    return Container(
      color: DCol.bg,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
            child: Row(
              children: [
                for (var i = 0; i < _cards.length; i++) ...[
                  Expanded(
                    child: Container(
                      height: 4,
                      color: i <= _step ? c.color : DCol.line,
                    ),
                  ),
                  if (i < _cards.length - 1) const SizedBox(width: 6),
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
                    height: 220,
                    children: [
                      Positioned.fill(
                        child: Center(
                          child: Opacity(
                            opacity: 0.85,
                            child: Text(c.panel, style: const TextStyle(fontSize: 110)),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          color: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                          child: Text('OP_${(_step + 1).toString().padLeft(2, '0')}',
                              style: DFont.pixel(size: 9, color: c.color, letterSpacing: 1)),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          child: Text('${_step + 1}/3',
                              style:
                                  DFont.pixel(size: 9, color: Colors.black)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Stencil(
                    c.title,
                    size: 48,
                    height: 1,
                    shadows: [Shadow(color: c.color, offset: const Offset(3, 3))],
                  ),
                  const SizedBox(height: 18),
                  Text(c.body, style: DFont.body(size: 15, color: DCol.inkDim, height: 1.5)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Row(
              children: [
                GhostBtn(
                  label: 'PULAR',
                  color: DCol.inkDim,
                  onPressed: () => app.go(Screen.interests),
                ),
                const Spacer(),
                Btn(
                  label: _step < 2 ? 'PRÓXIMO →' : 'COMEÇAR →',
                  color: c.color,
                  onPressed: () {
                    if (_step < 2) {
                      setState(() => _step++);
                    } else {
                      app.go(Screen.interests);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
