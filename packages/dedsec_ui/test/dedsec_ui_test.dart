import 'package:dedsec_ui/dedsec_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formatRank renders pt-BR thousands separator', () {
    expect(formatRank(1234), '#1.234');
  });
}
