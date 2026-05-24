import 'package:flutter/material.dart';
import '../atoms/btn.dart';
import '../atoms/pixel_chip.dart';
import '../atoms/stencil.dart';
import '../molecules/comic_panel.dart';
import '../molecules/news_card.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';
import '../widgets/back_header.dart';
import '../widgets/screen_root.dart';
import '../widgets/sticky_footer.dart';
import 'route.dart';

class DetailPage extends StatelessWidget {
  final ValueChanged<DedsecScreen> onGo;
  const DetailPage({super.key, required this.onGo});

  @override
  Widget build(BuildContext context) {
    final n = dedsecNews[0];
    const targets = [
      ('PREFEITO', 'Ricardo Nunes (MDB)', '@ricardo_nunes · X: @ricardonunes'),
      ('SEC. TRANSPORTES', 'Marcelo Branco', '@marcelo.branco'),
      ('VEREADOR · Eleito p/ Mobilidade', 'Eduardo Tuma (PSDB)', '@eduardo_tuma'),
    ];

    return ScreenRoot(
      child: Column(children: [
        BackHeader(
          onBack: () => onGo(DedsecScreen.home),
          trailing: const PixelChip('🔥 URGENTE', color: DedsecColors.danger, size: 8),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ComicPanel(
                color: n.color, height: 140, label: 'PAUTA · ${n.tag}',
                child: Center(child: Text(n.panel, style: const TextStyle(fontSize: 90))),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Stencil(n.title, size: 28),
                  const SizedBox(height: 12),
                  Text(
                    '${n.desc} A licitação inicial previa entrega para a Copa do Mundo de 2014. Sucessivos aditivos contratuais elevaram o custo total para R\$ 4,8 bilhões. Tribunal de Contas do Estado abriu processo de fiscalização em 2024.',
                    style: DedsecFonts.body(size: 13, color: DedsecColors.inkDim, height: 1.55),
                  ),
                  const SizedBox(height: 18),
                  Text('// FONTES ORIGINAIS',
                      style: DedsecFonts.pixel(size: 9, color: DedsecColors.acid, letterSpacing: 1.2)),
                  for (final s in n.sources)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: DedsecColors.line)),
                      ),
                      child: Row(children: [
                        Text('↗', style: TextStyle(color: DedsecColors.acid)),
                        const SizedBox(width: 8),
                        Expanded(child: Text(s, style: DedsecFonts.mono(size: 12, color: DedsecColors.ink))),
                        Text('abrir', style: DedsecFonts.mono(size: 10, color: DedsecColors.inkMute)),
                      ]),
                    ),
                  const SizedBox(height: 18),
                  Text('// QUEM DEVERIA SABER DISSO?',
                      style: DedsecFonts.pixel(size: 9, color: DedsecColors.magenta, letterSpacing: 1.2)),
                  for (final t in targets)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: DedsecColors.line)),
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(t.$1,
                            style: DedsecFonts.pixel(size: 8, color: DedsecColors.inkMute, letterSpacing: 1)),
                        const SizedBox(height: 2),
                        Text(t.$2,
                            style: DedsecFonts.body(size: 14, weight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(t.$3,
                            style: DedsecFonts.mono(size: 11, color: DedsecColors.acid)),
                      ]),
                    ),
                  const SizedBox(height: 14),
                  Text('reportar pauta enviesada',
                      style: DedsecFonts.mono(size: 10, color: DedsecColors.inkMute).copyWith(
                        decoration: TextDecoration.underline,
                      )),
                  const SizedBox(height: 100),
                ]),
              ),
            ]),
          ),
        ),
        StickyFooter(children: [
          Expanded(child: Btn(label: 'GERAR MENSAGEM →', color: DedsecColors.acid, full: true, onPressed: () => onGo(DedsecScreen.generate))),
        ]),
      ]),
    );
  }
}
