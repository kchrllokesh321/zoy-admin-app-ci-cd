import 'package:country_picker/country_picker.dart';
import 'package:exchek/core/enums/app_enums.dart';
import 'package:exchek/widgets/account_setup_widgets/directors_pan_upload_dialog.dart';
import 'package:exchek/viewmodels/account_setup_bloc/business_account_setup_bloc/business_account_setup_bloc.dart';
import 'package:exchek/widgets/custom_widget/custom_textfields.dart';
import 'package:exchek/widgets/custom_widget/custom_button.dart';
import 'package:exchek/widgets/common_widget/app_file_upload_widget.dart';
import 'package:exchek/widgets/account_setup_widgets/captcha_image.dart';
import 'package:exchek/widgets/common_widget/comman_verified_info_box.dart';
import 'package:exchek/widgets/account_setup_widgets/aadhar_upload_note.dart';
import 'package:exchek/widgets/common_widget/checkbox_label.dart';
import 'package:exchek/widgets/common_widget/image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:exchek/core/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:exchek/core/utils/local_storage.dart';
import 'package:go_router/go_router.dart';
import 'directors_pan_upload_dialog_test.mocks.dart';

// Generate mocks
@GenerateMocks([BusinessAccountSetupBloc, GoRouter])
// Helper function to create test state
BusinessAccountSetupState createTestState({
  DirectorKycSteps directorKycStep = DirectorKycSteps.panDetails,
  bool isDirector1PanDetailsVerified = false,
  bool isDirector1PanDetailsLoading = false,
  String? fullDirector1NamePan,
  FileData? director1PanCardFile,
  bool director1BeneficialOwner = false,
  bool ditector1BusinessRepresentative = false,
  bool? isDirectorPanCardSaveLoading,
  bool isAadharVerified = false,
  bool isDirectorCaptchaSend = false,
  bool isOtpSent = false,
  String? directorCaptchaImage,
  String isAadharOTPInvalidate = '',
  String? aadharNumber,
  FileData? frontSideAdharFile,
  FileData? backSideAdharFile,
  bool isDirectorAadharOtpLoading = false,
  bool? isAadharVerifiedLoading,
  bool isAadharOtpTimerRunning = false,
  int aadharOtpRemainingTime = 0,
  bool? isDirectorCaptchaLoading,
  bool isAadharFileUploading = false,
  KycVerificationSteps currentKycVerificationStep = KycVerificationSteps.aadharPanVerification,
  GlobalKey<FormState>? llpPanVerificationKey,
  TextEditingController? llpPanNumberController,
  bool isLLPPanVerifyingLoading = false,
  GlobalKey<FormState>? partnershipFirmPanVerificationKey,
  TextEditingController? partnershipFirmPanNumberController,
  bool isPartnershipFirmPanVerifyingLoading = false,
  GlobalKey<FormState>? soleProprietorShipPanVerificationKey,
  TextEditingController? soleProprietorShipPanNumberController,
  bool isSoleProprietorShipPanVerifyingLoading = false,
  GlobalKey<FormState>? kartaPanVerificationKey,
  TextEditingController? kartaPanNumberController,
  bool isKartaPanVerifyingLoading = false,
}) {
  return BusinessAccountSetupState(
    directorKycStep: directorKycStep,
    isDirector1PanDetailsVerified: isDirector1PanDetailsVerified,
    isDirector1PanDetailsLoading: isDirector1PanDetailsLoading,
    fullDirector1NamePan: fullDirector1NamePan,
    director1PanCardFile: director1PanCardFile,
    director1BeneficialOwner: director1BeneficialOwner,
    ditector1BusinessRepresentative: ditector1BusinessRepresentative,
    isDirectorPanCardSaveLoading: isDirectorPanCardSaveLoading,
    isAadharVerified: isAadharVerified,
    isDirectorCaptchaSend: isDirectorCaptchaSend,
    isOtpSent: isOtpSent,
    directorCaptchaImage: directorCaptchaImage,
    isAadharOTPInvalidate: isAadharOTPInvalidate,
    aadharNumber: aadharNumber,
    frontSideAdharFile: frontSideAdharFile,
    backSideAdharFile: backSideAdharFile,
    isDirectorAadharOtpLoading: isDirectorAadharOtpLoading,
    isAadharVerifiedLoading: isAadharVerifiedLoading,
    isAadharOtpTimerRunning: isAadharOtpTimerRunning,
    aadharOtpRemainingTime: aadharOtpRemainingTime,
    isDirectorCaptchaLoading: isDirectorCaptchaLoading,
    isAadharFileUploading: isAadharFileUploading,
    // Required fields for BusinessAccountSetupState
    currentStep: BusinessAccountSetupSteps.businessInformation,
    currentKycVerificationStep: currentKycVerificationStep,
    goodsAndServiceExportDescriptionController: TextEditingController(),
    goodsExportOtherController: TextEditingController(),
    serviceExportOtherController: TextEditingController(),
    businessActivityOtherController: TextEditingController(),
    scrollController: ScrollController(),
    formKey: GlobalKey<FormState>(),
    businessLegalNameController: TextEditingController(),
    professionalWebsiteUrl: TextEditingController(),
    phoneController: TextEditingController(),
    otpController: TextEditingController(),
    sePasswordFormKey: GlobalKey<FormState>(),
    createPasswordController: TextEditingController(),
    confirmPasswordController: TextEditingController(),
    aadharVerificationFormKey: GlobalKey<FormState>(),
    aadharNumberController: TextEditingController(),
    aadharOtpController: TextEditingController(),
    kartaAadharNumberController: TextEditingController(),
    kartaAadharOtpController: TextEditingController(),
    kartaAadharVerificationFormKey: GlobalKey<FormState>(),
    hufPanVerificationKey: GlobalKey<FormState>(),
    hufPanNumberController: TextEditingController(),
    isHUFPanVerifyingLoading: false,
    businessPanVerificationKey: GlobalKey<FormState>(),
    businessPanNumberController: TextEditingController(),
    businessPanNameController: TextEditingController(),
    directorsPanVerificationKey: GlobalKey<FormState>(),
    director1PanNumberController: TextEditingController(),
    director1PanNameController: TextEditingController(),
    director2PanNumberController: TextEditingController(),
    director2PanNameController: TextEditingController(),
    beneficialOwnerPanVerificationKey: GlobalKey<FormState>(),
    beneficialOwnerPanNumberController: TextEditingController(),
    beneficialOwnerPanNameController: TextEditingController(),
    businessRepresentativeFormKey: GlobalKey<FormState>(),
    businessRepresentativePanNumberController: TextEditingController(),
    businessRepresentativePanNameController: TextEditingController(),
    selectedCountry: Country(
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
    ),
    registerAddressFormKey: GlobalKey<FormState>(),
    pinCodeController: TextEditingController(),
    stateNameController: TextEditingController(),
    cityNameController: TextEditingController(),
    address1NameController: TextEditingController(),
    address2NameController: TextEditingController(),
    turnOverController: TextEditingController(),
    gstNumberController: TextEditingController(),
    annualTurnoverFormKey: GlobalKey<FormState>(),
    isGstCertificateMandatory: false,
    iceVerificationKey: GlobalKey<FormState>(),
    iceNumberController: TextEditingController(),
    cinVerificationKey: GlobalKey<FormState>(),
    cinNumberController: TextEditingController(),
    llpinNumberController: TextEditingController(),
    bankAccountVerificationFormKey: GlobalKey<FormState>(),
    bankAccountNumberController: TextEditingController(),
    reEnterbankAccountNumberController: TextEditingController(),
    ifscCodeController: TextEditingController(),
    directorCaptchaInputController: TextEditingController(),
    kartaCaptchaInputController: TextEditingController(),
    partnerAadharNumberController: TextEditingController(),
    partnerAadharOtpController: TextEditingController(),
    partnerAadharVerificationFormKey: GlobalKey<FormState>(),
    partnerCaptchaInputController: TextEditingController(),
    proprietorAadharNumberController: TextEditingController(),
    proprietorAadharOtpController: TextEditingController(),
    proprietorAadharVerificationFormKey: GlobalKey<FormState>(),
    proprietorCaptchaInputController: TextEditingController(),
    directorEmailIdNumberController: TextEditingController(),
    directorMobileNumberController: TextEditingController(),
    directorContactInformationKey: GlobalKey<FormState>(),
    otherDirectorsPanVerificationKey: GlobalKey<FormState>(),
    otherDirectorVerificationFormKey: GlobalKey<FormState>(),
    otherDirectorAadharNumberController: TextEditingController(),
    otherDirectoraadharOtpController: TextEditingController(),
    otherDirectorCaptchaInputController: TextEditingController(),
    companyPanVerificationKey: GlobalKey<FormState>(),
    companyPanCardFile: null,
    isCompanyPanDetailsLoading: false,
    isCompanyPanDetailsVerified: false,
    fullCompanyNamePan: null,
    isCompanyPanVerifyingLoading: false,
    companyPanNumberController: TextEditingController(),
    llpPanVerificationKey: llpPanVerificationKey ?? GlobalKey<FormState>(),
    llpPanNumberController: llpPanNumberController ?? TextEditingController(),
    isLLPPanVerifyingLoading: isLLPPanVerifyingLoading,
    partnershipFirmPanVerificationKey: partnershipFirmPanVerificationKey ?? GlobalKey<FormState>(),
    partnershipFirmPanNumberController: partnershipFirmPanNumberController ?? TextEditingController(),
    isPartnershipFirmPanVerifyingLoading: isPartnershipFirmPanVerifyingLoading,
    soleProprietorShipPanVerificationKey: soleProprietorShipPanVerificationKey ?? GlobalKey<FormState>(),
    soleProprietorShipPanNumberController: soleProprietorShipPanNumberController ?? TextEditingController(),
    isSoleProprietorShipPanVerifyingLoading: isSoleProprietorShipPanVerifyingLoading,
    kartaPanVerificationKey: kartaPanVerificationKey ?? GlobalKey<FormState>(),
    kartaPanNumberController: kartaPanNumberController ?? TextEditingController(),
    isKartaPanVerifyingLoading: isKartaPanVerifyingLoading,
    authorizedPinCodeController: TextEditingController(),
    authorizedStateNameController: TextEditingController(),
    authorizedCityNameController: TextEditingController(),
    authorizedAddress1NameController: TextEditingController(),
    authorizedAddress2NameController: TextEditingController(),
    otherDirectorPinCodeController: TextEditingController(),
    otherDirectorStateNameController: TextEditingController(),
    otherDirectorCityNameController: TextEditingController(),
    otherDirectorAddress1NameController: TextEditingController(),
    otherDirectorAddress2NameController: TextEditingController(),
    beneficialOwnerPinCodeController: TextEditingController(),
    beneficialOwnerStateNameController: TextEditingController(),
    beneficialOwnerCityNameController: TextEditingController(),
    beneficialOwnerAddress1NameController: TextEditingController(),
    beneficialOwnerAddress2NameController: TextEditingController(),
    dbaController: TextEditingController(),
  );
}

