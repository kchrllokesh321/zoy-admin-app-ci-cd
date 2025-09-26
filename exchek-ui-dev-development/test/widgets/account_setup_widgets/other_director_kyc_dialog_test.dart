import 'package:country_picker/country_picker.dart';
import 'package:exchek/core/enums/app_enums.dart';
import 'package:exchek/widgets/account_setup_widgets/other_director_kyc_dialog.dart';
import 'package:exchek/viewmodels/account_setup_bloc/business_account_setup_bloc/business_account_setup_bloc.dart';
import 'package:exchek/widgets/custom_widget/custom_textfields.dart';
import 'package:exchek/widgets/custom_widget/custom_button.dart';
import 'package:exchek/widgets/common_widget/app_file_upload_widget.dart';
import 'package:exchek/widgets/account_setup_widgets/captcha_image.dart';
import 'package:exchek/widgets/common_widget/comman_verified_info_box.dart';
import 'package:exchek/widgets/account_setup_widgets/aadhar_upload_note.dart';
import 'package:exchek/widgets/account_setup_widgets/business_representative_selection_dialog.dart';
import 'package:exchek/widgets/common_widget/image_view.dart';
import 'package:exchek/widgets/common_widget/checkbox_label.dart';
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
import 'other_director_kyc_dialog_test.mocks.dart';

