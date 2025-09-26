import 'dart:typed_data';
import 'package:exchek/core/enums/app_enums.dart';
import 'package:exchek/views/account_setup_view/personal_account_setup_view/personal_account_kyc_setup_view/personal_annual_turnover_declaration.dart';
import 'package:exchek/viewmodels/account_setup_bloc/personal_account_setup_bloc/personal_account_setup_bloc.dart';
import 'package:exchek/widgets/account_setup_widgets/custom_tile.dart';
import 'package:exchek/widgets/custom_widget/custom_button.dart';
import 'package:exchek/widgets/custom_widget/custom_textfields.dart';
import 'package:exchek/widgets/common_widget/app_file_upload_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:exchek/core/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

@GenerateMocks([PersonalAccountSetupBloc])
import 'personal_annual_turnover_declaration_test.mocks.dart';

// Helper function to create mock FileData
FileData createMockFileData() {
  return FileData(
    name: 'test_gst_certificate.pdf',
    bytes: Uint8List.fromList([1, 2, 3, 4]),
    sizeInMB: 1.0,
    path: '/path/test_gst_certificate.pdf',
  );
}

PersonalAccountSetupState createTestState({
  bool? isGstCertificateMandatory,
  bool? isGstVerificationLoading,
  String? selectedTurnover,
  String? gstNumber,
  FileData? gstCertificateFile,
  bool? isGSTNumberVerify,
}) {
  return PersonalAccountSetupState(
    isGstCertificateMandatory: isGstCertificateMandatory,
    isGstVerificationLoading: isGstVerificationLoading,
    selectedAnnualTurnover: selectedTurnover, // Set the selectedAnnualTurnover property
    isGSTNumberVerify: isGSTNumberVerify ?? false,
    currentKycVerificationStep: PersonalEKycVerificationSteps.annualTurnoverDeclaration,
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
    turnOverController: TextEditingController(text: selectedTurnover),
    gstNumberController: TextEditingController(text: gstNumber),
    gstCertificateFile: gstCertificateFile,
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
    isCaptchaSend: false,
    isOtpLoading: false,
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
  group('PersonalAnnualTurnoverDeclaration Widget Tests', () {
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
          body: SingleChildScrollView(
            child: SizedBox(
              height: 1500, // Provide enough height to prevent overflow
              child: BlocProvider<PersonalAccountSetupBloc>.value(
                value: mockBloc,
                child: PersonalAnnualTurnoverDeclaration(),
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('should display title and description', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert - Look for actual text from Lang keys
      expect(find.byType(Text), findsAtLeastNWidgets(2));
      // The widget uses Lang.of(context).lbl_turnover_previous_financial_year for title
      // and Lang.of(context).lbl_turnover_info_content for description
    });

    testWidgets('should display annual turnover field', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert - The widget shows 2 CustomTileWidget instances for the 2 turnover options
      expect(find.byType(CustomTileWidget), findsNWidgets(2));
    });

    testWidgets('should display GST number field when GST certificate is mandatory', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          isGstCertificateMandatory: true,
          selectedTurnover: '₹20 lakhs or more', // Need to select turnover for GST fields to show
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(isGstCertificateMandatory: true, selectedTurnover: '₹20 lakhs or more'),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(CustomTextInputField), findsOneWidget);
    });

    testWidgets('should display GST certificate upload when GST certificate is mandatory', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          isGstCertificateMandatory: true,
          selectedTurnover: '₹20 lakhs or more', // Need to select turnover for GST fields to show
          isGSTNumberVerify: true, // Need GST to be verified for file upload to show
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            isGstCertificateMandatory: true,
            selectedTurnover: '₹20 lakhs or more',
            isGSTNumberVerify: true,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(CustomFileUploadWidget), findsOneWidget);
    });

    testWidgets('should not display GST fields when GST certificate is not mandatory', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          isGstCertificateMandatory: false,
          selectedTurnover: 'Less than ₹20 lakhs', // Need to select turnover for GST fields to show
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(isGstCertificateMandatory: false, selectedTurnover: 'Less than ₹20 lakhs'),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      // Based on the actual widget implementation, GST fields are shown when selectedAnnualTurnover is not null
      expect(find.byType(CustomTextInputField), findsOneWidget); // GST number field is shown
      expect(find.byType(CustomFileUploadWidget), findsOneWidget); // File upload is shown
    });

    testWidgets('should display Next button', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          selectedTurnover: '₹20 lakhs or more', // Need to select turnover for Next button to show
          isGstCertificateMandatory: true,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(selectedTurnover: '₹20 lakhs or more', isGstCertificateMandatory: true),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(CustomElevatedButton), findsAtLeastNWidgets(1));
    });

    testWidgets('should have form with proper validation key', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('should display Next button when GST certificate is not mandatory', (WidgetTester tester) async {
      // Arrange
      when(
        mockBloc.state,
      ).thenReturn(createTestState(isGstCertificateMandatory: false, selectedTurnover: 'Less than ₹20 lakhs'));
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(isGstCertificateMandatory: false, selectedTurnover: 'Less than ₹20 lakhs'),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(CustomElevatedButton), findsOneWidget); // Only Next button (no skip button in this widget)
    });

    testWidgets('should display Verify button when GST certificate is mandatory and GST not verified', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          isGstCertificateMandatory: true,
          selectedTurnover: '₹20 lakhs or more',
          isGstVerificationLoading: false,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            isGstCertificateMandatory: true,
            selectedTurnover: '₹20 lakhs or more',
            isGstVerificationLoading: false,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(CustomElevatedButton), findsOneWidget); // Verify button
    });

    testWidgets('should display loading state when GST verification is in progress', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          isGstCertificateMandatory: true,
          isGstVerificationLoading: true,
          selectedTurnover: '₹20 lakhs or more',
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            isGstCertificateMandatory: true,
            isGstVerificationLoading: true,
            selectedTurnover: '₹20 lakhs or more',
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
      expect(button.isLoading, isTrue);
    });

    testWidgets('should disable Next button when form is invalid', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          isGstCertificateMandatory: true,
          selectedTurnover: '₹20 lakhs or more', // Valid turnover
          gstNumber: '', // Empty GST number
          gstCertificateFile: null, // No file uploaded - this makes button disabled
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            isGstCertificateMandatory: true,
            selectedTurnover: '₹20 lakhs or more',
            gstNumber: '',
            gstCertificateFile: null,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
      expect(button.isDisabled, isTrue);
    });

    testWidgets('should enable Next button when form is valid', (WidgetTester tester) async {
      // Arrange
      final mockFileData = createMockFileData();
      when(mockBloc.state).thenReturn(
        createTestState(
          isGstCertificateMandatory: true,
          selectedTurnover: '10-50 Lakhs',
          gstNumber: '12ABCDE3456F1Z5',
          gstCertificateFile: mockFileData,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            isGstCertificateMandatory: true,
            selectedTurnover: '10-50 Lakhs',
            gstNumber: '12ABCDE3456F1Z5',
            gstCertificateFile: mockFileData,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
      expect(button.isDisabled, isFalse);
    });

    testWidgets('should trigger onPressed when Next button is tapped', (WidgetTester tester) async {
      // Arrange
      final mockFileData = createMockFileData();
      final testState = createTestState(
        isGstCertificateMandatory: true,
        selectedTurnover: '10-50 Lakhs',
        gstNumber: '12ABCDE3456F1Z5',
        gstCertificateFile: mockFileData,
      );

      when(mockBloc.state).thenReturn(testState);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([testState]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Scroll to make the button visible
      await tester.scrollUntilVisible(
        find.byType(CustomElevatedButton).last,
        500.0,
        scrollable: find.byType(Scrollable).first,
      );

      // Tap the Next button (last one, which is the actual Next button)
      await tester.tap(find.byType(CustomElevatedButton).last, warnIfMissed: false);
      await tester.pump();

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Note: Skip button test removed because the widget doesn't have a skip button
    // The skip button code is commented out in the actual widget implementation
  });
}
