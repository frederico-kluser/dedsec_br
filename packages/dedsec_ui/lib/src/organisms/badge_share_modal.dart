import 'package:flutter/material.dart';
import '../atoms/avatar.dart';
import '../atoms/dashed_box.dart';
import '../atoms/halftone.dart';
import '../atoms/pixel_chip.dart';
import '../atoms/scanlines.dart';
import '../atoms/stencil.dart';
import '../state/achievements.dart';
import '../state/user.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';
import '../widgets/toggle.dart';

class DedsecBadgeShareModal extends StatefulWidget {
  final DedsecBadge badge;
  final DedsecUser user;
  final bool isLocked;
  final VoidCallback onClose;
  const DedsecBadgeShareModal({
    super.key,
    required this.badge,
    required this.user,
    required this.isLocked,
    required this.onClose,
  });

  @override
  State<DedsecBadgeShareModal> createState() => _DedsecBadgeShareModalState();
}

class _DedsecBadgeShareModalState extends State<DedsecBadgeShareModal> {
  bool _includeId = true;
  String? _shared;

  void _shareTo(String id) {
    setState(() => _shared = id);
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() => _shared = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cat = badgeCategories[widget.badge.category]!;
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.88),
        child: Stack(children: [
          const Positioned.fill(child: Scanlines(opacity: 0.08)),
          Column(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: const BoxDecoration(
                color: DedsecColors.bg,
                border: Border(bottom: BorderSide(color: DedsecColors.line)),
              ),
              child: Row(children: [
                Text(
                  widget.isLocked ? 'SELO BLOQUEADO' : 'COMPARTILHAR SELO',
                  style: DedsecFonts.pixel(size: 10, color: DedsecColors.acid, letterSpacing: 1),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: widget.onClose,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: DedsecColors.line),
                    ),
                    child: Text('× FECHAR',
                        style: DedsecFonts.pixel(size: 10, color: DedsecColors.inkDim)),
                  ),
                ),
              ]),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 100),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  _hero(cat),
                  if (!widget.isLocked) ...[
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: DedsecColors.panel,
                        border: Border.all(color: DedsecColors.line),
                      ),
                      child: Text.rich(TextSpan(
                        style: DedsecFonts.mono(size: 11, color: DedsecColors.inkDim),
                        children: const [
                          TextSpan(text: 'conquistado em '),
                          TextSpan(text: '23 mai 2026', style: TextStyle(color: DedsecColors.acid)),
                        ],
                      )),
                    ),
                    const SizedBox(height: 18),
                    _identityToggle(),
                    const SizedBox(height: 18),
                    Text('// PRÉVIA DO COMPARTILHAMENTO',
                        style: DedsecFonts.pixel(size: 8, color: DedsecColors.inkMute, letterSpacing: 1.5)),
                    const SizedBox(height: 8),
                    _preview(cat),
                    const SizedBox(height: 18),
                    Text('// COMPARTILHAR EM',
                        style: DedsecFonts.pixel(size: 8, color: DedsecColors.inkMute, letterSpacing: 1.5)),
                    const SizedBox(height: 8),
                    _shareGrid(),
                  ] else
                    _lockedHint(),
                ]),
              ),
            ),
          ]),
        ]),
      ),
    );
  }

  Widget _hero(BadgeCategoryMeta cat) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DedsecColors.panel,
        border: Border.all(color: cat.color, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
      ),
      child: Opacity(
        opacity: widget.isLocked ? 0.7 : 1,
        child: Column(children: [
          Text(widget.isLocked ? '🔒' : widget.badge.emoji,
              style: const TextStyle(fontSize: 80, height: 1)),
          const SizedBox(height: 10),
          PixelChip('${cat.label} · TIER ${widget.badge.tier}', color: cat.color, size: 8),
          const SizedBox(height: 10),
          Stencil(widget.badge.title.toUpperCase(), size: 26, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(widget.badge.desc,
              textAlign: TextAlign.center,
              style: DedsecFonts.body(size: 13, color: DedsecColors.inkDim, height: 1.5)),
        ]),
      ),
    );
  }

  Widget _identityToggle() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: DedsecColors.panel,
        border: Border.all(color: DedsecColors.line, width: 1.5),
      ),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Incluir minha identidade?',
                style: DedsecFonts.body(size: 13, weight: FontWeight.w600)),
            const SizedBox(height: 3),
            Text('avatar + pseudônimo aparecem no selo compartilhado.',
                style: DedsecFonts.mono(size: 10, color: DedsecColors.inkDim)),
          ]),
        ),
        DedsecToggle(value: _includeId, onChanged: () => setState(() => _includeId = !_includeId), size: ToggleSize.sm),
      ]),
    );
  }

  Widget _preview(BadgeCategoryMeta cat) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        border: Border.all(color: cat.color, width: 1.5),
      ),
      child: Stack(children: [
        Positioned.fill(child: Halftone(color: cat.color, size: 3, opacity: 0.1)),
        Row(children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(color: cat.color, border: Border.all(color: Colors.black, width: 2)),
            child: Center(child: Text(widget.badge.emoji, style: const TextStyle(fontSize: 36))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('CONQUISTA · DEDSEC_BR',
                  style: DedsecFonts.pixel(size: 8, color: cat.color, letterSpacing: 1)),
              const SizedBox(height: 4),
              Text(widget.badge.title,
                  style: DedsecFonts.body(size: 14, weight: FontWeight.w700)),
              const SizedBox(height: 6),
              _includeId
                  ? Row(children: [
                      Avatar(seed: widget.user.seed, size: 20, border: false),
                      const SizedBox(width: 6),
                      Text(widget.user.pseudonym,
                          style: DedsecFonts.mono(size: 10, color: DedsecColors.acid)),
                    ])
                  : Text('cidadão anônimo · sp',
                      style: DedsecFonts.mono(size: 10, color: DedsecColors.inkMute)),
            ]),
          ),
        ]),
      ]),
    );
  }

  Widget _shareGrid() {
    final channels = [
      ('ig', 'INSTAGRAM', const Color(0xFFE1306C), '📷'),
      ('x', 'X / TWITTER', const Color(0xFF1DA1F2), '🐦'),
      ('wa', 'WHATSAPP', const Color(0xFF25D366), '💬'),
      ('cp', 'COPIAR IMG', DedsecColors.acid, '📋'),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 3,
      children: [
        for (final ch in channels)
          GestureDetector(
            onTap: () => _shareTo(ch.$1),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: _shared == ch.$1 ? ch.$3 : DedsecColors.panel,
                border: Border.all(color: ch.$3, width: 1.5),
              ),
              child: Row(children: [
                Text(ch.$4, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _shared == ch.$1 ? 'ABRINDO...' : ch.$2,
                    style: DedsecFonts.pixel(
                      size: 9,
                      color: _shared == ch.$1 ? Colors.black : DedsecColors.ink,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ]),
            ),
          ),
      ],
    );
  }

  Widget _lockedHint() {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: DashedBox(
        color: DedsecColors.line,
        strokeWidth: 1.5,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('// COMO DESBLOQUEAR',
                style: DedsecFonts.pixel(size: 9, color: DedsecColors.acid)),
            const SizedBox(height: 12),
            Text(widget.badge.desc,
                style: DedsecFonts.mono(size: 11, color: DedsecColors.inkDim, letterSpacing: 0.4)),
          ]),
        ),
      ),
    );
  }
}
