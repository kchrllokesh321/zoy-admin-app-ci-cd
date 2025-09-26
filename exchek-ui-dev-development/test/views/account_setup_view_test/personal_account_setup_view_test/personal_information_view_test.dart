import 'package:exchek/core/enums/app_enums.dart';
import 'package:exchek/widgets/custom_widget/custom_button.dart';
import 'package:exchek/widgets/custom_widget/custom_textfields.dart';
import 'package:exchek/widgets/common_widget/comman_verified_info_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:exchek/views/account_setup_view/personal_account_setup_view/personal_information_view.dart';
import 'package:exchek/viewmodels/account_setup_bloc/personal_account_setup_bloc/personal_account_setup_bloc.dart';
import 'package:exchek/core/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

@GenerateMocks([PersonalAccountSetupBloc])
import 'personal_information_view_test.mocks.dart';

PersonalAccountSetupState createTestState({
  GlobalKey<FormState>? personalInfoKey,
  TextEditingController? fullnameNameController,
  TextEditingController? websiteController,
  TextEditingController? mobileController,
  TextEditingController? otpController,
  bool isOTPSent = false,
  int timeLeft = 0,
  bool isLoading = false,
  ScrollController? scrollController,
  PersonalAccountSetupSteps currentStep = PersonalAccountSetupSteps.personalInformation,
  String? fullNameText,
  String? websiteText,
  String? mobileText,
  String? otpText,
}) {
  // Create a form key that will be properly attached to the form in the widget
  final formKey = personalInfoKey ?? GlobalKey<FormState>();

  return PersonalAccountSetupState(
    personalInfoKey: formKey,
    fullNameController: fullnameNameController ?? TextEditingController(text: fullNameText),
    websiteController: websiteController ?? TextEditingController(text: websiteText),
    mobileController: mobileController ?? TextEditingController(text: mobileText),
    otpController: otpController ?? TextEditingController(text: otpText),
    isOTPSent: isOTPSent,
    timeLeft: timeLeft,
    isLoading: isLoading,
    scrollController: scrollController ?? ScrollController(),
    currentStep: currentStep,
    professionOtherController: TextEditingController(),
    productServiceDescriptionController: TextEditingController(),
    passwordController: TextEditingController(),
    confirmPasswordController: TextEditingController(),
    currentKycVerificationStep: PersonalEKycVerificationSteps.identityVerification,
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
    familyAndFriendsDescriptionController: TextEditingController(),
    iceVerificationKey: GlobalKey<FormState>(),
    iceNumberController: TextEditingController(),
    personalDbaController: TextEditingController(),
  );
}

