import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';

class PixelChip extends StatelessWidget {
  final String text;
  final Color? color;
  final Color bg;
  final double size;
  const PixelChip(
    this.text, {
    super.key,
    this.color,
    this.bg = Colors.black,
    this.size = 9,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? DedsecColors.acid;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(color: bg, border: Border.all(color: c)),
      child: Text(text, style: DedsecFonts.pixel(size: size, color: c, letterSpacing: 1)),
    );
  }
}
