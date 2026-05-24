import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/fonts.dart';
import '../../utils/scramble.dart';
import '../../utils/use_tick.dart';
import '../atoms/effects.dart';
import '../atoms/icons.dart';
import '../atoms/text_atoms.dart';
import '../molecules/token_stream_panel.dart';

// ───────────────────────────────────────────────────────────────
// L1 · LoaderTerminal — CRT boot log scroll.
// ───────────────────────────────────────────────────────────────
class LoaderTerminal extends StatefulWidget {
  const LoaderTerminal({super.key});
  @override
  State<LoaderTerminal> createState() => _LoaderTerminalState();
}

class _LoaderTerminalState extends State<LoaderTerminal> {
  static const _lines = <_TermLine>[
    _TermLine(100, '> dedsec_br célula · v0.1.0-beta'),
    _TermLine(200, '> kernel: montando /local/cérebro/'),
    _TermLine(300, '  ↳ gemma-3-1b-it.q4.task  [530MB]'),
    _TermLine(600, '  ↳ verificando integridade ..... OK'),
    _TermLine(900, '> aquecendo tokenizador ........ OK'),
    _TermLine(1200, '> descobrindo peers ............ 312 nós'),
    _TermLine(1500, '> handshake da malha (libp2p) .. OK'),
    _TermLine(1800, '> baixando pautas/sp/2026-05-23.'),
    _TermLine(2100, '  ↳ 4 itens · 12 fontes'),
    _TermLine(2400, '> uuid_hash = 9f4a-...-7c12'),
    _TermLine(2700, '> identidade selada (sem login)'),
    _TermLine(3000, '> NOS AGUARDE'),
    _TermLine(3300, '> pronto.'),
  ];

  int _visible = 0;
  final List<Timer> _timers = [];

  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() {
    setState(() => _visible = 0);
    for (var i = 0; i < _lines.length; i++) {
      final l = _lines[i];
      _timers.add(Timer(Duration(milliseconds: l.delay), () {
        if (mounted) setState(() => _visible = math.max(_visible, i + 1));
      }));
    }
    _timers.add(Timer(const Duration(milliseconds: 5000), () {
      if (mounted) _start();
    }));
  }

  @override
  void dispose() {
    for (final t in _timers) {
      t.cancel();
    }
    super.dispose();
  }

