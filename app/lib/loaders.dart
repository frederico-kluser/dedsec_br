// loaders.dart — 14 themed loader widgets (L1..L15, skipping L10).
// Each is a self-contained animated visualization meant for the loaders gallery
// and also (L7 TokenStream) embedded in the "Process pauta" flow.

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'atoms.dart';
import 'design.dart';
import 'molecules.dart';

// ─── L1 — Terminal de Boot ────────────────────────────────────────────────
class LoaderTerminal extends StatefulWidget {
  const LoaderTerminal({super.key});
  @override
  State<LoaderTerminal> createState() => _LoaderTerminalState();
}

class _LoaderTerminalState extends State<LoaderTerminal> {
  static const _lines = [
    (100, '> dedsec_br célula · v0.1.0-beta'),
    (200, '> kernel: montando /local/cérebro/'),
    (300, '  ↳ gemma-3-1b-it.q4.task  [530MB]'),
    (600, '  ↳ verificando integridade ..... OK'),
    (900, '> aquecendo tokenizador ........ OK'),
    (1200, '> descobrindo peers ............ 312 nós'),
    (1500, '> handshake da malha (libp2p) .. OK'),
    (1800, '> baixando pautas/sp/2026-05-23.'),
    (2100, '  ↳ 4 itens · 12 fontes'),
    (2400, '> uuid_hash = 9f4a-...-7c12'),
    (2700, '> identidade selada (sem login)'),
    (3000, '> NOS AGUARDE'),
    (3300, '> pronto.'),
  ];

  @override
  Widget build(BuildContext c) => TickerBuilder(
        interval: const Duration(milliseconds: 100),
        builder: (_, t) {
          final ms = t * 100;
          final visible = _lines.where((l) => l.$1 <= (ms % 5000)).toList();
          return Container(
            color: const Color(0xFF020602),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
            child: Stack(children: [
              const Scanlines(opacity: 0.22),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  decoration: const BoxDecoration(border: Border(bottom: DashedSide(color: Col.acid))),
                  child: Text('DEDSEC_BR :: INICIANDO  ░░░░░  TTY1',
                      style: Fonts.pixel(size: 9, color: Col.acid, letterSpacing: 2)),
                ),
                const SizedBox(height: 12),
                Expanded(child: SingleChildScrollView(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    for (final l in visible) Text(
                      l.$2,
                      style: Fonts.mono(
                        size: 12, height: 1.7,
                        color: l.$2.contains('AGUARDE')
                            ? Col.magenta
                            : l.$2.contains('OK') ? Col.acid
                            : l.$2.startsWith('  ↳') ? Col.acidD
                            : Col.acid,
                      ),
                    ),
                    Container(width: 8, height: 14, color: Col.acid),
                  ]),
                )),
                Row(children: [
                  Container(width: 6, height: 6, color: Col.acid),
                  const SizedBox(width: 8),
                  Text('REDE_AO_VIVO · 312 PEERS · TX/RX 4.2KB/s',
                      style: Fonts.pixel(size: 8, color: Col.acid, letterSpacing: 1.5)),
                ]),
              ]),
            ]),
          );
        },
      );
}

/// Simple dashed BorderSide-like marker (not a true BorderSide; used as a hint).
class DashedSide extends BorderSide {
  const DashedSide({super.color, super.width = 1});
}

// ─── L2 — Pulso Halftone ──────────────────────────────────────────────────
class LoaderHalftone extends StatelessWidget {
  const LoaderHalftone({super.key});
  @override
  Widget build(BuildContext c) => Container(
        color: Col.bg,
        padding: const EdgeInsets.all(24),
        child: TickerBuilder(
          interval: const Duration(milliseconds: 60),
          builder: (_, t) {
            const target = 'NOS AGUARDE';
            final lock = ((t % 60) ~/ 4).clamp(0, target.length);
            return Stack(alignment: Alignment.center, children: [
              for (var i = 0; i < 3; i++) _pulse(i, t),
              Container(
                width: 220, height: 220,
                decoration: BoxDecoration(
                  color: Col.magenta, shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 4),
                  boxShadow: const [BoxShadow(offset: Offset(8, 8), color: Colors.black)],
                ),
                child: const Stack(alignment: Alignment.center, children: [
                  Halftone(color: Colors.black, size: 6, opacity: 0.7),
                  Skull(size: 90, color: Colors.white),
                  Grain(opacity: 0.18),
                ]),
              ),
              Positioned(
                left: 22, right: 22, bottom: 22,
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('0xDED5EC', style: Fonts.pixel(size: 8, color: Col.inkMute, letterSpacing: 1.5)),
                  Text('● AO VIVO', style: Fonts.pixel(size: 8, color: Col.magenta, letterSpacing: 1.5)),
                ]),
              ),
              Positioned(
                bottom: 100,
                child: Column(children: [
                  Glitch(scramble(target, t, lock), size: 28),
                  const SizedBox(height: 14),
                  Text('// DECIFRANDO PAUTA ...', style: Fonts.mono(size: 10, color: Col.inkDim, letterSpacing: 2)),
                ]),
              ),
            ]);
          },
        ),
      );

  Widget _pulse(int i, int t) {
    final phase = ((t + i * 24) % 72) / 72.0;
    final scale = 0.4 + phase * 1.0;
    return Opacity(
      opacity: 0.8 * (1 - phase),
      child: Container(
        width: 320 * scale, height: 320 * scale,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [Col.magenta.withValues(alpha: 0.4), Colors.transparent]),
        ),
      ),
    );
  }
}

