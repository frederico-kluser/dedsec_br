import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/fonts.dart';
import '../../utils/use_tick.dart';
import '../atoms/effects.dart';

/// `molecules/TokenStreamPanel` — LLM input/output token stream visualisation.
class TokenStreamPanel extends StatelessWidget {
  final List<String> inputTokens;
  final List<String> outputTokens;
  final String modelLabel;

  static const List<String> _defInput = [
    '[BOS]', 'pauta:', 'linha', '17-', 'ouro', 'sp', 'atraso', '14', 'anos', 'custo', '3x', '[EOS]'
  ];
  static const List<String> _defOutput = [
    'A', ' Linha', ' 17-Ouro', ' do', ' metrô', ' atrasou', ' 14', ' anos', ' e', ' o', ' custo', ' triplicou', '.', ' Quem', ' paga', '?'
  ];

  const TokenStreamPanel({
    super.key,
    this.inputTokens = _defInput,
    this.outputTokens = _defOutput,
    this.modelLabel = 'GEMMA-3-1B',
  });

  @override
  Widget build(BuildContext context) {
    return TickBuilder(
      interval: const Duration(milliseconds: 180),
      builder: (_, t) {
        final cycleLength = outputTokens.length + 6;
        final cycle = t % cycleLength;
        final visible = math.min(outputTokens.length, cycle);
        final layer = (t ~/ 2) % 16 + 1;
        final tokPerSec = (12 + math.sin(t * 0.3) * 2).toStringAsFixed(1);
        final attnPct = (visible / outputTokens.length * 100).round();
        final kvKb = visible * 8 + inputTokens.length * 4;

        return Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
            child: Stack(
              children: [
                const Scanlines(opacity: 0.08),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        _Blink(child: Container(width: 8, height: 8, color: COL.acid)),
                        const SizedBox(width: 6),
                        Text(modelLabel,
                            style: FONT.pixel(size: 9, color: COL.acid, letterSpacing: 1)),
                        const Spacer(),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(text: 'layer '),
                              TextSpan(
                                text: '$layer',
                                style: FONT.mono(size: 9, color: COL.magenta),
                              ),
                              const TextSpan(text: '/16'),
                            ],
                            style: FONT.mono(size: 9, color: COL.inkDim),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A0D0A),
                        border: Border.all(color: COL.line, width: 1.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'INPUT · ${inputTokens.length} TOK',
                            style: FONT.pixel(size: 7, color: COL.inkMute, letterSpacing: 1.5),
                          ),
                          const SizedBox(height: 5),
                          Wrap(
                            spacing: 3,
                            runSpacing: 3,
                            children: [
                              for (final tk in inputTokens)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    border: Border.all(color: COL.line),
                                  ),
                                  child: Text(tk.trim().isEmpty ? '·' : tk.trim(),
                                      style: FONT.mono(size: 10, color: COL.inkDim)),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A0E0A),
                          border: Border.all(color: COL.acid, width: 1.5),
                          boxShadow: [
                            BoxShadow(color: COL.acid.withValues(alpha: 0.2), blurRadius: 16),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('GERANDO',
                                    style: FONT.pixel(size: 7, color: COL.acid, letterSpacing: 1.5)),
                                const Spacer(),
                                Text('$visible/${outputTokens.length} · $tokPerSec tok/s',
                                    style: FONT.mono(size: 9, color: COL.acid)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Wrap(
                                  spacing: 3,
                                  runSpacing: 3,
                                  children: [
                                    for (var i = 0; i < visible; i++)
                                      _OutputChip(
                                        text: outputTokens[i].trim().isEmpty
                                            ? '·'
                                            : outputTokens[i].trim(),
                                        fresh: i == visible - 1,
                                      ),
                                    if (visible < outputTokens.length)
                                      _Blink(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            border: Border.all(color: COL.acid, width: 1.5),
                                          ),
                                          child: Text('▮', style: FONT.mono(size: 11, color: COL.acid)),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 4,
                      children: [
                        Text.rich(TextSpan(
                          children: [
                            const TextSpan(text: 'attn: '),
                            TextSpan(text: '$attnPct%', style: TextStyle(color: COL.acid)),
                          ],
                          style: FONT.mono(size: 9, color: COL.inkMute),
                        )),
                        Text('·', style: FONT.mono(size: 9, color: COL.inkMute)),
                        Text.rich(TextSpan(
                          children: [
                            const TextSpan(text: 'kv: '),
                            TextSpan(text: '${kvKb}KB', style: TextStyle(color: COL.magenta)),
                            const TextSpan(text: '/256KB'),
                          ],
                          style: FONT.mono(size: 9, color: COL.inkMute),
                        )),
                        Text('·', style: FONT.mono(size: 9, color: COL.inkMute)),
                        Text('vocab: 32k', style: FONT.mono(size: 9, color: COL.inkMute)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _OutputChip extends StatelessWidget {
  final String text;
  final bool fresh;
  const _OutputChip({required this.text, required this.fresh});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: COL.acid,
        border: Border.all(color: Colors.black, width: 1.5),
        boxShadow: fresh
            ? const [BoxShadow(color: Colors.black, offset: Offset(2, 2))]
            : null,
      ),
      transform: fresh
          ? (Matrix4.identity()..scale(1.05))
          : Matrix4.identity(),
      transformAlignment: Alignment.center,
      child: Text(
        text,
        style: FONT.mono(size: 11, color: Colors.black, weight: fresh ? FontWeight.bold : null),
      ),
    );
  }
}

/// Shared blink animation widget used across the prototype.
class _Blink extends StatefulWidget {
  final Widget child;
  final Duration period;
  const _Blink({required this.child, this.period = const Duration(milliseconds: 700)});

  @override
  State<_Blink> createState() => _BlinkState();
}

class _BlinkState extends State<_Blink> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: widget.period)
    ..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) => Opacity(opacity: _c.value < 0.5 ? 1 : 0, child: widget.child),
    );
  }
}

/// Public re-export so screens can borrow the blink dot.
class Blink extends StatelessWidget {
  final Widget child;
  final Duration period;
  const Blink({super.key, required this.child, this.period = const Duration(milliseconds: 700)});

  @override
  Widget build(BuildContext context) => _Blink(period: period, child: child);
}
