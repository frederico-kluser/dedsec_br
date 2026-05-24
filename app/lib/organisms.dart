// organisms.dart — full-bleed overlays: ModerationOverlay, AnalysisOverlay,
// BadgeShareModal.

import 'package:flutter/material.dart' hide Badge;
import 'atoms.dart';
import 'data.dart';
import 'design.dart';
import 'molecules.dart';
import 'state.dart';
import 'utils.dart';

// ─── ModerationOverlay (idle | checking | blocked) ───────────────────────
class ModerationOverlay extends StatelessWidget {
  final String phase; // 'idle' | 'checking' | 'blocked'
  final String text;
  final String word;
  final VoidCallback onEdit;
  final VoidCallback onDiscard;
  const ModerationOverlay({super.key, required this.phase, required this.text, required this.word, required this.onEdit, required this.onDiscard});

  @override
  Widget build(BuildContext c) {
    if (phase == 'idle') return const SizedBox.shrink();
    if (phase == 'checking') return _checking();
    return _blocked();
  }

  Widget _checking() => Container(
        color: const Color(0xF7050505),
        padding: const EdgeInsets.all(22),
        child: Stack(alignment: Alignment.center, children: [
          const Scanlines(opacity: 0.1),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 140, height: 140,
              decoration: BoxDecoration(
                color: Col.acid, shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 4),
                boxShadow: const [BoxShadow(offset: Offset(6, 6), color: Colors.black)],
              ),
              child: const Center(child: Eye(size: 56, color: Colors.black)),
            ),
            const SizedBox(height: 22),
            StencilSpan(TextSpan(children: [
              const TextSpan(text: 'MODERANDO COM\n'),
              TextSpan(text: 'IA LOCAL', style: TextStyle(color: Col.acid)),
            ]), size: 26, align: TextAlign.center),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(width: 6, height: 6, color: Col.acid),
              const SizedBox(width: 6),
              Text('gemma-3-1b · classificando ódio/spam ...',
                  style: Fonts.mono(size: 10, color: Col.acid, letterSpacing: 1.5)),
            ]),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              constraints: const BoxConstraints(maxWidth: 320),
              decoration: BoxDecoration(color: Col.panel, border: Border.all(color: Col.line, width: 1)),
              child: Text('"$text"', textAlign: TextAlign.center,
                  style: Fonts.mono(size: 11, color: Col.inkDim, height: 1.5)),
            ),
          ]),
        ]),
      );

  Widget _blocked() => Container(
        color: const Color(0xF7050505),
        padding: const EdgeInsets.all(22),
        child: Stack(children: [
          const Halftone(color: Col.danger, size: 5, opacity: 0.18),
          Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Transform.rotate(angle: -2 * 3.14159 / 180, child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: const BoxDecoration(color: Col.danger, boxShadow: [BoxShadow(offset: Offset(4, 4), color: Colors.black)]),
              child: Text('BLOQUEADO', style: Fonts.pixel(size: 11, color: Colors.black, letterSpacing: 2)),
            )),
            const SizedBox(height: 18),
            StencilSpan(TextSpan(children: [
              const TextSpan(text: 'DISCURSO\n'),
              TextSpan(text: 'OFENSIVO', style: TextStyle(color: Col.danger, shadows: [Shadow(offset: Offset(3, 3), color: Col.magenta)])),
            ]), size: 34, align: TextAlign.center),
            const SizedBox(height: 14),
            Text('// a ia local detectou conteúdo que pode\n// violar as regras da comunidade.',
                textAlign: TextAlign.center,
                style: Fonts.mono(size: 11, color: Col.inkDim, height: 1.55)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              constraints: const BoxConstraints(maxWidth: 320),
              decoration: BoxDecoration(color: Col.panel, border: Border.all(color: Col.danger, width: 1.5)),
              child: Column(children: [
                Text.rich(TextSpan(children: [
                  TextSpan(text: 'sinal: ', style: Fonts.mono(size: 11, color: Col.ink)),
                  TextSpan(text: '"$word"', style: Fonts.mono(size: 11, color: Col.danger, weight: FontWeight.w700)),
                ])),
                const SizedBox(height: 4),
                Text('categoria: discurso de ódio', style: Fonts.mono(size: 9, color: Col.inkMute)),
              ]),
            ),
            const SizedBox(height: 22),
            Row(mainAxisSize: MainAxisSize.min, children: [
              GhostBtn('DESCARTAR', color: Col.inkDim, onTap: onDiscard),
              const SizedBox(width: 10),
              Btn('EDITAR ✎', color: Col.acid, onTap: onEdit),
            ]),
          ])),
        ]),
      );
}

// ─── AnalysisOverlay — 4-phase AI analysis for new pauta ─────────────────
class AnalysisPhase { final String label; final String tech; const AnalysisPhase(this.label, this.tech); }
const analysisPhases = [
  AnalysisPhase('lendo conteúdo ...', 'tokenize + chunk · 142 tokens'),
  AnalysisPhase('classificando tema ...', 'zero-shot · 20 categorias'),
  AnalysisPhase('identificando autoridades ...', 'lookup TSE + Câmara API'),
  AnalysisPhase('gerando título + resumo ...', 'gemma-3-1b · prompt cidadania'),
];

