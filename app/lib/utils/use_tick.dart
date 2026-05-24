import 'dart:async';

import 'package:flutter/widgets.dart';

/// Mounts an integer tick that increments every [interval] and rebuilds the
/// children on each step. Equivalent to the JS `useTick(ms)` hook.
class TickBuilder extends StatefulWidget {
  final Duration interval;
  final Widget Function(BuildContext context, int t) builder;

  const TickBuilder({
    super.key,
    this.interval = const Duration(milliseconds: 80),
    required this.builder,
  });

  @override
  State<TickBuilder> createState() => _TickBuilderState();
}

class _TickBuilderState extends State<TickBuilder> {
  int _t = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.interval, (_) {
      if (mounted) setState(() => _t++);
    });
  }

  @override
  void didUpdateWidget(covariant TickBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.interval != oldWidget.interval) {
      _timer?.cancel();
      _timer = Timer.periodic(widget.interval, (_) {
        if (mounted) setState(() => _t++);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _t);
}
