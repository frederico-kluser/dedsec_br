import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../design/colors.dart';
import '../design/fonts.dart';
import '../widgets/atoms.dart';
import '../widgets/utils.dart';

class ChannelsScreen extends StatefulWidget {
  const ChannelsScreen({super.key});
  @override
  State<ChannelsScreen> createState() => _ChannelsScreenState();
}

class _Channel {
  const _Channel({required this.plat, required this.who, required this.handle, required this.color, required this.glyph});
  final String plat;
  final String who;
  final String handle;
  final Color color;
  final String glyph;
}

const _channels = <_Channel>[
  _Channel(plat: 'INSTAGRAM', who: 'Prefeito Ricardo Nunes', handle: '@ricardo_nunes', color: Color(0xFFE1306C), glyph: '📷'),
  _Channel(plat: 'X / TWITTER', who: 'Sec. de Transportes', handle: '@sptransporte', color: Color(0xFF1DA1F2), glyph: '🐦'),
  _Channel(plat: 'INSTAGRAM', who: 'Câmara Municipal SP', handle: '@cmsp_oficial', color: Color(0xFFE1306C), glyph: '📷'),
  _Channel(plat: 'X / TWITTER', who: 'Ver. Eduardo Tuma', handle: '@eduardo_tuma', color: Color(0xFF1DA1F2), glyph: '🐦'),
  _Channel(plat: 'WHATSAPP', who: 'Compartilhar p/ grupos', handle: 'enviar via WA', color: Color(0xFF25D366), glyph: '💬'),
];

class _ChannelsScreenState extends State<ChannelsScreen> {
  final _posted = <String>{};

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return Container(
      color: DCol.bg,
      child: Column(
        children: [
          BackHeader(
            onBack: () => app.go(Screen.generate),
            right: const PixelChip('POSTAGEM MANUAL', color: DCol.magenta, size: 8),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Stencil('ABRIR ONDE?', size: 26),
                const SizedBox(height: 6),
                Text(
                  '// o app copia o texto, abre o destino e você cola no comentário.',
                  style: DFont.mono(size: 11, color: DCol.inkDim),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 100),
              children: [
                ..._channels.map((c) {
                  final sent = _posted.contains(c.handle);
                  return GestureDetector(
                    onTap: () => setState(() => _posted.add(c.handle)),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: sent ? DCol.panelHi : DCol.panel,
                        border: Border.all(color: sent ? DCol.acid : DCol.line, width: 1.5),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: c.color,
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                            child: Text(c.glyph,
                                style: const TextStyle(fontSize: 22, color: Colors.white)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c.plat,
                                    style: DFont.pixel(
                                        size: 8, color: DCol.inkMute, letterSpacing: 1)),
                                const SizedBox(height: 2),
                                Text(c.who,
                                    style: DFont.body(
                                        size: 14,
                                        color: DCol.ink,
                                        weight: FontWeight.w600)),
                                const SizedBox(height: 2),
                                Text(c.handle, style: DFont.mono(size: 11, color: c.color)),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: sent ? DCol.acid : Colors.transparent,
                              border: Border.all(
                                  color: sent ? DCol.acid : DCol.line, width: 1.5),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Text(sent ? '✓ COPIADO' : 'ABRIR →',
                                style: DFont.pixel(
                                    size: 9, color: sent ? Colors.black : DCol.ink)),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: DCol.panel,
                    border: Border.all(color: DCol.acid, width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('// TOAST',
                          style: DFont.pixel(size: 9, color: DCol.acid)),
                      const SizedBox(height: 6),
                      Text(
                        'mensagem copiada. cole no comentário do post mais recente do destinatário.',
                        style: DFont.mono(size: 11, color: DCol.inkDim, height: 1.5),
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
                child: Text('POSTOU EM ${_posted.length}/${_channels.length}',
                    style: DFont.pixel(size: 10, color: DCol.acid)),
              ),
              Btn(
                label: 'CONCLUÍDO',
                color: DCol.acid,
                onPressed: () => app.go(Screen.home),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
