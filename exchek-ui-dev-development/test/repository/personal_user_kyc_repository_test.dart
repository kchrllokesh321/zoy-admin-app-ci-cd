import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:exchek/repository/personal_user_kyc_repository.dart';
import 'package:exchek/core/utils/local_storage.dart';
import 'package:exchek/core/api_config/client/api_client.dart';
import 'package:exchek/models/auth_models/common_success_model.dart';
import 'package:exchek/models/personal_user_models/get_city_and_state_model.dart';
import 'package:exchek/models/personal_user_models/get_pan_detail_model.dart';
import 'package:exchek/models/personal_user_models/get_gst_details_model.dart';
import 'package:exchek/widgets/common_widget/app_file_upload_widget.dart';
import 'package:exchek/models/personal_user_models/aadhar_otp_model.dart';
import 'package:exchek/models/personal_user_models/aadhar_verify_otp_model.dart';
import 'package:exchek/models/personal_user_models/captcha_model.dart';
import 'package:exchek/models/personal_user_models/recaptcha_model.dart';
import 'package:exchek/models/personal_user_models/bank_account_verify_model.dart';
import 'package:exchek/models/personal_user_models/presigned_url_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:exchek/core/flavor_config/env_config.dart';
import 'package:exchek/core/enums/app_enums.dart';
import 'package:exchek/core/flavor_config/flavor_config.dart';
import 'personal_user_kyc_repository_test.mocks.dart';

