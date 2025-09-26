import 'package:flutter_test/flutter_test.dart';
import 'package:exchek/models/personal_user_models/get_currency_model.dart';

void main() {
  group('GetCurrencyOptionModel', () {
    // =============================================================================
    // CONSTRUCTOR TESTS
    // =============================================================================

    group('Constructor', () {
      test('should create instance with all required fields', () {
        // Arrange
        final data = Data(
          id: 1,
          estimatedMonthlyVolume: ['0-1000', '1000-5000', '5000-10000'],
          multicurrency: ['USD', 'EUR', 'GBP', 'INR'],
          createdAt: '2023-01-01T00:00:00Z',
          updatedAt: '2023-01-02T00:00:00Z',
        );

        // Act
        final model = GetCurrencyOptionModel(success: true, data: data);

        // Assert
        expect(model.success, isTrue);
        expect(model.data, equals(data));
        expect(model.data!.id, equals(1));
        expect(model.data!.estimatedMonthlyVolume, hasLength(3));
        expect(model.data!.multicurrency, hasLength(4));
        expect(model.data!.multicurrency, contains('USD'));
        expect(model.data!.multicurrency, contains('EUR'));
      });

      test('should create instance with null data', () {
        // Act
        final model = GetCurrencyOptionModel(success: false, data: null);

        // Assert
        expect(model.success, isFalse);
        expect(model.data, isNull);
      });

      test('should create instance with default null values', () {
        // Act
        final model = GetCurrencyOptionModel();

        // Assert
        expect(model.success, isNull);
        expect(model.data, isNull);
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
          'data': {
            'id': 1,
            'estimated_monthly_volume': ['0-1000', '1000-5000', '5000-10000', '10000+'],
            'multicurrency': ['USD', 'EUR', 'GBP', 'JPY', 'INR', 'CAD', 'AUD'],
            'created_at': '2023-01-01T00:00:00Z',
            'updated_at': '2023-01-02T00:00:00Z',
          },
        };

        // Act
        final model = GetCurrencyOptionModel.fromJson(json);

        // Assert
        expect(model.success, isTrue);
        expect(model.data, isNotNull);
        expect(model.data!.id, equals(1));
        expect(model.data!.estimatedMonthlyVolume, hasLength(4));
        expect(model.data!.estimatedMonthlyVolume, contains('0-1000'));
        expect(model.data!.estimatedMonthlyVolume, contains('10000+'));
        expect(model.data!.multicurrency, hasLength(7));
        expect(model.data!.multicurrency, contains('USD'));
        expect(model.data!.multicurrency, contains('INR'));
        expect(model.data!.createdAt, equals('2023-01-01T00:00:00Z'));
        expect(model.data!.updatedAt, equals('2023-01-02T00:00:00Z'));
      });

      test('should create instance from JSON with empty arrays', () {
        // Arrange
        final json = {
          'success': true,
          'data': {
            'id': 2,
            'estimated_monthly_volume': [],
            'multicurrency': [],
            'created_at': '2023-01-01T00:00:00Z',
            'updated_at': '2023-01-02T00:00:00Z',
          },
        };

        // Act
        final model = GetCurrencyOptionModel.fromJson(json);

        // Assert
        expect(model.success, isTrue);
        expect(model.data, isNotNull);
        expect(model.data!.id, equals(2));
        expect(model.data!.estimatedMonthlyVolume, isEmpty);
        expect(model.data!.multicurrency, isEmpty);
      });

      test('should create instance from JSON without data', () {
        // Arrange
        final json = {'success': false};

        // Act
        final model = GetCurrencyOptionModel.fromJson(json);

        // Assert
        expect(model.success, isFalse);
        expect(model.data, isNull);
      });

      test('should create instance from JSON with null data', () {
        // Arrange
        final json = {'success': true, 'data': null};

        // Act
        final model = GetCurrencyOptionModel.fromJson(json);

        // Assert
        expect(model.success, isTrue);
        expect(model.data, isNull);
      });

      test('should create instance from empty JSON', () {
        // Arrange
        final json = <String, dynamic>{};

        // Act
        final model = GetCurrencyOptionModel.fromJson(json);

        // Assert
        expect(model.success, isNull);
        expect(model.data, isNull);
      });

      test('should handle major world currencies', () {
        // Arrange
        final json = {
          'success': true,
          'data': {
            'id': 4,
            'estimated_monthly_volume': ['1000-5000'],
            'multicurrency': ['USD', 'EUR', 'GBP', 'JPY', 'CHF', 'CAD', 'AUD', 'CNY', 'INR', 'SGD'],
            'created_at': '2023-01-01T00:00:00Z',
            'updated_at': '2023-01-02T00:00:00Z',
          },
        };

        // Act
        final model = GetCurrencyOptionModel.fromJson(json);

        // Assert
        expect(model.success, isTrue);
        expect(model.data!.multicurrency, hasLength(10));

        final majorCurrencies = ['USD', 'EUR', 'GBP', 'JPY', 'CHF', 'CAD', 'AUD', 'CNY', 'INR', 'SGD'];
        for (final currency in majorCurrencies) {
          expect(model.data!.multicurrency, contains(currency));
        }
      });
    });

    // =============================================================================
    // TO JSON TESTS
    // =============================================================================

    group('toJson', () {
      test('should convert complete model to JSON', () {
        // Arrange
        final data = Data(
          id: 1,
          estimatedMonthlyVolume: ['0-1000', '1000-5000', '5000+'],
          multicurrency: ['USD', 'EUR', 'GBP', 'INR'],
          createdAt: '2023-01-01T00:00:00Z',
          updatedAt: '2023-01-02T00:00:00Z',
        );
        final model = GetCurrencyOptionModel(success: true, data: data);

        // Act
        final json = model.toJson();

        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['success'], isTrue);
        expect(json['data'], isNotNull);
        expect(json['data']['id'], equals(1));
        expect(json['data']['estimated_monthly_volume'], hasLength(3));
        expect(json['data']['estimated_monthly_volume'], contains('0-1000'));
        expect(json['data']['multicurrency'], hasLength(4));
        expect(json['data']['multicurrency'], contains('USD'));
        expect(json['data']['created_at'], equals('2023-01-01T00:00:00Z'));
        expect(json['data']['updated_at'], equals('2023-01-02T00:00:00Z'));
        expect(json.length, equals(2));
      });

      test('should convert model without data to JSON', () {
        // Arrange
        final model = GetCurrencyOptionModel(success: false, data: null);

        // Act
        final json = model.toJson();

        // Assert
        expect(json['success'], isFalse);
        expect(json.containsKey('data'), isFalse);
        expect(json.length, equals(1));
      });

      test('should convert model with empty arrays to JSON', () {
        // Arrange
        final data = Data(
          id: 2,
          estimatedMonthlyVolume: [],
          multicurrency: [],
          createdAt: '2023-01-01T00:00:00Z',
          updatedAt: '2023-01-02T00:00:00Z',
        );
        final model = GetCurrencyOptionModel(success: true, data: data);

        // Act
        final json = model.toJson();

        // Assert
        expect(json['success'], isTrue);
        expect(json['data']['estimated_monthly_volume'], isEmpty);
        expect(json['data']['multicurrency'], isEmpty);
      });
    });

    // =============================================================================
    // SERIALIZATION ROUND-TRIP TESTS
    // =============================================================================

    group('Serialization Round-trip', () {
      test('should maintain data integrity through JSON round-trip', () {
        // Arrange
        final data = Data(
          id: 1,
          estimatedMonthlyVolume: ['0-1000', '1000-5000', '5000-10000', '10000+'],
          multicurrency: ['USD', 'EUR', 'GBP', 'JPY', 'INR'],
          createdAt: '2023-01-01T00:00:00Z',
          updatedAt: '2023-01-02T00:00:00Z',
        );
        final originalModel = GetCurrencyOptionModel(success: true, data: data);

        // Act
        final json = originalModel.toJson();
        final deserializedModel = GetCurrencyOptionModel.fromJson(json);

        // Assert
        expect(deserializedModel.success, equals(originalModel.success));
        expect(deserializedModel.data!.id, equals(originalModel.data!.id));
        expect(deserializedModel.data!.estimatedMonthlyVolume, equals(originalModel.data!.estimatedMonthlyVolume));
        expect(deserializedModel.data!.multicurrency, equals(originalModel.data!.multicurrency));
        expect(deserializedModel.data!.createdAt, equals(originalModel.data!.createdAt));
        expect(deserializedModel.data!.updatedAt, equals(originalModel.data!.updatedAt));
      });
    });
  });

  // =============================================================================
  // DATA CLASS TESTS
  // =============================================================================

  group('Data', () {
    group('Constructor', () {
      test('should create instance with all fields', () {
        // Act
        final data = Data(
          id: 1,
          estimatedMonthlyVolume: ['0-1000', '1000-5000'],
          multicurrency: ['USD', 'EUR'],
          createdAt: '2023-01-01T00:00:00Z',
          updatedAt: '2023-01-02T00:00:00Z',
        );

        // Assert
        expect(data.id, equals(1));
        expect(data.estimatedMonthlyVolume, hasLength(2));
        expect(data.multicurrency, hasLength(2));
        expect(data.createdAt, equals('2023-01-01T00:00:00Z'));
        expect(data.updatedAt, equals('2023-01-02T00:00:00Z'));
      });

      test('should create instance with null values', () {
        // Act
        final data = Data();

        // Assert
        expect(data.id, isNull);
        expect(data.estimatedMonthlyVolume, isNull);
        expect(data.multicurrency, isNull);
        expect(data.createdAt, isNull);
        expect(data.updatedAt, isNull);
      });
    });

    group('fromJson', () {
      test('should create instance from complete JSON', () {
        // Arrange
        final json = {
          'id': 5,
          'estimated_monthly_volume': ['500-1000', '1000-2500'],
          'multicurrency': ['USD', 'EUR', 'GBP'],
          'created_at': '2023-01-01T00:00:00Z',
          'updated_at': '2023-01-02T00:00:00Z',
        };

        // Act
        final data = Data.fromJson(json);

        // Assert
        expect(data.id, equals(5));
        expect(data.estimatedMonthlyVolume, hasLength(2));
        expect(data.estimatedMonthlyVolume, contains('500-1000'));
        expect(data.multicurrency, hasLength(3));
        expect(data.multicurrency, contains('USD'));
        expect(data.createdAt, equals('2023-01-01T00:00:00Z'));
        expect(data.updatedAt, equals('2023-01-02T00:00:00Z'));
      });

      test('should create instance from JSON with empty arrays', () {
        // Arrange
        final json = {
          'id': null,
          'estimated_monthly_volume': [],
          'multicurrency': [],
          'created_at': null,
          'updated_at': null,
        };

        // Act
        final data = Data.fromJson(json);

        // Assert
        expect(data.id, isNull);
        expect(data.estimatedMonthlyVolume, isEmpty);
        expect(data.multicurrency, isEmpty);
        expect(data.createdAt, isNull);
        expect(data.updatedAt, isNull);
      });
    });

    group('toJson', () {
      test('should convert complete data to JSON', () {
        // Arrange
        final data = Data(
          id: 3,
          estimatedMonthlyVolume: ['1000-5000', '5000+'],
          multicurrency: ['USD', 'EUR', 'INR'],
          createdAt: '2023-01-01T00:00:00Z',
          updatedAt: '2023-01-02T00:00:00Z',
        );

        // Act
        final json = data.toJson();

        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['id'], equals(3));
        expect(json['estimated_monthly_volume'], hasLength(2));
        expect(json['multicurrency'], hasLength(3));
        expect(json['created_at'], equals('2023-01-01T00:00:00Z'));
        expect(json['updated_at'], equals('2023-01-02T00:00:00Z'));
        expect(json.length, equals(5));
      });

      test('should convert data with null values to JSON', () {
        // Arrange
        final data = Data();

        // Act
        final json = data.toJson();

        // Assert
        expect(json['id'], isNull);
        expect(json['estimated_monthly_volume'], isNull);
        expect(json['multicurrency'], isNull);
        expect(json['created_at'], isNull);
        expect(json['updated_at'], isNull);
        expect(json.length, equals(5));
      });
    });
  });
}
