import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/fonts.dart';
import '../atoms/text_atoms.dart';
import '../molecules/token_stream_panel.dart';

class AnalysisPhaseSpec {
  final int id;
  final String label;
  final String tech;
  const AnalysisPhaseSpec(this.id, this.label, this.tech);
}

const kAnalysisPhases = <AnalysisPhaseSpec>[
  AnalysisPhaseSpec(0, 'lendo conteúdo ...', 'tokenize + chunk · 142 tokens'),
  AnalysisPhaseSpec(1, 'classificando tema ...', 'zero-shot · 20 categorias'),
  AnalysisPhaseSpec(2, 'identificando autoridades ...', 'lookup TSE + Câmara API'),
  AnalysisPhaseSpec(3, 'gerando título + resumo ...', 'gemma-3-1b · prompt cidadania'),
];

enum AnalysisPhaseState { idle, analyzing }

class AnalysisOverlay extends StatelessWidget {
  final AnalysisPhaseState phase;
  final int currentPhase;
  final String inputText;

  const AnalysisOverlay({
    super.key,
    required this.phase,
    required this.currentPhase,
    required this.inputText,
  });

  @override
  Widget build(BuildContext context) {
    if (phase != AnalysisPhaseState.analyzing) return const SizedBox.shrink();
    final cur = kAnalysisPhases[currentPhase.clamp(0, kAnalysisPhases.length - 1)];

    var inputTokens = inputText.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).take(10).toList();
    if (inputTokens.isEmpty) inputTokens = ['[vazio]'];
    inputTokens = ['[BOS]', ...inputTokens, '[EOS]'];

    const phaseOutputs = [
      ['lendo', '·', '142', 'tokens', '✓'],
      ['tema', '=', 'transporte', '(', '87%', ')', '✓'],
      ['autoridade', '=', 'prefeito', '·', 'câmara', '✓'],
      ['título', '=', 'linha', '17-ouro', '...', '✓'],
    ];
    final outputTokens = <String>[];
    for (var i = 0; i <= currentPhase && i < phaseOutputs.length; i++) {
      outputTokens.addAll(phaseOutputs[i]);
    }

    return Positioned.fill(
      child: Material(
        color: const Color(0xFA020608),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              decoration: const BoxDecoration(
                color: Color(0xFF050A08),
                border: Border(bottom: BorderSide(color: COL.line)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Blink(child: Container(width: 8, height: 8, color: COL.magenta)),
                      const SizedBox(width: 8),
                      const PixelChip('IA LOCAL · PROCESSANDO',
                          color: COL.magenta, size: 8),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const StencilSpans(
                    spans: [
                      TextSpan(text: 'ANALISANDO\n'),
                      TextSpan(text: 'PAUTA', style: TextStyle(color: COL.magenta)),
                    ],
                    size: 22,
                    height: 1.0,
                  ),
                  const SizedBox(height: 8),
                  Text('// ${cur.label}',
                      style: FONT.mono(size: 10, color: COL.acid, letterSpacing: 1.2)),
                  const SizedBox(height: 2),
                  Text('// ${cur.tech}', style: FONT.mono(size: 9, color: COL.inkMute)),
                ],
              ),
            ),
            TokenStreamPanel(
              inputTokens: inputTokens,
              outputTokens: outputTokens,
              modelLabel: 'GEMMA-3-1B · pt-BR',
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: COL.line)),
              ),
              child: Row(
                children: [
                  for (var i = 0; i < kAnalysisPhases.length; i++) ...[
                    if (i > 0) const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            height: 5,
                            decoration: BoxDecoration(
                              color: i <= currentPhase ? COL.magenta : COL.line,
                              boxShadow: i == currentPhase
                                  ? [BoxShadow(color: COL.magenta, blurRadius: 8)]
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            i < currentPhase ? '✓' : '${i + 1}',
                            style: FONT.pixel(
                              size: 7,
                              color: i == currentPhase
                                  ? COL.magenta
                                  : i < currentPhase
                                      ? COL.acid
                                      : COL.inkMute,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