// ─── L3 — Varredura Radar ─────────────────────────────────────────────────
class LoaderRadar extends StatefulWidget {
  const LoaderRadar({super.key});
  @override
  State<LoaderRadar> createState() => _LoaderRadarState();
}

class _LoaderRadarState extends State<LoaderRadar> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400))..repeat();
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext c) => Container(
        color: const Color(0xFF040805),
        child: Stack(children: [
          const Scanlines(opacity: 0.12),
          Positioned(top: 22, left: 20, right: 20, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('// RASTREIO_REDE', style: Fonts.pixel(size: 9, color: Col.acid, letterSpacing: 2)),
            Text('● 312', style: Fonts.pixel(size: 9, color: Col.acid, letterSpacing: 2)),
          ])),
          Center(child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => CustomPaint(size: const Size(280, 280), painter: _RadarPainter(_ctrl.value)),
          )),
          Positioned(left: 0, right: 0, bottom: 80, child: Column(children: [
            StencilSpan(TextSpan(children: [
              const TextSpan(text: 'BUSCANDO '),
              TextSpan(text: 'CÉLULAS', style: TextStyle(color: Col.acid)),
            ]), size: 30, align: TextAlign.center),
            const SizedBox(height: 6),
            Text('312 peers ativos · são paulo', style: Fonts.mono(size: 11, color: Col.inkDim, letterSpacing: 2)),
          ])),
          Positioned(left: 22, right: 22, bottom: 22, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('P2P · libp2p', style: Fonts.pixel(size: 8, color: Col.acid, letterSpacing: 1.5)),
            Text('RSSI -42 dB', style: Fonts.pixel(size: 8, color: Col.acid, letterSpacing: 1.5)),
          ])),
        ]),
      );
}

class _RadarPainter extends CustomPainter {
  final double t;
  _RadarPainter(this.t);
  @override
  void paint(Canvas canvas, Size sz) {
    final center = Offset(sz.width / 2, sz.height / 2);
    final r = sz.width / 2;
    final ring = Paint()..color = Col.acid.withValues(alpha: 0.4)..style = PaintingStyle.stroke..strokeWidth = 1.5;
    canvas.drawCircle(center, r, ring);
    for (final ratio in [0.3, 0.55, 0.8]) {
      canvas.drawCircle(center, r * ratio, Paint()..color = Col.acid.withValues(alpha: 0.2)..style = PaintingStyle.stroke..strokeWidth = 1);
    }
    final cross = Paint()..color = Col.acid.withValues(alpha: 0.2)..strokeWidth = 1;
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, sz.height), cross);
    canvas.drawLine(Offset(0, center.dy), Offset(sz.width, center.dy), cross);

    final angle = t * 2 * math.pi;
    final sweep = Paint()..shader = LinearGradient(colors: [Col.acid, Colors.transparent]).createShader(Rect.fromLTWH(0, 0, r, 4));
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    canvas.drawRect(const Rect.fromLTWH(0, -1, 140, 2), sweep);
    canvas.restore();

    // blips
    final rng = math.Random(1);
    for (var i = 0; i < 14; i++) {
      final bAngle = (i * 67) % 360 * math.pi / 180;
      final radius = 30 + (i * 23) % 100.0;
      final age = (t * 1000 - i * 200) % 2400;
      final opacity = age < 1200 ? (1 - age / 1200) : 0.0;
      final p = Paint()..color = Col.acid.withValues(alpha: opacity);
      canvas.drawCircle(center + Offset(math.cos(bAngle) * radius, math.sin(bAngle) * radius), 4, p);
      rng.nextDouble(); // keep rng stable
    }
    canvas.drawRect(Rect.fromCenter(center: center, width: 10, height: 10), Paint()..color = Col.magenta);
  }
  @override
  bool shouldRepaint(_RadarPainter old) => true;
}

