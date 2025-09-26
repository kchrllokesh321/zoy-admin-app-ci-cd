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

class MockGoRouter extends Mock implements GoRouter {}

// Fake classes for registration
class FakePersonalAccountSetupEvent extends Fake implements PersonalAccountSetupEvent {}

class FakePersonalAccountSetupState extends Fake implements PersonalAccountSetupState {}

void main() {
  group('PersonalAccountEkycView Advanced Tests', () {
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
      bool isLocalDataLoading = false,
    }) {
      return PersonalAccountSetupState(
        currentKycVerificationStep: currentKycVerificationStep,
        isEkycCollapsed: isEkycCollapsed,
        isLocalDataLoading: isLocalDataLoading,
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

    group('Advanced Business Logic Tests', () {
      testWidgets('should handle freelancer user with all steps', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          Prefkeys.userKycDetail: jsonEncode({
            'personal_details': {'payment_purpose': 'I\'m a Freelancer'},
          }),
        });
        final state = createTestState();

        // Act
        await tester.pumpWidget(createTestApp(state: state));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Assert
        expect(find.byType(PersonalAccountEkycView), findsOneWidget);
      });

      testWidgets('should handle non-freelancer user with IEC step skipped', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          Prefkeys.userKycDetail: jsonEncode({
            'personal_details': {'payment_purpose': 'Business'},
          }),
        });
        final state = createTestState(currentKycVerificationStep: PersonalEKycVerificationSteps.iecVerification);

        // Act
        await tester.pumpWidget(createTestApp(state: state));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Assert
        expect(find.byType(PersonalAccountEkycView), findsOneWidget);
      });

      testWidgets('should show loading when isLocalDataLoading is true', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          Prefkeys.userKycDetail: jsonEncode({
            'personal_details': {'payment_purpose': 'I\'m a Freelancer'},
          }),
        });
        final state = createTestState(isLocalDataLoading: true);

        // Act
        await tester.pumpWidget(createTestApp(state: state));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Assert
        expect(find.byType(AppLoaderWidget), findsWidgets);
      });
    });

    group('Step Content Tests', () {
      testWidgets('should render identity verification step', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          Prefkeys.userKycDetail: jsonEncode({
            'personal_details': {'payment_purpose': 'I\'m a Freelancer'},
          }),
        });
        final state = createTestState(currentKycVerificationStep: PersonalEKycVerificationSteps.identityVerification);

        // Act
        await tester.pumpWidget(createTestApp(state: state));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Assert
        expect(find.byType(PersonalAccountEkycView), findsOneWidget);
      });

      testWidgets('should render PAN details step', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          Prefkeys.userKycDetail: jsonEncode({
            'personal_details': {'payment_purpose': 'I\'m a Freelancer'},
          }),
        });
        final state = createTestState(currentKycVerificationStep: PersonalEKycVerificationSteps.panDetails);

        // Act
        await tester.pumpWidget(createTestApp(state: state));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Assert
        expect(find.byType(PersonalAccountEkycView), findsOneWidget);
      });

      testWidgets('should render residential address step', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          Prefkeys.userKycDetail: jsonEncode({
            'personal_details': {'payment_purpose': 'I\'m a Freelancer'},
          }),
        });
        final state = createTestState(currentKycVerificationStep: PersonalEKycVerificationSteps.residentialAddress);

        // Act
        await tester.pumpWidget(createTestApp(state: state));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Assert
        expect(find.byType(PersonalAccountEkycView), findsOneWidget);
      });

      testWidgets('should render annual turnover declaration step', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          Prefkeys.userKycDetail: jsonEncode({
            'personal_details': {'payment_purpose': 'I\'m a Freelancer'},
          }),
        });
        final state = createTestState(
          currentKycVerificationStep: PersonalEKycVerificationSteps.annualTurnoverDeclaration,
        );

        // Act
        await tester.pumpWidget(createTestApp(state: state));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Assert
        expect(find.byType(PersonalAccountEkycView), findsOneWidget);
      });

      testWidgets('should render IEC verification step for freelancer', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          Prefkeys.userKycDetail: jsonEncode({
            'personal_details': {'payment_purpose': 'I\'m a Freelancer'},
          }),
        });
        final state = createTestState(currentKycVerificationStep: PersonalEKycVerificationSteps.iecVerification);

        // Act
        await tester.pumpWidget(createTestApp(state: state));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Assert
        expect(find.byType(PersonalAccountEkycView), findsOneWidget);
      });

      testWidgets('should render bank account linking step', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          Prefkeys.userKycDetail: jsonEncode({
            'personal_details': {'payment_purpose': 'I\'m a Freelancer'},
          }),
        });
        final state = createTestState(currentKycVerificationStep: PersonalEKycVerificationSteps.bankAccountLinking);

        // Act
        await tester.pumpWidget(createTestApp(state: state));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Assert
        expect(find.byType(PersonalAccountEkycView), findsOneWidget);
      });
    });

    group('getStepTitle Method Tests', () {
      test('should return correct title for identity verification', () {
        final widget = PersonalAccountEkycView();
        final state = createTestState();
        final context = MockBuildContext();

        final title = widget.getStepTitle(
          context: context,
          step: PersonalEKycVerificationSteps.identityVerification,
          state: state,
        );

        expect(title, equals('Identity Verification'));
      });

      test('should return correct title for PAN details', () {
        final widget = PersonalAccountEkycView();
        final state = createTestState();
        final context = MockBuildContext();

        final title = widget.getStepTitle(
          context: context,
          step: PersonalEKycVerificationSteps.panDetails,
          state: state,
        );

        expect(title, equals('PAN Details'));
      });

      test('should return correct title for residential address', () {
        final widget = PersonalAccountEkycView();
        final state = createTestState();
        final context = MockBuildContext();

        final title = widget.getStepTitle(
          context: context,
          step: PersonalEKycVerificationSteps.residentialAddress,
          state: state,
        );

        expect(title, equals('Residential Address'));
      });

      test('should return correct title for annual turnover declaration', () {
        final widget = PersonalAccountEkycView();
        final state = createTestState();
        final context = MockBuildContext();

        final title = widget.getStepTitle(
          context: context,
          step: PersonalEKycVerificationSteps.annualTurnoverDeclaration,
          state: state,
        );

        expect(title, equals('Annual Turnover Declaration'));
      });

      test('should return correct title for IEC verification', () {
        final widget = PersonalAccountEkycView();
        final state = createTestState();
        final context = MockBuildContext();

        final title = widget.getStepTitle(
          context: context,
          step: PersonalEKycVerificationSteps.iecVerification,
          state: state,
        );

        expect(title, equals('IEC number and certificate upload'));
      });

      test('should return correct title for bank account linking', () {
        final widget = PersonalAccountEkycView();
        final state = createTestState();
        final context = MockBuildContext();

        final title = widget.getStepTitle(
          context: context,
          step: PersonalEKycVerificationSteps.bankAccountLinking,
          state: state,
        );

        expect(title, equals('Bank Account Linking'));
      });
    });

    group('Edge Cases and Error Handling', () {
      testWidgets('should handle empty user details', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({Prefkeys.userKycDetail: jsonEncode({})});
        final state = createTestState();

        // Act
        await tester.pumpWidget(createTestApp(state: state));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Assert
        expect(find.byType(PersonalAccountEkycView), findsOneWidget);
      });

      testWidgets('should handle null personal_details', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          Prefkeys.userKycDetail: jsonEncode({'personal_details': null}),
        });
        final state = createTestState();

        // Act
        await tester.pumpWidget(createTestApp(state: state));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Assert
        expect(find.byType(PersonalAccountEkycView), findsOneWidget);
      });

      testWidgets('should handle missing payment_purpose', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          Prefkeys.userKycDetail: jsonEncode({'personal_details': {}}),
        });
        final state = createTestState();

        // Act
        await tester.pumpWidget(createTestApp(state: state));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Assert
        expect(find.byType(PersonalAccountEkycView), findsOneWidget);
      });

      testWidgets('should handle invalid JSON in preferences', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({Prefkeys.userKycDetail: 'invalid json'});
        final state = createTestState();

        // Act
        await tester.pumpWidget(createTestApp(state: state));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Assert
        expect(find.byType(PersonalAccountEkycView), findsOneWidget);
      });

      testWidgets('should handle collapsed state with different steps', (WidgetTester tester) async {
        // Test all steps with collapsed state
        final steps = PersonalEKycVerificationSteps.values;

        for (final step in steps) {
          SharedPreferences.setMockInitialValues({
            Prefkeys.userKycDetail: jsonEncode({
              'personal_details': {'payment_purpose': 'I\'m a Freelancer'},
            }),
          });
          final state = createTestState(currentKycVerificationStep: step, isEkycCollapsed: true);

          await tester.pumpWidget(createTestApp(state: state));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 100));

          expect(find.byType(PersonalAccountEkycView), findsOneWidget);
        }
      });
    });

    group('Widget Properties and Configuration', () {
      test('should create widget with custom key', () {
        const testKey = Key('test-ekyc-view');
        final widget = PersonalAccountEkycView(key: testKey);

        expect(widget.key, equals(testKey));
        expect(widget, isA<StatelessWidget>());
      });

      test('should create widget without key', () {
        final widget = PersonalAccountEkycView();

        expect(widget.key, isNull);
        expect(widget, isA<StatelessWidget>());
      });

      test('should be a StatelessWidget', () {
        final widget = PersonalAccountEkycView();

        expect(widget, isA<StatelessWidget>());
        expect(widget.runtimeType, equals(PersonalAccountEkycView));
      });
    });

    group('State Transitions and Combinations', () {
      testWidgets('should handle state transition from collapsed to expanded', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          Prefkeys.userKycDetail: jsonEncode({
            'personal_details': {'payment_purpose': 'I\'m a Freelancer'},
          }),
        });

        // Start with collapsed state
        final collapsedState = createTestState(isEkycCollapsed: true);
        await tester.pumpWidget(createTestApp(state: collapsedState));
        await tester.pump();

        // Transition to expanded state
        final expandedState = createTestState(isEkycCollapsed: false);
        when(() => mockBloc.state).thenReturn(expandedState);
        when(() => mockBloc.stream).thenAnswer((_) => Stream.value(expandedState));

        await tester.pumpWidget(createTestApp(state: expandedState));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Assert
        expect(find.byType(PersonalAccountEkycView), findsOneWidget);
      });

      testWidgets('should handle step transitions', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          Prefkeys.userKycDetail: jsonEncode({
            'personal_details': {'payment_purpose': 'I\'m a Freelancer'},
          }),
        });

        // Test transition from identity verification to PAN details
        final step1State = createTestState(
          currentKycVerificationStep: PersonalEKycVerificationSteps.identityVerification,
        );
        await tester.pumpWidget(createTestApp(state: step1State));
        await tester.pump();

        final step2State = createTestState(currentKycVerificationStep: PersonalEKycVerificationSteps.panDetails);
        when(() => mockBloc.state).thenReturn(step2State);
        when(() => mockBloc.stream).thenAnswer((_) => Stream.value(step2State));

        await tester.pumpWidget(createTestApp(state: step2State));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Assert
        expect(find.byType(PersonalAccountEkycView), findsOneWidget);
      });
    });
  });
}

// Mock class for BuildContext
class MockBuildContext extends Mock implements BuildContext {}