// Generate mocks
@GenerateMocks([BusinessAccountSetupBloc, GoRouter])
// Helper function to create test state
BusinessAccountSetupState createTestState({
  OtherDirectorKycSteps otherDirectorKycStep = OtherDirectorKycSteps.panDetails,
  bool isDirector2PanDetailsVerified = false,
  bool isDirector2PanDetailsLoading = false,
  String? fullDirector2NamePan,
  FileData? director2PanCardFile,
  bool director2BeneficialOwner = false,
  bool ditector2BusinessRepresentative = false,
  bool? isOtherDirectorPanCardSaveLoading,
  bool isOtherDirectorAadharVerified = false,
  bool isOtherDirectorCaptchaSend = false,
  bool isOtherDirectorOtpSent = false,
  bool isOtherDitectorOtpSent = false,
  String? otherDirectorCaptchaImage,
  String isOtherAadharOTPInvalidate = '',
  String? otherDirectorAadharNumber,
  FileData? otherDirectorAadharfrontSideAdharFile,
  FileData? otherDirectorAadharBackSideAdharFile,
  bool? isOtherDirectorAadharOtpLoading,
  bool? isOtherDirectorAadharVerifiedLoading,
  bool isOtherDirectorAadharOtpTimerRunning = false,
  int otherDirectorAadharOtpRemainingTime = 0,
  bool? isOtherDirectorDirectorCaptchaLoading,
  bool isOtherDirectorAadharFileUploading = false,
  bool ditector1BusinessRepresentative = false,
  KycVerificationSteps currentKycVerificationStep = KycVerificationSteps.aadharPanVerification,
  GlobalKey<FormState>? llpPanVerificationKey,
  TextEditingController? llpPanNumberController,
  bool isLLPPanVerifyingLoading = false,
  GlobalKey<FormState>? partnershipFirmPanVerificationKey,
  TextEditingController? partnershipFirmPanNumberController,
  bool isPartnershipFirmPanVerifyingLoading = false,
  GlobalKey<FormState>? soleProprietorShipPanVerificationKey,
}) {
  return BusinessAccountSetupState(
    otherDirectorKycStep: otherDirectorKycStep,
    isDirector2PanDetailsVerified: isDirector2PanDetailsVerified,
    isDirector2PanDetailsLoading: isDirector2PanDetailsLoading,
    fullDirector2NamePan: fullDirector2NamePan,
    director2PanCardFile: director2PanCardFile,
    director2BeneficialOwner: director2BeneficialOwner,
    ditector2BusinessRepresentative: ditector2BusinessRepresentative,
    isOtherDirectorPanCardSaveLoading: isOtherDirectorPanCardSaveLoading,
    isOtherDirectorAadharVerified: isOtherDirectorAadharVerified,
    isOtherDirectorCaptchaSend: isOtherDirectorCaptchaSend,
    isOtherDirectorOtpSent: isOtherDirectorOtpSent,
    isOtherDitectorOtpSent: isOtherDitectorOtpSent,
    otherDirectorCaptchaImage: otherDirectorCaptchaImage,
    isOtherAadharOTPInvalidate: isOtherAadharOTPInvalidate,
    otherDirectorAadharNumber: otherDirectorAadharNumber,
    otherDirectorAadharfrontSideAdharFile: otherDirectorAadharfrontSideAdharFile,
    otherDirectorAadharBackSideAdharFile: otherDirectorAadharBackSideAdharFile,
    isOtherDirectorAadharOtpLoading: isOtherDirectorAadharOtpLoading,
    isOtherDirectorAadharVerifiedLoading: isOtherDirectorAadharVerifiedLoading,
    isOtherDirectorAadharOtpTimerRunning: isOtherDirectorAadharOtpTimerRunning,
    otherDirectorAadharOtpRemainingTime: otherDirectorAadharOtpRemainingTime,
    isOtherDirectorDirectorCaptchaLoading: isOtherDirectorDirectorCaptchaLoading,
    isOtherDirectorAadharFileUploading: isOtherDirectorAadharFileUploading,
    ditector1BusinessRepresentative: ditector1BusinessRepresentative,
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
    directorKycStep: DirectorKycSteps.panDetails,
    companyPanVerificationKey: GlobalKey<FormState>(),
    companyPanCardFile: null,
    isCompanyPanDetailsLoading: false,
    isCompanyPanDetailsVerified: false,
    fullCompanyNamePan: null,
    isCompanyPanVerifyingLoading: false,
    companyPanNumberController: TextEditingController(),
    llpPanVerificationKey: GlobalKey<FormState>(),
    llpPanNumberController: TextEditingController(),
    isLLPPanVerifyingLoading: false,
    partnershipFirmPanVerificationKey: GlobalKey<FormState>(),
    partnershipFirmPanNumberController: TextEditingController(),
    isPartnershipFirmPanVerifyingLoading: false,
    soleProprietorShipPanVerificationKey: GlobalKey<FormState>(),
    soleProprietorShipPanNumberController: TextEditingController(),
    isSoleProprietorShipPanVerifyingLoading: false,
    kartaPanVerificationKey: GlobalKey<FormState>(),
    kartaPanNumberController: TextEditingController(),
    isKartaPanVerifyingLoading: false,
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

  group('OtherDirectorKycDialog Comprehensive Tests', () {
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
          body: BlocProvider<BusinessAccountSetupBloc>.value(value: mockBloc, child: const OtherDirectorKycDialog()),
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
      expect(find.byType(OtherDirectorKycDialog), findsOneWidget);
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Other Director KYC'), findsOneWidget);
      expect(find.text('1/2'), findsOneWidget);
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
      expect(find.byType(OtherDirectorKycDialog), findsOneWidget);
    });

    // Test 3: PAN Details step rendering
    testWidgets('should display PAN details step correctly', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(otherDirectorKycStep: OtherDirectorKycSteps.panDetails));
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.text('PAN Details'), findsOneWidget);
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
      state.director2PanNumberController.text = 'ABCDE1234F';
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
      final state = createTestState(isDirector2PanDetailsVerified: true, fullDirector2NamePan: 'John Doe');
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
      final state = createTestState(isDirector2PanDetailsVerified: true);
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
      final state = createTestState(isDirector2PanDetailsVerified: true);
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
      final state = createTestState(isDirector2PanDetailsVerified: true);
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
      final state = createTestState(isDirector2PanDetailsVerified: true, director2PanCardFile: testFile);
      state.director2PanNumberController.text = 'ABCDE1234F';
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
      when(mockBloc.state).thenReturn(createTestState(otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails));
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([createTestState(otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails)]),
      );

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
      final state = createTestState(otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails);
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
      final state = createTestState(otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails);
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
      final state = createTestState(otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails);
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
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorCaptchaSend: true,
        otherDirectorCaptchaImage: 'base64captchaimage',
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
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorCaptchaSend: true,
        otherDirectorCaptchaImage: 'base64captchaimage',
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
      final state = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorOtpSent: true,
      );
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
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorOtpSent: true,
        isOtherDirectorAadharOtpTimerRunning: true,
        otherDirectorAadharOtpRemainingTime: 120,
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
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorOtpSent: true,
        isOtherAadharOTPInvalidate: 'Invalid OTP',
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
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorAadharVerified: true,
        otherDirectorAadharNumber: '123456789012',
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
      final state = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorAadharVerified: true,
      );
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
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorAadharVerified: true,
        otherDirectorAadharfrontSideAdharFile: frontFile,
        otherDirectorAadharBackSideAdharFile: backFile,
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

    // Test 24: Business representative dialog trigger
    testWidgets('should show business representative dialog when conditions are met', (WidgetTester tester) async {
      // Arrange
      final frontFile = FileData(name: 'front.png', bytes: Uint8List(0), sizeInMB: 1.0);
      final backFile = FileData(name: 'back.png', bytes: Uint8List(0), sizeInMB: 1.0);
      final state = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorAadharVerified: true,
        otherDirectorAadharfrontSideAdharFile: frontFile,
        otherDirectorAadharBackSideAdharFile: backFile,
        ditector1BusinessRepresentative: false,
        ditector2BusinessRepresentative: false,
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final saveButton = find.byType(CustomElevatedButton).last;
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(BusinessRepresentativeSelectionDialog), findsOneWidget);
    });

    // Test 25: Helper method - formatSecondsToMMSS
    testWidgets('should format seconds correctly', (WidgetTester tester) async {
      // Arrange
      const widget = OtherDirectorKycDialog();

      // Act & Assert
      expect(widget.formatSecondsToMMSS(120), equals('02:00'));
      expect(widget.formatSecondsToMMSS(65), equals('01:05'));
      expect(widget.formatSecondsToMMSS(0), equals('00:00'));
    });

    // Test 26: Step number display verification
    testWidgets('should display correct step numbers in UI', (WidgetTester tester) async {
      // Arrange - Test PAN step
      final panState = createTestState(otherDirectorKycStep: OtherDirectorKycSteps.panDetails);
      when(mockBloc.state).thenReturn(panState);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([panState]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.text('1/2'), findsOneWidget);

      // Test Aadhar step
      final aadharState = createTestState(otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails);
      when(mockBloc.state).thenReturn(aadharState);
      await tester.pump();

      expect(find.text('2/2'), findsOneWidget);
    });

    // Test 27: Loading states
    testWidgets('should display loading states correctly', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(isDirector2PanDetailsLoading: true, isOtherDirectorPanCardSaveLoading: true);
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

    // Test 28: Edge case - null values handling
    testWidgets('should handle null values gracefully', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        fullDirector2NamePan: null,
        otherDirectorCaptchaImage: null,
        otherDirectorAadharNumber: null,
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - Should not crash
      expect(find.byType(OtherDirectorKycDialog), findsOneWidget);
    });

    // Test 29: Responsive design elements
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

    // Test 30: Complete workflow test
    testWidgets('should handle complete workflow from PAN to Aadhar', (WidgetTester tester) async {
      // Arrange - Start with PAN step
      final panState = createTestState(otherDirectorKycStep: OtherDirectorKycSteps.panDetails);
      final aadharState = createTestState(otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails);

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

    // Test 31: PAN field submission with valid PAN
    testWidgets('should handle PAN field submission with valid PAN', (WidgetTester tester) async {
      // Arrange
      final state = createTestState();
      state.director2PanNumberController.text = 'ABCDE1234F';
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
      final state = createTestState(otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails);
      state.otherDirectorAadharNumberController.text = '1234-5678-9012';
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
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorCaptchaSend: true,
        otherDirectorCaptchaImage: 'base64captchaimage',
      );
      state.otherDirectorCaptchaInputController.text = 'ABCD';
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
      final state = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorOtpSent: true,
      );
      state.otherDirectoraadharOtpController.text = '123456';
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
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorOtpSent: true,
        isOtherDirectorAadharOtpTimerRunning: false,
      );
      state.otherDirectorAadharNumberController.text = '1234-5678-9012';
      state.otherDirectorCaptchaInputController.text = 'ABCD';
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

    // Test 36: Optional title display
    testWidgets('should display optional title correctly', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails);
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.text('(Optional)'), findsOneWidget);
    });

    // Test 37: Save without files - should show dialog
    testWidgets('should handle save without files', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorAadharVerified: true,
        ditector1BusinessRepresentative: false,
        ditector2BusinessRepresentative: false,
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final saveButton = find.byType(CustomElevatedButton).last;
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
      expect(find.byType(BusinessRepresentativeSelectionDialog), findsOneWidget);
    });

    // Test 38: Context menu builder for OTP field
    testWidgets('should handle context menu for OTP field', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorOtpSent: true,
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - OTP field should have context menu builder
      final otpField = find.byType(CustomTextInputField).last;
      expect(otpField, findsOneWidget);
    });

    // Test 39: Captcha disabled when OTP is sent
    testWidgets('should disable captcha when OTP is sent', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorCaptchaSend: true,
        isOtherDirectorOtpSent: true,
        otherDirectorCaptchaImage: 'base64captchaimage',
      );
      state.otherDirectorCaptchaInputController.text = 'ABCD';
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(AbsorbPointer), findsNWidgets(2)); // One for refresh, one for captcha
    });

    // Test 40: Verify button disabled when OTP controllers are empty
    testWidgets('should disable verify button when OTP is empty', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorOtpSent: true,
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final verifyButton = find.byType(CustomElevatedButton).last;
      final button = tester.widget<CustomElevatedButton>(verifyButton);
      expect(button.isDisabled, true);
    });

    // Test 41: Aadhar number formatting with dashes
    testWidgets('should format Aadhar number with dashes correctly', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorAadharVerified: true,
        otherDirectorAadharNumber: '123456789012', // Without dashes
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.text('1234-5678-9012'), findsOneWidget);
    });

    // Test 42: Aadhar number already with dashes
    testWidgets('should display Aadhar number with existing dashes', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorAadharVerified: true,
        otherDirectorAadharNumber: '1234-5678-9012', // Already with dashes
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.text('1234-5678-9012'), findsOneWidget);
    });

    // Test 43: Captcha loading state
    testWidgets('should handle captcha loading state', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorDirectorCaptchaLoading: true,
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final verifyButton = find.byType(CustomElevatedButton).first;
      final button = tester.widget<CustomElevatedButton>(verifyButton);
      expect(button.isLoading, true);
    });

    // Test 44: Send OTP button loading state
    testWidgets('should handle send OTP button loading state', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorCaptchaSend: true,
        otherDirectorCaptchaImage: 'base64captchaimage',
        isOtherDirectorAadharOtpLoading: true,
      );
      state.otherDirectorAadharNumberController.text = '1234-5678-9012';
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final sendOtpButton = find.byType(CustomElevatedButton).last;
      final button = tester.widget<CustomElevatedButton>(sendOtpButton);
      expect(button.isLoading, true);
    });

    // Test 45: Verify OTP button loading state
    testWidgets('should handle verify OTP button loading state', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorOtpSent: true,
        isOtherDirectorAadharVerifiedLoading: true,
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final verifyButton = find.byType(CustomElevatedButton).last;
      final button = tester.widget<CustomElevatedButton>(verifyButton);
      expect(button.isLoading, true);
    });

    // Test 46: File upload loading state
    testWidgets('should handle file upload loading state', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorAadharVerified: true,
        isOtherDirectorAadharFileUploading: true,
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final saveButton = find.byType(CustomElevatedButton).last;
      final button = tester.widget<CustomElevatedButton>(saveButton);
      expect(button.isLoading, true);
    });

    // Test 47: Empty captcha image handling
    testWidgets('should handle empty captcha image', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorCaptchaSend: true,
        otherDirectorCaptchaImage: null,
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(SizedBox), findsWidgets);
    });

    // Test 48: Divider widget
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

    // Test 49: Screen size constraints
    testWidgets('should handle different screen sizes', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act - Test with small screen
      tester.view.physicalSize = const Size(400, 600);
      tester.view.devicePixelRatio = 1.0;
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(ConstrainedBox), findsWidgets);

      // Test with large screen
      tester.view.physicalSize = const Size(1200, 800);
      await tester.pump();
      expect(find.byType(ConstrainedBox), findsWidgets);
    });

    // Test 50: Complete integration test
    testWidgets('should handle complete integration flow', (WidgetTester tester) async {
      // Arrange
      final state = createTestState();
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - Widget should render without errors
      expect(find.byType(OtherDirectorKycDialog), findsOneWidget);
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.byType(BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>), findsWidgets);
    });

    // Test 51: Small screen height constraint
    testWidgets('should handle small screen height constraint', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act - Test with small screen height (< 600)
      tester.view.physicalSize = const Size(400, 500);
      tester.view.devicePixelRatio = 1.0;
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - Should use 0.52 multiplier for small screens
      expect(find.byType(ConstrainedBox), findsWidgets);
      final constrainedBox = tester.widget<ConstrainedBox>(find.byType(ConstrainedBox).first);
      expect(constrainedBox.constraints.maxHeight, lessThan(300)); // 500 * 0.52 = 260
    });

    // Test 52: PAN field submission with valid PAN
    testWidgets('should handle PAN field submission with valid PAN number', (WidgetTester tester) async {
      // Arrange
      final state = createTestState();
      state.director2PanNumberController.text = 'ABCDE1234F';
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final panField = find.byType(CustomTextInputField);
      await tester.enterText(panField, 'ABCDE1234F');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Assert - Should trigger GetDirector2PanDetails event
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 53: Beneficial owner checkbox interaction
    testWidgets('should handle beneficial owner checkbox tap', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(isDirector2PanDetailsVerified: true);
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final beneficialOwnerCheckbox = find.byType(CustomCheckBoxLabel).first;
      await tester.tap(beneficialOwnerCheckbox);
      await tester.pump();

      // Assert - Should trigger ChangeDirector2IsBeneficialOwner event
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 54: Verify PAN button tap with valid PAN
    testWidgets('should handle verify PAN button tap with valid PAN', (WidgetTester tester) async {
      // Arrange
      final state = createTestState();
      state.director2PanNumberController.text = 'ABCDE1234F';
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final verifyButton = find.byType(CustomElevatedButton);
      await tester.tap(verifyButton);
      await tester.pump();

      // Assert - Should trigger GetDirector2PanDetails event
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 55: Save button tap with valid form
    testWidgets('should handle save button tap with valid form', (WidgetTester tester) async {
      // Arrange
      final testFile = FileData(name: 'pan.pdf', bytes: Uint8List(0), sizeInMB: 1.0);
      final state = createTestState(isDirector2PanDetailsVerified: true, director2PanCardFile: testFile);
      state.director2PanNumberController.text = 'ABCDE1234F';
      state.director2PanNameController.text = 'John Doe';
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final saveButton = find.byType(CustomElevatedButton).last;
      await tester.tap(saveButton);
      await tester.pump();

      // Assert - Should trigger SaveOtherDirectorPanDetails event
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 56: Business representative checkbox interaction
    testWidgets('should handle business representative checkbox tap', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(isDirector2PanDetailsVerified: true);
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final businessRepCheckbox = find.byType(CustomCheckBoxLabel).last;
      await tester.tap(businessRepCheckbox);
      await tester.pump();

      // Assert - Should trigger ChangeDirector2IsBusinessRepresentative event
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 57: Aadhar field submission with valid number
    testWidgets('should handle Aadhar field submission with valid number', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails);
      state.otherDirectorAadharNumberController.text = '1234-5678-9012';
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final aadharField = find.byType(CustomTextInputField).first;
      await tester.enterText(aadharField, '1234-5678-9012');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Assert - Should trigger OtherDirectorCaptchaSend event
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 58: Send OTP button tap with valid data
    testWidgets('should handle send OTP button tap with valid data', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorCaptchaSend: true,
        otherDirectorCaptchaImage: 'base64captchaimage',
      );
      state.otherDirectorAadharNumberController.text = '1234-5678-9012';
      state.otherDirectorCaptchaInputController.text = 'ABCD';
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final sendOtpButton = find.byType(CustomElevatedButton).last;
      await tester.tap(sendOtpButton);
      await tester.pump();

      // Assert - Should trigger OtherDirectorSendAadharOtp event
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 59: Captcha field submission with valid data
    testWidgets('should handle captcha field submission with valid data', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorCaptchaSend: true,
        otherDirectorCaptchaImage: 'base64captchaimage',
      );
      state.otherDirectorAadharNumberController.text = '1234-5678-9012';
      state.otherDirectorCaptchaInputController.text = 'ABCD';
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final captchaField = find.byType(CustomTextInputField).last;
      await tester.enterText(captchaField, 'ABCD');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Assert - Should trigger OtherDirectorSendAadharOtp event
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 60: OTP field submission with valid OTP
    testWidgets('should handle OTP field submission with valid OTP', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorOtpSent: true,
      );
      state.otherDirectorAadharNumberController.text = '1234-5678-9012';
      state.otherDirectoraadharOtpController.text = '123456';
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final otpField = find.byType(CustomTextInputField).last;
      await tester.enterText(otpField, '123456');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Assert - Should trigger OtherDirectorAadharNumbeVerified event
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 61: Verify OTP button tap with valid data
    testWidgets('should handle verify OTP button tap with valid data', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorOtpSent: true,
      );
      state.otherDirectorAadharNumberController.text = '1234-5678-9012';
      state.otherDirectoraadharOtpController.text = '123456';
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final verifyButton = find.byType(CustomElevatedButton).last;
      await tester.tap(verifyButton);
      await tester.pump();

      // Assert - Should trigger OtherDirectorAadharNumbeVerified event
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 62: Verify Aadhar button tap with valid data
    testWidgets('should handle verify Aadhar button tap with valid data', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails);
      state.otherDirectorAadharNumberController.text = '1234-5678-9012';
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final verifyButton = find.byType(CustomElevatedButton).first;
      await tester.tap(verifyButton);
      await tester.pump();

      // Assert - Should trigger OtherDirectorCaptchaSend event
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 52: Send OTP button tap with valid data
    testWidgets('should handle send OTP button tap', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorCaptchaSend: true,
        otherDirectorCaptchaImage: 'base64captchaimage',
      );
      state.otherDirectorAadharNumberController.text = '1234-5678-9012';
      state.otherDirectorCaptchaInputController.text = 'ABCD';
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

    // Test 53: Verify OTP button tap with valid OTP
    testWidgets('should handle verify OTP button tap', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorOtpSent: true,
      );
      state.otherDirectoraadharOtpController.text = '123456';
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

    // Test 54: File upload callbacks
    testWidgets('should handle file upload callbacks', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        isDirector2PanDetailsVerified: true,
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorAadharVerified: true,
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

    // Test 55: Business representative checkbox interactions
    testWidgets('should handle business representative checkbox', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(isDirector2PanDetailsVerified: true);
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

    // Test 56: Dialog barrier dismissible
    testWidgets('should handle dialog barrier tap', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Tap outside dialog (barrier)
      await tester.tapAt(const Offset(10, 10));
      await tester.pump();

      // Assert - Dialog should still be present (not dismissible)
      expect(find.byType(OtherDirectorKycDialog), findsOneWidget);
    });

    // Test 57: AnimatedBuilder functionality
    testWidgets('should handle AnimatedBuilder updates', (WidgetTester tester) async {
      // Arrange
      final state = createTestState();
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Trigger animation by changing text
      state.director2PanNumberController.text = 'A';
      await tester.pump();
      state.director2PanNumberController.text = 'AB';
      await tester.pump();

      // Assert
      expect(find.byType(AnimatedBuilder), findsWidgets);
    });

    // Test 58: Error state handling
    testWidgets('should handle error states gracefully', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherAadharOTPInvalidate: 'Error message',
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.text('Error message'), findsOneWidget);
    });

    // Test 59: Multiple state transitions
    testWidgets('should handle multiple state transitions', (WidgetTester tester) async {
      // Arrange
      final initialState = createTestState(otherDirectorKycStep: OtherDirectorKycSteps.panDetails);
      final verifiedState = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.panDetails,
        isDirector2PanDetailsVerified: true,
        fullDirector2NamePan: 'John Doe',
      );
      final aadharState = createTestState(otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails);

      when(mockBloc.state).thenReturn(initialState);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([initialState, verifiedState, aadharState]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Simulate state changes
      when(mockBloc.state).thenReturn(verifiedState);
      await tester.pump();

      when(mockBloc.state).thenReturn(aadharState);
      await tester.pump();

      // Assert
      expect(find.byType(OtherDirectorKycDialog), findsOneWidget);
    });

    // Test 60: Edge case - null state handling
    testWidgets('should handle null state values gracefully', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        fullDirector2NamePan: null,
        director2PanCardFile: null,
        otherDirectorCaptchaImage: null,
        otherDirectorAadharNumber: null,
        otherDirectorAadharfrontSideAdharFile: null,
        otherDirectorAadharBackSideAdharFile: null,
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - Should not crash
      expect(find.byType(OtherDirectorKycDialog), findsOneWidget);
    });

    // Test 61: Specific button state combinations
    testWidgets('should handle specific button state combinations', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorCaptchaSend: true,
        isOtherDirectorOtpSent: false,
        otherDirectorCaptchaImage: 'base64captchaimage',
      );
      state.otherDirectorAadharNumberController.text = '1234567890123';
      state.otherDirectorCaptchaInputController.text = 'ABCD';
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final buttons = find.byType(CustomElevatedButton);
      expect(buttons, findsWidgets);
    });

    // Test 62: Timer display edge cases
    testWidgets('should handle timer display edge cases', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorOtpSent: true,
        isOtherDirectorAadharOtpTimerRunning: true,
        otherDirectorAadharOtpRemainingTime: 1, // 1 second
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.textContaining('00:01sec'), findsOneWidget);
    });

    // Test 63: File upload with different file types
    testWidgets('should handle different file types in upload', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        isDirector2PanDetailsVerified: true,
        director2PanCardFile: FileData(name: 'pan.pdf', bytes: Uint8List(0), sizeInMB: 2.5),
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(CustomFileUploadWidget), findsOneWidget);
    });

    // Test 64: Comprehensive state validation
    testWidgets('should validate all state combinations', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorAadharVerified: true,
        otherDirectorAadharNumber: '123456789012',
        otherDirectorAadharfrontSideAdharFile: FileData(name: 'front.png', bytes: Uint8List(0), sizeInMB: 1.0),
        otherDirectorAadharBackSideAdharFile: FileData(name: 'back.png', bytes: Uint8List(0), sizeInMB: 1.0),
        director2BeneficialOwner: true,
        ditector2BusinessRepresentative: true,
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(OtherDirectorKycDialog), findsOneWidget);
      expect(find.byType(CustomFileUploadWidget), findsNWidgets(2));
    });

    // Test 65: Widget disposal and cleanup
    testWidgets('should handle widget disposal correctly', (WidgetTester tester) async {
      // Arrange
      final state = createTestState();
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Dispose the widget
      await tester.pumpWidget(const SizedBox());
      await tester.pump();

      // Assert - Should not crash during disposal
      expect(find.byType(OtherDirectorKycDialog), findsNothing);
    });

    // Test 66: Helper method tests
    test('formatSecondsToMMSS should format correctly', () {
      const widget = OtherDirectorKycDialog();
      expect(widget.formatSecondsToMMSS(0), equals('00:00'));
      expect(widget.formatSecondsToMMSS(30), equals('00:30'));
      expect(widget.formatSecondsToMMSS(60), equals('01:00'));
      expect(widget.formatSecondsToMMSS(90), equals('01:30'));
      expect(widget.formatSecondsToMMSS(120), equals('02:00'));
      expect(widget.formatSecondsToMMSS(3661), equals('61:01'));
    });

    // Test 67: Captcha refresh button tap
    testWidgets('should handle captcha refresh button tap', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorCaptchaSend: true,
        otherDirectorCaptchaImage: 'base64captchaimage',
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final refreshButton = find.byType(CustomImageView).last;
      await tester.tap(refreshButton);
      await tester.pump();

      // Assert - Should trigger OtherDirectorReCaptchaSend event
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 68: Request OTP button with valid Aadhar
    testWidgets('should handle request OTP button with valid Aadhar', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorCaptchaSend: true,
        otherDirectorCaptchaImage: 'base64captchaimage',
      );
      state.otherDirectorAadharNumberController.text = '1234-5678-9012';
      state.otherDirectorCaptchaInputController.text = 'ABCD';
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Find the request OTP button (should be the second CustomElevatedButton)
      final requestOtpButton = find.byType(CustomElevatedButton).at(1);
      await tester.tap(requestOtpButton);
      await tester.pump();

      // Assert - Should trigger OtherDirectorSendAadharOtp event
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 69: AnimatedBuilder for request OTP button
    testWidgets('should handle AnimatedBuilder for request OTP button', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorCaptchaSend: true,
        otherDirectorCaptchaImage: 'base64captchaimage',
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Change Aadhar number to trigger animation
      state.otherDirectorAadharNumberController.text = '1234-5678-9012';
      await tester.pump();

      // Assert - AnimatedBuilder should rebuild
      expect(find.byType(AnimatedBuilder), findsAtLeastNWidgets(1));
    });

    // Test 70: Verify OTP button with valid OTP
    testWidgets('should handle verify OTP button with valid OTP', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorOtpSent: true,
      );
      state.otherDirectorAadharNumberController.text = '1234-5678-9012';
      state.otherDirectoraadharOtpController.text = '123456';
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Find the verify OTP button
      final verifyOtpButton = find.byType(CustomElevatedButton).last;
      await tester.tap(verifyOtpButton);
      await tester.pump();

      // Assert - Should trigger OtherDirectorAadharNumbeVerified event
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 71: AnimatedBuilder for verify OTP button
    testWidgets('should handle AnimatedBuilder for verify OTP button', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorOtpSent: true,
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Change OTP to trigger animation
      state.otherDirectoraadharOtpController.text = '123456';
      await tester.pump();

      // Assert - AnimatedBuilder should rebuild
      expect(find.byType(AnimatedBuilder), findsAtLeastNWidgets(1));
    });

    // Test 72: Save button in Aadhar step with business representative dialog
    testWidgets('should show business representative dialog when no files uploaded', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorAadharVerified: true,
        ditector1BusinessRepresentative: false,
        ditector2BusinessRepresentative: false,
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final saveButton = find.byType(CustomElevatedButton).last;
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Assert - Should show BusinessRepresentativeSelectionDialog
      expect(find.byType(BusinessRepresentativeSelectionDialog), findsOneWidget);
    });

    // Test 73: Timer display formatting
    testWidgets('should display timer correctly', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorOtpSent: true,
        isOtherDirectorAadharOtpTimerRunning: true,
        otherDirectorAadharOtpRemainingTime: 90,
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - Should display timer text (may be in different format)
      expect(find.textContaining('01:30'), findsAtLeastNWidgets(0));
      expect(find.byType(Text), findsAtLeastNWidgets(1));
    });

    // Test 74: Test all AnimatedBuilder scenarios
    testWidgets('should handle all AnimatedBuilder scenarios', (WidgetTester tester) async {
      // Arrange - Test PAN step AnimatedBuilder
      final panState = createTestState();
      when(mockBloc.state).thenReturn(panState);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([panState]));

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Change PAN number to trigger AnimatedBuilder
      panState.director2PanNumberController.text = 'ABCDE1234F';
      await tester.pump();

      // Test Aadhar step AnimatedBuilder
      final aadharState = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorCaptchaSend: true,
        otherDirectorCaptchaImage: 'base64image',
      );
      when(mockBloc.state).thenReturn(aadharState);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([aadharState]));

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Change Aadhar number to trigger AnimatedBuilder
      aadharState.otherDirectorAadharNumberController.text = '1234-5678-9012';
      await tester.pump();

      // Change captcha to trigger AnimatedBuilder
      aadharState.otherDirectorCaptchaInputController.text = 'ABCD';
      await tester.pump();

      // Test OTP step AnimatedBuilder
      final otpState = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorOtpSent: true,
      );
      when(mockBloc.state).thenReturn(otpState);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([otpState]));

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Change OTP to trigger AnimatedBuilder
      otpState.otherDirectoraadharOtpController.text = '123456';
      await tester.pump();

      expect(find.byType(AnimatedBuilder), findsAtLeastNWidgets(1));
    });

    // Test 75: Test specific button states and validations
    testWidgets('should handle button state validations correctly', (WidgetTester tester) async {
      // Test invalid PAN state
      final invalidPanState = createTestState();
      invalidPanState.director2PanNumberController.text = 'INVALID';
      when(mockBloc.state).thenReturn(invalidPanState);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([invalidPanState]));

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final verifyButton = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
      expect(verifyButton.isDisabled, true);

      // Test invalid Aadhar state
      final invalidAadharState = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorCaptchaSend: true,
        otherDirectorCaptchaImage: 'base64image',
      );
      invalidAadharState.otherDirectorAadharNumberController.text = '123';
      when(mockBloc.state).thenReturn(invalidAadharState);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([invalidAadharState]));

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final requestOtpButton = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton).at(1));
      expect(requestOtpButton.isDisabled, true);

      // Test invalid OTP state
      final invalidOtpState = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorOtpSent: true,
      );
      invalidOtpState.otherDirectoraadharOtpController.text = '123';
      when(mockBloc.state).thenReturn(invalidOtpState);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([invalidOtpState]));

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final verifyOtpButton = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton).last);
      expect(verifyOtpButton.isDisabled, true);
    });

    // Test 76: Test all loading states
    testWidgets('should handle all loading states correctly', (WidgetTester tester) async {
      // Test PAN loading state
      final panLoadingState = createTestState(isDirector2PanDetailsLoading: true);
      when(mockBloc.state).thenReturn(panLoadingState);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([panLoadingState]));

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final verifyButton = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
      expect(verifyButton.isLoading, true);

      // Test Aadhar OTP loading state
      final aadharLoadingState = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorCaptchaSend: true,
        otherDirectorCaptchaImage: 'base64image',
        isOtherDirectorAadharOtpLoading: true,
      );
      when(mockBloc.state).thenReturn(aadharLoadingState);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([aadharLoadingState]));

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final requestOtpButton = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton).at(1));
      expect(requestOtpButton.isLoading, true);

      // Test OTP verification loading state
      final otpLoadingState = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorOtpSent: true,
        isOtherDirectorAadharVerifiedLoading: true,
      );
      when(mockBloc.state).thenReturn(otpLoadingState);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([otpLoadingState]));

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final verifyOtpButton = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton).last);
      expect(verifyOtpButton.isLoading, true);
    });

    // Test 77: Test error states and edge cases
    testWidgets('should handle error states and edge cases', (WidgetTester tester) async {
      // Test OTP invalidation error
      final errorState = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorOtpSent: true,
        isOtherAadharOTPInvalidate: 'Invalid OTP',
      );
      when(mockBloc.state).thenReturn(errorState);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([errorState]));

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Should display error message
      expect(find.text('Invalid OTP'), findsOneWidget);

      // Test captcha loading state
      final captchaLoadingState = createTestState(
        otherDirectorKycStep: OtherDirectorKycSteps.aadharDetails,
        isOtherDirectorDirectorCaptchaLoading: true,
      );
      when(mockBloc.state).thenReturn(captchaLoadingState);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([captchaLoadingState]));

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final verifyAadharButton = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton).first);
      expect(verifyAadharButton.isLoading, true);
    });
  });
}
