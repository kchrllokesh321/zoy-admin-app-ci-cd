import 'package:flutter_test/flutter_test.dart';
import 'package:exchek/models/personal_user_models/aadhar_verify_otp_model.dart';

void main() {
  group('AadharOTPVerifyModel', () {
    // =============================================================================
    // CONSTRUCTOR TESTS
    // =============================================================================

    group('Constructor', () {
      test('should create instance with all required fields', () {
        // Arrange
        final address = AadharAddress(
          country: 'India',
          district: 'Mumbai',
          state: 'Maharashtra',
          postOffice: 'Andheri',
          locality: 'Andheri West',
          vtc: 'Mumbai',
          subDistrict: 'Mumbai Suburban',
          street: '123 Main Street',
          house: 'A-101',
          landmark: 'Near Metro Station',
        );

        final data = AadharData(
          address: address,
          name: 'John Doe',
          dateOfBirth: '01-01-1990',
          gender: 'M',
          maskedNumber: '****-****-1234',
          phone: '+91-9876543210',
          email: 'john@example.com',
          photo: '/9j/4AAQSkZJRgABAQEAYABgAAD...',
          generatedAt: '2023-01-01T00:00:00Z',
        );

        // Act
        final model = AadharOTPVerifyModel(
          code: 200,
          timestamp: 1640995200,
          transactionId: 'txn_123456789',
          subCode: 'SUCCESS',
          message: 'OTP verified successfully',
          data: data,
        );

        // Assert
        expect(model.code, equals(200));
        expect(model.timestamp, equals(1640995200));
        expect(model.transactionId, equals('txn_123456789'));
        expect(model.subCode, equals('SUCCESS'));
        expect(model.message, equals('OTP verified successfully'));
        expect(model.data, equals(data));
        expect(model.data!.name, equals('John Doe'));
        expect(model.data!.address?.country, equals('India'));
      });

      test('should create instance with null data', () {
        // Act
        final model = AadharOTPVerifyModel(
          code: 400,
          timestamp: 1640995300,
          transactionId: 'txn_error',
          subCode: 'ERROR',
          message: 'Invalid OTP',
          data: null,
        );

        // Assert
        expect(model.code, equals(400));
        expect(model.timestamp, equals(1640995300));
        expect(model.transactionId, equals('txn_error'));
        expect(model.subCode, equals('ERROR'));
        expect(model.message, equals('Invalid OTP'));
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
          'code': 200,
          'timestamp': 1640995200,
          'transaction_id': 'txn_123456789',
          'sub_code': 'SUCCESS',
          'message': 'OTP verified successfully',
          'data': {
            'name': 'John Doe',
            'date_of_birth': '01-01-1990',
            'gender': 'M',
            'masked_number': '****-****-1234',
            'phone': '+91-9876543210',
            'email': 'john@example.com',
            'photo': '/9j/4AAQSkZJRgABAQEAYABgAAD...',
            'generated_at': '2023-01-01T00:00:00Z',
            'address': {
              'country': 'India',
              'district': 'Mumbai',
              'state': 'Maharashtra',
              'post_office': 'Andheri',
              'locality': 'Andheri West',
              'vtc': 'Mumbai',
              'sub_district': 'Mumbai Suburban',
              'street': '123 Main Street',
              'house': 'A-101',
              'landmark': 'Near Metro Station',
              'pin': '400053',
              'care_of': 'S/O John Smith',
            },
          },
        };

        // Act
        final model = AadharOTPVerifyModel.fromJson(json);

        // Assert
        expect(model.code, equals(200));
        expect(model.timestamp, equals(1640995200));
        expect(model.transactionId, equals('txn_123456789'));
        expect(model.subCode, equals('SUCCESS'));
        expect(model.message, equals('OTP verified successfully'));
        expect(model.data!.name, equals('John Doe'));
        expect(model.data!.dateOfBirth, equals('01-01-1990'));
        expect(model.data!.gender, equals('M'));
        expect(model.data!.maskedNumber, equals('****-****-1234'));
        expect(model.data!.address?.country, equals('India'));
        expect(model.data!.address?.state, equals('Maharashtra'));
        expect(model.data!.address?.district, equals('Mumbai'));
        expect(model.data!.address?.pin, equals('400053'));
      });

      test('should create instance from JSON with minimal address data', () {
        // Arrange
        final json = {
          'code': 200,
          'timestamp': 1640995200,
          'transaction_id': 'txn_minimal',
          'sub_code': 'SUCCESS',
          'message': 'OTP verified',
          'data': {
            'name': 'Jane Doe',
            'date_of_birth': '15-05-1985',
            'gender': 'F',
            'address': {'country': 'India', 'state': 'Karnataka'},
          },
        };

        // Act
        final model = AadharOTPVerifyModel.fromJson(json);

        // Assert
        expect(model.data!.name, equals('Jane Doe'));
        expect(model.data!.gender, equals('F'));
        expect(model.data!.address?.country, equals('India'));
        expect(model.data!.address?.state, equals('Karnataka'));
        expect(model.data!.address?.district, isNull);
        expect(model.data!.address?.postOffice, isNull);
      });

      test('should create instance from JSON without data', () {
        // Arrange
        final json = {
          'code': 400,
          'timestamp': 1640995300,
          'transaction_id': 'txn_error',
          'sub_code': 'INVALID_OTP',
          'message': 'The provided OTP is invalid',
          'data': null,
        };

        // Act
        final model = AadharOTPVerifyModel.fromJson(json);

        // Assert
        expect(model.code, equals(400));
        expect(model.subCode, equals('INVALID_OTP'));
        expect(model.message, equals('The provided OTP is invalid'));
        expect(model.data, isNull);
      });
    });
  });

  // =============================================================================
  // AADHAR DATA CLASS TESTS
  // =============================================================================

  group('AadharData', () {
    group('Constructor', () {
      test('should create instance with required address', () {
        // Arrange
        final address = AadharAddress(country: 'India');

        // Act
        final data = AadharData(address: address);

        // Assert
        expect(data.address, equals(address));
        expect(data.name, isNull);
        expect(data.dateOfBirth, isNull);
        expect(data.gender, isNull);
        expect(data.phone, isNull);
        expect(data.email, isNull);
        expect(data.photo, isNull);
        expect(data.maskedNumber, isNull);
        expect(data.generatedAt, isNull);
      });

      test('should create instance with all fields', () {
        // Arrange
        final address = AadharAddress(country: 'India', state: 'Tamil Nadu', district: 'Chennai');

        // Act
        final data = AadharData(
          address: address,
          name: 'Test User',
          dateOfBirth: '01-01-1990',
          gender: 'M',
          phone: '+91-9876543210',
          email: 'test@example.com',
          photo: 'base64_photo_data',
          maskedNumber: '****-****-5678',
          generatedAt: '2023-01-01T00:00:00Z',
        );

        // Assert
        expect(data.address, equals(address));
        expect(data.name, equals('Test User'));
        expect(data.dateOfBirth, equals('01-01-1990'));
        expect(data.gender, equals('M'));
        expect(data.phone, equals('+91-9876543210'));
        expect(data.email, equals('test@example.com'));
        expect(data.photo, equals('base64_photo_data'));
        expect(data.maskedNumber, equals('****-****-5678'));
        expect(data.generatedAt, equals('2023-01-01T00:00:00Z'));
      });
    });

    group('fromJson', () {
      test('should create instance from complete JSON', () {
        // Arrange
        final json = {
          'name': 'JSON User',
          'date_of_birth': '15-08-1985',
          'gender': 'F',
          'phone': '+91-9876543210',
          'email': 'json@example.com',
          'photo': 'json_photo_data',
          'masked_number': '****-****-9012',
          'generated_at': '2023-01-01T00:00:00Z',
          'address': {'country': 'India', 'state': 'Tamil Nadu', 'district': 'Chennai'},
        };

        // Act
        final data = AadharData.fromJson(json);

        // Assert
        expect(data.name, equals('JSON User'));
        expect(data.dateOfBirth, equals('15-08-1985'));
        expect(data.gender, equals('F'));
        expect(data.phone, equals('+91-9876543210'));
        expect(data.email, equals('json@example.com'));
        expect(data.photo, equals('json_photo_data'));
        expect(data.maskedNumber, equals('****-****-9012'));
        expect(data.generatedAt, equals('2023-01-01T00:00:00Z'));
        expect(data.address?.country, equals('India'));
        expect(data.address?.state, equals('Tamil Nadu'));
        expect(data.address?.district, equals('Chennai'));
      });
    });
  });

  // =============================================================================
  // AADHAR ADDRESS CLASS TESTS
  // =============================================================================

  group('AadharAddress', () {
    group('Constructor', () {
      test('should create instance with all fields', () {
        // Act
        final address = AadharAddress(
          country: 'India',
          district: 'Bangalore',
          state: 'Karnataka',
          postOffice: 'Koramangala',
          locality: 'Koramangala 4th Block',
          vtc: 'Bangalore',
          subDistrict: 'Bangalore Urban',
          street: 'Hosur Road',
          house: 'B-202',
          landmark: 'Near Forum Mall',
          pin: '560034',
          careOf: 'S/O Test User',
        );

        // Assert
        expect(address.country, equals('India'));
        expect(address.district, equals('Bangalore'));
        expect(address.state, equals('Karnataka'));
        expect(address.postOffice, equals('Koramangala'));
        expect(address.locality, equals('Koramangala 4th Block'));
        expect(address.vtc, equals('Bangalore'));
        expect(address.subDistrict, equals('Bangalore Urban'));
        expect(address.street, equals('Hosur Road'));
        expect(address.house, equals('B-202'));
        expect(address.landmark, equals('Near Forum Mall'));
        expect(address.pin, equals('560034'));
        expect(address.careOf, equals('S/O Test User'));
      });

      test('should create instance with minimal fields', () {
        // Act
        final address = AadharAddress(country: 'India');

        // Assert
        expect(address.country, equals('India'));
        expect(address.district, isNull);
        expect(address.state, isNull);
        expect(address.postOffice, isNull);
        expect(address.locality, isNull);
        expect(address.vtc, isNull);
        expect(address.subDistrict, isNull);
        expect(address.street, isNull);
        expect(address.house, isNull);
        expect(address.landmark, isNull);
        expect(address.pin, isNull);
        expect(address.careOf, isNull);
      });
    });

    group('fromJson', () {
      test('should create instance from complete JSON', () {
        // Arrange
        final json = {
          'country': 'India',
          'district': 'Chennai',
          'state': 'Tamil Nadu',
          'post_office': 'T Nagar',
          'locality': 'T Nagar',
          'vtc': 'Chennai',
          'sub_district': 'Chennai',
          'street': 'Usman Road',
          'house': 'C-301',
          'landmark': 'Near Pondy Bazaar',
          'pin': '600017',
          'care_of': 'D/O Test User',
        };

        // Act
        final address = AadharAddress.fromJson(json);

        // Assert
        expect(address.country, equals('India'));
        expect(address.district, equals('Chennai'));
        expect(address.state, equals('Tamil Nadu'));
        expect(address.postOffice, equals('T Nagar'));
        expect(address.locality, equals('T Nagar'));
        expect(address.vtc, equals('Chennai'));
        expect(address.subDistrict, equals('Chennai'));
        expect(address.street, equals('Usman Road'));
        expect(address.house, equals('C-301'));
        expect(address.landmark, equals('Near Pondy Bazaar'));
        expect(address.pin, equals('600017'));
        expect(address.careOf, equals('D/O Test User'));
      });
    });
  });
}
