import 'package:exchek/core/enums/app_enums.dart';
import 'package:exchek/widgets/custom_widget/custom_button.dart';
import 'package:exchek/widgets/custom_widget/custom_textfields.dart';
import 'package:exchek/widgets/common_widget/password_checklist_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:exchek/views/account_setup_view/personal_account_setup_view/personal_set_password_view.dart';
import 'package:exchek/viewmodels/account_setup_bloc/personal_account_setup_bloc/personal_account_setup_bloc.dart';
import 'package:exchek/core/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

class MockPersonalAccountSetupBloc extends Mock implements PersonalAccountSetupBloc {}

PersonalAccountSetupState createTestState({
  GlobalKey<FormState>? sePasswordFormKey,
  TextEditingController? passwordController,
  TextEditingController? confirmPasswordController,
  bool obscurePassword = true,
  bool obscureConfirmPassword = true,
  bool? isSignupSuccess = false,
  bool isLoading = false,
  ScrollController? scrollController,
  PersonalAccountSetupSteps currentStep = PersonalAccountSetupSteps.setPassword,
  String? passwordText,
  String? confirmPasswordText,
}) {
  return PersonalAccountSetupState(
    sePasswordFormKey: sePasswordFormKey ?? GlobalKey<FormState>(),
    passwordController: passwordController ?? TextEditingController(text: passwordText),
    confirmPasswordController: confirmPasswordController ?? TextEditingController(text: confirmPasswordText),
    obscurePassword: obscurePassword,
    obscureConfirmPassword: obscureConfirmPassword,
    isSignupSuccess: isSignupSuccess,
    isLoading: isLoading,
    scrollController: scrollController ?? ScrollController(),
    currentStep: currentStep,
    professionOtherController: TextEditingController(),
    productServiceDescriptionController: TextEditingController(),
    personalInfoKey: GlobalKey<FormState>(),
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
    fullNameController: TextEditingController(),
    websiteController: TextEditingController(),
    mobileController: TextEditingController(),
    otpController: TextEditingController(),
    captchaInputController: TextEditingController(),
    familyAndFriendsDescriptionController: TextEditingController(),
    iceVerificationKey: GlobalKey<FormState>(),
    iceNumberController: TextEditingController(),
    personalDbaController: TextEditingController(),
  );
}

