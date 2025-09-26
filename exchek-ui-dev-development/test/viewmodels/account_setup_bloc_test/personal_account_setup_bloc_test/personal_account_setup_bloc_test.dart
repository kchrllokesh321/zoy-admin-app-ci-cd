import 'package:exchek/core/enums/app_enums.dart';
import 'package:exchek/models/auth_models/login_email_register_model.dart' as login_models;
import 'package:exchek/repository/auth_repository.dart';
import 'package:exchek/repository/personal_user_kyc_repository.dart';
import 'package:exchek/viewmodels/account_setup_bloc/personal_account_setup_bloc/personal_account_setup_bloc.dart';
import 'package:exchek/views/account_setup_view/personal_account_setup_view/personal_transaction_payment_reference_view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:camera/camera.dart';
import 'package:exchek/models/auth_models/common_success_model.dart';
import 'package:exchek/models/personal_user_models/get_currency_model.dart' as currency_models;
import 'package:exchek/models/personal_user_models/aadhar_verify_otp_model.dart';
import 'package:exchek/models/personal_user_models/aadhar_otp_model.dart';
import 'package:exchek/models/personal_user_models/captcha_model.dart' as captcha_models;
import 'package:exchek/models/personal_user_models/recaptcha_model.dart';
import 'package:exchek/widgets/common_widget/app_file_upload_widget.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:exchek/models/personal_user_models/get_pan_detail_model.dart' as pan_model;
import 'package:exchek/models/personal_user_models/get_city_and_state_model.dart' as city_model;
import 'package:exchek/models/personal_user_models/get_gst_details_model.dart' as gst_model;
import 'package:exchek/models/personal_user_models/bank_account_verify_model.dart' as bank_model;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:exchek/core/utils/local_storage.dart';

import 'personal_account_setup_bloc_test.mocks.dart';

