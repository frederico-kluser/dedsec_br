import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../design/colors.dart';
import '../design/fonts.dart';
import '../widgets/atoms.dart';
import '../widgets/utils.dart';

class PermsScreen extends StatefulWidget {
  const PermsScreen({super.key});
  @override
  State<PermsScreen> createState() => _PermsScreenState();
}

class _PermsScreenState extends State<PermsScreen> {
  bool _push = true, _store = true, _share = true;

  Widget _row(String title, String sub, bool value, ValueChanged<bool> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: DCol.line))),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: DFont.body(
                        size: 14, color: DCol.ink, weight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(sub, style: DFont.mono(size: 10, color: DCol.inkDim)),
              ],
            ),
          ),
          Toggle(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return Container(
      color: DCol.bg,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                PixelChip('OP_04 / PERMISSÕES', color: DCol.alert),
                SizedBox(height: 10),
                Stencil('O MÍNIMO\nPOSSÍVEL.', size: 36, height: 0.95),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _row('Notificações', 'Avisar quando tiver pauta urgente.', _push,
                    (v) => setState(() => _push = v)),
                _row('Armazenamento', 'Modelo LLM local · 530 MB · gemma-3-1b', _store,
                    (v) => setState(() => _store = v)),
                _row('Compartilhamento',
                    'Abrir Instagram / X / WhatsApp via deep link.', _share,
                    (v) => setState(() => _share = v)),
                const SizedBox(height: 22),
                Container(
                  decoration: BoxDecoration(border: Border.all(color: DCol.acid, width: 1.5)),
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('// MANIFESTO',
                          style: DFont.pixel(size: 9, color: DCol.acid)),
                      const SizedBox(height: 12),
                      Text(
                        'NÃO exigimos login.\n'
                        'NÃO coletamos nome, e-mail, telefone.\n'
                        'NÃO usamos localização exata.\n'
                        'NÃO rastreamos suas redes sociais.\n'
                        'NÃO postamos por você. Você revisa, você publica.',
                        style: DFont.mono(size: 11, color: DCol.inkDim, height: 1.55),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text('ler política completa →',
                    style: DFont.mono(
                        size: 10,
                        color: DCol.inkMute,
                        decoration: TextDecoration.underline)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: Row(
              children: [
                GhostBtn(
                  label: 'VOLTAR',
                  color: DCol.inkDim,
                  onPressed: () => app.go(Screen.city),
                ),
                const Spacer(),
                Btn(
                  label: 'ENTRAR →',
                  color: DCol.alert,
                  onPressed: () => app.go(Screen.home),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
