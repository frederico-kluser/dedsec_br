import 'package:flutter/material.dart';

import '../app/app_scope.dart';
import '../app/app_state.dart';
import '../theme/colors.dart';
import '../theme/fonts.dart';
import '../widgets/atoms/buttons.dart';
import '../widgets/atoms/text_atoms.dart';
import '../widgets/utils/layout.dart';

class PermsScreen extends StatefulWidget {
  const PermsScreen({super.key});
  @override
  State<PermsScreen> createState() => _PermsScreenState();
}

class _PermsScreenState extends State<PermsScreen> {
  final Map<String, bool> _p = {'push': true, 'store': true, 'share': true};

  @override
  Widget build(BuildContext context) {
    final state = AppScope.read(context);
    return Container(
      color: COL.bg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                PixelChip('OP_04 / PERMISSÕES', color: COL.alert),
                SizedBox(height: 10),
                Stencil('O MÍNIMO\nPOSSÍVEL.', size: 36),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _row('push', 'Notificações', 'Avisar quando tiver pauta urgente.'),
                  _row('store', 'Armazenamento', 'Modelo LLM local · 530 MB · gemma-3-1b'),
                  _row('share', 'Compartilhamento',
                      'Abrir Instagram / X / WhatsApp via deep link.'),
                  const SizedBox(height: 22),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border.all(color: COL.acid, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('// MANIFESTO',
                            style: FONT.pixel(size: 9, color: COL.acid)),
                        const SizedBox(height: 12),
                        Text(
                          'NÃO exigimos login.\n'
                          'NÃO coletamos nome, e-mail, telefone.\n'
                          'NÃO usamos localização exata.\n'
                          'NÃO rastreamos suas redes sociais.\n'
                          'NÃO postamos por você. Você revisa, você publica.',
                          style: FONT.mono(size: 11, color: COL.inkDim, height: 1.55),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('ler política completa →',
                      style: FONT.mono(
                        size: 10,
                        color: COL.inkMute,
                        decoration: TextDecoration.underline,
                      )),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: Row(
              children: [
                GhostBtn(
                  color: COL.inkDim,
                  onPressed: () => state.go(AppRoute.city),
                  child: const Text('VOLTAR'),
                ),
                const Spacer(),
                Btn(
                  color: COL.alert,
                  onPressed: () => state.go(AppRoute.home),
                  child: const Text('ENTRAR →'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String k, String title, String sub) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: COL.line)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: FONT.body(size: 14, weight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(sub, style: FONT.mono(size: 10, color: COL.inkDim)),
              ],
            ),
          ),
          Toggle(value: _p[k]!, onChanged: () => setState(() => _p[k] = !_p[k]!)),
        ],
      ),
    );
  }
}
