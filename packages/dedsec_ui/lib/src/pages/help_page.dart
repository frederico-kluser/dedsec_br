import 'dart:async';
import 'package:flutter/material.dart';
import '../atoms/btn.dart';
import '../atoms/halftone.dart';
import '../atoms/pixel_chip.dart';
import '../atoms/stencil.dart';
import '../molecules/tab_bar.dart';
import '../molecules/token_stream_panel.dart';
import '../molecules/top_bar.dart';
import '../state/ranking.dart';
import '../state/user.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';
import '../widgets/ranking_panel.dart';
import '../widgets/screen_root.dart';
import '../widgets/stat_box.dart';
import '../widgets/toggle.dart';
import 'route.dart';

enum _HelpPhase { idle, processing, done }

class HelpPage extends StatefulWidget {
  final ValueChanged<DedsecScreen> onGo;
  final String activeTab;
  final ValueChanged<String> onTab;
  final DedsecUser user;
  const HelpPage({
    super.key,
    required this.onGo,
    required this.activeTab,
    required this.onTab,
    required this.user,
  });

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  bool _auto = true;
  _HelpPhase _phase = _HelpPhase.idle;
  int _score = 12;
  Timer? _t1;
  Timer? _t2;

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
    return ScreenRoot(
      child: Stack(children: [
        Column(children: [
          const DedsecTopBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 90),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const PixelChip('MUTIRÃO_LLM', color: DedsecColors.magenta),
                const SizedBox(height: 12),
                StencilRich(size: 42, spans: const [
                  TextSpan(text: 'AJUDE A\n'),
                  TextSpan(text: 'CÉLULA',
                      style: TextStyle(
                        color: DedsecColors.magenta,
                        shadows: [Shadow(color: DedsecColors.acid, offset: Offset(3, 3))],
                      )),
                ]),
                const SizedBox(height: 12),
                RichText(
                  text: TextSpan(
                    style: DedsecFonts.body(size: 13, color: DedsecColors.inkDim, height: 1.55),
                    children: const [
                      TextSpan(text: 'Seu celular processa '),
                      TextSpan(text: '1 pauta em ~60s', style: TextStyle(fontWeight: FontWeight.bold, color: DedsecColors.ink)),
                      TextSpan(text: '. O resultado aparece no feed de outros usuários da sua cidade.'),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: DedsecColors.panel,
                    border: Border.all(color: DedsecColors.acid, width: 2),
                    boxShadow: const [BoxShadow(color: DedsecColors.line, offset: Offset(4, 4))],
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Container(width: 12, height: 12, color: DedsecColors.acid),
                      const SizedBox(width: 8),
                      Text('DISPOSITIVO PRONTO',
                          style: DedsecFonts.pixel(size: 10, color: DedsecColors.acid, letterSpacing: 1.5)),
                    ]),
                    const SizedBox(height: 4),
                    Text('wifi · 4.8GB livre · 34°C · 87% bateria',
                        style: DedsecFonts.mono(size: 10, color: DedsecColors.inkDim, letterSpacing: 0.5)),
                    const SizedBox(height: 16),
                    Btn(
                      label: '▶ PROCESSAR 1 PAUTA',
                      color: DedsecColors.magenta,
                      fg: Colors.white,
                      full: true,
                      disabled: _phase != _HelpPhase.idle,
                      onPressed: _phase == _HelpPhase.idle ? _start : null,
                    ),
                  ]),
                ),
                const SizedBox(height: 14),
                Container(
                  decoration: BoxDecoration(
                    color: DedsecColors.panel,
                    border: Border.all(color: DedsecColors.line, width: 1.5),
                  ),
                  child: Row(children: [
                    Expanded(child: StatBox(label: 'VOCÊ HOJE', value: '$_score')),
                    Container(width: 1, color: DedsecColors.line, height: 56),
                    Expanded(child: StatBox(label: 'COMUNIDADE', value: formatNum(scopeTotals['cidade']!), color: DedsecColors.acid)),
                  ]),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: DedsecColors.panel,
                    border: Border.all(color: DedsecColors.line, width: 1.5),
                  ),
                  child: Row(children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Modo automático', style: DedsecFonts.body(size: 13, weight: FontWeight.w600)),
                        const SizedBox(height: 3),
                        Text('roda só plugado + wifi + tela apagada',
                            style: DedsecFonts.mono(size: 10, color: DedsecColors.inkDim)),
                      ]),
                    ),
                    DedsecToggle(value: _auto, onChanged: () => setState(() => _auto = !_auto), size: ToggleSize.sm),
                  ]),
                ),
                const SizedBox(height: 22),
                RankingPanel(user: widget.user, score: _score),
                const SizedBox(height: 22),
                GestureDetector(
                  onTap: () => widget.onGo(DedsecScreen.achievements),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: DedsecColors.panel,
                      border: Border.all(color: DedsecColors.magenta, width: 1.5),
                      boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                    ),
                    child: Row(children: [
                      Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(color: DedsecColors.magenta, border: Border.all(color: Colors.black, width: 2)),
                        child: const Center(child: Text('🏅', style: TextStyle(fontSize: 26))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('SUA COLEÇÃO',
                              style: DedsecFonts.pixel(size: 9, color: DedsecColors.magenta, letterSpacing: 1.2)),
                          const SizedBox(height: 4),
                          Text('Selos conquistados',
                              style: DedsecFonts.body(size: 13, weight: FontWeight.w700)),
                          const SizedBox(height: 2),
                          Text.rich(TextSpan(
                            style: DedsecFonts.mono(size: 10, color: DedsecColors.inkDim),
                            children: const [
                              TextSpan(text: '11/24 desbloqueados · '),
                              TextSpan(text: '3 novos pra abrir', style: TextStyle(color: DedsecColors.magenta)),
                            ],
                          )),
                        ]),
                      ),
                      Text('›', style: TextStyle(color: DedsecColors.inkMute, fontSize: 18)),
                    ]),
                  ),
                ),
              ]),
            ),
          ),
          DedsecTabBar(active: widget.activeTab, onTab: widget.onTab),
        ]),
        if (_phase == _HelpPhase.processing) _processingOverlay(),
        if (_phase == _HelpPhase.done) _doneOverlay(),
      ]),
    );
  }

  Widget _processingOverlay() {
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
                Container(width: 8, height: 8, color: DedsecColors.acid),
                const SizedBox(width: 8),
                const PixelChip('MUTIRÃO · 1/1', color: DedsecColors.acid, size: 8),
                const Spacer(),
                GestureDetector(
                  onTap: _cancel,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(border: Border.all(color: DedsecColors.line)),
                    child: Text('CANCELAR',
                        style: DedsecFonts.pixel(size: 8, color: DedsecColors.inkDim, letterSpacing: 1)),
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              StencilRich(size: 20, spans: const [
                TextSpan(text: 'PROCESSANDO\n'),
                TextSpan(text: 'PAUTA DA FILA', style: TextStyle(color: DedsecColors.acid)),
              ]),
            ]),
          ),
          const Expanded(child: TokenStreamPanel()),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: DedsecColors.line))),
            child: Text('// gemma-3-1b roda 100% local. seu celular contribui pra rede.',
                style: DedsecFonts.mono(size: 10, color: DedsecColors.inkDim)),
          ),
        ]),
      ),
    );
  }

  Widget _doneOverlay() {
    return Positioned.fill(
      child: Container(
        color: DedsecColors.bg,
        child: Stack(children: [
          const Positioned.fill(child: Halftone(color: DedsecColors.acid, size: 6, opacity: 0.1)),
          Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                  color: DedsecColors.acid,
                  border: Border.all(color: Colors.black, width: 4),
                  boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6))],
                ),
                child: Center(
                  child: Text('✓',
                      style: DedsecFonts.pixel(size: 60, color: Colors.black)),
                ),
              ),
              const SizedBox(height: 26),
              StencilRich(
                textAlign: TextAlign.center,
                size: 38,
                spans: const [
                  TextSpan(text: '+1 PAUTA\n'),
                  TextSpan(text: 'PROCESSADA', style: TextStyle(color: DedsecColors.acid)),
                ],
              ),
              const SizedBox(height: 12),
              Text('obrigado por ajudar a célula.',
                  style: DedsecFonts.mono(size: 11, color: DedsecColors.inkDim, letterSpacing: 1)),
            ]),
          ),
        ]),
      ),
    );
  }
}