class AnalysisOverlay extends StatelessWidget {
  final String phase; // 'idle' | 'analyzing'
  final int currentPhase;
  final String inputText;
  const AnalysisOverlay({super.key, required this.phase, required this.currentPhase, required this.inputText});

  @override
  Widget build(BuildContext c) {
    if (phase != 'analyzing') return const SizedBox.shrink();
    final cur = analysisPhases[currentPhase.clamp(0, analysisPhases.length - 1)];
    var tokens = inputText.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).take(10).toList();
    if (tokens.isEmpty) tokens = ['[vazio]'];
    final inputTokens = ['[BOS]', ...tokens, '[EOS]'];
    final phaseOutputs = [
      ['lendo','·','142','tokens','✓'],
      ['tema','=','transporte','(','87%',')','✓'],
      ['autoridade','=','prefeito','·','câmara','✓'],
      ['título','=','linha','17-ouro','...','✓'],
    ];
    final outputTokens = <String>[];
    for (var i = 0; i <= currentPhase && i < phaseOutputs.length; i++) {
      outputTokens.addAll(phaseOutputs[i]);
    }

    return Container(
      color: const Color(0xFA020608),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: const BoxDecoration(color: Color(0xFF050A08), border: Border(bottom: BorderSide(color: Col.line))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(width: 8, height: 8, color: Col.magenta),
              const SizedBox(width: 8),
              const PixelChip('IA LOCAL · PROCESSANDO', color: Col.magenta, size: 8),
            ]),
            const SizedBox(height: 8),
            StencilSpan(TextSpan(children: [
              const TextSpan(text: 'ANALISANDO\n'),
              TextSpan(text: 'PAUTA', style: TextStyle(color: Col.magenta)),
            ]), size: 22),
            const SizedBox(height: 8),
            Text('// ${cur.label}', style: Fonts.mono(size: 10, color: Col.acid, letterSpacing: 1.2)),
            Text('// ${cur.tech}', style: Fonts.mono(size: 9, color: Col.inkMute)),
          ]),
        ),
        TokenStreamPanel(inputTokens: inputTokens, outputTokens: outputTokens, modelLabel: 'GEMMA-3-1B · pt-BR'),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: const BoxDecoration(border: Border(top: BorderSide(color: Col.line))),
          child: Row(children: [
            for (var i = 0; i < analysisPhases.length; i++) ...[
              if (i > 0) const SizedBox(width: 6),
              Expanded(child: Column(children: [
                Container(
                  height: 5,
                  color: i <= currentPhase ? Col.magenta : Col.line,
                ),
                const SizedBox(height: 4),
                Text(
                  i < currentPhase ? '✓' : '${i + 1}',
                  style: Fonts.pixel(
                    size: 7,
                    color: i == currentPhase ? Col.magenta : i < currentPhase ? Col.acid : Col.inkMute,
                    letterSpacing: 1,
                  ),
                ),
              ])),
            ],
          ]),
        ),
      ]),
    );
  }
}

// ─── BadgeShareModal — pretty share preview for a badge ───────────────────
class BadgeShareModal extends StatefulWidget {
  final Badge badge;
  final DedsecUser user;
  final bool isLocked;
  final VoidCallback onClose;
  const BadgeShareModal({super.key, required this.badge, required this.user, this.isLocked = false, required this.onClose});
  @override
  State<BadgeShareModal> createState() => _BadgeShareModalState();
}

class _BadgeShareModalState extends State<BadgeShareModal> {
  bool _includeId = true;
  String? _shared;

