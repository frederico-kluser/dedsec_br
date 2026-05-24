import 'package:flutter/material.dart';
import '../atoms/btn.dart';
import '../atoms/ghost_btn.dart';
import '../atoms/pixel_chip.dart';
import '../atoms/stencil.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';
import '../widgets/screen_root.dart';
import 'route.dart';

class InterestsPage extends StatefulWidget {
  final ValueChanged<DedsecScreen> onGo;
  const InterestsPage({super.key, required this.onGo});

  @override
  State<InterestsPage> createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  static const _causes = <String>[
    'Educação', 'Saúde', 'Transporte', 'Seg. Pública', 'Meio Ambiente',
    'Moradia', 'Cultura', 'Mobilidade', 'Saneamento', 'Orçamento',
    'LGBTQIA+', 'Indígenas', 'Mulheres', 'Negros', 'ECA',
    'Idosos', 'PCD', 'Trabalho', 'Hab. Popular', 'Corrupção',
  ];

  final Set<String> _sel = {'Educação', 'Transporte', 'Corrupção', 'Orçamento'};

  void _toggle(String c) {
    setState(() {
      _sel.contains(c) ? _sel.remove(c) : _sel.add(c);
    });
  }

  @override
  Widget build(BuildContext context) {
    final min = _sel.length >= 3;
    return ScreenRoot(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const PixelChip('OP_02 / INTERESSES', color: DedsecColors.magenta),
            const SizedBox(height: 10),
            const StencilRich(size: 40, spans: [
              TextSpan(text: 'ESCOLHA SUAS\n'),
              TextSpan(text: 'CAUSAS', style: TextStyle(color: DedsecColors.magenta)),
            ]),
            const SizedBox(height: 8),
            Text('// mín. 3 marcadas · ${_sel.length}/3 ${min ? '✓' : ''}',
                style: DedsecFonts.mono(size: 11, color: DedsecColors.inkDim)),
          ]),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Wrap(
              spacing: 8, runSpacing: 8,
              children: [
                for (final c in _causes)
                  GestureDetector(
                    onTap: () => _toggle(c),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
                      decoration: BoxDecoration(
                        color: _sel.contains(c) ? DedsecColors.acid : Colors.transparent,
                        border: Border.all(
                          color: _sel.contains(c) ? DedsecColors.acid : DedsecColors.line,
                          width: 1.5,
                        ),
                      ),
                      child: Text(c,
                          style: DedsecFonts.pixel(
                            size: 9,
                            color: _sel.contains(c) ? Colors.black : DedsecColors.ink,
                            letterSpacing: 0.5,
                          )),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Row(children: [
            GhostBtn(label: 'VOLTAR', color: DedsecColors.inkDim, onPressed: () => widget.onGo(DedsecScreen.onboarding)),
            const Spacer(),
            Btn(
              label: 'CONTINUAR →',
              color: DedsecColors.acid,
              disabled: !min,
              onPressed: min ? () => widget.onGo(DedsecScreen.city) : null,
            ),
          ]),
        ),
      ]),
    );
  }
}
