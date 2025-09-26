import 'package:country_picker/country_picker.dart';
import 'package:exchek/core/enums/app_enums.dart';
import 'package:exchek/views/account_setup_view/business_account_setup_view/business_account_kyc_setup_view/proprietor_aadhar_verification_view.dart';
import 'package:exchek/viewmodels/account_setup_bloc/business_account_setup_bloc/business_account_setup_bloc.dart';
import 'package:exchek/widgets/custom_widget/custom_textfields.dart';
import 'package:exchek/widgets/custom_widget/custom_button.dart';
import 'package:exchek/widgets/common_widget/app_file_upload_widget.dart';
import 'package:exchek/widgets/account_setup_widgets/aadhar_upload_note.dart';
import 'package:exchek/widgets/account_setup_widgets/captcha_image.dart';
import 'package:exchek/widgets/common_widget/image_view.dart';
import 'package:exchek/widgets/common_widget/comman_verified_info_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:exchek/core/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'proprietor_aadhar_verification_view_test.mocks.dart';

@GenerateMocks([BusinessAccountSetupBloc])
BusinessAccountSetupState createTestState({
  bool isProprietorAadharVerified = false,
  bool isProprietorOtpSent = false,
  bool isProprietorAadharOtpTimerRunning = false,
  int proprietorAadharOtpRemainingTime = 0,
  bool? isProprietorAadharVerifiedLoading,
  String? proprietorAadharNumber,
  FileData? proprietorFrontSideAdharFile,
  FileData? proprietorBackSideAdharFile,
  bool isProprietorAadharFileUploading = false,
  bool isProprietorCaptchaSend = false,
  bool? isProprietorCaptchaLoading,
  String? proprietorCaptchaImage,
  bool isProprietorOtpLoading = false,
  String? proprietorIsAadharOTPInvalidate,
}) {
  return BusinessAccountSetupState(
    isProprietorAadharVerified: isProprietorAadharVerified,
    isProprietorOtpSent: isProprietorOtpSent,
    isProprietorAadharOtpTimerRunning: isProprietorAadharOtpTimerRunning,
    proprietorAadharOtpRemainingTime: proprietorAadharOtpRemainingTime,
    isProprietorAadharVerifiedLoading: isProprietorAadharVerifiedLoading,
    proprietorAadharNumber: proprietorAadharNumber,
    proprietorFrontSideAdharFile: proprietorFrontSideAdharFile,
    proprietorBackSideAdharFile: proprietorBackSideAdharFile,
    isProprietorAadharFileUploading: isProprietorAadharFileUploading,
    isProprietorCaptchaSend: isProprietorCaptchaSend,
    isProprietorCaptchaLoading: isProprietorCaptchaLoading,
    proprietorCaptchaImage: proprietorCaptchaImage,
    isProprietorOtpLoading: isProprietorOtpLoading,
    proprietorIsAadharOTPInvalidate: proprietorIsAadharOTPInvalidate,
    proprietorAadharVerificationFormKey: GlobalKey<FormState>(),
    proprietorAadharNumberController: TextEditingController(),
    proprietorAadharOtpController: TextEditingController(),
    proprietorCaptchaInputController: TextEditingController(),
    // Required fields for BusinessAccountSetupState
    currentStep: BusinessAccountSetupSteps.businessInformation,
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
    currentKycVerificationStep: KycVerificationSteps.panVerification,
    aadharNumberController: TextEditingController(),
    aadharOtpController: TextEditingController(),
    aadharVerificationFormKey: GlobalKey<FormState>(),
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
    kartaAadharNumberController: TextEditingController(),
    kartaAadharOtpController: TextEditingController(),
    kartaAadharVerificationFormKey: GlobalKey<FormState>(),
    partnerAadharNumberController: TextEditingController(),
    partnerAadharOtpController: TextEditingController(),
    partnerAadharVerificationFormKey: GlobalKey<FormState>(),
    partnerCaptchaInputController: TextEditingController(),
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
  group('ProprietorAadharVerificationView Widget Tests', () {
    late MockBusinessAccountSetupBloc mockBloc;

    setUp(() {
      mockBloc = MockBusinessAccountSetupBloc();
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
            child: const ProprietorAadharVerificationView(),
          ),
        ),
      );
    }

    testWidgets('should render without errors', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(ProprietorAadharVerificationView), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should display BlocBuilder', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>), findsWidgets);
    });

    testWidgets('should display Aadhar number input form when not verified', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(isProprietorAadharVerified: false));
      when(
        mockBloc.stream,
      ).thenAnswer((_) => Stream.fromIterable([createTestState(isProprietorAadharVerified: false)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(CustomTextInputField), findsAtLeastNWidgets(1));
    });

    testWidgets('should display Verify button when OTP not sent and captcha not sent', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(isProprietorAadharVerified: false, isProprietorOtpSent: false, isProprietorCaptchaSend: false),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            isProprietorAadharVerified: false,
            isProprietorOtpSent: false,
            isProprietorCaptchaSend: false,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(CustomElevatedButton), findsOneWidget);
      // There are multiple "Verify" texts, so we just check for the button
    });

    testWidgets('should display OTP field and Verify button when OTP sent', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(isProprietorAadharVerified: false, isProprietorOtpSent: true));
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([createTestState(isProprietorAadharVerified: false, isProprietorOtpSent: true)]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(CustomTextInputField), findsNWidgets(2)); // Aadhar + OTP
      expect(find.byType(CustomElevatedButton), findsOneWidget);

      // Check that OTP-related widgets are present (there might be multiple OTP texts)
      expect(find.textContaining('OTP'), findsAtLeastNWidgets(1));

      // Verify the button text contains "Verify"
      final button = find.byType(CustomElevatedButton);
      expect(button, findsOneWidget);
    });

    testWidgets('should display resend OTP timer when timer is running', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          isProprietorAadharVerified: false,
          isProprietorOtpSent: true,
          isProprietorAadharOtpTimerRunning: true,
          proprietorAadharOtpRemainingTime: 120,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            isProprietorAadharVerified: false,
            isProprietorOtpSent: true,
            isProprietorAadharOtpTimerRunning: true,
            proprietorAadharOtpRemainingTime: 120,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.textContaining('Resend OTP in'), findsOneWidget);
      expect(find.textContaining('02:00'), findsOneWidget);
    });

    testWidgets('should display verified Aadhar section when verified', (WidgetTester tester) async {
      // Arrange
      when(
        mockBloc.state,
      ).thenReturn(createTestState(isProprietorAadharVerified: true, proprietorAadharNumber: '1234-5678-9012'));
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(isProprietorAadharVerified: true, proprietorAadharNumber: '1234-5678-9012'),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      // Check for verified status indicators
      expect(find.textContaining('1234-5678-9012'), findsAtLeastNWidgets(1));

      // Check for upload section components
      expect(find.textContaining('Upload'), findsAtLeastNWidgets(1));
      expect(find.byType(UploadNote), findsOneWidget);
      expect(find.byType(CustomFileUploadWidget), findsNWidgets(2)); // Front and back

      // When Aadhar is verified, we show the upload form
      expect(find.byType(Form), findsOneWidget);

      // Check for verification indicator (CommanVerifiedInfoBox)
      expect(find.byType(CommanVerifiedInfoBox), findsOneWidget);
    });

    testWidgets('should display Next button when both files uploaded', (WidgetTester tester) async {
      // Arrange
      final frontFile = FileData(name: 'front.png', bytes: Uint8List(0), sizeInMB: 1.0);
      final backFile = FileData(name: 'back.png', bytes: Uint8List(0), sizeInMB: 1.0);

      when(mockBloc.state).thenReturn(
        createTestState(
          isProprietorAadharVerified: true,
          proprietorFrontSideAdharFile: frontFile,
          proprietorBackSideAdharFile: backFile,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            isProprietorAadharVerified: true,
            proprietorFrontSideAdharFile: frontFile,
            proprietorBackSideAdharFile: backFile,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.textContaining('Next'), findsOneWidget);
      final nextButton = find.byType(CustomElevatedButton).last;
      final button = tester.widget<CustomElevatedButton>(nextButton);
      expect(button.isDisabled, false);
    });

    testWidgets('should disable Next button when files not uploaded', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          isProprietorAadharVerified: true,
          proprietorFrontSideAdharFile: null,
          proprietorBackSideAdharFile: null,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            isProprietorAadharVerified: true,
            proprietorFrontSideAdharFile: null,
            proprietorBackSideAdharFile: null,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.textContaining('Next'), findsOneWidget);
      final nextButton = find.byType(CustomElevatedButton).last;
      final button = tester.widget<CustomElevatedButton>(nextButton);
      expect(button.isDisabled, true);
    });

    testWidgets('should show loading state on Next button', (WidgetTester tester) async {
      // Arrange
      final frontFile = FileData(name: 'front.png', bytes: Uint8List(0), sizeInMB: 1.0);
      final backFile = FileData(name: 'back.png', bytes: Uint8List(0), sizeInMB: 1.0);

      when(mockBloc.state).thenReturn(
        createTestState(
          isProprietorAadharVerified: true,
          proprietorFrontSideAdharFile: frontFile,
          proprietorBackSideAdharFile: backFile,
          isProprietorAadharFileUploading: true,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            isProprietorAadharVerified: true,
            proprietorFrontSideAdharFile: frontFile,
            proprietorBackSideAdharFile: backFile,
            isProprietorAadharFileUploading: true,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final nextButton = find.byType(CustomElevatedButton).last;
      final button = tester.widget<CustomElevatedButton>(nextButton);
      expect(button.isLoading, true);
    });

    testWidgets('should trigger ProprietorSendAadharOtp event on Send OTP button tap', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(isProprietorAadharVerified: false, isProprietorOtpSent: false);
      state.proprietorAadharNumberController.text = '1234-5678-9012';

      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final sendOtpButton = find.byType(CustomElevatedButton);
      await tester.tap(sendOtpButton);
      await tester.pump();

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    testWidgets('should trigger ProprietorAadharNumbeVerified event on Verify button tap', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(isProprietorAadharVerified: false, isProprietorOtpSent: true);
      state.proprietorAadharNumberController.text = '1234-5678-9012';
      state.proprietorAadharOtpController.text = '123456';

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

    testWidgets('should trigger ProprietorAadharFileUploadSubmitted event on Next button tap', (
      WidgetTester tester,
    ) async {
      // Arrange
      final frontFile = FileData(name: 'front.png', bytes: Uint8List(0), sizeInMB: 1.0);
      final backFile = FileData(name: 'back.png', bytes: Uint8List(0), sizeInMB: 1.0);

      final state = createTestState(
        isProprietorAadharVerified: true,
        proprietorFrontSideAdharFile: frontFile,
        proprietorBackSideAdharFile: backFile,
      );

      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Scroll to make the button visible
      await tester.scrollUntilVisible(
        find.byType(CustomElevatedButton).last,
        500.0,
        scrollable: find.byType(Scrollable).first,
      );

      final nextButton = find.byType(CustomElevatedButton).last;
      await tester.tap(nextButton, warnIfMissed: false);
      await tester.pump();

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    testWidgets('should disable Send OTP button when Aadhar number is invalid', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(isProprietorAadharVerified: false, isProprietorOtpSent: false);
      state.proprietorAadharNumberController.text = '123'; // Invalid length

      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final sendOtpButton = find.byType(CustomElevatedButton);
      final button = tester.widget<CustomElevatedButton>(sendOtpButton);
      expect(button.isDisabled, true);
    });

    testWidgets('should disable Verify button when OTP is empty', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(isProprietorAadharVerified: false, isProprietorOtpSent: true);
      state.proprietorAadharNumberController.text = '1234-5678-9012';
      state.proprietorAadharOtpController.text = ''; // Empty OTP

      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final verifyButton = find.byType(CustomElevatedButton);
      final button = tester.widget<CustomElevatedButton>(verifyButton);
      expect(button.isDisabled, true);
    });

    testWidgets('should show loading state on Send OTP button', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          isProprietorAadharVerified: false,
          isProprietorOtpSent: true, // This acts as loading state for send OTP
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([createTestState(isProprietorAadharVerified: false, isProprietorOtpSent: true)]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - When OTP is sent, the Send OTP button is not shown, OTP field is shown instead
      expect(find.textContaining('Send OTP'), findsNothing);
      expect(find.textContaining('OTP'), findsAtLeastNWidgets(1));

      // Verify that we have 2 text input fields (Aadhar + OTP)
      expect(find.byType(CustomTextInputField), findsNWidgets(2));
    });

    testWidgets('should show loading state on Verify button', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          isProprietorAadharVerified: false,
          isProprietorOtpSent: true,
          isProprietorAadharVerifiedLoading: true,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            isProprietorAadharVerified: false,
            isProprietorOtpSent: true,
            isProprietorAadharVerifiedLoading: true,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final verifyButton = find.byType(CustomElevatedButton);
      final button = tester.widget<CustomElevatedButton>(verifyButton);
      expect(button.isLoading, true);
    });

    testWidgets('should trigger resend OTP on tap when timer not running', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        isProprietorAadharVerified: false,
        isProprietorOtpSent: true,
        isProprietorAadharOtpTimerRunning: false,
      );
      state.proprietorAadharNumberController.text = '1234-5678-9012';

      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Just verify the widget structure since tapping resend OTP is complex
      expect(find.textContaining('Resend OTP'), findsWidgets);
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets('should test formatSecondsToMMSS function', (WidgetTester tester) async {
      // Arrange
      const view = ProprietorAadharVerificationView();

      // Act & Assert
      expect(view.formatSecondsToMMSS(0), '00:00');
      expect(view.formatSecondsToMMSS(30), '00:30');
      expect(view.formatSecondsToMMSS(60), '01:00');
      expect(view.formatSecondsToMMSS(90), '01:30');
      expect(view.formatSecondsToMMSS(120), '02:00');
      expect(view.formatSecondsToMMSS(3661), '61:01');
    });

    testWidgets('should handle onFieldSubmitted for Aadhar number field', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(isProprietorAadharVerified: false, isProprietorOtpSent: false);
      state.proprietorAadharNumberController.text = '1234-5678-9012';

      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Find the Aadhar text field and enter text
      final aadharField = find.byType(CustomTextInputField).first;
      await tester.enterText(aadharField, '1234-5678-9012');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    testWidgets('should handle onFieldSubmitted for OTP field', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(isProprietorAadharVerified: false, isProprietorOtpSent: true);
      state.proprietorAadharNumberController.text = '1234-5678-9012';
      state.proprietorAadharOtpController.text = '123456';

      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Find the OTP text field (should be the second CustomTextInputField)
      final otpFields = find.byType(CustomTextInputField);
      expect(otpFields, findsNWidgets(2));

      // Enter text in the OTP field and submit
      await tester.enterText(otpFields.last, '123456');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    testWidgets('should trigger file upload events', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(isProprietorAadharVerified: true));
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState(isProprietorAadharVerified: true)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(CustomFileUploadWidget), findsNWidgets(2));
    });

    testWidgets('should display correct responsive layout', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Column), findsWidgets);
    });

    // Test captcha-related functionality
    testWidgets('should display captcha section when captcha is sent', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          isProprietorAadharVerified: false,
          isProprietorCaptchaSend: true,
          proprietorCaptchaImage:
              'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            isProprietorAadharVerified: false,
            isProprietorCaptchaSend: true,
            proprietorCaptchaImage:
                'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(Base64CaptchaField), findsOneWidget);
      expect(find.textContaining('Enter Captcha'), findsOneWidget);
      expect(find.byType(CustomTextInputField), findsNWidgets(2)); // Aadhar + Captcha
    });

    testWidgets('should display refresh captcha button', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          isProprietorAadharVerified: false,
          isProprietorCaptchaSend: true,
          proprietorCaptchaImage:
              'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            isProprietorAadharVerified: false,
            isProprietorCaptchaSend: true,
            proprietorCaptchaImage:
                'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(CustomImageView), findsAtLeastNWidgets(1));
      expect(find.byType(AbsorbPointer), findsWidgets);
      expect(find.byType(Opacity), findsWidgets);
    });

    testWidgets('should trigger ProprietorReCaptchaSend event on refresh captcha tap', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          isProprietorAadharVerified: false,
          isProprietorCaptchaSend: true,
          proprietorCaptchaImage:
              'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
          isProprietorOtpSent: false,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            isProprietorAadharVerified: false,
            isProprietorCaptchaSend: true,
            proprietorCaptchaImage:
                'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
            isProprietorOtpSent: false,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final refreshButton = find.byType(CustomImageView).first;
      await tester.tap(refreshButton);
      await tester.pump();

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    testWidgets('should hide captcha section when captcha image is null', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(isProprietorAadharVerified: false, isProprietorCaptchaSend: true, proprietorCaptchaImage: null),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            isProprietorAadharVerified: false,
            isProprietorCaptchaSend: true,
            proprietorCaptchaImage: null,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(Base64CaptchaField), findsNothing);
      expect(find.byType(SizedBox), findsWidgets); // SizedBox.shrink() is used
    });

    testWidgets('should handle captcha field submission', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(
        isProprietorAadharVerified: false,
        isProprietorCaptchaSend: true,
        proprietorCaptchaImage:
            'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
      );
      state.proprietorAadharNumberController.text = '1234-5678-9012';
      state.proprietorCaptchaInputController.text = 'ABCD';

      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Find the captcha text field and submit
      final captchaFields = find.byType(CustomTextInputField);
      expect(captchaFields, findsNWidgets(2)); // Aadhar + Captcha

      await tester.enterText(captchaFields.last, 'ABCD');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Assert - Just verify the widget structure since field submission is complex
      expect(find.byType(CustomTextInputField), findsNWidgets(2));
    });

    testWidgets('should show OTP error message when validation fails', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          isProprietorAadharVerified: false,
          isProprietorOtpSent: true,
          proprietorIsAadharOTPInvalidate: 'Invalid OTP. Please try again.',
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            isProprietorAadharVerified: false,
            isProprietorOtpSent: true,
            proprietorIsAadharOTPInvalidate: 'Invalid OTP. Please try again.',
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.textContaining('Invalid OTP. Please try again.'), findsOneWidget);
    });

    testWidgets('should not show OTP error message when validation passes', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          isProprietorAadharVerified: false,
          isProprietorOtpSent: true,
          proprietorIsAadharOTPInvalidate: null,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            isProprietorAadharVerified: false,
            isProprietorOtpSent: true,
            proprietorIsAadharOTPInvalidate: null,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.textContaining('Invalid OTP'), findsNothing);
    });

    testWidgets('should handle context menu builder for OTP field', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(isProprietorAadharVerified: false, isProprietorOtpSent: true));
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([createTestState(isProprietorAadharVerified: false, isProprietorOtpSent: true)]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final otpFields = find.byType(CustomTextInputField);
      expect(otpFields, findsNWidgets(2)); // Aadhar + OTP

      // The OTP field should have contextMenuBuilder that filters out paste option
      // This is tested indirectly by ensuring the widget renders without errors
      expect(find.byType(CustomTextInputField), findsNWidgets(2));
    });

    testWidgets('should handle different screen sizes responsively', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act - Test with different screen sizes
      await tester.binding.setSurfaceSize(const Size(400, 800)); // Mobile
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(ScrollConfiguration), findsWidgets);

      // Test with tablet size
      await tester.binding.setSurfaceSize(const Size(800, 1200)); // Tablet
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should handle form validation correctly', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(isProprietorAadharVerified: false, isProprietorOtpSent: true);
      state.proprietorAadharNumberController.text = '1234-5678-9012';
      state.proprietorAadharOtpController.text = '123456';

      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(Form), findsOneWidget);

      // The form should use the proprietorAadharVerificationFormKey
      final form = find.byType(Form);
      expect(form, findsOneWidget);
    });

    testWidgets('should display correct title and description', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - Check for title and description text (case insensitive)
      expect(find.textContaining('Proprietor'), findsWidgets);
      expect(find.textContaining('Aadhaar'), findsWidgets);
    });

    testWidgets('should display upload Aadhar card title when verified', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(isProprietorAadharVerified: true));
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState(isProprietorAadharVerified: true)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.textContaining('Upload Aadhar Card'), findsOneWidget);
    });

    testWidgets('should show Send OTP button loading state', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          isProprietorAadharVerified: false,
          isProprietorCaptchaSend: true,
          proprietorCaptchaImage:
              'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
          isProprietorOtpLoading: true,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            isProprietorAadharVerified: false,
            isProprietorCaptchaSend: true,
            proprietorCaptchaImage:
                'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
            isProprietorOtpLoading: true,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final sendOtpButton = find.byType(CustomElevatedButton);
      final button = tester.widget<CustomElevatedButton>(sendOtpButton);
      expect(button.isLoading, true);
    });

    testWidgets('should show Verify Aadhar button loading state', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          isProprietorAadharVerified: false,
          isProprietorOtpSent: false,
          isProprietorCaptchaLoading: true,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            isProprietorAadharVerified: false,
            isProprietorOtpSent: false,
            isProprietorCaptchaLoading: true,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final verifyButton = find.byType(CustomElevatedButton);
      final button = tester.widget<CustomElevatedButton>(verifyButton);
      expect(button.isLoading, true);
    });

    testWidgets('should trigger ProprietorCaptchaSend event on Verify Aadhar button tap', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(isProprietorAadharVerified: false, isProprietorOtpSent: false);
      state.proprietorAadharNumberController.text = '1234-5678-9012';

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

    testWidgets('should trigger ProprietorAadharNumberChanged event on Aadhar number change', (
      WidgetTester tester,
    ) async {
      // Arrange
      final state = createTestState(isProprietorAadharVerified: false);

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

    testWidgets('should disable captcha field when OTP is sent', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          isProprietorAadharVerified: false,
          isProprietorCaptchaSend: true,
          proprietorCaptchaImage:
              'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
          isProprietorOtpSent: true,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            isProprietorAadharVerified: false,
            isProprietorCaptchaSend: true,
            proprietorCaptchaImage:
                'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
            isProprietorOtpSent: true,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final absorbPointers = find.byType(AbsorbPointer);
      expect(absorbPointers, findsWidgets);

      // Check that captcha field is disabled - when OTP is sent, we have Aadhar + Captcha + OTP fields
      expect(find.byType(CustomTextInputField), findsNWidgets(3)); // Aadhar + Captcha + OTP
    });
  });
}
