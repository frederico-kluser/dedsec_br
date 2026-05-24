import 'package:flutter/material.dart';
import '../atoms/avatar.dart';
import '../atoms/stencil.dart';
import '../molecules/tab_bar.dart';
import '../molecules/top_bar.dart';
import '../state/app_state.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';
import '../widgets/screen_root.dart';
import 'route.dart';

class SettingsPage extends StatelessWidget {
  final ValueChanged<DedsecScreen> onGo;
  final String activeTab;
  final ValueChanged<String> onTab;
  const SettingsPage({super.key, required this.onGo, required this.activeTab, required this.onTab});

  @override
  Widget build(BuildContext context) {
    final state = DedsecScope.of(context);
    final user = state.user;
    return ScreenRoot(
      child: Column(children: [
        const DedsecTopBar(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Stencil('CONFIG', size: 28),
            const SizedBox(height: 4),
            Text('// uuid local · ${user.seed}',
                style: DedsecFonts.mono(size: 10, color: DedsecColors.inkDim)),
          ]),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 90),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _group('PERFIL ANÔNIMO', [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: DedsecColors.line)),
                  ),
                  child: Row(children: [
                    Avatar(seed: user.seed, size: 84),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(user.pseudonym,
                            style: DedsecFonts.body(size: 15, weight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text.rich(TextSpan(
                          style: DedsecFonts.mono(size: 10, color: DedsecColors.inkDim),
                          children: [
                            const TextSpan(text: 'seed: '),
                            TextSpan(text: user.seed, style: const TextStyle(color: DedsecColors.acid)),
                          ],
                        )),
                        const SizedBox(height: 2),
                        Text('via dicebear · identicon',
                            style: DedsecFonts.mono(size: 10, color: DedsecColors.inkMute)),
                      ]),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    GestureDetector(
                      onTap: state.regenerateUser,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: const BoxDecoration(
                          color: DedsecColors.magenta,
                          boxShadow: [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                        ),
                        child: Center(
                          child: Text('↻ REGERAR AVATAR',
                              style: DedsecFonts.pixel(size: 10, color: Colors.white, letterSpacing: 1.5)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text.rich(TextSpan(
                      style: DedsecFonts.mono(size: 9, color: DedsecColors.inkMute, height: 1.5),
                      children: [
                        const TextSpan(text: '// gera uma nova imagem aleatória.\n// seu pseudônimo '),
                        TextSpan(text: user.pseudonym, style: const TextStyle(color: DedsecColors.acid)),
                        const TextSpan(text: ' não muda.'),
                      ],
                    )),
                  ]),
                ),
              ]),
              _group('LLM LOCAL', [
                _row('Modelo', 'gemma-3-1b · q4'),
                _row('Baixar de novo', '530 MB'),
                _row('Atualizar p/ 4B', 'aparelho ok'),
              ]),
              _group('QUANDO AJUDAR', [
                _row('Bateria mínima', '50%'),
                _row('Só plugado', 'ON'),
                _row('Só wifi', 'ON'),
              ]),
              _group('DADOS', [
                _row('Notificações', 'ON'),
                _row('Limpar dados locais', ''),
              ]),
              _group('SOBRE', [
                _row('Código aberto (AGPLv3)', 'github'),
                _row('Política de privacidade', ''),
                _row('Manifesto', ''),
                _row('Versão', '0.1.0-beta'),
              ]),
            ]),
          ),
        ),
        DedsecTabBar(active: activeTab, onTab: onTab),
      ]),
    );
  }

  Widget _group(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('// $title',
            style: DedsecFonts.pixel(size: 8, color: DedsecColors.inkMute, letterSpacing: 1.5)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: DedsecColors.panel,
            border: Border.all(color: DedsecColors.line),
          ),
          child: Column(children: children),
        ),
      ]),
    );
  }

  Widget _row(String label, String value, {bool danger = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: DedsecColors.line)),
      ),
      child: Row(children: [
        Expanded(
          child: Text(label,
              style: DedsecFonts.body(size: 13, color: danger ? DedsecColors.danger : DedsecColors.ink)),
        ),
        Text(value, style: DedsecFonts.mono(size: 11, color: DedsecColors.inkDim)),
        const SizedBox(width: 6),
        Text('›', style: TextStyle(color: DedsecColors.inkMute)),
      ]),
    );
  }
}
