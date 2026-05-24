import 'package:flutter/material.dart';
import '../atoms/btn.dart';
import '../atoms/ghost_btn.dart';
import '../atoms/pixel_chip.dart';
import '../atoms/stencil.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';
import '../widgets/screen_root.dart';
import 'route.dart';

class CityPage extends StatefulWidget {
  final ValueChanged<DedsecScreen> onGo;
  const CityPage({super.key, required this.onGo});

  @override
  State<CityPage> createState() => _CityPageState();
}

class _CityPageState extends State<CityPage> {
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
    return ScreenRoot(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const PixelChip('OP_03 / TRINCHEIRA', color: DedsecColors.acid),
            const SizedBox(height: 10),
            const StencilRich(size: 40, spans: [
              TextSpan(text: 'QUAL É A SUA\n'),
              TextSpan(text: 'CIDADE?', style: TextStyle(color: DedsecColors.acid)),
            ]),
            const SizedBox(height: 8),
            Text('// só o nome. nunca coordenadas.',
                style: DedsecFonts.mono(size: 11, color: DedsecColors.inkDim)),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: DedsecColors.panel,
              border: Border.all(color: DedsecColors.line, width: 1.5),
            ),
            child: Row(children: [
              Text('>', style: DedsecFonts.pixel(size: 14, color: DedsecColors.magenta)),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: InputDecoration.collapsed(
                    hintText: 'buscar entre 5.570 municípios...',
                    hintStyle: DedsecFonts.mono(size: 13, color: DedsecColors.inkMute),
                  ),
                  style: DedsecFonts.mono(size: 13, color: DedsecColors.ink),
                ),
              ),
            ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('// POPULARES',
                style: DedsecFonts.pixel(size: 9, color: DedsecColors.inkMute, letterSpacing: 1)),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _cities.length,
            separatorBuilder: (_, __) => const Divider(color: DedsecColors.line, height: 1),
            itemBuilder: (_, i) {
              final (name, uf, pop) = _cities[i];
              final on = _sel == name;
              return GestureDetector(
                onTap: () => setState(() => _sel = name),
                child: Container(
                  color: on ? DedsecColors.panelHi : Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
                  child: Row(children: [
                    Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        color: on ? DedsecColors.acid : DedsecColors.panel,
                        border: Border.all(color: on ? DedsecColors.acid : DedsecColors.line, width: 1.5),
                      ),
                      child: Center(
                        child: Text(uf,
                            style: DedsecFonts.pixel(
                              size: 9,
                              color: on ? Colors.black : DedsecColors.inkDim,
                            )),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(name, style: DedsecFonts.body(size: 14, weight: FontWeight.w600)),
                        Text('$pop hab.', style: DedsecFonts.mono(size: 10, color: DedsecColors.inkMute)),
                      ]),
                    ),
                    if (on)
                      Text('●', style: DedsecFonts.pixel(size: 12, color: DedsecColors.acid)),
                  ]),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Row(children: [
            GhostBtn(label: 'VOLTAR', color: DedsecColors.inkDim, onPressed: () => widget.onGo(DedsecScreen.interests)),
            const Spacer(),
            Btn(label: 'CONFIRMAR →', color: DedsecColors.acid, onPressed: () => widget.onGo(DedsecScreen.perms)),
          ]),
        ),
      ]),
    );
  }
}
