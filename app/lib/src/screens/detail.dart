import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/news.dart';
import '../design/colors.dart';
import '../design/fonts.dart';
import '../widgets/atoms.dart';
import '../widgets/molecules.dart';
import '../widgets/utils.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final n = NEWS[0];

    const targets = [
      (role: 'PREFEITO', name: 'Ricardo Nunes (MDB)', handles: ['@ricardo_nunes', 'X: @ricardonunes']),
      (role: 'SEC. TRANSPORTES', name: 'Marcelo Branco', handles: ['@marcelo.branco']),
      (role: 'VEREADOR · Eleito p/ Mobilidade', name: 'Eduardo Tuma (PSDB)', handles: ['@eduardo_tuma']),
    ];

    return Container(
      color: DCol.bg,
      child: Column(
        children: [
          BackHeader(
            onBack: () => app.go(Screen.home),
            right: const PixelChip('🔥 URGENTE', color: DCol.danger, size: 8),
          ),
          Expanded(
            child: ListView(
              children: [
                ComicPanel(
                  color: n.color,
                  height: 140,
                  label: 'PAUTA · ${n.tag}',
                  children: [
                    Positioned.fill(
                      child: Center(
                        child: Text(n.panel, style: const TextStyle(fontSize: 90)),
                      ),
                    ),
                  ],
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
                        style: DFont.body(size: 13, color: DCol.inkDim, height: 1.55),
                      ),
                      const SizedBox(height: 18),
                      Text('// FONTES ORIGINAIS',
                          style: DFont.pixel(size: 9, color: DCol.acid, letterSpacing: 1.2)),
                      ...n.sources.map((s) => Container(
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: DCol.line)),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Text('↗', style: DFont.mono(size: 12, color: DCol.acid)),
                                const SizedBox(width: 8),
                                Expanded(
                                    child: Text(s,
                                        style:
                                            DFont.mono(size: 12, color: DCol.ink))),
                                Text('abrir',
                                    style:
                                        DFont.mono(size: 10, color: DCol.inkMute)),
                              ],
                            ),
                          )),
                      const SizedBox(height: 18),
                      Text('// QUEM DEVERIA SABER DISSO?',
                          style:
                              DFont.pixel(size: 9, color: DCol.magenta, letterSpacing: 1.2)),
                      ...targets.map((t) => Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: DCol.line)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(t.role,
                                    style: DFont.pixel(
                                        size: 8,
                                        color: DCol.inkMute,
                                        letterSpacing: 1)),
                                const SizedBox(height: 2),
                                Text(t.name,
                                    style: DFont.body(
                                        size: 14,
                                        color: DCol.ink,
                                        weight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                Text(t.handles.join(' · '),
                                    style: DFont.mono(size: 11, color: DCol.acid)),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 100),
                  child: Text('reportar pauta enviesada',
                      style: DFont.mono(
                          size: 10,
                          color: DCol.inkMute,
                          decoration: TextDecoration.underline)),
                ),
              ],
            ),
          ),
          StickyFooter(
            children: [
              Expanded(
                child: Btn(
                  label: 'GERAR MENSAGEM →',
                  full: true,
                  color: DCol.acid,
                  onPressed: () => app.go(Screen.generate),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
