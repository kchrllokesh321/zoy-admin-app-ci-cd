import 'package:exchek/widgets/common_widget/aadhar_input_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GroupedInputFormatter Tests', () {
    group('Constructor Tests', () {
      test('creates formatter with required parameters', () {
        final formatter = GroupedInputFormatter(groupSizes: [4, 4, 4]);

        expect(formatter.groupSizes, [4, 4, 4]);
        expect(formatter.separator, ' '); // default value
        expect(formatter.digitsOnly, false); // default value
        expect(formatter.toUpperCase, false); // default value
      });

      test('creates formatter with all custom parameters', () {
        final formatter = GroupedInputFormatter(
          groupSizes: [3, 3, 3, 3],
          separator: '-',
          digitsOnly: true,
          toUpperCase: true,
        );

        expect(formatter.groupSizes, [3, 3, 3, 3]);
        expect(formatter.separator, '-');
        expect(formatter.digitsOnly, true);
        expect(formatter.toUpperCase, true);
      });
    });

    group('Basic Formatting Tests', () {
      test('formats text with default separator (space)', () {
        final formatter = GroupedInputFormatter(groupSizes: [4, 4, 4]);

        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '123456789012'),
        );

        expect(result.text, '1234 5678 9012');
        expect(result.selection.baseOffset, 14);
      });

      test('formats text with custom separator', () {
        final formatter = GroupedInputFormatter(groupSizes: [4, 4, 4], separator: '-');

        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '123456789012'),
        );

        expect(result.text, '1234-5678-9012');
        expect(result.selection.baseOffset, 14);
      });

      test('formats text with different group sizes', () {
        final formatter = GroupedInputFormatter(groupSizes: [2, 3, 4, 3]);

        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '123456789012'),
        );

        expect(result.text, '12 345 6789 012');
        expect(result.selection.baseOffset, 15);
      });
    });

    group('Digits Only Tests', () {
      test('filters non-digits when digitsOnly is true', () {
        final formatter = GroupedInputFormatter(groupSizes: [4, 4, 4], digitsOnly: true);

        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '12a3b4c5d6e7f8g9h0i1j2'),
        );

        expect(result.text, '1234 5678 9012');
        expect(result.selection.baseOffset, 14);
      });

      test('preserves non-digits when digitsOnly is false', () {
        final formatter = GroupedInputFormatter(groupSizes: [4, 4, 4], digitsOnly: false);

        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '12a3b4c5d6e7'),
        );

        expect(result.text, '12a3 b4c5 d6e7');
        expect(result.selection.baseOffset, 14);
      });

      test('removes spaces when digitsOnly is false', () {
        final formatter = GroupedInputFormatter(groupSizes: [3, 3, 3], digitsOnly: false);

        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: 'ab c  de   f gh i'),
        );

        expect(result.text, 'abc def ghi');
        expect(result.selection.baseOffset, 11);
      });
    });

    group('Upper Case Tests', () {
      test('converts to uppercase when toUpperCase is true', () {
        final formatter = GroupedInputFormatter(groupSizes: [3, 3, 3], toUpperCase: true);

        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: 'abcdefghi'),
        );

        expect(result.text, 'ABC DEF GHI');
        expect(result.selection.baseOffset, 11);
      });

      test('preserves case when toUpperCase is false', () {
        final formatter = GroupedInputFormatter(groupSizes: [3, 3, 3], toUpperCase: false);

        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: 'abcDefGhi'),
        );

        expect(result.text, 'abc Def Ghi');
        expect(result.selection.baseOffset, 11);
      });
    });

    group('Combined Options Tests', () {
      test('applies both digitsOnly and toUpperCase', () {
        final formatter = GroupedInputFormatter(groupSizes: [4, 4, 4], digitsOnly: true, toUpperCase: true);

        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '12a3b4c5d6e7f8g9h0i1j2'),
        );

        expect(result.text, '1234 5678 9012');
        expect(result.selection.baseOffset, 14);
      });

      test('applies toUpperCase with custom separator', () {
        final formatter = GroupedInputFormatter(groupSizes: [2, 2, 2], separator: '-', toUpperCase: true);

        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: 'abcdef'),
        );

        expect(result.text, 'AB-CD-EF');
        expect(result.selection.baseOffset, 8);
      });
    });

    group('Edge Cases Tests', () {
      test('handles empty input', () {
        final formatter = GroupedInputFormatter(groupSizes: [4, 4, 4]);

        final result = formatter.formatEditUpdate(const TextEditingValue(text: ''), const TextEditingValue(text: ''));

        expect(result.text, '');
        expect(result.selection.baseOffset, 0);
      });

      test('handles input shorter than first group', () {
        final formatter = GroupedInputFormatter(groupSizes: [4, 4, 4]);

        final result = formatter.formatEditUpdate(const TextEditingValue(text: ''), const TextEditingValue(text: '12'));

        expect(result.text, '12');
        expect(result.selection.baseOffset, 2);
      });

      test('handles input exactly matching first group', () {
        final formatter = GroupedInputFormatter(groupSizes: [4, 4, 4]);

        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '1234'),
        );

        expect(result.text, '1234');
        expect(result.selection.baseOffset, 4);
      });

      test('handles input longer than all groups combined', () {
        final formatter = GroupedInputFormatter(groupSizes: [2, 2, 2]);

        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '1234567890'),
        );

        // The formatter processes only the groups defined, ignoring extra characters
        expect(result.text, '12 34 56 ');
        expect(result.selection.baseOffset, 9);
      });

      test('handles single character group sizes', () {
        final formatter = GroupedInputFormatter(groupSizes: [1, 1, 1, 1]);

        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '1234'),
        );

        expect(result.text, '1 2 3 4');
        expect(result.selection.baseOffset, 7);
      });

      test('handles large group sizes', () {
        final formatter = GroupedInputFormatter(groupSizes: [10]);

        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '12345'),
        );

        expect(result.text, '12345');
        expect(result.selection.baseOffset, 5);
      });

      test('handles mixed content with all options', () {
        final formatter = GroupedInputFormatter(
          groupSizes: [3, 3, 3],
          separator: '|',
          digitsOnly: false,
          toUpperCase: true,
        );

        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: 'a1 b2 c3 d4 e5'),
        );

        // After removing spaces: 'a1b2c3d4e5' -> uppercase: 'A1B2C3D4E5'
        // Groups: [3,3,3] -> 'A1B|2C3|D4E|' (with trailing separator)
        expect(result.text, 'A1B|2C3|D4E|');
        expect(result.selection.baseOffset, 12);
      });
    });

    group('Real-world Use Cases', () {
      test('formats Aadhaar number (12 digits in 4-4-4 pattern)', () {
        final formatter = GroupedInputFormatter(groupSizes: [4, 4, 4], separator: ' ', digitsOnly: true);

        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '123456789012'),
        );

        expect(result.text, '1234 5678 9012');
        expect(result.selection.baseOffset, 14);
      });

      test('formats PAN number (5-4-1 pattern with uppercase)', () {
        final formatter = GroupedInputFormatter(groupSizes: [5, 4, 1], separator: '', toUpperCase: true);

        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: 'abcde1234f'),
        );

        expect(result.text, 'ABCDE1234F');
        expect(result.selection.baseOffset, 10);
      });

      test('formats credit card number (4-4-4-4 pattern)', () {
        final formatter = GroupedInputFormatter(groupSizes: [4, 4, 4, 4], separator: '-', digitsOnly: true);

        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '1234567890123456'),
        );

        expect(result.text, '1234-5678-9012-3456');
        expect(result.selection.baseOffset, 19);
      });

      test('formats phone number (3-3-4 pattern)', () {
        final formatter = GroupedInputFormatter(groupSizes: [3, 3, 4], separator: '-', digitsOnly: true);

        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '1234567890'),
        );

        expect(result.text, '123-456-7890');
        expect(result.selection.baseOffset, 12);
      });
    });

    group('TextSelection Tests', () {
      test('sets cursor at end of formatted text', () {
        final formatter = GroupedInputFormatter(groupSizes: [2, 2, 2]);

        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '123456'),
        );

        expect(result.selection.baseOffset, result.text.length);
        expect(result.selection.extentOffset, result.text.length);
        expect(result.selection.isCollapsed, true);
      });
    });
  });
}
