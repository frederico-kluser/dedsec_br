import 'dart:async';
import 'package:flutter/material.dart';
import '../atoms/btn.dart';
import '../atoms/caution_tape.dart';
import '../atoms/ghost_btn.dart';
import '../atoms/glitch.dart';
import '../atoms/halftone.dart';
import '../atoms/pixel_bar.dart';
import '../atoms/scanlines.dart';
import '../atoms/skull.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';
import '../widgets/screen_root.dart';
import 'route.dart';

class SplashPage extends StatefulWidget {
  final ValueChanged<DedsecScreen> onGo;
  const SplashPage({super.key, required this.onGo});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
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
    return ScreenRoot(
      child: Stack(children: [
        const Positioned.fill(child: Halftone(color: DedsecColors.magenta, size: 6, opacity: 0.18)),
        const Positioned.fill(child: Scanlines(opacity: 0.12)),
        Column(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Skull(size: 64),
                  const SizedBox(height: 22),
                  const Glitch(text: 'DEDSEC_BR', size: 24),
                  const SizedBox(height: 12),
                  Text('// CÉLULA CÍVICA LOCAL · v0.1.0',
                      style: DedsecFonts.mono(size: 10, color: DedsecColors.inkDim, letterSpacing: 2)),
                  const SizedBox(height: 40),
                  Row(children: [
                    Text('BAIXANDO_CÉREBRO_LOCAL',
                        style: DedsecFonts.mono(size: 11, color: DedsecColors.acid)),
                    const Spacer(),
                    Text('$_pct%', style: DedsecFonts.mono(size: 11, color: DedsecColors.acid)),
                  ]),
                  const SizedBox(height: 6),
                  PixelBar(value: _pct.toDouble(), color: DedsecColors.acid),
                  const SizedBox(height: 8),
                  Text('gemma-3-1b-it-q4.task · 530 MB · wifi recomendado',
                      style: DedsecFonts.mono(size: 9, color: DedsecColors.inkMute, letterSpacing: 1)),
                ],
              ),
            ),
          ),
          const CautionTape(text: 'NOS AGUARDE · NOS AGUARDE · NOS AGUARDE · ', color: DedsecColors.acid),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
            child: Row(children: [
              const Expanded(child: GhostBtn(label: 'CANCELAR', full: true, color: DedsecColors.inkDim)),
              const SizedBox(width: 10),
              Expanded(
                child: Btn(
                  label: 'PULAR →',
                  color: DedsecColors.magenta,
                  fg: Colors.white,
                  full: true,
                  onPressed: () => widget.onGo(DedsecScreen.onboarding),
                ),
              ),
            ]),
          ),
        ]),
      ]),
    );
  }
}
