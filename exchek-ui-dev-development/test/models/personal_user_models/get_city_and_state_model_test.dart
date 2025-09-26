import 'package:flutter_test/flutter_test.dart';
import 'package:exchek/models/personal_user_models/get_city_and_state_model.dart';

void main() {
  group('GetCityAndStateModel', () {
    // =============================================================================
    // CONSTRUCTOR TESTS
    // =============================================================================

    group('Constructor', () {
      test('should create instance with all required fields', () {
        // Arrange
        final data = Data(city: 'Mumbai', state: 'Maharashtra');

        // Act
        final model = GetCityAndStateModel(success: true, data: data);

        // Assert
        expect(model.success, isTrue);
        expect(model.data, equals(data));
        expect(model.data?.city, equals('Mumbai'));
        expect(model.data?.state, equals('Maharashtra'));
      });

      test('should create instance with false success', () {
        // Arrange
        final data = Data(city: 'Delhi', state: 'Delhi');

        // Act
        final model = GetCityAndStateModel(success: false, data: data);

        // Assert
        expect(model.success, isFalse);
        expect(model.data?.city, equals('Delhi'));
        expect(model.data?.state, equals('Delhi'));
      });
    });

    // =============================================================================
    // FROM JSON TESTS
    // =============================================================================

    group('fromJson', () {
      test('should create instance from complete JSON', () {
        // Arrange
        final json = {
          'success': true,
          'data': {'city': 'Delhi', 'state': 'Delhi'},
        };

        // Act
        final model = GetCityAndStateModel.fromJson(json);

        // Assert
        expect(model.success, isTrue);
        expect(model.data, isNotNull);
        expect(model.data?.city, equals('Delhi'));
        expect(model.data?.state, equals('Delhi'));
      });

      test('should handle various Indian cities and states', () {
        // Arrange
        final testCases = [
          {'city': 'Bangalore', 'state': 'Karnataka'},
          {'city': 'Chennai', 'state': 'Tamil Nadu'},
          {'city': 'Kolkata', 'state': 'West Bengal'},
          {'city': 'Hyderabad', 'state': 'Telangana'},
          {'city': 'Pune', 'state': 'Maharashtra'},
          {'city': 'Ahmedabad', 'state': 'Gujarat'},
          {'city': 'Jaipur', 'state': 'Rajasthan'},
          {'city': 'Lucknow', 'state': 'Uttar Pradesh'},
        ];

        for (final testCase in testCases) {
          final json = {'success': true, 'data': testCase};

          // Act
          final model = GetCityAndStateModel.fromJson(json);

          // Assert
          expect(model.success, isTrue);
          expect(model.data!.city, equals(testCase['city']));
          expect(model.data!.state, equals(testCase['state']));
        }
      });

      test('should handle JSON with special characters in city/state names', () {
        // Arrange
        final json = {
          'success': true,
          'data': {'city': 'Thiruvananthapuram', 'state': 'Kerala'},
        };

        // Act
        final model = GetCityAndStateModel.fromJson(json);

        // Assert
        expect(model.success, isTrue);
        expect(model.data!.city, equals('Thiruvananthapuram'));
        expect(model.data!.state, equals('Kerala'));
      });
    });

    // =============================================================================
    // TO JSON TESTS
    // =============================================================================

    group('toJson', () {
      test('should convert complete model to JSON', () {
        // Arrange
        final data = Data(city: 'Mumbai', state: 'Maharashtra');
        final model = GetCityAndStateModel(success: true, data: data);

        // Act
        final json = model.toJson();

        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['success'], isTrue);
        expect(json['data'], isNotNull);
        expect(json['data']['city'], equals('Mumbai'));
        expect(json['data']['state'], equals('Maharashtra'));
        expect(json.length, equals(2));
      });

      test('should convert model with false success to JSON', () {
        // Arrange
        final data = Data(city: 'Chennai', state: 'Tamil Nadu');
        final model = GetCityAndStateModel(success: false, data: data);

        // Act
        final json = model.toJson();

        // Assert
        expect(json['success'], isFalse);
        expect(json['data'], isNotNull);
        expect(json['data']['city'], equals('Chennai'));
        expect(json['data']['state'], equals('Tamil Nadu'));
        expect(json.length, equals(2));
      });

      test('should maintain correct JSON structure', () {
        // Arrange
        final data = Data(city: 'Kochi', state: 'Kerala');
        final model = GetCityAndStateModel(success: true, data: data);

        // Act
        final json = model.toJson();

        // Assert
        expect(json.keys, containsAll(['success', 'data']));
        expect(json['data'].keys, containsAll(['city', 'state']));
        expect(json['data'].keys.length, equals(2));
      });
    });

    // =============================================================================
    // SERIALIZATION ROUND-TRIP TESTS
    // =============================================================================

    group('Serialization Round-trip', () {
      test('should maintain data integrity through JSON round-trip', () {
        // Arrange
        final data = Data(city: 'Bangalore', state: 'Karnataka');
        final originalModel = GetCityAndStateModel(success: true, data: data);

        // Act
        final json = originalModel.toJson();
        final deserializedModel = GetCityAndStateModel.fromJson(json);

        // Assert
        expect(deserializedModel.success, equals(originalModel.success));
        expect(deserializedModel.data?.city, equals(originalModel.data?.city));
        expect(deserializedModel.data?.state, equals(originalModel.data?.state));
      });
    });
  });

  // =============================================================================
  // DATA CLASS TESTS
  // =============================================================================

  group('Data', () {
    group('Constructor', () {
      test('should create instance with city and state', () {
        // Act
        final data = Data(city: 'Chennai', state: 'Tamil Nadu');

        // Assert
        expect(data.city, equals('Chennai'));
        expect(data.state, equals('Tamil Nadu'));
      });
    });

    group('fromJson', () {
      test('should create instance from complete JSON', () {
        // Arrange
        final json = {'city': 'Hyderabad', 'state': 'Telangana'};

        // Act
        final data = Data.fromJson(json);

        // Assert
        expect(data.city, equals('Hyderabad'));
        expect(data.state, equals('Telangana'));
      });
    });

    group('toJson', () {
      test('should convert complete data to JSON', () {
        // Arrange
        final data = Data(city: 'Kolkata', state: 'West Bengal');

        // Act
        final json = data.toJson();

        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['city'], equals('Kolkata'));
        expect(json['state'], equals('West Bengal'));
        expect(json.length, equals(2));
      });
    });

    group('Serialization Round-trip', () {
      test('should maintain data integrity through JSON round-trip', () {
        // Arrange
        final originalData = Data(city: 'Jaipur', state: 'Rajasthan');

        // Act
        final json = originalData.toJson();
        final deserializedData = Data.fromJson(json);

        // Assert
        expect(deserializedData.city, equals(originalData.city));
        expect(deserializedData.state, equals(originalData.state));
      });
    });
  });

  // =============================================================================
  // EDGE CASES AND ERROR HANDLING TESTS
  // =============================================================================

  group('Edge Cases', () {
    test('should handle special characters in city and state names', () {
      // Arrange
      const specialCity = 'City with special chars: !@#\$%^&*()_+-=[]{}|;:,.<>?';
      const specialState = 'State with special chars: !@#\$%^&*()_+-=[]{}|;:,.<>?';
      final data = Data(city: specialCity, state: specialState);

      // Act
      final json = data.toJson();
      final deserializedData = Data.fromJson(json);

      // Assert
      expect(deserializedData.city, equals(specialCity));
      expect(deserializedData.state, equals(specialState));
    });

    test('should handle unicode characters in city and state names', () {
      // Arrange
      const unicodeCity = 'City unicode: 你好 🌟 ñáéíóú àèìòù äëïöü';
      const unicodeState = 'State unicode: 你好 🌟 ñáéíóú àèìòù äëïöü';
      final data = Data(city: unicodeCity, state: unicodeState);

      // Act
      final json = data.toJson();
      final deserializedData = Data.fromJson(json);

      // Assert
      expect(deserializedData.city, equals(unicodeCity));
      expect(deserializedData.state, equals(unicodeState));
    });

    test('should handle very long city and state names', () {
      // Arrange
      final longCity = 'A' * 1000; // 1000 character city name
      final longState = 'B' * 1000; // 1000 character state name
      final data = Data(city: longCity, state: longState);

      // Act
      final json = data.toJson();
      final deserializedData = Data.fromJson(json);

      // Assert
      expect(deserializedData.city, equals(longCity));
      expect(deserializedData.state, equals(longState));
      expect(deserializedData.city?.length, equals(1000));
      expect(deserializedData.state?.length, equals(1000));
    });

    test('should handle empty string values', () {
      // Arrange
      final data = Data(city: '', state: '');

      // Act
      final json = data.toJson();
      final deserializedData = Data.fromJson(json);

      // Assert
      expect(deserializedData.city, equals(''));
      expect(deserializedData.state, equals(''));
    });

    test('should handle whitespace-only values', () {
      // Arrange
      final data = Data(city: '   ', state: '\t\n\r');

      // Act
      final json = data.toJson();
      final deserializedData = Data.fromJson(json);

      // Assert
      expect(deserializedData.city, equals('   '));
      expect(deserializedData.state, equals('\t\n\r'));
    });
  });

  // =============================================================================
  // REAL-WORLD SCENARIO TESTS
  // =============================================================================

  group('Real-world Scenarios', () {
    test('should handle typical success response for pincode lookup', () {
      // Arrange
      final json = {
        'success': true,
        'data': {'city': 'Mumbai', 'state': 'Maharashtra'},
      };

      // Act
      final model = GetCityAndStateModel.fromJson(json);

      // Assert
      expect(model.success, isTrue);
      expect(model.data!.city, equals('Mumbai'));
      expect(model.data!.state, equals('Maharashtra'));
    });

    test('should handle error response for invalid pincode', () {
      // Arrange
      final json = {
        'success': false,
        'data': {'city': '', 'state': ''},
      };

      // Act
      final model = GetCityAndStateModel.fromJson(json);

      // Assert
      expect(model.success, isFalse);
      expect(model.data, isNotNull);
      expect(model.data?.city, equals(''));
      expect(model.data?.state, equals(''));
    });

    test('should handle response for Union Territory', () {
      // Arrange
      final json = {
        'success': true,
        'data': {'city': 'New Delhi', 'state': 'Delhi'},
      };

      // Act
      final model = GetCityAndStateModel.fromJson(json);

      // Assert
      expect(model.success, isTrue);
      expect(model.data?.city, equals('New Delhi'));
      expect(model.data?.state, equals('Delhi'));
    });

    test('should handle response for multiple cities in same state', () {
      // Arrange
      final testCases = [
        {'city': 'Mumbai', 'state': 'Maharashtra'},
        {'city': 'Pune', 'state': 'Maharashtra'},
        {'city': 'Nagpur', 'state': 'Maharashtra'},
        {'city': 'Nashik', 'state': 'Maharashtra'},
      ];

      for (final testCase in testCases) {
        final json = {'success': true, 'data': testCase};

        // Act
        final model = GetCityAndStateModel.fromJson(json);

        // Assert
        expect(model.success, isTrue);
        expect(model.data?.city, equals(testCase['city']));
        expect(model.data?.state, equals('Maharashtra'));
      }
    });
  });
}
