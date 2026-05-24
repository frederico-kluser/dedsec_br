import 'package:flutter/material.dart';

import '../app/app_scope.dart';
import '../app/app_state.dart';
import '../theme/colors.dart';
import '../theme/fonts.dart';
import '../widgets/atoms/buttons.dart';
import '../widgets/atoms/text_atoms.dart';

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({super.key});
  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  static const _causes = [
    'Educação', 'Saúde', 'Transporte', 'Seg. Pública', 'Meio Ambiente',
    'Moradia', 'Cultura', 'Mobilidade', 'Saneamento', 'Orçamento',
    'LGBTQIA+', 'Indígenas', 'Mulheres', 'Negros', 'ECA',
    'Idosos', 'PCD', 'Trabalho', 'Hab. Popular', 'Corrupção',
  ];
  final Set<String> _sel = {'Educação', 'Transporte', 'Corrupção', 'Orçamento'};

  @override
  Widget build(BuildContext context) {
    final state = AppScope.read(context);
    final min = _sel.length >= 3;
    return Container(
      color: COL.bg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PixelChip('OP_02 / INTERESSES', color: COL.magenta),
                const SizedBox(height: 10),
                const StencilSpans(
                  spans: [
                    TextSpan(text: 'ESCOLHA SUAS\n'),
                    TextSpan(text: 'CAUSAS', style: TextStyle(color: COL.magenta)),
                  ],
                  size: 40,
                ),
                const SizedBox(height: 8),
                Text(
                  '// mín. 3 marcadas · ${_sel.length}/3${min ? ' ✓' : ''}',
                  style: FONT.mono(size: 11, color: COL.inkDim),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final c in _causes)
                    GestureDetector(
                      onTap: () => setState(() => _sel.contains(c) ? _sel.remove(c) : _sel.add(c)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
                        decoration: BoxDecoration(
                          color: _sel.contains(c) ? COL.acid : Colors.transparent,
                          border: Border.all(
                            color: _sel.contains(c) ? COL.acid : COL.line,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          c,
                          style: FONT.pixel(
                            size: 9,
                            color: _sel.contains(c) ? Colors.black : COL.ink,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
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
                  onPressed: () => state.go(AppRoute.onb1),
                  child: const Text('VOLTAR'),
                ),
                const Spacer(),
                Btn(
                  color: COL.acid,
                  disabled: !min,
                  onPressed: min ? () => state.go(AppRoute.city) : null,
                  child: const Text('CONTINUAR →'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
