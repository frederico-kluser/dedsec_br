import 'package:flutter/widgets.dart';

import 'app_state.dart';

/// `InheritedNotifier` wrapper so any descendant can read [AppState] via
/// `AppScope.of(context)`.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope.of called outside an AppScope.');
    return scope!.notifier!;
  }

  /// Variant that does not subscribe to rebuilds — use when reading inside
  /// callbacks (e.g. button taps).
  static AppState read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope.read called outside an AppScope.');
    return scope!.notifier!;
  }
}
