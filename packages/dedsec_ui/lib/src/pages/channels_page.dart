import 'package:flutter/material.dart';
import '../atoms/btn.dart';
import '../atoms/dashed_box.dart';
import '../atoms/pixel_chip.dart';
import '../atoms/stencil.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';
import '../widgets/back_header.dart';
import '../widgets/screen_root.dart';
import '../widgets/sticky_footer.dart';
import 'route.dart';

class _Channel {
  final String plat;
  final String who;
  final String handle;
  final Color color;
  final String glyph;
  const _Channel(this.plat, this.who, this.handle, this.color, this.glyph);
}

const _channels = <_Channel>[
  _Channel('INSTAGRAM', 'Prefeito Ricardo Nunes', '@ricardo_nunes', Color(0xFFE1306C), '📷'),
  _Channel('X / TWITTER', 'Sec. de Transportes', '@sptransporte', Color(0xFF1DA1F2), '🐦'),
  _Channel('INSTAGRAM', 'Câmara Municipal SP', '@cmsp_oficial', Color(0xFFE1306C), '📷'),
  _Channel('X / TWITTER', 'Ver. Eduardo Tuma', '@eduardo_tuma', Color(0xFF1DA1F2), '🐦'),
  _Channel('WHATSAPP', 'Compartilhar p/ grupos', 'enviar via WA', Color(0xFF25D366), '💬'),
];

class ChannelsPage extends StatefulWidget {
  final ValueChanged<DedsecScreen> onGo;
  const ChannelsPage({super.key, required this.onGo});
  @override
  State<ChannelsPage> createState() => _ChannelsPageState();
}

class _ChannelsPageState extends State<ChannelsPage> {
  final Set<String> _posted = {};

  @override
  Widget build(BuildContext context) {
    return ScreenRoot(
      child: Column(children: [
        BackHeader(
          onBack: () => widget.onGo(DedsecScreen.generate),
          trailing: const PixelChip('POSTAGEM MANUAL', color: DedsecColors.magenta, size: 8),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Stencil('ABRIR ONDE?', size: 26),
            const SizedBox(height: 6),
            Text('// o app copia o texto, abre o destino e você cola no comentário.',
                style: DedsecFonts.mono(size: 11, color: DedsecColors.inkDim)),
          ]),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 100),
            itemCount: _channels.length + 1,
            itemBuilder: (_, i) {
              if (i == _channels.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: DashedBox(
                    color: DedsecColors.acid,
                    strokeWidth: 1.5,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('// TOAST',
                            style: DedsecFonts.pixel(size: 9, color: DedsecColors.acid)),
                        const SizedBox(height: 6),
                        Text(
                          'mensagem copiada. cole no comentário do post mais recente do destinatário.',
                          style: DedsecFonts.mono(size: 11, color: DedsecColors.inkDim),
                        ),
                      ]),
                    ),
                  ),
                );
              }
              final c = _channels[i];
              final sent = _posted.contains(c.handle);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () => setState(() => _posted.add(c.handle)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: sent ? DedsecColors.panelHi : DedsecColors.panel,
                      border: Border.all(color: sent ? DedsecColors.acid : DedsecColors.line, width: 1.5),
                    ),
                    child: Row(children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(color: c.color, border: Border.all(color: Colors.black, width: 2)),
                        child: Center(child: Text(c.glyph, style: const TextStyle(fontSize: 22))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(c.plat, style: DedsecFonts.pixel(size: 8, color: DedsecColors.inkMute, letterSpacing: 1)),
                          const SizedBox(height: 2),
                          Text(c.who, style: DedsecFonts.body(size: 14, weight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          Text(c.handle, style: DedsecFonts.mono(size: 11, color: c.color)),
                        ]),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: sent ? DedsecColors.acid : Colors.transparent,
                          border: Border.all(color: sent ? DedsecColors.acid : DedsecColors.line, width: 1.5),
                        ),
                        child: Text(sent ? '✓ COPIADO' : 'ABRIR →',
                            style: DedsecFonts.pixel(
                              size: 9,
                              color: sent ? Colors.black : DedsecColors.ink,
                            )),
                      ),
                    ]),
                  ),
                ),
              );
            },
          ),
        ),
        StickyFooter(children: [
          Expanded(
            child: Text('POSTOU EM ${_posted.length}/${_channels.length}',
                style: DedsecFonts.pixel(size: 10, color: DedsecColors.acid)),
          ),
          Btn(label: 'CONCLUÍDO', color: DedsecColors.acid, onPressed: () => widget.onGo(DedsecScreen.home)),
        ]),
      ]),
    );
  }
}
