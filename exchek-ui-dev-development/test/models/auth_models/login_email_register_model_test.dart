import 'package:flutter_test/flutter_test.dart';
import 'package:exchek/models/auth_models/login_email_register_model.dart';

void main() {
  group('LoginEmailPasswordModel', () {
    // =============================================================================
    // CONSTRUCTOR TESTS
    // =============================================================================

    group('Constructor', () {
      test('should create instance with default null values', () {
        // Act
        final model = LoginEmailPasswordModel();

        // Assert
        expect(model.data, isNull);
        expect(model.success, isNull);
      });

      test('should create instance with provided values', () {
        // Arrange
        final data = Data(token: 'test_token');

        // Act
        final model = LoginEmailPasswordModel(data: data, success: true);

        // Assert
        expect(model.data, equals(data));
        expect(model.success, isTrue);
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
            'token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9',
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
        final model = LoginEmailPasswordModel.fromJson(json);

        // Assert
        expect(model.success, isTrue);
        expect(model.data, isNotNull);
        expect(model.data!.token, equals('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'));
        expect(model.data!.user, isNotNull);
        expect(model.data!.user!.userId, equals('user123'));
        expect(model.data!.user!.userName, equals('john_doe'));
        expect(model.data!.user!.email, equals('john@example.com'));
      });

      test('should create instance from JSON without user data', () {
        // Arrange
        final json = {
          'success': true,
          'data': {
            'token': 'test_token',
          }
        };

        // Act
        final model = LoginEmailPasswordModel.fromJson(json);

        // Assert
        expect(model.success, isTrue);
        expect(model.data, isNotNull);
        expect(model.data!.token, equals('test_token'));
        expect(model.data!.user, isNull);
      });

      test('should create instance from JSON without data', () {
        // Arrange
        final json = {
          'success': false,
        };

        // Act
        final model = LoginEmailPasswordModel.fromJson(json);

        // Assert
        expect(model.success, isFalse);
        expect(model.data, isNull);
      });

      test('should create instance from empty JSON', () {
        // Arrange
        final json = <String, dynamic>{};

        // Act
        final model = LoginEmailPasswordModel.fromJson(json);

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
        final data = Data(token: 'test_token', user: user);
        final model = LoginEmailPasswordModel(data: data, success: true);

        // Act
        final json = model.toJson();

        // Assert
        expect(json['success'], isTrue);
        expect(json['data'], isNotNull);
        expect(json['data']['token'], equals('test_token'));
        expect(json['data']['user'], isNotNull);
        expect(json['data']['user']['user_id'], equals('user123'));
      });

      test('should convert model without data to JSON', () {
        // Arrange
        final model = LoginEmailPasswordModel(success: false);

        // Act
        final json = model.toJson();

        // Assert
        expect(json['success'], isFalse);
        expect(json.containsKey('data'), isFalse);
      });

      test('should convert null model to JSON', () {
        // Arrange
        final model = LoginEmailPasswordModel();

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
        final data = Data(token: 'test_token', user: user);
        final originalModel = LoginEmailPasswordModel(data: data, success: true);

        // Act
        final json = originalModel.toJson();
        final deserializedModel = LoginEmailPasswordModel.fromJson(json);

        // Assert
        expect(deserializedModel.success, equals(originalModel.success));
        expect(deserializedModel.data!.token, equals(originalModel.data!.token));
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
        expect(data.token, isNull);
        expect(data.user, isNull);
      });

      test('should create instance with provided values', () {
        // Arrange
        final user = User(userId: 'test123');

        // Act
        final data = Data(token: 'test_token', user: user);

        // Assert
        expect(data.token, equals('test_token'));
        expect(data.user, equals(user));
      });
    });

    group('fromJson', () {
      test('should create instance from complete JSON', () {
        // Arrange
        final json = {
          'token': 'test_token',
          'user': {
            'user_id': 'user123',
            'user_name': 'john_doe',
            'email': 'john@example.com',
          }
        };

        // Act
        final data = Data.fromJson(json);

        // Assert
        expect(data.token, equals('test_token'));
        expect(data.user, isNotNull);
        expect(data.user!.userId, equals('user123'));
      });

      test('should create instance from JSON without user', () {
        // Arrange
        final json = {
          'token': 'test_token',
        };

        // Act
        final data = Data.fromJson(json);

        // Assert
        expect(data.token, equals('test_token'));
        expect(data.user, isNull);
      });
    });

    group('toJson', () {
      test('should convert complete data to JSON', () {
        // Arrange
        final user = User(userId: 'user123', email: 'test@example.com');
        final data = Data(token: 'test_token', user: user);

        // Act
        final json = data.toJson();

        // Assert
        expect(json['token'], equals('test_token'));
        expect(json['user'], isNotNull);
        expect(json['user']['user_id'], equals('user123'));
      });

      test('should convert data without user to JSON', () {
        // Arrange
        final data = Data(token: 'test_token');

        // Act
        final json = data.toJson();

        // Assert
        expect(json['token'], equals('test_token'));
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
        expect(user.createdAt, isNull);
        expect(user.email, isNull);
        expect(user.mobileNumber, isNull);
        expect(user.updatedAt, isNull);
        expect(user.userId, isNull);
        expect(user.userName, isNull);
      });

      test('should create instance with provided values', () {
        // Act
        final user = User(
          createdAt: '2023-01-01T00:00:00Z',
          email: 'john@example.com',
          mobileNumber: '+1234567890',
          updatedAt: '2023-01-02T00:00:00Z',
          userId: 'user123',
          userName: 'john_doe',
        );

        // Assert
        expect(user.createdAt, equals('2023-01-01T00:00:00Z'));
        expect(user.email, equals('john@example.com'));
        expect(user.mobileNumber, equals('+1234567890'));
        expect(user.updatedAt, equals('2023-01-02T00:00:00Z'));
        expect(user.userId, equals('user123'));
        expect(user.userName, equals('john_doe'));
      });
    });

    group('fromJson', () {
      test('should create instance from complete JSON', () {
        // Arrange
        final json = {
          'created_at': '2023-01-01T00:00:00Z',
          'email': 'john@example.com',
          'mobile_number': '+1234567890',
          'updated_at': '2023-01-02T00:00:00Z',
          'user_id': 'user123',
          'user_name': 'john_doe',
        };

        // Act
        final user = User.fromJson(json);

        // Assert
        expect(user.createdAt, equals('2023-01-01T00:00:00Z'));
        expect(user.email, equals('john@example.com'));
        expect(user.mobileNumber, equals('+1234567890'));
        expect(user.updatedAt, equals('2023-01-02T00:00:00Z'));
        expect(user.userId, equals('user123'));
        expect(user.userName, equals('john_doe'));
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
        expect(user.createdAt, isNull);
        expect(user.mobileNumber, isNull);
        expect(user.updatedAt, isNull);
        expect(user.userName, isNull);
      });
    });

    group('toJson', () {
      test('should convert complete user to JSON', () {
        // Arrange
        final user = User(
          createdAt: '2023-01-01T00:00:00Z',
          email: 'john@example.com',
          mobileNumber: '+1234567890',
          updatedAt: '2023-01-02T00:00:00Z',
          userId: 'user123',
          userName: 'john_doe',
        );

        // Act
        final json = user.toJson();

        // Assert
        expect(json['created_at'], equals('2023-01-01T00:00:00Z'));
        expect(json['email'], equals('john@example.com'));
        expect(json['mobile_number'], equals('+1234567890'));
        expect(json['updated_at'], equals('2023-01-02T00:00:00Z'));
        expect(json['user_id'], equals('user123'));
        expect(json['user_name'], equals('john_doe'));
      });

      test('should convert user with null values to JSON', () {
        // Arrange
        final user = User();

        // Act
        final json = user.toJson();

        // Assert
        expect(json['created_at'], isNull);
        expect(json['email'], isNull);
        expect(json['mobile_number'], isNull);
        expect(json['updated_at'], isNull);
        expect(json['user_id'], isNull);
        expect(json['user_name'], isNull);
      });
    });
  });
}
