import 'package:flutter/material.dart';

import '../../data/achievements_data.dart';
import '../../models/badge.dart';
import '../../models/user.dart';
import '../../theme/colors.dart';
import '../../theme/fonts.dart';
import '../atoms/avatar.dart';
import '../atoms/effects.dart';
import '../atoms/text_atoms.dart';
import '../utils/layout.dart';

/// `organisms/BadgeShareModal` — sheet exposing one selected badge.
class BadgeShareModal extends StatefulWidget {
  final DedsecBadge? badge;
  final DedsecUser user;
  final bool isLocked;
  final VoidCallback onClose;

  const BadgeShareModal({
    super.key,
    required this.badge,
    required this.user,
    required this.isLocked,
    required this.onClose,
  });

  @override
  State<BadgeShareModal> createState() => _BadgeShareModalState();
}

class _BadgeShareModalState extends State<BadgeShareModal> {
  bool _includeId = true;
  String? _sharing;

  @override
  Widget build(BuildContext context) {
    final b = widget.badge;
    if (b == null) return const SizedBox.shrink();
    final cat = kBadgeCategories[b.category]!;
    return Positioned.fill(
      child: Material(
        color: const Color(0xE0000000),
        child: Stack(
          children: [
            const Scanlines(opacity: 0.08),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: const BoxDecoration(
                    color: COL.bg,
                    border: Border(bottom: BorderSide(color: COL.line)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        widget.isLocked ? 'SELO BLOQUEADO' : 'COMPARTILHAR SELO',
                        style: FONT.pixel(size: 10, color: COL.acid, letterSpacing: 1),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: widget.onClose,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(border: Border.all(color: COL.line)),
                          child: Text('× FECHAR',
                              style: FONT.pixel(size: 10, color: COL.inkDim)),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // hero
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: COL.panel,
                            border: Border.all(color: cat.color, width: 2),
                            boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                          ),
                          child: Stack(
                            children: [
                              Halftone(color: cat.color, size: 4, opacity: 0.12),
                              Column(
                                children: [
                                  Text(
                                    widget.isLocked ? '🔒' : b.emoji,
                                    style: const TextStyle(fontSize: 80),
                                  ),
                                  const SizedBox(height: 10),
                                  PixelChip(
                                    '${cat.label} · TIER ${b.tier}',
                                    color: cat.color,
                                    size: 8,
                                  ),
                                  const SizedBox(height: 10),
                                  Stencil(b.title.toUpperCase(),
                                      size: 26, textAlign: TextAlign.center),
                                  const SizedBox(height: 8),
                                  Text(b.desc,
                                      textAlign: TextAlign.center,
                                      style: FONT.body(size: 13, color: COL.inkDim, height: 1.5)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (!widget.isLocked) ...[
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: COL.panel,
                              border: Border.all(color: COL.line),
                            ),
                            child: Text.rich(
                              TextSpan(children: [
                                const TextSpan(text: 'conquistado em '),
                                TextSpan(text: '23 mai 2026', style: const TextStyle(color: COL.acid)),
                              ], style: FONT.mono(size: 11, color: COL.inkDim)),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Container(
                            padding: const EdgeInsets.all(12),
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
                                      Text('Incluir minha identidade?',
                                          style: FONT.body(size: 13, weight: FontWeight.w600)),
                                      const SizedBox(height: 3),
                                      Text(
                                        'avatar + pseudônimo aparecem no selo compartilhado.',
                                        style: FONT.mono(size: 10, color: COL.inkDim),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Toggle(
                                  value: _includeId,
                                  onChanged: () => setState(() => _includeId = !_includeId),
                                  size: ToggleSize.sm,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            '// PRÉVIA DO COMPARTILHAMENTO',
                            style: FONT.pixel(size: 8, color: COL.inkMute, letterSpacing: 1.5),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0A0A0A),
                              border: Border.all(color: cat.color, width: 1.5),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: cat.color,
                                    border: Border.all(color: Colors.black, width: 2),
                                  ),
                                  child: Text(b.emoji, style: const TextStyle(fontSize: 36)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('CONQUISTA · DEDSEC_BR',
                                          style: FONT.pixel(size: 8, color: cat.color, letterSpacing: 1)),
                                      const SizedBox(height: 4),
                                      Text(b.title,
                                          style: FONT.body(size: 14, weight: FontWeight.w700)),
                                      const SizedBox(height: 6),
                                      if (_includeId)
                                        Row(
                                          children: [
                                            Avatar(seed: widget.user.seed, size: 20, border: false),
                                            const SizedBox(width: 6),
                                            Text(widget.user.pseudonym,
                                                style: FONT.mono(size: 10, color: COL.acid)),
                                          ],
                                        )
                                      else
                                        Text('cidadão anônimo · sp',
                                            style: FONT.mono(size: 10, color: COL.inkMute)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text('// COMPARTILHAR EM',
                              style: FONT.pixel(size: 8, color: COL.inkMute, letterSpacing: 1.5)),
                          const SizedBox(height: 8),
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 4,
                            children: [
                              _shareBtn('ig', 'INSTAGRAM', const Color(0xFFE1306C), '📷'),
                              _shareBtn('x', 'X / TWITTER', const Color(0xFF1DA1F2), '🐦'),
                              _shareBtn('wa', 'WHATSAPP', const Color(0xFF25D366), '💬'),
                              _shareBtn('cp', 'COPIAR IMG', COL.acid, '📋'),
                            ],
                          ),
                        ] else
                          Container(
                            margin: const EdgeInsets.only(top: 18),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: COL.panel,
                              border: Border.all(color: COL.line, width: 1.5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('// COMO DESBLOQUEAR',
                                    style: FONT.pixel(size: 9, color: COL.acid)),
                                const SizedBox(height: 8),
                                Text(b.desc,
                                    style: FONT.mono(size: 11, color: COL.inkDim, height: 1.55)),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _shareBtn(String id, String label, Color color, String glyph) {
    final isSharing = _sharing == id;
    return GestureDetector(
      onTap: () {
        setState(() => _sharing = id);
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) setState(() => _sharing = null);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSharing ? color : COL.panel,
          border: Border.all(color: color, width: 1.5),
        ),
        child: Row(
          children: [
            Text(glyph, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                isSharing ? 'ABRINDO...' : label,
                overflow: TextOverflow.ellipsis,
                style: FONT.pixel(
                  size: 9,
                  color: isSharing ? Colors.black : COL.ink,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
