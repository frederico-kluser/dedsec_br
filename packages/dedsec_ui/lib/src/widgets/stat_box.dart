import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';

class StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final double size;
  const StatBox({super.key, required this.label, required this.value, this.color, this.size = 22});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: DedsecFonts.pixel(size: 8, color: DedsecColors.inkMute, letterSpacing: 1.2),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: DedsecFonts.pixel(size: size, color: color ?? DedsecColors.ink),
          ),
        ],
      ),
    );
  }
}
