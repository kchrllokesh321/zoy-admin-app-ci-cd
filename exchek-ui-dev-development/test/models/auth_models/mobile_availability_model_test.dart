import 'package:flutter_test/flutter_test.dart';
import 'package:exchek/models/auth_models/mobile_availabilty_model.dart';

void main() {
  group('MobileAvailabilityModel', () {
    // =============================================================================
    // CONSTRUCTOR TESTS
    // =============================================================================

    group('Constructor', () {
      test('should create instance with default null values', () {
        // Act
        final model = MobileAvailabilityModel();

        // Assert
        expect(model.success, isNull);
        expect(model.data, isNull);
      });

      test('should create instance with provided values', () {
        // Arrange
        final data = Data(exists: true);

        // Act
        final model = MobileAvailabilityModel(success: true, data: data);

        // Assert
        expect(model.success, isTrue);
        expect(model.data, equals(data));
      });

      test('should create instance with false success', () {
        // Arrange
        final data = Data(exists: false);

        // Act
        final model = MobileAvailabilityModel(success: false, data: data);

        // Assert
        expect(model.success, isFalse);
        expect(model.data, equals(data));
        expect(model.data!.exists, isFalse);
      });
    });

    // =============================================================================
    // FROM JSON TESTS
    // =============================================================================

    group('fromJson', () {
      test('should create instance from complete JSON with exists true', () {
        // Arrange
        final json = {
          'success': true,
          'data': {
            'exists': true,
          }
        };

        // Act
        final model = MobileAvailabilityModel.fromJson(json);

        // Assert
        expect(model.success, isTrue);
        expect(model.data, isNotNull);
        expect(model.data!.exists, isTrue);
      });

      test('should create instance from complete JSON with exists false', () {
        // Arrange
        final json = {
          'success': true,
          'data': {
            'exists': false,
          }
        };

        // Act
        final model = MobileAvailabilityModel.fromJson(json);

        // Assert
        expect(model.success, isTrue);
        expect(model.data, isNotNull);
        expect(model.data!.exists, isFalse);
      });

      test('should create instance from JSON without data', () {
        // Arrange
        final json = {
          'success': false,
        };

        // Act
        final model = MobileAvailabilityModel.fromJson(json);

        // Assert
        expect(model.success, isFalse);
        expect(model.data, isNull);
      });

      test('should create instance from JSON with null data', () {
        // Arrange
        final json = {
          'success': true,
          'data': null,
        };

        // Act
        final model = MobileAvailabilityModel.fromJson(json);

        // Assert
        expect(model.success, isTrue);
        expect(model.data, isNull);
      });

      test('should create instance from empty JSON', () {
        // Arrange
        final json = <String, dynamic>{};

        // Act
        final model = MobileAvailabilityModel.fromJson(json);

        // Assert
        expect(model.success, isNull);
        expect(model.data, isNull);
      });

      test('should handle null values in JSON', () {
        // Arrange
        final json = {
          'success': null,
          'data': null,
        };

        // Act
        final model = MobileAvailabilityModel.fromJson(json);

        // Assert
        expect(model.success, isNull);
        expect(model.data, isNull);
      });
    });

    // =============================================================================
    // TO JSON TESTS
    // =============================================================================

    group('toJson', () {
      test('should convert complete model to JSON', () {
        // Arrange
        final data = Data(exists: true);
        final model = MobileAvailabilityModel(success: true, data: data);

        // Act
        final json = model.toJson();

        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['success'], isTrue);
        expect(json['data'], isNotNull);
        expect(json['data']['exists'], isTrue);
        expect(json.length, equals(2));
      });

      test('should convert model with false exists to JSON', () {
        // Arrange
        final data = Data(exists: false);
        final model = MobileAvailabilityModel(success: true, data: data);

        // Act
        final json = model.toJson();

        // Assert
        expect(json['success'], isTrue);
        expect(json['data'], isNotNull);
        expect(json['data']['exists'], isFalse);
      });

      test('should convert model without data to JSON', () {
        // Arrange
        final model = MobileAvailabilityModel(success: false);

        // Act
        final json = model.toJson();

        // Assert
        expect(json['success'], isFalse);
        expect(json.containsKey('data'), isFalse);
        expect(json.length, equals(1));
      });

      test('should convert null model to JSON', () {
        // Arrange
        final model = MobileAvailabilityModel();

        // Act
        final json = model.toJson();

        // Assert
        expect(json['success'], isNull);
        expect(json.containsKey('data'), isFalse);
        expect(json.length, equals(1));
      });

      test('should convert model with null data to JSON', () {
        // Arrange
        final model = MobileAvailabilityModel(success: true, data: null);

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
      test('should maintain data integrity through JSON round-trip with exists true', () {
        // Arrange
        final data = Data(exists: true);
        final originalModel = MobileAvailabilityModel(success: true, data: data);

        // Act
        final json = originalModel.toJson();
        final deserializedModel = MobileAvailabilityModel.fromJson(json);

        // Assert
        expect(deserializedModel.success, equals(originalModel.success));
        expect(deserializedModel.data!.exists, equals(originalModel.data!.exists));
      });

      test('should maintain data integrity through JSON round-trip with exists false', () {
        // Arrange
        final data = Data(exists: false);
        final originalModel = MobileAvailabilityModel(success: false, data: data);

        // Act
        final json = originalModel.toJson();
        final deserializedModel = MobileAvailabilityModel.fromJson(json);

        // Assert
        expect(deserializedModel.success, equals(originalModel.success));
        expect(deserializedModel.data!.exists, equals(originalModel.data!.exists));
      });

      test('should maintain data integrity through JSON round-trip with null values', () {
        // Arrange
        final originalModel = MobileAvailabilityModel();

        // Act
        final json = originalModel.toJson();
        final deserializedModel = MobileAvailabilityModel.fromJson(json);

        // Assert
        expect(deserializedModel.success, equals(originalModel.success));
        expect(deserializedModel.data, equals(originalModel.data));
      });

      test('should maintain data integrity through multiple round-trips', () {
        // Arrange
        final data = Data(exists: true);
        final originalModel = MobileAvailabilityModel(success: true, data: data);

        // Act - First round-trip
        final json1 = originalModel.toJson();
        final model1 = MobileAvailabilityModel.fromJson(json1);
        
        // Second round-trip
        final json2 = model1.toJson();
        final model2 = MobileAvailabilityModel.fromJson(json2);
        
        // Third round-trip
        final json3 = model2.toJson();
        final finalModel = MobileAvailabilityModel.fromJson(json3);

        // Assert
        expect(finalModel.success, equals(originalModel.success));
        expect(finalModel.data!.exists, equals(originalModel.data!.exists));
      });
    });
  });

  // =============================================================================
  // DATA CLASS TESTS
  // =============================================================================

  group('Data', () {
    group('Constructor', () {
      test('should create instance with default null values', () {
        // Act
        final data = Data();

        // Assert
        expect(data.exists, isNull);
      });

      test('should create instance with exists true', () {
        // Act
        final data = Data(exists: true);

        // Assert
        expect(data.exists, isTrue);
      });

      test('should create instance with exists false', () {
        // Act
        final data = Data(exists: false);

        // Assert
        expect(data.exists, isFalse);
      });
    });

    group('fromJson', () {
      test('should create instance from JSON with exists true', () {
        // Arrange
        final json = {
          'exists': true,
        };

        // Act
        final data = Data.fromJson(json);

        // Assert
        expect(data.exists, isTrue);
      });

      test('should create instance from JSON with exists false', () {
        // Arrange
        final json = {
          'exists': false,
        };

        // Act
        final data = Data.fromJson(json);

        // Assert
        expect(data.exists, isFalse);
      });

      test('should create instance from JSON with null exists', () {
        // Arrange
        final json = {
          'exists': null,
        };

        // Act
        final data = Data.fromJson(json);

        // Assert
        expect(data.exists, isNull);
      });

      test('should create instance from empty JSON', () {
        // Arrange
        final json = <String, dynamic>{};

        // Act
        final data = Data.fromJson(json);

        // Assert
        expect(data.exists, isNull);
      });
    });

    group('toJson', () {
      test('should convert data with exists true to JSON', () {
        // Arrange
        final data = Data(exists: true);

        // Act
        final json = data.toJson();

        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['exists'], isTrue);
        expect(json.length, equals(1));
      });

      test('should convert data with exists false to JSON', () {
        // Arrange
        final data = Data(exists: false);

        // Act
        final json = data.toJson();

        // Assert
        expect(json['exists'], isFalse);
        expect(json.length, equals(1));
      });

      test('should convert data with null exists to JSON', () {
        // Arrange
        final data = Data();

        // Act
        final json = data.toJson();

        // Assert
        expect(json['exists'], isNull);
        expect(json.length, equals(1));
      });
    });

    group('Serialization Round-trip', () {
      test('should maintain data integrity through JSON round-trip with exists true', () {
        // Arrange
        final originalData = Data(exists: true);

        // Act
        final json = originalData.toJson();
        final deserializedData = Data.fromJson(json);

        // Assert
        expect(deserializedData.exists, equals(originalData.exists));
      });

      test('should maintain data integrity through JSON round-trip with exists false', () {
        // Arrange
        final originalData = Data(exists: false);

        // Act
        final json = originalData.toJson();
        final deserializedData = Data.fromJson(json);

        // Assert
        expect(deserializedData.exists, equals(originalData.exists));
      });

      test('should maintain data integrity through JSON round-trip with null exists', () {
        // Arrange
        final originalData = Data();

        // Act
        final json = originalData.toJson();
        final deserializedData = Data.fromJson(json);

        // Assert
        expect(deserializedData.exists, equals(originalData.exists));
      });
    });
  });

  // =============================================================================
  // EDGE CASES AND ERROR HANDLING TESTS
  // =============================================================================

  group('Edge Cases', () {
    test('should handle property modification after creation', () {
      // Arrange
      final model = MobileAvailabilityModel(success: true);

      // Act
      model.success = false;
      model.data = Data(exists: true);

      // Assert
      expect(model.success, isFalse);
      expect(model.data, isNotNull);
      expect(model.data!.exists, isTrue);
    });

    test('should handle data property modification', () {
      // Arrange
      final data = Data(exists: true);

      // Act
      data.exists = false;

      // Assert
      expect(data.exists, isFalse);
    });

    test('should handle setting properties to null', () {
      // Arrange
      final data = Data(exists: true);
      final model = MobileAvailabilityModel(success: true, data: data);

      // Act
      model.success = null;
      model.data = null;
      data.exists = null;

      // Assert
      expect(model.success, isNull);
      expect(model.data, isNull);
      expect(data.exists, isNull);
    });
  });
}
