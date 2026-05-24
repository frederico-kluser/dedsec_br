import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/fonts.dart';

/// `molecules/LoaderShowcase` — header + container wrapper for a loader.
class LoaderShowcase extends StatelessWidget {
  final String id;
  final String title;
  final String subtitle;
  final Widget child;
  const LoaderShowcase({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: COL.line)),
            ),
            child: Row(
              children: [
                Text(id, style: FONT.pixel(size: 9, color: COL.acid, letterSpacing: 1.5)),
                const SizedBox(width: 10),
                Text(title,
                    style: FONT.body(size: 13, color: COL.ink, weight: FontWeight.w600)),
                const Spacer(),
                Text(subtitle, style: FONT.mono(size: 10, color: COL.inkMute)),
              ],
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
