import 'package:flutter_test/flutter_test.dart';
import 'package:exchek/models/auth_models/common_success_model.dart';

void main() {
  group('CommonSuccessModel', () {
    // =============================================================================
    // CONSTRUCTOR TESTS
    // =============================================================================

    group('Constructor', () {
      test('should create instance with default null values', () {
        // Act
        final model = CommonSuccessModel();

        // Assert
        expect(model.success, isNull);
        expect(model.message, isNull);
      });

      test('should create instance with provided success value', () {
        // Act
        final model = CommonSuccessModel(success: true);

        // Assert
        expect(model.success, isTrue);
        expect(model.message, isNull);
      });

      test('should create instance with provided message value', () {
        // Act
        final model = CommonSuccessModel(message: 'Test message');

        // Assert
        expect(model.success, isNull);
        expect(model.message, equals('Test message'));
      });

      test('should create instance with both success and message values', () {
        // Act
        final model = CommonSuccessModel(success: true, message: 'Operation successful');

        // Assert
        expect(model.success, isTrue);
        expect(model.message, equals('Operation successful'));
      });

      test('should create instance with false success value', () {
        // Act
        final model = CommonSuccessModel(success: false, message: 'Operation failed');

        // Assert
        expect(model.success, isFalse);
        expect(model.message, equals('Operation failed'));
      });
    });

    // =============================================================================
    // FROM JSON TESTS
    // =============================================================================

    group('fromJson', () {
      test('should create instance from valid JSON with all fields', () {
        // Arrange
        final json = {'success': true, 'message': 'Request processed successfully'};

        // Act
        final model = CommonSuccessModel.fromJson(json);

        // Assert
        expect(model.success, isTrue);
        expect(model.message, equals('Request processed successfully'));
      });

      test('should create instance from JSON with success false', () {
        // Arrange
        final json = {'success': false, 'message': 'Request failed'};

        // Act
        final model = CommonSuccessModel.fromJson(json);

        // Assert
        expect(model.success, isFalse);
        expect(model.message, equals('Request failed'));
      });

      test('should create instance from JSON with only success field', () {
        // Arrange
        final json = {'success': true};

        // Act
        final model = CommonSuccessModel.fromJson(json);

        // Assert
        expect(model.success, isTrue);
        expect(model.message, isNull);
      });

      test('should create instance from JSON with only message field', () {
        // Arrange
        final json = {'message': 'Status message'};

        // Act
        final model = CommonSuccessModel.fromJson(json);

        // Assert
        expect(model.success, isNull);
        expect(model.message, equals('Status message'));
      });

      test('should create instance from empty JSON', () {
        // Arrange
        final json = <String, dynamic>{};

        // Act
        final model = CommonSuccessModel.fromJson(json);

        // Assert
        expect(model.success, isNull);
        expect(model.message, isNull);
      });

      test('should handle null values in JSON', () {
        // Arrange
        final json = {'success': null, 'message': null};

        // Act
        final model = CommonSuccessModel.fromJson(json);

        // Assert
        expect(model.success, isNull);
        expect(model.message, isNull);
      });

      test('should handle boolean true value in JSON', () {
        // Arrange
        final json = {'success': true, 'message': 'Boolean true test'};

        // Act
        final model = CommonSuccessModel.fromJson(json);

        // Assert
        expect(model.success, isTrue);
        expect(model.message, equals('Boolean true test'));
      });

      test('should handle boolean false value in JSON', () {
        // Arrange
        final json = {'success': false, 'message': 'Boolean false test'};

        // Act
        final model = CommonSuccessModel.fromJson(json);

        // Assert
        expect(model.success, isFalse);
        expect(model.message, equals('Boolean false test'));
      });

      test('should handle empty string message in JSON', () {
        // Arrange
        final json = {'success': true, 'message': ''};

        // Act
        final model = CommonSuccessModel.fromJson(json);

        // Assert
        expect(model.success, isTrue);
        expect(model.message, equals(''));
      });

      test('should handle long message in JSON', () {
        // Arrange
        const longMessage =
            'This is a very long message that contains multiple words and sentences. '
            'It tests the ability of the model to handle lengthy text content without any issues. '
            'The message can contain special characters like @#\$%^&*()_+-=[]{}|;:,.<>?';
        final json = {'success': false, 'message': longMessage};

        // Act
        final model = CommonSuccessModel.fromJson(json);

        // Assert
        expect(model.success, isFalse);
        expect(model.message, equals(longMessage));
      });
    });

    // =============================================================================
    // TO JSON TESTS
    // =============================================================================

    group('toJson', () {
      test('should convert instance with all fields to JSON', () {
        // Arrange
        final model = CommonSuccessModel(success: true, message: 'Conversion successful');

        // Act
        final json = model.toJson();

        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['success'], isTrue);
        expect(json['message'], equals('Conversion successful'));
        expect(json.length, equals(2));
      });

      test('should convert instance with null values to JSON', () {
        // Arrange
        final model = CommonSuccessModel();

        // Act
        final json = model.toJson();

        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['success'], isNull);
        expect(json['message'], isNull);
        expect(json.length, equals(2));
      });

      test('should convert instance with only success to JSON', () {
        // Arrange
        final model = CommonSuccessModel(success: false);

        // Act
        final json = model.toJson();

        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['success'], isFalse);
        expect(json['message'], isNull);
        expect(json.length, equals(2));
      });

      test('should convert instance with only message to JSON', () {
        // Arrange
        final model = CommonSuccessModel(message: 'Only message');

        // Act
        final json = model.toJson();

        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['success'], isNull);
        expect(json['message'], equals('Only message'));
        expect(json.length, equals(2));
      });

      test('should convert instance with empty message to JSON', () {
        // Arrange
        final model = CommonSuccessModel(success: true, message: '');

        // Act
        final json = model.toJson();

        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['success'], isTrue);
        expect(json['message'], equals(''));
        expect(json.length, equals(2));
      });
    });

    // =============================================================================
    // SERIALIZATION ROUND-TRIP TESTS
    // =============================================================================

    group('Serialization Round-trip', () {
      test('should maintain data integrity through JSON round-trip with all fields', () {
        // Arrange
        final originalModel = CommonSuccessModel(success: true, message: 'Round-trip test message');

        // Act
        final json = originalModel.toJson();
        final deserializedModel = CommonSuccessModel.fromJson(json);

        // Assert
        expect(deserializedModel.success, equals(originalModel.success));
        expect(deserializedModel.message, equals(originalModel.message));
      });

      test('should maintain data integrity through JSON round-trip with null values', () {
        // Arrange
        final originalModel = CommonSuccessModel();

        // Act
        final json = originalModel.toJson();
        final deserializedModel = CommonSuccessModel.fromJson(json);

        // Assert
        expect(deserializedModel.success, equals(originalModel.success));
        expect(deserializedModel.message, equals(originalModel.message));
      });

      test('should maintain data integrity through JSON round-trip with false success', () {
        // Arrange
        final originalModel = CommonSuccessModel(success: false, message: 'Failure message');

        // Act
        final json = originalModel.toJson();
        final deserializedModel = CommonSuccessModel.fromJson(json);

        // Assert
        expect(deserializedModel.success, equals(originalModel.success));
        expect(deserializedModel.message, equals(originalModel.message));
      });

      test('should maintain data integrity through multiple round-trips', () {
        // Arrange
        final originalModel = CommonSuccessModel(success: true, message: 'Multiple round-trip test');

        // Act - First round-trip
        final json1 = originalModel.toJson();
        final model1 = CommonSuccessModel.fromJson(json1);

        // Second round-trip
        final json2 = model1.toJson();
        final model2 = CommonSuccessModel.fromJson(json2);

        // Third round-trip
        final json3 = model2.toJson();
        final finalModel = CommonSuccessModel.fromJson(json3);

        // Assert
        expect(finalModel.success, equals(originalModel.success));
        expect(finalModel.message, equals(originalModel.message));
      });
    });

    // =============================================================================
    // EDGE CASES AND ERROR HANDLING TESTS
    // =============================================================================

    group('Edge Cases', () {
      test('should handle special characters in message', () {
        // Arrange
        const specialMessage = 'Special chars: !@#\$%^&*()_+-=[]{}|;:,.<>?/~`"\'\\';
        final model = CommonSuccessModel(success: true, message: specialMessage);

        // Act
        final json = model.toJson();
        final deserializedModel = CommonSuccessModel.fromJson(json);

        // Assert
        expect(deserializedModel.message, equals(specialMessage));
      });

      test('should handle unicode characters in message', () {
        // Arrange
        const unicodeMessage = 'Unicode: 你好 🌟 ñáéíóú àèìòù äëïöü';
        final model = CommonSuccessModel(success: false, message: unicodeMessage);

        // Act
        final json = model.toJson();
        final deserializedModel = CommonSuccessModel.fromJson(json);

        // Assert
        expect(deserializedModel.message, equals(unicodeMessage));
      });

      test('should handle newlines and tabs in message', () {
        // Arrange
        const messageWithWhitespace = 'Line 1\nLine 2\tTabbed\r\nWindows newline';
        final model = CommonSuccessModel(success: true, message: messageWithWhitespace);

        // Act
        final json = model.toJson();
        final deserializedModel = CommonSuccessModel.fromJson(json);

        // Assert
        expect(deserializedModel.message, equals(messageWithWhitespace));
      });
    });

    // =============================================================================
    // PROPERTY ACCESS TESTS
    // =============================================================================

    group('Property Access', () {
      test('should allow modification of success property', () {
        // Arrange
        final model = CommonSuccessModel(success: true);

        // Act
        model.success = false;

        // Assert
        expect(model.success, isFalse);
      });

      test('should allow modification of message property', () {
        // Arrange
        final model = CommonSuccessModel(message: 'Original message');

        // Act
        model.message = 'Modified message';

        // Assert
        expect(model.message, equals('Modified message'));
      });

      test('should allow setting properties to null', () {
        // Arrange
        final model = CommonSuccessModel(success: true, message: 'Some message');

        // Act
        model.success = null;
        model.message = null;

        // Assert
        expect(model.success, isNull);
        expect(model.message, isNull);
      });
    });
  });
}
