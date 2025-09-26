import 'package:flutter_test/flutter_test.dart';
import 'package:exchek/models/personal_user_models/recaptcha_model.dart';

void main() {
  group('RecaptchaModel', () {
    // =============================================================================
    // CONSTRUCTOR TESTS
    // =============================================================================

    group('Constructor', () {
      test('should create instance with all required fields', () {
        // Arrange
        final data = RecaptchaData(captcha: 'base64_recaptcha_image_data');

        // Act
        final model = RecaptchaModel(
          timestamp: 1640995200,
          transactionId: 'recaptcha_txn_123456789',
          data: data,
          code: 200,
        );

        // Assert
        expect(model.timestamp, equals(1640995200));
        expect(model.transactionId, equals('recaptcha_txn_123456789'));
        expect(model.data, equals(data));
        expect(model.code, equals(200));
        expect(model.data?.captcha, equals('base64_recaptcha_image_data'));
      });

      test('should create instance with different status codes', () {
        // Arrange
        final successData = RecaptchaData(captcha: 'success_recaptcha_data');
        final errorData = RecaptchaData(captcha: 'error_recaptcha_data');

        // Act
        final successModel = RecaptchaModel(
          timestamp: 1640995200,
          transactionId: 'success_txn',
          data: successData,
          code: 200,
        );

        final errorModel = RecaptchaModel(
          timestamp: 1640995300,
          transactionId: 'error_txn',
          data: errorData,
          code: 500,
        );

        // Assert
        expect(successModel.code, equals(200));
        expect(successModel.data?.captcha, equals('success_recaptcha_data'));
        expect(errorModel.code, equals(500));
        expect(errorModel.data?.captcha, equals('error_recaptcha_data'));
      });

      test('should create instance with edge case values', () {
        // Arrange
        final data = RecaptchaData(captcha: '');

        // Act
        final model = RecaptchaModel(timestamp: 0, transactionId: '', data: data, code: 0);

        // Assert
        expect(model.timestamp, equals(0));
        expect(model.transactionId, equals(''));
        expect(model.data?.captcha, equals(''));
        expect(model.code, equals(0));
      });
    });

    // =============================================================================
    // FROM JSON TESTS
    // =============================================================================

    group('fromJson', () {
      test('should create instance from complete JSON', () {
        // Arrange
        final json = {
          'timestamp': 1640995200,
          'transaction_id': 'recaptcha_txn_123456789',
          'data': {
            'captcha':
                'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==',
          },
          'code': 200,
        };

        // Act
        final model = RecaptchaModel.fromJson(json);

        // Assert
        expect(model.timestamp, equals(1640995200));
        expect(model.transactionId, equals('recaptcha_txn_123456789'));
        expect(model.code, equals(200));
        expect(
          model.data?.captcha,
          equals('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg=='),
        );
      });

      test('should create instance from JSON with different data types', () {
        // Arrange
        final json = {
          'timestamp': 1640995200,
          'transaction_id': 'recaptcha_txn_different_types',
          'data': {'captcha': 'different_types_recaptcha_data'},
          'code': 200,
        };

        // Act
        final model = RecaptchaModel.fromJson(json);

        // Assert
        expect(model.timestamp, equals(1640995200));
        expect(model.transactionId, equals('recaptcha_txn_different_types'));
        expect(model.code, equals(200));
        expect(model.data?.captcha, equals('different_types_recaptcha_data'));
      });

      test('should handle error response JSON', () {
        // Arrange
        final json = {
          'timestamp': 1640995300,
          'transaction_id': 'recaptcha_error_txn',
          'data': {'captcha': 'error_recaptcha_placeholder'},
          'code': 500,
        };

        // Act
        final model = RecaptchaModel.fromJson(json);

        // Assert
        expect(model.timestamp, equals(1640995300));
        expect(model.transactionId, equals('recaptcha_error_txn'));
        expect(model.code, equals(500));
        expect(model.data?.captcha, equals('error_recaptcha_placeholder'));
      });

      test('should handle large timestamp values', () {
        // Arrange
        final json = {
          'timestamp': 9999999999,
          'transaction_id': 'large_timestamp_txn',
          'data': {'captcha': 'large_timestamp_recaptcha'},
          'code': 200,
        };

        // Act
        final model = RecaptchaModel.fromJson(json);

        // Assert
        expect(model.timestamp, equals(9999999999));
        expect(model.transactionId, equals('large_timestamp_txn'));
        expect(model.data?.captcha, equals('large_timestamp_recaptcha'));
      });

      test('should handle special characters in fields', () {
        // Arrange
        final json = {
          'timestamp': 1640995200,
          'transaction_id': 'special_chars_txn_!@#\$%^&*()',
          'data': {'captcha': 'special_chars_recaptcha_!@#\$%^&*()'},
          'code': 200,
        };

        // Act
        final model = RecaptchaModel.fromJson(json);

        // Assert
        expect(model.timestamp, equals(1640995200));
        expect(model.transactionId, equals('special_chars_txn_!@#\$%^&*()'));
        expect(model.data?.captcha, equals('special_chars_recaptcha_!@#\$%^&*()'));
      });
    });

    // =============================================================================
    // TO JSON TESTS
    // =============================================================================

    group('toJson', () {
      test('should convert complete model to JSON', () {
        // Arrange
        final data = RecaptchaData(
          captcha: 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==',
        );
        final model = RecaptchaModel(
          timestamp: 1640995200,
          transactionId: 'recaptcha_txn_123456789',
          data: data,
          code: 200,
        );

        // Act
        final json = model.toJson();

        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['timestamp'], equals(1640995200));
        expect(json['transaction_id'], equals('recaptcha_txn_123456789'));
        expect(json['code'], equals(200));
        expect(json['data'], isNotNull);
        expect(
          json['data']['captcha'],
          equals('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg=='),
        );
        expect(json.length, equals(4));
      });

      test('should convert model with error values to JSON', () {
        // Arrange
        final data = RecaptchaData(captcha: 'error_recaptcha_data');
        final model = RecaptchaModel(
          timestamp: 1640995300,
          transactionId: 'error_recaptcha_txn',
          data: data,
          code: 500,
        );

        // Act
        final json = model.toJson();

        // Assert
        expect(json['timestamp'], equals(1640995300));
        expect(json['transaction_id'], equals('error_recaptcha_txn'));
        expect(json['code'], equals(500));
        expect(json['data']['captcha'], equals('error_recaptcha_data'));
      });

      test('should convert model with edge case values to JSON', () {
        // Arrange
        final data = RecaptchaData(captcha: '');
        final model = RecaptchaModel(timestamp: 0, transactionId: '', data: data, code: 0);

        // Act
        final json = model.toJson();

        // Assert
        expect(json['timestamp'], equals(0));
        expect(json['transaction_id'], equals(''));
        expect(json['code'], equals(0));
        expect(json['data']['captcha'], equals(''));
      });

      test('should maintain correct JSON structure', () {
        // Arrange
        final data = RecaptchaData(captcha: 'structure_test_recaptcha');
        final model = RecaptchaModel(timestamp: 1640995200, transactionId: 'structure_test_txn', data: data, code: 200);

        // Act
        final json = model.toJson();

        // Assert
        expect(json.keys, containsAll(['timestamp', 'transaction_id', 'data', 'code']));
        expect(json['data'].keys, contains('captcha'));
        expect(json.keys.length, equals(4));
        expect(json['data'].keys.length, equals(1));
      });
    });

    // =============================================================================
    // SERIALIZATION ROUND-TRIP TESTS
    // =============================================================================

    group('Serialization Round-trip', () {
      test('should maintain data integrity through JSON round-trip', () {
        // Arrange
        final data = RecaptchaData(
          captcha: 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==',
        );
        final originalModel = RecaptchaModel(
          timestamp: 1640995200,
          transactionId: 'round_trip_txn_123456789',
          data: data,
          code: 200,
        );

        // Act
        final json = originalModel.toJson();
        final deserializedModel = RecaptchaModel.fromJson(json);

        // Assert
        expect(deserializedModel.timestamp, equals(originalModel.timestamp));
        expect(deserializedModel.transactionId, equals(originalModel.transactionId));
        expect(deserializedModel.code, equals(originalModel.code));
        expect(deserializedModel.data?.captcha, equals(originalModel.data?.captcha));
      });

      test('should maintain data integrity through multiple round-trips', () {
        // Arrange
        final data = RecaptchaData(captcha: 'multiple_round_trip_recaptcha_data');
        final originalModel = RecaptchaModel(
          timestamp: 1640995200,
          transactionId: 'multiple_round_trip_txn',
          data: data,
          code: 200,
        );

        // Act & Assert - First round-trip
        final json1 = originalModel.toJson();
        final model1 = RecaptchaModel.fromJson(json1);
        expect(model1.data?.captcha, equals(originalModel.data?.captcha));

        // Act & Assert - Second round-trip
        final json2 = model1.toJson();
        final model2 = RecaptchaModel.fromJson(json2);
        expect(model2.data?.captcha, equals(originalModel.data?.captcha));

        // Act & Assert - Third round-trip
        final json3 = model2.toJson();
        final finalModel = RecaptchaModel.fromJson(json3);
        expect(finalModel.data?.captcha, equals(originalModel.data?.captcha));
      });

      test('should handle edge case values in round-trip', () {
        // Arrange
        final data = RecaptchaData(captcha: '');
        final originalModel = RecaptchaModel(timestamp: 0, transactionId: '', data: data, code: 0);

        // Act
        final json = originalModel.toJson();
        final deserializedModel = RecaptchaModel.fromJson(json);

        // Assert
        expect(deserializedModel.timestamp, equals(originalModel.timestamp));
        expect(deserializedModel.transactionId, equals(originalModel.transactionId));
        expect(deserializedModel.code, equals(originalModel.code));
        expect(deserializedModel.data?.captcha, equals(originalModel.data?.captcha));
      });
    });
  });

  // =============================================================================
  // RECAPTCHA DATA CLASS TESTS
  // =============================================================================

  group('RecaptchaData', () {
    group('Constructor', () {
      test('should create instance with captcha', () {
        // Act
        final data = RecaptchaData(captcha: 'base64_encoded_recaptcha_image_data');

        // Assert
        expect(data.captcha, equals('base64_encoded_recaptcha_image_data'));
      });

      test('should create instance with empty captcha', () {
        // Act
        final data = RecaptchaData(captcha: '');

        // Assert
        expect(data.captcha, equals(''));
      });

      test('should create instance with special characters', () {
        // Arrange
        const specialCaptcha = 'recaptcha_with_special_chars_!@#\$%^&*()_+-=[]{}|;:,.<>?';

        // Act
        final data = RecaptchaData(captcha: specialCaptcha);

        // Assert
        expect(data.captcha, equals(specialCaptcha));
      });

      test('should create instance with very long captcha', () {
        // Arrange
        final largeCaptcha = 'A' * 10000; // 10000 character captcha

        // Act
        final data = RecaptchaData(captcha: largeCaptcha);

        // Assert
        expect(data.captcha, equals(largeCaptcha));
        expect(data.captcha?.length, equals(10000));
      });
    });

    group('fromJson', () {
      test('should create instance from JSON', () {
        // Arrange
        final json = {'captcha': 'json_recaptcha_data_test'};

        // Act
        final data = RecaptchaData.fromJson(json);

        // Assert
        expect(data.captcha, equals('json_recaptcha_data_test'));
      });

      test('should create instance from JSON with empty captcha', () {
        // Arrange
        final json = {'captcha': ''};

        // Act
        final data = RecaptchaData.fromJson(json);

        // Assert
        expect(data.captcha, equals(''));
      });

      test('should create instance from JSON with special characters', () {
        // Arrange
        const specialCaptcha = 'recaptcha_with_special_chars_!@#\$%^&*()_+-=[]{}|;:,.<>?';
        final json = {'captcha': specialCaptcha};

        // Act
        final data = RecaptchaData.fromJson(json);

        // Assert
        expect(data.captcha, equals(specialCaptcha));
      });

      test('should create instance from JSON with unicode characters', () {
        // Arrange
        const unicodeCaptcha = 'recaptcha_unicode: 你好 🌟 ñáéíóú àèìòù äëïöü';
        final json = {'captcha': unicodeCaptcha};

        // Act
        final data = RecaptchaData.fromJson(json);

        // Assert
        expect(data.captcha, equals(unicodeCaptcha));
      });
    });

    group('toJson', () {
      test('should convert data to JSON', () {
        // Arrange
        final data = RecaptchaData(captcha: 'to_json_recaptcha_test_data');

        // Act
        final json = data.toJson();

        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['captcha'], equals('to_json_recaptcha_test_data'));
        expect(json.length, equals(1));
      });

      test('should convert data with empty captcha to JSON', () {
        // Arrange
        final data = RecaptchaData(captcha: '');

        // Act
        final json = data.toJson();

        // Assert
        expect(json['captcha'], equals(''));
        expect(json.length, equals(1));
      });

      test('should convert data with special characters to JSON', () {
        // Arrange
        const specialCaptcha = 'special_chars_!@#\$%^&*()_+-=[]{}|;:,.<>?';
        final data = RecaptchaData(captcha: specialCaptcha);

        // Act
        final json = data.toJson();

        // Assert
        expect(json['captcha'], equals(specialCaptcha));
      });
    });

    group('Serialization Round-trip', () {
      test('should maintain data integrity through JSON round-trip', () {
        // Arrange
        final originalData = RecaptchaData(captcha: 'round_trip_recaptcha_data_integrity_test');

        // Act
        final json = originalData.toJson();
        final deserializedData = RecaptchaData.fromJson(json);

        // Assert
        expect(deserializedData.captcha, equals(originalData.captcha));
      });

      test('should maintain data integrity with large captcha', () {
        // Arrange
        final largeCaptcha = 'B' * 5000; // 5000 character captcha
        final originalData = RecaptchaData(captcha: largeCaptcha);

        // Act
        final json = originalData.toJson();
        final deserializedData = RecaptchaData.fromJson(json);

        // Assert
        expect(deserializedData.captcha, equals(originalData.captcha));
        expect(deserializedData.captcha?.length, equals(5000));
      });
    });
  });

  // =============================================================================
  // EDGE CASES AND ERROR HANDLING TESTS
  // =============================================================================

  group('Edge Cases', () {
    test('should handle negative timestamp values', () {
      // Arrange
      final data = RecaptchaData(captcha: 'negative_timestamp_test');
      final model = RecaptchaModel(
        timestamp: -1640995200,
        transactionId: 'negative_timestamp_txn',
        data: data,
        code: 200,
      );

      // Act
      final json = model.toJson();
      final deserializedModel = RecaptchaModel.fromJson(json);

      // Assert
      expect(deserializedModel.timestamp, equals(-1640995200));
      expect(deserializedModel.data?.captcha, equals('negative_timestamp_test'));
    });

    test('should handle maximum integer values', () {
      // Arrange
      final data = RecaptchaData(captcha: 'max_int_test');
      final model = RecaptchaModel(
        timestamp: 9223372036854775807, // Max int64 value
        transactionId: 'max_int_txn',
        data: data,
        code: 2147483647, // Max int32 value
      );

      // Act
      final json = model.toJson();
      final deserializedModel = RecaptchaModel.fromJson(json);

      // Assert
      expect(deserializedModel.timestamp, equals(9223372036854775807));
      expect(deserializedModel.code, equals(2147483647));
      expect(deserializedModel.data?.captcha, equals('max_int_test'));
    });

    test('should handle whitespace in captcha', () {
      // Arrange
      const captchaWithWhitespace = '   recaptcha_with_whitespace   \n\t\r';
      final data = RecaptchaData(captcha: captchaWithWhitespace);
      final model = RecaptchaModel(timestamp: 1640995200, transactionId: 'whitespace_test_txn', data: data, code: 200);

      // Act
      final json = model.toJson();
      final deserializedModel = RecaptchaModel.fromJson(json);

      // Assert
      expect(deserializedModel.data?.captcha, equals(captchaWithWhitespace));
    });
  });

  // =============================================================================
  // REAL-WORLD SCENARIO TESTS
  // =============================================================================

  group('Real-world Scenarios', () {
    test('should handle typical recaptcha generation response', () {
      // Arrange
      final json = {
        'timestamp': 1640995200,
        'transaction_id': 'RECAPTCHA_GEN_TXN_20220101_123456',
        'data': {
          'captcha':
              'iVBORw0KGgoAAAANSUhEUgAAASwAAABkCAMAAAC6xXZGAAAABGdBTUEAALGPC/xhBQAAAAFzUkdCAK7OHOkAAAAgY0hSTQAAeiYAAICEAAD6AAAAgOgAAHUwAADqYAAAOpgAABdwnLpRPAAAAwBQTFRF////AAAA',
        },
        'code': 200,
      };

      // Act
      final model = RecaptchaModel.fromJson(json);

      // Assert
      expect(model.code, equals(200));
      expect(model.transactionId, contains('RECAPTCHA_GEN_TXN'));
      expect(model.data?.captcha, startsWith('iVBORw0KGgoAAAANSUhEUgAAASwAAABkCAMAAAC6xXZG'));
    });

    test('should handle recaptcha generation failure response', () {
      // Arrange
      final json = {
        'timestamp': 1640995300,
        'transaction_id': 'RECAPTCHA_ERROR_TXN_20220101_123457',
        'data': {'captcha': ''},
        'code': 500,
      };

      // Act
      final model = RecaptchaModel.fromJson(json);

      // Assert
      expect(model.code, equals(500));
      expect(model.transactionId, contains('RECAPTCHA_ERROR_TXN'));
      expect(model.data?.captcha, equals(''));
    });

    test('should handle rate limit response', () {
      // Arrange
      final json = {
        'timestamp': 1640995400,
        'transaction_id': 'RECAPTCHA_RATE_LIMIT_TXN_20220101_123458',
        'data': {'captcha': 'rate_limit_placeholder'},
        'code': 429,
      };

      // Act
      final model = RecaptchaModel.fromJson(json);

      // Assert
      expect(model.code, equals(429));
      expect(model.transactionId, contains('RECAPTCHA_RATE_LIMIT_TXN'));
      expect(model.data?.captcha, equals('rate_limit_placeholder'));
    });
  });
}
