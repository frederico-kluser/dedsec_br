import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';

class ScopeChip extends StatelessWidget {
  final String label;
  final bool active;
  final Color color;
  final VoidCallback? onPressed;
  const ScopeChip({
    super.key,
    required this.label,
    required this.active,
    required this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: active ? color : Colors.transparent,
            border: Border.all(color: active ? color : DedsecColors.line, width: 1.5),
          ),
          child: Center(
            child: Text(
              label,
              style: DedsecFonts.pixel(
                size: 9,
                color: active ? Colors.black : DedsecColors.inkDim,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