// ─── L4 — Fita de Dados ───────────────────────────────────────────────────
class LoaderDataTape extends StatelessWidget {
  const LoaderDataTape({super.key});
  static const _stream = [
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

  @override
  Widget build(BuildContext c) => Container(
        color: Colors.black,
        child: TickerBuilder(
          interval: const Duration(milliseconds: 80),
          builder: (_, t) {
            final idx = t % _stream.length;
            return Stack(children: [
              const Scanlines(opacity: 0.15),
              Column(children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(18, 20, 18, 10),
                  child: Row(children: [
                    Container(width: 10, height: 10, color: Col.magenta),
                    const SizedBox(width: 10),
                    Expanded(child: Text('TRANSMITINDO',
                        style: Fonts.pixel(size: 10, color: Col.magenta, letterSpacing: 2))),
                    Text('${(t * 0.42).toStringAsFixed(1)} KB/s', style: Fonts.mono(size: 10, color: Col.inkDim)),
                  ]),
                ),
                Expanded(child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(color: const Color(0xFF040404), border: Border.all(color: Col.line)),
                  clipBehavior: Clip.hardEdge,
                  child: Column(children: [
                    for (var i = idx; i < idx + 12 && i < _stream.length * 3; i++)
                      _row(_stream[i % _stream.length], i == idx),
                  ]),
                )),
                Container(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 22),
                  child: Row(children: [
                    const Glitch('SINCRONIZANDO', size: 16),
                    const Spacer(),
                    Text('${(12 + t).toString().padLeft(2, '0').substring(0, 2)}%',
                        style: Fonts.pixel(size: 9, color: Col.acid)),
                  ]),
                ),
              ]),
            ]);
          },
        ),
      );

  Widget _row(String line, bool active) {
    final color = line.contains('[CENSURADO]') ? Col.inkMute
        : line.contains('████') ? const Color(0xFF444444)
        : line.contains('chegando') ? Col.magenta
        : RegExp(r'^[01 ]+$').hasMatch(line) ? Col.acid.withValues(alpha: 0.67)
        : line.contains('200') ? Col.acid
        : Col.ink;
    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFF111111)))),
      child: Opacity(opacity: active ? 1 : 0.5, child: Text(line,
          maxLines: 1, overflow: TextOverflow.ellipsis,
          style: Fonts.mono(size: 11, color: color))),
    );
  }
}

// ─── L5 — Contador de Células ─────────────────────────────────────────────
class LoaderCounter extends StatelessWidget {
  const LoaderCounter({super.key});
  @override
  Widget build(BuildContext c) => Container(
        color: Col.bg,
        padding: const EdgeInsets.all(22),
        child: TickerBuilder(
          interval: const Duration(milliseconds: 140),
          builder: (_, t) {
            final n = 4328 + t;
            return Stack(children: [
              const Halftone(color: Col.acid, size: 6, opacity: 0.08),
              const Scanlines(opacity: 0.1),
              Positioned(top: 0, left: 0, right: 0, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('// MUTIRÃO', style: Fonts.pixel(size: 9, color: Col.acid)),
                Text('SÃO PAULO', style: Fonts.pixel(size: 9, color: Col.inkDim)),
              ])),
              Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text('PAUTAS PROCESSADAS HOJE',
                    style: Fonts.pixel(size: 10, color: Col.inkDim, letterSpacing: 2)),
                const SizedBox(height: 20),
                Text(formatNum(n), style: Fonts.stencil(size: 84, color: Col.ink, letterSpacing: 4).copyWith(
                  shadows: const [
                    Shadow(offset: Offset(4, 4), color: Col.magenta),
                    Shadow(offset: Offset(-4, -4), color: Col.acid),
                  ],
                )),
                const SizedBox(height: 20),
                Row(mainAxisSize: MainAxisSize.min, children: [
                  for (var i = 0; i < 20; i++)
                    Container(width: 6, height: 18, margin: const EdgeInsets.symmetric(horizontal: 3),
                      color: i <= (t % 20) ? Col.acid : Col.line),
                ]),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(color: Colors.black, border: Border.all(color: Col.acid, width: 1.5)),
                  child: Text.rich(TextSpan(children: [
                    TextSpan(text: '+1 célula entrou agora · cidadão_', style: Fonts.mono(size: 11, color: Col.acid)),
                    TextSpan(text: 'sp_${(t * 7).toRadixString(16).padLeft(4, '0').substring(0, 4)}',
                        style: Fonts.mono(size: 11, color: Col.magenta)),
                  ])),
                ),
              ])),
              Positioned(bottom: 0, left: 0, right: 0, child: Text(
                'SINCRONIZANDO FEED LOCAL ...',
                textAlign: TextAlign.center,
                style: Fonts.pixel(size: 9, color: Col.inkMute, letterSpacing: 1.5),
              )),
            ]);
          },
        ),
      );
}

