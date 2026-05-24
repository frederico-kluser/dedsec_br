import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';

class DedsecTab {
  final String id;
  final String label;
  final String glyph;
  const DedsecTab(this.id, this.label, this.glyph);
}

const dedsecTabs = <DedsecTab>[
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
        border: Border(top: BorderSide(color: DedsecColors.line, width: 2)),
      ),
      child: Row(children: [
        for (final t in dedsecTabs)
          Expanded(
            child: GestureDetector(
              onTap: () => onTab?.call(t.id),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                color: active == t.id ? DedsecColors.magenta : Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(t.glyph,
                        style: TextStyle(
                          fontSize: 16,
                          color: active == t.id ? Colors.black : DedsecColors.inkDim,
                        )),
                    const SizedBox(height: 3),
                    Text(t.label,
                        style: DedsecFonts.pixel(
                          size: 7,
                          color: active == t.id ? Colors.black : DedsecColors.inkDim,
                          letterSpacing: 1,
                        )),
                  ],
                ),
              ),
            ),
          ),
      ]),
    );
  }
}
