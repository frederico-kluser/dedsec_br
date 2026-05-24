import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../design/colors.dart';
import '../design/fonts.dart';
import '../widgets/atoms.dart';

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

  final _sel = <String>{'Educação', 'Transporte', 'Corrupção', 'Orçamento'};

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final min = _sel.length >= 3;
    return Container(
      color: DCol.bg,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PixelChip('OP_02 / INTERESSES', color: DCol.magenta),
                const SizedBox(height: 10),
                const StencilTwoLine(
                  first: 'ESCOLHA SUAS',
                  second: 'CAUSAS',
                  size: 40,
                  height: 0.95,
                ),
                const SizedBox(height: 8),
                Text(
                  '// mín. 3 marcadas · ${_sel.length}/3 ${min ? '✓' : ''}',
                  style: DFont.mono(size: 11, color: DCol.inkDim),
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
                children: _causes.map((c) {
                  final on = _sel.contains(c);
                  return GestureDetector(
                    onTap: () => setState(() {
                      on ? _sel.remove(c) : _sel.add(c);
                    }),
                    child: Container(
                      decoration: BoxDecoration(
                        color: on ? DCol.acid : Colors.transparent,
                        border:
                            Border.all(color: on ? DCol.acid : DCol.line, width: 1.5),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
                      child: Text(
                        c,
                        style: DFont.pixel(
                          size: 9,
                          color: on ? Colors.black : DCol.ink,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Row(
              children: [
                GhostBtn(
                  label: 'VOLTAR',
                  color: DCol.inkDim,
                  onPressed: () => app.go(Screen.onboarding),
                ),
                const Spacer(),
                Btn(
                  label: 'CONTINUAR →',
                  color: DCol.acid,
                  disabled: !min,
                  onPressed: min ? () => app.go(Screen.city) : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