// ─── L6 — Glitch Embaralhado ──────────────────────────────────────────────
class LoaderGlitch extends StatelessWidget {
  const LoaderGlitch({super.key});
  @override
  Widget build(BuildContext c) => Container(
        color: Colors.black,
        child: TickerBuilder(
          interval: const Duration(milliseconds: 50),
          builder: (_, t) {
            const phases = ['ACESSANDO', 'DECIFRANDO', 'COMPILANDO', 'LIBERADO'];
            final phase = phases[(t ~/ 30) % phases.length];
            final lock = ((t % 30) ~/ 3).clamp(0, phase.length);
            return Stack(children: [
              // 4-quadrant pop-art background
              Row(children: [
                Expanded(child: Column(children: [
                  Expanded(child: Container(color: Col.magenta, child: const Halftone(color: Colors.black, size: 5, opacity: 0.6))),
                  Expanded(child: Container(color: Colors.black, child: const Halftone(color: Col.magenta, size: 4, opacity: 0.3))),
                ])),
                Expanded(child: Column(children: [
                  Expanded(child: Container(color: Colors.black, child: const Halftone(color: Col.acid, size: 4, opacity: 0.3))),
                  Expanded(child: Container(color: Col.acid, child: const Halftone(color: Colors.black, size: 5, opacity: 0.6))),
                ])),
              ]),
              Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: const [
                      BoxShadow(offset: Offset(6, 6), color: Col.magenta),
                      BoxShadow(offset: Offset(-6, -6), color: Col.acid),
                    ],
                  ),
                  child: Text('DEDSEC_BR', style: Fonts.pixel(size: 26, color: Colors.white, letterSpacing: 2)),
                ),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  constraints: const BoxConstraints(minWidth: 240),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.white, width: 2.5),
                    boxShadow: const [BoxShadow(offset: Offset(4, 4), color: Colors.black)],
                  ),
                  child: Column(children: [
                    Text('// STATUS', style: Fonts.mono(size: 10, color: Col.inkDim, letterSpacing: 2)),
                    const SizedBox(height: 6),
                    Text('${scramble(phase, t, lock)}...',
                        style: Fonts.pixel(size: 16, color: Col.acid, letterSpacing: 2)),
                  ]),
                ),
                const SizedBox(height: 16),
                Row(mainAxisSize: MainAxisSize.min, children: [
                  for (var i = 0; i < 8; i++)
                    Container(width: 22, height: 6, margin: const EdgeInsets.symmetric(horizontal: 2),
                        color: i <= (t % 8) ? Colors.white : const Color(0xFF333333)),
                ]),
              ])),
              const Grain(opacity: 0.15),
            ]);
          },
        ),
      );
}

// ─── L7 — TokenStream (wraps shared panel) ────────────────────────────────
class LoaderTokenStream extends StatelessWidget {
  const LoaderTokenStream({super.key});
  @override
  Widget build(BuildContext c) => Container(
        color: const Color(0xFF020608),
        child: const Column(children: [TokenStreamPanel()]),
      );
}

// ─── L8 — Chuva Binária ───────────────────────────────────────────────────
class LoaderBinaryRain extends StatefulWidget {
  const LoaderBinaryRain({super.key});
  @override
  State<LoaderBinaryRain> createState() => _LoaderBinaryRainState();
}

class _LoaderBinaryRainState extends State<LoaderBinaryRain> with SingleTickerProviderStateMixin {
  late final List<_RainColumn> cols;
  late final AnimationController _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat();
  @override
  void initState() {
    super.initState();
    final r = math.Random(7);
    cols = List.generate(14, (_) => _RainColumn.random(r));
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext c) => Container(
        color: const Color(0xFF020602),
        child: Stack(children: [
          const Scanlines(opacity: 0.08),
          AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => Row(children: [
              for (final col in cols)
                Expanded(child: ClipRect(child: CustomPaint(
                  painter: _RainPainter(col, _ctrl.value),
                  size: Size.infinite,
                ))),
            ]),
          ),
          Center(child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Col.acid, width: 2),
              boxShadow: const [BoxShadow(offset: Offset(5, 5), color: Col.magenta)],
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('DECIFRANDO', style: Fonts.pixel(size: 14, color: Col.acid, letterSpacing: 2)),
              const SizedBox(height: 6),
              Text('// canal seguro · libp2p', style: Fonts.mono(size: 10, color: Col.inkDim, letterSpacing: 1.5)),
            ]),
          )),
        ]),
      );
}

class _RainColumn {
  final List<String> chars;
  final double duration;
  final double delay;
  final bool accent;
  _RainColumn(this.chars, this.duration, this.delay, this.accent);
  factory _RainColumn.random(math.Random r) {
    final chars = List.generate(30, (_) {
      final v = r.nextDouble();
      if (v < 0.18) return 'DEDSEC'[r.nextInt(6)];
      if (v < 0.35) return r.nextInt(10).toString();
      return r'#@%$&*?!+='[r.nextInt(10)];
    });
    return _RainColumn(chars, 4 + r.nextDouble() * 6, -r.nextDouble() * 8, r.nextDouble() < 0.18);
  }
}

class _RainPainter extends CustomPainter {
  final _RainColumn col;
  final double t;
  _RainPainter(this.col, this.t);
  @override
  void paint(Canvas canvas, Size sz) {
    final base = (t * 8 / col.duration + col.delay) % 1.0;
    final offset = base * sz.height * 2 - sz.height;
    final color = col.accent ? Col.magenta : Col.acid;
    for (var i = 0; i < col.chars.length; i++) {
      final y = offset + i * 18.0;
      if (y < -20 || y > sz.height) continue;
      final tp = TextPainter(
        text: TextSpan(text: col.chars[i],
            style: Fonts.mono(size: 13, color: color, height: 1).copyWith(
                shadows: [Shadow(color: color, blurRadius: 5)])),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(sz.width / 2 - tp.width / 2, y));
    }
  }
  @override
  bool shouldRepaint(_RainPainter old) => true;
}