void main() {
  group('PersonalSetPasswordView Widget Tests', () {
    late MockPersonalAccountSetupBloc mockBloc;

    setUp(() {
      mockBloc = MockPersonalAccountSetupBloc();

      // Register fallback values for mocktail
      registerFallbackValue(TogglePasswordVisibility());
      registerFallbackValue(ToggleConfirmPasswordVisibility());
      registerFallbackValue(PersonalPasswordSubmitted());
      registerFallbackValue(PersonalResetSignupSuccess());
    });

    Widget createTestWidget() {
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder:
                (context, state) => Scaffold(
                  body: BlocProvider<PersonalAccountSetupBloc>.value(
                    value: mockBloc,
                    child: const PersonalSetPasswordView(),
                  ),
                ),
          ),
          GoRoute(
            path: '/businessaccountsuccess',
            builder: (context, state) => const Scaffold(body: Center(child: Text('Success Page'))),
          ),
        ],
      );

      return MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: const [
          Lang.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: Lang.delegate.supportedLocales,
      );
    }

    testWidgets('should display title and description', (WidgetTester tester) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(
        PersonalAccountSetupState(
          sePasswordFormKey: GlobalKey<FormState>(),
          passwordController: TextEditingController(),
          confirmPasswordController: TextEditingController(),
          obscurePassword: true,
          obscureConfirmPassword: true,
          isSignupSuccess: false,
          isLoading: false,
          scrollController: ScrollController(),
          currentStep: PersonalAccountSetupSteps.setPassword,
          professionOtherController: TextEditingController(),
          productServiceDescriptionController: TextEditingController(),
          personalInfoKey: GlobalKey<FormState>(),
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
          fullNameController: TextEditingController(),
          websiteController: TextEditingController(),
          mobileController: TextEditingController(),
          otpController: TextEditingController(),
          captchaInputController: TextEditingController(),
          familyAndFriendsDescriptionController: TextEditingController(),
          iceVerificationKey: GlobalKey<FormState>(),
          iceNumberController: TextEditingController(),
          personalDbaController: TextEditingController(),
        ),
      );
      when(() => mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          PersonalAccountSetupState(
            sePasswordFormKey: GlobalKey<FormState>(),
            passwordController: TextEditingController(),
            confirmPasswordController: TextEditingController(),
            obscurePassword: true,
            obscureConfirmPassword: true,
            isSignupSuccess: false,
            isLoading: false,
            scrollController: ScrollController(),
            currentStep: PersonalAccountSetupSteps.setPassword,
            professionOtherController: TextEditingController(),
            productServiceDescriptionController: TextEditingController(),
            personalInfoKey: GlobalKey<FormState>(),
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
            fullNameController: TextEditingController(),
            websiteController: TextEditingController(),
            mobileController: TextEditingController(),
            otpController: TextEditingController(),
            captchaInputController: TextEditingController(),
            familyAndFriendsDescriptionController: TextEditingController(),
            iceVerificationKey: GlobalKey<FormState>(),
            iceNumberController: TextEditingController(),
            personalDbaController: TextEditingController(),
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.textContaining('Create a strong password'), findsOneWidget);
      expect(find.textContaining('secure handling of your incoming funds'), findsOneWidget);
    });

    testWidgets('should display password fields', (WidgetTester tester) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(createTestState());
      when(() => mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.textContaining('Create password'), findsOneWidget);
      expect(find.textContaining('Confirm Password'), findsOneWidget);
      expect(find.byType(CustomTextInputField), findsNWidgets(2));
    });

    testWidgets('should display password checklist when password is entered', (WidgetTester tester) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(createTestState(passwordText: 'Test123!'));
      when(() => mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState(passwordText: 'Test123!')]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(PasswordChecklistItem), findsNWidgets(5));
      expect(find.textContaining('One lowercase character'), findsOneWidget);
      expect(find.textContaining('One number'), findsOneWidget);
      expect(find.textContaining('One uppercase character'), findsOneWidget);
      expect(find.textContaining('One special character'), findsOneWidget);
      expect(find.textContaining('8 characters minimum'), findsOneWidget);
    });

    testWidgets('should not display password checklist when password is empty', (WidgetTester tester) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(createTestState());
      when(() => mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(PasswordChecklistItem), findsNothing);
    });

    testWidgets('should display Sign Up button', (WidgetTester tester) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(createTestState());
      when(() => mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.byType(CustomElevatedButton), findsOneWidget);
    });

    testWidgets('should disable Sign Up button when fields are empty', (WidgetTester tester) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(createTestState());
      when(() => mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
      expect(button.isDisabled, isTrue);
    });

    testWidgets('should enable Sign Up button when both fields are filled', (WidgetTester tester) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(createTestState(passwordText: 'Test123!', confirmPasswordText: 'Test123!'));
      when(() => mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([createTestState(passwordText: 'Test123!', confirmPasswordText: 'Test123!')]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
      expect(button.isDisabled, isFalse);
    });

    testWidgets('should show loading state when signup is loading', (WidgetTester tester) async {
      // Arrange
      when(
        () => mockBloc.state,
      ).thenReturn(createTestState(passwordText: 'Test123!', confirmPasswordText: 'Test123!', isLoading: true));
      when(() => mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(passwordText: 'Test123!', confirmPasswordText: 'Test123!', isLoading: true),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
      expect(button.isLoading, isTrue);
    });

    testWidgets('should toggle password visibility when eye icon tapped', (WidgetTester tester) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(createTestState());
      when(() => mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      await tester.tap(find.byType(GestureDetector).first);

      // Assert
      verify(() => mockBloc.add(any<TogglePasswordVisibility>())).called(1);
    });

    testWidgets('should have enabled Sign Up button when both fields are filled', (WidgetTester tester) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(createTestState(passwordText: 'Test123!', confirmPasswordText: 'Test123!'));
      when(() => mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([createTestState(passwordText: 'Test123!', confirmPasswordText: 'Test123!')]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - Verify button is enabled and can be tapped
      final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
      expect(button.isDisabled, isFalse);
      expect(button.onPressed, isNotNull);
    });

    testWidgets('should navigate to success page when signup is successful', (WidgetTester tester) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(createTestState(isSignupSuccess: true));
      when(() => mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState(isSignupSuccess: true)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      verify(() => mockBloc.add(any<PersonalResetSignupSuccess>())).called(1);
    });

    testWidgets('should display tooltip on Sign Up button', (WidgetTester tester) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(createTestState(passwordText: 'Test123!', confirmPasswordText: 'Test123!'));
      when(() => mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([createTestState(passwordText: 'Test123!', confirmPasswordText: 'Test123!')]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
      expect(button.isShowTooltip, isTrue);
    });
  });
}
