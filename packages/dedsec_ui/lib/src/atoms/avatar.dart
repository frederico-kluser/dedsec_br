import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../tokens/colors.dart';

const dicebearPalette = 'ff1466,b7ff2a,ffd60a,7fc8ff,1a1a1a';

class Avatar extends StatelessWidget {
  final String seed;
  final String style;
  final double size;
  final bool border;
  final Color? bg;
  const Avatar({
    super.key,
    required this.seed,
    this.style = 'identicon',
    this.size = 32,
    this.border = true,
    this.bg,
  });

  @override
  Widget build(BuildContext context) {
    final url = 'https://api.dicebear.com/9.x/$style/svg'
        '?seed=${Uri.encodeComponent(seed)}'
        '&backgroundColor=$dicebearPalette';

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg ?? const Color(0xFF1C1C1C),
        border: border ? Border.all(color: Colors.black, width: 2) : null,
        boxShadow: border
            ? const [BoxShadow(color: DedsecColors.line, offset: Offset(2, 2))]
            : null,
      ),
      child: ClipRect(
        child: SvgPicture.network(
          url,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholderBuilder: (_) => Container(color: const Color(0xFF1C1C1C)),
        ),
      ),
    );
  }
}