// ─── L9 — Espectro de Sinal ──────────────────────────────────────────────
class LoaderSpectrum extends StatelessWidget {
  const LoaderSpectrum({super.key});
  @override
  Widget build(BuildContext c) => Container(
        color: Col.bg,
        padding: const EdgeInsets.all(16),
        child: TickerBuilder(
          interval: const Duration(milliseconds: 60),
          builder: (_, t) => Stack(children: [
            const Halftone(color: Col.magenta, size: 6, opacity: 0.05),
            const Scanlines(opacity: 0.08),
            Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              const PixelChip('// SINAL CAPTADO', color: Col.magenta),
              const SizedBox(height: 12),
              StencilSpan(TextSpan(children: [
                const TextSpan(text: 'ESCUTANDO\nA '),
                TextSpan(text: 'REDE', style: TextStyle(color: Col.magenta)),
              ]), size: 28, align: TextAlign.center),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                height: 150,
                decoration: BoxDecoration(color: Col.panel, border: Border.all(color: Col.line, width: 1.5)),
                child: Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisSize: MainAxisSize.min, children: [
                  for (var i = 0; i < 26; i++) ...[
                    if (i > 0) const SizedBox(width: 3),
                    _bar(i, t),
                  ],
                ]),
              ),
              const SizedBox(height: 16),
              Wrap(spacing: 12, children: [
                Text('2.4 GHz', style: Fonts.mono(size: 10, color: Col.inkDim)),
                Text('·', style: Fonts.mono(size: 10, color: Col.inkDim)),
                Text('-${42 + (t % 8)} dBm', style: Fonts.mono(size: 10, color: Col.inkDim)),
                Text('·', style: Fonts.mono(size: 10, color: Col.inkDim)),
                Text('${312 + (t % 7)} nós', style: Fonts.mono(size: 10, color: Col.inkDim)),
              ]),
            ])),
          ]),
        ),
      );
  Widget _bar(int i, int t) {
    final phase = t * 0.4 + i * 0.5;
    final h = 18 + math.sin(phase).abs() * 65 + math.sin(phase * 2.3).abs() * 28;
    final accent = i % 4 == 0;
    final color = accent ? Col.magenta : Col.acid;
    return Container(
      width: 6, height: h,
      decoration: BoxDecoration(color: color, boxShadow: [BoxShadow(color: color, blurRadius: 5)]),
    );
  }
}

// ─── L11 — Decifrador (Glyph Decode) ─────────────────────────────────────
class LoaderGlyphDecode extends StatelessWidget {
  const LoaderGlyphDecode({super.key});
  @override
  Widget build(BuildContext c) => Container(
        color: Colors.black,
        padding: const EdgeInsets.all(22),
        child: TickerBuilder(
          interval: const Duration(milliseconds: 45),
          builder: (_, t) {
            const lines = [
              'ARQUIVO_VAZADO.txt',
              'PROTOCOLO_OUVI_2026',
              'DIARIO_OFICIAL_MUN',
              'DEDSEC_BR DECRIPTANDO',
            ];
            final cycleLen = lines.length * 36;
            final cycle = t % cycleLen;
            final lineIdx = cycle ~/ 36;
            final subStep = cycle % 36;
            final target = lines[lineIdx];
            final lock = (subStep / 1.5).floor().clamp(0, target.length);
            return Stack(children: [
              const Scanlines(opacity: 0.16),
              Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text('// ARQUIVO INTERCEPTADO', style: Fonts.pixel(size: 9, color: Col.acid, letterSpacing: 2)),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0A0A),
                    border: Border.all(color: Col.acid, width: 2),
                    boxShadow: [
                      const BoxShadow(offset: Offset(4, 4), color: Col.magenta),
                      BoxShadow(color: Col.acid.withValues(alpha: 0.27), blurRadius: 20),
                    ],
                  ),
                  child: Text(scramble(target, t * 7, lock),
                      style: Fonts.mono(size: 16, color: Col.acid, letterSpacing: 1.5).copyWith(
                          shadows: [const Shadow(color: Col.acid, blurRadius: 6)])),
                ),
                const SizedBox(height: 26),
                Row(mainAxisSize: MainAxisSize.min, children: [
                  for (var i = 0; i < lines.length; i++) ...[
                    if (i > 0) const SizedBox(width: 6),
                    Container(width: 30, height: 4,
                        color: i < lineIdx ? Col.acid : i == lineIdx ? Col.magenta : Col.line),
                  ],
                ]),
                const SizedBox(height: 14),
                Text('decifrando · ${(lock / target.length * 100).floor()}%',
                    style: Fonts.mono(size: 10, color: Col.inkMute)),
              ])),
            ]);
          },
        ),
      );
}

