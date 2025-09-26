import 'package:flutter_test/flutter_test.dart';
import 'package:exchek/models/personal_user_models/captcha_model.dart';

void main() {
  group('CaptchaModel', () {
    // =============================================================================
    // CONSTRUCTOR TESTS
    // =============================================================================

    group('Constructor', () {
      test('should create instance with all required fields', () {
        // Arrange
        final data = Data(captcha: 'base64_captcha_image_data', sessionId: 'session_123');

        // Act
        final model = CaptchaModel(
          code: 200,
          timestamp: 1640995200,
          transactionId: 'captcha_txn_123456789',
          data: data,
        );

        // Assert
        expect(model.code, equals(200));
        expect(model.timestamp, equals(1640995200));
        expect(model.transactionId, equals('captcha_txn_123456789'));
        expect(model.data, equals(data));
        expect(model.data!.captcha, equals('base64_captcha_image_data'));
        expect(model.data!.sessionId, equals('session_123'));
      });

      test('should create instance with null data and transactionId', () {
        // Act
        final model = CaptchaModel(
          code: 400,
          timestamp: 1640995300,
          data: null,
          transactionId: null,
        );

        // Assert
        expect(model.code, equals(400));
        expect(model.timestamp, equals(1640995300));
        expect(model.data, isNull);
        expect(model.transactionId, isNull);
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
          'transaction_id': 'captcha_txn_123456789',
          'data': {
            'captcha': 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==',
            'session_id': 'session_123',
          },
        };

        // Act
        final model = CaptchaModel.fromJson(json);

        // Assert
        expect(model.code, equals(200));
        expect(model.timestamp, equals(1640995200));
        expect(model.transactionId, equals('captcha_txn_123456789'));
        expect(model.data!.captcha, equals('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg=='));
        expect(model.data!.sessionId, equals('session_123'));
      });

      test('should create instance from JSON with string numbers', () {
        // Arrange
        final json = {
          'code': '200', // String instead of int
          'timestamp': '1640995200', // String instead of int
          'transaction_id': 'captcha_txn_string_timestamp',
          'data': {
            'captcha': 'string_timestamp_captcha_data',
            'session_id': 'string_session',
          },
        };

        // Act
        final model = CaptchaModel.fromJson(json);

        // Assert
        expect(model.code, equals(200));
        expect(model.timestamp, equals(1640995200));
        expect(model.transactionId, equals('captcha_txn_string_timestamp'));
        expect(model.data!.captcha, equals('string_timestamp_captcha_data'));
        expect(model.data!.sessionId, equals('string_session'));
      });

      test('should create instance from JSON without data', () {
        // Arrange
        final json = {
          'code': 200,
          'timestamp': 1640995200,
          'transaction_id': 'no_data_txn',
          'data': null,
        };

        // Act
        final model = CaptchaModel.fromJson(json);

        // Assert
        expect(model.code, equals(200));
        expect(model.timestamp, equals(1640995200));
        expect(model.transactionId, equals('no_data_txn'));
        expect(model.data, isNull);
      });

      test('should handle invalid string numbers with fallback to 0', () {
        // Arrange
        final json = {
          'code': 'invalid_number',
          'timestamp': 'also_invalid',
          'transaction_id': 'fallback_test',
          'data': null,
        };

        // Act
        final model = CaptchaModel.fromJson(json);

        // Assert
        expect(model.code, equals(0)); // Falls back to 0
        expect(model.timestamp, equals(0)); // Falls back to 0
        expect(model.transactionId, equals('fallback_test'));
        expect(model.data, isNull);
      });

      test('should handle error response JSON', () {
        // Arrange
        final json = {
          'code': 500,
          'timestamp': 1640995300,
          'transaction_id': 'captcha_error_txn',
          'data': {
            'captcha': 'error_captcha_placeholder',
            'session_id': 'error_session',
          },
        };

        // Act
        final model = CaptchaModel.fromJson(json);

        // Assert
        expect(model.code, equals(500));
        expect(model.timestamp, equals(1640995300));
        expect(model.transactionId, equals('captcha_error_txn'));
        expect(model.data!.captcha, equals('error_captcha_placeholder'));
        expect(model.data!.sessionId, equals('error_session'));
      });
    });

    // =============================================================================
    // TO JSON TESTS
    // =============================================================================

    group('toJson', () {
      test('should convert complete model to JSON', () {
        // Arrange
        final data = Data(
          captcha: 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==',
          sessionId: 'session_123',
        );
        final model = CaptchaModel(
          code: 200,
          timestamp: 1640995200,
          transactionId: 'captcha_txn_123456789',
          data: data,
        );

        // Act
        final json = model.toJson();

        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['code'], equals(200));
        expect(json['timestamp'], equals(1640995200));
        expect(json['transaction_id'], equals('captcha_txn_123456789'));
        expect(json['data'], isNotNull);
        expect(json['data']['captcha'], equals('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg=='));
        expect(json['data']['session_id'], equals('session_123'));
        expect(json.length, equals(4));
      });

      test('should convert model without data to JSON', () {
        // Arrange
        final model = CaptchaModel(
          code: 200,
          timestamp: 1640995200,
          transactionId: 'empty_captcha_txn',
          data: null,
        );

        // Act
        final json = model.toJson();

        // Assert
        expect(json['code'], equals(200));
        expect(json['timestamp'], equals(1640995200));
        expect(json['transaction_id'], equals('empty_captcha_txn'));
        expect(json['data'], isNull);
      });

      test('should convert model with null transactionId to JSON', () {
        // Arrange
        final data = Data(captcha: 'test_captcha', sessionId: 'test_session');
        final model = CaptchaModel(
          code: 200,
          timestamp: 1640995200,
          transactionId: null,
          data: data,
        );

        // Act
        final json = model.toJson();

        // Assert
        expect(json['code'], equals(200));
        expect(json['timestamp'], equals(1640995200));
        expect(json['transaction_id'], isNull);
        expect(json['data'], isNotNull);
      });
    });

    // =============================================================================
    // SERIALIZATION ROUND-TRIP TESTS
    // =============================================================================

    group('Serialization Round-trip', () {
      test('should maintain data integrity through JSON round-trip', () {
        // Arrange
        final data = Data(
          captcha: 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==',
          sessionId: 'round_trip_session',
        );
        final originalModel = CaptchaModel(
          code: 200,
          timestamp: 1640995200,
          transactionId: 'round_trip_txn_123456789',
          data: data,
        );

        // Act
        final json = originalModel.toJson();
        final deserializedModel = CaptchaModel.fromJson(json);

        // Assert
        expect(deserializedModel.code, equals(originalModel.code));
        expect(deserializedModel.timestamp, equals(originalModel.timestamp));
        expect(deserializedModel.transactionId, equals(originalModel.transactionId));
        expect(deserializedModel.data!.captcha, equals(originalModel.data!.captcha));
        expect(deserializedModel.data!.sessionId, equals(originalModel.data!.sessionId));
      });

      test('should maintain data integrity with null values', () {
        // Arrange
        final originalModel = CaptchaModel(
          code: 400,
          timestamp: 1640995300,
          transactionId: null,
          data: null,
        );

        // Act
        final json = originalModel.toJson();
        final deserializedModel = CaptchaModel.fromJson(json);

        // Assert
        expect(deserializedModel.code, equals(originalModel.code));
        expect(deserializedModel.timestamp, equals(originalModel.timestamp));
        expect(deserializedModel.transactionId, equals(originalModel.transactionId));
        expect(deserializedModel.data, equals(originalModel.data));
      });
    });
  });

  // =============================================================================
  // DATA CLASS TESTS
  // =============================================================================

  group('Data', () {
    group('Constructor', () {
      test('should create instance with captcha and sessionId', () {
        // Act
        final data = Data(
          captcha: 'base64_encoded_captcha_image_data',
          sessionId: 'session_456',
        );

        // Assert
        expect(data.captcha, equals('base64_encoded_captcha_image_data'));
        expect(data.sessionId, equals('session_456'));
      });

      test('should create instance with empty values', () {
        // Act
        final data = Data(captcha: '', sessionId: '');

        // Assert
        expect(data.captcha, equals(''));
        expect(data.sessionId, equals(''));
      });
    });

    group('fromJson', () {
      test('should create instance from JSON', () {
        // Arrange
        final json = {
          'captcha': 'json_captcha_data_test',
          'session_id': 'json_session_test',
        };

        // Act
        final data = Data.fromJson(json);

        // Assert
        expect(data.captcha, equals('json_captcha_data_test'));
        expect(data.sessionId, equals('json_session_test'));
      });

      test('should create instance from JSON with special characters', () {
        // Arrange
        const specialCaptcha = 'captcha_with_special_chars_!@#\$%^&*()_+-=[]{}|;:,.<>?';
        const specialSession = 'session_with_special_chars_!@#\$%^&*()_+-=[]{}|;:,.<>?';
        final json = {
          'captcha': specialCaptcha,
          'session_id': specialSession,
        };

        // Act
        final data = Data.fromJson(json);

        // Assert
        expect(data.captcha, equals(specialCaptcha));
        expect(data.sessionId, equals(specialSession));
      });
    });

    group('toJson', () {
      test('should convert data to JSON', () {
        // Arrange
        final data = Data(
          captcha: 'to_json_captcha_test_data',
          sessionId: 'to_json_session_test',
        );

        // Act
        final json = data.toJson();

        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['captcha'], equals('to_json_captcha_test_data'));
        expect(json['session_id'], equals('to_json_session_test'));
        expect(json.length, equals(2));
      });

      test('should convert data with empty values to JSON', () {
        // Arrange
        final data = Data(captcha: '', sessionId: '');

        // Act
        final json = data.toJson();

        // Assert
        expect(json['captcha'], equals(''));
        expect(json['session_id'], equals(''));
        expect(json.length, equals(2));
      });
    });

    group('Serialization Round-trip', () {
      test('should maintain data integrity through JSON round-trip', () {
        // Arrange
        final originalData = Data(
          captcha: 'round_trip_captcha_data_integrity_test',
          sessionId: 'round_trip_session_integrity_test',
        );

        // Act
        final json = originalData.toJson();
        final deserializedData = Data.fromJson(json);

        // Assert
        expect(deserializedData.captcha, equals(originalData.captcha));
        expect(deserializedData.sessionId, equals(originalData.sessionId));
      });
    });
  });

  // =============================================================================
  // REAL-WORLD SCENARIO TESTS
  // =============================================================================

  group('Real-world Scenarios', () {
    test('should handle typical captcha generation response', () {
      // Arrange
      final json = {
        'code': 200,
        'timestamp': 1640995200,
        'transaction_id': 'CAPTCHA_GEN_TXN_20220101_123456',
        'data': {
          'captcha': 'iVBORw0KGgoAAAANSUhEUgAAASwAAABkCAMAAAC6xXZGAAAABGdBTUEAALGPC/xhBQAAAAFzUkdCAK7OHOkAAAAgY0hSTQAAeiYAAICEAAD6AAAAgOgAAHUwAADqYAAAOpgAABdwnLpRPAAAAwBQTFRF////AAAA',
          'session_id': 'CAPTCHA_SESSION_20220101_123456',
        },
      };

      // Act
      final model = CaptchaModel.fromJson(json);

      // Assert
      expect(model.code, equals(200));
      expect(model.transactionId, contains('CAPTCHA_GEN_TXN'));
      expect(model.data!.captcha, startsWith('iVBORw0KGgoAAAANSUhEUgAAASwAAABkCAMAAAC6xXZG'));
      expect(model.data!.sessionId, contains('CAPTCHA_SESSION'));
    });

    test('should handle captcha generation failure response', () {
      // Arrange
      final json = {
        'code': 500,
        'timestamp': 1640995300,
        'transaction_id': 'CAPTCHA_ERROR_TXN_20220101_123457',
        'data': null,
      };

      // Act
      final model = CaptchaModel.fromJson(json);

      // Assert
      expect(model.code, equals(500));
      expect(model.transactionId, contains('CAPTCHA_ERROR_TXN'));
      expect(model.data, isNull);
    });
  });
}
