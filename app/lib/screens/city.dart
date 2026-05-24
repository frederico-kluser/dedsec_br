import 'package:flutter/material.dart';

import '../app/app_scope.dart';
import '../app/app_state.dart';
import '../theme/colors.dart';
import '../theme/fonts.dart';
import '../widgets/atoms/buttons.dart';
import '../widgets/atoms/text_atoms.dart';

class CityScreen extends StatefulWidget {
  const CityScreen({super.key});
  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  static const _cities = <List<String>>[
    ['São Paulo', 'SP', '11,4 mi'],
    ['Rio de Janeiro', 'RJ', '6,2 mi'],
    ['Belo Horizonte', 'MG', '2,5 mi'],
    ['Recife', 'PE', '1,5 mi'],
    ['Porto Alegre', 'RS', '1,3 mi'],
    ['Curitiba', 'PR', '1,7 mi'],
    ['Salvador', 'BA', '2,4 mi'],
    ['Fortaleza', 'CE', '2,6 mi'],
  ];

  String _sel = 'São Paulo';

  @override
  Widget build(BuildContext context) {
    final state = AppScope.read(context);
    return Container(
      color: COL.bg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PixelChip('OP_03 / TRINCHEIRA', color: COL.acid),
                const SizedBox(height: 10),
                const StencilSpans(
                  spans: [
                    TextSpan(text: 'QUAL É A SUA\n'),
                    TextSpan(text: 'CIDADE?', style: TextStyle(color: COL.acid)),
                  ],
                  size: 40,
                ),
                const SizedBox(height: 8),
                Text('// só o nome. nunca coordenadas.',
                    style: FONT.mono(size: 11, color: COL.inkDim)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: COL.panel,
                border: Border.all(color: COL.line, width: 1.5),
              ),
              child: Row(
                children: [
                  Text('>', style: FONT.pixel(size: 14, color: COL.magenta)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'buscar entre 5.570 municípios...',
                        hintStyle: FONT.mono(size: 13, color: COL.inkMute),
                        border: InputBorder.none,
                        isCollapsed: true,
                      ),
                      style: FONT.mono(size: 13, color: COL.ink),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Text('// POPULARES',
                style: FONT.pixel(size: 9, color: COL.inkMute, letterSpacing: 1)),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                for (final c in _cities) _cityRow(c),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: Row(
              children: [
                GhostBtn(
                  color: COL.inkDim,
                  onPressed: () => state.go(AppRoute.interests),
                  child: const Text('VOLTAR'),
                ),
                const Spacer(),
                Btn(
                  color: COL.acid,
                  onPressed: () => state.go(AppRoute.perms),
                  child: const Text('CONFIRMAR →'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cityRow(List<String> c) {
    final on = _sel == c[0];
    return GestureDetector(
      onTap: () => setState(() => _sel = c[0]),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
        decoration: BoxDecoration(
          color: on ? COL.panelHi : Colors.transparent,
          border: const Border(bottom: BorderSide(color: COL.line)),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: on ? COL.acid : COL.panel,
                border: Border.all(color: on ? COL.acid : COL.line, width: 1.5),
              ),
              child: Text(c[1],
                  style: FONT.pixel(size: 9, color: on ? Colors.black : COL.inkDim)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c[0], style: FONT.body(size: 14, weight: FontWeight.w600)),
                  Text('${c[2]} hab.', style: FONT.mono(size: 10, color: COL.inkMute)),
                ],
              ),
            ),
            if (on) Text('●', style: FONT.pixel(size: 12, color: COL.acid)),
          ],
        ),
      ),
    );
  }
}
