import 'dart:async';

import 'package:flutter/material.dart';

import '../app/app_scope.dart';
import '../app/app_state.dart';
import '../data/ranking.dart';
import '../theme/colors.dart';
import '../theme/fonts.dart';
import '../utils/format.dart';
import '../widgets/atoms/buttons.dart';
import '../widgets/atoms/effects.dart';
import '../widgets/atoms/text_atoms.dart';
import '../widgets/molecules/bars.dart';
import '../widgets/molecules/token_stream_panel.dart';
import '../widgets/utils/layout.dart';
import '../widgets/utils/ranking_panel.dart';

enum _HelpPhase { idle, processing, done }

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});
  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  bool _auto = true;
  _HelpPhase _phase = _HelpPhase.idle;
  int _score = 12;
  Timer? _t1, _t2;

  void _start() {
    if (_phase != _HelpPhase.idle) return;
    setState(() => _phase = _HelpPhase.processing);
    _t1 = Timer(const Duration(milliseconds: 6500), () {
      if (!mounted) return;
      setState(() {
        _score++;
        _phase = _HelpPhase.done;
      });
      _t2 = Timer(const Duration(milliseconds: 2400), () {
        if (!mounted) return;
        setState(() => _phase = _HelpPhase.idle);
      });
    });
  }

  void _cancel() {
    _t1?.cancel();
    _t2?.cancel();
    setState(() => _phase = _HelpPhase.idle);
  }

  @override
  void dispose() {
    _t1?.cancel();
    _t2?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final user = state.user;
    return Container(
      color: COL.bg,
      child: Stack(
        children: [
          Column(
            children: [
              const TopBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 22, 18, 90),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PixelChip('MUTIRÃO_LLM', color: COL.magenta),
                      const SizedBox(height: 12),
                      const StencilSpans(
                        spans: [
                          TextSpan(text: 'AJUDE A\n'),
                          TextSpan(
                            text: 'CÉLULA',
                            style: TextStyle(
                              color: COL.magenta,
                              shadows: [Shadow(offset: Offset(3, 3), color: COL.acid)],
                            ),
                          ),
                        ],
                        size: 42,
                        height: 0.9,
                      ),
                      const SizedBox(height: 12),
                      Text.rich(
                        TextSpan(children: [
                          const TextSpan(text: 'Seu celular processa '),
                          TextSpan(
                            text: '1 pauta em ~60s',
                            style: const TextStyle(color: COL.ink, fontWeight: FontWeight.w700),
                          ),
                          const TextSpan(
                            text: '. O resultado aparece no feed de outros usuários da sua cidade.',
                          ),
                        ], style: FONT.body(size: 13, color: COL.inkDim, height: 1.55)),
                      ),
                      const SizedBox(height: 22),
                      // primary action
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: COL.panel,
                          border: Border.all(color: COL.acid, width: 2),
                          boxShadow: const [BoxShadow(color: COL.line, offset: Offset(4, 4))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Blink(child: Container(width: 12, height: 12, color: COL.acid)),
                                const SizedBox(width: 8),
                                Text('DISPOSITIVO PRONTO',
                                    style: FONT.pixel(size: 10, color: COL.acid, letterSpacing: 1.5)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'wifi · 4.8GB livre · 34°C · 87% bateria',
                              style: FONT.mono(size: 10, color: COL.inkDim, letterSpacing: 0.5),
                            ),
                            const SizedBox(height: 16),
                            Btn(
                              full: true,
                              color: COL.magenta,
                              fg: Colors.white,
                              onPressed: _phase == _HelpPhase.idle ? _start : null,
                              disabled: _phase != _HelpPhase.idle,
                              child: const Text('▶ PROCESSAR 1 PAUTA'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        decoration: BoxDecoration(
                          color: COL.panel,
                          border: Border.all(color: COL.line, width: 1.5),
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              Expanded(child: StatBox(label: 'VOCÊ HOJE', value: '$_score')),
                              Container(width: 1, color: COL.line),
                              Expanded(
                                child: StatBox(
                                  label: 'COMUNIDADE',
                                  value: formatNum(kScopeTotals['cidade']!),
                                  color: COL.acid,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: COL.panel,
                          border: Border.all(color: COL.line, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Modo automático',
                                      style: FONT.body(size: 13, weight: FontWeight.w600)),
                                  const SizedBox(height: 3),
                                  Text(
                                    'roda só plugado + wifi + tela apagada',
                                    style: FONT.mono(size: 10, color: COL.inkDim),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Toggle(
                              value: _auto,
                              size: ToggleSize.sm,
                              onChanged: () => setState(() => _auto = !_auto),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      RankingPanel(user: user, score: _score),
                      const SizedBox(height: 22),
                      GestureDetector(
                        onTap: () => state.go(AppRoute.achievements),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: COL.panel,
                            border: Border.all(color: COL.magenta, width: 1.5),
                            boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: COL.magenta,
                                  border: Border.all(color: Colors.black, width: 2),
                                ),
                                child: const Text('🏅', style: TextStyle(fontSize: 26)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('SUA COLEÇÃO',
                                        style: FONT.pixel(size: 9, color: COL.magenta, letterSpacing: 1.2)),
                                    const SizedBox(height: 4),
                                    Text('Selos conquistados',
                                        style: FONT.body(size: 13, weight: FontWeight.w700)),
                                    const SizedBox(height: 2),
                                    Text.rich(
                                      TextSpan(children: [
                                        const TextSpan(text: '11/24 desbloqueados · '),
                                        TextSpan(
                                          text: '3 novos pra abrir',
                                          style: const TextStyle(color: COL.magenta),
                                        ),
                                      ], style: FONT.mono(size: 10, color: COL.inkDim)),
                                    ),
                                  ],
                                ),
                              ),
                              Text('›', style: FONT.body(size: 18, color: COL.inkMute)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: DedsecTabBar(active: state.tab.name, onTab: _onTab),
          ),
          if (_phase == _HelpPhase.processing) _processing(),
          if (_phase == _HelpPhase.done) _done(),
        ],
      ),
    );
  }

  Widget _processing() {
    return Positioned.fill(
      child: Container(
        color: const Color(0xFA020608),
        child: Column(
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
                      Blink(child: Container(width: 8, height: 8, color: COL.acid)),
                      const SizedBox(width: 8),
                      const PixelChip('MUTIRÃO · 1/1', color: COL.acid, size: 8),
                      const Spacer(),
                      GestureDetector(
                        onTap: _cancel,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(border: Border.all(color: COL.line)),
                          child: Text('CANCELAR',
                              style: FONT.pixel(size: 8, color: COL.inkDim, letterSpacing: 1)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const StencilSpans(
                    spans: [
                      TextSpan(text: 'PROCESSANDO\n'),
                      TextSpan(text: 'PAUTA DA FILA', style: TextStyle(color: COL.acid)),
                    ],
                    size: 20,
                    height: 1,
                  ),
                ],
              ),
            ),
            const TokenStreamPanel(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: COL.line)),
              ),
              child: Text(
                '// gemma-3-1b roda 100% local. seu celular contribui pra rede.',
                style: FONT.mono(size: 10, color: COL.inkDim, height: 1.55),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _done() {
    return Positioned.fill(
      child: Container(
        color: COL.bg,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Halftone(color: COL.acid, size: 6, opacity: 0.1),
            for (var i = 0; i < 2; i++) _DonePulse(delay: Duration(milliseconds: i * 500)),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: COL.acid,
                    border: Border.all(color: Colors.black, width: 4),
                    boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6))],
                  ),
                  child: Text('✓', style: FONT.pixel(size: 60, color: Colors.black)),
                ),
                const SizedBox(height: 26),
                const StencilSpans(
                  spans: [
                    TextSpan(text: '+1 PAUTA\n'),
                    TextSpan(text: 'PROCESSADA', style: TextStyle(color: COL.acid)),
                  ],
                  size: 38,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text('obrigado por ajudar a célula.',
                    style: FONT.mono(size: 11, color: COL.inkDim, letterSpacing: 1)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onTab(String id) {
    final s = AppScope.read(context);
    switch (id) {
      case 'home':
        s.goTab(AppTab.home);
        break;
      case 'help':
        s.goTab(AppTab.help);
        break;
      case 'forum':
        s.goTab(AppTab.forum);
        break;
      case 'settings':
        s.goTab(AppTab.settings);
        break;
    }
  }
}

class _DonePulse extends StatefulWidget {
  final Duration delay;
  const _DonePulse({required this.delay});

  @override
  State<_DonePulse> createState() => _DonePulseState();
}

class _DonePulseState extends State<_DonePulse> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
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
      builder: (_, __) => Transform.scale(
        scale: 0.4 + _c.value,
        child: Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                COL.acid.withValues(alpha: 0.4 * (1 - _c.value)),
                Colors.transparent,
              ],
              stops: const [0.0, 0.6],
            ),
          ),
        ),
      ),
    );
  }
}
