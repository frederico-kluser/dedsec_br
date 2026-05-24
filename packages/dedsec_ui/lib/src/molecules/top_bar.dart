import 'package:flutter/material.dart';
import '../atoms/eye.dart';
import '../atoms/skull.dart';
import '../atoms/wordmark.dart';
import '../state/ranking.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';

class DedsecTopBar extends StatelessWidget {
  final int score;
  final int supporters;
  const DedsecTopBar({super.key, this.score = 12, this.supporters = 4328});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
      decoration: const BoxDecoration(
        color: DedsecColors.bg,
        border: Border(bottom: BorderSide(color: DedsecColors.line)),
      ),
      child: Row(children: [
        const Wordmark(size: 11),
        const Spacer(),
        Row(mainAxisSize: MainAxisSize.min, children: [
          const Eye(size: 11),
          const SizedBox(width: 4),
          Text('$score', style: DedsecFonts.pixel(size: 8, color: DedsecColors.acid)),
        ]),
        const SizedBox(width: 8),
        Row(mainAxisSize: MainAxisSize.min, children: [
          const Skull(size: 11, color: DedsecColors.magenta),
          const SizedBox(width: 4),
          Text(formatNum(supporters),
              style: DedsecFonts.pixel(size: 8, color: DedsecColors.magenta)),
        ]),
      ]),
    );
  }
}
