import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/fonts.dart';

/// `utils/ScreenRoot` — full-height column container with bg + ink defaults.
class ScreenRoot extends StatelessWidget {
  final Widget child;
  final Color background;
  final bool relative;
  const ScreenRoot({
    super.key,
    required this.child,
    this.background = COL.bg,
    this.relative = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: SafeArea(
        bottom: false,
        child: DefaultTextStyle(
          style: FONT.body(color: COL.ink),
          child: child,
        ),
      ),
    );
  }
}

/// `utils/ScrollArea` — flex-grow scrollable region.
class ScrollArea extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final ScrollController? controller;

  const ScrollArea({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        controller: controller,
        padding: padding,
        child: child,
      ),
    );
  }
}

/// `utils/BackHeader` — top row with "← VOLTAR" + right-side slot.
class BackHeader extends StatelessWidget {
  final String label;
  final VoidCallback? onBack;
  final Widget? trailing;

  const BackHeader({
    super.key,
    this.label = 'VOLTAR',
    this.onBack,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: const BoxDecoration(
        color: COL.bg,
        border: Border(bottom: BorderSide(color: COL.line)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            behavior: HitTestBehavior.opaque,
            child: Text('← $label',
                style: FONT.pixel(size: 11, color: COL.ink, letterSpacing: 1)),
          ),
          const Spacer(),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// `utils/StickyFooter` — bottom action area pinned above the system nav.
class StickyFooter extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  const StickyFooter({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: const BoxDecoration(
        color: COL.bg,
        border: Border(top: BorderSide(color: COL.line)),
      ),
      child: Row(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(width: 10),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// `utils/Toggle` — on/off switch.
class Toggle extends StatelessWidget {
  final bool value;
  final VoidCallback onChanged;
  final ToggleSize size;
  final Color onColor;
  final Color offColor;

  const Toggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = ToggleSize.md,
    this.onColor = COL.acid,
    this.offColor = COL.panel,
  });

  @override
  Widget build(BuildContext context) {
    final w = size == ToggleSize.sm ? 46.0 : 50.0;
    final h = size == ToggleSize.sm ? 24.0 : 26.0;
    final k = size == ToggleSize.sm ? 16.0 : 18.0;
    return GestureDetector(
      onTap: onChanged,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: value ? onColor : offColor,
          border: Border.all(color: value ? onColor : COL.line, width: 1.5),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 180),
              top: 0,
              left: value ? w - k - 4 : 2,
              child: Container(width: k, height: k - 2, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

enum ToggleSize { sm, md }

/// `utils/StatBox` — pixel label + big number.
class StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final double size;
  const StatBox({
    super.key,
    required this.label,
    required this.value,
    this.color = COL.ink,
    this.size = 22,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: FONT.pixel(size: 8, color: COL.inkMute, letterSpacing: 1.2)),
          const SizedBox(height: 4),
          Text(value, style: FONT.pixel(size: size, color: color)),
        ],
      ),
    );
  }
}
