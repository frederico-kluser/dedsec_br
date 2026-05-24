import 'package:flutter/material.dart';
import '../atoms/dashed_box.dart';
import '../state/achievements.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';

class DedsecBadgeCarousel extends StatelessWidget {
  final Set<String> owned;
  final Set<String> unopened;
  final ValueChanged<DedsecBadge> onPick;
  const DedsecBadgeCarousel({
    super.key,
    required this.owned,
    required this.unopened,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    final ownedDedsecBadges = badges.where((b) => owned.contains(b.id)).toList();
    if (ownedDedsecBadges.isEmpty) {
      return DashedBox(
        color: DedsecColors.line,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Text(
            '// nenhum selo ainda. processe sua primeira pauta.',
            textAlign: TextAlign.center,
            style: DedsecFonts.mono(size: 11, color: DedsecColors.inkMute),
          ),
        ),
      );
    }
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        itemCount: ownedDedsecBadges.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final b = ownedDedsecBadges[i];
          final isNew = unopened.contains(b.id);
          final cat = badgeCategories[b.category]!;
          return GestureDetector(
            onTap: () => onPick(b),
            child: SizedBox(
              width: 88,
              child: Stack(clipBehavior: Clip.none, children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(6, 12, 6, 10),
                  decoration: BoxDecoration(
                    color: DedsecColors.panel,
                    border: Border.all(color: cat.color, width: 2),
                    boxShadow: isNew
                        ? [BoxShadow(color: cat.color.withOpacity(0.5), blurRadius: 14)]
                        : const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                  ),
                  child: Column(children: [
                    Text(b.emoji, style: const TextStyle(fontSize: 32, height: 1)),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 18,
                      child: Center(
                        child: Text(
                          b.title.toUpperCase(),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: DedsecFonts.pixel(size: 7, color: DedsecColors.ink, letterSpacing: 0.5),
                        ),
                      ),
                    ),
                  ]),
                ),
                if (isNew)
                  Positioned(
                    top: -6,
                    right: -6,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: DedsecColors.magenta,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Center(
                        child: Text('!', style: DedsecFonts.pixel(size: 7, color: Colors.white)),
                      ),
                    ),
                  ),
              ]),
            ),
          );
        },
      ),
    );
  }
}