// ─── L12 — Token Attention ────────────────────────────────────────────────
class LoaderTokenAttention extends StatelessWidget {
  const LoaderTokenAttention({super.key});
  @override
  Widget build(BuildContext c) => Container(
        color: const Color(0xFF020608),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: TickerBuilder(
          interval: const Duration(milliseconds: 220),
          builder: (_, t) {
            const input = ['notícia', 'sobre', 'metrô', 'linha', '17-ouro', 'SP', 'atraso', 'custo'];
            const output = ['transporte', 'urgência', 'fiscalização', 'cobrança'];
            final cycle = t % (output.length + 4);
            final visible = cycle.clamp(0, output.length);
            final cur = (visible - 1).clamp(0, output.length - 1);
            return Stack(children: [
              const Scanlines(opacity: 0.08),
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Row(children: [
                  Container(width: 8, height: 8, color: Col.magenta),
                  const SizedBox(width: 6),
                  Text('MATRIZ DE ATENÇÃO', style: Fonts.pixel(size: 9, color: Col.magenta, letterSpacing: 1)),
                  const Spacer(),
                  Text('head 4/8', style: Fonts.mono(size: 9, color: Col.inkDim)),
                ]),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFF0A0A0E), border: Border.all(color: Col.line, width: 1.5)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('INPUT — pesos de atenção',
                        style: Fonts.pixel(size: 7, color: Col.inkMute, letterSpacing: 1.2)),
                    const SizedBox(height: 8),
                    Wrap(spacing: 4, runSpacing: 6, children: [
                      for (var i = 0; i < input.length; i++)
                        _tokAttn(input[i], (math.sin(cur * 1.3 + i * 0.7).abs() * 0.7 + 0.2)),
                    ]),
                  ]),
                ),
                const SizedBox(height: 10),
                Expanded(child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0E0A),
                    border: Border.all(color: Col.acid, width: 1.5),
                    boxShadow: [BoxShadow(color: Col.acid.withValues(alpha: 0.13), blurRadius: 12)],
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Text('GERANDO', style: Fonts.pixel(size: 7, color: Col.acid, letterSpacing: 1.2)),
                      const Spacer(),
                      Text('$visible/${output.length}', style: Fonts.mono(size: 9, color: Col.acid)),
                    ]),
                    const SizedBox(height: 6),
                    Wrap(spacing: 4, runSpacing: 4, children: [
                      for (var i = 0; i < visible; i++)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: i == cur ? Col.acid : Colors.black,
                            border: Border.all(color: Col.acid, width: 1.5),
                          ),
                          child: Text(output[i], style: Fonts.mono(size: 12,
                              color: i == cur ? Colors.black : Col.acid,
                              weight: i == cur ? FontWeight.w700 : FontWeight.w400)),
                        ),
                    ]),
                  ]),
                )),
                const SizedBox(height: 8),
                Wrap(spacing: 8, children: [
                  Text('self-attn', style: Fonts.mono(size: 9, color: Col.inkMute)),
                  Text('·', style: Fonts.mono(size: 9, color: Col.inkMute)),
                  Text('head 4/8', style: Fonts.mono(size: 9, color: Col.inkMute)),
                  Text('·', style: Fonts.mono(size: 9, color: Col.inkMute)),
                  Text('softmax', style: Fonts.mono(size: 9, color: Col.inkMute)),
                ]),
              ]),
            ]);
          },
        ),
      );
  Widget _tokAttn(String tk, double w) => SizedBox(
        width: 56,
        child: Column(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: Col.magenta.withValues(alpha: w * 0.6),
              border: Border.all(color: w > 0.55 ? Col.magenta : Col.line, width: 1),
            ),
            child: Text(tk, textAlign: TextAlign.center,
                style: Fonts.mono(size: 10, color: w > 0.55 ? Colors.white : Col.ink)),
          ),
          const SizedBox(height: 3),
          Container(height: 4, color: Col.line, child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(widthFactor: w, child: Container(color: Col.magenta)),
          )),
          const SizedBox(height: 2),
          Text(w.toStringAsFixed(2), style: Fonts.mono(size: 8, color: Col.inkMute)),
        ]),
      );
}

