import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../atoms/scanlines.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';

/// Visualization of LLM input + output tokens streaming.
/// Reusable both as L7 loader and inside Help/NewPost overlays.
class TokenStreamPanel extends StatefulWidget {
  final List<String> inputTokens;
  final List<String> outputTokens;
  final String modelLabel;

  const TokenStreamPanel({
    super.key,
    this.inputTokens = const [
      '[BOS]', 'pauta:', 'linha', '17-', 'ouro', 'sp',
      'atraso', '14', 'anos', 'custo', '3x', '[EOS]',
    ],
    this.outputTokens = const [
      'A', ' Linha', ' 17-Ouro', ' do', ' metrô', ' atrasou',
      ' 14', ' anos', ' e', ' o', ' custo', ' triplicou', '.',
      ' Quem', ' paga', '?'
    ],
    this.modelLabel = 'GEMMA-3-1B',
  });

  @override
  State<TokenStreamPanel> createState() => _TokenStreamPanelState();
}

class _TokenStreamPanelState extends State<TokenStreamPanel> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 180),
  )..addListener(() {
      if (!mounted) return;
      setState(() => _tick++);
    });
  int _tick = 0;
  late int _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = 0;
    // Poll every 180ms via Ticker — use a periodic re-render via animation
    _c.repeat();
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 180));
      if (!mounted) return false;
      setState(() => _ticker++);
      return true;
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = _ticker;
    final cycleLength = widget.outputTokens.length + 6;
    final cycle = t % cycleLength;
    final visible = math.min(widget.outputTokens.length, cycle);
    final layer = (t ~/ 2) % 16 + 1;
    final tokPerSec = (12 + math.sin(t * 0.3) * 2).toStringAsFixed(1);
    final attnPct = (visible / widget.outputTokens.length * 100).round();
    final kvKb = visible * 8 + widget.inputTokens.length * 4;

    return Stack(children: [
      Positioned.fill(
        child: Container(
          color: const Color(0xFF020608),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              Container(width: 8, height: 8, color: DedsecColors.acid),
              const SizedBox(width: 6),
              Text(widget.modelLabel,
                  style: DedsecFonts.pixel(size: 9, color: DedsecColors.acid, letterSpacing: 1)),
              const Spacer(),
              RichText(
                text: TextSpan(
                  style: DedsecFonts.mono(size: 9, color: DedsecColors.inkDim),
                  children: [
                    const TextSpan(text: 'layer '),
                    TextSpan(text: '$layer', style: const TextStyle(color: DedsecColors.magenta)),
                    const TextSpan(text: '/16'),
                  ],
                ),
              ),
            ]),
            const SizedBox(height: 10),
            // INPUT
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0D0A),
                border: Border.all(color: DedsecColors.line, width: 1.5),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('INPUT · ${widget.inputTokens.length} TOK',
                    style: DedsecFonts.pixel(size: 7, color: DedsecColors.inkMute, letterSpacing: 1.5)),
                const SizedBox(height: 5),
                Wrap(
                  spacing: 3, runSpacing: 3,
                  children: [
                    for (final tk in widget.inputTokens)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(color: DedsecColors.line),
                        ),
                        child: Text(tk.trim().isEmpty ? '·' : tk,
                            style: DedsecFonts.mono(size: 10, color: DedsecColors.inkDim)),
                      ),
                  ],
                ),
              ]),
            ),
            const SizedBox(height: 8),
            // OUTPUT
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A0E0A),
                  border: Border.all(color: DedsecColors.acid, width: 1.5),
                  boxShadow: [BoxShadow(color: DedsecColors.acid.withOpacity(0.2), blurRadius: 16)],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Row(children: [
                    Text('GERANDO',
                        style: DedsecFonts.pixel(size: 7, color: DedsecColors.acid, letterSpacing: 1.5)),
                    const Spacer(),
                    Text('$visible/${widget.outputTokens.length} · $tokPerSec tok/s',
                        style: DedsecFonts.mono(size: 9, color: DedsecColors.acid)),
                  ]),
                  const SizedBox(height: 6),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 3, runSpacing: 3,
                        children: [
                          for (var i = 0; i < visible; i++)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: DedsecColors.acid,
                                border: Border.all(color: Colors.black, width: 1.5),
                              ),
                              child: Text(
                                widget.outputTokens[i].trim().isEmpty ? '·' : widget.outputTokens[i],
                                style: DedsecFonts.mono(
                                  size: 11,
                                  color: Colors.black,
                                  weight: i == visible - 1 ? FontWeight.w700 : FontWeight.w400,
                                ),
                              ),
                            ),
                          if (visible < widget.outputTokens.length)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                border: Border.all(color: DedsecColors.acid, width: 1.5),
                              ),
                              child: Text('▮',
                                  style: DedsecFonts.mono(size: 11, color: DedsecColors.acid)),
                            ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              children: [
                Text.rich(TextSpan(
                  style: DedsecFonts.mono(size: 9, color: DedsecColors.inkMute),
                  children: [
                    const TextSpan(text: 'attn: '),
                    TextSpan(text: '$attnPct%', style: const TextStyle(color: DedsecColors.acid)),
                  ],
                )),
                Text('·', style: DedsecFonts.mono(size: 9, color: DedsecColors.inkMute)),
                Text.rich(TextSpan(
                  style: DedsecFonts.mono(size: 9, color: DedsecColors.inkMute),
                  children: [
                    const TextSpan(text: 'kv: '),
                    TextSpan(text: '${kvKb}KB', style: const TextStyle(color: DedsecColors.magenta)),
                    const TextSpan(text: '/256KB'),
                  ],
                )),
                Text('·', style: DedsecFonts.mono(size: 9, color: DedsecColors.inkMute)),
                Text('vocab: 32k', style: DedsecFonts.mono(size: 9, color: DedsecColors.inkMute)),
              ],
            ),
          ]),
        ),
      ),
      const Positioned.fill(child: IgnorePointer(child: Scanlines(opacity: 0.08))),
    ]);
  }
}
