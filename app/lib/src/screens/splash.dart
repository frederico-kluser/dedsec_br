import 'dart:async';

import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../design/colors.dart';
import '../design/fonts.dart';
import '../widgets/atoms.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _pct = 34;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 160), (_) {
      if (mounted) setState(() => _pct = _pct >= 100 ? 34 : _pct + 1);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return Container(
      color: DCol.bg,
      child: Stack(
        children: [
          const Positioned.fill(child: Halftone(color: DCol.magenta, size: 6, opacity: 0.18)),
          const Positioned.fill(child: Scanlines(opacity: 0.12)),
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Skull(size: 64, color: DCol.ink),
                      const SizedBox(height: 22),
                      const Glitch('DEDSEC_BR', size: 24),
                      const SizedBox(height: 12),
                      Text('// CÉLULA CÍVICA LOCAL · v0.1.0',
                          style: DFont.mono(
                              size: 10, color: DCol.inkDim, letterSpacing: 2)),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('BAIXANDO_CÉREBRO_LOCAL',
                              style: DFont.mono(size: 11, color: DCol.acid)),
                          Text('${_pct.toInt()}%',
                              style: DFont.mono(size: 11, color: DCol.acid)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      PixelBar(value: _pct),
                      const SizedBox(height: 8),
                      Text(
                        'gemma-3-1b-it-q4.task · 530 MB · wifi recomendado',
                        style: DFont.mono(size: 9, color: DCol.inkMute, letterSpacing: 1),
                      ),
                    ],
                  ),
                ),
              ),
              const CautionTape(text: 'NOS AGUARDE · NOS AGUARDE · NOS AGUARDE · ', color: DCol.acid),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
                child: Row(
                  children: [
                    const Expanded(child: GhostBtn(label: 'CANCELAR', full: true, color: DCol.inkDim)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Btn(
                        label: 'PULAR →',
                        color: DCol.magenta,
                        fg: Colors.white,
                        full: true,
                        onPressed: () => app.go(Screen.onboarding),
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
