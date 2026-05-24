import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';

class CautionTape extends StatefulWidget {
  final String text;
  final Color? color;
  const CautionTape({super.key, this.text = 'DEDSEC_BR / DEDSEC_BR / DEDSEC_BR / ', this.color});

  @override
  State<CautionTape> createState() => _CautionTapeState();
}

class _CautionTapeState extends State<CautionTape> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 20),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? DedsecColors.alert;
    return Transform.rotate(
      angle: -0.025, // -1.5deg
      child: Container(
        decoration: BoxDecoration(
          color: color,
          border: const Border(
            top: BorderSide(color: Colors.black, width: 2),
            bottom: BorderSide(color: Colors.black, width: 2),
          ),
        ),
        height: 28,
        child: ClipRect(
          child: AnimatedBuilder(
            animation: _c,
            builder: (_, __) {
              final tape = widget.text * 12;
              return Transform.translate(
                offset: Offset(-_c.value * 600, 0),
                child: Text(
                  tape,
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                  softWrap: false,
                  style: DedsecFonts.pixel(size: 10, color: Colors.black, letterSpacing: 2),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