@GenerateMocks([AuthRepository, CameraController, PersonalUserKycRepository])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Setup test environment
  setUpAll(() async {
    // Mock Google Fonts to prevent network calls in tests
    GoogleFonts.config.allowRuntimeFetching = false;

    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({
      Prefkeys.userId: 'test_user_id',
      Prefkeys.userKycDetail: jsonEncode({'user_type': 'personal'}),
    });

    // Mock secure storage and other plugins with actual data
    final Map<String, String> mockSecureStorage = {
      Prefkeys.userId: 'test_user_id',
      Prefkeys.userKycDetail: jsonEncode({'user_type': 'personal'}),
    };

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'read':
            final String key = methodCall.arguments['key'];
            return mockSecureStorage[key];
          case 'write':
            final String key = methodCall.arguments['key'];
            final String value = methodCall.arguments['value'];
            mockSecureStorage[key] = value;
            return null;
          case 'delete':
            final String key = methodCall.arguments['key'];
            mockSecureStorage.remove(key);
            return null;
          case 'deleteAll':
            mockSecureStorage.clear();
            return null;
          case 'readAll':
            return Map<String, String>.from(mockSecureStorage);
          case 'containsKey':
            final String key = methodCall.arguments['key'];
            return mockSecureStorage.containsKey(key);
          default:
            return null;
        }
      },
    );

    // Mock package info plugin
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('dev.fluttercommunity.plus/package_info'),
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'getAll':
            return {'appName': 'Test App', 'packageName': 'com.test.app', 'version': '1.0.0', 'buildNumber': '1'};
          default:
            return null;
        }
      },
    );
  });

  group('PersonalAccountSetupBloc', () {
    late PersonalAccountSetupBloc personalAccountSetupBloc;
    late MockAuthRepository mockAuthRepository;
    late MockPersonalUserKycRepository mockPersonalUserKycRepository;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      mockPersonalUserKycRepository = MockPersonalUserKycRepository();

      // Setup default mock responses
      when(
        mockPersonalUserKycRepository.getPanDetails(
          panNumber: anyNamed('panNumber'),
          userId: anyNamed('userId'),
          kycRole: anyNamed('kycRole'),
        ),
      ).thenAnswer(
        (_) async => pan_model.GetPanDetailModel(
          success: true,
          data: pan_model.Data(nameInformation: pan_model.NameInformation(panNameCleaned: 'Test User')),
        ),
      );

      when(mockPersonalUserKycRepository.getCityAndState(pincode: anyNamed('pincode'))).thenAnswer(
        (_) async =>
            city_model.GetCityAndStateModel(success: true, data: city_model.Data(city: 'Mumbai', state: 'Maharashtra')),
      );

      personalAccountSetupBloc = PersonalAccountSetupBloc(
        authRepository: mockAuthRepository,
        personalUserKycRepository: mockPersonalUserKycRepository,
      );
    });

    // tearDown removed to avoid disposal issues in the bloc

    test('initial state is correct', () {
      expect(personalAccountSetupBloc.state.currentStep, PersonalAccountSetupSteps.personalEntity);
      expect(personalAccountSetupBloc.state.isLoading, false);
      expect(personalAccountSetupBloc.state.isOTPSent, false);
      expect(personalAccountSetupBloc.state.obscurePassword, true);
    });

    group('PersonalInfoStepChanged', () {
      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'emits new step when PersonalInfoStepChanged is added',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const PersonalInfoStepChanged(PersonalAccountSetupSteps.personalInformation)),
        expect:
            () => [personalAccountSetupBloc.state.copyWith(currentStep: PersonalAccountSetupSteps.personalInformation)],
      );
    });

    group('NextStep', () {
      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'moves to next step when NextStep is added',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const NextStep()),
        expect:
            () => [personalAccountSetupBloc.state.copyWith(currentStep: PersonalAccountSetupSteps.personalInformation)],
      );
    });

    group('PreviousStepEvent', () {
      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'moves to previous step when PreviousStepEvent is added',
        build: () => personalAccountSetupBloc,
        seed: () => personalAccountSetupBloc.state.copyWith(currentStep: PersonalAccountSetupSteps.personalInformation),
        act: (bloc) => bloc.add(const PreviousStepEvent()),
        expect: () => [personalAccountSetupBloc.state.copyWith(currentStep: PersonalAccountSetupSteps.personalEntity)],
      );
    });

    group('ChangePurpose', () {
      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'emits new purpose when ChangePurpose is added',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const ChangePurpose('Business')),
        expect: () => [personalAccountSetupBloc.state.copyWith(selectedPurpose: 'Business')],
      );
    });

    group('ChangeProfession', () {
      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'emits new profession when ChangeProfession is added',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const ChangeProfession('Software Engineer')),
        expect:
            () => [
              personalAccountSetupBloc.state.copyWith(selectedProfession: ['Software Engineer']),
            ],
      );
    });

    group('UpdatePersonalDetails', () {
      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'updates personal details when UpdatePersonalDetails is added',
        build: () => personalAccountSetupBloc,
        act:
            (bloc) => bloc.add(
              const UpdatePersonalDetails(
                fullName: 'John Doe',
                website: 'https://johndoe.com',
                phoneNumber: '9876543210',
              ),
            ),
        expect:
            () => [
              personalAccountSetupBloc.state.copyWith(
                fullName: 'John Doe',
                website: 'https://johndoe.com',
                phoneNumber: '9876543210',
              ),
            ],
      );
    });

    group('PersonalPasswordSubmitted', () {
      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'emits success state when password submission is successful',
        build: () => personalAccountSetupBloc,
        setUp: () {
          when(
            mockAuthRepository.registerPersonalUser(
              email: anyNamed('email'),
              estimatedMonthlyVolume: anyNamed('estimatedMonthlyVolume'),
              // multicurrency: anyNamed('multicurrency'),
              mobileNumber: anyNamed('mobileNumber'),
              receivingreason: anyNamed('receivingreason'),
              profession: anyNamed('profession'),
              productDescription: anyNamed('productDescription'),
              legalFullName: anyNamed('legalFullName'),
              password: anyNamed('password'),
              tosacceptance: anyNamed('tosacceptance'),
              usertype: anyNamed('usertype'),
              website: anyNamed('website'),
              doingBusinessAs: anyNamed('doingBusinessAs'),
            ),
          ).thenAnswer(
            (_) async =>
                login_models.LoginEmailPasswordModel(success: true, data: login_models.Data(token: 'test_token')),
          );
        },

        act: (bloc) => bloc.add(PersonalPasswordSubmitted()),
        expect: () => [personalAccountSetupBloc.state.copyWith(isLoading: true, navigateNext: false)],
      );
    });

    group('Currency Selection Events', () {
      final mockCurrency = CurrencyModel(
        currencyName: 'US Dollar',
        currencySymbol: 'USD',
        currencyImagePath: '/path/usd.png',
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'changes estimated monthly transaction',
        build: () => personalAccountSetupBloc,

        act: (bloc) => bloc.add(PersonalChangeEstimatedMonthlyTransaction('1000-5000')),
        expect: () => [personalAccountSetupBloc.state.copyWith(selectedEstimatedMonthlyTransaction: '1000-5000')],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'toggles currency selection',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(PersonalToggleCurrencySelection(mockCurrency)),

        expect:
            () => [
              personalAccountSetupBloc.state.copyWith(selectedCurrencies: [mockCurrency]),
            ],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'removes currency when already selected',
        build: () => personalAccountSetupBloc,

        seed: () => personalAccountSetupBloc.state.copyWith(selectedCurrencies: [mockCurrency]),
        act: (bloc) => bloc.add(PersonalToggleCurrencySelection(mockCurrency)),

        expect: () => [personalAccountSetupBloc.state.copyWith(selectedCurrencies: [])],
      );
    });

    group('KYC Verification Events', () {
      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'changes KYC step when PersonalKycStepChange is added',
        build: () => personalAccountSetupBloc,

        act: (bloc) => bloc.add(PersonalKycStepChange(PersonalEKycVerificationSteps.identityVerification)),
        expect:
            () => [
              personalAccountSetupBloc.state.copyWith(
                currentKycVerificationStep: PersonalEKycVerificationSteps.identityVerification,
              ),
            ],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'updates ID verification doc type',
        build: () => personalAccountSetupBloc,

        act: (bloc) => bloc.add(PersonalUpdateIdVerificationDocType(IDVerificationDocType.aadharCard)),
        expect:
            () => [
              predicate<PersonalAccountSetupState>(
                (state) =>
                    state.selectedIDVerificationDocType == IDVerificationDocType.aadharCard &&
                    state.isIdVerified == false &&
                    state.isDrivingIdVerified == false,
              ),
              predicate<PersonalAccountSetupState>(
                (state) =>
                    state.selectedIDVerificationDocType == IDVerificationDocType.aadharCard &&
                    state.isIdVerified == false &&
                    state.isDrivingIdVerified == false &&
                    state.isIdVerifiedLoading == false &&
                    state.isCaptchaSend == false &&
                    state.isCaptchaLoading == false &&
                    state.captchaImage == '' &&
                    state.isOtpSent == false &&
                    state.isOtpLoading == false &&
                    state.frontSideAdharFile == null &&
                    state.backSideAdharFile == null &&
                    state.drivingLicenceFrontSideFile == null &&
                    state.voterIdFrontFile == null &&
                    state.passportFrontFile == null &&
                    state.aadharNumber == null &&
                    state.drivingLicenseNumber == null &&
                    state.voterIDNumber == null &&
                    state.passporteNumber == null,
              ),
            ],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'starts Aadhaar OTP timer when AadharSendOtpPressed is added',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(AadharSendOtpPressed()),

        expect:
            () => [personalAccountSetupBloc.state.copyWith(isAadharOtpTimerRunning: true, aadharOtpRemainingTime: 120)],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'verifies driving license successfully',
        build: () => personalAccountSetupBloc,
        wait: const Duration(milliseconds: 500),
        act: (bloc) => bloc.add(PersonalDrivingLicenceVerified('DL1234567890')),
        expect:
            () => [
              predicate<PersonalAccountSetupState>((state) => state.isIdVerifiedLoading == true),
              predicate<PersonalAccountSetupState>(
                (state) =>
                    state.isIdVerifiedLoading == false &&
                    state.isIdVerified == true &&
                    state.drivingLicenseNumber == 'DL1234567890',
              ),
            ],
      );
    });

    group('File Upload Events', () {
      final mockFileData = FileData(name: 'test.png', path: '/path/test.png', bytes: Uint8List(0), sizeInMB: 0);

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'uploads front Aadhaar card file',
        build: () => personalAccountSetupBloc,

        act: (bloc) => bloc.add(PersonalFrontSlideAadharCardUpload(mockFileData)),
        expect: () => [personalAccountSetupBloc.state.copyWith(frontSideAdharFile: mockFileData)],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'uploads PAN card file',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(PersonalUploadPanCard(mockFileData)),
        expect: () => [personalAccountSetupBloc.state.copyWith(panFileData: mockFileData)],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'submits PAN verification successfully',
        build: () => personalAccountSetupBloc,
        act:
            (bloc) => bloc.add(
              PersonalPanVerificationSubmitted(fileData: mockFileData, panName: 'John Doe', panNumber: 'ABCDE1234F'),
            ),
        expect: () => [],
      );
    });

    group('Address Verification Events', () {
      final mockCountry = Country(
        phoneCode: '91',
        countryCode: 'IN',
        e164Sc: 0,
        geographic: true,
        level: 1,
        name: 'India',
        example: '9123456789',
        displayName: 'India',
        displayNameNoCountryCode: 'India',
        e164Key: '',
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'updates selected country',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(PersonalUpdateSelectedCountry(country: mockCountry)),
        expect: () => [personalAccountSetupBloc.state.copyWith(selectedCountry: mockCountry)],
      );
    });

    group('Password Visibility Events', () {
      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'toggles password visibility',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const TogglePasswordVisibility()),
        expect: () => [personalAccountSetupBloc.state.copyWith(obscurePassword: false)],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'toggles confirm password visibility',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const ToggleConfirmPasswordVisibility()),
        expect: () => [personalAccountSetupBloc.state.copyWith(obscureConfirmPassword: false)],
      );
    });

    group('GetPersonalCurrencyOptions', () {
      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'loads currency options successfully',
        build: () => personalAccountSetupBloc,
        setUp: () {
          when(mockAuthRepository.getCurrencyOptions()).thenAnswer(
            (_) async => currency_models.GetCurrencyOptionModel(
              success: true,
              data: currency_models.Data(
                multicurrency: ['USD US Dollar', 'EUR Euro'],
                estimatedMonthlyVolume: ['0-1000', '1000-5000'],
              ),
            ),
          );
        },
        act: (bloc) => bloc.add(const GetPersonalCurrencyOptions()),
        expect:
            () => [
              predicate<PersonalAccountSetupState>((state) => state.isLoading == true),
              predicate<PersonalAccountSetupState>(
                (state) =>
                    state.currencyList != null &&
                    state.currencyList!.isNotEmpty &&
                    state.estimatedMonthlyVolumeList != null &&
                    state.estimatedMonthlyVolumeList!.length == 2 &&
                    state.estimatedMonthlyVolumeList!.contains('0-1000') &&
                    state.estimatedMonthlyVolumeList!.contains('1000-5000'),
              ),
            ],
      );
    });

    group('PersonalResetData', () {
      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'resets all data to initial state',
        build: () => personalAccountSetupBloc,
        seed:
            () => personalAccountSetupBloc.state.copyWith(
              currentStep: PersonalAccountSetupSteps.personalInformation,
              selectedPurpose: 'Business',
              isLoading: true,
            ),
        act: (bloc) => bloc.add(const PersonalResetData()),
        expect:
            () => [
              predicate<PersonalAccountSetupState>(
                (state) => state.currentStep == PersonalAccountSetupSteps.personalEntity && state.isLoading == false,
              ),
            ],
      );
    });

    // =============================================================================
    // COMPREHENSIVE ADDITIONAL TEST COVERAGE
    // =============================================================================

    group('Aadhaar Verification Events', () {
      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'sends Aadhaar OTP successfully',
        build: () => personalAccountSetupBloc,
        setUp: () {
          when(
            mockPersonalUserKycRepository.generateAadharOTP(
              aadhaarNumber: anyNamed('aadhaarNumber'),
              captcha: anyNamed('captcha'),
              sessionId: anyNamed('sessionId'),
            ),
          ).thenAnswer(
            (_) async => AadharOTPSendModel(
              code: 200,
              message: 'OTP sent successfully',
              timestamp: 1234567890,
              transactionId: 'test-transaction-id',
              subCode: 'test-sub-code',
            ),
          );
        },
        act:
            (bloc) => bloc.add(
              const PersonalSendAadharOtp(aadhar: '1234-5678-9012', captcha: 'ABC123', sessionId: 'session123'),
            ),
        expect:
            () => [
              predicate<PersonalAccountSetupState>((state) => state.isOtpSent == false && state.isOtpLoading == true),
              predicate<PersonalAccountSetupState>((state) => state.isOtpSent == true && state.isOtpLoading == false),
              predicate<PersonalAccountSetupState>(
                (state) => state.isAadharOtpTimerRunning == true && state.aadharOtpRemainingTime == 120,
              ),
            ],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'handles Aadhar OTP send failure',
        build: () => personalAccountSetupBloc,
        setUp: () {
          when(
            mockPersonalUserKycRepository.generateAadharOTP(
              aadhaarNumber: anyNamed('aadhaarNumber'),
              captcha: anyNamed('captcha'),
              sessionId: anyNamed('sessionId'),
            ),
          ).thenAnswer(
            (_) async => AadharOTPSendModel(
              code: 400,
              message: 'Invalid captcha',
              timestamp: 1234567890,
              transactionId: 'test-transaction-id',
              subCode: 'test-sub-code',
            ),
          );
        },
        act:
            (bloc) => bloc.add(
              const PersonalSendAadharOtp(aadhar: '1234-5678-9012', captcha: 'INVALID', sessionId: 'session123'),
            ),
        expect:
            () => [
              predicate<PersonalAccountSetupState>((state) => state.isOtpSent == false && state.isOtpLoading == true),
              predicate<PersonalAccountSetupState>((state) => state.isOtpLoading == false),
            ],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'handles Aadhar OTP verification failure',
        build: () => personalAccountSetupBloc,
        setUp: () {
          when(
            mockPersonalUserKycRepository.validateAadharOtp(
              faker: anyNamed('faker'),
              otp: anyNamed('otp'),
              sessionId: anyNamed('sessionId'),
              userId: anyNamed('userId'),
              userType: anyNamed('userType'),
              aadhaarNumber: anyNamed('aadhaarNumber'),
            ),
          ).thenAnswer(
            (_) async => AadharOTPVerifyModel(
              code: 400,
              timestamp: 1234567890,
              transactionId: 'test-transaction-id',
              subCode: 'test-sub-code',
              message: 'Invalid OTP',
              data: AadharData(address: AadharAddress()),
            ),
          );
        },
        act: (bloc) => bloc.add(const PersonalAadharNumbeVerified(aadharNumber: '123456789012', otp: 'INVALID')),
        expect:
            () => [
              predicate<PersonalAccountSetupState>(
                (state) => state.isIdVerifiedLoading == true && state.isAadharOTPInvalidate == null,
              ),
              predicate<PersonalAccountSetupState>(
                (state) => state.isIdVerifiedLoading == false && state.isAadharOTPInvalidate == 'Invalid OTP',
              ),
            ],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'changes OTP sent status',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const ChangeOtpSentStatus(true)),
        expect: () => [predicate<PersonalAccountSetupState>((state) => state.isOtpSent == true)],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'handles Aadhaar OTP timer tick',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const AadharOtpTimerTicked(60)),
        expect:
            () => [
              predicate<PersonalAccountSetupState>(
                (state) => state.aadharOtpRemainingTime == 60 && state.isAadharOtpTimerRunning == true,
              ),
            ],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'stops timer when time reaches zero',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const AadharOtpTimerTicked(0)),
        expect:
            () => [
              predicate<PersonalAccountSetupState>(
                (state) => state.aadharOtpRemainingTime == 0 && state.isAadharOtpTimerRunning == false,
              ),
            ],
      );
    });

    group('Captcha Events', () {
      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'sends captcha successfully',
        build: () => personalAccountSetupBloc,
        setUp: () {
          when(
            mockPersonalUserKycRepository.generateCaptcha(
              aadhaarNumber: anyNamed('aadhaarNumber'),
              userID: anyNamed('userID'),
              userType: anyNamed('userType'),
            ),
          ).thenAnswer(
            (_) async => captcha_models.CaptchaModel(
              code: 200,
              timestamp: 1234567890,
              transactionId: 'captcha_txn_123',
              data: captcha_models.Data(captcha: 'base64captchaimage', sessionId: 'session123'),
            ),
          );
        },
        act: (bloc) => bloc.add(const CaptchaSend()),
        expect:
            () => [
              predicate<PersonalAccountSetupState>(
                (state) => state.isCaptchaLoading == true && state.isCaptchaSend == false,
              ),
              predicate<PersonalAccountSetupState>(
                (state) =>
                    state.isCaptchaSend == true &&
                    state.isCaptchaLoading == false &&
                    state.captchaImage == 'base64captchaimage',
              ),
            ],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'regenerates captcha successfully',
        build: () => personalAccountSetupBloc,
        setUp: () {
          when(mockPersonalUserKycRepository.reGenerateCaptcha(sessionId: anyNamed('sessionId'))).thenAnswer(
            (_) async => RecaptchaModel(
              code: 200,
              timestamp: 1234567890,
              transactionId: 'recaptcha_txn_123',
              data: RecaptchaData(captcha: 'newbase64captchaimage'),
            ),
          );
        },
        act: (bloc) => bloc.add(const ReCaptchaSend()),
        expect:
            () => [
              predicate<PersonalAccountSetupState>(
                (state) => state.isCaptchaLoading == true && state.isCaptchaSend == false,
              ),
              predicate<PersonalAccountSetupState>(
                (state) =>
                    state.isCaptchaSend == true &&
                    state.isCaptchaLoading == false &&
                    state.captchaImage == 'newbase64captchaimage',
              ),
            ],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'handles captcha generation failure',
        build: () => personalAccountSetupBloc,
        setUp: () {
          when(
            mockPersonalUserKycRepository.generateCaptcha(
              aadhaarNumber: anyNamed('aadhaarNumber'),
              userID: anyNamed('userID'),
              userType: anyNamed('userType'),
            ),
          ).thenThrow(Exception('Network error'));
        },
        act: (bloc) => bloc.add(const CaptchaSend()),
        expect:
            () => [
              predicate<PersonalAccountSetupState>(
                (state) => state.isCaptchaLoading == true && state.isCaptchaSend == false,
              ),
              predicate<PersonalAccountSetupState>(
                (state) => state.isCaptchaLoading == false && state.isCaptchaSend == false,
              ),
            ],
      );
    });

    group('Document Verification Events', () {
      final mockFileData = FileData(name: 'test.png', path: '/path/test.png', bytes: Uint8List(0), sizeInMB: 0);

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'verifies voter ID successfully',
        build: () => personalAccountSetupBloc,
        wait: const Duration(milliseconds: 500),
        act: (bloc) => bloc.add(const PersonalVoterIdVerified('VOTER123456')),
        expect:
            () => [
              predicate<PersonalAccountSetupState>((state) => state.isIdVerifiedLoading == true),
              predicate<PersonalAccountSetupState>(
                (state) =>
                    state.isIdVerifiedLoading == false &&
                    state.isIdVerified == true &&
                    state.voterIDNumber == 'VOTER123456',
              ),
            ],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'verifies passport successfully',
        build: () => personalAccountSetupBloc,
        wait: const Duration(milliseconds: 500),
        act: (bloc) => bloc.add(const PersonalPassportVerified('PASSPORT123456')),
        expect:
            () => [
              predicate<PersonalAccountSetupState>((state) => state.isIdVerifiedLoading == true),
              predicate<PersonalAccountSetupState>(
                (state) =>
                    state.isIdVerifiedLoading == false &&
                    state.isIdVerified == true &&
                    state.passporteNumber == 'PASSPORT123456',
              ),
            ],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'uploads back side Aadhaar card file',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(PersonalBackSlideAadharCardUpload(mockFileData)),
        expect: () => [personalAccountSetupBloc.state.copyWith(backSideAdharFile: mockFileData)],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'uploads driving license front side file',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(PersonalFrontSlideDrivingLicenceUpload(mockFileData)),
        expect: () => [personalAccountSetupBloc.state.copyWith(drivingLicenceFrontSideFile: mockFileData)],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'uploads voter ID file',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(PersonalVoterIdFrontFileUpload(mockFileData)),
        expect: () => [personalAccountSetupBloc.state.copyWith(voterIdFrontFile: mockFileData)],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'uploads passport file',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(PersonalPassportFrontFileUpload(mockFileData)),
        expect: () => [personalAccountSetupBloc.state.copyWith(passportFrontFile: mockFileData)],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'handles front side Aadhar file upload with null value',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const PersonalFrontSlideAadharCardUpload(null)),
        expect: () => [predicate<PersonalAccountSetupState>((state) => state.frontSideAdharFile == null)],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'handles back side Aadhar file upload with null value',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const PersonalBackSlideAadharCardUpload(null)),
        expect: () => [predicate<PersonalAccountSetupState>((state) => state.backSideAdharFile == null)],
      );
    });

    group('Address Verification Events Extended', () {
      final mockFileData = FileData(name: 'address.pdf', path: '/path/address.pdf', bytes: Uint8List(0), sizeInMB: 0);

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'updates address verification doc type',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const PersonalUpdateAddressVerificationDocType('BankStatement')),
        expect: () => [personalAccountSetupBloc.state.copyWith(selectedAddressVerificationDocType: 'BankStatement')],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'uploads address verification file',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(PersonalUploadAddressVerificationFile(fileData: mockFileData)),
        expect: () => [personalAccountSetupBloc.state.copyWith(addressVerificationFile: mockFileData)],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'uploads back address verification file',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(PersonalUploadBackAddressVerificationFile(fileData: mockFileData)),
        expect: () => [personalAccountSetupBloc.state.copyWith(backAddressVerificationFile: mockFileData)],
      );
    });

    group('GST and Annual Turnover Events', () {
      final mockFileData = FileData(name: 'gst.pdf', path: '/path/gst.pdf', bytes: Uint8List(0), sizeInMB: 0);

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'changes annual turnover selection',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const PersonalChangeAnnualTurnover('1000000-5000000')),
        expect: () => [personalAccountSetupBloc.state.copyWith(selectedAnnualTurnover: '1000000-5000000')],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'uploads GST certificate file',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(PersonalUploadGstCertificateFile(fileData: mockFileData)),
        expect: () => [personalAccountSetupBloc.state.copyWith(gstCertificateFile: mockFileData)],
      );
    });

    group('Bank Account Verification Events Extended', () {
      final mockFileData = FileData(name: 'bank.pdf', path: '/path/bank.pdf', bytes: Uint8List(0), sizeInMB: 0);

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'updates bank account verification doc type',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const PersonalUpdateBankAccountVerificationDocType('BankStatement')),
        expect:
            () => [personalAccountSetupBloc.state.copyWith(selectedBankAccountVerificationDocType: 'BankStatement')],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'uploads bank account verification file',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(PersonalUploadBankAccountVerificationFile(fileData: mockFileData)),
        expect: () => [personalAccountSetupBloc.state.copyWith(bankVerificationFile: mockFileData)],
      );
    });

    group('Scroll and Navigation Events', () {
      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'scrolls to position with valid key',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(PersonalScrollToPosition(GlobalKey())),
        expect: () => [predicate<PersonalAccountSetupState>((state) => state.scrollDebounceTimer != null)],
      );
    });

    group('Password Events Extended', () {
      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'changes password text',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const PasswordChanged(password: 'newpassword123')),
        expect:
            () => [predicate<PersonalAccountSetupState>((state) => state.passwordController.text == 'newpassword123')],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'changes confirm password text',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const ConfirmPasswordChanged(password: 'newpassword123')),
        expect:
            () => [
              predicate<PersonalAccountSetupState>((state) => state.confirmPasswordController.text == 'newpassword123'),
            ],
      );
    });

    group('Additional State Management Events', () {
      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'resets signup success state',
        build: () => personalAccountSetupBloc,
        seed: () => personalAccountSetupBloc.state.copyWith(isSignupSuccess: true),
        act: (bloc) => bloc.add(const PersonalResetSignupSuccess()),
        expect: () => [personalAccountSetupBloc.state.copyWith(isSignupSuccess: false)],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'updates OTP error message',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const UpdateOTPError('Invalid OTP')),
        expect: () => [personalAccountSetupBloc.state.copyWith(otpError: 'Invalid OTP')],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'updates resend timer state with time left',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const UpdateResendTimerState(timeLeft: 60)),
        expect: () => [personalAccountSetupBloc.state.copyWith(timeLeft: 60)],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'updates resend timer state with can resend',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const UpdateResendTimerState(canResend: true)),
        expect: () => [personalAccountSetupBloc.state.copyWith(canResendOTP: true)],
      );
    });

    group('Address Same as Aadhar Events', () {
      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'sets residence address same as Aadhar',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const ResidenceAddressSameAsAadhar(1)),
        expect: () => [personalAccountSetupBloc.state.copyWith(isResidenceAddressSameAsAadhar: 1)],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'changes agree to address same as Aadhar',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const ChangeAgreeToAddressSameAsAadhar(true)),
        expect: () => [personalAccountSetupBloc.state.copyWith(isAgreeToAddressSameAsAadhar: true)],
      );
    });

    group('PAN and City State Events', () {
      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'gets city and state from pin code',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const GetCityAndState('400001')),
        expect:
            () => [
              predicate<PersonalAccountSetupState>((state) => state.isCityAndStateLoading == true),
              predicate<PersonalAccountSetupState>(
                (state) =>
                    state.isCityAndStateLoading == false &&
                    state.isCityAndStateVerified == true &&
                    state.cityNameController.text == 'Mumbai' &&
                    state.stateNameController.text == 'Maharashtra',
              ),
            ],
      );
    });

    group('App Bar Collapse Events', () {
      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'changes personal app bar collapse state',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const PersonalAppBarCollapseChanged(true)),
        expect: () => [personalAccountSetupBloc.state.copyWith(isCollapsed: true)],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'changes eKYC app bar collapse state',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const PersonalEkycAppBarCollapseChanged(true)),
        expect: () => [personalAccountSetupBloc.state.copyWith(isEkycCollapsed: true)],
      );
    });

    group('PAN Name Overwrite Popup Events', () {
      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'dismisses PAN name overwrite popup',
        build: () => personalAccountSetupBloc,
        seed: () => personalAccountSetupBloc.state.copyWith(showPanNameOverwrittenPopup: true),
        act: (bloc) => bloc.add(const PanNameOverwritePopupDismissed()),
        expect: () => [personalAccountSetupBloc.state.copyWith(showPanNameOverwrittenPopup: false)],
      );
    });

    group('Error Handling and Edge Cases', () {
      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'handles profession toggle with existing profession',
        build: () => personalAccountSetupBloc,
        seed: () => personalAccountSetupBloc.state.copyWith(selectedProfession: ['Software Engineer']),
        act: (bloc) => bloc.add(const ChangeProfession('Software Engineer')),
        expect: () => [personalAccountSetupBloc.state.copyWith(selectedProfession: [])],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'handles annual turnover change with error handling',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const PersonalChangeAnnualTurnover('invalid_amount')),
        expect: () => [personalAccountSetupBloc.state.copyWith(selectedAnnualTurnover: 'invalid_amount')],
      );
    });

    // Add comprehensive tests for missing coverage
    group('Additional Event Coverage', () {
      final mockFileData = FileData(name: 'test.png', path: '/path/test.png', bytes: Uint8List(0), sizeInMB: 0);

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'handles PersonalGSTVerification event',
        build: () {
          when(
            mockPersonalUserKycRepository.getGSTDetails(
              userID: anyNamed('userID'),
              estimatedAnnualIncome: anyNamed('estimatedAnnualIncome'),
              gstNumber: anyNamed('gstNumber'),
            ),
          ).thenAnswer(
            (_) async => gst_model.GetGstDetailsModel(success: true, data: gst_model.Data(legalName: 'Test Company')),
          );
          return personalAccountSetupBloc;
        },
        act: (bloc) => bloc.add(const PersonalGSTVerification(turnover: '1000000', gstNumber: 'GST123456')),
        expect:
            () => [
              predicate<PersonalAccountSetupState>((state) => state.isGstVerificationLoading == true),
              predicate<PersonalAccountSetupState>(
                (state) => state.isGstVerificationLoading == false && state.isGSTNumberVerify == true,
              ),
            ],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'handles PersonalAnnualTurnOverVerificationSubmitted event',
        build: () {
          when(
            mockPersonalUserKycRepository.uploadGSTDocument(
              userID: anyNamed('userID'),
              gstNumber: anyNamed('gstNumber'),
              userType: anyNamed('userType'),
              gstCertificate: anyNamed('gstCertificate'),
            ),
          ).thenAnswer((_) async => CommonSuccessModel(success: true, message: 'Turnover verified'));
          return personalAccountSetupBloc;
        },
        act:
            (bloc) => bloc.add(
              PersonalAnnualTurnOverVerificationSubmitted(gstNumber: 'GST123456', gstCertificate: mockFileData),
            ),
        expect:
            () => [
              predicate<PersonalAccountSetupState>((state) => state.isGstVerificationLoading == true),
              predicate<PersonalAccountSetupState>((state) => state.isGstVerificationLoading == false),
              predicate<PersonalAccountSetupState>(
                (state) => state.currentKycVerificationStep == PersonalEKycVerificationSteps.panDetails,
              ),
            ],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'handles PersonalBankAccountNumberVerify event',
        build: () {
          when(
            mockPersonalUserKycRepository.verifyBankAccount(
              accountNumber: anyNamed('accountNumber'),
              ifscCode: anyNamed('ifscCode'),
              userID: anyNamed('userID'),
              userType: anyNamed('userType'),
            ),
          ).thenAnswer(
            (_) async =>
                bank_model.BankAccountVerifyModel(success: true, data: bank_model.Data(accountHolderName: 'Test User')),
          );
          return personalAccountSetupBloc;
        },
        act:
            (bloc) =>
                bloc.add(const PersonalBankAccountNumberVerify(accountNumber: '1234567890', ifscCode: 'HDFC0001234')),
        expect:
            () => [
              predicate<PersonalAccountSetupState>((state) => state.isBankAccountNumberVerifiedLoading == true),
              predicate<PersonalAccountSetupState>(
                (state) => state.isBankAccountNumberVerifiedLoading == false && state.isBankAccountVerify == true,
              ),
            ],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'handles PersonalUpdateBankAccountVerificationDocType event',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const PersonalUpdateBankAccountVerificationDocType('bank_statement')),
        expect:
            () => [personalAccountSetupBloc.state.copyWith(selectedBankAccountVerificationDocType: 'bank_statement')],
      );

      testWidgets('handles PersonalBankAccountDetailSubmitted event', (WidgetTester tester) async {
        when(
          mockPersonalUserKycRepository.uploadBankDocuments(
            userID: anyNamed('userID'),
            userType: anyNamed('userType'),
            accountNumber: anyNamed('accountNumber'),
            ifscCode: anyNamed('ifscCode'),
            documentType: anyNamed('documentType'),
            proofDocumentImage: anyNamed('proofDocumentImage'),
          ),
        ).thenAnswer((_) async => CommonSuccessModel(success: true, message: 'Bank details submitted'));

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                personalAccountSetupBloc.emit(
                  personalAccountSetupBloc.state.copyWith(
                    currentKycVerificationStep: PersonalEKycVerificationSteps.bankAccountLinking,
                  ),
                );

                personalAccountSetupBloc.add(
                  PersonalBankAccountDetailSubmitted(
                    bankAccountVerifyFile: mockFileData,
                    documentType: 'bank_statement',
                    context: context,
                  ),
                );

                return const SizedBox();
              },
            ),
          ),
        );

        await tester.pump();

        expect(personalAccountSetupBloc.state.isBankAccountNumberVerifiedLoading, isTrue);

        await tester.pump(const Duration(milliseconds: 100));

        expect(personalAccountSetupBloc.state.isBankAccountNumberVerifiedLoading, isFalse);
      });

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'handles CaptchaSend event',
        build: () {
          when(
            mockPersonalUserKycRepository.generateCaptcha(
              aadhaarNumber: anyNamed('aadhaarNumber'),
              userID: anyNamed('userID'),
              userType: anyNamed('userType'),
            ),
          ).thenAnswer(
            (_) async => captcha_models.CaptchaModel(
              code: 200,
              data: captcha_models.Data(captcha: 'test_captcha', sessionId: 'session_123'),
            ),
          );
          return personalAccountSetupBloc;
        },
        act: (bloc) => bloc.add(const CaptchaSend()),
        expect:
            () => [
              predicate<PersonalAccountSetupState>((state) => state.isCaptchaLoading == true),
              predicate<PersonalAccountSetupState>(
                (state) =>
                    state.isCaptchaLoading == false &&
                    state.captchaImage == 'test_captcha' &&
                    state.isCaptchaSend == true,
              ),
            ],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'handles ReCaptchaSend event',
        build: () {
          when(
            mockPersonalUserKycRepository.reGenerateCaptcha(sessionId: anyNamed('sessionId')),
          ).thenAnswer((_) async => RecaptchaModel(code: 200, data: RecaptchaData(captcha: 'recaptcha_test')));
          return personalAccountSetupBloc;
        },
        act: (bloc) => bloc.add(const ReCaptchaSend()),
        expect:
            () => [
              predicate<PersonalAccountSetupState>((state) => state.isCaptchaLoading == true),
              predicate<PersonalAccountSetupState>(
                (state) =>
                    state.isCaptchaLoading == false &&
                    state.captchaImage == 'recaptcha_test' &&
                    state.isCaptchaSend == true,
              ),
            ],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'handles PersonalClearIdentityVerificationFields event',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(PersonalClearIdentityVerificationFields()),
        expect:
            () => [
              predicate<PersonalAccountSetupState>(
                (state) =>
                    state.aadharNumber == null && state.drivingLicenseNumber == null && state.voterIDNumber == null,
              ),
            ],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'handles ResidenceAddressSameAsAadhar event',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const ResidenceAddressSameAsAadhar(1)),
        expect: () => [personalAccountSetupBloc.state.copyWith(isResidenceAddressSameAsAadhar: 1)],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'handles GetPanDetails event',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const GetPanDetails('ABCDE1234F')),
        expect:
            () => [
              predicate<PersonalAccountSetupState>((state) => state.isPanDetailsLoading == true),
              predicate<PersonalAccountSetupState>(
                (state) => state.isPanDetailsLoading == false && state.fullNamePan == 'Test User',
              ),
            ],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'handles PersonalPanNumberChanged event',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const PersonalPanNumberChanged('ABCDE1234F')),
        expect: () => [predicate<PersonalAccountSetupState>((state) => state.isPanDetailsVerified == false)],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'handles GetCityAndState event',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const GetCityAndState('400001')),
        expect:
            () => [
              predicate<PersonalAccountSetupState>((state) => state.isCityAndStateLoading == true),
              predicate<PersonalAccountSetupState>(
                (state) => state.isCityAndStateLoading == false && state.isCityAndStateVerified == true,
              ),
            ],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'handles ChangeAgreeToAddressSameAsAadhar event',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const ChangeAgreeToAddressSameAsAadhar(true)),
        expect: () => [personalAccountSetupBloc.state.copyWith(isAgreeToAddressSameAsAadhar: true)],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'handles PersonalChangeAnnualTurnover event',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const PersonalChangeAnnualTurnover('2')),
        expect: () => [personalAccountSetupBloc.state.copyWith(selectedAnnualTurnover: '2')],
      );

      // Add more simple tests for better coverage
      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'handles PersonalAppBarCollapseChanged event',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const PersonalAppBarCollapseChanged(true)),
        expect: () => [personalAccountSetupBloc.state.copyWith(isCollapsed: true)],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'handles PersonalEkycAppBarCollapseChanged event',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const PersonalEkycAppBarCollapseChanged(true)),
        expect: () => [personalAccountSetupBloc.state.copyWith(isEkycCollapsed: true)],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'handles PanNameOverwritePopupDismissed event',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const PanNameOverwritePopupDismissed()),
        expect: () => [personalAccountSetupBloc.state.copyWith(showPanNameOverwrittenPopup: false)],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'handles PersonalUploadICECertificate event',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(PersonalUploadICECertificate(mockFileData)),
        expect: () => [personalAccountSetupBloc.state.copyWith(iceCertificateFile: mockFileData)],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'handles PersonalUploadGstCertificateFile event',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(PersonalUploadGstCertificateFile(fileData: mockFileData)),
        expect: () => [personalAccountSetupBloc.state.copyWith(gstCertificateFile: mockFileData)],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'handles PersonalUploadBankAccountVerificationFile event',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(PersonalUploadBankAccountVerificationFile(fileData: mockFileData)),
        expect: () => [personalAccountSetupBloc.state.copyWith(bankVerificationFile: mockFileData)],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'handles PersonalUpdateAddressVerificationDocType event',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(const PersonalUpdateAddressVerificationDocType('passport')),
        expect: () => [personalAccountSetupBloc.state.copyWith(selectedAddressVerificationDocType: 'passport')],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'handles PersonalUploadAddressVerificationFile event',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(PersonalUploadAddressVerificationFile(fileData: mockFileData)),
        expect: () => [personalAccountSetupBloc.state.copyWith(addressVerificationFile: mockFileData)],
      );

      blocTest<PersonalAccountSetupBloc, PersonalAccountSetupState>(
        'handles PersonalUploadBackAddressVerificationFile event',
        build: () => personalAccountSetupBloc,
        act: (bloc) => bloc.add(PersonalUploadBackAddressVerificationFile(fileData: mockFileData)),
        expect: () => [personalAccountSetupBloc.state.copyWith(backAddressVerificationFile: mockFileData)],
      );
    });
  });
}
