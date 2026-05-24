import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../design/colors.dart';
import '../design/fonts.dart';
import '../widgets/atoms.dart';

class CityScreen extends StatefulWidget {
  const CityScreen({super.key});
  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  static const _cities = [
    ('São Paulo', 'SP', '11,4 mi'),
    ('Rio de Janeiro', 'RJ', '6,2 mi'),
    ('Belo Horizonte', 'MG', '2,5 mi'),
    ('Recife', 'PE', '1,5 mi'),
    ('Porto Alegre', 'RS', '1,3 mi'),
    ('Curitiba', 'PR', '1,7 mi'),
    ('Salvador', 'BA', '2,4 mi'),
    ('Fortaleza', 'CE', '2,6 mi'),
  ];

  String _sel = 'São Paulo';

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return Container(
      color: DCol.bg,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PixelChip('OP_03 / TRINCHEIRA', color: DCol.acid),
                const SizedBox(height: 10),
                const StencilTwoLine(
                  first: 'QUAL É A SUA',
                  second: 'CIDADE?',
                  secondColor: DCol.acid,
                  size: 40,
                  height: 0.95,
                ),
                const SizedBox(height: 8),
                Text('// só o nome. nunca coordenadas.',
                    style: DFont.mono(size: 11, color: DCol.inkDim)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: DCol.panel,
                border: Border.all(color: DCol.line, width: 1.5),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Text('>', style: DFont.pixel(size: 14, color: DCol.magenta)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      style: DFont.mono(size: 13, color: DCol.ink),
                      decoration: InputDecoration.collapsed(
                        hintText: 'buscar entre 5.570 municípios...',
                        hintStyle: DFont.mono(size: 13, color: DCol.inkMute),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('// POPULARES',
                  style: DFont.pixel(size: 9, color: DCol.inkMute, letterSpacing: 1)),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: _cities.map((c) {
                final on = _sel == c.$1;
                return GestureDetector(
                  onTap: () => setState(() => _sel = c.$1),
                  child: Container(
                    color: on ? DCol.panelHi : Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
                    decoration: BoxDecoration(
                      color: on ? DCol.panelHi : Colors.transparent,
                      border: const Border(bottom: BorderSide(color: DCol.line)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: on ? DCol.acid : DCol.panel,
                            border: Border.all(
                                color: on ? DCol.acid : DCol.line, width: 1.5),
                          ),
                          child: Text(c.$2,
                              style: DFont.pixel(
                                  size: 9,
                                  color: on ? Colors.black : DCol.inkDim)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c.$1,
                                  style: DFont.body(
                                      size: 14,
                                      color: DCol.ink,
                                      weight: FontWeight.w600)),
                              Text('${c.$3} hab.',
                                  style: DFont.mono(size: 10, color: DCol.inkMute)),
                            ],
                          ),
                        ),
                        if (on)
                          Text('●', style: DFont.pixel(size: 12, color: DCol.acid)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: Row(
              children: [
                GhostBtn(
                  label: 'VOLTAR',
                  color: DCol.inkDim,
                  onPressed: () => app.go(Screen.interests),
                ),
                const Spacer(),
                Btn(
                  label: 'CONFIRMAR →',
                  color: DCol.acid,
                  onPressed: () => app.go(Screen.perms),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