@GenerateMocks([ApiClient, FileData])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    // Initialize FlavorConfig for testing
    const testBaseUrl = 'https://test-api.example.com';
    final testEnvConfig = EnvConfig(baseUrl: testBaseUrl);
    FlavorConfig.initialize(flavor: Flavor.dev, env: testEnvConfig);

    // Mock flutter_secure_storage read for user_kyc_detail used in getPanDetails
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'read') {
          final key = (methodCall.arguments as Map)['key'];
          if (key == Prefkeys.userKycDetail) {
            return jsonEncode({'user_type': 'personal'});
          }
        }
        if (methodCall.method == 'containsKey') return true;
        if (methodCall.method == 'readAll') return <String, String>{};
        return null;
      },
    );
  });

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
      null,
    );
  });

  late MockApiClient mockApiClient;
  late PersonalUserKycRepository repository;
  late FileData mockFileData;

  setUp(() {
    mockApiClient = MockApiClient();
    repository = PersonalUserKycRepository(apiClient: mockApiClient);
    mockFileData = MockFileData();
  });

  group('Constructor', () {
    test('should create PersonalUserKycRepository with required dependencies', () {
      // Arrange & Act
      final repo = PersonalUserKycRepository(apiClient: mockApiClient);

      // Assert
      expect(repo, isNotNull);
      expect(repo.apiClient, equals(mockApiClient));
    });
  });

  group('uploadPersonalKyc', () {
    test('success', () async {
      when(
        mockApiClient.request(any, any, multipartData: anyNamed('multipartData')),
      ).thenAnswer((_) async => <String, dynamic>{'success': true});
      final result = await repository.uploadPersonalKyc(
        userID: '1',
        documentType: 'PAN',
        documentNumber: 'ABCDE1234F',
        nameOnPan: 'Test User',
        documentFrontImage: mockFileData,
        userType: "personal",
      );
      expect(result, isA<CommonSuccessModel>());
    });

    test('success without back document for non-Aadhaar card', () async {
      when(
        mockApiClient.request(any, any, multipartData: anyNamed('multipartData')),
      ).thenAnswer((_) async => <String, dynamic>{'success': true});
      final result = await repository.uploadPersonalKyc(
        userID: '1',
        documentType: 'PAN',
        documentNumber: 'ABCDE1234F',
        nameOnPan: 'Test User',
        documentFrontImage: mockFileData,
        userType: 'personal',
        kycRole: 'primary',
      );
      expect(result, isA<CommonSuccessModel>());
    });

    test('success with kycRole parameter', () async {
      when(
        mockApiClient.request(any, any, multipartData: anyNamed('multipartData')),
      ).thenAnswer((_) async => <String, dynamic>{'success': true});
      final result = await repository.uploadPersonalKyc(
        userID: '1',
        documentType: 'PASSPORT',
        documentNumber: 'A1234567',
        nameOnPan: 'Test User',
        documentFrontImage: mockFileData,
        userType: 'business',
        kycRole: 'secondary',
      );
      expect(result, isA<CommonSuccessModel>());
    });

    test('throws error', () async {
      when(mockApiClient.request(any, any, multipartData: anyNamed('multipartData'))).thenThrow(Exception('error'));
      expect(
        () => repository.uploadPersonalKyc(
          userID: '1',
          documentType: 'PAN',
          documentNumber: 'ABCDE1234F',
          nameOnPan: 'Test User',
          documentFrontImage: mockFileData,
          userType: 'personal',
        ),
        throwsException,
      );
    });
  });

  group('generateCaptcha', () {
    test('success', () async {
      when(mockApiClient.request(any, any)).thenAnswer((_) async => <String, dynamic>{'captcha': '1234'});
      final result = await repository.generateCaptcha(
        userID: 'u',
        aadhaarNumber: '1234',
        userType: 'personal',
        kycRole: 'primary',
      );
      expect(result, isA<CaptchaModel>());
    });
    test('throws error', () async {
      when(mockApiClient.request(any, any)).thenThrow(Exception('error'));
      expect(
        repository.generateCaptcha(userID: 'u', aadhaarNumber: '1234', userType: 'personal', kycRole: 'primary'),
        throwsException,
      );
    });
  });

  group('reGenerateCaptcha', () {
    test('success', () async {
      when(mockApiClient.request(any, any)).thenAnswer(
        (_) async => {
          'timestamp': 1234567890,
          'transaction_id': 'txn123',
          'data': {'captcha': 'abcd'},
          'code': 200,
        },
      );
      final result = await repository.reGenerateCaptcha(sessionId: 'session');
      expect(result, isA<RecaptchaModel>());
    });
    test('throws error', () async {
      when(mockApiClient.request(any, any)).thenThrow(Exception('error'));
      expect(repository.reGenerateCaptcha(sessionId: 'session'), throwsException);
    });
  });

  group('generateAadharOTP', () {
    test('success', () async {
      when(mockApiClient.request(any, any, data: anyNamed('data'))).thenAnswer(
        (_) async => {
          'code': 200,
          'timestamp': 1234567890,
          'transaction_id': 'txn123',
          'sub_code': 'sub1',
          'message': 'OTP sent',
        },
      );
      final result = await repository.generateAadharOTP(
        aadhaarNumber: '123412341234',
        captcha: 'abcd',
        sessionId: 'session',
      );
      expect(result, isA<AadharOTPSendModel>());
    });
    test('throws error', () async {
      when(mockApiClient.request(any, any, data: anyNamed('data'))).thenThrow(Exception('error'));
      expect(
        repository.generateAadharOTP(aadhaarNumber: '123412341234', captcha: 'abcd', sessionId: 'session'),
        throwsException,
      );
    });
  });

  group('validateAadharOtp', () {
    test('success', () async {
      when(mockApiClient.request(any, any, data: anyNamed('data'))).thenAnswer(
        (_) async => {
          'code': 200,
          'timestamp': 1234567890,
          'transaction_id': 'txn123',
          'sub_code': 'sub1',
          'message': 'OTP verified',
          'data': {
            'address': {
              'care_of': 'c/o',
              'country': 'IN',
              'district': 'Dist',
              'house': '123',
              'landmark': 'Landmark',
              'locality': 'Local',
              'pin': '123456',
              'post_office': 'PO',
              'state': 'State',
              'street': 'Street',
              'sub_district': 'SubDist',
              'vtc': 'VTC',
            },
            'date_of_birth': '1990-01-01',
            'email': 'test@email.com',
            'gender': 'M',
            'generated_at': 'now',
            'masked_number': 'XXXX1234',
            'name': 'Test Name',
            'phone': '9999999999',
            'photo': 'base64',
          },
        },
      );
      final result = await repository.validateAadharOtp(
        faker: true,
        otp: '123456',
        sessionId: 'session',
        userId: '1',
        userType: 'personal',
        aadhaarNumber: '1234',
      );
      expect(result, isA<AadharOTPVerifyModel>());
    });

    test('success with faker false', () async {
      when(mockApiClient.request(any, any, data: anyNamed('data'))).thenAnswer(
        (_) async => {
          'code': 200,
          'timestamp': 1234567890,
          'transaction_id': 'txn123',
          'sub_code': 'sub1',
          'message': 'OTP verified',
          'data': {
            'address': {
              'care_of': 'c/o',
              'country': 'IN',
              'district': 'Dist',
              'house': '123',
              'landmark': 'Landmark',
              'locality': 'Local',
              'pin': '123456',
              'post_office': 'PO',
              'state': 'State',
              'street': 'Street',
              'sub_district': 'SubDist',
              'vtc': 'VTC',
            },
            'date_of_birth': '1990-01-01',
            'email': 'test@email.com',
            'gender': 'F',
            'generated_at': 'now',
            'masked_number': 'XXXX5678',
            'name': 'Test Name Female',
            'phone': '8888888888',
            'photo': 'base64data',
          },
        },
      );
      final result = await repository.validateAadharOtp(
        faker: false,
        otp: '654321',
        sessionId: 'session2',
        userId: '2',
        userType: 'personal',
        aadhaarNumber: '1234',
      );
      expect(result, isA<AadharOTPVerifyModel>());
    });

    test('throws error', () async {
      when(mockApiClient.request(any, any, data: anyNamed('data'))).thenThrow(Exception('error'));
      expect(
        repository.validateAadharOtp(
          faker: true,
          otp: '123456',
          sessionId: 'session',
          userId: '1',
          userType: 'personal',
          aadhaarNumber: '1234',
        ),
        throwsException,
      );
    });
  });

  group('getPanDetails', () {
    test('success', () async {
      when(mockApiClient.request(any, any, data: anyNamed('data'), isShowToast: anyNamed('isShowToast'))).thenAnswer(
        (_) async => {
          'success': true,
          'data': {
            '@entity': 'entity',
            'pan': 'ABCDE1234F',
            'full_name': 'Test User',
            'status': 'Active',
            'category': 'Individual',
            'name_information': {'pan_name_cleaned': 'Test User'},
          },
        },
      );
      final result = await repository.getPanDetails(panNumber: 'ABCDE1234F', userId: '123', kycRole: '');
      expect(result, isA<GetPanDetailModel>());
      expect(result.success, isTrue);
      expect(result.data?.pan, equals('ABCDE1234F'));
      expect(result.data?.fullName, equals('Test User'));
      expect(result.data?.status, equals('Active'));
      expect(result.data?.category, equals('Individual'));
      expect(result.data?.nameInformation?.panNameCleaned, equals('Test User'));
    });

    test('throws error', () async {
      when(
        mockApiClient.request(any, any, data: anyNamed('data'), isShowToast: anyNamed('isShowToast')),
      ).thenThrow(Exception('error'));
      expect(repository.getPanDetails(panNumber: 'ABCDE1234F', userId: '123', kycRole: ''), throwsException);
    });
  });

  group('getCityAndState', () {
    test('success', () async {
      when(mockApiClient.request(any, any)).thenAnswer(
        (_) async => {
          'success': true,
          'data': {'city': 'TestCity', 'state': 'TestState'},
        },
      );
      final result = await repository.getCityAndState(pincode: '123456');
      expect(result, isA<GetCityAndStateModel>());
    });
    test('throws error', () async {
      when(mockApiClient.request(any, any)).thenThrow(Exception('error'));
      expect(repository.getCityAndState(pincode: '123456'), throwsException);
    });
  });

  group('uploadResidentialAddressDetails', () {
    test('success', () async {
      when(
        mockApiClient.request(any, any, multipartData: anyNamed('multipartData')),
      ).thenAnswer((_) async => <String, dynamic>{'success': true});
      final result = await repository.uploadResidentialAddressDetails(
        userID: '1',
        userType: 'personal',
        country: 'IN',
        pinCode: '123456',
        state: 'TestState',
        city: 'TestCity',
        addressLine1: 'Line1',
        addressLine2: 'Line2',
        documentType: 'AADHAAR',
        documentFrontImage: mockFileData,
        documentBackImage: mockFileData,
        isAddharCard: true,
        aadhaarUsedAsIdentity: 'yes',
      );
      expect(result, isA<CommonSuccessModel>());
    });

    test('success without optional parameters', () async {
      when(
        mockApiClient.request(any, any, multipartData: anyNamed('multipartData')),
      ).thenAnswer((_) async => <String, dynamic>{'success': true});
      final result = await repository.uploadResidentialAddressDetails(
        userID: '1',
        userType: 'business',
        country: 'US',
        pinCode: '10001',
        state: 'New York',
        city: 'New York City',
        addressLine1: '123 Main Street',
        addressLine2: null,
        documentType: 'UTILITY_BILL',
        documentFrontImage: null,
        documentBackImage: null,
        isAddharCard: false,
        aadhaarUsedAsIdentity: 'no',
      );
      expect(result, isA<CommonSuccessModel>());
    });

    test('throws error', () async {
      when(mockApiClient.request(any, any, multipartData: anyNamed('multipartData'))).thenThrow(Exception('error'));
      expect(
        repository.uploadResidentialAddressDetails(
          userID: '1',
          userType: 'personal',
          country: 'IN',
          pinCode: '123456',
          state: 'TestState',
          city: 'TestCity',
          addressLine1: 'Line1',
          addressLine2: 'Line2',
          documentType: 'AADHAAR',
          documentFrontImage: mockFileData,
          documentBackImage: mockFileData,
          isAddharCard: true,
          aadhaarUsedAsIdentity: 'yes',
        ),
        throwsException,
      );
    });
  });

  group('getGSTDetails', () {
    test('success', () async {
      when(mockApiClient.request(any, any, data: anyNamed('data'))).thenAnswer(
        (_) async => {
          'success': true,
          'data': {'legal_name': 'Test Company', 'message': 'GST details found', 'status': 'Active'},
        },
      );
      final result = await repository.getGSTDetails(
        userID: '1',
        estimatedAnnualIncome: '1000000',
        gstNumber: '12ABCDE3456F7Z8',
      );
      expect(result, isA<GetGstDetailsModel>());
      expect(result.success, isTrue);
      expect(result.data?.legalName, equals('Test Company'));
      expect(result.data?.message, equals('GST details found'));
      expect(result.data?.status, equals('Active'));
    });

    test('throws error', () async {
      when(mockApiClient.request(any, any, data: anyNamed('data'))).thenThrow(Exception('error'));
      expect(
        repository.getGSTDetails(userID: '1', estimatedAnnualIncome: '1000000', gstNumber: '12ABCDE3456F7Z8'),
        throwsException,
      );
    });
  });

  group('uploadGSTDocument', () {
    test('success', () async {
      when(
        mockApiClient.request(any, any, multipartData: anyNamed('multipartData')),
      ).thenAnswer((_) async => <String, dynamic>{'success': true});
      final result = await repository.uploadGSTDocument(
        userID: '1',
        gstNumber: '12ABCDE3456F7Z8',
        userType: 'business',
        gstCertificate: mockFileData,
      );
      expect(result, isA<CommonSuccessModel>());
    });

    test('success with null gstCertificate', () async {
      when(
        mockApiClient.request(any, any, multipartData: anyNamed('multipartData')),
      ).thenAnswer((_) async => <String, dynamic>{'success': true});
      final result = await repository.uploadGSTDocument(
        userID: '2',
        gstNumber: '29BBBBB1111B2Z6',
        userType: 'business',
        gstCertificate: null,
      );
      expect(result, isA<CommonSuccessModel>());
    });

    test('throws error', () async {
      when(mockApiClient.request(any, any, multipartData: anyNamed('multipartData'))).thenThrow(Exception('error'));
      expect(
        repository.uploadGSTDocument(
          userID: '1',
          gstNumber: '12ABCDE3456F7Z8',
          userType: 'business',
          gstCertificate: mockFileData,
        ),
        throwsException,
      );
    });
  });

  group('uploadBusinessLegalDocuments', () {
    test('success', () async {
      when(
        mockApiClient.request(any, any, multipartData: anyNamed('multipartData')),
      ).thenAnswer((_) async => <String, dynamic>{'success': true});
      final result = await repository.uploadBusinessLegalDocuments(
        userID: '1',
        userType: 'business',
        documentType: 'INCORPORATION_CERTIFICATE',
        documentNumber: 'INC123456',
        documentFrontImage: mockFileData,
      );
      expect(result, isA<CommonSuccessModel>());
    });

    test('success with all optional parameters', () async {
      when(
        mockApiClient.request(any, any, multipartData: anyNamed('multipartData')),
      ).thenAnswer((_) async => <String, dynamic>{'success': true});
      final result = await repository.uploadBusinessLegalDocuments(
        userID: '2',
        userType: 'business',
        documentType: 'MOA',
        documentNumber: 'MOA789012',
        documentFrontImage: mockFileData,
        documentbackImage: mockFileData,
      );
      expect(result, isA<CommonSuccessModel>());
    });

    test('success with null optional parameters', () async {
      when(
        mockApiClient.request(any, any, multipartData: anyNamed('multipartData')),
      ).thenAnswer((_) async => <String, dynamic>{'success': true});
      final result = await repository.uploadBusinessLegalDocuments(
        userID: '3',
        userType: 'business',
        documentType: 'PARTNERSHIP_DEED',
        documentNumber: null,
        documentFrontImage: null,
        documentbackImage: null,
      );
      expect(result, isA<CommonSuccessModel>());
    });

    test('throws error', () async {
      when(mockApiClient.request(any, any, multipartData: anyNamed('multipartData'))).thenThrow(Exception('error'));
      expect(
        repository.uploadBusinessLegalDocuments(
          userID: '1',
          userType: 'business',
          documentType: 'INCORPORATION_CERTIFICATE',
          documentNumber: 'INC123456',
          documentFrontImage: mockFileData,
        ),
        throwsException,
      );
    });
  });

  group('verifyBankAccount', () {
    test('success', () async {
      when(mockApiClient.request(any, any, data: anyNamed('data'))).thenAnswer(
        (_) async => {
          'success': true,
          'data': {
            'account_holder_name': 'John Doe',
            'message': 'Bank account verified successfully',
            'status': 'verified',
          },
        },
      );
      final result = await repository.verifyBankAccount(
        accountNumber: '1234567890',
        ifscCode: 'HDFC0001234',
        userID: '1',
        userType: 'personal',
      );
      expect(result, isA<BankAccountVerifyModel>());
      expect(result.success, isTrue);
      expect(result.data?.accountHolderName, equals('John Doe'));
      expect(result.data?.message, equals('Bank account verified successfully'));
      expect(result.data?.status, equals('verified'));
    });

    test('throws error', () async {
      when(mockApiClient.request(any, any, data: anyNamed('data'))).thenThrow(Exception('error'));
      expect(
        repository.verifyBankAccount(
          accountNumber: '1234567890',
          ifscCode: 'HDFC0001234',
          userID: '1',
          userType: 'personal',
        ),
        throwsException,
      );
    });
  });

  group('uploadBankDocuments', () {
    test('success', () async {
      when(
        mockApiClient.request(any, any, multipartData: anyNamed('multipartData')),
      ).thenAnswer((_) async => <String, dynamic>{'success': true});
      final result = await repository.uploadBankDocuments(
        userID: '1',
        userType: 'personal',
        accountNumber: '1234567890',
        ifscCode: 'HDFC0001234',
        documentType: 'BANK_STATEMENT',
        proofDocumentImage: mockFileData,
      );
      expect(result, isA<CommonSuccessModel>());
    });

    test('throws error', () async {
      when(mockApiClient.request(any, any, multipartData: anyNamed('multipartData'))).thenThrow(Exception('error'));
      expect(
        repository.uploadBankDocuments(
          userID: '1',
          userType: 'personal',
          accountNumber: '1234567890',
          ifscCode: 'HDFC0001234',
          documentType: 'BANK_STATEMENT',
          proofDocumentImage: mockFileData,
        ),
        throwsException,
      );
    });
  });

  group('getPresignedUrl', () {
    test('success', () async {
      when(
        mockApiClient.request(any, any, data: anyNamed('data')),
      ).thenAnswer((_) async => {'url': 'https://s3.amazonaws.com/bucket/file.jpg?signature=abc123'});
      final result = await repository.getPresignedUrl(urlPath: 'documents/kyc/file.jpg');
      expect(result, isA<PresignedUrlModel>());
      expect(result.url, equals('https://s3.amazonaws.com/bucket/file.jpg?signature=abc123'));
    });

    test('throws error', () async {
      when(mockApiClient.request(any, any, data: anyNamed('data'))).thenThrow(Exception('error'));
      expect(repository.getPresignedUrl(urlPath: 'documents/kyc/file.jpg'), throwsException);
    });
  });

  group('uploadPanDetails', () {
    test('success with all params', () async {
      when(
        mockApiClient.request(any, any, multipartData: anyNamed('multipartData')),
      ).thenAnswer((_) async => <String, dynamic>{'success': true});

      final result = await repository.uploadPanDetails(
        userID: 'U1',
        userType: 'personal',
        kycRole: 'primary',
        panNumber: 'ABCDE1234F',
        nameOnPan: 'Test User',
        isBeneficialOwnerisBeneficialOwner: 'yes',
        isBusinessRepresentative: 'no',
        panDoc: mockFileData,
      );

      expect(result, isA<CommonSuccessModel>());
    });

    test('success with minimal params', () async {
      when(
        mockApiClient.request(any, any, multipartData: anyNamed('multipartData')),
      ).thenAnswer((_) async => <String, dynamic>{'success': true});

      final result = await repository.uploadPanDetails(
        userID: 'U2',
        userType: 'business',
        kycRole: null,
        panNumber: 'AAAAA9999A',
        nameOnPan: 'Someone',
        isBeneficialOwnerisBeneficialOwner: null,
        isBusinessRepresentative: null,
        panDoc: mockFileData,
      );

      expect(result, isA<CommonSuccessModel>());
    });

    test('throws error', () async {
      when(mockApiClient.request(any, any, multipartData: anyNamed('multipartData'))).thenThrow(Exception('error'));

      expect(
        repository.uploadPanDetails(
          userID: 'U3',
          userType: 'personal',
          kycRole: 'primary',
          panNumber: 'BBBBB1111B',
          nameOnPan: 'Err User',
          isBeneficialOwnerisBeneficialOwner: 'no',
          isBusinessRepresentative: 'yes',
          panDoc: mockFileData,
        ),
        throwsException,
      );
    });
  });
}
