import 'package:flutter/material.dart';
import '../tokens/colors.dart';

class StickyFooter extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets padding;
  final MainAxisAlignment mainAxisAlignment;
  const StickyFooter({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: const BoxDecoration(
        color: DedsecColors.bg,
        border: Border(top: BorderSide(color: DedsecColors.line)),
      ),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
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
