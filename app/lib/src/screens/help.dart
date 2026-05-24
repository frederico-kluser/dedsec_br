import 'dart:async';

import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/ranking.dart';
import '../design/colors.dart';
import '../design/fonts.dart';
import '../widgets/atoms.dart';
import '../widgets/molecules.dart';
import '../widgets/utils.dart';

enum _Phase { idle, processing, done }

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});
  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  bool _auto = true;
  _Phase _phase = _Phase.idle;
  int _score = 12;

  void _start() {
    if (_phase != _Phase.idle) return;
    setState(() => _phase = _Phase.processing);
    Timer(const Duration(milliseconds: 6500), () {
      if (!mounted) return;
      setState(() {
        _score++;
        _phase = _Phase.done;
      });
      Timer(const Duration(milliseconds: 2400), () {
        if (mounted) setState(() => _phase = _Phase.idle);
      });
    });
  }

  void _cancel() => setState(() => _phase = _Phase.idle);

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return Container(
      color: DCol.bg,
      child: Stack(
        children: [
          Column(
            children: [
              const TopBar(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 22, 18, 90),
                  children: [
                    const PixelChip('MUTIRÃO_LLM', color: DCol.magenta),
                    const SizedBox(height: 12),
                    StencilTwoLine(
                      first: 'AJUDE A',
                      second: 'CÉLULA',
                      size: 42,
                      height: 0.9,
                      secondShadows: const [Shadow(color: DCol.acid, offset: Offset(3, 3))],
                    ),
                    const SizedBox(height: 12),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(text: 'Seu celular processa '),
                          TextSpan(
                            text: '1 pauta em ~60s',
                            style: DFont.body(
                              size: 13,
                              color: DCol.ink,
                              weight: FontWeight.w700,
                              height: 1.55,
                            ),
                          ),
                          const TextSpan(text: '. O resultado aparece no feed de outros usuários da sua cidade.'),
                        ],
                        style: DFont.body(size: 13, color: DCol.inkDim, height: 1.55),
                      ),
                    ),
                    const SizedBox(height: 22),
                    _primaryAction(),
                    const SizedBox(height: 14),
                    _stats(),
                    const SizedBox(height: 14),
                    _autoCard(),
                    const SizedBox(height: 22),
                    RankingPanel(user: app.user, score: _score),
                    const SizedBox(height: 22),
                    _achievementsCta(app),
                  ],
                ),
              ),
              DTabBar(active: app.tab, onTab: app.goTab),
            ],
          ),
          if (_phase == _Phase.processing) _processingOverlay(),
          if (_phase == _Phase.done) _doneOverlay(),
        ],
      ),
    );
  }

  Widget _primaryAction() {
    return Container(
      decoration: BoxDecoration(
        color: DCol.panel,
        border: Border.all(color: DCol.acid, width: 2),
        boxShadow: const [BoxShadow(color: DCol.line, offset: Offset(4, 4))],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Blink(color: DCol.acid, width: 12, height: 12),
              const SizedBox(width: 8),
              Text('DISPOSITIVO PRONTO',
                  style: DFont.pixel(size: 10, color: DCol.acid, letterSpacing: 1.5)),
            ],
          ),
          const SizedBox(height: 6),
          Text('wifi · 4.8GB livre · 34°C · 87% bateria',
              style: DFont.mono(size: 10, color: DCol.inkDim)),
          const SizedBox(height: 16),
          Btn(
            label: '▶ PROCESSAR 1 PAUTA',
            color: DCol.magenta,
            fg: Colors.white,
            full: true,
            disabled: _phase != _Phase.idle,
            onPressed: _phase == _Phase.idle ? _start : null,
          ),
        ],
      ),
    );
  }

  Widget _stats() {
    return Container(
      decoration:
          BoxDecoration(color: DCol.panel, border: Border.all(color: DCol.line, width: 1.5)),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(child: StatBox(label: 'VOCÊ HOJE', value: '$_score')),
            Container(width: 1, color: DCol.line),
            Expanded(
              child: StatBox(
                label: 'COMUNIDADE',
                value: formatNum(SCOPE_TOTALS['cidade']!),
                color: DCol.acid,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _autoCard() {
    return Container(
      decoration:
          BoxDecoration(color: DCol.panel, border: Border.all(color: DCol.line, width: 1.5)),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Modo automático',
                    style: DFont.body(
                        size: 13, color: DCol.ink, weight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text('roda só plugado + wifi + tela apagada',
                    style: DFont.mono(size: 10, color: DCol.inkDim)),
              ],
            ),
          ),
          Toggle(
            value: _auto,
            onChanged: (v) => setState(() => _auto = v),
            size: ToggleSize.sm,
          ),
        ],
      ),
    );
  }

  Widget _achievementsCta(AppState app) {
    return GestureDetector(
      onTap: () => app.go(Screen.achievements),
      child: Container(
        decoration: BoxDecoration(
          color: DCol.panel,
          border: Border.all(color: DCol.magenta, width: 1.5),
          boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: DCol.magenta,
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
                      style: DFont.pixel(
                          size: 9, color: DCol.magenta, letterSpacing: 1.2)),
                  const SizedBox(height: 4),
                  Text('Selos conquistados',
                      style: DFont.body(
                          size: 13, color: DCol.ink, weight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text.rich(
                    TextSpan(children: [
                      const TextSpan(text: '11/24 desbloqueados · '),
                      TextSpan(
                          text: '3 novos pra abrir',
                          style: DFont.mono(size: 10, color: DCol.magenta)),
                    ], style: DFont.mono(size: 10, color: DCol.inkDim)),
                  ),
                ],
              ),
            ),
            Text('›', style: TextStyle(color: DCol.inkMute, fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _processingOverlay() {
    return Positioned.fill(
      child: Container(
        color: const Color(0xFF020608).withValues(alpha: 0.98),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: const BoxDecoration(
                color: Color(0xFF050A08),
                border: Border(bottom: BorderSide(color: DCol.line)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Blink(color: DCol.acid, width: 8, height: 8),
                      const SizedBox(width: 8),
                      const PixelChip('MUTIRÃO · 1/1', color: DCol.acid, size: 8),
                      const Spacer(),
                      GestureDetector(
                        onTap: _cancel,
                        child: Container(
                          decoration: BoxDecoration(border: Border.all(color: DCol.line)),
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text('CANCELAR',
                              style: DFont.pixel(
                                  size: 8, color: DCol.inkDim, letterSpacing: 1)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const StencilTwoLine(
                    first: 'PROCESSANDO',
                    second: 'PAUTA DA FILA',
                    secondColor: DCol.acid,
                    size: 20,
                    height: 1,
                  ),
                ],
              ),
            ),
            const TokenStreamPanel(),
            Container(
              decoration:
                  const BoxDecoration(border: Border(top: BorderSide(color: DCol.line))),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Text(
                '// gemma-3-1b roda 100% local. seu celular contribui pra rede.',
                style: DFont.mono(size: 10, color: DCol.inkDim, height: 1.55),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _doneOverlay() {
    return Positioned.fill(
      child: Container(
        color: DCol.bg,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(22),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Positioned.fill(child: Halftone(color: DCol.acid, size: 6, opacity: 0.1)),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: DCol.acid,
                    border: Border.all(color: Colors.black, width: 4),
                    boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6))],
                  ),
                  child: Text('✓',
                      style:
                          DFont.pixel(size: 60, color: Colors.black, letterSpacing: 0)),
                ),
                const SizedBox(height: 26),
                const StencilTwoLine(
                  first: '+1 PAUTA',
                  second: 'PROCESSADA',
                  secondColor: DCol.acid,
                  size: 38,
                  height: 0.95,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text('obrigado por ajudar a célula.',
                    style: DFont.mono(size: 11, color: DCol.inkDim, letterSpacing: 1)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