  @override
  Widget build(BuildContext c) {
    final cat = badgeCategories[widget.badge.category]!;
    final color = Color(cat.color);
    return Container(
      color: const Color(0xE0000000),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: const BoxDecoration(color: Col.bg, border: Border(bottom: BorderSide(color: Col.line))),
          child: Row(children: [
            Text(widget.isLocked ? 'SELO BLOQUEADO' : 'COMPARTILHAR SELO',
                style: Fonts.pixel(size: 10, color: Col.acid, letterSpacing: 1)),
            const Spacer(),
            GestureDetector(
              onTap: widget.onClose,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(border: Border.all(color: Col.line)),
                child: Text('× FECHAR', style: Fonts.pixel(size: 10, color: Col.inkDim)),
              ),
            ),
          ]),
        ),
        ScrollArea(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 100),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // hero
            ColorFiltered(
              colorFilter: widget.isLocked
                  ? const ColorFilter.matrix(<double>[
                      0.5, 0.5, 0.5, 0, 0,
                      0.5, 0.5, 0.5, 0, 0,
                      0.5, 0.5, 0.5, 0, 0,
                      0, 0, 0, 0.7, 0,
                    ])
                  : const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Col.panel,
                  border: Border.all(color: color, width: 2),
                  boxShadow: const [BoxShadow(offset: Offset(4, 4), color: Colors.black)],
                ),
                child: Stack(children: [
                  Halftone(color: color, size: 4, opacity: 0.12),
                  Column(children: [
                    Text(widget.isLocked ? '🔒' : widget.badge.emoji,
                        style: const TextStyle(fontSize: 80, height: 1)),
                    const SizedBox(height: 10),
                    PixelChip('${cat.label} · TIER ${widget.badge.tier}', color: color, size: 8),
                    const SizedBox(height: 10),
                    Stencil(widget.badge.title.toUpperCase(), size: 26, align: TextAlign.center),
                    const SizedBox(height: 8),
                    Text(widget.badge.desc, textAlign: TextAlign.center,
                        style: Fonts.body(size: 13, color: Col.inkDim, height: 1.5)),
                  ]),
                ]),
              ),
            ),
            if (!widget.isLocked) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(color: Col.panel, border: Border.all(color: Col.line, width: 1)),
                child: Text.rich(TextSpan(children: [
                  TextSpan(text: 'conquistado em ', style: Fonts.mono(size: 11, color: Col.inkDim)),
                  TextSpan(text: '23 mai 2026', style: Fonts.mono(size: 11, color: Col.acid)),
                ])),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Col.panel, border: Border.all(color: Col.line, width: 1.5)),
                child: Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Incluir minha identidade?', style: Fonts.body(size: 13, color: Col.ink, weight: FontWeight.w600)),
                    const SizedBox(height: 3),
                    Text('avatar + pseudônimo aparecem no selo compartilhado.',
                        style: Fonts.mono(size: 10, color: Col.inkDim)),
                  ])),
                  Toggle(value: _includeId, onChanged: () => setState(() => _includeId = !_includeId), size: 'sm'),
                ]),
              ),
              const SizedBox(height: 18),
              Text('// PRÉVIA DO COMPARTILHAMENTO', style: Fonts.pixel(size: 8, color: Col.inkMute, letterSpacing: 1.5)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFF0A0A0A), border: Border.all(color: color, width: 1.5)),
                child: Stack(children: [
                  Halftone(color: color, size: 3, opacity: 0.1),
                  Row(children: [
                    Container(
                      width: 64, height: 64,
                      decoration: BoxDecoration(color: color, border: Border.all(color: Colors.black, width: 2)),
                      alignment: Alignment.center,
                      child: Text(widget.badge.emoji, style: const TextStyle(fontSize: 36)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('CONQUISTA · DEDSEC_BR', style: Fonts.pixel(size: 8, color: color, letterSpacing: 1)),
                      const SizedBox(height: 4),
                      Text(widget.badge.title, style: Fonts.body(size: 14, color: Col.ink, weight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      if (_includeId) Row(children: [
                        Avatar(seed: widget.user.seed, size: 20, border: false),
                        const SizedBox(width: 6),
                        Text(widget.user.pseudonym, style: Fonts.mono(size: 10, color: Col.acid)),
                      ]) else Text('cidadão anônimo · sp', style: Fonts.mono(size: 10, color: Col.inkMute)),
                    ])),
                  ]),
                ]),
              ),
              const SizedBox(height: 18),
              Text('// COMPARTILHAR EM', style: Fonts.pixel(size: 8, color: Col.inkMute, letterSpacing: 1.5)),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8, children: [
                for (final ch in const [
                  ('ig', 'INSTAGRAM', 0xFFE1306C, '📷'),
                  ('x',  'X / TWITTER', 0xFF1DA1F2, '🐦'),
                  ('wa', 'WHATSAPP', 0xFF25D366, '💬'),
                  ('cp', 'COPIAR IMG', 0xFFB7FF2A, '📋'),
                ])
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 48) / 2,
                    child: GestureDetector(
                      onTap: () { setState(() => _shared = ch.$1); Future.delayed(const Duration(milliseconds: 1500), () { if (mounted) setState(() => _shared = null); }); },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: _shared == ch.$1 ? Color(ch.$3) : Col.panel,
                          border: Border.all(color: Color(ch.$3), width: 1.5),
                        ),
                        child: Row(children: [
                          Text(ch.$4, style: const TextStyle(fontSize: 18)),
                          const SizedBox(width: 8),
                          Expanded(child: Text(_shared == ch.$1 ? 'ABRINDO...' : ch.$2,
                              style: Fonts.pixel(size: 9, color: _shared == ch.$1 ? Colors.black : Col.ink, letterSpacing: 1))),
                        ]),
                      ),
                    ),
                  ),
              ]),
            ] else ...[
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Col.panel, border: Border.all(color: Col.line, width: 1.5)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('// COMO DESBLOQUEAR', style: Fonts.pixel(size: 9, color: Col.acid)),
                  const SizedBox(height: 12),
                  Text(widget.badge.desc, style: Fonts.mono(size: 11, color: Col.inkDim, height: 1.55)),
                ]),
              ),
            ],
          ]),
        ),
      ]),
    );
  }
}
