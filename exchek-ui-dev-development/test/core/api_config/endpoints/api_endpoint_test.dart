import 'package:flutter_test/flutter_test.dart';
import 'package:exchek/core/api_config/endpoints/api_endpoint.dart';
import 'package:exchek/core/flavor_config/flavor_config.dart';
import 'package:exchek/core/flavor_config/env_config.dart';
import 'package:exchek/core/enums/app_enums.dart';

void main() {
  group('ApiEndPoint Tests', () {
    setUpAll(() {
      // Initialize FlavorConfig for testing
      const testBaseUrl = 'https://test-api.example.com';
      final testEnvConfig = EnvConfig(baseUrl: testBaseUrl);
      FlavorConfig.initialize(flavor: Flavor.dev, env: testEnvConfig);
    });

    group('Base URL Tests', () {
      test('should return base URL from flavor config', () {
        // Act
        final baseUrl = ApiEndPoint.baseUrl;

        // Assert
        expect(baseUrl, isNotNull);
        expect(baseUrl, isNotEmpty);
        expect(baseUrl, equals(FlavorConfig.instance.env.baseUrl));
      });

      test('should return IP URL', () {
        // Act
        final ipUrl = ApiEndPoint.ipUrl;

        // Assert
        expect(ipUrl, isNotNull);
        expect(ipUrl, isNotEmpty);
        expect(ipUrl, equals('https://api.ipify.org?format=json'));
      });
    });

    group('Authentication Endpoints Tests', () {
      test('should return social login URL', () {
        // Act
        final socialLoginUrl = ApiEndPoint.socialLoginUrl;

        // Assert
        expect(socialLoginUrl, isNotNull);
        expect(socialLoginUrl, isNotEmpty);
        expect(socialLoginUrl, endsWith('/auth/social-login'));
        expect(socialLoginUrl, startsWith(FlavorConfig.instance.env.baseUrl));
      });

      test('should return email availability URL', () {
        // Act
        final emailAvailabilityUrl = ApiEndPoint.emailavailability;

        // Assert
        expect(emailAvailabilityUrl, isNotNull);
        expect(emailAvailabilityUrl, isNotEmpty);
        expect(emailAvailabilityUrl, endsWith('/api/v1/auth/email-availability'));
        expect(emailAvailabilityUrl, startsWith(FlavorConfig.instance.env.baseUrl));
      });

      test('should return mobile availability URL', () {
        // Act
        final mobileAvailabilityUrl = ApiEndPoint.mobileavailability;

        // Assert
        expect(mobileAvailabilityUrl, isNotNull);
        expect(mobileAvailabilityUrl, isNotEmpty);
        expect(mobileAvailabilityUrl, endsWith('/api/v1/auth/mobile-availability'));
        expect(mobileAvailabilityUrl, startsWith(FlavorConfig.instance.env.baseUrl));
      });

      test('should return login URL', () {
        // Act
        final loginUrl = ApiEndPoint.loginurl;

        // Assert
        expect(loginUrl, isNotNull);
        expect(loginUrl, isNotEmpty);
        expect(loginUrl, endsWith('/api/v1/auth/login'));
        expect(loginUrl, startsWith(FlavorConfig.instance.env.baseUrl));
      });

      test('should return register URL', () {
        // Act
        final registerUrl = ApiEndPoint.registerurl;

        // Assert
        expect(registerUrl, isNotNull);
        expect(registerUrl, isNotEmpty);
        expect(registerUrl, endsWith('/api/v1/auth/register'));
        expect(registerUrl, startsWith(FlavorConfig.instance.env.baseUrl));
      });

      test('should return update password URL', () {
        // Act
        final updatePasswordUrl = ApiEndPoint.updatePasswordUrl;

        // Assert
        expect(updatePasswordUrl, isNotNull);
        expect(updatePasswordUrl, isNotEmpty);
        expect(updatePasswordUrl, endsWith('/api/v1/auth/update-password'));
        expect(updatePasswordUrl, startsWith(FlavorConfig.instance.env.baseUrl));
      });

      test('should return logout URL', () {
        // Act
        final logoutUrl = ApiEndPoint.logoutUrl;

        // Assert
        expect(logoutUrl, isNotNull);
        expect(logoutUrl, isNotEmpty);
        expect(logoutUrl, endsWith('/api/v1/auth/logout'));
        expect(logoutUrl, startsWith(FlavorConfig.instance.env.baseUrl));
      });
    });

    group('Email Verification Endpoints Tests', () {
      test('should return send email verification link URL', () {
        // Act
        final sendEmailVerificationLinkUrl = ApiEndPoint.sendEmailVerificationLinkUrl;

        // Assert
        expect(sendEmailVerificationLinkUrl, isNotNull);
        expect(sendEmailVerificationLinkUrl, isNotEmpty);
        expect(sendEmailVerificationLinkUrl, endsWith('/api/v1/email/send-email-verification-link'));
        expect(sendEmailVerificationLinkUrl, startsWith(FlavorConfig.instance.env.baseUrl));
      });
    });

    group('OTP Endpoints Tests', () {
      test('should return send OTP URL', () {
        // Act
        final sendOtpUrl = ApiEndPoint.sendOtpUrl;

        // Assert
        expect(sendOtpUrl, isNotNull);
        expect(sendOtpUrl, isNotEmpty);
        expect(sendOtpUrl, endsWith('/api/v1/whatsapp/send_otp'));
        expect(sendOtpUrl, startsWith(FlavorConfig.instance.env.baseUrl));
      });

      test('should return validate login OTP URL', () {
        // Act
        final validateLoginOtpUrl = ApiEndPoint.validateLoginOtpUrl;

        // Assert
        expect(validateLoginOtpUrl, isNotNull);
        expect(validateLoginOtpUrl, isNotEmpty);
        expect(validateLoginOtpUrl, endsWith('/api/v1/whatsapp/validate_login_otp'));
        expect(validateLoginOtpUrl, startsWith(FlavorConfig.instance.env.baseUrl));
      });

      test('should return validate registration OTP URL', () {
        // Act
        final validateRegistrationOtpUrl = ApiEndPoint.validateRegistrationOtpUrl;

        // Assert
        expect(validateRegistrationOtpUrl, isNotNull);
        expect(validateRegistrationOtpUrl, isNotEmpty);
        expect(validateRegistrationOtpUrl, endsWith('/api/v1/whatsapp/validate_registration_otp'));
        expect(validateRegistrationOtpUrl, startsWith(FlavorConfig.instance.env.baseUrl));
      });

      test('should return validate forgot password OTP URL', () {
        // Act
        final validateForgotPasswordOtpUrl = ApiEndPoint.validateForgotPasswordOtpUrl;

        // Assert
        expect(validateForgotPasswordOtpUrl, isNotNull);
        expect(validateForgotPasswordOtpUrl, isNotEmpty);
        expect(validateForgotPasswordOtpUrl, endsWith('/api/v1/whatsapp/validate_forgot_otp'));
        expect(validateForgotPasswordOtpUrl, startsWith(FlavorConfig.instance.env.baseUrl));
      });
    });

    group('Dropdown Options Endpoints Tests', () {
      test('should return get dropdown options URL', () {
        // Act
        final getDropdownOptionUrl = ApiEndPoint.getDropdownOptionUrl;

        // Assert
        expect(getDropdownOptionUrl, isNotNull);
        expect(getDropdownOptionUrl, isNotEmpty);
        expect(getDropdownOptionUrl, endsWith('/api/v1/dropdown-options/get-user-service-options'));
        expect(getDropdownOptionUrl, startsWith(FlavorConfig.instance.env.baseUrl));
      });

      test('should return get currency options URL', () {
        // Act
        final getCurrencyOptionUrl = ApiEndPoint.getCurrencyOptionUrl;

        // Assert
        expect(getCurrencyOptionUrl, isNotNull);
        expect(getCurrencyOptionUrl, isNotEmpty);
        expect(getCurrencyOptionUrl, endsWith('/api/v1/dropdown-options/get-currency-options'));
        expect(getCurrencyOptionUrl, startsWith(FlavorConfig.instance.env.baseUrl));
      });
    });

    group('KYC and Upload Endpoints Tests', () {
      test('should return upload personal KYC URL', () {
        // Act
        final uploadPersonalKycUrl = ApiEndPoint.uploadPersonalKycUrl;

        // Assert
        expect(uploadPersonalKycUrl, isNotNull);
        expect(uploadPersonalKycUrl, isNotEmpty);
        expect(uploadPersonalKycUrl, endsWith('/api/v1/upload/personal-kyc'));
        expect(uploadPersonalKycUrl, startsWith(FlavorConfig.instance.env.baseUrl));
      });

      test('should return GST document URL', () {
        // Act
        final gstDocumentUrl = ApiEndPoint.gstDocumentUrl;

        // Assert
        expect(gstDocumentUrl, isNotNull);
        expect(gstDocumentUrl, isNotEmpty);
        expect(gstDocumentUrl, endsWith('/api/v1/upload/gst-document'));
        expect(gstDocumentUrl, startsWith(FlavorConfig.instance.env.baseUrl));
      });

      test('should return business legal documents URL', () {
        // Act
        final businessLegalDocuments = ApiEndPoint.businessLegalDocuments;

        // Assert
        expect(businessLegalDocuments, isNotNull);
        expect(businessLegalDocuments, isNotEmpty);
        expect(businessLegalDocuments, endsWith('/api/v1/upload/business-legal-documents'));
        expect(businessLegalDocuments, startsWith(FlavorConfig.instance.env.baseUrl));
      });

      test('should return upload bank document URL', () {
        // Act
        final uploadBankDocumentUrl = ApiEndPoint.uploadBankDocumentUrl;

        // Assert
        expect(uploadBankDocumentUrl, isNotNull);
        expect(uploadBankDocumentUrl, isNotEmpty);
        expect(uploadBankDocumentUrl, endsWith('/api/v1/upload/bank-document'));
        expect(uploadBankDocumentUrl, startsWith(FlavorConfig.instance.env.baseUrl));
      });

      test('should return upload residential address details URL', () {
        // Act
        final uploadResidentialAddressDetailsUrl = ApiEndPoint.uploadResidentialAddressDetailsUrl;

        // Assert
        expect(uploadResidentialAddressDetailsUrl, isNotNull);
        expect(uploadResidentialAddressDetailsUrl, isNotEmpty);
        expect(uploadResidentialAddressDetailsUrl, endsWith('/api/v1/upload/residential-address-details'));
        expect(uploadResidentialAddressDetailsUrl, startsWith(FlavorConfig.instance.env.baseUrl));
      });

      test('should return presigned URL', () {
        // Act
        final presignedUrl = ApiEndPoint.presignedUrl;

        // Assert
        expect(presignedUrl, isNotNull);
        expect(presignedUrl, isNotEmpty);
        expect(presignedUrl, endsWith('/api/v1/upload/presigned-url'));
        expect(presignedUrl, startsWith(FlavorConfig.instance.env.baseUrl));
      });
    });

    group('Aadhaar and Captcha Endpoints Tests', () {
      test('should return generate captcha URL', () {
        // Act
        final generateCaptchaUrl = ApiEndPoint.generateCaptchaUrl;

        // Assert
        expect(generateCaptchaUrl, isNotNull);
        expect(generateCaptchaUrl, isNotEmpty);
        expect(generateCaptchaUrl, endsWith('/api/v1/aadhar/generate-captcha'));
        expect(generateCaptchaUrl, startsWith(FlavorConfig.instance.env.baseUrl));
      });

      test('should return generate re-captcha URL', () {
        // Act
        final generateReCaptchaUrl = ApiEndPoint.generateReCaptchaUrl;

        // Assert
        expect(generateReCaptchaUrl, isNotNull);
        expect(generateReCaptchaUrl, isNotEmpty);
        expect(generateReCaptchaUrl, endsWith('/api/v1/aadhar/re-captcha'));
        expect(generateReCaptchaUrl, startsWith(FlavorConfig.instance.env.baseUrl));
      });

      test('should return generate Aadhaar OTP URL', () {
        // Act
        final generateAadharOTP = ApiEndPoint.generateAadharOTP;

        // Assert
        expect(generateAadharOTP, isNotNull);
        expect(generateAadharOTP, isNotEmpty);
        expect(generateAadharOTP, endsWith('/api/v1/aadhar/generate-otp'));
        expect(generateAadharOTP, startsWith(FlavorConfig.instance.env.baseUrl));
      });

      test('should return validate Aadhaar OTP URL', () {
        // Act
        final validateAadharOTPUrl = ApiEndPoint.validateAadharOTPUrl;

        // Assert
        expect(validateAadharOTPUrl, isNotNull);
        expect(validateAadharOTPUrl, isNotEmpty);
        expect(validateAadharOTPUrl, endsWith('/api/v1/aadhar/verify-otp'));
        expect(validateAadharOTPUrl, startsWith(FlavorConfig.instance.env.baseUrl));
      });

      test('should return get PAN detail URL', () {
        // Act
        final getPanDetailUrl = ApiEndPoint.getPanDetailUrl;

        // Assert
        expect(getPanDetailUrl, isNotNull);
        expect(getPanDetailUrl, isNotEmpty);
        expect(getPanDetailUrl, endsWith('/api/v1/aadhar/get-pan-details'));
        expect(getPanDetailUrl, startsWith(FlavorConfig.instance.env.baseUrl));
      });
    });

    group('Utility and Service Endpoints Tests', () {
      test('should return get city and state URL', () {
        // Act
        final getCityAndStateUrl = ApiEndPoint.getCityAndStateUrl;

        // Assert
        expect(getCityAndStateUrl, isNotNull);
        expect(getCityAndStateUrl, isNotEmpty);
        expect(getCityAndStateUrl, endsWith('/api/v1/googleapi/get-city-and-state'));
        expect(getCityAndStateUrl, startsWith(FlavorConfig.instance.env.baseUrl));
      });

      test('should return get user details URL', () {
        // Act
        final getUserDetailsUrl = ApiEndPoint.getKycDetailsUrl;

        // Assert
        expect(getUserDetailsUrl, isNotNull);
        expect(getUserDetailsUrl, isNotEmpty);
        expect(getUserDetailsUrl, endsWith('/api/v1/details/get-kyc-status/'));
        expect(getUserDetailsUrl, startsWith(FlavorConfig.instance.env.baseUrl));
      });

      test('should return get GST details URL', () {
        // Act
        final getGSTDetailsUrl = ApiEndPoint.getGSTDetailsUrl;

        // Assert
        expect(getGSTDetailsUrl, isNotNull);
        expect(getGSTDetailsUrl, isNotEmpty);
        expect(getGSTDetailsUrl, endsWith('/api/v1/gst/get-details'));
        expect(getGSTDetailsUrl, startsWith(FlavorConfig.instance.env.baseUrl));
      });

      test('should return verify bank account URL', () {
        // Act
        final verifyBankAccountUrl = ApiEndPoint.verifyBankAccountUrl;

        // Assert
        expect(verifyBankAccountUrl, isNotNull);
        expect(verifyBankAccountUrl, isNotEmpty);
        expect(verifyBankAccountUrl, endsWith('/api/v1/bank/verify'));
        expect(verifyBankAccountUrl, startsWith(FlavorConfig.instance.env.baseUrl));
      });
    });

    group('URL Structure Tests', () {
      test('should have consistent URL structure', () {
        // Test that all URLs follow the expected pattern
        final urls = [
          ApiEndPoint.socialLoginUrl,
          ApiEndPoint.emailavailability,
          ApiEndPoint.mobileavailability,
          ApiEndPoint.sendEmailVerificationLinkUrl,
          ApiEndPoint.sendOtpUrl,
          ApiEndPoint.validateLoginOtpUrl,
          ApiEndPoint.validateRegistrationOtpUrl,
          ApiEndPoint.updatePasswordUrl,
          ApiEndPoint.getDropdownOptionUrl,
          ApiEndPoint.loginurl,
          ApiEndPoint.registerurl,
          ApiEndPoint.getCurrencyOptionUrl,
          ApiEndPoint.validateForgotPasswordOtpUrl,
          ApiEndPoint.logoutUrl,
          ApiEndPoint.uploadPersonalKycUrl,
          ApiEndPoint.generateCaptchaUrl,
          ApiEndPoint.generateReCaptchaUrl,
          ApiEndPoint.generateAadharOTP,
          ApiEndPoint.validateAadharOTPUrl,
          ApiEndPoint.getPanDetailUrl,
          ApiEndPoint.getCityAndStateUrl,
          ApiEndPoint.uploadResidentialAddressDetailsUrl,
          ApiEndPoint.getKycDetailsUrl,
          ApiEndPoint.getGSTDetailsUrl,
          ApiEndPoint.gstDocumentUrl,
          ApiEndPoint.businessLegalDocuments,
          ApiEndPoint.verifyBankAccountUrl,
          ApiEndPoint.uploadBankDocumentUrl,
          ApiEndPoint.presignedUrl,
        ];

        for (final url in urls) {
          expect(url, isNotNull);
          expect(url, isNotEmpty);
          expect(url, startsWith(FlavorConfig.instance.env.baseUrl));
          // Note: getUserDetailsUrl ends with '/' by design, so we exclude it from this check
          if (url != ApiEndPoint.getKycDetailsUrl) {
            expect(url, isNot(endsWith('/')));
          }
        }
      });

      test('should not have duplicate URLs', () {
        // Test that all URLs are unique
        final urls = [
          ApiEndPoint.socialLoginUrl,
          ApiEndPoint.emailavailability,
          ApiEndPoint.mobileavailability,
          ApiEndPoint.sendEmailVerificationLinkUrl,
          ApiEndPoint.sendOtpUrl,
          ApiEndPoint.validateLoginOtpUrl,
          ApiEndPoint.validateRegistrationOtpUrl,
          ApiEndPoint.updatePasswordUrl,
          ApiEndPoint.getDropdownOptionUrl,
          ApiEndPoint.loginurl,
          ApiEndPoint.registerurl,
          ApiEndPoint.getCurrencyOptionUrl,
          ApiEndPoint.validateForgotPasswordOtpUrl,
          ApiEndPoint.logoutUrl,
          ApiEndPoint.uploadPersonalKycUrl,
          ApiEndPoint.generateCaptchaUrl,
          ApiEndPoint.generateReCaptchaUrl,
          ApiEndPoint.generateAadharOTP,
          ApiEndPoint.validateAadharOTPUrl,
          ApiEndPoint.getPanDetailUrl,
          ApiEndPoint.getCityAndStateUrl,
          ApiEndPoint.uploadResidentialAddressDetailsUrl,
          ApiEndPoint.getKycDetailsUrl,
          ApiEndPoint.getGSTDetailsUrl,
          ApiEndPoint.gstDocumentUrl,
          ApiEndPoint.businessLegalDocuments,
          ApiEndPoint.verifyBankAccountUrl,
          ApiEndPoint.uploadBankDocumentUrl,
          ApiEndPoint.presignedUrl,
        ];

        final uniqueUrls = urls.toSet();
        expect(uniqueUrls.length, equals(urls.length));
      });
    });

    group('Integration Tests', () {
      test('should work with different flavor configurations', () {
        // Test that the endpoints work regardless of the flavor configuration
        expect(ApiEndPoint.baseUrl, isNotNull);
        expect(ApiEndPoint.baseUrl, isNotEmpty);

        // All other URLs should be constructed properly
        expect(ApiEndPoint.socialLoginUrl, contains(ApiEndPoint.baseUrl));
        expect(ApiEndPoint.emailavailability, contains(ApiEndPoint.baseUrl));
        expect(ApiEndPoint.mobileavailability, contains(ApiEndPoint.baseUrl));
      });

      test('should have proper URL encoding', () {
        // Test that URLs don't have any obvious encoding issues
        final urls = [
          ApiEndPoint.socialLoginUrl,
          ApiEndPoint.emailavailability,
          ApiEndPoint.mobileavailability,
          ApiEndPoint.sendEmailVerificationLinkUrl,
          ApiEndPoint.sendOtpUrl,
          ApiEndPoint.validateLoginOtpUrl,
          ApiEndPoint.validateRegistrationOtpUrl,
          ApiEndPoint.updatePasswordUrl,
          ApiEndPoint.getDropdownOptionUrl,
          ApiEndPoint.loginurl,
          ApiEndPoint.registerurl,
          ApiEndPoint.getCurrencyOptionUrl,
          ApiEndPoint.validateForgotPasswordOtpUrl,
          ApiEndPoint.logoutUrl,
          ApiEndPoint.uploadPersonalKycUrl,
          ApiEndPoint.generateCaptchaUrl,
          ApiEndPoint.generateReCaptchaUrl,
          ApiEndPoint.generateAadharOTP,
          ApiEndPoint.validateAadharOTPUrl,
          ApiEndPoint.getPanDetailUrl,
          ApiEndPoint.getCityAndStateUrl,
          ApiEndPoint.uploadResidentialAddressDetailsUrl,
          ApiEndPoint.getKycDetailsUrl,
          ApiEndPoint.getGSTDetailsUrl,
          ApiEndPoint.gstDocumentUrl,
          ApiEndPoint.businessLegalDocuments,
          ApiEndPoint.verifyBankAccountUrl,
          ApiEndPoint.uploadBankDocumentUrl,
          ApiEndPoint.presignedUrl,
        ];

        for (final url in urls) {
          // URLs should not contain spaces or other problematic characters
          expect(url, isNot(contains(' ')));
          expect(url, isNot(contains('\n')));
          expect(url, isNot(contains('\t')));
        }
      });

      test('should test ipUrl independently', () {
        // Test that ipUrl is independent of baseUrl
        final ipUrl = ApiEndPoint.ipUrl;

        expect(ipUrl, isNotNull);
        expect(ipUrl, isNotEmpty);
        expect(ipUrl, equals('https://api.ipify.org?format=json'));
        expect(ipUrl, isNot(startsWith(FlavorConfig.instance.env.baseUrl)));
      });
    });
  });
}
