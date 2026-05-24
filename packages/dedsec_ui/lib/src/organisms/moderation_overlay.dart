import 'package:flutter/material.dart';
import '../atoms/btn.dart';
import '../atoms/eye.dart';
import '../atoms/ghost_btn.dart';
import '../atoms/halftone.dart';
import '../atoms/scanlines.dart';
import '../atoms/stencil.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';

enum ModerationPhase { idle, checking, blocked }

class ModerationOverlay extends StatefulWidget {
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
  State<ModerationOverlay> createState() => _ModerationOverlayState();
}

class _ModerationOverlayState extends State<ModerationOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this, duration: const Duration(seconds: 2),
  )..repeat();

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.phase == ModerationPhase.idle) return const SizedBox.shrink();
    final isCheck = widget.phase == ModerationPhase.checking;

    return Positioned.fill(
      child: Container(
        color: const Color(0xF7050505),
        padding: const EdgeInsets.all(22),
        child: Stack(children: [
          const Positioned.fill(child: Scanlines(opacity: 0.1)),
          if (isCheck) _checkContent() else _blockedContent(),
        ]),
      ),
    );
  }

  Widget _checkContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _pulse,
          builder: (_, __) => Container(
            width: 140, height: 140,
            decoration: BoxDecoration(
              color: DedsecColors.acid,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 4),
              boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6))],
            ),
            child: ClipOval(
              child: Stack(alignment: Alignment.center, children: const [
                Positioned.fill(child: Halftone(color: Colors.black, size: 6, opacity: 0.55)),
                Eye(size: 56, color: Colors.black),
              ]),
            ),
          ),
        ),
        const SizedBox(height: 22),
        StencilRich(
          textAlign: TextAlign.center,
          size: 26,
          spans: const [
            TextSpan(text: 'MODERANDO COM\n'),
            TextSpan(text: 'IA LOCAL', style: TextStyle(color: DedsecColors.acid)),
          ],
        ),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(width: 6, height: 6, color: DedsecColors.acid),
          const SizedBox(width: 6),
          Text('gemma-3-1b · classificando ódio/spam ...',
              style: DedsecFonts.mono(size: 10, color: DedsecColors.acid, letterSpacing: 1.5)),
        ]),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: DedsecColors.panel,
            border: Border.all(color: DedsecColors.line, style: BorderStyle.solid),
          ),
          child: Text('"${widget.text}"',
              textAlign: TextAlign.center,
              style: DedsecFonts.mono(size: 11, color: DedsecColors.inkDim)),
        ),
      ],
    );
  }

  Widget _blockedContent() {
    return Stack(children: [
      const Positioned.fill(child: Halftone(color: DedsecColors.danger, size: 5, opacity: 0.18)),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.rotate(
            angle: -0.035,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: const BoxDecoration(
                color: DedsecColors.danger,
                boxShadow: [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
              ),
              child: Text('BLOQUEADO',
                  style: DedsecFonts.pixel(size: 11, color: Colors.black, letterSpacing: 2)),
            ),
          ),
          const SizedBox(height: 18),
          StencilRich(
            textAlign: TextAlign.center,
            size: 34,
            spans: const [
              TextSpan(text: 'DISCURSO\n'),
              TextSpan(
                text: 'OFENSIVO',
                style: TextStyle(
                  color: DedsecColors.danger,
                  shadows: [Shadow(color: DedsecColors.magenta, offset: Offset(3, 3))],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            '// a ia local detectou conteúdo que pode\n// violar as regras da comunidade.',
            textAlign: TextAlign.center,
            style: DedsecFonts.mono(size: 11, color: DedsecColors.inkDim),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            constraints: const BoxConstraints(maxWidth: 320),
            decoration: BoxDecoration(
              color: DedsecColors.panel,
              border: Border.all(color: DedsecColors.danger, width: 1.5),
            ),
            child: Column(children: [
              Text.rich(TextSpan(
                style: DedsecFonts.mono(size: 11, color: DedsecColors.ink),
                children: [
                  const TextSpan(text: 'sinal: '),
                  TextSpan(
                    text: '"${widget.word ?? '?'}"',
                    style: const TextStyle(color: DedsecColors.danger, fontWeight: FontWeight.w700),
                  ),
                ],
              )),
              const SizedBox(height: 4),
              Text('categoria: discurso de ódio',
                  style: DedsecFonts.mono(size: 9, color: DedsecColors.inkMute)),
            ]),
          ),
          const SizedBox(height: 22),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            GhostBtn(label: 'DESCARTAR', color: DedsecColors.inkDim, onPressed: widget.onDiscard),
            const SizedBox(width: 10),
            Btn(label: 'EDITAR ✎', color: DedsecColors.acid, onPressed: widget.onEdit),
          ]),
        ],
      ),
    ]);
  }
}
