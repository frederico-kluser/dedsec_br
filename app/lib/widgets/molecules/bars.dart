import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/fonts.dart';
import '../../utils/format.dart';
import '../atoms/icons.dart';
import '../atoms/text_atoms.dart';

/// `molecules/TopBar` — phone-internal status header.
class TopBar extends StatelessWidget {
  final int score;
  final int supporters;
  const TopBar({super.key, this.score = 12, this.supporters = 4328});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
      decoration: const BoxDecoration(
        color: COL.bg,
        border: Border(bottom: BorderSide(color: COL.line)),
      ),
      child: Row(
        children: [
          const Wordmark(size: 11),
          const Spacer(),
          const Eye(size: 11, color: COL.acid),
          const SizedBox(width: 4),
          Text('$score', style: FONT.pixel(size: 8, color: COL.acid)),
          const SizedBox(width: 8),
          const Skull(size: 11, color: COL.magenta),
          const SizedBox(width: 4),
          Text(formatNum(supporters), style: FONT.pixel(size: 8, color: COL.magenta)),
        ],
      ),
    );
  }
}

/// `molecules/TabBar` — bottom navigation row.
class DedsecTab {
  final String id;
  final String label;
  final String glyph;
  const DedsecTab(this.id, this.label, this.glyph);
}

const kTabs = <DedsecTab>[
  DedsecTab('home', 'PAUTAS', '▣'),
  DedsecTab('help', 'AJUDAR', '✦'),
  DedsecTab('forum', 'FÓRUM', '◉'),
  DedsecTab('settings', 'CONFIG', '⚙'),
];

class DedsecTabBar extends StatelessWidget {
  final String? active;
  final ValueChanged<String>? onTab;
  const DedsecTabBar({super.key, this.active, this.onTab});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: COL.line, width: 2)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            for (final t in kTabs)
              Expanded(
                child: GestureDetector(
                  onTap: () => onTab?.call(t.id),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    color: active == t.id ? COL.magenta : Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        Text(t.glyph,
                            style: TextStyle(
                              fontSize: 16,
                              color: active == t.id ? Colors.black : COL.inkDim,
                            )),
                        const SizedBox(height: 3),
                        Text(t.label,
                            style: FONT.pixel(
                              size: 7,
                              color: active == t.id ? Colors.black : COL.inkDim,
                              letterSpacing: 1,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// `molecules/ScopeChip` — toggle chip for mun/est/fed.
class ScopeChip extends StatelessWidget {
  final String text;
  final bool active;
  final Color color;
  final VoidCallback? onTap;
  const ScopeChip(
    this.text, {
    super.key,
    this.active = false,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: active ? color : Colors.transparent,
            border: Border.all(color: active ? color : COL.line, width: 1.5),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: FONT.pixel(
              size: 9,
              color: active ? Colors.black : COL.inkDim,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
