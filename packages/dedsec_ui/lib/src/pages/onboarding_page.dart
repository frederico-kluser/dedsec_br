import 'package:flutter/material.dart';
import '../atoms/btn.dart';
import '../atoms/ghost_btn.dart';
import '../atoms/stencil.dart';
import '../molecules/comic_panel.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';
import '../widgets/screen_root.dart';
import 'route.dart';

class OnboardingPage extends StatefulWidget {
  final ValueChanged<DedsecScreen> onGo;
  const OnboardingPage({super.key, required this.onGo});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _step = 0;

  @override
  Widget build(BuildContext context) {
    final cards = const [
      _OnbCard(color: DedsecColors.magenta, title: 'VOCÊ É O\nVIGIA',
          body: 'Pautas da sua cidade chegam direto. Você decide quando, como e onde se manifestar.', panel: '👁'),
      _OnbCard(color: DedsecColors.acid, title: 'NADA DE\nLOGIN',
          body: 'Sem CPF, sem e-mail, sem celular. Sem rastrear suas redes. Sua identidade nunca sai do seu aparelho.', panel: '🛡'),
      _OnbCard(color: DedsecColors.alert, title: 'CÉLULA\nDISTRIBUÍDA',
          body: 'O cérebro do app é o seu próprio celular. Quando você quiser, ajuda outros usuários processando pautas.', panel: '⚡'),
    ];
    final c = cards[_step];

    return ScreenRoot(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
          child: Row(children: [
            for (var i = 0; i < cards.length; i++) ...[
              if (i > 0) const SizedBox(width: 6),
              Expanded(
                child: Container(
                  height: 4,
                  color: i <= _step ? c.color : DedsecColors.line,
                ),
              ),
            ],
          ]),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ComicPanel(
                color: c.color,
                height: 220,
                child: Stack(children: [
                  Positioned.fill(
                    child: Center(
                      child: Opacity(
                        opacity: 0.85,
                        child: Text(c.panel, style: const TextStyle(fontSize: 110)),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12, left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                      color: Colors.black,
                      child: Text('OP_${(_step + 1).toString().padLeft(2, '0')}',
                          style: DedsecFonts.pixel(size: 9, color: c.color, letterSpacing: 1)),
                    ),
                  ),
                  Positioned(
                    bottom: 12, right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      color: Colors.white,
                      child: Text('${_step + 1}/3',
                          style: DedsecFonts.pixel(size: 9, color: Colors.black)),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 18),
              Stencil(c.title, size: 48, shadows: [Shadow(color: c.color, offset: const Offset(3, 3))]),
              const SizedBox(height: 18),
              Text(c.body, style: DedsecFonts.body(size: 15, color: DedsecColors.inkDim, height: 1.5)),
            ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Row(children: [
            GhostBtn(label: 'PULAR', color: DedsecColors.inkDim, onPressed: () => widget.onGo(DedsecScreen.interests)),
            const Spacer(),
            Btn(
              label: _step < 2 ? 'PRÓXIMO →' : 'COMEÇAR →',
              color: c.color,
              onPressed: () => _step < 2 ? setState(() => _step++) : widget.onGo(DedsecScreen.interests),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _OnbCard {
  final Color color;
  final String title;
  final String body;
  final String panel;
  const _OnbCard({required this.color, required this.title, required this.body, required this.panel});
}