// ─── L13 — Token Beam (top-K) ─────────────────────────────────────────────
class LoaderTokenBeam extends StatelessWidget {
  const LoaderTokenBeam({super.key});
  @override
  Widget build(BuildContext c) => Container(
        color: const Color(0xFF020608),
        padding: const EdgeInsets.all(14),
        child: TickerBuilder(
          interval: const Duration(milliseconds: 450),
          builder: (_, t) {
            const sets = [
              [('-Ouro', 0.62), ('-Diamante', 0.15), ('-Prata', 0.10), (' está', 0.08), (' tem', 0.05)],
              [(' atrasou', 0.55), (' tem', 0.18), (' foi', 0.13), (' está', 0.09), (' chegou', 0.05)],
              [(' 14', 0.41), (' anos', 0.22), (' a', 0.18), (' dois', 0.12), (' três', 0.07)],
              [(' e', 0.48), (' com', 0.21), (' mas', 0.15), (' enquanto', 0.10), (' por', 0.06)],
            ];
            const ctxs = [
              ['A', ' Linha', ' 17'],
              ['A', ' Linha', ' 17', '-Ouro'],
              ['A', ' Linha', ' 17', '-Ouro', ' atrasou'],
              ['A', ' Linha', ' 17', '-Ouro', ' atrasou', ' 14'],
            ];
            final idx = t % sets.length;
            return Stack(children: [
              const Scanlines(opacity: 0.08),
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Row(children: [
                  Container(width: 8, height: 8, color: Col.alert),
                  const SizedBox(width: 6),
                  Text('TOP-K SAMPLING', style: Fonts.pixel(size: 9, color: Col.alert, letterSpacing: 1)),
                  const Spacer(),
                  Text('k=5 · τ=0.7', style: Fonts.mono(size: 9, color: Col.inkDim)),
                ]),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFF0A0E0A), border: Border.all(color: Col.acid, width: 1.5)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('CONTEXTO (${ctxs[idx].length} tok)', style: Fonts.pixel(size: 7, color: Col.inkMute, letterSpacing: 1.2)),
                    const SizedBox(height: 5),
                    Text.rich(TextSpan(children: [
                      TextSpan(text: ctxs[idx].join(''), style: Fonts.mono(size: 13, color: Col.ink)),
                      TextSpan(text: '▮', style: Fonts.mono(size: 13, color: Col.acid)),
                    ])),
                  ]),
                ),
                const SizedBox(height: 10),
                Expanded(child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFF0A0A0E), border: Border.all(color: Col.line, width: 1.5)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Text('PRÓXIMO TOKEN — 5 CANDIDATOS',
                        style: Fonts.pixel(size: 7, color: Col.inkMute, letterSpacing: 1.2)),
                    const SizedBox(height: 8),
                    for (var i = 0; i < sets[idx].length; i++) _row(sets[idx][i], i),
                  ]),
                )),
                const SizedBox(height: 8),
                Wrap(spacing: 8, children: [
                  Text('argmax', style: Fonts.mono(size: 9, color: Col.inkMute)),
                  Text('·', style: Fonts.mono(size: 9, color: Col.inkMute)),
                  Text('softmax', style: Fonts.mono(size: 9, color: Col.inkMute)),
                  Text('·', style: Fonts.mono(size: 9, color: Col.inkMute)),
                  Text('rep_penalty=1.1', style: Fonts.mono(size: 9, color: Col.inkMute)),
                ]),
              ]),
            ]);
          },
        ),
      );
  Widget _row((String, double) entry, int i) {
    final winner = i == 0;
    final color = winner ? Col.acid : Col.magenta;
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(children: [
        SizedBox(width: 16, child: Text('#${i + 1}', textAlign: TextAlign.right,
            style: Fonts.pixel(size: 8, color: winner ? Col.acid : Col.inkMute))),
        const SizedBox(width: 6),
        Container(
          width: 60,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: winner ? Col.acid : Colors.black,
            border: Border.all(color: winner ? Col.acid : Col.line),
          ),
          child: Text(entry.$1.trim().isEmpty ? '·' : entry.$1,
              style: Fonts.mono(size: 11, color: winner ? Colors.black : Col.ink)),
        ),
        const SizedBox(width: 6),
        Expanded(child: Container(height: 8, color: Col.line, child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(widthFactor: entry.$2, child: Container(color: color)),
        ))),
        const SizedBox(width: 6),
        SizedBox(width: 36, child: Text('${(entry.$2 * 100).round()}%', textAlign: TextAlign.right,
            style: Fonts.mono(size: 10, color: winner ? Col.acid : Col.inkDim))),
      ]),
    );
  }
}

