import 'package:flutter/material.dart';
import '../tokens/colors.dart';

/// Wraps a page in a black background with safe-area handling. Replaces the
/// React `ScreenRoot` / `AndroidDevice` chrome (we drop the desktop bezel).
class ScreenRoot extends StatelessWidget {
  final Widget child;
  final bool useSafeArea;
  const ScreenRoot({super.key, required this.child, this.useSafeArea = true});

  @override
  Widget build(BuildContext context) {
    final body = Container(
      color: DedsecColors.bg,
      child: child,
    );
    return Scaffold(
      backgroundColor: DedsecColors.bg,
      body: useSafeArea ? SafeArea(child: body) : body,
    );
  }
}
