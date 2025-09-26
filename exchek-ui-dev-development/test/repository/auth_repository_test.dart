import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/models/auth_models/common_success_model.dart';
import 'package:exchek/models/auth_models/email_availabilty_model.dart';
import 'package:exchek/models/auth_models/login_email_register_model.dart';
import 'package:exchek/models/auth_models/mobile_availabilty_model.dart';
import 'package:exchek/models/auth_models/validate_login_otp_model.dart';
import 'package:exchek/models/auth_models/verify_email_model.dart';
import 'package:exchek/models/personal_user_models/get_currency_model.dart';
import 'package:exchek/models/personal_user_models/get_option_model.dart';
import 'package:exchek/models/auth_models/get_user_kyc_detail_model.dart';

import 'auth_repository_test.mocks.dart';

@GenerateMocks([ApiClient, OAuth2Config])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthRepository', () {
    late MockApiClient mockApiClient;
    late MockOAuth2Config mockOAuth2Config;
    late AuthRepository authRepository;

    setUpAll(() {
      // Initialize FlavorConfig for testing
      const testBaseUrl = 'https://test-api.example.com';
      final testEnvConfig = EnvConfig(baseUrl: testBaseUrl);
      FlavorConfig.initialize(flavor: Flavor.dev, env: testEnvConfig);
    });

    setUp(() {
      mockApiClient = MockApiClient();
      mockOAuth2Config = MockOAuth2Config();
      authRepository = AuthRepository(apiClient: mockApiClient, oauth2Config: mockOAuth2Config);
    });

    group('Constructor', () {
      test('should create AuthRepository with required dependencies', () {
        // Arrange & Act
        final repository = AuthRepository(apiClient: mockApiClient, oauth2Config: mockOAuth2Config);

        // Assert
        expect(repository, isNotNull);
        expect(repository.apiClient, equals(mockApiClient));
        expect(repository.oauth2Config, equals(mockOAuth2Config));
      });
    });

    group('Email Verification Methods', () {
      test('sendEmailVerificationLink should return VerifyEmailModel on success', () async {
        // Arrange
        final mockResponse = {
          'success': true,
          'data': {
            'status': true,
            'message': 'Email sent successfully',
            'email': 'test@example.com',
            'token': 'test_token',
          },
        };
        final expectedModel = VerifyEmailModel.fromJson(mockResponse);

        when(
          mockApiClient.request(
            RequestType.POST,
            ApiEndPoint.sendEmailVerificationLinkUrl,
            data: {'email': 'test@example.com', 'type': 'email_verification'},
            isShowToast: false,
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await authRepository.sendEmailVerificationLink(
          email: 'test@example.com',
          type: 'email_verification',
        );

        // Assert
        expect(result.success, expectedModel.success);
        expect(result.data?.status, expectedModel.data?.status);
        expect(result.data?.message, expectedModel.data?.message);
        expect(result.data?.email, expectedModel.data?.email);
        expect(result.data?.token, expectedModel.data?.token);
      });

      test('sendEmailVerificationLink should rethrow on error', () async {
        // Arrange
        when(
          mockApiClient.request(
            RequestType.POST,
            ApiEndPoint.sendEmailVerificationLinkUrl,
            data: {'email': 'test@example.com', 'type': 'email_verification'},
            isShowToast: false,
          ),
        ).thenThrow(Exception('API error'));

        // Act & Assert
        expect(
          () => authRepository.sendEmailVerificationLink(email: 'test@example.com', type: 'email_verification'),
          throwsException,
        );
      });

      test('resetPasswordVerificationLink should return CommonSuccessModel on success', () async {
        // Arrange
        final mockResponse = {'success': true, 'message': 'Reset link sent successfully'};
        final expectedModel = CommonSuccessModel.fromJson(mockResponse);

        when(
          mockApiClient.request(
            RequestType.POST,
            ApiEndPoint.sendEmailVerificationLinkUrl,
            data: {'email': 'test@example.com', 'type': 'forgot_password'},
            isShowToast: false,
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await authRepository.resetPasswordVerificationLink(
          email: 'test@example.com',
          type: 'forgot_password',
        );

        // Assert
        expect(result.success, expectedModel.success);
        expect(result.message, expectedModel.message);
      });

      test('resetPasswordVerificationLink should rethrow on error', () async {
        // Arrange
        when(
          mockApiClient.request(
            RequestType.POST,
            ApiEndPoint.sendEmailVerificationLinkUrl,
            data: {'email': 'test@example.com', 'type': 'forgot_password'},
            isShowToast: false,
          ),
        ).thenThrow(Exception('API error'));

        // Act & Assert
        expect(
          () => authRepository.resetPasswordVerificationLink(email: 'test@example.com', type: 'forgot_password'),
          throwsException,
        );
      });
    });

    group('OTP Methods', () {
      test('sendOtp should return CommonSuccessModel on success', () async {
        // Arrange
        final mockResponse = {'success': true, 'message': 'OTP sent successfully'};
        final expectedModel = CommonSuccessModel.fromJson(mockResponse);

        when(
          mockApiClient.request(
            RequestType.POST,
            ApiEndPoint.sendOtpUrl,
            data: {'mobile': '1234567890', 'type': 'login'},
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await authRepository.sendOtp(mobile: '1234567890', type: 'login');

        // Assert
        expect(result.success, expectedModel.success);
        expect(result.message, expectedModel.message);
      });

      test('sendOtp should rethrow on error', () async {
        // Arrange
        when(
          mockApiClient.request(
            RequestType.POST,
            ApiEndPoint.sendOtpUrl,
            data: {'mobile': '1234567890', 'type': 'login'},
          ),
        ).thenThrow(Exception('API error'));

        // Act & Assert
        expect(() => authRepository.sendOtp(mobile: '1234567890', type: 'login'), throwsException);
      });

      test('validateLoginOtp should return ValidateLoginOtpModel on success', () async {
        // Arrange
        final mockResponse = {
          'success': true,
          'data': {
            'token': 'test_token',
            'user': {'id': '123', 'email': 'test@example.com'},
          },
        };
        final expectedModel = ValidateLoginOtpModel.fromJson(mockResponse);

        when(
          mockApiClient.request(
            RequestType.POST,
            ApiEndPoint.validateLoginOtpUrl,
            data: {'mobile': '1234567890', 'otp': '123456'},
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await authRepository.validateLoginOtp(mobile: '1234567890', otp: '123456');

        // Assert
        expect(result.success, expectedModel.success);
        expect(result.data?.token, expectedModel.data?.token);
      });

      test('validateLoginOtp should rethrow on error', () async {
        // Arrange
        when(
          mockApiClient.request(
            RequestType.POST,
            ApiEndPoint.validateLoginOtpUrl,
            data: {'mobile': '1234567890', 'otp': '123456'},
          ),
        ).thenThrow(Exception('API error'));

        // Act & Assert
        expect(() => authRepository.validateLoginOtp(mobile: '1234567890', otp: '123456'), throwsException);
      });

      test('validateregistrationOtp should return CommonSuccessModel on success', () async {
        // Arrange
        final mockResponse = {'success': true, 'message': 'OTP validated successfully'};
        final expectedModel = CommonSuccessModel.fromJson(mockResponse);

        when(
          mockApiClient.request(
            RequestType.POST,
            ApiEndPoint.validateRegistrationOtpUrl,
            data: {'mobile': '1234567890', 'otp': '123456'},
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await authRepository.validateregistrationOtp(mobile: '1234567890', otp: '123456');

        // Assert
        expect(result.success, expectedModel.success);
        expect(result.message, expectedModel.message);
      });

      test('validateregistrationOtp should rethrow on error', () async {
        // Arrange
        when(
          mockApiClient.request(
            RequestType.POST,
            ApiEndPoint.validateRegistrationOtpUrl,
            data: {'mobile': '1234567890', 'otp': '123456'},
          ),
        ).thenThrow(Exception('API error'));

        // Act & Assert
        expect(() => authRepository.validateregistrationOtp(mobile: '1234567890', otp: '123456'), throwsException);
      });

      test('validateForgotPasswordOtp should return CommonSuccessModel on success', () async {
        // Arrange
        final mockResponse = {'success': true, 'message': 'OTP validated successfully'};
        final expectedModel = CommonSuccessModel.fromJson(mockResponse);

        when(
          mockApiClient.request(
            RequestType.POST,
            ApiEndPoint.validateForgotPasswordOtpUrl,
            data: {'mobile': '1234567890', 'otp': '123456'},
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await authRepository.validateForgotPasswordOtp(mobile: '1234567890', otp: '123456');

        // Assert
        expect(result.success, expectedModel.success);
        expect(result.message, expectedModel.message);
      });

      test('validateForgotPasswordOtp should rethrow on error', () async {
        // Arrange
        when(
          mockApiClient.request(
            RequestType.POST,
            ApiEndPoint.validateForgotPasswordOtpUrl,
            data: {'mobile': '1234567890', 'otp': '123456'},
          ),
        ).thenThrow(Exception('API error'));

        // Act & Assert
        expect(() => authRepository.validateForgotPasswordOtp(mobile: '1234567890', otp: '123456'), throwsException);
      });
    });

    group('Password Methods', () {
      test('updatePassword should return CommonSuccessModel on success', () async {
        // Arrange
        final mockResponse = {'success': true, 'message': 'Password updated successfully'};
        final expectedModel = CommonSuccessModel.fromJson(mockResponse);

        when(
          mockApiClient.request(
            RequestType.POST,
            ApiEndPoint.updatePasswordUrl,
            data: {
              'confirm_password': 'newpassword123',
              'email_token': 'test_token',
              'mobile_number': '1234567890',
              'new_password': 'newpassword123',
            },
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await authRepository.updatePassword(
          confirmpassword: 'newpassword123',
          email: 'test_token',
          mobilenumber: '1234567890',
          newpassword: 'newpassword123',
        );

        // Assert
        expect(result.success, expectedModel.success);
        expect(result.message, expectedModel.message);
      });

      test('updatePassword should rethrow on error', () async {
        // Arrange
        when(
          mockApiClient.request(
            RequestType.POST,
            ApiEndPoint.updatePasswordUrl,
            data: {
              'confirm_password': 'newpassword123',
              'email_token': 'test_token',
              'mobile_number': '1234567890',
              'new_password': 'newpassword123',
            },
          ),
        ).thenThrow(Exception('API error'));

        // Act & Assert
        expect(
          () => authRepository.updatePassword(
            confirmpassword: 'newpassword123',
            email: 'test_token',
            mobilenumber: '1234567890',
            newpassword: 'newpassword123',
          ),
          throwsException,
        );
      });
    });

    group('Availability Check Methods', () {
      test('emailAvailability should return EmailAvailabilityModel on success', () async {
        // Arrange
        final mockResponse = {
          'success': true,
          'data': {'exists': false, 'user': null},
        };
        final expectedModel = EmailAvailabilityModel.fromJson(mockResponse);

        when(
          mockApiClient.request(RequestType.POST, ApiEndPoint.emailavailability, data: {'email': 'test@example.com'}),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await authRepository.emailAvailability(email: 'test@example.com');

        // Assert
        expect(result.success, expectedModel.success);
        expect(result.data?.exists, expectedModel.data?.exists);
      });

      test('emailAvailability should rethrow on error', () async {
        // Arrange
        when(
          mockApiClient.request(RequestType.POST, ApiEndPoint.emailavailability, data: {'email': 'test@example.com'}),
        ).thenThrow(Exception('API error'));

        // Act & Assert
        expect(() => authRepository.emailAvailability(email: 'test@example.com'), throwsException);
      });

      test('mobileAvailability should return MobileAvailabilityModel on success', () async {
        // Arrange
        final mockResponse = {
          'success': true,
          'data': {'exists': false, 'user': null},
        };
        final expectedModel = MobileAvailabilityModel.fromJson(mockResponse);

        when(
          mockApiClient.request(
            RequestType.POST,
            ApiEndPoint.mobileavailability,
            data: {'mobile_number': '1234567890'},
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await authRepository.mobileAvailability(mobileNumber: '1234567890');

        // Assert
        expect(result.success, expectedModel.success);
        expect(result.data?.exists, expectedModel.data?.exists);
      });

      test('mobileAvailability should rethrow on error', () async {
        // Arrange
        when(
          mockApiClient.request(
            RequestType.POST,
            ApiEndPoint.mobileavailability,
            data: {'mobile_number': '1234567890'},
          ),
        ).thenThrow(Exception('API error'));

        // Act & Assert
        expect(() => authRepository.mobileAvailability(mobileNumber: '1234567890'), throwsException);
      });
    });

    group('Dropdown and Options Methods', () {
      test('getDropdownOptions should return GetDropdownOptionModel on success', () async {
        // Arrange
        final mockResponse = {
          'success': true,
          'data': {
            'id': 1,
            'freelancer': ['Engineer', 'Doctor'],
            'export_goods': ['Electronics', 'Textiles'],
            'export_services': ['IT Services', 'Consulting'],
            'created_at': '2023-01-01',
            'updated_at': '2023-01-01',
          },
        };
        final expectedModel = GetDropdownOptionModel.fromJson(mockResponse);

        when(
          mockApiClient.request(RequestType.GET, ApiEndPoint.getDropdownOptionUrl),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await authRepository.getDropdownOptions();

        // Assert
        expect(result.success, expectedModel.success);
        expect(result.data?.personal?.freelancer, expectedModel.data?.personal?.freelancer);
        expect(result.data?.business?.exportOfGoods, expectedModel.data?.business?.exportOfGoods);
        expect(result.data?.business?.exportOfGoodsServices, expectedModel.data?.business?.exportOfGoodsServices);
      });

      test('getDropdownOptions should rethrow on error', () async {
        // Arrange
        when(
          mockApiClient.request(RequestType.GET, ApiEndPoint.getDropdownOptionUrl),
        ).thenThrow(Exception('API error'));

        // Act & Assert
        expect(() => authRepository.getDropdownOptions(), throwsException);
      });

      test('getCurrencyOptions should return GetCurrencyOptionModel on success', () async {
        // Arrange
        final mockResponse = {
          'success': true,
          'data': {
            'id': 1,
            'estimated_monthly_volume': ['10000', '50000'],
            'multicurrency': ['USD', 'EUR'],
            'created_at': '2023-01-01',
            'updated_at': '2023-01-01',
          },
        };
        final expectedModel = GetCurrencyOptionModel.fromJson(mockResponse);

        when(
          mockApiClient.request(RequestType.GET, ApiEndPoint.getCurrencyOptionUrl),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await authRepository.getCurrencyOptions();

        // Assert
        expect(result.success, expectedModel.success);
        expect(result.data?.estimatedMonthlyVolume, expectedModel.data?.estimatedMonthlyVolume);
        expect(result.data?.multicurrency, expectedModel.data?.multicurrency);
      });

      test('getCurrencyOptions should rethrow on error', () async {
        // Arrange
        when(
          mockApiClient.request(RequestType.GET, ApiEndPoint.getCurrencyOptionUrl),
        ).thenThrow(Exception('API error'));

        // Act & Assert
        expect(() => authRepository.getCurrencyOptions(), throwsException);
      });
    });

    group('Login and Registration Methods', () {
      test('loginuser should return LoginEmailPasswordModel on success', () async {
        // Arrange
        final mockResponse = {
          'success': true,
          'data': {
            'token': 'test_token',
            'user': {'id': '123', 'email': 'test@example.com'},
          },
        };
        final expectedModel = LoginEmailPasswordModel.fromJson(mockResponse);

        when(
          mockApiClient.request(
            RequestType.POST,
            ApiEndPoint.loginurl,
            data: {'email': 'test@example.com', 'password': 'password123'},
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await authRepository.loginuser(email: 'test@example.com', password: 'password123');

        // Assert
        expect(result.success, expectedModel.success);
        expect(result.data?.token, expectedModel.data?.token);
      });

      test('loginuser should rethrow on error', () async {
        // Arrange
        when(
          mockApiClient.request(
            RequestType.POST,
            ApiEndPoint.loginurl,
            data: {'email': 'test@example.com', 'password': 'password123'},
          ),
        ).thenThrow(Exception('API error'));

        // Act & Assert
        expect(() => authRepository.loginuser(email: 'test@example.com', password: 'password123'), throwsException);
      });

      test('registerPersonalUser should return LoginEmailPasswordModel on success', () async {
        // Arrange
        final mockResponse = {
          'success': true,
          'data': {
            'token': 'test_token',
            'user': {'id': '123', 'email': 'test@example.com'},
          },
        };
        final expectedModel = LoginEmailPasswordModel.fromJson(mockResponse);
        final tosAcceptance = {'ip': '127.0.0.1', 'user_agent': 'test'};

        when(
          mockApiClient.request(
            RequestType.POST,
            ApiEndPoint.registerurl,
            data: {
              "email_token": "test@example.com",
              "estimated_monthly_volume": "10000",
              "mobile_number": "1234567890",
              "nested": {
                "payment_purpose": "Business",
                "profession": ["Engineer"],
                "product_desc": "Test description",
                "legal_full_name": "John Doe",
              },
              "password": "password123",
              "tos_acceptance": tosAcceptance,
              "user_type": "personal",
              "website": "https://example.com",
              "doing_business_as": "Test DBA",
            },
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await authRepository.registerPersonalUser(
          email: 'test@example.com',
          estimatedMonthlyVolume: '10000',
          mobileNumber: '1234567890',
          receivingreason: 'Business',
          profession: ['Engineer'],
          productDescription: 'Test description',
          legalFullName: 'John Doe',
          password: 'password123',
          tosacceptance: tosAcceptance,
          usertype: 'personal',
          website: 'https://example.com',
          doingBusinessAs: 'Test DBA',
        );

        // Assert
        expect(result.success, expectedModel.success);
        expect(result.data?.token, expectedModel.data?.token);
      });

      test('registerPersonalUser should rethrow on error', () async {
        // Arrange
        final tosAcceptance = {'ip': '127.0.0.1', 'user_agent': 'test'};

        when(
          mockApiClient.request(
            RequestType.POST,
            ApiEndPoint.registerurl,
            data: {
              "email_token": "test@example.com",
              "estimated_monthly_volume": "10000",
              "mobile_number": "1234567890",
              "nested": {
                "payment_purpose": "Business",
                "profession": ["Engineer"],
                "product_desc": "Test description",
                "legal_full_name": "John Doe",
              },
              "password": "password123",
              "tos_acceptance": tosAcceptance,
              "user_type": "personal",
              "website": "https://example.com",
              "doing_business_as": "Test DBA",
            },
          ),
        ).thenThrow(Exception('API error'));

        // Act & Assert
        expect(
          () => authRepository.registerPersonalUser(
            email: 'test@example.com',
            estimatedMonthlyVolume: '10000',
            mobileNumber: '1234567890',
            receivingreason: 'Business',
            profession: ['Engineer'],
            productDescription: 'Test description',
            legalFullName: 'John Doe',
            password: 'password123',
            tosacceptance: tosAcceptance,
            usertype: 'personal',
            website: 'https://example.com',
            doingBusinessAs: 'Test DBA',
          ),
          throwsException,
        );
      });

      test('registerBusinessUser should return LoginEmailPasswordModel on success', () async {
        // Arrange
        final mockResponse = {
          'success': true,
          'data': {
            'token': 'test_token',
            'user': {'id': '123', 'email': 'test@example.com'},
          },
        };
        final expectedModel = LoginEmailPasswordModel.fromJson(mockResponse);
        final tosAcceptance = {'ip': '127.0.0.1', 'user_agent': 'test'};

        when(
          mockApiClient.request(
            RequestType.POST,
            ApiEndPoint.registerurl,
            data: {
              "email_token": "test@example.com",
              "estimated_monthly_volume": "10000",
              "mobile_number": "1234567890",
              "nested": {
                "business_type": "Corporation",
                "business_nature": "Technology",
                "exports_type": ["Services"],
                "business_legal_name": "Test Corp",
              },
              "password": "password123",
              "tos_acceptance": tosAcceptance,
              "user_type": "business",
              "username": "Test Corp",
              "website": "https://example.com",
              "doing_business_as": "Test DBA",
            },
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await authRepository.registerBusinessUser(
          email: 'test@example.com',
          estimatedMonthlyVolume: '10000',
          mobileNumber: '1234567890',
          businesstype: 'Corporation',
          businessnature: 'Technology',
          exportstype: ['Services'],
          businesslegalname: 'Test Corp',
          password: 'password123',
          tosacceptance: tosAcceptance,
          usertype: 'business',
          username: 'Test Corp',
          website: 'https://example.com',
          doingBusinessAs: 'Test DBA',
        );

        // Assert
        expect(result.success, expectedModel.success);
        expect(result.data?.token, expectedModel.data?.token);
      });

      test('registerBusinessUser should rethrow on error', () async {
        // Arrange
        final tosAcceptance = {'ip': '127.0.0.1', 'user_agent': 'test'};

        when(
          mockApiClient.request(
            RequestType.POST,
            ApiEndPoint.registerurl,
            data: {
              "email_token": "test@example.com",
              "estimated_monthly_volume": "10000",
              "mobile_number": "1234567890",
              "nested": {
                "business_type": "Corporation",
                "business_nature": "Technology",
                "exports_type": ["Services"],
                "business_legal_name": "Test Corp",
              },
              "password": "password123",
              "tos_acceptance": tosAcceptance,
              "user_type": "business",
              "username": "Test Corp",
              "website": "https://example.com",
              "doing_business_as": "Test DBA",
            },
          ),
        ).thenThrow(Exception('API error'));

        // Act & Assert
        expect(
          () => authRepository.registerBusinessUser(
            email: 'test@example.com',
            estimatedMonthlyVolume: '10000',
            mobileNumber: '1234567890',
            businesstype: 'Corporation',
            businessnature: 'Technology',
            exportstype: ['Services'],
            businesslegalname: 'Test Corp',
            password: 'password123',
            tosacceptance: tosAcceptance,
            usertype: 'business',
            username: 'Test Corp',
            website: 'https://example.com',
            doingBusinessAs: 'Test DBA',
          ),
          throwsException,
        );
      });
    });

    group('Logout Method', () {
      test('logout should return CommonSuccessModel on success', () async {
        // Arrange
        final mockResponse = {'success': true, 'message': 'Logged out successfully'};
        final expectedModel = CommonSuccessModel.fromJson(mockResponse);

        when(
          mockApiClient.request(RequestType.POST, ApiEndPoint.logoutUrl, data: {'email': 'test@example.com'}),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await authRepository.logout(email: 'test@example.com');

        // Assert
        expect(result.success, expectedModel.success);
        expect(result.message, expectedModel.message);
      });

      test('logout should rethrow on error', () async {
        // Arrange
        when(
          mockApiClient.request(RequestType.POST, ApiEndPoint.logoutUrl, data: {'email': 'test@example.com'}),
        ).thenThrow(Exception('API error'));

        // Act & Assert
        expect(() => authRepository.logout(email: 'test@example.com'), throwsException);
      });
    });

    group('User Details Method', () {
      test('getUserDetails should return GetUserDetailModel on success', () async {
        // Arrange
        final mockResponse = {
          'success': true,
          'data': {
            'user_id': 'user123',
            'user_email': 'test@example.com',
            'user_type': 'personal',
            'mobile_number': '1234567890',
            'multicurrency': ['USD', 'EUR'],
            'estimated_monthly_volume': '10000',
            'business_details': null,
            'personal_details': {
              'legal_full_name': 'John Doe',
              'payment_purpose': 'Business',
              'product_desc': 'Test description',
              'profession': ['Engineer'],
            },
            'user_identity_documents': [],
            'user_address_documents': null,
            'user_gst_details': null,
            'user_business_legal_documents': [],
          },
        };
        final expectedModel = GetUserKycDetailsModel.fromJson(mockResponse);

        when(
          mockApiClient.request(RequestType.GET, '${ApiEndPoint.getKycDetailsUrl}user123'),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await authRepository.getKycDetails(userId: 'user123');

        // Assert
        expect(result.success, expectedModel.success);
        expect(result.data?.userId, expectedModel.data?.userId);
        expect(result.data?.userEmail, expectedModel.data?.userEmail);
        expect(result.data?.userType, expectedModel.data?.userType);
        expect(result.data?.mobileNumber, expectedModel.data?.mobileNumber);
        expect(result.data?.multicurrency, expectedModel.data?.multicurrency);
        expect(result.data?.estimatedMonthlyVolume, expectedModel.data?.estimatedMonthlyVolume);
        expect(result.data?.personalDetails?.legalFullName, expectedModel.data?.personalDetails?.legalFullName);
        expect(result.data?.personalDetails?.profession, expectedModel.data?.personalDetails?.profession);
      });

      test('getUserDetails should rethrow on error', () async {
        // Arrange
        when(
          mockApiClient.request(RequestType.GET, '${ApiEndPoint.getKycDetailsUrl}user123'),
        ).thenThrow(Exception('API error'));

        // Act & Assert
        expect(() => authRepository.getKycDetails(userId: 'user123'), throwsException);
      });

      test('getUserDetails should handle business user data correctly', () async {
        // Arrange
        final mockResponse = {
          'success': true,
          'data': {
            'user_id': 'business123',
            'user_email': 'business@example.com',
            'user_type': 'business',
            'mobile_number': '9876543210',
            'multicurrency': ['USD', 'GBP', 'EUR'],
            'estimated_monthly_volume': '50000',
            'business_details': {
              'business_type': 'Corporation',
              'business_nature': 'Technology',
              'exports_type': ['Services', 'Software'],
              'business_legal_name': 'Tech Corp Ltd',
            },
            'personal_details': null,
            'user_identity_documents': [
              {
                'document_type': 'PAN',
                'document_number': 'ABCDE1234F',
                'front_doc_url': 'https://example.com/pan.png',
                'back_doc_url': null,
                'kyc_role': 'primary',
                'name_on_pan': 'Tech Corp Ltd',
              },
            ],
            'user_address_documents': {
              'document_type': 'Utility Bill',
              'country': 'India',
              'pincode': '110001',
              'state': 'Delhi',
              'city': 'New Delhi',
              'address_line1': '123 Business Street',
              'front_doc_url': 'https://example.com/utility.png',
            },
            'user_gst_details': {
              'gst_number': '27AAAAA0000A1Z5',
              'legal_name': 'Tech Corp Ltd',
              'gst_certificate_url': 'https://example.com/gst.pdf',
              'estimated_annual_income': '6000000',
            },
            'user_business_legal_documents': [
              {
                'document_type': 'Certificate of Incorporation',
                'document_number': 'COI123456',
                'doc_url': 'https://example.com/coi.pdf',
              },
            ],
          },
        };
        final expectedModel = GetUserKycDetailsModel.fromJson(mockResponse);

        when(
          mockApiClient.request(RequestType.GET, '${ApiEndPoint.getKycDetailsUrl}business123'),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await authRepository.getKycDetails(userId: 'business123');

        // Assert
        expect(result.success, expectedModel.success);
        expect(result.data?.userId, equals('business123'));
        expect(result.data?.userType, equals('business'));
        expect(result.data?.businessDetails?.businessType, equals('Corporation'));
        expect(result.data?.businessDetails?.businessNature, equals('Technology'));
        expect(result.data?.businessDetails?.exportsType, equals(['Services', 'Software']));
        expect(result.data?.businessDetails?.businessLegalName, equals('Tech Corp Ltd'));
      });

      test('getUserDetails should handle null data response', () async {
        // Arrange
        final mockResponse = {'success': false, 'data': null};
        final expectedModel = GetUserKycDetailsModel.fromJson(mockResponse);

        when(
          mockApiClient.request(RequestType.GET, '${ApiEndPoint.getKycDetailsUrl}nonexistent'),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await authRepository.getKycDetails(userId: 'nonexistent');

        // Assert
        expect(result.success, expectedModel.success);
        expect(result.data, isNull);
      });

      test('getUserDetails should handle empty user ID', () async {
        // Arrange
        final mockResponse = {'success': false, 'data': null};

        when(
          mockApiClient.request(RequestType.GET, ApiEndPoint.getKycDetailsUrl),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await authRepository.getKycDetails(userId: '');

        // Assert
        expect(result.success, isFalse);
        expect(result.data, isNull);
      });

      test('getUserDetails should handle special characters in user ID', () async {
        // Arrange
        const specialUserId = 'user@123#test';
        final mockResponse = {
          'success': true,
          'data': {
            'user_id': specialUserId,
            'user_email': 'special@example.com',
            'user_type': 'personal',
            'mobile_number': '1111111111',
            'multicurrency': ['USD'],
            'estimated_monthly_volume': '5000',
            'business_details': null,
            'personal_details': {
              'legal_full_name': 'Special User',
              'payment_purpose': 'Testing',
              'product_desc': 'Special test',
              'profession': ['Tester'],
            },
            'user_identity_documents': [],
            'user_address_documents': null,
            'user_gst_details': null,
            'user_business_legal_documents': [],
          },
        };

        when(
          mockApiClient.request(RequestType.GET, ApiEndPoint.getKycDetailsUrl + specialUserId),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await authRepository.getKycDetails(userId: specialUserId);

        // Assert
        expect(result.success, isTrue);
        expect(result.data?.userId, equals(specialUserId));
        expect(result.data?.personalDetails?.legalFullName, equals('Special User'));
      });
    });
  });
}
