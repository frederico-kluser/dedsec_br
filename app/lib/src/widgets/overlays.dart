import 'package:flutter/material.dart';

import '../data/models.dart';
import '../design/colors.dart';
import '../design/fonts.dart';
import 'atoms.dart';
import 'molecules.dart';
import 'utils.dart';

// ─────────────────────────────────────────────────────────────────────
// ModerationOverlay — checking | blocked full-bleed overlay
// ─────────────────────────────────────────────────────────────────────
enum ModPhase { idle, checking, blocked }

class ModerationOverlay extends StatelessWidget {
  const ModerationOverlay({
    super.key,
    required this.phase,
    required this.text,
    this.word,
    this.onEdit,
    this.onDiscard,
  });

  final ModPhase phase;
  final String text;
  final String? word;
  final VoidCallback? onEdit;
  final VoidCallback? onDiscard;

  @override
  Widget build(BuildContext context) {
    if (phase == ModPhase.idle) return const SizedBox.shrink();
    return Positioned.fill(
      child: Container(
        color: DCol.bg.withValues(alpha: 0.97),
        padding: const EdgeInsets.all(22),
        child: Stack(
          children: [
            const Positioned.fill(child: Scanlines(opacity: 0.1)),
            if (phase == ModPhase.checking) _checking(text),
            if (phase == ModPhase.blocked) _blocked(text, word ?? '', onEdit, onDiscard),
          ],
        ),
      ),
    );
  }

