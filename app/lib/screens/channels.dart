import 'package:flutter/material.dart';

import '../app/app_scope.dart';
import '../app/app_state.dart';
import '../theme/colors.dart';
import '../theme/fonts.dart';
import '../widgets/atoms/buttons.dart';
import '../widgets/atoms/text_atoms.dart';
import '../widgets/utils/layout.dart';

class _Channel {
  final String plat;
  final String who;
  final String handle;
  final Color color;
  final String glyph;
  const _Channel(this.plat, this.who, this.handle, this.color, this.glyph);
}

const _kChannels = <_Channel>[
  _Channel('INSTAGRAM', 'Prefeito Ricardo Nunes', '@ricardo_nunes', Color(0xFFE1306C), '📷'),
  _Channel('X / TWITTER', 'Sec. de Transportes', '@sptransporte', Color(0xFF1DA1F2), '🐦'),
  _Channel('INSTAGRAM', 'Câmara Municipal SP', '@cmsp_oficial', Color(0xFFE1306C), '📷'),
  _Channel('X / TWITTER', 'Ver. Eduardo Tuma', '@eduardo_tuma', Color(0xFF1DA1F2), '🐦'),
  _Channel('WHATSAPP', 'Compartilhar p/ grupos', 'enviar via WA', Color(0xFF25D366), '💬'),
];

class ChannelsScreen extends StatefulWidget {
  const ChannelsScreen({super.key});
  @override
  State<ChannelsScreen> createState() => _ChannelsScreenState();
}

class _ChannelsScreenState extends State<ChannelsScreen> {
  final Set<String> _posted = {};

  @override
  Widget build(BuildContext context) {
    final state = AppScope.read(context);
    return Container(
      color: COL.bg,
      child: Column(
        children: [
          BackHeader(
            onBack: () => state.go(AppRoute.generate),
            trailing: const PixelChip('POSTAGEM MANUAL', color: COL.magenta, size: 8),
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
                  style: FONT.mono(size: 11, color: COL.inkDim),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 100),
              children: [
                for (final c in _kChannels) _channelButton(c),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: COL.panel,
                    border: Border.all(color: COL.acid, width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('// TOAST',
                          style: FONT.pixel(size: 9, color: COL.acid)),
                      const SizedBox(height: 4),
                      Text(
                        'mensagem copiada. cole no comentário do post mais recente do destinatário.',
                        style: FONT.mono(size: 11, color: COL.inkDim, height: 1.5),
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
                child: Text('POSTOU EM ${_posted.length}/${_kChannels.length}',
                    style: FONT.pixel(size: 10, color: COL.acid)),
              ),
              Btn(
                color: COL.acid,
                onPressed: () => state.go(AppRoute.home),
                child: const Text('CONCLUÍDO'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _channelButton(_Channel c) {
    final sent = _posted.contains(c.handle);
    return GestureDetector(
      onTap: () => setState(() => _posted.add(c.handle)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: sent ? COL.panelHi : COL.panel,
          border: Border.all(color: sent ? COL.acid : COL.line, width: 1.5),
        ),
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
                      style: FONT.pixel(size: 8, color: COL.inkMute, letterSpacing: 1)),
                  const SizedBox(height: 2),
                  Text(c.who,
                      style: FONT.body(size: 14, weight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(c.handle, style: FONT.mono(size: 11, color: c.color)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: sent ? COL.acid : Colors.transparent,
                border: Border.all(color: sent ? COL.acid : COL.line, width: 1.5),
              ),
              child: Text(
                sent ? '✓ COPIADO' : 'ABRIR →',
                style: FONT.pixel(size: 9, color: sent ? Colors.black : COL.ink),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
