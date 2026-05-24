import 'package:dedsec_app/main.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Dedsec app boots to splash', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844); // iPhone 14 ratio
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const DedsecApp());
    await tester.pump();

    // Splash shows the wordmark via Glitch widget.
    expect(find.text('DEDSEC_BR'), findsOneWidget);
  });
}
