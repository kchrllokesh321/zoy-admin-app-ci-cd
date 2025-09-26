import 'package:flutter_test/flutter_test.dart';
import 'package:exchek/core/utils/get_initials.dart';

void main() {
  group('getInitials', () {
    test('returns first letter for single name', () {
      expect(getInitials('Alice'), 'A');
    });

    test('returns initials for two names', () {
      expect(getInitials('Alice Bob'), 'AB');
    });

    test('returns initials for multiple names (first two)', () {
      expect(getInitials('Alice Bob Carol'), 'AB');
    });

    test('returns empty string for empty input', () {
      expect(getInitials(''), '');
    });

    test('trims leading and trailing spaces', () {
      expect(getInitials('  Alice  '), 'A');
      expect(getInitials('  Alice Bob  '), 'AB');
    });

    test('handles lowercase input', () {
      expect(getInitials('alice bob'), 'AB');
    });

    test('handles non-ASCII characters', () {
      expect(getInitials('Élodie Durand'), 'ÉD');
      expect(getInitials('李 小龙'), '李小');
    });
  });
}
