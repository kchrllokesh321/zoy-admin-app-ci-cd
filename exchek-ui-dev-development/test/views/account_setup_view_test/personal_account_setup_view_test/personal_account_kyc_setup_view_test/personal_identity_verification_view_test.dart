import 'package:exchek/core/enums/app_enums.dart';
import 'package:exchek/views/account_setup_view/personal_account_setup_view/personal_account_kyc_setup_view/personal_identity_verification_view.dart';
import 'package:exchek/viewmodels/account_setup_bloc/personal_account_setup_bloc/personal_account_setup_bloc.dart';
import 'package:exchek/widgets/custom_widget/custom_textfields.dart';
import 'package:exchek/widgets/custom_widget/custom_drop_down_field.dart';
import 'package:exchek/widgets/common_widget/app_file_upload_widget.dart';
import 'package:exchek/widgets/common_widget/comman_verified_info_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:exchek/core/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

@GenerateMocks([PersonalAccountSetupBloc])
import 'personal_identity_verification_view_test.mocks.dart';

PersonalAccountSetupState createTestState({
  IDVerificationDocType? selectedIDVerificationDocType,
  bool isIdVerified = false,
  bool isCaptchaSend = false,
  bool isOtpSent = false,
  String? captchaImage,
  String? aadharNumber,
  String? drivingLicenseNumber,
  String? voterIDNumber,
  String? passporteNumber,
  bool? isIdVerifiedLoading,
  bool? isOtpLoading,
  bool? isCaptchaLoading,
  int aadharOtpRemainingTime = 0,
  bool isAadharOtpTimerRunning = false,
}) {
  return PersonalAccountSetupState(
    selectedIDVerificationDocType: selectedIDVerificationDocType,
    isIdVerified: isIdVerified,
    isCaptchaSend: isCaptchaSend,
    isOtpSent: isOtpSent,
    captchaImage: captchaImage,
    aadharNumber: aadharNumber,
    drivingLicenseNumber: drivingLicenseNumber,
    voterIDNumber: voterIDNumber,
    passporteNumber: passporteNumber,
    isIdVerifiedLoading: isIdVerifiedLoading,
    isOtpLoading: isOtpLoading ?? false,
    isCaptchaLoading: isCaptchaLoading,
    aadharOtpRemainingTime: aadharOtpRemainingTime,
    isAadharOtpTimerRunning: isAadharOtpTimerRunning,
    currentKycVerificationStep: PersonalEKycVerificationSteps.identityVerification,
    scrollController: ScrollController(),
    professionOtherController: TextEditingController(),
    productServiceDescriptionController: TextEditingController(),
    passwordController: TextEditingController(),
    confirmPasswordController: TextEditingController(),
    personalInfoKey: GlobalKey<FormState>(),
    aadharNumberController: TextEditingController(),
    aadharOtpController: TextEditingController(),
    aadharVerificationFormKey: GlobalKey<FormState>(),
    drivingVerificationFormKey: GlobalKey<FormState>(),
    drivingLicenceController: TextEditingController(),
    voterVerificationFormKey: GlobalKey<FormState>(),
    voterIdNumberController: TextEditingController(),
    passportVerificationFormKey: GlobalKey<FormState>(),
    passportNumberController: TextEditingController(),
    panVerificationKey: GlobalKey<FormState>(),
    panNameController: TextEditingController(),
    panNumberController: TextEditingController(),
    registerAddressFormKey: GlobalKey<FormState>(),
    pinCodeController: TextEditingController(),
    stateNameController: TextEditingController(),
    cityNameController: TextEditingController(),
    address1NameController: TextEditingController(),
    address2NameController: TextEditingController(),
    annualTurnoverFormKey: GlobalKey<FormState>(),
    turnOverController: TextEditingController(),
    gstNumberController: TextEditingController(),
    personalBankAccountVerificationFormKey: GlobalKey<FormState>(),
    bankAccountNumberController: TextEditingController(),
    reEnterbankAccountNumberController: TextEditingController(),
    ifscCodeController: TextEditingController(),
    sePasswordFormKey: GlobalKey<FormState>(),
    captchaInputController: TextEditingController(),
    fullNameController: TextEditingController(),
    websiteController: TextEditingController(),
    mobileController: TextEditingController(),
    otpController: TextEditingController(),
    captchaInput: '',
    isCaptchaValid: false,
    isCaptchaSubmitting: false,
    isResidenceAddressSameAsAadhar: 0,
    isPanDetailsLoading: false,
    isPanDetailsVerified: false,
    isCityAndStateLoading: false,
    isCityAndStateVerified: false,
    isAgreeToAddressSameAsAadhar: false,
    isLoading: false,
    isReady: false,
    hasPermission: false,
    isImageCaptured: false,
    isImageSubmitted: false,
    navigateNext: false,
    isOTPSent: false,
    isOtpVerified: false,
    canResendOTP: false,
    timeLeft: 0,
    obscurePassword: false,
    obscureConfirmPassword: false,
    familyAndFriendsDescriptionController: TextEditingController(),
    iceVerificationKey: GlobalKey<FormState>(),
    iceNumberController: TextEditingController(),
    personalDbaController: TextEditingController(),
  );
}