// ─── L14 — Token RAG ──────────────────────────────────────────────────────
class LoaderTokenRAG extends StatelessWidget {
  const LoaderTokenRAG({super.key});
  @override
  Widget build(BuildContext c) => Container(
        color: const Color(0xFF020608),
        padding: const EdgeInsets.all(12),
        child: TickerBuilder(
          interval: const Duration(milliseconds: 180),
          builder: (_, t) {
            const chunks = [
              ('D.O. Municipal SP · 2024-08', 'aditivo n°3 prorroga prazo de entrega', 0.91),
              ('queridodiario.api · trecho',  'custo revisto: R\$1.6bi → R\$4.8bi', 0.84),
              ('G1 SP · 2024-12',             'TCE-SP abre processo de fiscalização', 0.71),
            ];
            const gen = ['A',' linha',' 17-Ouro',' do',' metrô',' acumula',' aditivos',' que',' triplicaram',' o',' custo','.'];
            final cycle = t % (gen.length + 4);
            final visible = cycle.clamp(0, gen.length);
            return Stack(children: [
              const Scanlines(opacity: 0.08),
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Row(children: [
                  Container(width: 8, height: 8, color: Col.acid),
                  const SizedBox(width: 6),
                  Text('RAG · BUSCA AUMENTADA', style: Fonts.pixel(size: 9, color: Col.acid, letterSpacing: 1)),
                  const Spacer(),
                  Text('top-3', style: Fonts.mono(size: 9, color: Col.inkDim)),
                ]),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(color: const Color(0xFF0A0A0E), border: Border.all(color: Col.line, width: 1.5)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('QUERY', style: Fonts.pixel(size: 7, color: Col.inkMute, letterSpacing: 1.2)),
                    const SizedBox(height: 3),
                    Text('"transporte público sp · atraso obras"', style: Fonts.mono(size: 10, color: Col.ink)),
                  ]),
                ),
                const SizedBox(height: 8),
                Text('CHUNKS RECUPERADOS', style: Fonts.pixel(size: 7, color: Col.inkMute, letterSpacing: 1.2)),
                const SizedBox(height: 5),
                for (final ch in chunks) Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0A0E),
                    border: const Border(
                      top: BorderSide(color: Col.line),
                      right: BorderSide(color: Col.line),
                      bottom: BorderSide(color: Col.line),
                      left: BorderSide(color: Col.acid, width: 3),
                    ),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: Text(ch.$1, style: Fonts.mono(size: 9, color: Col.acid))),
                      Text('sim=${ch.$3}', style: Fonts.mono(size: 9, color: Col.magenta)),
                    ]),
                    Text('"${ch.$2}"', style: Fonts.mono(size: 9, color: Col.inkDim)),
                  ]),
                ),
                const SizedBox(height: 4),
                Expanded(child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0E0A),
                    border: Border.all(color: Col.acid, width: 1.5),
                    boxShadow: [BoxShadow(color: Col.acid.withValues(alpha: 0.13), blurRadius: 12)],
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Text('GERANDO COM CONTEXTO', style: Fonts.pixel(size: 7, color: Col.acid, letterSpacing: 1.2)),
                      const Spacer(),
                      Text('$visible/${gen.length}', style: Fonts.mono(size: 9, color: Col.acid)),
                    ]),
                    const SizedBox(height: 5),
                    Wrap(spacing: 3, runSpacing: 3, children: [
                      for (var i = 0; i < visible; i++)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: Col.acid, border: Border.all(color: Colors.black, width: 1.5)),
                          child: Text(gen[i].trim().isEmpty ? '·' : gen[i],
                              style: Fonts.mono(size: 11, color: Colors.black)),
                        ),
                    ]),
                  ]),
                )),
              ]),
            ]);
          },
        ),
      );
}

// ─── L15 — Token Layers (transformer stack) ───────────────────────────────
class LoaderTokenLayers extends StatelessWidget {
  const LoaderTokenLayers({super.key});
  @override
  Widget build(BuildContext c) => Container(
        color: const Color(0xFF020608),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: TickerBuilder(
          interval: const Duration(milliseconds: 80),
          builder: (_, t) {
            const layers = 12, tokens = 8;
            return Stack(children: [
              const Scanlines(opacity: 0.08),
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Row(children: [
                  Container(width: 8, height: 8, color: Col.magenta),
                  const SizedBox(width: 6),
                  Text('TRANSFORMER STACK', style: Fonts.pixel(size: 9, color: Col.magenta, letterSpacing: 1)),
                  const Spacer(),
                  Text('${layers}×$tokens', style: Fonts.mono(size: 9, color: Col.inkDim)),
                ]),
                const SizedBox(height: 10),
                Expanded(child: Column(children: [
                  for (var l = 0; l < layers; l++) Expanded(child: _layer(l, t, tokens)),
                ])),
                const SizedBox(height: 8),
                Wrap(spacing: 8, children: [
                  Text('self-attn → ffn → norm', style: Fonts.mono(size: 9, color: Col.inkMute)),
                  Text('·', style: Fonts.mono(size: 9, color: Col.inkMute)),
                  Text('residual', style: Fonts.mono(size: 9, color: Col.inkMute)),
                ]),
              ]),
            ]);
          },
        ),
      );
  Widget _layer(int l, int t, int tokens) {
    final active = ((t - l) % 16) < 8;
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF0A0E0A) : Colors.transparent,
        border: Border.all(color: active ? Col.acid.withValues(alpha: 0.33) : Col.line),
      ),
      child: Row(children: [
        SizedBox(width: 22, child: Text('L${(l + 1).toString().padLeft(2, '0')}',
            style: Fonts.pixel(size: 7, color: active ? Col.acid : Col.inkMute))),
        const SizedBox(width: 3),
        for (var k = 0; k < tokens; k++) ...[
          if (k > 0) const SizedBox(width: 3),
          Expanded(child: _cell(l, k, t)),
        ],
      ]),
    );
  }
  Widget _cell(int l, int k, int t) {
    final active = ((t * 2 - l + k) % 16) < 6;
    final v = (math.sin(t * 0.1 + l * 0.4 + k * 0.5) + 1) / 2;
    return Container(
      decoration: BoxDecoration(
        color: active ? Col.acid.withValues(alpha: 0.3 + v * 0.7) : const Color(0xFF0A0A0A),
        border: Border.all(color: active ? Col.acid : Col.line),
      ),
    );
  }
}