  Color _lineColor(String t) {
    if (t.contains('AGUARDE')) return COL.magenta;
    if (t.contains('OK')) return COL.acid;
    if (t.startsWith('  ↳')) return const Color(0xFF7FB800);
    return COL.acid;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF020602),
      child: Stack(
        children: [
          const Scanlines(opacity: 0.22),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 22, 18, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: COL.acid.withValues(alpha: 0.33)),
                    ),
                  ),
                  child: Text(
                    'DEDSEC_BR :: INICIANDO  ░░░░░  TTY1',
                    style: FONT.pixel(size: 9, color: COL.acid, letterSpacing: 2),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: _visible + 1,
                    itemBuilder: (_, i) {
                      if (i >= _visible) {
                        return Blink(
                          child: Container(width: 8, height: 14, color: COL.acid),
                        );
                      }
                      final l = _lines[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          l.text,
                          style: FONT.mono(
                            size: 12,
                            color: _lineColor(l.text),
                            height: 1.7,
                          ).copyWith(shadows: const [
                            Shadow(color: Color(0x66B7FF2A), blurRadius: 6),
                          ]),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Blink(child: Container(width: 6, height: 6, color: COL.acid)),
                    const SizedBox(width: 8),
                    Text(
                      'REDE_AO_VIVO · 312 PEERS · TX/RX 4.2KB/s',
                      style: FONT.pixel(size: 8, color: COL.acid, letterSpacing: 1.5),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TermLine {
  final int delay;
  final String text;
  const _TermLine(this.delay, this.text);
}

// ───────────────────────────────────────────────────────────────
// L2 · LoaderHalftone — pop-art breathing pulse.
// ───────────────────────────────────────────────────────────────
class LoaderHalftone extends StatelessWidget {
  const LoaderHalftone({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: COL.bg,
      child: TickBuilder(
        interval: const Duration(milliseconds: 60),
        builder: (_, t) {
          const target = 'NOS AGUARDE';
          final lock = math.min(target.length, (t % 60) ~/ 4);
          return Stack(
            alignment: Alignment.center,
            children: [
              for (var i = 0; i < 3; i++)
                _PulseRing(delay: Duration(milliseconds: i * 800), color: COL.magenta),
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  color: COL.magenta,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 4),
                  boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(8, 8))],
                ),
                child: const ClipOval(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Halftone(color: Colors.black, size: 6, opacity: 0.7),
                      Skull(size: 90, color: Colors.white),
                      Grain(opacity: 0.18),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 80,
                child: Column(
                  children: [
                    Glitch(text: scramble(target, t, lock), size: 28),
                    const SizedBox(height: 14),
                    Text('// DECIFRANDO PAUTA ...',
                        style: FONT.mono(size: 10, color: COL.inkDim, letterSpacing: 2)),
                  ],
                ),
              ),
              Positioned(
                bottom: 22,
                left: 22,
                right: 22,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('0xDED5EC',
                        style: FONT.pixel(size: 8, color: COL.inkMute, letterSpacing: 1.5)),
                    Text('● AO VIVO',
                        style: FONT.pixel(size: 8, color: COL.magenta, letterSpacing: 1.5)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PulseRing extends StatefulWidget {
  final Duration delay;
  final Color color;
  const _PulseRing({required this.delay, required this.color});
  @override
  State<_PulseRing> createState() => _PulseRingState();
}

class _PulseRingState extends State<_PulseRing> with SingleTickerProviderStateMixin {
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
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        return Transform.scale(
          scale: 0.4 + _c.value * 1.0,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  widget.color.withValues(alpha: 0.4 * (1 - _c.value)),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.6],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ───────────────────────────────────────────────────────────────
// L3 · LoaderRadar — P2P sweep.
// ───────────────────────────────────────────────────────────────
class LoaderRadar extends StatefulWidget {
  const LoaderRadar({super.key});
  @override
  State<LoaderRadar> createState() => _LoaderRadarState();
}

class _LoaderRadarState extends State<LoaderRadar> with SingleTickerProviderStateMixin {
  late final AnimationController _sweep = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat();

  @override
  void dispose() {
    _sweep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF040805),
      child: TickBuilder(
        interval: const Duration(milliseconds: 120),
        builder: (_, t) {
          return Stack(
            alignment: Alignment.center,
            children: [
              const Scanlines(opacity: 0.12),
              Positioned(
                top: 22,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('// RASTREIO_REDE',
                        style: FONT.pixel(size: 9, color: COL.acid, letterSpacing: 2)),
                    Text('● 312',
                        style: FONT.pixel(size: 9, color: COL.acid, letterSpacing: 2)),
                  ],
                ),
              ),
              SizedBox(
                width: 280,
                height: 280,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: COL.acid.withValues(alpha: 0.4), width: 1.5),
                        boxShadow: [
                          BoxShadow(color: COL.acid.withValues(alpha: 0.13), blurRadius: 30),
                        ],
                      ),
                    ),
                    for (var r = 1; r <= 3; r++)
                      Container(
                        width: (r * 70).toDouble(),
                        height: (r * 70).toDouble(),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: COL.acid.withValues(alpha: 0.2)),
                        ),
                      ),
                    Container(width: 1, height: 280, color: COL.acid.withValues(alpha: 0.2)),
                    Container(width: 280, height: 1, color: COL.acid.withValues(alpha: 0.2)),
                    AnimatedBuilder(
                      animation: _sweep,
                      builder: (_, __) {
                        return Transform.rotate(
                          angle: _sweep.value * 2 * math.pi,
                          child: CustomPaint(
                            size: const Size(280, 280),
                            painter: _RadarBeam(),
                          ),
                        );
                      },
                    ),
                    for (var i = 0; i < 14; i++) _radarBlip(i, t),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: COL.magenta,
                        boxShadow: [BoxShadow(color: COL.magenta, blurRadius: 16)],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 60,
                child: Column(
                  children: [
                    Stencil('BUSCANDO CÉLULAS', size: 26, textAlign: TextAlign.center),
                    const SizedBox(height: 6),
                    Text(
                      '${312 + (t % 20)} peers ativos · são paulo',
                      style: FONT.mono(size: 11, color: COL.inkDim, letterSpacing: 2),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 22,
                left: 22,
                right: 22,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('P2P · libp2p',
                        style: FONT.pixel(size: 8, color: COL.acid, letterSpacing: 1.5)),
                    Text('RSSI -42 dB',
                        style: FONT.pixel(size: 8, color: COL.acid, letterSpacing: 1.5)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _radarBlip(int i, int t) {
    final angle = (i * 67) % 360;
    final radius = (30 + (i * 23) % 100).toDouble();
    final ageMs = t * 120 - i * 200;
    final visible = ageMs > 0 && (ageMs % 2400) < 1200;
    final opacity = visible ? math.max(0, 1 - (ageMs % 2400) / 1200) : 0;
    final x = math.cos(angle * math.pi / 180) * radius;
    final y = math.sin(angle * math.pi / 180) * radius;
    return Positioned(
      left: 140 + x - 4,
      top: 140 + y - 4,
      child: Opacity(
        opacity: opacity.toDouble().clamp(0, 1),
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: COL.acid,
            boxShadow: [BoxShadow(color: COL.acid, blurRadius: 8)],
          ),
        ),
      ),
    );
  }
}

class _RadarBeam extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [COL.acid, COL.acid.withValues(alpha: 0.4), Colors.transparent],
        stops: const [0.0, 0.3, 1.0],
      ).createShader(Rect.fromLTWH(cx, cy - 1, cx, 2));
    canvas.drawRect(Rect.fromLTWH(cx, cy - 1, cx, 2), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ───────────────────────────────────────────────────────────────
// L4 · LoaderDataTape — vertical streaming tape.
// ───────────────────────────────────────────────────────────────
class LoaderDataTape extends StatelessWidget {
  const LoaderDataTape({super.key});

  static const _stream = <String>[
    '01001000 01100001 01100011 01101011',
    'pauta_atualizada :: linha-17-ouro',
    'rede_cidadã ▓▓▓▓ 67%',
    '████████ █████████ ███ ██████',
    'classify(pt-BR) → transporte · urgente',
    'sha256: 9f4a3c12bb98ef...7c12',
    'embedding · 384d · cos=0.81',
    '[CENSURADO] [CENSURADO] [CENSURADO]',
    '0xCAFEBABE :: peer/sp-cidadão-bb22',
    'gemma · token 142/512',
    'queridodiario.api ............ 200',
    'tse.dadosabertos.api ......... 200',
    'fcm.push.batch ............... fila',
    'consenso(2/3) :: confirmado',
    '01000101 01011000 01010000 01000101',
    '> estamos chegando · 4328 hoje',
  ];

  Color _color(String line) {
    if (line.contains('[CENSURADO]')) return COL.inkMute;
    if (line.contains('████')) return const Color(0xFF444444);
    if (line.contains('chegando')) return COL.magenta;
    if (RegExp(r'^[01 ]+$').hasMatch(line)) return COL.acid.withValues(alpha: 0.67);
    if (line.contains('200')) return COL.acid;
    return COL.ink;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: TickBuilder(
        interval: const Duration(milliseconds: 80),
        builder: (_, t) {
          final idx = t % _stream.length;
          return Stack(
            children: [
              const Scanlines(opacity: 0.15),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 20, 18, 10),
                    child: Row(
                      children: [
                        Blink(child: Container(width: 10, height: 10, color: COL.magenta)),
                        const SizedBox(width: 10),
                        Text('TRANSMITINDO',
                            style: FONT.pixel(size: 10, color: COL.magenta, letterSpacing: 2)),
                        const Spacer(),
                        Text('${(t * 0.42).toStringAsFixed(1)} KB/s',
                            style: FONT.mono(size: 10, color: COL.inkDim)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF040404),
                        border: Border.all(color: COL.line),
                      ),
                      child: ClipRect(
                        child: Stack(
                          children: [
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 200),
                              top: -idx * 22.0,
                              left: 0,
                              right: 0,
                              child: Column(
                                children: [
                                  for (final line in [..._stream, ..._stream, ..._stream])
                                    SizedBox(
                                      height: 22,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(line, style: FONT.mono(size: 11, color: _color(line))),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 22),
                    child: Row(
                      children: [
                        Glitch(text: 'SINCRONIZANDO', size: 16),
                        const Spacer(),
                        Text(
                          '${math.min(99, 12 + t).toString().padLeft(2, '0')}%',
                          style: FONT.pixel(size: 9, color: COL.acid),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// L5 · LoaderCounter — big counter + skull burst.
// ───────────────────────────────────────────────────────────────
class LoaderCounter extends StatelessWidget {
  const LoaderCounter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: COL.bg,
      child: TickBuilder(
        interval: const Duration(milliseconds: 140),
        builder: (_, t) {
          final base = 4328 + t;
          final burst = (t % 4) == 0;
          return Stack(
            children: [
              const Halftone(color: COL.acid, size: 6, opacity: 0.08),
              const Scanlines(opacity: 0.1),
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('// MUTIRÃO', style: FONT.pixel(size: 9, color: COL.acid)),
                        Text('SÃO PAULO', style: FONT.pixel(size: 9, color: COL.inkDim)),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      'PAUTAS PROCESSADAS HOJE',
                      style: FONT.pixel(size: 10, color: COL.inkDim, letterSpacing: 2),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Stencil(
                            base.toString().replaceAllMapped(
                              RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
                              (m) => '${m[1]}.',
                            ),
                            size: 96,
                            color: COL.ink,
                            height: 0.9,
                            shadows: const [
                              Shadow(offset: Offset(4, 4), color: COL.magenta),
                              Shadow(offset: Offset(-4, -4), color: COL.acid),
                            ],
                          ),
                          if (burst) ...[
                            const Positioned(
                              top: -10,
                              right: -36,
                              child: Skull(size: 28, color: COL.acid),
                            ),
                            const Positioned(
                              bottom: -10,
                              left: -36,
                              child: Skull(size: 24, color: COL.magenta),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var i = 0; i < 20; i++) ...[
                          if (i > 0) const SizedBox(width: 6),
                          Container(
                            width: 6,
                            height: 18,
                            decoration: BoxDecoration(
                              color: i <= (t % 20) ? COL.acid : COL.line,
                              boxShadow: i == (t % 20)
                                  ? [BoxShadow(color: COL.acid, blurRadius: 10)]
                                  : null,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: COL.acid, width: 1.5),
                      ),
                      child: Text.rich(
                        TextSpan(children: [
                          const TextSpan(text: '+1 célula entrou agora · cidadão_'),
                          TextSpan(
                            text: 'sp_${(t * 7).toRadixString(16).padLeft(4, '0').substring(0, 4)}',
                            style: const TextStyle(color: COL.magenta),
                          ),
                        ], style: FONT.mono(size: 11, color: COL.acid)),
                      ),
                    ),
                    const Spacer(),
                    Text('SINCRONIZANDO FEED LOCAL ...',
                        style: FONT.pixel(size: 9, color: COL.inkMute, letterSpacing: 1.5)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// L6 · LoaderGlitch — heavy RGB-split + comic burst.
// ───────────────────────────────────────────────────────────────
class LoaderGlitch extends StatelessWidget {
  const LoaderGlitch({super.key});

  @override
  Widget build(BuildContext context) {
    return TickBuilder(
      interval: const Duration(milliseconds: 50),
      builder: (_, t) {
        const phases = ['ACESSANDO', 'DECIFRANDO', 'COMPILANDO', 'LIBERADO'];
        final phase = phases[(t ~/ 30) % phases.length];
        final lock = math.min(phase.length, (t % 30) ~/ 3);
        final offsetX = (t % 4) - 2;
        final offsetY = ((t * 3) % 4) - 2;
        return Container(
          color: Colors.black,
          child: Stack(
            alignment: Alignment.center,
            children: [
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                children: [
                  Stack(children: const [
                    DecoratedBox(decoration: BoxDecoration(color: COL.magenta), child: SizedBox.expand()),
                    Halftone(color: Colors.black, size: 5, opacity: 0.6),
                  ]),
                  Stack(children: const [
                    DecoratedBox(decoration: BoxDecoration(color: Colors.black), child: SizedBox.expand()),
                    Halftone(color: COL.acid, size: 4, opacity: 0.3),
                  ]),
                  Stack(children: const [
                    DecoratedBox(decoration: BoxDecoration(color: Colors.black), child: SizedBox.expand()),
                    Halftone(color: COL.magenta, size: 4, opacity: 0.3),
                  ]),
                  Stack(children: const [
                    DecoratedBox(decoration: BoxDecoration(color: COL.acid), child: SizedBox.expand()),
                    Halftone(color: Colors.black, size: 5, opacity: 0.6),
                  ]),
                ],
              ),
              Transform.translate(
                offset: Offset(offsetX.toDouble(), offsetY.toDouble()),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: COL.magenta,
                        offset: Offset(offsetX * 3.0, offsetY * 3.0),
                      ),
                      BoxShadow(
                        color: COL.acid,
                        offset: Offset(-offsetX * 3.0, -offsetY * 3.0),
                      ),
                    ],
                  ),
                  child: Text('DEDSEC_BR',
                      style: FONT.pixel(size: 26, color: Colors.white, letterSpacing: 2)),
                ),
              ),
              Positioned(
                top: 60,
                right: 24,
                child: Transform.rotate(
                  angle: ((-12 + (t % 6)) * math.pi / 180),
                  child: Container(
                    width: 84,
                    height: 84,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                    ),
                    child: Text(
                      'NOS\nAGUARDE!',
                      textAlign: TextAlign.center,
                      style: FONT.pixel(size: 8, color: Colors.black, height: 1.3),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 80,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      constraints: const BoxConstraints(minWidth: 240),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.white, width: 2.5),
                        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                      ),
                      child: Column(
                        children: [
                          Text(
                            '// STATUS',
                            style: FONT.mono(size: 10, color: COL.inkDim, letterSpacing: 2),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${scramble(phase, t, lock)}...',
                            style: FONT.pixel(size: 16, color: COL.acid, letterSpacing: 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var i = 0; i < 8; i++) ...[
                          if (i > 0) const SizedBox(width: 4),
                          Container(
                            width: 22,
                            height: 6,
                            color: i <= (t % 8) ? Colors.white : const Color(0xFF333333),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const Grain(opacity: 0.15),
            ],
          ),
        );
      },
    );
  }
}

// ───────────────────────────────────────────────────────────────
// L7 · LoaderTokenStream — wraps the shared TokenStreamPanel.
// ───────────────────────────────────────────────────────────────
class LoaderTokenStream extends StatelessWidget {
  const LoaderTokenStream({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF020608),
      child: const Column(children: [TokenStreamPanel()]),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// L8 · LoaderBinaryRain — matrix-style.
// ───────────────────────────────────────────────────────────────
class LoaderBinaryRain extends StatelessWidget {
  const LoaderBinaryRain({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF020602),
      child: Stack(
        children: [
          const Scanlines(opacity: 0.08),
          Row(
            children: [
              for (var i = 0; i < 14; i++)
                Expanded(child: _RainCol(seed: i)),
            ],
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: COL.acid, width: 2),
                boxShadow: const [BoxShadow(color: COL.magenta, offset: Offset(5, 5))],
              ),
              child: Column(
                children: [
                  Text('DECIFRANDO',
                      style: FONT.pixel(size: 14, color: COL.acid, letterSpacing: 2)),
                  const SizedBox(height: 6),
                  Text(
                    '// canal seguro · libp2p',
                    style: FONT.mono(size: 10, color: COL.inkDim, letterSpacing: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RainCol extends StatefulWidget {
  final int seed;
  const _RainCol({required this.seed});

  @override
  State<_RainCol> createState() => _RainColState();
}

class _RainColState extends State<_RainCol> with SingleTickerProviderStateMixin {
  late final math.Random _rng = math.Random(widget.seed);
  late final List<String> _chars = _genChars();
  late final double _duration;
  late final double _delay;
  late final bool _accent;
  late final AnimationController _ac;

  List<String> _genChars() {
    final out = <String>[];
    for (var i = 0; i < 30; i++) {
      final r = _rng.nextDouble();
      if (r < 0.18) {
        out.add('DEDSEC'[_rng.nextInt(6)]);
      } else if (r < 0.35) {
        out.add(_rng.nextInt(10).toString());
      } else {
        const symbols = '#@%\$&*?!+=';
        out.add(symbols[_rng.nextInt(symbols.length)]);
      }
    }
    return out;
  }

  @override
  void initState() {
    super.initState();
    _duration = 4 + _rng.nextDouble() * 6;
    _delay = -_rng.nextDouble() * 8;
    _accent = _rng.nextDouble() < 0.18;
    _ac = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (_duration * 1000).round()),
    );
    Future.delayed(Duration(milliseconds: ((_delay + 8) * 100).round()), () {
      if (mounted) _ac.repeat();
    });
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = _accent ? COL.magenta : COL.acid;
    return ClipRect(
      child: AnimatedBuilder(
        animation: _ac,
        builder: (_, __) {
          return LayoutBuilder(builder: (_, c) {
            return Transform.translate(
              offset: Offset(0, -c.maxHeight + _ac.value * c.maxHeight * 2),
              child: Column(
                children: [
                  for (final ch in _chars)
                    Text(
                      ch,
                      style: FONT.mono(size: 13, color: color, height: 1.4).copyWith(
                            shadows: [Shadow(color: color, blurRadius: 5)],
                          ),
                    ),
                ],
              ),
            );
          });
        },
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// L9 · LoaderSpectrum — equalizer.
// ───────────────────────────────────────────────────────────────
class LoaderSpectrum extends StatelessWidget {
  const LoaderSpectrum({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: COL.bg,
      child: Stack(
        children: [
          const Halftone(color: COL.magenta, size: 6, opacity: 0.05),
          const Scanlines(opacity: 0.08),
          TickBuilder(
            interval: const Duration(milliseconds: 60),
            builder: (_, t) {
              const bars = 26;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const PixelChip('// SINAL CAPTADO', color: COL.magenta),
                    const SizedBox(height: 12),
                    const StencilSpans(
                      spans: [
                        TextSpan(text: 'ESCUTANDO\nA '),
                        TextSpan(text: 'REDE', style: TextStyle(color: COL.magenta)),
                      ],
                      size: 28,
                      textAlign: TextAlign.center,
                      height: 1,
                    ),
                    const SizedBox(height: 22),
                    Container(
                      height: 130,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: COL.panel,
                        border: Border.all(color: COL.line, width: 1.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          for (var i = 0; i < bars; i++) ...[
                            if (i > 0) const SizedBox(width: 3),
                            _bar(i, t),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      children: [
                        Text('2.4 GHz',
                            style: FONT.mono(size: 10, color: COL.inkDim, letterSpacing: 1.5)),
                        Text('·', style: FONT.mono(size: 10, color: COL.inkDim)),
                        Text('-${42 + (t % 8)} dBm',
                            style: FONT.mono(size: 10, color: COL.inkDim, letterSpacing: 1.5)),
                        Text('·', style: FONT.mono(size: 10, color: COL.inkDim)),
                        Text('${312 + (t % 7)} nós',
                            style: FONT.mono(size: 10, color: COL.inkDim, letterSpacing: 1.5)),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _bar(int i, int t) {
    final phase = t * 0.4 + i * 0.5;
    final h = 18 + math.sin(phase).abs() * 65 + math.sin(phase * 2.3).abs() * 28;
    final accent = i % 4 == 0;
    return Container(
      width: 6,
      height: h.toDouble(),
      decoration: BoxDecoration(
        color: accent ? COL.magenta : COL.acid,
        boxShadow: [BoxShadow(color: accent ? COL.magenta : COL.acid, blurRadius: 5)],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// L11 · LoaderGlyphDecode — scramble cycler.
// ───────────────────────────────────────────────────────────────
class LoaderGlyphDecode extends StatelessWidget {
  const LoaderGlyphDecode({super.key});

  static const _lines = <String>[
    'ARQUIVO_VAZADO.txt',
    'PROTOCOLO_OUVI_2026',
    'DIARIO_OFICIAL_MUN',
    'DEDSEC_BR DECRIPTANDO',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: TickBuilder(
        interval: const Duration(milliseconds: 45),
        builder: (_, t) {
          const cycleLen = 4 * 36;
          final cycle = t % cycleLen;
          final lineIdx = (cycle ~/ 36);
          final subStep = cycle % 36;
          final target = _lines[lineIdx];
          final lock = math.min(target.length, (subStep / 1.5).floor());

          return Stack(
            children: [
              const Scanlines(opacity: 0.16),
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('// ARQUIVO INTERCEPTADO',
                        style: FONT.pixel(size: 9, color: COL.acid, letterSpacing: 2)),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A0A0A),
                        border: Border.all(color: COL.acid, width: 2),
                        boxShadow: [
                          const BoxShadow(color: COL.magenta, offset: Offset(4, 4)),
                          BoxShadow(color: COL.acid.withValues(alpha: 0.27), blurRadius: 20),
                        ],
                      ),
                      child: Text(
                        scramble(target, t * 7, lock),
                        textAlign: TextAlign.center,
                        style: FONT.mono(size: 16, color: COL.acid, letterSpacing: 1.5).copyWith(
                              shadows: [const Shadow(color: COL.acid, blurRadius: 6)],
                            ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < _lines.length; i++) ...[
                          if (i > 0) const SizedBox(width: 6),
                          Container(
                            width: 30,
                            height: 4,
                            decoration: BoxDecoration(
                              color: i < lineIdx
                                  ? COL.acid
                                  : i == lineIdx
                                      ? COL.magenta
                                      : COL.line,
                              boxShadow: i == lineIdx
                                  ? [BoxShadow(color: COL.magenta, blurRadius: 6)]
                                  : null,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text.rich(
                      TextSpan(children: [
                        const TextSpan(text: 'decifrando · '),
                        TextSpan(
                          text: '${(lock / target.length * 100).floor()}%',
                          style: const TextStyle(color: COL.acid),
                        ),
                      ], style: FONT.mono(size: 10, color: COL.inkMute)),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// L12 · LoaderTokenAttention.
// ───────────────────────────────────────────────────────────────
class LoaderTokenAttention extends StatelessWidget {
  const LoaderTokenAttention({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF020608),
      child: TickBuilder(
        interval: const Duration(milliseconds: 220),
        builder: (_, t) {
          const input = ['notícia', 'sobre', 'metrô', 'linha', '17-ouro', 'SP', 'atraso', 'custo'];
          const output = ['transporte', 'urgência', 'fiscalização', 'cobrança'];
          final cycle = t % (output.length + 4);
          final visible = math.min(output.length, cycle);
          final currentIdx = math.max(0, visible - 1);
          final weights = List<double>.generate(
            input.length,
            (i) => math.sin(currentIdx * 1.3 + i * 0.7).abs() * 0.7 + 0.2,
          );
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Stack(
              children: [
                const Scanlines(opacity: 0.08),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Blink(child: Container(width: 8, height: 8, color: COL.magenta)),
                        const SizedBox(width: 6),
                        Text('MATRIZ DE ATENÇÃO',
                            style: FONT.pixel(size: 9, color: COL.magenta, letterSpacing: 1)),
                        const Spacer(),
                        Text('head 4/8', style: FONT.mono(size: 9, color: COL.inkDim)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A0A0E),
                        border: Border.all(color: COL.line, width: 1.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('INPUT — pesos de atenção',
                              style: FONT.pixel(size: 7, color: COL.inkMute, letterSpacing: 1.2)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: [
                              for (var i = 0; i < input.length; i++)
                                _attnCol(input[i], weights[i]),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A0E0A),
                          border: Border.all(color: COL.acid, width: 1.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('GERANDO', style: FONT.pixel(size: 7, color: COL.acid, letterSpacing: 1.2)),
                                const Spacer(),
                                Text('$visible/${output.length}',
                                    style: FONT.mono(size: 9, color: COL.acid)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: [
                                for (var i = 0; i < visible; i++)
                                  _outputChip(output[i], fresh: i == currentIdx),
                                if (visible < output.length)
                                  Blink(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        border: Border.all(color: COL.acid, width: 1.5),
                                      ),
                                      child: Text('▮', style: FONT.mono(size: 12, color: COL.acid)),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(spacing: 8, children: [
                      Text('self-attn', style: FONT.mono(size: 9, color: COL.inkMute)),
                      Text('·', style: FONT.mono(size: 9, color: COL.inkMute)),
                      Text('head 4/8', style: FONT.mono(size: 9, color: COL.inkMute)),
                      Text('·', style: FONT.mono(size: 9, color: COL.inkMute)),
                      Text('softmax', style: FONT.mono(size: 9, color: COL.inkMute)),
                    ]),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _attnCol(String tk, double w) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: COL.magenta.withValues(alpha: w * 0.6),
            border: Border.all(color: w > 0.55 ? COL.magenta : COL.line),
          ),
          child: Text(tk, style: FONT.mono(size: 10, color: w > 0.55 ? Colors.white : COL.ink)),
        ),
        const SizedBox(height: 3),
        SizedBox(
          width: 60,
          height: 4,
          child: Stack(
            children: [
              Container(color: COL.line),
              FractionallySizedBox(
                widthFactor: w,
                child: Container(color: COL.magenta),
              ),
            ],
          ),
        ),
        const SizedBox(height: 3),
        Text(w.toStringAsFixed(2), style: FONT.mono(size: 8, color: COL.inkMute)),
      ],
    );
  }

  Widget _outputChip(String text, {required bool fresh}) {
    return AnimatedScale(
      scale: fresh ? 1.08 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: fresh ? COL.acid : Colors.black,
          border: Border.all(color: COL.acid, width: 1.5),
        ),
        child: Text(text,
            style: FONT.mono(
              size: 12,
              color: fresh ? Colors.black : COL.acid,
              weight: fresh ? FontWeight.w700 : null,
            )),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// L13 · LoaderTokenBeam.
// ───────────────────────────────────────────────────────────────
class LoaderTokenBeam extends StatelessWidget {
  const LoaderTokenBeam({super.key});

  @override
  Widget build(BuildContext context) {
    const baseCandidates = <List<List<dynamic>>>[
      [['-Ouro', 0.62], ['-Diamante', 0.15], ['-Prata', 0.10], [' está', 0.08], [' tem', 0.05]],
      [[' atrasou', 0.55], [' tem', 0.18], [' foi', 0.13], [' está', 0.09], [' chegou', 0.05]],
      [[' 14', 0.41], [' anos', 0.22], [' a', 0.18], [' dois', 0.12], [' três', 0.07]],
      [[' e', 0.48], [' com', 0.21], [' mas', 0.15], [' enquanto', 0.10], [' por', 0.06]],
    ];
    const ctx = <List<String>>[
      ['A', ' Linha', ' 17'],
      ['A', ' Linha', ' 17', '-Ouro'],
      ['A', ' Linha', ' 17', '-Ouro', ' atrasou'],
      ['A', ' Linha', ' 17', '-Ouro', ' atrasou', ' 14'],
    ];
    return Container(
      color: const Color(0xFF020608),
      child: TickBuilder(
        interval: const Duration(milliseconds: 450),
        builder: (_, t) {
          final idx = t % baseCandidates.length;
          final candidates = baseCandidates[idx];
          final committed = ctx[idx];
          return Padding(
            padding: const EdgeInsets.all(14),
            child: Stack(
              children: [
                const Scanlines(opacity: 0.08),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Blink(child: Container(width: 8, height: 8, color: COL.alert)),
                        const SizedBox(width: 6),
                        Text('TOP-K SAMPLING',
                            style: FONT.pixel(size: 9, color: COL.alert, letterSpacing: 1)),
                        const Spacer(),
                        Text('k=5 · τ=0.7', style: FONT.mono(size: 9, color: COL.inkDim)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A0E0A),
                        border: Border.all(color: COL.acid, width: 1.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('CONTEXTO (${committed.length} tok)',
                              style: FONT.pixel(size: 7, color: COL.inkMute, letterSpacing: 1.2)),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Text(committed.join(), style: FONT.mono(size: 13, color: COL.ink)),
                              Blink(child: Text('▮', style: FONT.mono(size: 13, color: COL.acid))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A0A0E),
                          border: Border.all(color: COL.line, width: 1.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('PRÓXIMO TOKEN — 5 CANDIDATOS',
                                style: FONT.pixel(size: 7, color: COL.inkMute, letterSpacing: 1.2)),
                            const SizedBox(height: 8),
                            for (var i = 0; i < candidates.length; i++)
                              _row(i, candidates[i][0] as String, (candidates[i][1] as num).toDouble()),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(spacing: 8, children: [
                      Text('argmax', style: FONT.mono(size: 9, color: COL.inkMute)),
                      Text('·', style: FONT.mono(size: 9, color: COL.inkMute)),
                      Text('softmax', style: FONT.mono(size: 9, color: COL.inkMute)),
                      Text('·', style: FONT.mono(size: 9, color: COL.inkMute)),
                      Text('rep_penalty=1.1', style: FONT.mono(size: 9, color: COL.inkMute)),
                    ]),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _row(int i, String token, double prob) {
    final isWinner = i == 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            child: Text('#${i + 1}',
                textAlign: TextAlign.right,
                style: FONT.pixel(size: 8, color: isWinner ? COL.acid : COL.inkMute)),
          ),
          const SizedBox(width: 6),
          Container(
            constraints: const BoxConstraints(minWidth: 60),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isWinner ? COL.acid : Colors.black,
              border: Border.all(color: isWinner ? COL.acid : COL.line),
            ),
            child: Text(token.trim().isEmpty ? '·' : token.trim(),
                style: FONT.mono(size: 11, color: isWinner ? Colors.black : COL.ink)),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: SizedBox(
              height: 8,
              child: Stack(
                children: [
                  Container(color: COL.line),
                  FractionallySizedBox(
                    widthFactor: prob,
                    child: Container(color: isWinner ? COL.acid : COL.magenta),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 36,
            child: Text(
              '${(prob * 100).round()}%',
              textAlign: TextAlign.right,
              style: FONT.mono(size: 10, color: isWinner ? COL.acid : COL.inkDim),
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────
// L14 · LoaderTokenRAG.
// ───────────────────────────────────────────────────────────────
class LoaderTokenRAG extends StatelessWidget {
  const LoaderTokenRAG({super.key});

  @override
  Widget build(BuildContext context) {
    const chunks = <_RagChunk>[
      _RagChunk('D.O. Municipal SP · 2024-08', 'aditivo n°3 prorroga prazo de entrega', 0.91),
      _RagChunk('queridodiario.api · trecho', 'custo revisto: R\$1.6bi → R\$4.8bi', 0.84),
      _RagChunk('G1 SP · 2024-12', 'TCE-SP abre processo de fiscalização', 0.71),
    ];
    const generated = ['A', ' linha', ' 17-Ouro', ' do', ' metrô', ' acumula', ' aditivos', ' que', ' triplicaram', ' o', ' custo', '.'];
    return Container(
      color: const Color(0xFF020608),
      child: TickBuilder(
        interval: const Duration(milliseconds: 180),
        builder: (_, t) {
          final cycle = t % (generated.length + 4);
          final visible = math.min(generated.length, cycle);
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Stack(
              children: [
                const Scanlines(opacity: 0.08),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Blink(child: Container(width: 8, height: 8, color: COL.acid)),
                        const SizedBox(width: 6),
                        Text('RAG · BUSCA AUMENTADA',
                            style: FONT.pixel(size: 9, color: COL.acid, letterSpacing: 1)),
                        const Spacer(),
                        Text('top-3', style: FONT.mono(size: 9, color: COL.inkDim)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A0A0E),
                        border: Border.all(color: COL.line, width: 1.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('QUERY',
                              style: FONT.pixel(size: 7, color: COL.inkMute, letterSpacing: 1.2)),
                          const SizedBox(height: 3),
                          Text('"transporte público sp · atraso obras"',
                              style: FONT.mono(size: 10, color: COL.ink)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('CHUNKS RECUPERADOS',
                        style: FONT.pixel(size: 7, color: COL.inkMute, letterSpacing: 1.2)),
                    const SizedBox(height: 5),
                    for (final c in chunks)
                      Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A0A0E),
                          border: const Border(
                            left: BorderSide(color: COL.acid, width: 3),
                            top: BorderSide(color: COL.line),
                            right: BorderSide(color: COL.line),
                            bottom: BorderSide(color: COL.line),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(c.src, style: FONT.mono(size: 9, color: COL.acid)),
                                const Spacer(),
                                Text('sim=${c.sim}', style: FONT.mono(size: 9, color: COL.magenta)),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text('"${c.text}"',
                                style: FONT.mono(size: 9, color: COL.inkDim)),
                          ],
                        ),
                      ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A0E0A),
                          border: Border.all(color: COL.acid, width: 1.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('GERANDO COM CONTEXTO',
                                    style: FONT.pixel(size: 7, color: COL.acid, letterSpacing: 1.2)),
                                const Spacer(),
                                Text('$visible/${generated.length}',
                                    style: FONT.mono(size: 9, color: COL.acid)),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Wrap(
                              spacing: 3,
                              runSpacing: 3,
                              children: [
                                for (var i = 0; i < visible; i++)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: COL.acid,
                                      border: Border.all(color: Colors.black, width: 1.5),
                                    ),
                                    child: Text(
                                        generated[i].trim().isEmpty ? '·' : generated[i].trim(),
                                        style: FONT.mono(size: 11, color: Colors.black)),
                                  ),
                                if (visible < generated.length)
                                  Blink(
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RagChunk {
  final String src;
  final String text;
  final double sim;
  const _RagChunk(this.src, this.text, this.sim);
}

// ───────────────────────────────────────────────────────────────
// L15 · LoaderTokenLayers.
// ───────────────────────────────────────────────────────────────
class LoaderTokenLayers extends StatelessWidget {
  const LoaderTokenLayers({super.key});

  @override
  Widget build(BuildContext context) {
    const layers = 12;
    const tokens = 8;
    return Container(
      color: const Color(0xFF020608),
      child: TickBuilder(
        interval: const Duration(milliseconds: 80),
        builder: (_, t) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Stack(
              children: [
                const Scanlines(opacity: 0.08),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Blink(child: Container(width: 8, height: 8, color: COL.magenta)),
                        const SizedBox(width: 6),
                        Text('TRANSFORMER STACK',
                            style: FONT.pixel(size: 9, color: COL.magenta, letterSpacing: 1)),
                        const Spacer(),
                        Text('${layers}×$tokens', style: FONT.mono(size: 9, color: COL.inkDim)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Column(
                        children: [
                          for (var li = 0; li < layers; li++)
                            Expanded(
                              child: _layerRow(li, t, tokens),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(spacing: 8, children: [
                      Text('self-attn → ffn → norm', style: FONT.mono(size: 9, color: COL.inkMute)),
                      Text('·', style: FONT.mono(size: 9, color: COL.inkMute)),
                      Text('residual', style: FONT.mono(size: 9, color: COL.inkMute)),
                    ]),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _layerRow(int li, int t, int tokens) {
    final layerActive = ((t - li) % 16) < 8;
    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: layerActive ? const Color(0xFF0A0E0A) : Colors.transparent,
        border: Border.all(
          color: layerActive ? COL.acid.withValues(alpha: 0.33) : COL.line,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              'L${(li + 1).toString().padLeft(2, '0')}',
              style: FONT.pixel(size: 7, color: layerActive ? COL.acid : COL.inkMute),
            ),
          ),
          for (var ti = 0; ti < tokens; ti++)
            Expanded(
              child: _cell(li, ti, t),
            ),
        ],
      ),
    );
  }

  Widget _cell(int li, int ti, int t) {
    final cellActive = ((t * 2 - li + ti) % 16) < 6;
    final value = (math.sin(t * 0.1 + li * 0.4 + ti * 0.5) + 1) / 2;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: cellActive
            ? COL.acid.withValues(alpha: 0.3 + value * 0.7)
            : const Color(0xFF0A0A0A),
        border: Border.all(color: cellActive ? COL.acid : COL.line),
      ),
    );
  }
}