void main() {
  group('PersonalIdentityVerificationView Widget Tests', () {
    late MockPersonalAccountSetupBloc mockBloc;

    setUp(() {
      mockBloc = MockPersonalAccountSetupBloc();
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
          body: BlocProvider<PersonalAccountSetupBloc>.value(
            value: mockBloc,
            child: const PersonalIdentityVerificationView(),
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
      expect(find.byType(PersonalIdentityVerificationView), findsOneWidget);
    });

    testWidgets('should display dropdown field', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(ExpandableDropdownField), findsOneWidget);
    });

    testWidgets('should display Aadhar verification form when Aadhar is selected and not verified', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(selectedIDVerificationDocType: IDVerificationDocType.aadharCard, isIdVerified: false),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(selectedIDVerificationDocType: IDVerificationDocType.aadharCard, isIdVerified: false),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.textContaining('Aadhar Number'), findsOneWidget);
      expect(find.byType(CustomTextInputField), findsAtLeastNWidgets(1));
    });

    testWidgets('should display verified Aadhar info when Aadhar is verified', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          selectedIDVerificationDocType: IDVerificationDocType.aadharCard,
          isIdVerified: true,
          aadharNumber: '1234-5678-9012',
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            selectedIDVerificationDocType: IDVerificationDocType.aadharCard,
            isIdVerified: true,
            aadharNumber: '1234-5678-9012',
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(CommanVerifiedInfoBox), findsOneWidget);
      expect(find.textContaining('Upload Aadhar Card'), findsOneWidget);
      expect(find.byType(CustomFileUploadWidget), findsNWidgets(2)); // Front and back
    });

    testWidgets('should display driving license verification form when driving license is selected and not verified', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(selectedIDVerificationDocType: IDVerificationDocType.drivingLicense, isIdVerified: false),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(selectedIDVerificationDocType: IDVerificationDocType.drivingLicense, isIdVerified: false),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.textContaining('Driving Licence number'), findsOneWidget);
      expect(find.byType(CustomTextInputField), findsAtLeastNWidgets(1));
    });

    testWidgets('should display verified driving license info when driving license is verified', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          selectedIDVerificationDocType: IDVerificationDocType.drivingLicense,
          isIdVerified: true,
          drivingLicenseNumber: 'DL1420110012345',
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            selectedIDVerificationDocType: IDVerificationDocType.drivingLicense,
            isIdVerified: true,
            drivingLicenseNumber: 'DL1420110012345',
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(CommanVerifiedInfoBox), findsOneWidget);
      expect(find.textContaining('Upload Driving License'), findsOneWidget);
      expect(find.byType(CustomFileUploadWidget), findsOneWidget);
    });

    testWidgets('should display voter ID verification form when voter ID is selected and not verified', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(
        mockBloc.state,
      ).thenReturn(createTestState(selectedIDVerificationDocType: IDVerificationDocType.voterID, isIdVerified: false));
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(selectedIDVerificationDocType: IDVerificationDocType.voterID, isIdVerified: false),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.textContaining('Voter ID number'), findsOneWidget);
      expect(find.byType(CustomTextInputField), findsAtLeastNWidgets(1));
    });

    testWidgets('should display verified voter ID info when voter ID is verified', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          selectedIDVerificationDocType: IDVerificationDocType.voterID,
          isIdVerified: true,
          voterIDNumber: 'ABC1234567',
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            selectedIDVerificationDocType: IDVerificationDocType.voterID,
            isIdVerified: true,
            voterIDNumber: 'ABC1234567',
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(CommanVerifiedInfoBox), findsOneWidget);
      expect(find.textContaining('Upload Voter ID'), findsOneWidget);
      expect(find.byType(CustomFileUploadWidget), findsOneWidget);
    });

    testWidgets('should display passport verification form when passport is selected and not verified', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(
        mockBloc.state,
      ).thenReturn(createTestState(selectedIDVerificationDocType: IDVerificationDocType.passport, isIdVerified: false));
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(selectedIDVerificationDocType: IDVerificationDocType.passport, isIdVerified: false),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.textContaining('Passport number'), findsOneWidget);
      expect(find.byType(CustomTextInputField), findsAtLeastNWidgets(1));
    });

    testWidgets('should display verified passport info when passport is verified', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          selectedIDVerificationDocType: IDVerificationDocType.passport,
          isIdVerified: true,
          passporteNumber: 'A1234567',
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            selectedIDVerificationDocType: IDVerificationDocType.passport,
            isIdVerified: true,
            passporteNumber: 'A1234567',
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(CommanVerifiedInfoBox), findsOneWidget);
      expect(find.textContaining('Upload Passport'), findsOneWidget);
      expect(find.byType(CustomFileUploadWidget), findsOneWidget);
    });

    testWidgets('should handle dropdown selection', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Find and tap the dropdown
      final dropdown = find.byType(ExpandableDropdownField);
      expect(dropdown, findsOneWidget);

      // Simulate dropdown selection
      await tester.tap(dropdown);
      await tester.pump();
    });

    testWidgets('should test formatSecondsToMMSS method', (WidgetTester tester) async {
      // Arrange
      final widget = PersonalIdentityVerificationView();

      // Act & Assert
      expect(widget.formatSecondsToMMSS(0), equals('00:00'));
      expect(widget.formatSecondsToMMSS(60), equals('01:00'));
      expect(widget.formatSecondsToMMSS(125), equals('02:05'));
      expect(widget.formatSecondsToMMSS(3661), equals('61:01'));
    });

    test('should test widget instantiation', () {
      // Arrange & Act
      final widget = PersonalIdentityVerificationView();

      // Assert
      expect(widget, isA<PersonalIdentityVerificationView>());
      expect(widget, isA<StatelessWidget>());
    });

    test('should test formatSecondsToMMSS with edge cases', () {
      // Arrange
      final widget = PersonalIdentityVerificationView();

      // Act & Assert - Test edge cases
      expect(widget.formatSecondsToMMSS(-1), equals('00:59')); // Negative seconds: -1 % 60 = 59
      expect(widget.formatSecondsToMMSS(59), equals('00:59')); // Less than a minute
      expect(widget.formatSecondsToMMSS(3599), equals('59:59')); // Almost an hour
      expect(widget.formatSecondsToMMSS(3600), equals('60:00')); // Exactly an hour
    });

    testWidgets('should handle null selectedIDVerificationDocType', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          selectedIDVerificationDocType: null, // No document type selected
          isIdVerified: false,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([createTestState(selectedIDVerificationDocType: null, isIdVerified: false)]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(ExpandableDropdownField), findsOneWidget);
      // Should not show any document-specific fields
      expect(find.byType(CustomTextInputField), findsNothing);
    });

    test('should test formatSecondsToMMSS with various inputs', () {
      // Arrange
      final widget = PersonalIdentityVerificationView();

      // Act & Assert - Test more edge cases
      expect(widget.formatSecondsToMMSS(1), equals('00:01'));
      expect(widget.formatSecondsToMMSS(10), equals('00:10'));
      expect(widget.formatSecondsToMMSS(61), equals('01:01'));
      expect(widget.formatSecondsToMMSS(119), equals('01:59'));
      expect(widget.formatSecondsToMMSS(600), equals('10:00'));
      expect(widget.formatSecondsToMMSS(3661), equals('61:01'));
      expect(widget.formatSecondsToMMSS(7200), equals('120:00'));
    });

    test('should create widget with correct type', () {
      // Arrange & Act
      final widget = PersonalIdentityVerificationView();

      // Assert
      expect(widget.runtimeType, equals(PersonalIdentityVerificationView));
      expect(widget, isA<StatelessWidget>());
      expect(widget, isA<Widget>());
    });
  });
}
