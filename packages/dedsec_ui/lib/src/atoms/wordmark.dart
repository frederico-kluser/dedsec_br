import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';

/// "DEDSEC" pixel text + "_BR" magenta chip.
class Wordmark extends StatelessWidget {
  final double size;
  final Color? color;
  const Wordmark({super.key, this.size = 16, this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text('DEDSEC',
            style: DedsecFonts.pixel(size: size, color: color ?? DedsecColors.ink, letterSpacing: 2)),
        SizedBox(width: size * 0.25),
        Container(
          padding: EdgeInsets.symmetric(horizontal: size * 0.3, vertical: size * 0.12),
          color: DedsecColors.magenta,
          child: Text('_BR',
              style: DedsecFonts.pixel(size: size * 0.6, color: Colors.black, letterSpacing: 2)),
        ),
      ],
    );
  }
}
