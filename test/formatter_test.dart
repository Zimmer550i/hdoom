import 'package:flutter_test/flutter_test.dart';
import 'package:hdoom/utils/formatter.dart';

void main() {
  group('Formatter.compactNumber', () {
    test('removes trailing .0 for exact thousands', () {
      expect(Formatter.compactNumber(1000), '1K');
      expect(Formatter.compactNumber(1500000), '1.5M');
      expect(Formatter.compactNumber(1200), '1.2K');
    });
  });
}
