import 'package:flutter_test/flutter_test.dart';
import 'package:exchek/models/auth_models/email_availabilty_model.dart';

void main() {
  group('EmailAvailabilityModel', () {
    // =============================================================================
    // CONSTRUCTOR TESTS
    // =============================================================================

    group('Constructor', () {
      test('should create instance with default null values', () {
        // Act
        final model = EmailAvailabilityModel();

        // Assert
        expect(model.success, isNull);
        expect(model.data, isNull);
      });

      test('should create instance with provided values', () {
        // Arrange
        final data = Data(exists: true);

        // Act
        final model = EmailAvailabilityModel(success: true, data: data);

        // Assert
        expect(model.success, isTrue);
        expect(model.data, equals(data));
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
            'exists': true,
            'user': {
              'user_id': 'user123',
              'user_name': 'john_doe',
              'email': 'john@example.com',
              'created_at': '2023-01-01T00:00:00Z',
              'updated_at': '2023-01-02T00:00:00Z',
              'mobile_number': '+1234567890'
            }
          }
        };

        // Act
        final model = EmailAvailabilityModel.fromJson(json);

        // Assert
        expect(model.success, isTrue);
        expect(model.data, isNotNull);
        expect(model.data!.exists, isTrue);
        expect(model.data!.user, isNotNull);
        expect(model.data!.user!.userId, equals('user123'));
        expect(model.data!.user!.userName, equals('john_doe'));
        expect(model.data!.user!.email, equals('john@example.com'));
      });

      test('should create instance from JSON without user data', () {
        // Arrange
        final json = {
          'success': false,
          'data': {
            'exists': false,
          }
        };

        // Act
        final model = EmailAvailabilityModel.fromJson(json);

        // Assert
        expect(model.success, isFalse);
        expect(model.data, isNotNull);
        expect(model.data!.exists, isFalse);
        expect(model.data!.user, isNull);
      });

      test('should create instance from JSON without data', () {
        // Arrange
        final json = {
          'success': true,
        };

        // Act
        final model = EmailAvailabilityModel.fromJson(json);

        // Assert
        expect(model.success, isTrue);
        expect(model.data, isNull);
      });

      test('should create instance from empty JSON', () {
        // Arrange
        final json = <String, dynamic>{};

        // Act
        final model = EmailAvailabilityModel.fromJson(json);

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
        final user = User(
          userId: 'user123',
          userName: 'john_doe',
          email: 'john@example.com',
          createdAt: '2023-01-01T00:00:00Z',
          updatedAt: '2023-01-02T00:00:00Z',
          mobileNumber: '+1234567890',
        );
        final data = Data(exists: true, user: user);
        final model = EmailAvailabilityModel(success: true, data: data);

        // Act
        final json = model.toJson();

        // Assert
        expect(json['success'], isTrue);
        expect(json['data'], isNotNull);
        expect(json['data']['exists'], isTrue);
        expect(json['data']['user'], isNotNull);
        expect(json['data']['user']['user_id'], equals('user123'));
      });

      test('should convert model without data to JSON', () {
        // Arrange
        final model = EmailAvailabilityModel(success: false);

        // Act
        final json = model.toJson();

        // Assert
        expect(json['success'], isFalse);
        expect(json.containsKey('data'), isFalse);
      });

      test('should convert null model to JSON', () {
        // Arrange
        final model = EmailAvailabilityModel();

        // Act
        final json = model.toJson();

        // Assert
        expect(json['success'], isNull);
        expect(json.containsKey('data'), isFalse);
      });
    });

    // =============================================================================
    // SERIALIZATION ROUND-TRIP TESTS
    // =============================================================================

    group('Serialization Round-trip', () {
      test('should maintain data integrity through JSON round-trip', () {
        // Arrange
        final user = User(
          userId: 'user123',
          userName: 'john_doe',
          email: 'john@example.com',
          createdAt: '2023-01-01T00:00:00Z',
          updatedAt: '2023-01-02T00:00:00Z',
          mobileNumber: '+1234567890',
        );
        final data = Data(exists: true, user: user);
        final originalModel = EmailAvailabilityModel(success: true, data: data);

        // Act
        final json = originalModel.toJson();
        final deserializedModel = EmailAvailabilityModel.fromJson(json);

        // Assert
        expect(deserializedModel.success, equals(originalModel.success));
        expect(deserializedModel.data!.exists, equals(originalModel.data!.exists));
        expect(deserializedModel.data!.user!.userId, equals(originalModel.data!.user!.userId));
        expect(deserializedModel.data!.user!.email, equals(originalModel.data!.user!.email));
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
        expect(data.user, isNull);
      });

      test('should create instance with provided values', () {
        // Arrange
        final user = User(userId: 'test123');

        // Act
        final data = Data(exists: true, user: user);

        // Assert
        expect(data.exists, isTrue);
        expect(data.user, equals(user));
      });
    });

    group('fromJson', () {
      test('should create instance from complete JSON', () {
        // Arrange
        final json = {
          'exists': true,
          'user': {
            'user_id': 'user123',
            'user_name': 'john_doe',
            'email': 'john@example.com',
          }
        };

        // Act
        final data = Data.fromJson(json);

        // Assert
        expect(data.exists, isTrue);
        expect(data.user, isNotNull);
        expect(data.user!.userId, equals('user123'));
      });

      test('should create instance from JSON without user', () {
        // Arrange
        final json = {
          'exists': false,
        };

        // Act
        final data = Data.fromJson(json);

        // Assert
        expect(data.exists, isFalse);
        expect(data.user, isNull);
      });
    });

    group('toJson', () {
      test('should convert complete data to JSON', () {
        // Arrange
        final user = User(userId: 'user123', email: 'test@example.com');
        final data = Data(exists: true, user: user);

        // Act
        final json = data.toJson();

        // Assert
        expect(json['exists'], isTrue);
        expect(json['user'], isNotNull);
        expect(json['user']['user_id'], equals('user123'));
      });

      test('should convert data without user to JSON', () {
        // Arrange
        final data = Data(exists: false);

        // Act
        final json = data.toJson();

        // Assert
        expect(json['exists'], isFalse);
        expect(json.containsKey('user'), isFalse);
      });
    });
  });

  // =============================================================================
  // USER CLASS TESTS
  // =============================================================================

  group('User', () {
    group('Constructor', () {
      test('should create instance with default null values', () {
        // Act
        final user = User();

        // Assert
        expect(user.userId, isNull);
        expect(user.userName, isNull);
        expect(user.email, isNull);
        expect(user.createdAt, isNull);
        expect(user.updatedAt, isNull);
        expect(user.mobileNumber, isNull);
      });

      test('should create instance with provided values', () {
        // Act
        final user = User(
          userId: 'user123',
          userName: 'john_doe',
          email: 'john@example.com',
          createdAt: '2023-01-01T00:00:00Z',
          updatedAt: '2023-01-02T00:00:00Z',
          mobileNumber: '+1234567890',
        );

        // Assert
        expect(user.userId, equals('user123'));
        expect(user.userName, equals('john_doe'));
        expect(user.email, equals('john@example.com'));
        expect(user.createdAt, equals('2023-01-01T00:00:00Z'));
        expect(user.updatedAt, equals('2023-01-02T00:00:00Z'));
        expect(user.mobileNumber, equals('+1234567890'));
      });
    });

    group('fromJson', () {
      test('should create instance from complete JSON', () {
        // Arrange
        final json = {
          'user_id': 'user123',
          'user_name': 'john_doe',
          'email': 'john@example.com',
          'created_at': '2023-01-01T00:00:00Z',
          'updated_at': '2023-01-02T00:00:00Z',
          'mobile_number': '+1234567890',
        };

        // Act
        final user = User.fromJson(json);

        // Assert
        expect(user.userId, equals('user123'));
        expect(user.userName, equals('john_doe'));
        expect(user.email, equals('john@example.com'));
        expect(user.createdAt, equals('2023-01-01T00:00:00Z'));
        expect(user.updatedAt, equals('2023-01-02T00:00:00Z'));
        expect(user.mobileNumber, equals('+1234567890'));
      });

      test('should create instance from partial JSON', () {
        // Arrange
        final json = {
          'user_id': 'user123',
          'email': 'john@example.com',
        };

        // Act
        final user = User.fromJson(json);

        // Assert
        expect(user.userId, equals('user123'));
        expect(user.email, equals('john@example.com'));
        expect(user.userName, isNull);
        expect(user.createdAt, isNull);
        expect(user.updatedAt, isNull);
        expect(user.mobileNumber, isNull);
      });
    });

    group('toJson', () {
      test('should convert complete user to JSON', () {
        // Arrange
        final user = User(
          userId: 'user123',
          userName: 'john_doe',
          email: 'john@example.com',
          createdAt: '2023-01-01T00:00:00Z',
          updatedAt: '2023-01-02T00:00:00Z',
          mobileNumber: '+1234567890',
        );

        // Act
        final json = user.toJson();

        // Assert
        expect(json['user_id'], equals('user123'));
        expect(json['user_name'], equals('john_doe'));
        expect(json['email'], equals('john@example.com'));
        expect(json['created_at'], equals('2023-01-01T00:00:00Z'));
        expect(json['updated_at'], equals('2023-01-02T00:00:00Z'));
        expect(json['mobile_number'], equals('+1234567890'));
      });

      test('should convert user with null values to JSON', () {
        // Arrange
        final user = User();

        // Act
        final json = user.toJson();

        // Assert
        expect(json['user_id'], isNull);
        expect(json['user_name'], isNull);
        expect(json['email'], isNull);
        expect(json['created_at'], isNull);
        expect(json['updated_at'], isNull);
        expect(json['mobile_number'], isNull);
      });
    });
  });
}
