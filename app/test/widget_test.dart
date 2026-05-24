import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dedsec_app/main.dart';

void main() {
  testWidgets('App boots into splash without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const DedsecApp());
    // First frame includes the wordmark.
    expect(find.text('DEDSEC_BR'), findsOneWidget);
    expect(find.text('PULAR →'), findsOneWidget);
    // Cancel the splash percentage timer so the test exits cleanly.
    await tester.pump(const Duration(milliseconds: 200));
  });
}
