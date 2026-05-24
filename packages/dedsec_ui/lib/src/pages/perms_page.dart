import 'package:flutter/material.dart';
import '../atoms/btn.dart';
import '../atoms/dashed_box.dart';
import '../atoms/ghost_btn.dart';
import '../atoms/pixel_chip.dart';
import '../atoms/stencil.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';
import '../widgets/screen_root.dart';
import '../widgets/toggle.dart';
import 'route.dart';

class PermsPage extends StatefulWidget {
  final ValueChanged<DedsecScreen> onGo;
  const PermsPage({super.key, required this.onGo});

  @override
  State<PermsPage> createState() => _PermsPageState();
}

class _PermsPageState extends State<PermsPage> {
  bool _push = true, _store = true, _share = true;

  Widget _row(String k, String title, String sub, bool value, VoidCallback toggle) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: DedsecColors.line)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: DedsecFonts.body(size: 14, weight: FontWeight.w600)),
            const SizedBox(height: 3),
            Text(sub, style: DedsecFonts.mono(size: 10, color: DedsecColors.inkDim)),
          ]),
        ),
        DedsecToggle(value: value, onChanged: toggle),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenRoot(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            PixelChip('OP_04 / PERMISSÕES', color: DedsecColors.alert),
            SizedBox(height: 10),
            Stencil('O MÍNIMO\nPOSSÍVEL.', size: 36),
          ]),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              _row('push', 'Notificações', 'Avisar quando tiver pauta urgente.', _push, () => setState(() => _push = !_push)),
              _row('store', 'Armazenamento', 'Modelo LLM local · 530 MB · gemma-3-1b', _store, () => setState(() => _store = !_store)),
              _row('share', 'Compartilhamento', 'Abrir Instagram / X / WhatsApp via deep link.', _share, () => setState(() => _share = !_share)),
              const SizedBox(height: 22),
              DashedBox(
                color: DedsecColors.acid,
                strokeWidth: 1.5,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('// MANIFESTO',
                        style: DedsecFonts.pixel(size: 9, color: DedsecColors.acid)),
                    const SizedBox(height: 12),
                    Text(
                      'NÃO exigimos login.\nNÃO coletamos nome, e-mail, telefone.\nNÃO usamos localização exata.\nNÃO rastreamos suas redes sociais.\nNÃO postamos por você. Você revisa, você publica.',
                      style: DedsecFonts.mono(size: 11, color: DedsecColors.inkDim, letterSpacing: 0.4),
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('ler política completa →',
                    style: DedsecFonts.mono(size: 10, color: DedsecColors.inkMute).copyWith(
                      decoration: TextDecoration.underline,
                    )),
              ),
            ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Row(children: [
            GhostBtn(label: 'VOLTAR', color: DedsecColors.inkDim, onPressed: () => widget.onGo(DedsecScreen.city)),
            const Spacer(),
            Btn(label: 'ENTRAR →', color: DedsecColors.alert, onPressed: () => widget.onGo(DedsecScreen.home)),
          ]),
        ),
      ]),
    );
  }
}
