import 'package:exchek/models/personal_user_models/get_gst_details_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GetGstDetailsModel', () {
    test('constructor creates instance with required parameters', () {
      final data = Data(
        legalName: 'ABC Private Limited',
        message: 'GST details retrieved successfully',
        status: 'active',
      );

      final model = GetGstDetailsModel(success: true, data: data);

      expect(model.success, isTrue);
      expect(model.data, equals(data));
    });

    test('constructor creates instance with null parameters', () {
      final model = GetGstDetailsModel(success: null, data: null);

      expect(model.success, isNull);
      expect(model.data, isNull);
    });

    test('fromJson creates instance from JSON with data', () {
      final json = {
        'success': true,
        'data': {'legal_name': 'XYZ Corporation', 'message': 'Valid GST number', 'status': 'verified'},
      };

      final model = GetGstDetailsModel.fromJson(json);

      expect(model.success, isTrue);
      expect(model.data, isNotNull);
      expect(model.data!.legalName, equals('XYZ Corporation'));
      expect(model.data!.message, equals('Valid GST number'));
      expect(model.data!.status, equals('verified'));
    });

    test('fromJson creates instance from JSON with null success', () {
      final json = {
        'success': null,
        'data': {'legal_name': 'Test Company', 'message': 'Processing GST verification', 'status': 'pending'},
      };

      final model = GetGstDetailsModel.fromJson(json);

      expect(model.success, isNull);
      expect(model.data, isNotNull);
      expect(model.data!.legalName, equals('Test Company'));
    });

    test('fromJson throws error when data field is null', () {
      final json = {'success': false, 'data': null};

      // The current implementation will throw an error because it doesn't handle null data
      expect(() => GetGstDetailsModel.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('fromJson throws error when data field is missing', () {
      final json = {'success': true};

      // The current implementation will throw an error because it doesn't handle missing data
      expect(() => GetGstDetailsModel.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('fromJson handles empty JSON', () {
      final json = <String, dynamic>{};

      // This will throw because both success and data are missing
      expect(() => GetGstDetailsModel.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('toJson converts instance to JSON with data', () {
      final data = Data(legalName: 'Tech Solutions Pvt Ltd', message: 'GST registration is valid', status: 'active');

      final model = GetGstDetailsModel(success: true, data: data);
      final json = model.toJson();

      expect(json['success'], isTrue);
      expect(json['data'], isNotNull);
      expect(json['data']['legal_name'], equals('Tech Solutions Pvt Ltd'));
      expect(json['data']['message'], equals('GST registration is valid'));
      expect(json['data']['status'], equals('active'));
    });

    test('toJson converts instance to JSON with null data', () {
      final model = GetGstDetailsModel(success: false, data: null);
      final json = model.toJson();

      expect(json['success'], isFalse);
      expect(json['data'], isNull);
    });

    test('toJson converts instance to JSON with null success', () {
      final data = Data(legalName: 'Sample Company', message: 'GST verification in progress', status: 'processing');

      final model = GetGstDetailsModel(success: null, data: data);
      final json = model.toJson();

      expect(json['success'], isNull);
      expect(json['data'], isNotNull);
      expect(json['data']['legal_name'], equals('Sample Company'));
    });

    test('toJson converts instance to JSON with all null values', () {
      final model = GetGstDetailsModel(success: null, data: null);
      final json = model.toJson();

      expect(json['success'], isNull);
      expect(json['data'], isNull);
    });
  });

  group('Data', () {
    test('constructor creates instance with all parameters', () {
      final data = Data(
        legalName: 'Global Enterprises Ltd',
        message: 'GST details are valid and up to date',
        status: 'verified',
      );

      expect(data.legalName, equals('Global Enterprises Ltd'));
      expect(data.message, equals('GST details are valid and up to date'));
      expect(data.status, equals('verified'));
    });

    test('constructor creates instance with null parameters', () {
      final data = Data(legalName: null, message: null, status: null);

      expect(data.legalName, isNull);
      expect(data.message, isNull);
      expect(data.status, isNull);
    });

    test('constructor creates instance with mixed parameters', () {
      final data = Data(legalName: 'Partial Data Company', message: null, status: 'incomplete');

      expect(data.legalName, equals('Partial Data Company'));
      expect(data.message, isNull);
      expect(data.status, equals('incomplete'));
    });

    test('fromJson creates instance from JSON with all fields', () {
      final json = {
        'legal_name': 'Manufacturing Corp',
        'message': 'GST number is valid and active',
        'status': 'active',
      };

      final data = Data.fromJson(json);

      expect(data.legalName, equals('Manufacturing Corp'));
      expect(data.message, equals('GST number is valid and active'));
      expect(data.status, equals('active'));
    });

    test('fromJson creates instance from JSON with null fields', () {
      final json = {'legal_name': null, 'message': null, 'status': null};

      final data = Data.fromJson(json);

      expect(data.legalName, isNull);
      expect(data.message, isNull);
      expect(data.status, isNull);
    });

    test('fromJson creates instance from JSON with missing fields', () {
      final json = <String, dynamic>{};

      final data = Data.fromJson(json);

      expect(data.legalName, isNull);
      expect(data.message, isNull);
      expect(data.status, isNull);
    });

    test('fromJson creates instance from JSON with partial fields', () {
      final json = {'legal_name': 'Incomplete Data Ltd', 'status': 'pending'};

      final data = Data.fromJson(json);

      expect(data.legalName, equals('Incomplete Data Ltd'));
      expect(data.message, isNull);
      expect(data.status, equals('pending'));
    });

    test('toJson converts instance to JSON with all fields', () {
      final data = Data(
        legalName: 'Export Import Company',
        message: 'GST registration verified successfully',
        status: 'verified',
      );

      final json = data.toJson();

      expect(json['legal_name'], equals('Export Import Company'));
      expect(json['message'], equals('GST registration verified successfully'));
      expect(json['status'], equals('verified'));
    });

    test('toJson converts instance to JSON with null fields', () {
      final data = Data(legalName: null, message: null, status: null);

      final json = data.toJson();

      expect(json['legal_name'], isNull);
      expect(json['message'], isNull);
      expect(json['status'], isNull);
    });

    test('toJson converts instance to JSON with mixed fields', () {
      final data = Data(legalName: 'Mixed Data Corp', message: null, status: 'active');

      final json = data.toJson();

      expect(json['legal_name'], equals('Mixed Data Corp'));
      expect(json['message'], isNull);
      expect(json['status'], equals('active'));
    });
  });

  group('Integration Tests', () {
    test('complete workflow - successful GST verification', () {
      // Simulate API response for successful GST verification
      final apiResponse = {
        'success': true,
        'data': {
          'legal_name': 'ABC Private Limited',
          'message': 'GST number 27AAAAA0000A1Z5 is valid and active',
          'status': 'active',
        },
      };

      final model = GetGstDetailsModel.fromJson(apiResponse);

      expect(model.success, isTrue);
      expect(model.data, isNotNull);
      expect(model.data!.legalName, equals('ABC Private Limited'));
      expect(model.data!.message, contains('27AAAAA0000A1Z5'));
      expect(model.data!.status, equals('active'));

      // Convert back to JSON for API request
      final requestJson = model.toJson();
      expect(requestJson['success'], isTrue);
      expect(requestJson['data']['legal_name'], equals('ABC Private Limited'));
    });

    test('complete workflow - failed GST verification', () {
      // Simulate API response for failed GST verification
      final apiResponse = {
        'success': false,
        'data': {'legal_name': null, 'message': 'Invalid GST number provided', 'status': 'invalid'},
      };

      final model = GetGstDetailsModel.fromJson(apiResponse);

      expect(model.success, isFalse);
      expect(model.data, isNotNull);
      expect(model.data!.legalName, isNull);
      expect(model.data!.message, equals('Invalid GST number provided'));
      expect(model.data!.status, equals('invalid'));
    });

    test('complete workflow - pending GST verification', () {
      // Simulate API response for pending GST verification
      final apiResponse = {
        'success': true,
        'data': {'legal_name': 'XYZ Corporation', 'message': 'GST verification is in progress', 'status': 'pending'},
      };

      final model = GetGstDetailsModel.fromJson(apiResponse);

      expect(model.success, isTrue);
      expect(model.data, isNotNull);
      expect(model.data!.legalName, equals('XYZ Corporation'));
      expect(model.data!.message, equals('GST verification is in progress'));
      expect(model.data!.status, equals('pending'));
    });

    test('handles various GST status values', () {
      final statusValues = [
        'active',
        'inactive',
        'suspended',
        'cancelled',
        'pending',
        'verified',
        'invalid',
        'expired',
        'blocked',
      ];

      for (final status in statusValues) {
        final json = {
          'success': true,
          'data': {'legal_name': 'Test Company', 'message': 'Status test', 'status': status},
        };

        final model = GetGstDetailsModel.fromJson(json);
        expect(model.data!.status, equals(status));

        final convertedJson = model.toJson();
        expect(convertedJson['data']['status'], equals(status));
      }
    });

    test('handles various legal name formats', () {
      final legalNames = [
        'ABC Private Limited',
        'XYZ PUBLIC LIMITED COMPANY',
        'Tech Solutions Pvt. Ltd.',
        'Global Enterprises LLP',
        'Manufacturing Co.',
        'Export Import Corporation',
        'Service Provider & Associates',
        'Company with Special Characters @#\$',
        'कंपनी नाम हिंदी में',
        'Company Name with Numbers 123',
        '',
      ];

      for (final legalName in legalNames) {
        final json = {
          'success': true,
          'data': {'legal_name': legalName, 'message': 'Test message', 'status': 'active'},
        };

        final model = GetGstDetailsModel.fromJson(json);
        expect(model.data!.legalName, equals(legalName));

        final convertedJson = model.toJson();
        expect(convertedJson['data']['legal_name'], equals(legalName));
      }
    });

    test('handles various message formats', () {
      final messages = [
        'GST number is valid and active',
        'Invalid GST number format',
        'GST registration not found',
        'Verification successful',
        'Error: Unable to verify GST details',
        'Warning: GST registration is suspended',
        'Info: Please provide valid GST number',
        'Success! GST details retrieved',
        'Special characters in message: !@#\$%^&*()',
        'Unicode message: जीएसटी सत्यापन सफल',
        '',
      ];

      for (final message in messages) {
        final json = {
          'success': true,
          'data': {'legal_name': 'Test Company', 'message': message, 'status': 'active'},
        };

        final model = GetGstDetailsModel.fromJson(json);
        expect(model.data!.message, equals(message));

        final convertedJson = model.toJson();
        expect(convertedJson['data']['message'], equals(message));
      }
    });
  });

  group('Edge Cases and Error Handling', () {
    test('round-trip conversion maintains data integrity', () {
      final originalData = Data(
        legalName: 'Original Company Name',
        message: 'Original verification message',
        status: 'verified',
      );

      final originalModel = GetGstDetailsModel(success: true, data: originalData);

      // Convert to JSON and back
      final json = originalModel.toJson();
      final reconstructedModel = GetGstDetailsModel.fromJson(json);

      // Verify all data is preserved
      expect(reconstructedModel.success, equals(originalModel.success));
      expect(reconstructedModel.data, isNotNull);
      expect(reconstructedModel.data!.legalName, equals(originalData.legalName));
      expect(reconstructedModel.data!.message, equals(originalData.message));
      expect(reconstructedModel.data!.status, equals(originalData.status));
    });

    test('round-trip conversion with null values in data', () {
      final originalData = Data(legalName: null, message: null, status: null);

      final originalModel = GetGstDetailsModel(success: null, data: originalData);

      // Convert to JSON and back
      final json = originalModel.toJson();
      final reconstructedModel = GetGstDetailsModel.fromJson(json);

      // Verify null values are preserved
      expect(reconstructedModel.success, isNull);
      expect(reconstructedModel.data, isNotNull);
      expect(reconstructedModel.data!.legalName, isNull);
      expect(reconstructedModel.data!.message, isNull);
      expect(reconstructedModel.data!.status, isNull);
    });

    test('handles JSON with additional unexpected fields', () {
      final json = {
        'success': true,
        'data': {
          'legal_name': 'Test Company',
          'message': 'Test message',
          'status': 'active',
          'unexpected_field': 'should_be_ignored',
          'another_field': 123,
        },
        'extra_field': 'ignored',
      };

      final model = GetGstDetailsModel.fromJson(json);

      expect(model.success, isTrue);
      expect(model.data!.legalName, equals('Test Company'));
      expect(model.data!.message, equals('Test message'));
      expect(model.data!.status, equals('active'));

      // toJson should only include expected fields
      final convertedJson = model.toJson();
      expect(convertedJson.keys.length, equals(2)); // success and data
      expect(convertedJson['data'].keys.length, equals(3)); // legal_name, message, status
    });

    test('maintains consistency across multiple operations', () {
      const legalName = 'Consistency Test Company';
      const message = 'Consistency test message';
      const status = 'active';

      // Create model
      final model1 = GetGstDetailsModel(
        success: true,
        data: Data(legalName: legalName, message: message, status: status),
      );

      // Convert to JSON
      final json1 = model1.toJson();

      // Create from JSON
      final model2 = GetGstDetailsModel.fromJson(json1);

      // Convert to JSON again
      final json2 = model2.toJson();

      // Create from JSON again
      final model3 = GetGstDetailsModel.fromJson(json2);

      // All should be equal
      expect(model1.success, equals(model2.success));
      expect(model2.success, equals(model3.success));
      expect(model1.data!.legalName, equals(model2.data!.legalName));
      expect(model2.data!.legalName, equals(model3.data!.legalName));
      expect(json1, equals(json2));
    });
  });
}
