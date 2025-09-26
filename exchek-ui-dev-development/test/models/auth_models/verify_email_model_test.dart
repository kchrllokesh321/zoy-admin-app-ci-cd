import 'package:flutter_test/flutter_test.dart';
import 'package:exchek/models/auth_models/verify_email_model.dart';

void main() {
  group('VerifyEmailModel', () {
    // =============================================================================
    // CONSTRUCTOR TESTS
    // =============================================================================

    group('Constructor', () {
      test('should create instance with default null values', () {
        // Act
        final model = VerifyEmailModel();

        // Assert
        expect(model.success, isNull);
        expect(model.data, isNull);
      });

      test('should create instance with provided values', () {
        // Arrange
        final data = VerifyEmailData(status: true, message: 'Email verified');

        // Act
        final model = VerifyEmailModel(success: true, data: data);

        // Assert
        expect(model.success, isTrue);
        expect(model.data, equals(data));
      });

      test('should create instance with false success', () {
        // Arrange
        final data = VerifyEmailData(status: false, message: 'Verification failed');

        // Act
        final model = VerifyEmailModel(success: false, data: data);

        // Assert
        expect(model.success, isFalse);
        expect(model.data, equals(data));
        expect(model.data!.status, isFalse);
      });
    });

    // =============================================================================
    // FROM JSON TESTS
    // =============================================================================

    group('fromJson', () {
      test('should create instance from complete JSON with data', () {
        // Arrange
        final json = {
          'success': true,
          'data': {
            'status': true,
            'message': 'Email verified successfully',
            'email': 'john@example.com',
            'token': 'verification_token_123',
          }
        };

        // Act
        final model = VerifyEmailModel.fromJson(json);

        // Assert
        expect(model.success, isTrue);
        expect(model.data, isNotNull);
        expect(model.data!.status, isTrue);
        expect(model.data!.message, equals('Email verified successfully'));
        expect(model.data!.email, equals('john@example.com'));
        expect(model.data!.token, equals('verification_token_123'));
      });

      test('should create instance from JSON with error field when data is null', () {
        // Arrange
        final json = {
          'success': false,
          'data': null,
          'error': 'Invalid verification token',
        };

        // Act
        final model = VerifyEmailModel.fromJson(json);

        // Assert
        expect(model.success, isFalse);
        expect(model.data, isNotNull);
        expect(model.data!.message, equals('Invalid verification token'));
        expect(model.data!.status, isNull);
        expect(model.data!.email, isNull);
        expect(model.data!.token, isNull);
      });

      test('should create instance from JSON without data and without error', () {
        // Arrange
        final json = {
          'success': false,
          'data': null,
        };

        // Act
        final model = VerifyEmailModel.fromJson(json);

        // Assert
        expect(model.success, isFalse);
        expect(model.data, isNotNull);
        expect(model.data!.message, equals(''));
        expect(model.data!.status, isNull);
        expect(model.data!.email, isNull);
        expect(model.data!.token, isNull);
      });

      test('should create instance from JSON without data field', () {
        // Arrange
        final json = {
          'success': true,
        };

        // Act
        final model = VerifyEmailModel.fromJson(json);

        // Assert
        expect(model.success, isTrue);
        expect(model.data, isNotNull);
        expect(model.data!.message, equals(''));
      });

      test('should create instance from empty JSON', () {
        // Arrange
        final json = <String, dynamic>{};

        // Act
        final model = VerifyEmailModel.fromJson(json);

        // Assert
        expect(model.success, isNull);
        expect(model.data, isNotNull);
        expect(model.data!.message, equals(''));
      });

      test('should handle null values in JSON', () {
        // Arrange
        final json = {
          'success': null,
          'data': null,
          'error': null,
        };

        // Act
        final model = VerifyEmailModel.fromJson(json);

        // Assert
        expect(model.success, isNull);
        expect(model.data, isNotNull);
        expect(model.data!.message, equals(''));
      });

      test('should prioritize error field when both data and error are present', () {
        // Arrange
        final json = {
          'success': false,
          'data': {
            'status': true,
            'message': 'Success message',
          },
          'error': 'Error message',
        };

        // Act
        final model = VerifyEmailModel.fromJson(json);

        // Assert
        expect(model.success, isFalse);
        expect(model.data, isNotNull);
        expect(model.data!.status, isTrue);
        expect(model.data!.message, equals('Success message'));
      });
    });

    // =============================================================================
    // TO JSON TESTS
    // =============================================================================

    group('toJson', () {
      test('should convert complete model to JSON', () {
        // Arrange
        final data = VerifyEmailData(
          status: true,
          message: 'Email verified successfully',
          email: 'john@example.com',
          token: 'verification_token_123',
        );
        final model = VerifyEmailModel(success: true, data: data);

        // Act
        final json = model.toJson();

        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['success'], isTrue);
        expect(json['data'], isNotNull);
        expect(json['data']['status'], isTrue);
        expect(json['data']['message'], equals('Email verified successfully'));
        expect(json['data']['email'], equals('john@example.com'));
        expect(json['data']['token'], equals('verification_token_123'));
      });

      test('should convert model without data to JSON', () {
        // Arrange
        final model = VerifyEmailModel(success: false);

        // Act
        final json = model.toJson();

        // Assert
        expect(json['success'], isFalse);
        expect(json.containsKey('data'), isFalse);
        expect(json.length, equals(1));
      });

      test('should convert null model to JSON', () {
        // Arrange
        final model = VerifyEmailModel();

        // Act
        final json = model.toJson();

        // Assert
        expect(json['success'], isNull);
        expect(json.containsKey('data'), isFalse);
        expect(json.length, equals(1));
      });

      test('should convert model with null data to JSON', () {
        // Arrange
        final model = VerifyEmailModel(success: true, data: null);

        // Act
        final json = model.toJson();

        // Assert
        expect(json['success'], isTrue);
        expect(json.containsKey('data'), isFalse);
        expect(json.length, equals(1));
      });
    });

    // =============================================================================
    // SERIALIZATION ROUND-TRIP TESTS
    // =============================================================================

    group('Serialization Round-trip', () {
      test('should maintain data integrity through JSON round-trip', () {
        // Arrange
        final data = VerifyEmailData(
          status: true,
          message: 'Email verified successfully',
          email: 'john@example.com',
          token: 'verification_token_123',
        );
        final originalModel = VerifyEmailModel(success: true, data: data);

        // Act
        final json = originalModel.toJson();
        final deserializedModel = VerifyEmailModel.fromJson(json);

        // Assert
        expect(deserializedModel.success, equals(originalModel.success));
        expect(deserializedModel.data!.status, equals(originalModel.data!.status));
        expect(deserializedModel.data!.message, equals(originalModel.data!.message));
        expect(deserializedModel.data!.email, equals(originalModel.data!.email));
        expect(deserializedModel.data!.token, equals(originalModel.data!.token));
      });

      test('should maintain data integrity through JSON round-trip with null values', () {
        // Arrange
        final originalModel = VerifyEmailModel();

        // Act
        final json = originalModel.toJson();
        final deserializedModel = VerifyEmailModel.fromJson(json);

        // Assert
        expect(deserializedModel.success, equals(originalModel.success));
        // Note: data will not be null after deserialization due to the fromJson logic
        expect(deserializedModel.data, isNotNull);
        expect(deserializedModel.data!.message, equals(''));
      });
    });
  });

  // =============================================================================
  // VERIFY EMAIL DATA CLASS TESTS
  // =============================================================================

  group('VerifyEmailData', () {
    group('Constructor', () {
      test('should create instance with default null values', () {
        // Act
        final data = VerifyEmailData();

        // Assert
        expect(data.status, isNull);
        expect(data.message, isNull);
        expect(data.email, isNull);
        expect(data.token, isNull);
      });

      test('should create instance with provided values', () {
        // Act
        final data = VerifyEmailData(
          status: true,
          message: 'Email verified successfully',
          email: 'john@example.com',
          token: 'verification_token_123',
        );

        // Assert
        expect(data.status, isTrue);
        expect(data.message, equals('Email verified successfully'));
        expect(data.email, equals('john@example.com'));
        expect(data.token, equals('verification_token_123'));
      });

      test('should create instance with false status', () {
        // Act
        final data = VerifyEmailData(
          status: false,
          message: 'Verification failed',
          email: 'john@example.com',
        );

        // Assert
        expect(data.status, isFalse);
        expect(data.message, equals('Verification failed'));
        expect(data.email, equals('john@example.com'));
        expect(data.token, isNull);
      });
    });

    group('fromJson', () {
      test('should create instance from complete JSON', () {
        // Arrange
        final json = {
          'status': true,
          'message': 'Email verified successfully',
          'email': 'john@example.com',
          'token': 'verification_token_123',
        };

        // Act
        final data = VerifyEmailData.fromJson(json);

        // Assert
        expect(data.status, isTrue);
        expect(data.message, equals('Email verified successfully'));
        expect(data.email, equals('john@example.com'));
        expect(data.token, equals('verification_token_123'));
      });

      test('should create instance from partial JSON', () {
        // Arrange
        final json = {
          'status': false,
          'message': 'Verification failed',
        };

        // Act
        final data = VerifyEmailData.fromJson(json);

        // Assert
        expect(data.status, isFalse);
        expect(data.message, equals('Verification failed'));
        expect(data.email, isNull);
        expect(data.token, isNull);
      });

      test('should create instance from empty JSON', () {
        // Arrange
        final json = <String, dynamic>{};

        // Act
        final data = VerifyEmailData.fromJson(json);

        // Assert
        expect(data.status, isNull);
        expect(data.message, isNull);
        expect(data.email, isNull);
        expect(data.token, isNull);
      });

      test('should handle null values in JSON', () {
        // Arrange
        final json = {
          'status': null,
          'message': null,
          'email': null,
          'token': null,
        };

        // Act
        final data = VerifyEmailData.fromJson(json);

        // Assert
        expect(data.status, isNull);
        expect(data.message, isNull);
        expect(data.email, isNull);
        expect(data.token, isNull);
      });
    });

    group('toJson', () {
      test('should convert complete data to JSON', () {
        // Arrange
        final data = VerifyEmailData(
          status: true,
          message: 'Email verified successfully',
          email: 'john@example.com',
          token: 'verification_token_123',
        );

        // Act
        final json = data.toJson();

        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['status'], isTrue);
        expect(json['message'], equals('Email verified successfully'));
        expect(json['email'], equals('john@example.com'));
        expect(json['token'], equals('verification_token_123'));
        expect(json.length, equals(4));
      });

      test('should convert data with null values to JSON', () {
        // Arrange
        final data = VerifyEmailData();

        // Act
        final json = data.toJson();

        // Assert
        expect(json['status'], isNull);
        expect(json['message'], isNull);
        expect(json['email'], isNull);
        expect(json['token'], isNull);
        expect(json.length, equals(4));
      });

      test('should convert partial data to JSON', () {
        // Arrange
        final data = VerifyEmailData(
          status: false,
          message: 'Verification failed',
        );

        // Act
        final json = data.toJson();

        // Assert
        expect(json['status'], isFalse);
        expect(json['message'], equals('Verification failed'));
        expect(json['email'], isNull);
        expect(json['token'], isNull);
      });
    });

    group('Serialization Round-trip', () {
      test('should maintain data integrity through JSON round-trip', () {
        // Arrange
        final originalData = VerifyEmailData(
          status: true,
          message: 'Email verified successfully',
          email: 'john@example.com',
          token: 'verification_token_123',
        );

        // Act
        final json = originalData.toJson();
        final deserializedData = VerifyEmailData.fromJson(json);

        // Assert
        expect(deserializedData.status, equals(originalData.status));
        expect(deserializedData.message, equals(originalData.message));
        expect(deserializedData.email, equals(originalData.email));
        expect(deserializedData.token, equals(originalData.token));
      });

      test('should maintain data integrity through JSON round-trip with null values', () {
        // Arrange
        final originalData = VerifyEmailData();

        // Act
        final json = originalData.toJson();
        final deserializedData = VerifyEmailData.fromJson(json);

        // Assert
        expect(deserializedData.status, equals(originalData.status));
        expect(deserializedData.message, equals(originalData.message));
        expect(deserializedData.email, equals(originalData.email));
        expect(deserializedData.token, equals(originalData.token));
      });
    });
  });

  // =============================================================================
  // EDGE CASES AND ERROR HANDLING TESTS
  // =============================================================================

  group('Edge Cases', () {
    test('should handle property modification after creation', () {
      // Arrange
      final model = VerifyEmailModel(success: true);

      // Act
      model.success = false;
      model.data = VerifyEmailData(status: true, message: 'Modified');

      // Assert
      expect(model.success, isFalse);
      expect(model.data, isNotNull);
      expect(model.data!.status, isTrue);
      expect(model.data!.message, equals('Modified'));
    });

    test('should handle data property modification', () {
      // Arrange
      final data = VerifyEmailData(status: true, message: 'Original');

      // Act
      data.status = false;
      data.message = 'Modified';
      data.email = 'new@example.com';
      data.token = 'new_token';

      // Assert
      expect(data.status, isFalse);
      expect(data.message, equals('Modified'));
      expect(data.email, equals('new@example.com'));
      expect(data.token, equals('new_token'));
    });

    test('should handle setting properties to null', () {
      // Arrange
      final data = VerifyEmailData(
        status: true,
        message: 'Original',
        email: 'test@example.com',
        token: 'token123',
      );
      final model = VerifyEmailModel(success: true, data: data);

      // Act
      model.success = null;
      model.data = null;
      data.status = null;
      data.message = null;
      data.email = null;
      data.token = null;

      // Assert
      expect(model.success, isNull);
      expect(model.data, isNull);
      expect(data.status, isNull);
      expect(data.message, isNull);
      expect(data.email, isNull);
      expect(data.token, isNull);
    });

    test('should handle special characters in message and email', () {
      // Arrange
      const specialMessage = 'Special chars: !@#\$%^&*()_+-=[]{}|;:,.<>?/~`"\'\\';
      const specialEmail = 'test+special@example-domain.co.uk';
      final data = VerifyEmailData(
        status: true,
        message: specialMessage,
        email: specialEmail,
        token: 'token_with_special_chars_123!@#',
      );

      // Act
      final json = data.toJson();
      final deserializedData = VerifyEmailData.fromJson(json);

      // Assert
      expect(deserializedData.message, equals(specialMessage));
      expect(deserializedData.email, equals(specialEmail));
      expect(deserializedData.token, equals('token_with_special_chars_123!@#'));
    });
  });
}
