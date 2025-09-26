import 'package:flutter_test/flutter_test.dart';
import 'package:exchek/models/personal_user_models/get_option_model.dart';

void main() {
  group('GetDropdownOptionModel', () {
    // =============================================================================
    // CONSTRUCTOR TESTS
    // =============================================================================

    group('Constructor', () {
      test('should create instance with all fields', () {
        // Arrange
        final personal = Personal(freelancer: ['Web Development', 'Graphic Design']);
        final business = Business(
          exportOfGoods: ['Electronics', 'Textiles'],
          exportOfGoodsServices: ['IT Services', 'Consulting'],
          exportOfServices: ['Software Development', 'Digital Marketing'],
        );
        final data = Data(personal: personal, business: business);

        // Act
        final model = GetDropdownOptionModel(success: true, data: data);

        // Assert
        expect(model.success, isTrue);
        expect(model.data, equals(data));
        expect(model.data!.personal, equals(personal));
        expect(model.data!.business, equals(business));
      });

      test('should create instance with null values', () {
        // Act
        final model = GetDropdownOptionModel();

        // Assert
        expect(model.success, isNull);
        expect(model.data, isNull);
      });

      test('should create instance with false success and null data', () {
        // Act
        final model = GetDropdownOptionModel(success: false, data: null);

        // Assert
        expect(model.success, isFalse);
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
            'Personal': {
              'Freelancer': ['Web Development', 'Mobile App Development', 'Graphic Design', 'Content Writing']
            },
            'Business': {
              'Export of Goods': ['Electronics', 'Textiles', 'Machinery', 'Chemicals'],
              'Export of Goods & Services': ['IT Services', 'Consulting', 'Engineering Services'],
              'Export of Services': ['Software Development', 'Digital Marketing', 'Financial Services']
            }
          }
        };

        // Act
        final model = GetDropdownOptionModel.fromJson(json);

        // Assert
        expect(model.success, isTrue);
        expect(model.data, isNotNull);
        expect(model.data!.personal, isNotNull);
        expect(model.data!.business, isNotNull);
        expect(model.data!.personal!.freelancer, hasLength(4));
        expect(model.data!.personal!.freelancer, contains('Web Development'));
        expect(model.data!.business!.exportOfGoods, hasLength(4));
        expect(model.data!.business!.exportOfGoods, contains('Electronics'));
        expect(model.data!.business!.exportOfGoodsServices, hasLength(3));
        expect(model.data!.business!.exportOfServices, hasLength(3));
      });

      test('should create instance from JSON with only Personal data', () {
        // Arrange
        final json = {
          'success': true,
          'data': {
            'Personal': {
              'Freelancer': ['Consulting', 'Training']
            }
          }
        };

        // Act
        final model = GetDropdownOptionModel.fromJson(json);

        // Assert
        expect(model.success, isTrue);
        expect(model.data!.personal, isNotNull);
        expect(model.data!.personal!.freelancer, hasLength(2));
        expect(model.data!.personal!.freelancer, contains('Consulting'));
        expect(model.data!.business, isNull);
      });

      test('should create instance from JSON with only Business data', () {
        // Arrange
        final json = {
          'success': true,
          'data': {
            'Business': {
              'Export of Goods': ['Pharmaceuticals'],
              'Export of Goods & Services': ['Healthcare Services'],
              'Export of Services': ['Medical Tourism']
            }
          }
        };

        // Act
        final model = GetDropdownOptionModel.fromJson(json);

        // Assert
        expect(model.success, isTrue);
        expect(model.data!.business, isNotNull);
        expect(model.data!.business!.exportOfGoods, hasLength(1));
        expect(model.data!.business!.exportOfGoods, contains('Pharmaceuticals'));
        expect(model.data!.personal, isNull);
      });

      test('should create instance from JSON without data', () {
        // Arrange
        final json = {
          'success': false,
        };

        // Act
        final model = GetDropdownOptionModel.fromJson(json);

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
        final model = GetDropdownOptionModel.fromJson(json);

        // Assert
        expect(model.success, isTrue);
        expect(model.data, isNull);
      });

      test('should create instance from empty JSON', () {
        // Arrange
        final json = <String, dynamic>{};

        // Act
        final model = GetDropdownOptionModel.fromJson(json);

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
        final personal = Personal(freelancer: ['Web Development', 'Design']);
        final business = Business(
          exportOfGoods: ['Electronics'],
          exportOfGoodsServices: ['IT Services'],
          exportOfServices: ['Software Development'],
        );
        final data = Data(personal: personal, business: business);
        final model = GetDropdownOptionModel(success: true, data: data);

        // Act
        final json = model.toJson();

        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['success'], isTrue);
        expect(json['data'], isNotNull);
        expect(json['data']['Personal'], isNotNull);
        expect(json['data']['Business'], isNotNull);
        expect(json['data']['Personal']['Freelancer'], hasLength(2));
        expect(json['data']['Business']['Export of Goods'], hasLength(1));
        expect(json.length, equals(2));
      });

      test('should convert model without data to JSON', () {
        // Arrange
        final model = GetDropdownOptionModel(success: false, data: null);

        // Act
        final json = model.toJson();

        // Assert
        expect(json['success'], isFalse);
        expect(json.containsKey('data'), isFalse);
        expect(json.length, equals(1));
      });

      test('should convert model with null success to JSON', () {
        // Arrange
        final model = GetDropdownOptionModel();

        // Act
        final json = model.toJson();

        // Assert
        expect(json['success'], isNull);
        expect(json.containsKey('data'), isFalse);
        expect(json.length, equals(1));
      });

      test('should convert model with only Personal data to JSON', () {
        // Arrange
        final personal = Personal(freelancer: ['Freelance Writing']);
        final data = Data(personal: personal, business: null);
        final model = GetDropdownOptionModel(success: true, data: data);

        // Act
        final json = model.toJson();

        // Assert
        expect(json['success'], isTrue);
        expect(json['data']['Personal'], isNotNull);
        expect(json['data'].containsKey('Business'), isFalse);
      });
    });

    // =============================================================================
    // SERIALIZATION ROUND-TRIP TESTS
    // =============================================================================

    group('Serialization Round-trip', () {
      test('should maintain data integrity through JSON round-trip', () {
        // Arrange
        final personal = Personal(freelancer: ['Web Development', 'Mobile Development']);
        final business = Business(
          exportOfGoods: ['Electronics', 'Textiles'],
          exportOfGoodsServices: ['IT Services'],
          exportOfServices: ['Software Development'],
        );
        final data = Data(personal: personal, business: business);
        final originalModel = GetDropdownOptionModel(success: true, data: data);

        // Act
        final json = originalModel.toJson();
        final deserializedModel = GetDropdownOptionModel.fromJson(json);

        // Assert
        expect(deserializedModel.success, equals(originalModel.success));
        expect(deserializedModel.data!.personal!.freelancer, equals(originalModel.data!.personal!.freelancer));
        expect(deserializedModel.data!.business!.exportOfGoods, equals(originalModel.data!.business!.exportOfGoods));
        expect(deserializedModel.data!.business!.exportOfGoodsServices, equals(originalModel.data!.business!.exportOfGoodsServices));
        expect(deserializedModel.data!.business!.exportOfServices, equals(originalModel.data!.business!.exportOfServices));
      });

      test('should maintain data integrity with null values', () {
        // Arrange
        final originalModel = GetDropdownOptionModel(success: false, data: null);

        // Act
        final json = originalModel.toJson();
        final deserializedModel = GetDropdownOptionModel.fromJson(json);

        // Assert
        expect(deserializedModel.success, equals(originalModel.success));
        expect(deserializedModel.data, equals(originalModel.data));
      });
    });
  });

  // =============================================================================
  // DATA CLASS TESTS
  // =============================================================================

  group('Data', () {
    group('Constructor', () {
      test('should create instance with personal and business', () {
        // Arrange
        final personal = Personal(freelancer: ['Consulting']);
        final business = Business(exportOfGoods: ['Electronics']);

        // Act
        final data = Data(personal: personal, business: business);

        // Assert
        expect(data.personal, equals(personal));
        expect(data.business, equals(business));
      });

      test('should create instance with null values', () {
        // Act
        final data = Data();

        // Assert
        expect(data.personal, isNull);
        expect(data.business, isNull);
      });
    });

    group('fromJson', () {
      test('should create instance from complete JSON', () {
        // Arrange
        final json = {
          'Personal': {
            'Freelancer': ['Web Development', 'Design']
          },
          'Business': {
            'Export of Goods': ['Electronics'],
            'Export of Goods & Services': ['IT Services'],
            'Export of Services': ['Software Development']
          }
        };

        // Act
        final data = Data.fromJson(json);

        // Assert
        expect(data.personal, isNotNull);
        expect(data.business, isNotNull);
        expect(data.personal!.freelancer, hasLength(2));
        expect(data.business!.exportOfGoods, hasLength(1));
      });

      test('should create instance from JSON with null values', () {
        // Arrange
        final json = {
          'Personal': null,
          'Business': null,
        };

        // Act
        final data = Data.fromJson(json);

        // Assert
        expect(data.personal, isNull);
        expect(data.business, isNull);
      });
    });

    group('toJson', () {
      test('should convert complete data to JSON', () {
        // Arrange
        final personal = Personal(freelancer: ['Writing']);
        final business = Business(exportOfGoods: ['Textiles']);
        final data = Data(personal: personal, business: business);

        // Act
        final json = data.toJson();

        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['Personal'], isNotNull);
        expect(json['Business'], isNotNull);
        expect(json.length, equals(2));
      });

      test('should convert data with null values to JSON', () {
        // Arrange
        final data = Data();

        // Act
        final json = data.toJson();

        // Assert
        expect(json.length, equals(0));
      });
    });
  });

  // =============================================================================
  // PERSONAL CLASS TESTS
  // =============================================================================

  group('Personal', () {
    group('Constructor', () {
      test('should create instance with freelancer list', () {
        // Act
        final personal = Personal(freelancer: ['Web Development', 'Mobile Development']);

        // Assert
        expect(personal.freelancer, hasLength(2));
        expect(personal.freelancer, contains('Web Development'));
      });

      test('should create instance with null freelancer', () {
        // Act
        final personal = Personal();

        // Assert
        expect(personal.freelancer, isNull);
      });
    });

    group('fromJson', () {
      test('should create instance from JSON', () {
        // Arrange
        final json = {
          'Freelancer': ['Consulting', 'Training', 'Coaching']
        };

        // Act
        final personal = Personal.fromJson(json);

        // Assert
        expect(personal.freelancer, hasLength(3));
        expect(personal.freelancer, contains('Consulting'));
        expect(personal.freelancer, contains('Training'));
        expect(personal.freelancer, contains('Coaching'));
      });
    });

    group('toJson', () {
      test('should convert personal to JSON', () {
        // Arrange
        final personal = Personal(freelancer: ['Design', 'Development']);

        // Act
        final json = personal.toJson();

        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['Freelancer'], hasLength(2));
        expect(json['Freelancer'], contains('Design'));
        expect(json.length, equals(1));
      });

      test('should convert personal with null freelancer to JSON', () {
        // Arrange
        final personal = Personal();

        // Act
        final json = personal.toJson();

        // Assert
        expect(json['Freelancer'], isNull);
        expect(json.length, equals(1));
      });
    });
  });

  // =============================================================================
  // BUSINESS CLASS TESTS
  // =============================================================================

  group('Business', () {
    group('Constructor', () {
      test('should create instance with all export types', () {
        // Act
        final business = Business(
          exportOfGoods: ['Electronics', 'Textiles'],
          exportOfGoodsServices: ['IT Services', 'Consulting'],
          exportOfServices: ['Software Development', 'Digital Marketing'],
        );

        // Assert
        expect(business.exportOfGoods, hasLength(2));
        expect(business.exportOfGoodsServices, hasLength(2));
        expect(business.exportOfServices, hasLength(2));
        expect(business.exportOfGoods, contains('Electronics'));
        expect(business.exportOfGoodsServices, contains('IT Services'));
        expect(business.exportOfServices, contains('Software Development'));
      });

      test('should create instance with null values', () {
        // Act
        final business = Business();

        // Assert
        expect(business.exportOfGoods, isNull);
        expect(business.exportOfGoodsServices, isNull);
        expect(business.exportOfServices, isNull);
      });
    });

    group('fromJson', () {
      test('should create instance from complete JSON', () {
        // Arrange
        final json = {
          'Export of Goods': ['Pharmaceuticals', 'Chemicals'],
          'Export of Goods & Services': ['Healthcare Services', 'Educational Services'],
          'Export of Services': ['Medical Tourism', 'Financial Services']
        };

        // Act
        final business = Business.fromJson(json);

        // Assert
        expect(business.exportOfGoods, hasLength(2));
        expect(business.exportOfGoodsServices, hasLength(2));
        expect(business.exportOfServices, hasLength(2));
        expect(business.exportOfGoods, contains('Pharmaceuticals'));
        expect(business.exportOfGoodsServices, contains('Healthcare Services'));
        expect(business.exportOfServices, contains('Medical Tourism'));
      });
    });

    group('toJson', () {
      test('should convert business to JSON', () {
        // Arrange
        final business = Business(
          exportOfGoods: ['Machinery'],
          exportOfGoodsServices: ['Engineering Services'],
          exportOfServices: ['Technical Consulting'],
        );

        // Act
        final json = business.toJson();

        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['Export of Goods'], hasLength(1));
        expect(json['Export of Goods & Services'], hasLength(1));
        expect(json['Export of Services'], hasLength(1));
        expect(json['Export of Goods'], contains('Machinery'));
        expect(json.length, equals(3));
      });

      test('should convert business with null values to JSON', () {
        // Arrange
        final business = Business();

        // Act
        final json = business.toJson();

        // Assert
        expect(json['Export of Goods'], isNull);
        expect(json['Export of Goods & Services'], isNull);
        expect(json['Export of Services'], isNull);
        expect(json.length, equals(3));
      });
    });
  });

  // =============================================================================
  // REAL-WORLD SCENARIO TESTS
  // =============================================================================

  group('Real-world Scenarios', () {
    test('should handle typical dropdown options response', () {
      // Arrange
      final json = {
        'success': true,
        'data': {
          'Personal': {
            'Freelancer': [
              'Web Development',
              'Mobile App Development',
              'Graphic Design',
              'Content Writing',
              'Digital Marketing',
              'Consulting',
              'Photography',
              'Video Editing'
            ]
          },
          'Business': {
            'Export of Goods': [
              'Electronics',
              'Textiles',
              'Pharmaceuticals',
              'Machinery',
              'Chemicals',
              'Food Products'
            ],
            'Export of Goods & Services': [
              'IT Services',
              'Engineering Services',
              'Healthcare Services',
              'Educational Services'
            ],
            'Export of Services': [
              'Software Development',
              'Digital Marketing',
              'Financial Services',
              'Medical Tourism',
              'Business Process Outsourcing'
            ]
          }
        }
      };

      // Act
      final model = GetDropdownOptionModel.fromJson(json);

      // Assert
      expect(model.success, isTrue);
      expect(model.data!.personal!.freelancer, hasLength(8));
      expect(model.data!.business!.exportOfGoods, hasLength(6));
      expect(model.data!.business!.exportOfGoodsServices, hasLength(4));
      expect(model.data!.business!.exportOfServices, hasLength(5));
      
      // Check for common freelancer options
      expect(model.data!.personal!.freelancer, contains('Web Development'));
      expect(model.data!.personal!.freelancer, contains('Digital Marketing'));
      
      // Check for common business export options
      expect(model.data!.business!.exportOfGoods, contains('Electronics'));
      expect(model.data!.business!.exportOfServices, contains('Software Development'));
    });

    test('should handle error response for dropdown options', () {
      // Arrange
      final json = {
        'success': false,
      };

      // Act
      final model = GetDropdownOptionModel.fromJson(json);

      // Assert
      expect(model.success, isFalse);
      expect(model.data, isNull);
    });
  });
}
