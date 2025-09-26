import 'package:flutter_test/flutter_test.dart';
import 'package:exchek/models/personal_user_models/aadhar_otp_model.dart';

void main() {
  group('AadharOTPSendModel', () {
    // =============================================================================
    // CONSTRUCTOR TESTS
    // =============================================================================

    group('Constructor', () {
      test('should create instance with all required fields', () {
        // Act
        final model = AadharOTPSendModel(
          code: 200,
          timestamp: 1640995200,
          transactionId: 'txn_123456789',
          subCode: 'SUB001',
          message: 'OTP sent successfully',
        );

        // Assert
        expect(model.code, equals(200));
        expect(model.timestamp, equals(1640995200));
        expect(model.transactionId, equals('txn_123456789'));
        expect(model.subCode, equals('SUB001'));
        expect(model.message, equals('OTP sent successfully'));
      });

      test('should create instance with different status codes', () {
        // Act
        final successModel = AadharOTPSendModel(
          code: 200,
          timestamp: 1640995200,
          transactionId: 'txn_success',
          subCode: 'SUCCESS',
          message: 'OTP sent successfully',
        );

        final errorModel = AadharOTPSendModel(
          code: 400,
          timestamp: 1640995300,
          transactionId: 'txn_error',
          subCode: 'ERROR',
          message: 'Invalid Aadhaar number',
        );

        // Assert
        expect(successModel.code, equals(200));
        expect(successModel.message, equals('OTP sent successfully'));
        expect(errorModel.code, equals(400));
        expect(errorModel.message, equals('Invalid Aadhaar number'));
      });

      test('should create instance with edge case values', () {
        // Act
        final model = AadharOTPSendModel(code: 0, timestamp: 0, transactionId: '', subCode: '', message: '');

        // Assert
        expect(model.code, equals(0));
        expect(model.timestamp, equals(0));
        expect(model.transactionId, equals(''));
        expect(model.subCode, equals(''));
        expect(model.message, equals(''));
      });
    });

    // =============================================================================
    // FROM JSON TESTS
    // =============================================================================

    group('fromJson', () {
      test('should create instance from complete JSON', () {
        // Arrange
        final json = {
          'code': 200,
          'timestamp': 1640995200,
          'transaction_id': 'txn_123456789',
          'sub_code': 'SUB001',
          'message': 'OTP sent successfully',
        };

        // Act
        final model = AadharOTPSendModel.fromJson(json);

        // Assert
        expect(model.code, equals(200));
        expect(model.timestamp, equals(1640995200));
        expect(model.transactionId, equals('txn_123456789'));
        expect(model.subCode, equals('SUB001'));
        expect(model.message, equals('OTP sent successfully'));
      });

      test('should create instance from JSON with proper data types', () {
        // Arrange
        final json = {
          'code': 200, // Correct int type
          'timestamp': 1640995200, // Correct int type
          'transaction_id': 'txn_123456789',
          'sub_code': 'SUB001',
          'message': 'OTP sent successfully',
        };

        // Act
        final model = AadharOTPSendModel.fromJson(json);

        // Assert
        expect(model.code, equals(200));
        expect(model.timestamp, equals(1640995200));
        expect(model.transactionId, equals('txn_123456789'));
        expect(model.subCode, equals('SUB001'));
        expect(model.message, equals('OTP sent successfully'));
      });

      test('should create instance from JSON with default values', () {
        // Arrange
        final json = {'code': 0, 'timestamp': 0, 'transaction_id': '', 'sub_code': '', 'message': ''};

        // Act
        final model = AadharOTPSendModel.fromJson(json);

        // Assert
        expect(model.code, equals(0));
        expect(model.timestamp, equals(0));
        expect(model.transactionId, equals(''));
        expect(model.subCode, equals(''));
        expect(model.message, equals(''));
      });

      test('should create instance from JSON with error response', () {
        // Arrange
        final json = {
          'code': 400,
          'timestamp': 1640995300,
          'transaction_id': 'error_txn',
          'sub_code': 'INVALID_REQUEST',
          'message': 'Invalid Aadhaar number format',
        };

        // Act
        final model = AadharOTPSendModel.fromJson(json);

        // Assert
        expect(model.code, equals(400));
        expect(model.timestamp, equals(1640995300));
        expect(model.transactionId, equals('error_txn'));
        expect(model.subCode, equals('INVALID_REQUEST'));
        expect(model.message, equals('Invalid Aadhaar number format'));
      });

      test('should handle error response JSON', () {
        // Arrange
        final json = {
          'code': 400,
          'timestamp': 1640995300,
          'transaction_id': 'txn_error_123',
          'sub_code': 'INVALID_AADHAR',
          'message': 'The provided Aadhaar number is invalid',
        };

        // Act
        final model = AadharOTPSendModel.fromJson(json);

        // Assert
        expect(model.code, equals(400));
        expect(model.timestamp, equals(1640995300));
        expect(model.transactionId, equals('txn_error_123'));
        expect(model.subCode, equals('INVALID_AADHAR'));
        expect(model.message, equals('The provided Aadhaar number is invalid'));
      });

      test('should handle large timestamp values', () {
        // Arrange
        final json = {
          'code': 200,
          'timestamp': 9999999999, // Large timestamp
          'transaction_id': 'txn_large_timestamp',
          'sub_code': 'SUCCESS',
          'message': 'OTP sent with large timestamp',
        };

        // Act
        final model = AadharOTPSendModel.fromJson(json);

        // Assert
        expect(model.code, equals(200));
        expect(model.timestamp, equals(9999999999));
        expect(model.transactionId, equals('txn_large_timestamp'));
        expect(model.subCode, equals('SUCCESS'));
        expect(model.message, equals('OTP sent with large timestamp'));
      });
    });

    // =============================================================================
    // TO JSON TESTS
    // =============================================================================

    group('toJson', () {
      test('should convert complete model to JSON', () {
        // Arrange
        final model = AadharOTPSendModel(
          code: 200,
          timestamp: 1640995200,
          transactionId: 'txn_123456789',
          subCode: 'SUB001',
          message: 'OTP sent successfully',
        );

        // Act
        final json = model.toJson();

        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['code'], equals(200));
        expect(json['timestamp'], equals(1640995200));
        expect(json['transaction_id'], equals('txn_123456789'));
        expect(json['sub_code'], equals('SUB001'));
        expect(json['message'], equals('OTP sent successfully'));
        expect(json.length, equals(5));
      });

      test('should convert model with error values to JSON', () {
        // Arrange
        final model = AadharOTPSendModel(
          code: 400,
          timestamp: 1640995300,
          transactionId: 'txn_error_123',
          subCode: 'INVALID_AADHAR',
          message: 'The provided Aadhaar number is invalid',
        );

        // Act
        final json = model.toJson();

        // Assert
        expect(json['code'], equals(400));
        expect(json['timestamp'], equals(1640995300));
        expect(json['transaction_id'], equals('txn_error_123'));
        expect(json['sub_code'], equals('INVALID_AADHAR'));
        expect(json['message'], equals('The provided Aadhaar number is invalid'));
      });

      test('should convert model with edge case values to JSON', () {
        // Arrange
        final model = AadharOTPSendModel(code: 0, timestamp: 0, transactionId: '', subCode: '', message: '');

        // Act
        final json = model.toJson();

        // Assert
        expect(json['code'], equals(0));
        expect(json['timestamp'], equals(0));
        expect(json['transaction_id'], equals(''));
        expect(json['sub_code'], equals(''));
        expect(json['message'], equals(''));
      });

      test('should maintain correct JSON structure', () {
        // Arrange
        final model = AadharOTPSendModel(
          code: 200,
          timestamp: 1640995200,
          transactionId: 'txn_123456789',
          subCode: 'SUB001',
          message: 'OTP sent successfully',
        );

        // Act
        final json = model.toJson();

        // Assert
        expect(json.keys, containsAll(['code', 'timestamp', 'transaction_id', 'sub_code', 'message']));
        expect(json.keys.length, equals(5));
      });
    });

    // =============================================================================
    // SERIALIZATION ROUND-TRIP TESTS
    // =============================================================================

    group('Serialization Round-trip', () {
      test('should maintain data integrity through JSON round-trip', () {
        // Arrange
        final originalModel = AadharOTPSendModel(
          code: 200,
          timestamp: 1640995200,
          transactionId: 'txn_123456789',
          subCode: 'SUB001',
          message: 'OTP sent successfully',
        );

        // Act
        final json = originalModel.toJson();
        final deserializedModel = AadharOTPSendModel.fromJson(json);

        // Assert
        expect(deserializedModel.code, equals(originalModel.code));
        expect(deserializedModel.timestamp, equals(originalModel.timestamp));
        expect(deserializedModel.transactionId, equals(originalModel.transactionId));
        expect(deserializedModel.subCode, equals(originalModel.subCode));
        expect(deserializedModel.message, equals(originalModel.message));
      });

      test('should maintain data integrity through multiple round-trips', () {
        // Arrange
        final originalModel = AadharOTPSendModel(
          code: 400,
          timestamp: 1640995300,
          transactionId: 'txn_error_123',
          subCode: 'INVALID_AADHAR',
          message: 'The provided Aadhaar number is invalid',
        );

        // Act - First round-trip
        final json1 = originalModel.toJson();
        final model1 = AadharOTPSendModel.fromJson(json1);

        // Second round-trip
        final json2 = model1.toJson();
        final model2 = AadharOTPSendModel.fromJson(json2);

        // Third round-trip
        final json3 = model2.toJson();
        final finalModel = AadharOTPSendModel.fromJson(json3);

        // Assert
        expect(finalModel.code, equals(originalModel.code));
        expect(finalModel.timestamp, equals(originalModel.timestamp));
        expect(finalModel.transactionId, equals(originalModel.transactionId));
        expect(finalModel.subCode, equals(originalModel.subCode));
        expect(finalModel.message, equals(originalModel.message));
      });

      test('should handle edge case values in round-trip', () {
        // Arrange
        final originalModel = AadharOTPSendModel(code: 0, timestamp: 0, transactionId: '', subCode: '', message: '');

        // Act
        final json = originalModel.toJson();
        final deserializedModel = AadharOTPSendModel.fromJson(json);

        // Assert
        expect(deserializedModel.code, equals(originalModel.code));
        expect(deserializedModel.timestamp, equals(originalModel.timestamp));
        expect(deserializedModel.transactionId, equals(originalModel.transactionId));
        expect(deserializedModel.subCode, equals(originalModel.subCode));
        expect(deserializedModel.message, equals(originalModel.message));
      });
    });

    // =============================================================================
    // EDGE CASES AND ERROR HANDLING TESTS
    // =============================================================================

    group('Edge Cases', () {
      test('should handle special characters in string fields', () {
        // Arrange
        const specialChars = 'Special chars: !@#\$%^&*()_+-=[]{}|;:,.<>?/~`"\'\\';
        final model = AadharOTPSendModel(
          code: 200,
          timestamp: 1640995200,
          transactionId: specialChars,
          subCode: specialChars,
          message: specialChars,
        );

        // Act
        final json = model.toJson();
        final deserializedModel = AadharOTPSendModel.fromJson(json);

        // Assert
        expect(deserializedModel.transactionId, equals(specialChars));
        expect(deserializedModel.subCode, equals(specialChars));
        expect(deserializedModel.message, equals(specialChars));
      });

      test('should handle unicode characters in string fields', () {
        // Arrange
        const unicodeText = 'Unicode: 你好 🌟 ñáéíóú àèìòù äëïöü';
        final model = AadharOTPSendModel(
          code: 200,
          timestamp: 1640995200,
          transactionId: unicodeText,
          subCode: unicodeText,
          message: unicodeText,
        );

        // Act
        final json = model.toJson();
        final deserializedModel = AadharOTPSendModel.fromJson(json);

        // Assert
        expect(deserializedModel.transactionId, equals(unicodeText));
        expect(deserializedModel.subCode, equals(unicodeText));
        expect(deserializedModel.message, equals(unicodeText));
      });

      test('should handle very long string values', () {
        // Arrange
        final longString = 'A' * 1000; // 1000 character string
        final model = AadharOTPSendModel(
          code: 200,
          timestamp: 1640995200,
          transactionId: longString,
          subCode: longString,
          message: longString,
        );

        // Act
        final json = model.toJson();
        final deserializedModel = AadharOTPSendModel.fromJson(json);

        // Assert
        expect(deserializedModel.transactionId, equals(longString));
        expect(deserializedModel.subCode, equals(longString));
        expect(deserializedModel.message, equals(longString));
        expect(deserializedModel.transactionId?.length, equals(1000));
      });

      test('should handle negative values for numeric fields', () {
        // Arrange
        final model = AadharOTPSendModel(
          code: -1,
          timestamp: -1640995200,
          transactionId: 'txn_negative',
          subCode: 'NEG',
          message: 'Negative values test',
        );

        // Act
        final json = model.toJson();
        final deserializedModel = AadharOTPSendModel.fromJson(json);

        // Assert
        expect(deserializedModel.code, equals(-1));
        expect(deserializedModel.timestamp, equals(-1640995200));
        expect(deserializedModel.transactionId, equals('txn_negative'));
        expect(deserializedModel.subCode, equals('NEG'));
        expect(deserializedModel.message, equals('Negative values test'));
      });

      test('should handle maximum integer values', () {
        // Arrange
        const maxInt = 9223372036854775807; // Max int64 value
        final model = AadharOTPSendModel(
          code: maxInt,
          timestamp: maxInt,
          transactionId: 'txn_max_int',
          subCode: 'MAX',
          message: 'Maximum integer test',
        );

        // Act
        final json = model.toJson();
        final deserializedModel = AadharOTPSendModel.fromJson(json);

        // Assert
        expect(deserializedModel.code, equals(maxInt));
        expect(deserializedModel.timestamp, equals(maxInt));
        expect(deserializedModel.transactionId, equals('txn_max_int'));
        expect(deserializedModel.subCode, equals('MAX'));
        expect(deserializedModel.message, equals('Maximum integer test'));
      });
    });

    // =============================================================================
    // REAL-WORLD SCENARIO TESTS
    // =============================================================================

    group('Real-world Scenarios', () {
      test('should handle typical success response', () {
        // Arrange
        final json = {
          'code': 200,
          'timestamp': 1640995200,
          'transaction_id': 'AADHAR_OTP_TXN_20220101_123456',
          'sub_code': 'OTP_SENT_SUCCESS',
          'message': 'OTP has been sent to your registered mobile number ending with ****7890',
        };

        // Act
        final model = AadharOTPSendModel.fromJson(json);

        // Assert
        expect(model.code, equals(200));
        expect(model.transactionId, contains('AADHAR_OTP_TXN'));
        expect(model.subCode, equals('OTP_SENT_SUCCESS'));
        expect(model.message, contains('OTP has been sent'));
      });

      test('should handle typical error response', () {
        // Arrange
        final json = {
          'code': 400,
          'timestamp': 1640995300,
          'transaction_id': 'AADHAR_ERROR_TXN_20220101_123457',
          'sub_code': 'INVALID_AADHAR_NUMBER',
          'message': 'The provided Aadhaar number is not valid. Please check and try again.',
        };

        // Act
        final model = AadharOTPSendModel.fromJson(json);

        // Assert
        expect(model.code, equals(400));
        expect(model.transactionId, contains('AADHAR_ERROR_TXN'));
        expect(model.subCode, equals('INVALID_AADHAR_NUMBER'));
        expect(model.message, contains('not valid'));
      });

      test('should handle rate limit response', () {
        // Arrange
        final json = {
          'code': 429,
          'timestamp': 1640995400,
          'transaction_id': 'AADHAR_RATE_LIMIT_TXN_20220101_123458',
          'sub_code': 'RATE_LIMIT_EXCEEDED',
          'message': 'Too many requests. Please try again after 5 minutes.',
        };

        // Act
        final model = AadharOTPSendModel.fromJson(json);

        // Assert
        expect(model.code, equals(429));
        expect(model.transactionId, contains('RATE_LIMIT'));
        expect(model.subCode, equals('RATE_LIMIT_EXCEEDED'));
        expect(model.message, contains('Too many requests'));
      });
    });
  });
}