void main() {
  group('PersonalLegalNameContactView Widget Tests', () {
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
              height: 1200, // Increase height to accommodate all content
              child: BlocProvider<PersonalAccountSetupBloc>.value(
                value: mockBloc,
                child: const PersonalLegalNameContactView(),
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
      await tester.pump();

      // Assert
      expect(find.textContaining('Confirm your identity'), findsOneWidget);
      expect(
        find.textContaining(
          'Official full name, phone number, and website required for verification and communication.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('should display all form fields', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(CustomTextInputField), findsNWidgets(3)); // Full name, Website, Phone
      expect(find.text('Full Legal Name'), findsOneWidget);
      expect(find.textContaining('Professional website URL'), findsOneWidget);
      expect(find.textContaining('Mobile Number'), findsOneWidget);
    });

    testWidgets('should display Send OTP button when OTP not sent', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(isOTPSent: false));
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState(isOTPSent: false)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - Look for the button by type instead of text since text might be localized
      expect(find.byType(CustomElevatedButton), findsOneWidget);
      final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
      // Button should be disabled when form is empty
      expect(button.isDisabled, isTrue);
    });

    testWidgets('should display OTP field and Confirm button when OTP sent', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(isOTPSent: true));
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState(isOTPSent: true)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.textContaining('OTP'), findsAtLeastNWidgets(1));
      expect(find.text('Confirm and Continue'), findsOneWidget);
      expect(find.byType(CustomTextInputField), findsNWidgets(4)); // Including OTP field (3 original + 1 OTP)
    });

    testWidgets('should disable form fields when OTP is sent', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(isOTPSent: true, timeLeft: 60));
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState(isOTPSent: true, timeLeft: 60)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final absorbPointers = find.byType(AbsorbPointer);
      expect(absorbPointers, findsAtLeastNWidgets(1));

      // Check that at least one AbsorbPointer is absorbing
      final absorbPointerWidgets = tester.widgetList<AbsorbPointer>(absorbPointers);
      expect(absorbPointerWidgets.any((widget) => widget.absorbing), isTrue);
    });

    testWidgets('should display resend OTP timer when timer is running', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(isOTPSent: true, timeLeft: 120, mobileText: '9876543210'));
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([createTestState(isOTPSent: true, timeLeft: 120, mobileText: '9876543210')]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.textContaining('Resend OTP in 02:00sec'), findsOneWidget);
    });

    testWidgets('should enable Send OTP button when form is valid', (WidgetTester tester) async {
      // Arrange
      final mobileController = TextEditingController(text: '9876543210');
      final fullnameNameController = TextEditingController(text: 'John Doe');
      final websiteController = TextEditingController(text: 'https://test.com');

      when(mockBloc.state).thenReturn(
        createTestState(
          fullnameNameController: fullnameNameController,
          websiteController: websiteController,
          mobileController: mobileController,
          isOTPSent: false,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            fullnameNameController: fullnameNameController,
            websiteController: websiteController,
            mobileController: mobileController,
            isOTPSent: false,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Find the Send OTP button by type
      final sendOtpButtons = find.byType(CustomElevatedButton);
      expect(sendOtpButtons, findsOneWidget);

      // Assert that the button is enabled (not disabled)
      final buttonWidget = tester.widget<CustomElevatedButton>(sendOtpButtons);
      expect(buttonWidget.isDisabled, isFalse);
      expect(buttonWidget.onPressed, isNotNull);
    });

    testWidgets('should enable Confirm and Continue button when all fields are valid', (WidgetTester tester) async {
      // Arrange
      final fullnameNameController = TextEditingController(text: 'John Doe');
      final mobileController = TextEditingController(text: '9876543210');
      final otpController = TextEditingController(text: '123456');

      when(mockBloc.state).thenReturn(
        createTestState(
          fullnameNameController: fullnameNameController,
          mobileController: mobileController,
          otpController: otpController,
          isOTPSent: true,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            fullnameNameController: fullnameNameController,
            mobileController: mobileController,
            otpController: otpController,
            isOTPSent: true,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Find the Confirm and Continue button by type (there should be one button when OTP is sent)
      final confirmButtons = find.byType(CustomElevatedButton);
      expect(confirmButtons, findsOneWidget);

      // Assert that the button is enabled (not disabled)
      final buttonWidget = tester.widget<CustomElevatedButton>(confirmButtons);
      expect(buttonWidget.isDisabled, isFalse);
      expect(buttonWidget.onPressed, isNotNull);
    });

    testWidgets('should disable Send OTP button when mobile number is invalid', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          mobileText: '123', // Invalid mobile
          isOTPSent: false,
        ),
      );
      when(
        mockBloc.stream,
      ).thenAnswer((_) => Stream.fromIterable([createTestState(mobileText: '123', isOTPSent: false)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
      expect(button.isDisabled, isTrue);
    });

    testWidgets('should enable Confirm button when all required fields are filled', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(fullNameText: 'John Doe', mobileText: '9876543210', otpText: '123456', isOTPSent: true),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(fullNameText: 'John Doe', mobileText: '9876543210', otpText: '123456', isOTPSent: true),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
      expect(button.isDisabled, isFalse);
    });

    group('formatSecondsToMMSS Tests', () {
      testWidgets('should format seconds correctly', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(MaterialApp(home: Container()));
        const widget = PersonalLegalNameContactView();

        // Act & Assert
        expect(widget.formatSecondsToMMSS(0), equals('00:00'));
        expect(widget.formatSecondsToMMSS(30), equals('00:30'));
        expect(widget.formatSecondsToMMSS(60), equals('01:00'));
        expect(widget.formatSecondsToMMSS(90), equals('01:30'));
        expect(widget.formatSecondsToMMSS(120), equals('02:00'));
      });
    });

    testWidgets('should display India country code prefix', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(isOTPSent: false));
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState(isOTPSent: false)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.text('+91'), findsOneWidget);
    });

    testWidgets('should show verified info box when personal info is verified', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(isOTPSent: true, mobileText: '9876543210');
      // Set the verified flag
      final verifiedState = state.copyWith(isVerifyPersonalRegisterdInfo: true);

      when(mockBloc.state).thenReturn(verifiedState);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([verifiedState]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - Should show verified info box instead of text field
      expect(find.byType(CommanVerifiedInfoBox), findsOneWidget);
    });

    testWidgets('should handle resend OTP when timer expires', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(isOTPSent: true, timeLeft: 0, mobileText: '9876543210'));
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([createTestState(isOTPSent: true, timeLeft: 0, mobileText: '9876543210')]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Find the resend OTP text/button in the suffix
      final otpField = find.byType(CustomTextInputField).last;
      expect(otpField, findsOneWidget);

      // The resend functionality should be available when timer is 0
      final otpFieldWidget = tester.widget<CustomTextInputField>(otpField);
      expect(otpFieldWidget.suffixIcon, isNotNull);
    });

    testWidgets('should handle form validation correctly', (WidgetTester tester) async {
      // Arrange
      final mobileController = TextEditingController(text: '9876543210');
      final fullnameController = TextEditingController(text: 'John Doe');
      final websiteController = TextEditingController(text: 'https://test.com');

      when(mockBloc.state).thenReturn(
        createTestState(
          mobileController: mobileController,
          fullnameNameController: fullnameController,
          websiteController: websiteController,
          isOTPSent: false,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            mobileController: mobileController,
            fullnameNameController: fullnameController,
            websiteController: websiteController,
            isOTPSent: false,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - Form should be valid with all fields filled
      final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
      expect(button.isDisabled, isFalse);
    });

    testWidgets('should show OTP field when OTP is sent', (WidgetTester tester) async {
      // Arrange
      final fullnameController = TextEditingController(text: 'John Doe');
      final mobileController = TextEditingController(text: '9876543210');
      final otpController = TextEditingController(text: '123456');

      when(mockBloc.state).thenReturn(
        createTestState(
          fullnameNameController: fullnameController,
          mobileController: mobileController,
          otpController: otpController,
          isOTPSent: true,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            fullnameNameController: fullnameController,
            mobileController: mobileController,
            otpController: otpController,
            isOTPSent: true,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - Should show OTP field and button should be enabled
      expect(find.byType(CustomTextInputField), findsNWidgets(4)); // 3 original + 1 OTP
      final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
      expect(button.isDisabled, isFalse);
    });

    testWidgets('should validate button state correctly', (WidgetTester tester) async {
      // Arrange
      final mobileController = TextEditingController(text: '9876543210');
      final fullnameController = TextEditingController(text: 'John Doe');
      final websiteController = TextEditingController(text: 'https://test.com');

      when(mockBloc.state).thenReturn(
        createTestState(
          mobileController: mobileController,
          fullnameNameController: fullnameController,
          websiteController: websiteController,
          isOTPSent: false,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            mobileController: mobileController,
            fullnameNameController: fullnameController,
            websiteController: websiteController,
            isOTPSent: false,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - Button should be enabled when form is valid
      final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
      expect(button.isDisabled, isFalse);
      expect(button.onPressed, isNotNull);
    });

    testWidgets('should validate OTP form state correctly', (WidgetTester tester) async {
      // Arrange
      final fullnameController = TextEditingController(text: 'John Doe');
      final mobileController = TextEditingController(text: '9876543210');
      final otpController = TextEditingController(text: '123456');

      when(mockBloc.state).thenReturn(
        createTestState(
          fullnameNameController: fullnameController,
          mobileController: mobileController,
          otpController: otpController,
          isOTPSent: true,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            fullnameNameController: fullnameController,
            mobileController: mobileController,
            otpController: otpController,
            isOTPSent: true,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - Button should be enabled when OTP form is valid
      final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
      expect(button.isDisabled, isFalse);
      expect(button.onPressed, isNotNull);
    });

    testWidgets('should handle verified state button press for next step', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(isOTPSent: true, currentStep: PersonalAccountSetupSteps.personalInformation);
      final verifiedState = state.copyWith(isVerifyPersonalRegisterdInfo: true);

      when(mockBloc.state).thenReturn(verifiedState);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([verifiedState]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - Button should be enabled and have callback for verified state
      final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
      expect(button.isDisabled, isFalse);
      expect(button.onPressed, isNotNull);

      // Verify verified info box is shown
      expect(find.byType(CommanVerifiedInfoBox), findsOneWidget);
    });

    group('Edge Cases and Error Handling', () {
      testWidgets('should handle empty form validation', (WidgetTester tester) async {
        // Arrange
        when(mockBloc.state).thenReturn(createTestState(isOTPSent: false));
        when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState(isOTPSent: false)]));

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert - Button should be disabled when form is empty
        final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
        expect(button.isDisabled, isTrue);
      });

      testWidgets('should handle loading state', (WidgetTester tester) async {
        // Arrange
        when(mockBloc.state).thenReturn(createTestState(isLoading: true, isOTPSent: false));
        when(
          mockBloc.stream,
        ).thenAnswer((_) => Stream.fromIterable([createTestState(isLoading: true, isOTPSent: false)]));

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert - Button should show loading state
        final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
        expect(button.isLoading, isTrue);
      });

      testWidgets('should handle timer display correctly', (WidgetTester tester) async {
        // Arrange - Test with a specific timer value
        when(mockBloc.state).thenReturn(createTestState(isOTPSent: true, timeLeft: 30, mobileText: '9876543210'));
        when(mockBloc.stream).thenAnswer(
          (_) => Stream.fromIterable([createTestState(isOTPSent: true, timeLeft: 30, mobileText: '9876543210')]),
        );

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert - Should show timer when OTP is sent and timer is running
        expect(find.byType(CustomTextInputField), findsNWidgets(4)); // 3 original + 1 OTP
        // Timer text should be present in the OTP field suffix
        final otpField = find.byType(CustomTextInputField).last;
        expect(otpField, findsOneWidget);
      });

      testWidgets('should handle form validation edge cases', (WidgetTester tester) async {
        // Arrange - Test with invalid mobile number
        final mobileController = TextEditingController(text: '123'); // Invalid mobile
        final fullnameController = TextEditingController(text: 'John Doe');
        final websiteController = TextEditingController(text: 'invalid-url'); // Invalid URL

        when(mockBloc.state).thenReturn(
          createTestState(
            mobileController: mobileController,
            fullnameNameController: fullnameController,
            websiteController: websiteController,
            isOTPSent: false,
          ),
        );
        when(mockBloc.stream).thenAnswer(
          (_) => Stream.fromIterable([
            createTestState(
              mobileController: mobileController,
              fullnameNameController: fullnameController,
              websiteController: websiteController,
              isOTPSent: false,
            ),
          ]),
        );

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert - Button should be disabled with invalid data
        final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
        expect(button.isDisabled, isTrue);
      });

      testWidgets('should handle OTP field submission with valid data', (WidgetTester tester) async {
        // Arrange
        final fullnameController = TextEditingController(text: 'John Doe');
        final mobileController = TextEditingController(text: '9876543210');
        final otpController = TextEditingController(text: '123456');

        when(mockBloc.state).thenReturn(
          createTestState(
            fullnameNameController: fullnameController,
            mobileController: mobileController,
            otpController: otpController,
            isOTPSent: true,
          ),
        );
        when(mockBloc.stream).thenAnswer(
          (_) => Stream.fromIterable([
            createTestState(
              fullnameNameController: fullnameController,
              mobileController: mobileController,
              otpController: otpController,
              isOTPSent: true,
            ),
          ]),
        );

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Find OTP field and trigger onFieldSubmitted
        final otpField = find.byType(CustomTextInputField).last;
        final otpWidget = tester.widget<CustomTextInputField>(otpField);

        // Simulate field submission
        otpWidget.onFieldSubmitted?.call('123456');
        await tester.pump();

        // Assert - Should handle submission correctly
        expect(find.byType(CustomTextInputField), findsNWidgets(4));
      });

      testWidgets('should handle mobile field submission with valid data', (WidgetTester tester) async {
        // Arrange
        final fullnameController = TextEditingController(text: 'John Doe');
        final mobileController = TextEditingController(text: '9876543210');
        final websiteController = TextEditingController(text: 'https://test.com');

        when(mockBloc.state).thenReturn(
          createTestState(
            fullnameNameController: fullnameController,
            mobileController: mobileController,
            websiteController: websiteController,
            isOTPSent: false,
          ),
        );
        when(mockBloc.stream).thenAnswer(
          (_) => Stream.fromIterable([
            createTestState(
              fullnameNameController: fullnameController,
              mobileController: mobileController,
              websiteController: websiteController,
              isOTPSent: false,
            ),
          ]),
        );

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Find mobile field and trigger onFieldSubmitted
        final mobileField = find.byType(CustomTextInputField).at(2); // Mobile is 3rd field
        final mobileWidget = tester.widget<CustomTextInputField>(mobileField);

        // Simulate field submission
        mobileWidget.onFieldSubmitted?.call('9876543210');
        await tester.pump();

        // Assert - Should handle submission correctly
        expect(find.byType(CustomTextInputField), findsNWidgets(3));
      });

      testWidgets('should handle resend OTP when timer is 0', (WidgetTester tester) async {
        // Arrange
        when(mockBloc.state).thenReturn(
          createTestState(
            isOTPSent: true,
            timeLeft: 0, // Timer expired
            mobileText: '9876543210',
          ),
        );
        when(mockBloc.stream).thenAnswer(
          (_) => Stream.fromIterable([createTestState(isOTPSent: true, timeLeft: 0, mobileText: '9876543210')]),
        );

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Find OTP field and check if resend is available
        final otpField = find.byType(CustomTextInputField).last;
        final otpWidget = tester.widget<CustomTextInputField>(otpField);

        // Assert - Should have suffix icon for resend when timer is 0
        expect(otpWidget.suffixIcon, isNotNull);
      });

      testWidgets('should handle button state validation correctly', (WidgetTester tester) async {
        // Arrange - Test Send OTP button state
        final mobileController = TextEditingController(text: '9876543210');
        final fullnameController = TextEditingController(text: 'John Doe');
        final websiteController = TextEditingController(text: 'https://test.com');

        when(mockBloc.state).thenReturn(
          createTestState(
            mobileController: mobileController,
            fullnameNameController: fullnameController,
            websiteController: websiteController,
            isOTPSent: false,
          ),
        );
        when(mockBloc.stream).thenAnswer(
          (_) => Stream.fromIterable([
            createTestState(
              mobileController: mobileController,
              fullnameNameController: fullnameController,
              websiteController: websiteController,
              isOTPSent: false,
            ),
          ]),
        );

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert - Button should be enabled and have onPressed callback
        final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
        expect(button.isDisabled, isFalse);
        expect(button.onPressed, isNotNull);
      });

      testWidgets('should handle verified state navigation', (WidgetTester tester) async {
        // Arrange - Test verified state with next step navigation
        final state = createTestState(isOTPSent: true, currentStep: PersonalAccountSetupSteps.personalInformation);
        final verifiedState = state.copyWith(isVerifyPersonalRegisterdInfo: true);

        when(mockBloc.state).thenReturn(verifiedState);
        when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([verifiedState]));

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Get button and call onPressed directly to test navigation logic
        final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
        button.onPressed?.call();
        await tester.pump();

        // Assert - Should handle verified state navigation
        expect(find.byType(CommanVerifiedInfoBox), findsOneWidget);
      });
    });
  });
}
