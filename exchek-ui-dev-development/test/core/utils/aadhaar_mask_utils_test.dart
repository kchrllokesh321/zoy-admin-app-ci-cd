import 'package:flutter_test/flutter_test.dart';
import 'package:exchek/core/utils/aadhaar_mask_utils.dart';

void main() {
  group('AadhaarMaskUtils', () {
    group('maskAadhaarNumber', () {
      test('should mask valid 12-digit Aadhaar number correctly', () {
        // Arrange
        const aadhaarNumber = '123456789012';

        // Act
        final result = AadhaarMaskUtils.maskAadhaarNumber(aadhaarNumber);

        // Assert
        expect(result, equals('****-****-9012'));
      });

      test('should mask formatted Aadhaar number correctly', () {
        // Arrange
        const aadhaarNumber = '1234-5678-9012';

        // Act
        final result = AadhaarMaskUtils.maskAadhaarNumber(aadhaarNumber);

        // Assert
        expect(result, equals('****-****-9012'));
      });

      test('should return empty string for empty input', () {
        // Arrange
        const aadhaarNumber = '';

        // Act
        final result = AadhaarMaskUtils.maskAadhaarNumber(aadhaarNumber);

        // Assert
        expect(result, equals(''));
      });

      test('should return original string for invalid length', () {
        // Arrange
        const aadhaarNumber = '1234567890'; // 10 digits

        // Act
        final result = AadhaarMaskUtils.maskAadhaarNumber(aadhaarNumber);

        // Assert
        expect(result, equals(aadhaarNumber));
      });

      test('should return original string for non-numeric input', () {
        // Arrange
        const aadhaarNumber = 'ABCD-EFGH-IJKL';

        // Act
        final result = AadhaarMaskUtils.maskAadhaarNumber(aadhaarNumber);

        // Assert
        expect(result, equals(aadhaarNumber));
      });
    });

    group('maskAadhaarNumberCustom', () {
      test('should mask with default parameters correctly', () {
        // Arrange
        const aadhaarNumber = '123456789012';

        // Act
        final result = AadhaarMaskUtils.maskAadhaarNumberCustom(aadhaarNumber);

        // Assert
        expect(result, equals('****-****-9012'));
      });

      test('should mask with custom visible digits', () {
        // Arrange
        const aadhaarNumber = '123456789012';

        // Act
        final result = AadhaarMaskUtils.maskAadhaarNumberCustom(aadhaarNumber, visibleDigits: 6);

        // Assert
        expect(result, equals('****-**-789012'));
      });

      test('should mask with custom mask character', () {
        // Arrange
        const aadhaarNumber = '123456789012';

        // Act
        final result = AadhaarMaskUtils.maskAadhaarNumberCustom(aadhaarNumber, maskChar: '#');

        // Assert
        expect(result, equals('####-####-9012'));
      });

      test('should handle edge case with 0 visible digits', () {
        // Arrange
        const aadhaarNumber = '123456789012';

        // Act
        final result = AadhaarMaskUtils.maskAadhaarNumberCustom(aadhaarNumber, visibleDigits: 0);

        // Assert
        expect(result, equals('****-****-****'));
      });

      test('should handle edge case with all visible digits', () {
        // Arrange
        const aadhaarNumber = '123456789012';

        // Act
        final result = AadhaarMaskUtils.maskAadhaarNumberCustom(aadhaarNumber, visibleDigits: 12);

        // Assert
        expect(result, equals('123456789012'));
      });

      test('should clamp visible digits to valid range', () {
        // Arrange
        const aadhaarNumber = '123456789012';

        // Act
        final result = AadhaarMaskUtils.maskAadhaarNumberCustom(
          aadhaarNumber,
          visibleDigits: 15, // Invalid value
        );

        // Assert
        expect(result, equals('****-****-9012')); // Should default to 4
      });

      test('should handle negative visible digits', () {
        // Arrange
        const aadhaarNumber = '123456789012';

        // Act
        final result = AadhaarMaskUtils.maskAadhaarNumberCustom(
          aadhaarNumber,
          visibleDigits: -1, // Invalid value
        );

        // Assert
        expect(result, equals('****-****-9012')); // Should default to 4
      });
    });

    group('isValidAadhaarFormat', () {
      test('should return true for valid 12-digit Aadhaar', () {
        // Arrange
        const aadhaarNumber = '123456789012';

        // Act
        final result = AadhaarMaskUtils.isValidAadhaarFormat(aadhaarNumber);

        // Assert
        expect(result, isTrue);
      });

      test('should return true for formatted valid Aadhaar', () {
        // Arrange
        const aadhaarNumber = '1234-5678-9012';

        // Act
        final result = AadhaarMaskUtils.isValidAadhaarFormat(aadhaarNumber);

        // Assert
        expect(result, isTrue);
      });

      test('should return false for empty string', () {
        // Arrange
        const aadhaarNumber = '';

        // Act
        final result = AadhaarMaskUtils.isValidAadhaarFormat(aadhaarNumber);

        // Assert
        expect(result, isFalse);
      });

      test('should return false for invalid length', () {
        // Arrange
        const aadhaarNumber = '1234567890'; // 10 digits

        // Act
        final result = AadhaarMaskUtils.isValidAadhaarFormat(aadhaarNumber);

        // Assert
        expect(result, isFalse);
      });

      test('should return false for non-numeric input', () {
        // Arrange
        const aadhaarNumber = 'ABCD-EFGH-IJKL';

        // Act
        final result = AadhaarMaskUtils.isValidAadhaarFormat(aadhaarNumber);

        // Assert
        expect(result, isFalse);
      });

      test('should return false for mixed alphanumeric', () {
        // Arrange
        const aadhaarNumber = '1234-5678-ABCD';

        // Act
        final result = AadhaarMaskUtils.isValidAadhaarFormat(aadhaarNumber);

        // Assert
        expect(result, isFalse);
      });
    });

    group('extractCleanAadhaar', () {
      test('should extract clean digits from formatted Aadhaar', () {
        // Arrange
        const aadhaarNumber = '1234-5678-9012';

        // Act
        final result = AadhaarMaskUtils.extractCleanAadhaar(aadhaarNumber);

        // Assert
        expect(result, equals('123456789012'));
      });

      test('should return original string if already clean', () {
        // Arrange
        const aadhaarNumber = '123456789012';

        // Act
        final result = AadhaarMaskUtils.extractCleanAadhaar(aadhaarNumber);

        // Assert
        expect(result, equals('123456789012'));
      });

      test('should handle empty string', () {
        // Arrange
        const aadhaarNumber = '';

        // Act
        final result = AadhaarMaskUtils.extractCleanAadhaar(aadhaarNumber);

        // Assert
        expect(result, equals(''));
      });

      test('should remove all non-digit characters', () {
        // Arrange
        const aadhaarNumber = 'A1B2C3D4E5F6G7H8I9J0K1L2';

        // Act
        final result = AadhaarMaskUtils.extractCleanAadhaar(aadhaarNumber);

        // Assert
        expect(result, equals('123456789012'));
      });
    });
  });
}
