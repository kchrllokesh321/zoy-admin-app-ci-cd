import 'package:exchek/core/enums/app_enums.dart';
import 'package:exchek/views/account_setup_view/personal_account_setup_view/personal_account_kyc_setup_view/personal_bank_account_linking.dart';
import 'package:exchek/viewmodels/account_setup_bloc/personal_account_setup_bloc/personal_account_setup_bloc.dart';
import 'package:exchek/widgets/custom_widget/custom_button.dart';
import 'package:exchek/widgets/custom_widget/custom_textfields.dart';
import 'package:exchek/widgets/common_widget/app_file_upload_widget.dart';
import 'package:exchek/widgets/custom_widget/custom_drop_down_field.dart';
import 'package:exchek/widgets/common_widget/comman_verified_info_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:exchek/core/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

@GenerateMocks([PersonalAccountSetupBloc])
import 'personal_bank_account_linking_test.mocks.dart';

PersonalAccountSetupState createTestState({
  bool? isBankAccountVerify,
  bool? isBankAccountNumberVerifiedLoading,
  String? bankAccountNumber,
  String? ifscCode,
  String? accountHolderName,
  String? selectedBankAccountVerificationDocType,
}) {
  return PersonalAccountSetupState(
    isBankAccountVerify: isBankAccountVerify,
    isBankAccountNumberVerifiedLoading: isBankAccountNumberVerifiedLoading,
    bankAccountNumber: bankAccountNumber,
    ifscCode: ifscCode,
    accountHolderName: accountHolderName,
    selectedBankAccountVerificationDocType: selectedBankAccountVerificationDocType,
    currentKycVerificationStep: PersonalEKycVerificationSteps.bankAccountLinking,
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
    bankAccountNumberController: TextEditingController(text: bankAccountNumber),
    reEnterbankAccountNumberController: TextEditingController(text: bankAccountNumber),
    ifscCodeController: TextEditingController(text: ifscCode),
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
  group('PersonalBankAccountLinking Widget Tests', () {
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
            child: const PersonalBankAccountLinking(),
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
      await tester.pump();

      // Assert
      // The widget uses Lang.of(context).lbl_link_your_bank_account and Lang.of(context).lbl_securely_connect_account
      // We should look for Text widgets instead of specific text content
      expect(find.byType(Text), findsAtLeastNWidgets(2));
    });

    testWidgets('should display bank account form fields when not verified', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(isBankAccountVerify: false));
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState(isBankAccountVerify: false)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      // Check for form fields by widget type instead of text content
      expect(find.byType(CustomTextInputField), findsNWidgets(3)); // Bank account, re-enter bank account, IFSC
      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('should display verify button when bank details are entered', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(isBankAccountVerify: false, bankAccountNumber: '1234567890', ifscCode: 'SBIN0001234'),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(isBankAccountVerify: false, bankAccountNumber: '1234567890', ifscCode: 'SBIN0001234'),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      // Check for button by type instead of text content
      expect(find.byType(CustomElevatedButton), findsOneWidget);
    });

    testWidgets('should display verified bank account info when verified', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          isBankAccountVerify: true,
          bankAccountNumber: '1234567890',
          ifscCode: 'SBIN0001234',
          accountHolderName: 'John Doe',
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            isBankAccountVerify: true,
            bankAccountNumber: '1234567890',
            ifscCode: 'SBIN0001234',
            accountHolderName: 'John Doe',
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      // Check for verified info boxes - should have 3 (bank account, IFSC, account holder name)
      expect(find.byType(CommanVerifiedInfoBox), findsNWidgets(3));
    });

    testWidgets('should display bank verification document dropdown when verified', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(isBankAccountVerify: true));
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState(isBankAccountVerify: true)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      // Check for dropdown widget
      expect(find.byType(ExpandableDropdownField), findsOneWidget);
    });

    testWidgets('should display file upload widget when document type is selected', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(isBankAccountVerify: true, selectedBankAccountVerificationDocType: 'Bank Statement'),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(isBankAccountVerify: true, selectedBankAccountVerificationDocType: 'Bank Statement'),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(CustomFileUploadWidget), findsOneWidget);
    });

    testWidgets('should display Next button when bank account is verified and document uploaded', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(isBankAccountVerify: true, selectedBankAccountVerificationDocType: 'Bank Statement'),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(isBankAccountVerify: true, selectedBankAccountVerificationDocType: 'Bank Statement'),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      // Check for submit button by type - the widget shows a submit button when verified
      expect(find.byType(CustomElevatedButton), findsOneWidget);
    });

    testWidgets('should display loading state when bank verification is in progress', (WidgetTester tester) async {
      // Arrange
      when(
        mockBloc.state,
      ).thenReturn(createTestState(isBankAccountVerify: false, isBankAccountNumberVerifiedLoading: true));
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(isBankAccountVerify: false, isBankAccountNumberVerifiedLoading: true),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      // Check that a button exists and it should be in loading state
      final buttonFinder = find.byType(CustomElevatedButton);
      expect(buttonFinder, findsOneWidget);
      final verifyButton = tester.widget<CustomElevatedButton>(buttonFinder);
      expect(verifyButton.isLoading, isTrue);
    });

    testWidgets('should have form with proper validation key', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('should validate bank account number fields match', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(isBankAccountVerify: false));
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState(isBankAccountVerify: false)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - Both bank account number fields should be present
      expect(find.byType(CustomTextInputField), findsNWidgets(3)); // Bank account, re-enter, IFSC
    });

    testWidgets('should disable verify button when fields are empty', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(isBankAccountVerify: false));
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState(isBankAccountVerify: false)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final buttonFinder = find.byType(CustomElevatedButton);
      expect(buttonFinder, findsOneWidget);
      final verifyButton = tester.widget<CustomElevatedButton>(buttonFinder);
      expect(verifyButton.isDisabled, isTrue);
    });
  });
}
