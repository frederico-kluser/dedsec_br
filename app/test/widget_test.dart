import 'package:dedsec_ui/dedsec_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DedsecApp boots into Splash screen', (tester) async {
    await tester.pumpWidget(const DedsecApp());
    await tester.pump();
    // Splash shows the wordmark glyph with "DEDSEC_BR".
    expect(find.text('DEDSEC_BR'), findsWidgets);
  });
}