  Widget _checking(String text) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              for (var i = 0; i < 3; i++) _PulseRing(delay: i * 0.27),
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: DCol.acid,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 4),
                  boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6))],
                ),
                alignment: Alignment.center,
                child: const Eye(size: 56, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 22),
          const StencilTwoLine(
            first: 'MODERANDO COM',
            second: 'IA LOCAL',
            secondColor: DCol.acid,
            textAlign: TextAlign.center,
            size: 26,
            height: 1.05,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Blink(color: DCol.acid, width: 6, height: 6),
              const SizedBox(width: 6),
              Text(
                'gemma-3-1b · classificando ódio/spam ...',
                style: DFont.mono(size: 10, color: DCol.acid, letterSpacing: 1.5),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration:
                BoxDecoration(color: DCol.panel, border: Border.all(color: DCol.line)),
            constraints: const BoxConstraints(maxWidth: 300),
            child: Text('"$text"',
                textAlign: TextAlign.center,
                style: DFont.mono(size: 11, color: DCol.inkDim, height: 1.5)),
          ),
        ],
      ),
    );
  }

  Widget _blocked(String text, String word, VoidCallback? onEdit, VoidCallback? onDiscard) {
    return Stack(
      children: [
        Positioned.fill(child: Halftone(color: DCol.danger, size: 5, opacity: 0.18)),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.rotate(
                angle: -2 * 3.14159 / 180,
                child: Container(
                  color: DCol.danger,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  child: Text('BLOQUEADO',
                      style: DFont.pixel(
                          size: 11, color: Colors.black, letterSpacing: 2)),
                ),
              ),
              const SizedBox(height: 18),
              const StencilTwoLine(
                first: 'DISCURSO',
                second: 'OFENSIVO',
                secondColor: DCol.danger,
                size: 34,
                textAlign: TextAlign.center,
                height: 1,
              ),
              const SizedBox(height: 14),
              Text(
                '// a ia local detectou conteúdo que pode\n// violar as regras da comunidade.',
                textAlign: TextAlign.center,
                style: DFont.mono(size: 11, color: DCol.inkDim, height: 1.55),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                constraints: const BoxConstraints(maxWidth: 320),
                decoration: BoxDecoration(
                  color: DCol.panel,
                  border: Border.all(color: DCol.danger, width: 1.5),
                ),
                child: Column(
                  children: [
                    Text.rich(
                      TextSpan(children: [
                        const TextSpan(text: 'sinal: '),
                        TextSpan(
                            text: '"$word"',
                            style: DFont.mono(
                                size: 11, color: DCol.danger, weight: FontWeight.w700)),
                      ], style: DFont.mono(size: 11, color: DCol.ink)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text('categoria: discurso de ódio',
                        style: DFont.mono(size: 9, color: DCol.inkMute)),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GhostBtn(label: 'DESCARTAR', color: DCol.inkDim, onPressed: onDiscard),
                  const SizedBox(width: 10),
                  Btn(label: 'EDITAR ✎', color: DCol.acid, onPressed: onEdit),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PulseRing extends StatefulWidget {
  const _PulseRing({this.delay = 0});
  final double delay;
  @override
  State<_PulseRing> createState() => _PulseRingState();
}

class _PulseRingState extends State<_PulseRing> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400))
      ..repeat();
    Future.delayed(Duration(milliseconds: (widget.delay * 1000).toInt()), () {
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
        final t = ((_c.value + widget.delay) % 1.0);
        final scale = 0.4 + t * 1.0;
        final opacity = (1 - t) * 0.8;
        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [DCol.acid.withValues(alpha: 0.33), Colors.transparent],
                  stops: const [0, 0.6],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// AnalysisOverlay — IA analysis phases + TokenStreamPanel
// ─────────────────────────────────────────────────────────────────────
const ANALYSIS_PHASES = [
  (label: 'lendo conteúdo ...', tech: 'tokenize + chunk · 142 tokens'),
  (label: 'classificando tema ...', tech: 'zero-shot · 20 categorias'),
  (label: 'identificando autoridades ...', tech: 'lookup TSE + Câmara API'),
  (label: 'gerando título + resumo ...', tech: 'gemma-3-1b · prompt cidadania'),
];

enum AnalysisPhase { idle, analyzing }

class AnalysisOverlay extends StatelessWidget {
  const AnalysisOverlay({
    super.key,
    required this.phase,
    required this.currentPhase,
    this.inputText = '',
  });

  final AnalysisPhase phase;
  final int currentPhase;
  final String inputText;

  static const _phaseOutputs = [
    ['lendo', '·', '142', 'tokens', '✓'],
    ['tema', '=', 'transporte', '(', '87%', ')', '✓'],
    ['autoridade', '=', 'prefeito', '·', 'câmara', '✓'],
    ['título', '=', 'linha', '17-ouro', '...', '✓'],
  ];

  @override
  Widget build(BuildContext context) {
    if (phase != AnalysisPhase.analyzing) return const SizedBox.shrink();
    final cur = ANALYSIS_PHASES[currentPhase.clamp(0, ANALYSIS_PHASES.length - 1)];

    var inputTokens = inputText.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).take(10).toList();
    if (inputTokens.isEmpty) inputTokens = ['[vazio]'];
    inputTokens = ['[BOS]', ...inputTokens, '[EOS]'];

    final outputTokens = <String>[];
    for (var i = 0; i <= currentPhase && i < _phaseOutputs.length; i++) {
      outputTokens.addAll(_phaseOutputs[i]);
    }

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
                      const Blink(color: DCol.magenta, width: 8, height: 8),
                      const SizedBox(width: 8),
                      const PixelChip('IA LOCAL · PROCESSANDO',
                          color: DCol.magenta, size: 8),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const StencilTwoLine(
                    first: 'ANALISANDO',
                    second: 'PAUTA',
                    secondColor: DCol.magenta,
                    size: 22,
                    height: 1,
                  ),
                  const SizedBox(height: 8),
                  Text('// ${cur.label}',
                      style: DFont.mono(size: 10, color: DCol.acid, letterSpacing: 1.2)),
                  const SizedBox(height: 2),
                  Text('// ${cur.tech}',
                      style: DFont.mono(size: 9, color: DCol.inkMute)),
                ],
              ),
            ),
            TokenStreamPanel(
              inputTokens: inputTokens,
              outputTokens: outputTokens,
              modelLabel: 'GEMMA-3-1B · pt-BR',
            ),
            Container(
              decoration:
                  const BoxDecoration(border: Border(top: BorderSide(color: DCol.line))),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: List.generate(ANALYSIS_PHASES.length, (i) {
                  final past = i < currentPhase;
                  final active = i == currentPhase;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Column(
                        children: [
                          Container(
                            height: 5,
                            decoration: BoxDecoration(
                              color: i <= currentPhase ? DCol.magenta : DCol.line,
                              boxShadow: active
                                  ? [BoxShadow(color: DCol.magenta.withValues(alpha: 0.5), blurRadius: 8)]
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            past ? '✓' : '${i + 1}',
                            style: DFont.pixel(
                              size: 7,
                              color: active
                                  ? DCol.magenta
                                  : past
                                      ? DCol.acid
                                      : DCol.inkMute,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// BadgeShareModal — share a single badge
// ─────────────────────────────────────────────────────────────────────
class BadgeShareModal extends StatefulWidget {
  const BadgeShareModal({
    super.key,
    required this.badge,
    required this.user,
    required this.isLocked,
    required this.onClose,
  });

  final DBadge? badge;
  final DUser user;
  final bool isLocked;
  final VoidCallback onClose;

  @override
  State<BadgeShareModal> createState() => _BadgeShareModalState();
}

class _BadgeShareModalState extends State<BadgeShareModal> {
  bool _includeId = true;
  String? _shared;

  void _shareTo(String where) {
    setState(() => _shared = where);
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _shared = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final badge = widget.badge;
    if (badge == null) return const SizedBox.shrink();
    final cat = BADGE_CATEGORIES[badge.category]!;

    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.88),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: DCol.bg,
                border: Border(bottom: BorderSide(color: DCol.line)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Text(
                    widget.isLocked ? 'SELO BLOQUEADO' : 'COMPARTILHAR SELO',
                    style: DFont.pixel(size: 10, color: DCol.acid, letterSpacing: 1),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: widget.onClose,
                    child: Container(
                      decoration: BoxDecoration(border: Border.all(color: DCol.line)),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text('× FECHAR',
                          style: DFont.pixel(size: 10, color: DCol.inkDim)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 100),
                children: [
                  _badgeHero(badge, cat),
                  if (!widget.isLocked) ..._unlockedBody(badge, cat),
                  if (widget.isLocked)
                    Padding(
                      padding: const EdgeInsets.only(top: 18),
                      child: Container(
                        decoration: BoxDecoration(
                          color: DCol.panel,
                          border: Border.all(color: DCol.line, width: 1.5),
                        ),
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('// COMO DESBLOQUEAR',
                                style: DFont.pixel(size: 9, color: DCol.acid)),
                            const SizedBox(height: 12),
                            Text(badge.desc,
                                style: DFont.mono(
                                    size: 11, color: DCol.inkDim, height: 1.55)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badgeHero(DBadge badge, BadgeCategory cat) {
    return ColorFiltered(
      colorFilter: widget.isLocked
          ? const ColorFilter.matrix([
              0.6, 0.6, 0.6, 0, 0,
              0.6, 0.6, 0.6, 0, 0,
              0.6, 0.6, 0.6, 0, 0,
              0,   0,   0,   1, 0,
            ])
          : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: DCol.panel,
          border: Border.all(color: cat.color, width: 2),
          boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
        ),
        child: Stack(
          children: [
            Positioned.fill(child: Halftone(color: cat.color, size: 4, opacity: 0.12)),
            Column(
              children: [
                Text(widget.isLocked ? '🔒' : badge.emoji,
                    style: const TextStyle(fontSize: 80, height: 1)),
                const SizedBox(height: 10),
                PixelChip('${cat.label} · TIER ${badge.tier}', color: cat.color, size: 8),
                const SizedBox(height: 10),
                Stencil(badge.title, size: 26, textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(badge.desc,
                    textAlign: TextAlign.center,
                    style: DFont.body(size: 13, color: DCol.inkDim, height: 1.5)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _unlockedBody(DBadge badge, BadgeCategory cat) {
    return [
      const SizedBox(height: 14),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration:
            BoxDecoration(color: DCol.panel, border: Border.all(color: DCol.line)),
        child: Text.rich(
          TextSpan(children: [
            const TextSpan(text: 'conquistado em '),
            TextSpan(text: '23 mai 2026', style: DFont.mono(size: 11, color: DCol.acid)),
          ], style: DFont.mono(size: 11, color: DCol.inkDim)),
        ),
      ),
      const SizedBox(height: 18),
      Container(
        decoration: BoxDecoration(
          color: DCol.panel,
          border: Border.all(color: DCol.line, width: 1.5),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Incluir minha identidade?',
                      style: DFont.body(
                          size: 13, color: DCol.ink, weight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Text('avatar + pseudônimo aparecem no selo compartilhado.',
                      style: DFont.mono(size: 10, color: DCol.inkDim)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Toggle(
              value: _includeId,
              onChanged: (v) => setState(() => _includeId = v),
              size: ToggleSize.sm,
            ),
          ],
        ),
      ),
      const SizedBox(height: 18),
      Text('// PRÉVIA DO COMPARTILHAMENTO',
          style: DFont.pixel(size: 8, color: DCol.inkMute, letterSpacing: 1.5)),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0A0A0A),
          border: Border.all(color: cat.color, width: 1.5),
        ),
        padding: const EdgeInsets.all(14),
        child: Stack(
          children: [
            Positioned.fill(child: Halftone(color: cat.color, size: 3, opacity: 0.1)),
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  color: cat.color,
                  alignment: Alignment.center,
                  child: Text(badge.emoji, style: const TextStyle(fontSize: 36)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CONQUISTA · DEDSEC_BR',
                          style:
                              DFont.pixel(size: 8, color: cat.color, letterSpacing: 1)),
                      const SizedBox(height: 4),
                      Text(badge.title,
                          style: DFont.body(
                              size: 14,
                              color: DCol.ink,
                              weight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      if (_includeId)
                        Row(
                          children: [
                            Avatar(seed: widget.user.seed, size: 20, border: false),
                            const SizedBox(width: 6),
                            Text(widget.user.pseudonym,
                                style: DFont.mono(size: 10, color: DCol.acid)),
                          ],
                        )
                      else
                        Text('cidadão anônimo · sp',
                            style: DFont.mono(size: 10, color: DCol.inkMute)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 18),
      Text('// COMPARTILHAR EM',
          style: DFont.pixel(size: 8, color: DCol.inkMute, letterSpacing: 1.5)),
      const SizedBox(height: 8),
      GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 3.4,
        children: [
          _shareBtn('ig', 'INSTAGRAM', const Color(0xFFE1306C), '📷'),
          _shareBtn('x', 'X / TWITTER', const Color(0xFF1DA1F2), '🐦'),
          _shareBtn('wa', 'WHATSAPP', const Color(0xFF25D366), '💬'),
          _shareBtn('cp', 'COPIAR IMG', DCol.acid, '📋'),
        ],
      ),
    ];
  }

  Widget _shareBtn(String id, String label, Color color, String glyph) {
    final on = _shared == id;
    return GestureDetector(
      onTap: () => _shareTo(id),
      child: Container(
        decoration: BoxDecoration(
          color: on ? color : DCol.panel,
          border: Border.all(color: color, width: 1.5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Text(glyph, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(on ? 'ABRINDO...' : label,
                  style: DFont.pixel(
                      size: 9, color: on ? Colors.black : DCol.ink, letterSpacing: 1)),
            ),
          ],
        ),
      ),
    );
  }
}
