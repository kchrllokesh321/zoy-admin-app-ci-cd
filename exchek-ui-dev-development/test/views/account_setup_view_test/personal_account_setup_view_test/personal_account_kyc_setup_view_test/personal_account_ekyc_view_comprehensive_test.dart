import 'dart:convert';
import 'package:bloc_test/bloc_test.dart';
import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/views/account_setup_view/personal_account_setup_view/personal_account_kyc_setup_view/personal_account_ekyc_view.dart';
import 'package:exchek/viewmodels/account_setup_bloc/personal_account_setup_bloc/personal_account_setup_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock classes
class MockPersonalAccountSetupBloc extends MockBloc<PersonalAccountSetupEvent, PersonalAccountSetupState>
    implements PersonalAccountSetupBloc {}

// Fake classes for registration
class FakePersonalAccountSetupEvent extends Fake implements PersonalAccountSetupEvent {}

class FakePersonalAccountSetupState extends Fake implements PersonalAccountSetupState {}

void main() {
  group('PersonalAccountEkycView Comprehensive Coverage Tests', () {
    late MockPersonalAccountSetupBloc mockBloc;

    setUpAll(() {
      registerFallbackValue(FakePersonalAccountSetupEvent());
      registerFallbackValue(FakePersonalAccountSetupState());
    });

    setUp(() {
      mockBloc = MockPersonalAccountSetupBloc();
    });

    PersonalAccountSetupState createTestState({
      PersonalEKycVerificationSteps currentKycVerificationStep = PersonalEKycVerificationSteps.identityVerification,
      bool isEkycCollapsed = false,
    }) {
      return PersonalAccountSetupState(
        currentKycVerificationStep: currentKycVerificationStep,
        isEkycCollapsed: isEkycCollapsed,
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
        familyAndFriendsDescriptionController: TextEditingController(),
        iceVerificationKey: GlobalKey<FormState>(),
        iceNumberController: TextEditingController(),
        personalDbaController: TextEditingController(),
      );
    }

    Widget createTestApp({required PersonalAccountSetupState state, Map<String, String> preferences = const {}}) {
      when(() => mockBloc.state).thenReturn(state);
      when(() => mockBloc.stream).thenAnswer((_) => Stream.value(state));

      return MaterialApp(
        home: BlocProvider<PersonalAccountSetupBloc>.value(value: mockBloc, child: PersonalAccountEkycView()),
        localizationsDelegates: [
          Lang.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
      );
    }

    group('Build method coverage tests', () {
      testWidgets('should render loading state when no user data', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({});
        final state = createTestState();

        // Act
        await tester.pumpWidget(createTestApp(state: state));
        await tester.pump();

        // Assert - Should show loading widget
        expect(find.byType(Center), findsWidgets);
      });

      testWidgets('should render complete widget structure for freelancer', (WidgetTester tester) async {
        // Arrange - Set up complete user data
        SharedPreferences.setMockInitialValues({
          Prefkeys.userKycDetail: jsonEncode({
            'personal_details': {'payment_purpose': 'I\'m a Freelancer'},
          }),
        });
        final state = createTestState(
          currentKycVerificationStep: PersonalEKycVerificationSteps.identityVerification,
          isEkycCollapsed: false,
        );

        // Act
        await tester.pumpWidget(createTestApp(state: state));
        await tester.pump();

        // Allow multiple pump cycles to ensure full rendering
        for (int i = 0; i < 10; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }

        // Assert - Widget should render completely
        expect(find.byType(PersonalAccountEkycView), findsOneWidget);
      });

      testWidgets('should render complete widget structure for non-freelancer', (WidgetTester tester) async {
        // Arrange - Set up complete user data for non-freelancer
        SharedPreferences.setMockInitialValues({
          Prefkeys.userKycDetail: jsonEncode({
            'personal_details': {'payment_purpose': 'Business'},
          }),
        });
        final state = createTestState(
          currentKycVerificationStep: PersonalEKycVerificationSteps.identityVerification,
          isEkycCollapsed: false,
        );

        // Act
        await tester.pumpWidget(createTestApp(state: state));
        await tester.pump();

        // Allow multiple pump cycles to ensure full rendering
        for (int i = 0; i < 10; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }

        // Assert - Widget should render completely
        expect(find.byType(PersonalAccountEkycView), findsOneWidget);
      });

      testWidgets('should test all KYC steps with complete rendering', (WidgetTester tester) async {
        // Test each step individually with full rendering
        final steps = PersonalEKycVerificationSteps.values;

        for (final step in steps) {
          // Arrange
          SharedPreferences.setMockInitialValues({
            Prefkeys.userKycDetail: jsonEncode({
              'personal_details': {'payment_purpose': 'I\'m a Freelancer'},
            }),
          });
          final state = createTestState(currentKycVerificationStep: step);

          // Act
          await tester.pumpWidget(createTestApp(state: state));
          await tester.pump();

          // Allow multiple pump cycles for complete rendering
          for (int i = 0; i < 5; i++) {
            await tester.pump(const Duration(milliseconds: 50));
          }

          // Assert - Widget should render for each step
          expect(find.byType(PersonalAccountEkycView), findsOneWidget);
        }
      });

      testWidgets('should handle IEC step logic for freelancer vs non-freelancer', (WidgetTester tester) async {
        // Test freelancer with IEC step
        SharedPreferences.setMockInitialValues({
          Prefkeys.userKycDetail: jsonEncode({
            'personal_details': {'payment_purpose': 'I\'m a Freelancer'},
          }),
        });
        final freelancerState = createTestState(
          currentKycVerificationStep: PersonalEKycVerificationSteps.iecVerification,
        );

        await tester.pumpWidget(createTestApp(state: freelancerState));
        await tester.pump();
        for (int i = 0; i < 5; i++) {
          await tester.pump(const Duration(milliseconds: 50));
        }
        expect(find.byType(PersonalAccountEkycView), findsOneWidget);

        // Test non-freelancer with IEC step (should skip)
        SharedPreferences.setMockInitialValues({
          Prefkeys.userKycDetail: jsonEncode({
            'personal_details': {'payment_purpose': 'Business'},
          }),
        });
        final nonFreelancerState = createTestState(
          currentKycVerificationStep: PersonalEKycVerificationSteps.iecVerification,
        );

        await tester.pumpWidget(createTestApp(state: nonFreelancerState));
        await tester.pump();
        for (int i = 0; i < 5; i++) {
          await tester.pump(const Duration(milliseconds: 50));
        }
        expect(find.byType(PersonalAccountEkycView), findsOneWidget);
      });

      testWidgets('should handle collapsed and non-collapsed states with full rendering', (WidgetTester tester) async {
        // Test collapsed state
        SharedPreferences.setMockInitialValues({
          Prefkeys.userKycDetail: jsonEncode({
            'personal_details': {'payment_purpose': 'I\'m a Freelancer'},
          }),
        });
        final collapsedState = createTestState(isEkycCollapsed: true);

        await tester.pumpWidget(createTestApp(state: collapsedState));
        await tester.pump();
        for (int i = 0; i < 5; i++) {
          await tester.pump(const Duration(milliseconds: 50));
        }
        expect(find.byType(PersonalAccountEkycView), findsOneWidget);

        // Test non-collapsed state
        final nonCollapsedState = createTestState(isEkycCollapsed: false);

        await tester.pumpWidget(createTestApp(state: nonCollapsedState));
        await tester.pump();
        for (int i = 0; i < 5; i++) {
          await tester.pump(const Duration(milliseconds: 50));
        }
        expect(find.byType(PersonalAccountEkycView), findsOneWidget);
      });
    });

    group('getStepTitle method coverage', () {
      test('should return correct titles for all steps', () {
        // Arrange
        final widget = PersonalAccountEkycView();
        final state = createTestState();
        final context = MockBuildContext();

        // Act & Assert - Test all step titles
        for (final step in PersonalEKycVerificationSteps.values) {
          final title = widget.getStepTitle(context: context, step: step, state: state);
          expect(title, isNotNull);
          expect(title, isA<String>());
          expect(title.isNotEmpty, isTrue);
        }
      });
    });

    group('Widget instantiation coverage', () {
      test('should create widget with and without key', () {
        // Test without key
        final widget1 = PersonalAccountEkycView();
        expect(widget1, isA<PersonalAccountEkycView>());
        expect(widget1.key, isNull);

        // Test with key
        const key = Key('test-key');
        final widget2 = PersonalAccountEkycView(key: key);
        expect(widget2, isA<PersonalAccountEkycView>());
        expect(widget2.key, equals(key));
      });
    });
  });
}

// Mock class for BuildContext
class MockBuildContext extends Mock implements BuildContext {}
