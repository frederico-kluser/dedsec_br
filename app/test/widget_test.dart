import 'package:flutter_test/flutter_test.dart';

import 'package:dedsec_app/main.dart';

void main() {
  testWidgets('Hello Dedsec smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const DedsecApp());

    expect(find.text('Hello, Dedsec'), findsOneWidget);
    expect(find.text('Dedsec'), findsWidgets);
  });
}
