import 'dart:async';

import 'package:flutter/material.dart';

import '../app/app_scope.dart';
import '../app/app_state.dart';
import '../theme/colors.dart';
import '../theme/fonts.dart';
import '../widgets/atoms/buttons.dart';
import '../widgets/atoms/effects.dart';
import '../widgets/atoms/icons.dart';
import '../widgets/atoms/text_atoms.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _pct = 34;
  Timer? _t;

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(milliseconds: 160), (_) {
      if (!mounted) return;
      setState(() => _pct = _pct >= 100 ? 34 : _pct + 1);
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.read(context);
    return Container(
      color: COL.bg,
      child: Stack(
        children: [
          const Halftone(color: COL.magenta, size: 6, opacity: 0.18),
          const Scanlines(opacity: 0.12),
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Skull(size: 64, color: COL.ink),
                      const SizedBox(height: 22),
                      const Glitch(text: 'DEDSEC_BR', size: 24),
                      const SizedBox(height: 12),
                      Text(
                        '// CÉLULA CÍVICA LOCAL · v0.1.0',
                        style: FONT.mono(size: 10, color: COL.inkDim, letterSpacing: 2),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          Text('BAIXANDO_CÉREBRO_LOCAL',
                              style: FONT.mono(size: 11, color: COL.acid)),
                          const Spacer(),
                          Text('$_pct%',
                              style: FONT.mono(size: 11, color: COL.acid)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      PixelBar(value: _pct.toDouble(), color: COL.acid),
                      const SizedBox(height: 8),
                      Text(
                        'gemma-3-1b-it-q4.task · 530 MB · wifi recomendado',
                        style: FONT.mono(size: 9, color: COL.inkMute, letterSpacing: 1),
                      ),
                    ],
                  ),
                ),
              ),
              const CautionTape(text: 'NOS AGUARDE · NOS AGUARDE · NOS AGUARDE · ', color: COL.acid),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
                child: Row(
                  children: [
                    const Expanded(child: GhostBtn(full: true, color: COL.inkDim, child: Text('CANCELAR'))),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Btn(
                        full: true,
                        color: COL.magenta,
                        fg: Colors.white,
                        onPressed: () => state.go(AppRoute.onb1),
                        child: const Text('PULAR →'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
