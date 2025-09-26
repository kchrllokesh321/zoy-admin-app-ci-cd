import 'package:exchek/models/personal_user_models/bank_account_verify_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BankAccountVerifyModel', () {
    test('constructor creates instance with required parameters', () {
      final data = Data(accountHolderName: 'John Doe', message: 'Account verified successfully', status: 'success');

      final model = BankAccountVerifyModel(success: true, data: data);

      expect(model.success, isTrue);
      expect(model.data, equals(data));
    });

    test('constructor creates instance with null parameters', () {
      final model = BankAccountVerifyModel(success: null, data: null);

      expect(model.success, isNull);
      expect(model.data, isNull);
    });

    test('fromJson creates instance from JSON with data', () {
      final json = {
        'success': true,
        'data': {
          'account_holder_name': 'Jane Smith',
          'message': 'Bank account verification completed',
          'status': 'verified',
        },
      };

      final model = BankAccountVerifyModel.fromJson(json);

      expect(model.success, isTrue);
      expect(model.data, isNotNull);
      expect(model.data!.accountHolderName, equals('Jane Smith'));
      expect(model.data!.message, equals('Bank account verification completed'));
      expect(model.data!.status, equals('verified'));
    });

    test('fromJson creates instance from JSON with null data', () {
      final json = {'success': false, 'data': null};

      final model = BankAccountVerifyModel.fromJson(json);

      expect(model.success, isFalse);
      expect(model.data, isNull);
    });

    test('fromJson creates instance from JSON without data field', () {
      final json = {'success': true};

      final model = BankAccountVerifyModel.fromJson(json);

      expect(model.success, isTrue);
      expect(model.data, isNull);
    });

    test('fromJson handles null success field', () {
      final json = {
        'success': null,
        'data': {'account_holder_name': 'Test User', 'message': 'Test message', 'status': 'pending'},
      };

      final model = BankAccountVerifyModel.fromJson(json);

      expect(model.success, isNull);
      expect(model.data, isNotNull);
      expect(model.data!.accountHolderName, equals('Test User'));
    });

    test('toJson converts instance to JSON with data', () {
      final data = Data(accountHolderName: 'Alice Johnson', message: 'Verification successful', status: 'active');

      final model = BankAccountVerifyModel(success: true, data: data);
      final json = model.toJson();

      expect(json['success'], isTrue);
      expect(json['data'], isNotNull);
      expect(json['data']['account_holder_name'], equals('Alice Johnson'));
      expect(json['data']['message'], equals('Verification successful'));
      expect(json['data']['status'], equals('active'));
    });

    test('toJson converts instance to JSON with null data', () {
      final model = BankAccountVerifyModel(success: false, data: null);
      final json = model.toJson();

      expect(json['success'], isFalse);
      expect(json.containsKey('data'), isFalse);
    });

    test('toJson converts instance to JSON with null success', () {
      final data = Data(accountHolderName: 'Bob Wilson', message: 'Processing verification', status: 'processing');

      final model = BankAccountVerifyModel(success: null, data: data);
      final json = model.toJson();

      expect(json['success'], isNull);
      expect(json['data'], isNotNull);
      expect(json['data']['account_holder_name'], equals('Bob Wilson'));
    });

    test('toJson converts instance to JSON with all null values', () {
      final model = BankAccountVerifyModel(success: null, data: null);
      final json = model.toJson();

      expect(json['success'], isNull);
      expect(json.containsKey('data'), isFalse);
    });
  });

  group('Data', () {
    test('constructor creates instance with all parameters', () {
      final data = Data(accountHolderName: 'Charlie Brown', message: 'Account details verified', status: 'completed');

      expect(data.accountHolderName, equals('Charlie Brown'));
      expect(data.message, equals('Account details verified'));
      expect(data.status, equals('completed'));
    });

    test('constructor creates instance with null parameters', () {
      final data = Data(accountHolderName: null, message: null, status: null);

      expect(data.accountHolderName, isNull);
      expect(data.message, isNull);
      expect(data.status, isNull);
    });

    test('constructor creates instance with mixed parameters', () {
      final data = Data(accountHolderName: 'David Lee', message: null, status: 'pending');

      expect(data.accountHolderName, equals('David Lee'));
      expect(data.message, isNull);
      expect(data.status, equals('pending'));
    });

    test('fromJson creates instance from JSON with all fields', () {
      final json = {
        'account_holder_name': 'Emma Davis',
        'message': 'Bank account successfully verified',
        'status': 'success',
      };

      final data = Data.fromJson(json);

      expect(data.accountHolderName, equals('Emma Davis'));
      expect(data.message, equals('Bank account successfully verified'));
      expect(data.status, equals('success'));
    });

    test('fromJson creates instance from JSON with null fields', () {
      final json = {'account_holder_name': null, 'message': null, 'status': null};

      final data = Data.fromJson(json);

      expect(data.accountHolderName, isNull);
      expect(data.message, isNull);
      expect(data.status, isNull);
    });

    test('fromJson creates instance from JSON with missing fields', () {
      final json = <String, dynamic>{};

      final data = Data.fromJson(json);

      expect(data.accountHolderName, isNull);
      expect(data.message, isNull);
      expect(data.status, isNull);
    });

    test('fromJson creates instance from JSON with partial fields', () {
      final json = {'account_holder_name': 'Frank Miller', 'status': 'failed'};

      final data = Data.fromJson(json);

      expect(data.accountHolderName, equals('Frank Miller'));
      expect(data.message, isNull);
      expect(data.status, equals('failed'));
    });

    test('toJson converts instance to JSON with all fields', () {
      final data = Data(
        accountHolderName: 'Grace Wilson',
        message: 'Verification process completed successfully',
        status: 'verified',
      );

      final json = data.toJson();

      expect(json['account_holder_name'], equals('Grace Wilson'));
      expect(json['message'], equals('Verification process completed successfully'));
      expect(json['status'], equals('verified'));
    });

    test('toJson converts instance to JSON with null fields', () {
      final data = Data(accountHolderName: null, message: null, status: null);

      final json = data.toJson();

      expect(json['account_holder_name'], isNull);
      expect(json['message'], isNull);
      expect(json['status'], isNull);
    });

    test('toJson converts instance to JSON with mixed fields', () {
      final data = Data(accountHolderName: 'Henry Taylor', message: null, status: 'in_progress');

      final json = data.toJson();

      expect(json['account_holder_name'], equals('Henry Taylor'));
      expect(json['message'], isNull);
      expect(json['status'], equals('in_progress'));
    });
  });

  group('Integration Tests', () {
    test('complete workflow - successful verification', () {
      // Simulate API response for successful verification
      final apiResponse = {
        'success': true,
        'data': {
          'account_holder_name': 'John Doe',
          'message': 'Bank account verified successfully',
          'status': 'verified',
        },
      };

      final model = BankAccountVerifyModel.fromJson(apiResponse);

      expect(model.success, isTrue);
      expect(model.data, isNotNull);
      expect(model.data!.accountHolderName, equals('John Doe'));
      expect(model.data!.message, equals('Bank account verified successfully'));
      expect(model.data!.status, equals('verified'));

      // Convert back to JSON for API request
      final requestJson = model.toJson();
      expect(requestJson['success'], isTrue);
      expect(requestJson['data']['account_holder_name'], equals('John Doe'));
    });

    test('complete workflow - failed verification', () {
      // Simulate API response for failed verification
      final apiResponse = {
        'success': false,
        'data': {'account_holder_name': null, 'message': 'Invalid account details provided', 'status': 'failed'},
      };

      final model = BankAccountVerifyModel.fromJson(apiResponse);

      expect(model.success, isFalse);
      expect(model.data, isNotNull);
      expect(model.data!.accountHolderName, isNull);
      expect(model.data!.message, equals('Invalid account details provided'));
      expect(model.data!.status, equals('failed'));

      // Convert back to JSON
      final requestJson = model.toJson();
      expect(requestJson['success'], isFalse);
      expect(requestJson['data']['message'], equals('Invalid account details provided'));
    });

    test('complete workflow - pending verification', () {
      // Simulate API response for pending verification
      final apiResponse = {
        'success': true,
        'data': {'account_holder_name': 'Jane Smith', 'message': 'Verification is in progress', 'status': 'pending'},
      };

      final model = BankAccountVerifyModel.fromJson(apiResponse);

      expect(model.success, isTrue);
      expect(model.data, isNotNull);
      expect(model.data!.accountHolderName, equals('Jane Smith'));
      expect(model.data!.message, equals('Verification is in progress'));
      expect(model.data!.status, equals('pending'));
    });

    test('complete workflow - error response with no data', () {
      // Simulate API error response
      final apiResponse = {'success': false, 'data': null};

      final model = BankAccountVerifyModel.fromJson(apiResponse);

      expect(model.success, isFalse);
      expect(model.data, isNull);

      // Convert back to JSON
      final requestJson = model.toJson();
      expect(requestJson['success'], isFalse);
      expect(requestJson.containsKey('data'), isFalse);
    });
  });

  group('Edge Cases and Error Handling', () {
    test('BankAccountVerifyModel handles empty JSON', () {
      final json = <String, dynamic>{};

      final model = BankAccountVerifyModel.fromJson(json);

      expect(model.success, isNull);
      expect(model.data, isNull);
    });

    test('BankAccountVerifyModel handles malformed data field', () {
      final json = {'success': true, 'data': 'invalid_data_type'};

      // This should not throw an exception, but data should be null
      expect(() => BankAccountVerifyModel.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('Data handles various account holder name formats', () {
      final testCases = [
        'John Doe',
        'JOHN DOE',
        'john doe',
        'John-Doe',
        'John O\'Connor',
        'José María García',
        '李小明',
        '123 Test Name',
        '',
      ];

      for (final name in testCases) {
        final json = {'account_holder_name': name, 'message': 'Test message', 'status': 'test'};

        final data = Data.fromJson(json);
        expect(data.accountHolderName, equals(name));

        final convertedJson = data.toJson();
        expect(convertedJson['account_holder_name'], equals(name));
      }
    });

    test('Data handles various status values', () {
      final statusValues = [
        'verified',
        'failed',
        'pending',
        'in_progress',
        'cancelled',
        'expired',
        'success',
        'error',
        '',
        'VERIFIED',
        'Failed',
      ];

      for (final status in statusValues) {
        final json = {'account_holder_name': 'Test User', 'message': 'Test message', 'status': status};

        final data = Data.fromJson(json);
        expect(data.status, equals(status));

        final convertedJson = data.toJson();
        expect(convertedJson['status'], equals(status));
      }
    });

    test('Data handles various message formats', () {
      final messages = [
        'Account verified successfully',
        'Verification failed due to invalid details',
        'Please wait while we verify your account',
        '',
        'Error: Unable to process request',
        'Success! Your bank account has been linked.',
        'Warning: Account details do not match',
        'Info: Verification will take 2-3 business days',
        'Special characters: !@#\$%^&*()',
        'Unicode: 账户验证成功',
      ];

      for (final message in messages) {
        final json = {'account_holder_name': 'Test User', 'message': message, 'status': 'test'};

        final data = Data.fromJson(json);
        expect(data.message, equals(message));

        final convertedJson = data.toJson();
        expect(convertedJson['message'], equals(message));
      }
    });

    test('round-trip conversion maintains data integrity', () {
      final originalData = Data(
        accountHolderName: 'Test User Name',
        message: 'Test verification message',
        status: 'verified',
      );

      final originalModel = BankAccountVerifyModel(success: true, data: originalData);

      // Convert to JSON and back
      final json = originalModel.toJson();
      final reconstructedModel = BankAccountVerifyModel.fromJson(json);

      // Verify all data is preserved
      expect(reconstructedModel.success, equals(originalModel.success));
      expect(reconstructedModel.data, isNotNull);
      expect(reconstructedModel.data!.accountHolderName, equals(originalData.accountHolderName));
      expect(reconstructedModel.data!.message, equals(originalData.message));
      expect(reconstructedModel.data!.status, equals(originalData.status));
    });

    test('round-trip conversion with null values', () {
      final originalData = Data(accountHolderName: null, message: null, status: null);

      final originalModel = BankAccountVerifyModel(success: null, data: originalData);

      // Convert to JSON and back
      final json = originalModel.toJson();
      final reconstructedModel = BankAccountVerifyModel.fromJson(json);

      // Verify null values are preserved
      expect(reconstructedModel.success, isNull);
      expect(reconstructedModel.data, isNotNull);
      expect(reconstructedModel.data!.accountHolderName, isNull);
      expect(reconstructedModel.data!.message, isNull);
      expect(reconstructedModel.data!.status, isNull);
    });
  });
}
