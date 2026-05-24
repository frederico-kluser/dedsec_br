import 'package:flutter/material.dart';
import '../atoms/pixel_chip.dart';
import '../atoms/stencil.dart';
import '../molecules/token_stream_panel.dart';
import '../state/analysis.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';

class AnalysisOverlay extends StatelessWidget {
  final bool active; // phase === 'analyzing'
  final int currentPhase;
  final String inputText;
  const AnalysisOverlay({
    super.key,
    required this.active,
    required this.currentPhase,
    required this.inputText,
  });

  @override
  Widget build(BuildContext context) {
    if (!active) return const SizedBox.shrink();
    final cur = analysisPhases[currentPhase.clamp(0, analysisPhases.length - 1)];
    var inputTokens = inputText.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).take(10).toList();
    if (inputTokens.isEmpty) inputTokens = ['[vazio]'];
    inputTokens = ['[BOS]', ...inputTokens, '[EOS]'];

    final phaseOutputs = <List<String>>[
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
      child: Container(
        color: const Color(0xFA020608),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              color: Color(0xFF050A08),
              border: Border(bottom: BorderSide(color: DedsecColors.line)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(width: 8, height: 8, color: DedsecColors.magenta),
                const SizedBox(width: 8),
                const PixelChip('IA LOCAL · PROCESSANDO',
                    color: DedsecColors.magenta, size: 8),
              ]),
              const SizedBox(height: 8),
              StencilRich(
                size: 22,
                spans: const [
                  TextSpan(text: 'ANALISANDO\n'),
                  TextSpan(text: 'PAUTA', style: TextStyle(color: DedsecColors.magenta)),
                ],
              ),
              const SizedBox(height: 8),
              Text('// ${cur['label']}',
                  style: DedsecFonts.mono(size: 10, color: DedsecColors.acid, letterSpacing: 1.2)),
              const SizedBox(height: 2),
              Text('// ${cur['tech']}',
                  style: DedsecFonts.mono(size: 9, color: DedsecColors.inkMute)),
            ]),
          ),
          Expanded(child: TokenStreamPanel(
            inputTokens: inputTokens,
            outputTokens: outputTokens,
            modelLabel: 'GEMMA-3-1B · pt-BR',
          )),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: DedsecColors.line)),
            ),
            child: Row(children: [
              for (var i = 0; i < analysisPhases.length; i++)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: i == analysisPhases.length - 1 ? 0 : 6),
                    child: Column(children: [
                      Container(
                        height: 5,
                        color: i <= currentPhase ? DedsecColors.magenta : DedsecColors.line,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        i < currentPhase ? '✓' : '${i + 1}',
                        style: DedsecFonts.pixel(
                          size: 7,
                          color: i == currentPhase
                              ? DedsecColors.magenta
                              : i < currentPhase
                                  ? DedsecColors.acid
                                  : DedsecColors.inkMute,
                          letterSpacing: 1,
                        ),
                      ),
                    ]),
                  ),
                ),
            ]),
          ),
        ]),
      ),
    );
  }
}
