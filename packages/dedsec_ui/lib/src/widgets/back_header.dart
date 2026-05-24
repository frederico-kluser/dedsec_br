import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';

class BackHeader extends StatelessWidget {
  final String label;
  final VoidCallback? onBack;
  final Widget? trailing;
  const BackHeader({super.key, this.label = 'VOLTAR', this.onBack, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: const BoxDecoration(
        color: DedsecColors.bg,
        border: Border(bottom: BorderSide(color: DedsecColors.line)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Text(
              '← ${label.toUpperCase()}',
              style: DedsecFonts.pixel(size: 11, color: DedsecColors.ink, letterSpacing: 1),
            ),
          ),
          const Spacer(),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
