import 'package:flutter_test/flutter_test.dart';
import 'package:exchek/models/personal_user_models/get_pan_detail_model.dart';

void main() {
  group('GetPanDetailModel Tests', () {
    test('should parse JSON correctly with valid data', () {
      // Arrange
      final json = {
        'success': true,
        'data': {
          '@entity': 'entity',
          'pan': 'ABCDE1234F',
          'full_name': 'Test User',
          'status': 'Active',
          'category': 'Individual',
          'name_information': {'pan_name_cleaned': 'Test User'},
        },
      };

      // Act
      final model = GetPanDetailModel.fromJson(json);

      // Assert
      expect(model.success, isTrue);
      expect(model.data?.entity, equals('entity'));
      expect(model.data?.pan, equals('ABCDE1234F'));
      expect(model.data?.fullName, equals('Test User'));
      expect(model.data?.status, equals('Active'));
      expect(model.data?.category, equals('Individual'));
      expect(model.data?.nameInformation?.panNameCleaned, equals('Test User'));
    });

    test('should parse JSON correctly with false success', () {
      // Arrange
      final json = {
        'success': false,
        'data': {
          '@entity': 'entity',
          'pan': 'INVALID123',
          'full_name': 'Invalid User',
          'status': 'Inactive',
          'category': 'Invalid',
          'name_information': {'pan_name_cleaned': 'Invalid User'},
        },
      };

      // Act
      final model = GetPanDetailModel.fromJson(json);

      // Assert
      expect(model.success, isFalse);
      expect(model.data?.entity, equals('entity'));
      expect(model.data?.pan, equals('INVALID123'));
      expect(model.data?.fullName, equals('Invalid User'));
      expect(model.data?.status, equals('Inactive'));
      expect(model.data?.category, equals('Invalid'));
      expect(model.data?.nameInformation?.panNameCleaned, equals('Invalid User'));
    });

    test('should convert to JSON correctly', () {
      // Arrange
      final nameInfo = NameInformation(panNameCleaned: 'Test User');
      final data = Data(
        entity: 'entity',
        pan: 'ABCDE1234F',
        fullName: 'Test User',
        status: 'Active',
        category: 'Individual',
        nameInformation: nameInfo,
      );
      final model = GetPanDetailModel(success: true, data: data);

      // Act
      final json = model.toJson();

      // Assert
      expect(json['success'], isTrue);
      expect(json['data']['@entity'], equals('entity'));
      expect(json['data']['pan'], equals('ABCDE1234F'));
      expect(json['data']['full_name'], equals('Test User'));
      expect(json['data']['status'], equals('Active'));
      expect(json['data']['category'], equals('Individual'));
      expect(json['data']['name_information']['pan_name_cleaned'], equals('Test User'));
    });

    test('Data class should parse JSON correctly', () {
      // Arrange
      final json = {
        '@entity': 'entity',
        'pan': 'ABCDE1234F',
        'full_name': 'Test User',
        'status': 'Active',
        'category': 'Individual',
        'name_information': {'pan_name_cleaned': 'Test User'},
      };

      // Act
      final data = Data.fromJson(json);

      // Assert
      expect(data.entity, equals('entity'));
      expect(data.pan, equals('ABCDE1234F'));
      expect(data.fullName, equals('Test User'));
      expect(data.status, equals('Active'));
      expect(data.category, equals('Individual'));
      expect(data.nameInformation?.panNameCleaned, equals('Test User'));
    });

    test('NameInformation class should parse JSON correctly', () {
      // Arrange
      final json = {'pan_name_cleaned': 'Test User'};

      // Act
      final nameInfo = NameInformation.fromJson(json);

      // Assert
      expect(nameInfo.panNameCleaned, equals('Test User'));
    });

    test('NameInformation class should convert to JSON correctly', () {
      // Arrange
      final nameInfo = NameInformation(panNameCleaned: 'Test User');

      // Act
      final json = nameInfo.toJson();

      // Assert
      expect(json['pan_name_cleaned'], equals('Test User'));
    });

    test('should handle empty or null values gracefully', () {
      // Arrange
      final json = {
        'success': true,
        'data': {
          '@entity': '',
          'pan': '',
          'full_name': '',
          'status': '',
          'category': '',
          'name_information': {'pan_name_cleaned': ''},
        },
      };

      // Act
      final model = GetPanDetailModel.fromJson(json);

      // Assert
      expect(model.success, isTrue);
      expect(model.data?.entity, equals(''));
      expect(model.data?.pan, equals(''));
      expect(model.data?.fullName, equals(''));
      expect(model.data?.status, equals(''));
      expect(model.data?.category, equals(''));
      expect(model.data?.nameInformation?.panNameCleaned, equals(''));
    });

    test('should handle different PAN formats', () {
      // Arrange
      final testCases = ['ABCDE1234F', 'XYZPQ5678G', 'MNOPQ9876H'];

      for (final panNumber in testCases) {
        final json = {
          'success': true,
          'data': {
            '@entity': 'entity',
            'pan': panNumber,
            'full_name': 'Test User',
            'status': 'Active',
            'category': 'Individual',
            'name_information': {'pan_name_cleaned': 'Test User'},
          },
        };

        // Act
        final model = GetPanDetailModel.fromJson(json);

        // Assert
        expect(model.data?.pan, equals(panNumber));
      }
    });

    test('should handle different status values', () {
      // Arrange
      final statusValues = ['Active', 'Inactive', 'Pending', 'Verified'];

      for (final status in statusValues) {
        final json = {
          'success': true,
          'data': {
            '@entity': 'entity',
            'pan': 'ABCDE1234F',
            'full_name': 'Test User',
            'status': status,
            'category': 'Individual',
            'name_information': {'pan_name_cleaned': 'Test User'},
          },
        };

        // Act
        final model = GetPanDetailModel.fromJson(json);

        // Assert
        expect(model.data?.status, equals(status));
      }
    });

    test('should handle different category values', () {
      // Arrange
      final categoryValues = ['Individual', 'Company', 'Partnership', 'Trust'];

      for (final category in categoryValues) {
        final json = {
          'success': true,
          'data': {
            '@entity': 'entity',
            'pan': 'ABCDE1234F',
            'full_name': 'Test User',
            'status': 'Active',
            'category': category,
            'name_information': {'pan_name_cleaned': 'Test User'},
          },
        };

        // Act
        final model = GetPanDetailModel.fromJson(json);

        // Assert
        expect(model.data?.category, equals(category));
      }
    });
  });
}
