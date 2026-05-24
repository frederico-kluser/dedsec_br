import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/fonts.dart';
import '../atoms/buttons.dart';
import '../atoms/effects.dart';
import '../atoms/icons.dart';
import '../atoms/text_atoms.dart';

enum ModerationPhase { idle, checking, blocked }

/// `organisms/ModerationOverlay` — full-bleed pre-publish moderation UI.
class ModerationOverlay extends StatelessWidget {
  final ModerationPhase phase;
  final String text;
  final String? word;
  final VoidCallback onEdit;
  final VoidCallback onDiscard;

  const ModerationOverlay({
    super.key,
    required this.phase,
    required this.text,
    required this.word,
    required this.onEdit,
    required this.onDiscard,
  });

  @override
  Widget build(BuildContext context) {
    if (phase == ModerationPhase.idle) return const SizedBox.shrink();
    final isCheck = phase == ModerationPhase.checking;
    return Positioned.fill(
      child: Material(
        color: const Color(0xF8050505),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const Scanlines(opacity: 0.1),
            if (isCheck) ..._buildChecking() else ..._buildBlocked(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildChecking() {
    return [
      for (var i = 0; i < 3; i++)
        _PulseOut(delay: Duration(milliseconds: i * 800), color: COL.acid),
      Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: COL.acid,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 4),
                  boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6))],
                ),
                child: const Stack(
                  alignment: Alignment.center,
                  children: [
                    Halftone(color: Colors.black, size: 6, opacity: 0.55),
                    Eye(size: 56, color: Colors.black),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              StencilSpans(
                spans: const [
                  TextSpan(text: 'MODERANDO COM\n'),
                  TextSpan(text: 'IA LOCAL', style: TextStyle(color: COL.acid)),
                ],
                size: 26,
                textAlign: TextAlign.center,
                height: 1.05,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 6, height: 6, color: COL.acid),
                  const SizedBox(width: 6),
                  Text('gemma-3-1b · classificando ódio/spam ...',
                      style: FONT.mono(size: 10, color: COL.acid, letterSpacing: 1.5)),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: COL.panel,
                  border: Border.all(color: COL.line),
                ),
                constraints: const BoxConstraints(maxWidth: 320),
                child: Text('"$text"',
                    textAlign: TextAlign.center,
                    style: FONT.mono(size: 11, color: COL.inkDim, height: 1.5)),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildBlocked() {
    return [
      const Halftone(color: COL.danger, size: 5, opacity: 0.18),
      Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              Transform.rotate(
                angle: -2 * 3.14159 / 180,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: const BoxDecoration(
                    color: COL.danger,
                    boxShadow: [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                  ),
                  child: Text('BLOQUEADO',
                      style: FONT.pixel(size: 11, color: Colors.black, letterSpacing: 2)),
                ),
              ),
              const SizedBox(height: 18),
              StencilSpans(
                spans: [
                  const TextSpan(text: 'DISCURSO\n'),
                  TextSpan(
                    text: 'OFENSIVO',
                    style: TextStyle(
                      color: COL.danger,
                      shadows: const [Shadow(offset: Offset(3, 3), color: COL.magenta)],
                    ),
                  ),
                ],
                size: 34,
                textAlign: TextAlign.center,
                height: 1.0,
              ),
              const SizedBox(height: 14),
              Text(
                '// a ia local detectou conteúdo que pode\n// violar as regras da comunidade.',
                textAlign: TextAlign.center,
                style: FONT.mono(size: 11, color: COL.inkDim, height: 1.55),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                constraints: const BoxConstraints(maxWidth: 320),
                decoration: BoxDecoration(
                  color: COL.panel,
                  border: Border.all(color: COL.danger, width: 1.5),
                ),
                child: Column(
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          const TextSpan(text: 'sinal: '),
                          TextSpan(
                            text: '"${word ?? ''}"',
                            style: const TextStyle(color: COL.danger, fontWeight: FontWeight.bold),
                          ),
                        ],
                        style: FONT.mono(size: 11, color: COL.ink, height: 1.5),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('categoria: discurso de ódio',
                        style: FONT.mono(size: 9, color: COL.inkMute)),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GhostBtn(
                    color: COL.inkDim,
                    onPressed: onDiscard,
                    child: const Text('DESCARTAR'),
                  ),
                  const SizedBox(width: 10),
                  Btn(
                    color: COL.acid,
                    onPressed: onEdit,
                    child: const Text('EDITAR ✎'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ];
  }
}

class _PulseOut extends StatefulWidget {
  final Duration delay;
  final Color color;
  const _PulseOut({required this.delay, required this.color});

  @override
  State<_PulseOut> createState() => _PulseOutState();
}

class _PulseOutState extends State<_PulseOut> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) _c.repeat();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, __) {
          final scale = 0.4 + _c.value * 1.0;
          final opacity = 0.8 * (1 - _c.value);
          return Transform.scale(
            scale: scale,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    widget.color.withValues(alpha: opacity * 0.33),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.6],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