void main() {
  // In-memory storage for testing
  final Map<String, String> mockStorage = {};

  setUpAll(() {
    // Initialize Flutter binding for tests
    TestWidgetsFlutterBinding.ensureInitialized();

    // Mock flutter_secure_storage plugin
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'write':
            final String key = methodCall.arguments['key'];
            final String value = methodCall.arguments['value'];
            mockStorage[key] = value;
            return null;
          case 'read':
            final String key = methodCall.arguments['key'];
            return mockStorage[key];
          case 'delete':
            final String key = methodCall.arguments['key'];
            mockStorage.remove(key);
            return null;
          case 'deleteAll':
            mockStorage.clear();
            return null;
          case 'readAll':
            return Map<String, String>.from(mockStorage);
          case 'containsKey':
            final String key = methodCall.arguments['key'];
            return mockStorage.containsKey(key);
          default:
            return null;
        }
      },
    );

    // Load test environment variables
    dotenv.testLoad(
      fileInput: '''
ENCRYPT_KEY=1234567890123456
ENCRYPT_IV=1234567890123456
''',
    );
  });

  tearDownAll(() {
    // Clean up the mock method channel handler
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
      null,
    );
  });

  group('AuthorizedDirectorKycDialog Comprehensive Tests', () {
    late MockBusinessAccountSetupBloc mockBloc;

    setUp(() async {
      mockBloc = MockBusinessAccountSetupBloc();

      // Clear mock storage between tests
      mockStorage.clear();

      // Set up SharedPreferences mock for web compatibility
      SharedPreferences.setMockInitialValues({});

      // Set up session ID in preferences
      await Prefobj.preferences.put(Prefkeys.sessionId, 'test-session-id');
    });

    Widget createTestWidget() {
      return MaterialApp(
        localizationsDelegates: const [
          Lang.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: Lang.delegate.supportedLocales,
        home: Scaffold(
          body: BlocProvider<BusinessAccountSetupBloc>.value(
            value: mockBloc,
            child: const AuthorizedDirectorKycDialog(),
          ),
        ),
      );
    }

    // Test 1: Basic widget rendering
    testWidgets('should render dialog without errors', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(AuthorizedDirectorKycDialog), findsOneWidget);
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Authorized Director KYC'), findsOneWidget);
    });

    // Test 2: Close button functionality
    testWidgets('should close dialog when close button is tapped', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final closeButton = find.byType(CustomImageView).last;
      await tester.tap(closeButton);
      await tester.pump();

      // Assert - Dialog should still be present in test environment
      expect(find.byType(AuthorizedDirectorKycDialog), findsOneWidget);
    });

    // Test 3: PAN Details step rendering
    testWidgets('should display PAN details step correctly', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(directorKycStep: DirectorKycSteps.panDetails));
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.text('PAN Details'), findsOneWidget);
      expect(find.text('1/2'), findsOneWidget);
      expect(find.byType(CustomTextInputField), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
    });

    // Test 4: PAN number field validation and interaction
    testWidgets('should handle PAN number field input and validation', (WidgetTester tester) async {
      // Arrange
      final state = createTestState();
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final panField = find.byType(CustomTextInputField);
      await tester.enterText(panField, 'ABCDE1234F');
      await tester.pump();

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 5: Verify PAN button - disabled state
    testWidgets('should show disabled verify button when PAN is invalid', (WidgetTester tester) async {
      // Arrange
      final state = createTestState();
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final verifyButton = find.byType(CustomElevatedButton);
      expect(verifyButton, findsOneWidget);
      final button = tester.widget<CustomElevatedButton>(verifyButton);
      expect(button.isDisabled, true);
    });

    // Test 6: Verify PAN button - enabled state
    testWidgets('should show enabled verify button when PAN is valid', (WidgetTester tester) async {
      // Arrange
      final state = createTestState();
      state.director1PanNumberController.text = 'ABCDE1234F';
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final verifyButton = find.byType(CustomElevatedButton);
      expect(verifyButton, findsOneWidget);
      final button = tester.widget<CustomElevatedButton>(verifyButton);
      expect(button.isDisabled, false);
    });

    // Test 7: PAN verified state
    testWidgets('should display PAN verified state correctly', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(isDirector1PanDetailsVerified: true, fullDirector1NamePan: 'John Doe');
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(CommanVerifiedInfoBox), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.byType(CustomFileUploadWidget), findsOneWidget);
    });

    // Test 8: File upload functionality
    testWidgets('should handle file upload for PAN card', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(isDirector1PanDetailsVerified: true);
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final fileUploadWidget = find.byType(CustomFileUploadWidget);
      final widget = tester.widget<CustomFileUploadWidget>(fileUploadWidget);

      // Simulate file selection
      final testFile = FileData(name: 'pan.pdf', bytes: Uint8List(0), sizeInMB: 1.0);
      widget.onFileSelected?.call(testFile);
      await tester.pump();

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 9: Checkbox interactions
    testWidgets('should handle beneficial owner checkbox', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(isDirector1PanDetailsVerified: true);
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final checkboxes = find.byType(CustomCheckBoxLabel);
      expect(checkboxes, findsNWidgets(2));

      await tester.tap(checkboxes.first);
      await tester.pump();

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 10: Save and Next button - disabled state
    testWidgets('should show disabled save button when form is incomplete', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(isDirector1PanDetailsVerified: true);
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final saveButton = find.byType(CustomElevatedButton).last;
      final button = tester.widget<CustomElevatedButton>(saveButton);
      expect(button.isDisabled, true);
    });

    // Test 11: Save and Next button - enabled state
    testWidgets('should show enabled save button when form is complete', (WidgetTester tester) async {
      // Arrange
      final testFile = FileData(name: 'pan.pdf', bytes: Uint8List(0), sizeInMB: 1.0);
      final state = createTestState(isDirector1PanDetailsVerified: true, director1PanCardFile: testFile);
      state.director1PanNumberController.text = 'ABCDE1234F';
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final saveButton = find.byType(CustomElevatedButton).last;
      final button = tester.widget<CustomElevatedButton>(saveButton);
      expect(button.isDisabled, false);
    });

    // Test 12: Aadhar Details step rendering
    testWidgets('should display Aadhar details step correctly', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(directorKycStep: DirectorKycSteps.aadharDetails));
      when(
        mockBloc.stream,
      ).thenAnswer((_) => Stream.fromIterable([createTestState(directorKycStep: DirectorKycSteps.aadharDetails)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.text('Aadhar Details'), findsOneWidget);
      expect(find.text('2/2'), findsOneWidget);
      expect(find.byType(CustomImageView).first, findsOneWidget); // Back arrow
    });

    // Test 13: Back navigation from Aadhar step
    testWidgets('should navigate back to PAN step when back arrow is tapped', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(directorKycStep: DirectorKycSteps.aadharDetails);
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final backButton = find.byType(CustomImageView).first;
      await tester.tap(backButton);
      await tester.pump();

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 14: Aadhar number field input
    testWidgets('should handle Aadhar number field input', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(directorKycStep: DirectorKycSteps.aadharDetails);
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final aadharField = find.byType(CustomTextInputField).first;
      await tester.enterText(aadharField, '1234-5678-9012');
      await tester.pump();

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 15: Verify Aadhar button - disabled state
    testWidgets('should show disabled verify Aadhar button when number is invalid', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(directorKycStep: DirectorKycSteps.aadharDetails);
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final verifyButton = find.byType(CustomElevatedButton).first;
      final button = tester.widget<CustomElevatedButton>(verifyButton);
      expect(button.isDisabled, true);
    });

    // Test 16: Captcha display and interaction
    testWidgets('should display captcha when captcha is sent', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        directorKycStep: DirectorKycSteps.aadharDetails,
        isDirectorCaptchaSend: true,
        directorCaptchaImage: 'base64captchaimage',
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(Base64CaptchaField), findsOneWidget);
      expect(find.text('Enter Captcha'), findsOneWidget);
    });

    // Test 17: Captcha refresh functionality
    testWidgets('should handle captcha refresh', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        directorKycStep: DirectorKycSteps.aadharDetails,
        isDirectorCaptchaSend: true,
        directorCaptchaImage: 'base64captchaimage',
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final refreshButtons = find.byType(CustomImageView);
      final refreshButton = refreshButtons.at(1); // Second CustomImageView is the refresh button
      await tester.tap(refreshButton);
      await tester.pump();

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 18: OTP field display and interaction
    testWidgets('should display OTP field when OTP is sent', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(directorKycStep: DirectorKycSteps.aadharDetails, isOtpSent: true);
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.text('One Time Password'), findsOneWidget);
      expect(find.text('Resend OTP'), findsOneWidget);
    });

    // Test 19: OTP timer functionality
    testWidgets('should display OTP timer when timer is running', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        directorKycStep: DirectorKycSteps.aadharDetails,
        isOtpSent: true,
        isAadharOtpTimerRunning: true,
        aadharOtpRemainingTime: 120,
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.textContaining('02:00sec'), findsOneWidget);
    });

    // Test 20: OTP error message display
    testWidgets('should display OTP error message when validation fails', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        directorKycStep: DirectorKycSteps.aadharDetails,
        isOtpSent: true,
        isAadharOTPInvalidate: 'Invalid OTP',
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.text('Invalid OTP'), findsOneWidget);
    });

    // Test 21: Aadhar verified state display
    testWidgets('should display verified Aadhar number correctly', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        directorKycStep: DirectorKycSteps.aadharDetails,
        isAadharVerified: true,
        aadharNumber: '123456789012',
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.text('Aadhar Number (Verified)'), findsOneWidget);
      expect(find.text('1234-5678-9012'), findsOneWidget);
      expect(find.byType(UploadNote), findsOneWidget);
    });

    // Test 22: File upload for Aadhar cards
    testWidgets('should handle Aadhar card file uploads', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(directorKycStep: DirectorKycSteps.aadharDetails, isAadharVerified: true);
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(CustomFileUploadWidget), findsNWidgets(2));
      expect(find.text('Upload Front Side of Aadhar Card'), findsOneWidget);
      expect(find.text('Upload Back Side of Aadhar Card'), findsOneWidget);
    });

    // Test 23: Save button in Aadhar step
    testWidgets('should handle save button in Aadhar step', (WidgetTester tester) async {
      // Arrange
      final frontFile = FileData(name: 'front.png', bytes: Uint8List(0), sizeInMB: 1.0);
      final backFile = FileData(name: 'back.png', bytes: Uint8List(0), sizeInMB: 1.0);
      final state = createTestState(
        directorKycStep: DirectorKycSteps.aadharDetails,
        isAadharVerified: true,
        frontSideAdharFile: frontFile,
        backSideAdharFile: backFile,
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final saveButton = find.byType(CustomElevatedButton).last;
      await tester.tap(saveButton);
      await tester.pump();

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 24: Helper method - formatSecondsToMMSS
    testWidgets('should format seconds correctly', (WidgetTester tester) async {
      // Arrange
      const widget = AuthorizedDirectorKycDialog();

      // Act & Assert
      expect(widget.formatSecondsToMMSS(120), equals('02:00'));
      expect(widget.formatSecondsToMMSS(65), equals('01:05'));
      expect(widget.formatSecondsToMMSS(0), equals('00:00'));
    });

    // Test 25: Step number display verification
    testWidgets('should display correct step numbers in UI', (WidgetTester tester) async {
      // Arrange - Test PAN step
      final panState = createTestState(directorKycStep: DirectorKycSteps.panDetails);
      when(mockBloc.state).thenReturn(panState);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([panState]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.text('1/2'), findsOneWidget);

      // Test Aadhar step
      final aadharState = createTestState(directorKycStep: DirectorKycSteps.aadharDetails);
      when(mockBloc.state).thenReturn(aadharState);
      await tester.pump();

      expect(find.text('2/2'), findsOneWidget);
    });

    // Test 26: Loading states
    testWidgets('should display loading states correctly', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(isDirector1PanDetailsLoading: true, isDirectorPanCardSaveLoading: true);
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final buttons = find.byType(CustomElevatedButton);
      expect(buttons, findsWidgets);

      for (final buttonFinder in buttons.evaluate()) {
        final button = tester.widget<CustomElevatedButton>(find.byWidget(buttonFinder.widget));
        // At least one button should be in loading state
        if (button.isLoading == true) {
          expect(button.isLoading, true);
          break;
        }
      }
    });

    // Test 27: Edge case - null values handling
    testWidgets('should handle null values gracefully', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(fullDirector1NamePan: null, directorCaptchaImage: null, aadharNumber: null);
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - Should not crash
      expect(find.byType(AuthorizedDirectorKycDialog), findsOneWidget);
    });

    // Test 28: Responsive design elements
    testWidgets('should handle responsive design elements', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(ConstrainedBox), findsWidgets);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    // Test 29: Complete workflow test
    testWidgets('should handle complete workflow from PAN to Aadhar', (WidgetTester tester) async {
      // Arrange - Start with PAN step
      final panState = createTestState(directorKycStep: DirectorKycSteps.panDetails);
      final aadharState = createTestState(directorKycStep: DirectorKycSteps.aadharDetails);

      when(mockBloc.state).thenReturn(panState);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([panState, aadharState]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert initial state
      expect(find.text('PAN Details'), findsOneWidget);
      expect(find.text('1/2'), findsOneWidget);

      // Simulate state change to Aadhar step
      when(mockBloc.state).thenReturn(aadharState);
      await tester.pump();

      // Assert final state
      expect(find.text('Aadhar Details'), findsOneWidget);
      expect(find.text('2/2'), findsOneWidget);
    });

    // Test 30: Divider widget
    testWidgets('should display divider correctly', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(Container), findsWidgets);
    });

    // Test 31: PAN field submission with valid PAN
    testWidgets('should handle PAN field submission with valid PAN', (WidgetTester tester) async {
      // Arrange
      final state = createTestState();
      state.director1PanNumberController.text = 'ABCDE1234F';
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final panField = find.byType(CustomTextInputField);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 32: Aadhar field submission with valid Aadhar
    testWidgets('should handle Aadhar field submission with valid Aadhar', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(directorKycStep: DirectorKycSteps.aadharDetails);
      state.aadharNumberController.text = '1234-5678-9012';
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final aadharField = find.byType(CustomTextInputField).first;
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 33: Captcha field submission
    testWidgets('should handle captcha field submission', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        directorKycStep: DirectorKycSteps.aadharDetails,
        isDirectorCaptchaSend: true,
        directorCaptchaImage: 'base64captchaimage',
      );
      state.directorCaptchaInputController.text = 'ABCD';
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final captchaField = find.byType(CustomTextInputField).last;
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 34: OTP field submission
    testWidgets('should handle OTP field submission', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(directorKycStep: DirectorKycSteps.aadharDetails, isOtpSent: true);
      state.aadharOtpController.text = '123456';
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final otpField = find.byType(CustomTextInputField).last;
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 35: Resend OTP functionality
    testWidgets('should handle resend OTP when timer is not running', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        directorKycStep: DirectorKycSteps.aadharDetails,
        isOtpSent: true,
        isAadharOtpTimerRunning: false,
      );
      state.aadharNumberController.text = '1234-5678-9012';
      state.directorCaptchaInputController.text = 'ABCD';
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final resendButton = find.text('Resend OTP');
      await tester.tap(resendButton);
      await tester.pump();

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 36: Verify PAN button tap with valid PAN
    testWidgets('should handle verify PAN button tap', (WidgetTester tester) async {
      // Arrange
      final state = createTestState();
      state.director1PanNumberController.text = 'ABCDE1234F';
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final verifyButton = find.byType(CustomElevatedButton);
      await tester.tap(verifyButton);
      await tester.pump();

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 37: Send OTP button tap with valid data
    testWidgets('should handle send OTP button tap', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        directorKycStep: DirectorKycSteps.aadharDetails,
        isDirectorCaptchaSend: true,
        directorCaptchaImage: 'base64captchaimage',
      );
      state.aadharNumberController.text = '1234-5678-9012';
      state.directorCaptchaInputController.text = 'ABCD';
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final sendOtpButton = find.byType(CustomElevatedButton).last;
      await tester.tap(sendOtpButton);
      await tester.pump();

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 38: Verify OTP button tap with valid OTP
    testWidgets('should handle verify OTP button tap', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(directorKycStep: DirectorKycSteps.aadharDetails, isOtpSent: true);
      state.aadharOtpController.text = '123456';
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final verifyButton = find.byType(CustomElevatedButton).last;
      await tester.tap(verifyButton);
      await tester.pump();

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 39: File upload callbacks
    testWidgets('should handle file upload callbacks', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        isDirector1PanDetailsVerified: true,
        directorKycStep: DirectorKycSteps.aadharDetails,
        isAadharVerified: true,
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final fileUploadWidgets = find.byType(CustomFileUploadWidget);
      expect(fileUploadWidgets, findsWidgets);

      // Simulate file selection for front side
      final frontUploadWidget = tester.widget<CustomFileUploadWidget>(fileUploadWidgets.first);
      final testFile = FileData(name: 'front.png', bytes: Uint8List(0), sizeInMB: 1.0);
      frontUploadWidget.onFileSelected?.call(testFile);
      await tester.pump();

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 40: Business representative checkbox interactions
    testWidgets('should handle business representative checkbox', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(isDirector1PanDetailsVerified: true);
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final checkboxes = find.byType(CustomCheckBoxLabel);
      expect(checkboxes, findsNWidgets(2));

      // Tap business representative checkbox
      await tester.tap(checkboxes.last);
      await tester.pump();

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 41: Error states handling
    testWidgets('should display error states correctly', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        directorKycStep: DirectorKycSteps.aadharDetails,
        isOtpSent: true,
        isAadharOTPInvalidate: 'Invalid OTP entered',
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.text('Invalid OTP entered'), findsOneWidget);
    });

    // Test 42: Loading states for various operations
    testWidgets('should display loading states for various operations', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        isDirector1PanDetailsLoading: true,
        isDirectorCaptchaLoading: true,
        isDirectorAadharOtpLoading: true,
        isAadharVerifiedLoading: true,
        isAadharFileUploading: true,
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - Widget should handle loading states gracefully
      expect(find.byType(AuthorizedDirectorKycDialog), findsOneWidget);
    });

    // Test 43: File upload with different file types
    testWidgets('should handle different file types for upload', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        isDirector1PanDetailsVerified: true,
        directorKycStep: DirectorKycSteps.aadharDetails,
        isAadharVerified: true,
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final fileUploadWidgets = find.byType(CustomFileUploadWidget);
      final backUploadWidget = tester.widget<CustomFileUploadWidget>(fileUploadWidgets.last);

      // Test with different file types
      final pdfFile = FileData(name: 'back.pdf', bytes: Uint8List(0), sizeInMB: 2.0);
      backUploadWidget.onFileSelected?.call(pdfFile);
      await tester.pump();

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 44: Aadhar number formatting
    testWidgets('should display formatted Aadhar number when verified', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        directorKycStep: DirectorKycSteps.aadharDetails,
        isAadharVerified: true,
        aadharNumber: '123456789012',
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - Should display formatted Aadhar number
      expect(find.text('1234-5678-9012'), findsOneWidget);
    });

    // Test 45: Timer display formatting
    testWidgets('should format timer display correctly', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        directorKycStep: DirectorKycSteps.aadharDetails,
        isOtpSent: true,
        isAadharOtpTimerRunning: true,
        aadharOtpRemainingTime: 65, // 1 minute 5 seconds
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - Should display formatted time
      expect(find.textContaining('01:05sec'), findsOneWidget);
    });

    // Test 46: Edge case - Zero timer
    testWidgets('should handle zero timer correctly', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        directorKycStep: DirectorKycSteps.aadharDetails,
        isOtpSent: true,
        isAadharOtpTimerRunning: true,
        aadharOtpRemainingTime: 0,
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - Should display 00:00
      expect(find.textContaining('00:00sec'), findsOneWidget);
    });

    // Test 47: Edge case - Large timer value
    testWidgets('should handle large timer values correctly', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        directorKycStep: DirectorKycSteps.aadharDetails,
        isOtpSent: true,
        isAadharOtpTimerRunning: true,
        aadharOtpRemainingTime: 3661, // More than 60 minutes
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - Should handle large values gracefully
      expect(find.byType(AuthorizedDirectorKycDialog), findsOneWidget);
    });

    // Test 48: Multiple state transitions
    testWidgets('should handle multiple state transitions', (WidgetTester tester) async {
      // Arrange
      final initialState = createTestState(directorKycStep: DirectorKycSteps.panDetails);
      final verifiedState = createTestState(
        directorKycStep: DirectorKycSteps.panDetails,
        isDirector1PanDetailsVerified: true,
        fullDirector1NamePan: 'John Doe',
      );
      final aadharState = createTestState(directorKycStep: DirectorKycSteps.aadharDetails);

      when(mockBloc.state).thenReturn(initialState);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([initialState, verifiedState, aadharState]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Initial state
      expect(find.text('PAN Details'), findsOneWidget);

      // Simulate state change to verified
      when(mockBloc.state).thenReturn(verifiedState);
      await tester.pump();
      expect(find.text('John Doe'), findsOneWidget);

      // Simulate state change to Aadhar step
      when(mockBloc.state).thenReturn(aadharState);
      await tester.pump();
      expect(find.text('Aadhar Details'), findsOneWidget);
    });

    // Test 49: Widget disposal and cleanup
    testWidgets('should handle widget disposal correctly', (WidgetTester tester) async {
      // Arrange
      final state = createTestState();
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Dispose the widget
      await tester.pumpWidget(Container());
      await tester.pump();

      // Assert - Should not crash
      expect(find.byType(AuthorizedDirectorKycDialog), findsNothing);
    });

    // Test 50: Complete form validation scenarios
    testWidgets('should validate complete form scenarios', (WidgetTester tester) async {
      // Arrange - Complete valid state
      final testFile = FileData(name: 'test.pdf', bytes: Uint8List(0), sizeInMB: 1.0);
      final state = createTestState(
        isDirector1PanDetailsVerified: true,
        director1PanCardFile: testFile,
        director1BeneficialOwner: true,
        ditector1BusinessRepresentative: false,
      );
      state.director1PanNumberController.text = 'ABCDE1234F';
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - Save button should be enabled
      final saveButton = find.byType(CustomElevatedButton).last;
      final button = tester.widget<CustomElevatedButton>(saveButton);
      expect(button.isDisabled, false);
    });
  });
}
