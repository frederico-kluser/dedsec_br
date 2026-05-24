import 'package:flutter/material.dart';
import '../tokens/colors.dart';

enum ToggleSize { sm, md }

class DedsecToggle extends StatelessWidget {
  final bool value;
  final VoidCallback onChanged;
  final ToggleSize size;
  final Color? onColor;
  final Color? offColor;
  const DedsecToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = ToggleSize.md,
    this.onColor,
    this.offColor,
  });

  @override
  Widget build(BuildContext context) {
    final dims = size == ToggleSize.sm
        ? const _Dim(46, 24, 16)
        : const _Dim(50, 26, 18);
    final on = onColor ?? DedsecColors.acid;
    final off = offColor ?? DedsecColors.panel;

    return GestureDetector(
      onTap: onChanged,
      child: SizedBox(
        width: dims.w,
        height: dims.h,
        child: Container(
          decoration: BoxDecoration(
            color: value ? on : off,
            border: Border.all(color: value ? on : DedsecColors.line, width: 1.5),
          ),
          child: Stack(children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 180),
              left: value ? dims.w - dims.k - 4 : 2,
              top: 2,
              child: Container(width: dims.k, height: dims.k, color: Colors.black),
            ),
          ]),
        ),
      ),
    );
  }
}

class _Dim {
  final double w;
  final double h;
  final double k;
  const _Dim(this.w, this.h, this.k);
}
