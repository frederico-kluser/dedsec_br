import 'package:flutter/material.dart';

import '../app/app_scope.dart';
import '../app/app_state.dart';
import '../data/home_data.dart';
import '../theme/colors.dart';
import '../theme/fonts.dart';
import '../widgets/atoms/buttons.dart';
import '../widgets/atoms/text_atoms.dart';
import '../widgets/molecules/comic_panel.dart';
import '../widgets/utils/layout.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  static const _targets = <_Target>[
    _Target('PREFEITO', 'Ricardo Nunes (MDB)', ['@ricardo_nunes', 'X: @ricardonunes']),
    _Target('SEC. TRANSPORTES', 'Marcelo Branco', ['@marcelo.branco']),
    _Target('VEREADOR · Eleito p/ Mobilidade', 'Eduardo Tuma (PSDB)', ['@eduardo_tuma']),
  ];

  @override
  Widget build(BuildContext context) {
    final state = AppScope.read(context);
    final n = kNews[0];
    return Container(
      color: COL.bg,
      child: Column(
        children: [
          BackHeader(
            onBack: () => state.go(AppRoute.home),
            trailing: const PixelChip('🔥 URGENTE', color: COL.danger, size: 8),
          ),
          ScrollArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ComicPanel(
                  color: n.color,
                  halftoneColor: Colors.black,
                  height: 140,
                  label: 'PAUTA · ${n.tag}',
                  child: Center(
                    child: Text(n.panel, style: const TextStyle(fontSize: 90)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stencil(n.title, size: 28, height: 1.05),
                      const SizedBox(height: 12),
                      Text(
                        '${n.desc} A licitação inicial previa entrega para a Copa do Mundo de 2014. Sucessivos aditivos contratuais elevaram o custo total para R\$ 4,8 bilhões. Tribunal de Contas do Estado abriu processo de fiscalização em 2024.',
                        style: FONT.body(size: 13, color: COL.inkDim, height: 1.55),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        '// FONTES ORIGINAIS',
                        style: FONT.pixel(size: 9, color: COL.acid, letterSpacing: 1.2),
                      ),
                      for (final s in n.sources)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: COL.line)),
                          ),
                          child: Row(
                            children: [
                              Text('↗',
                                  style: FONT.mono(size: 12, color: COL.acid)),
                              const SizedBox(width: 8),
                              Expanded(child: Text(s, style: FONT.mono(size: 12, color: COL.ink))),
                              Text('abrir', style: FONT.mono(size: 10, color: COL.inkMute)),
                            ],
                          ),
                        ),
                      const SizedBox(height: 18),
                      Text(
                        '// QUEM DEVERIA SABER DISSO?',
                        style: FONT.pixel(size: 9, color: COL.magenta, letterSpacing: 1.2),
                      ),
                      for (final t in _targets)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: COL.line)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t.role,
                                  style: FONT.pixel(size: 8, color: COL.inkMute, letterSpacing: 1)),
                              const SizedBox(height: 2),
                              Text(t.name,
                                  style: FONT.body(size: 14, weight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text(t.handles.join(' · '),
                                  style: FONT.mono(size: 11, color: COL.acid)),
                            ],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 14, bottom: 100),
                        child: Text('reportar pauta enviesada',
                            style: FONT.mono(
                              size: 10,
                              color: COL.inkMute,
                              decoration: TextDecoration.underline,
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          StickyFooter(
            children: [
              Expanded(
                child: Btn(
                  full: true,
                  color: COL.acid,
                  onPressed: () => state.go(AppRoute.generate),
                  child: const Text('GERAR MENSAGEM →'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Target {
  final String role;
  final String name;
  final List<String> handles;
  const _Target(this.role, this.name, this.handles);
}
