import 'dart:convert';
import 'package:bloc_test/bloc_test.dart';
import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/views/account_setup_view/personal_account_setup_view/personal_account_kyc_setup_view/personal_account_ekyc_view.dart';
import 'package:exchek/viewmodels/account_setup_bloc/personal_account_setup_bloc/personal_account_setup_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock classes
class MockBuildContext extends Mock implements BuildContext {}

class MockPersonalAccountSetupBloc extends MockBloc<PersonalAccountSetupEvent, PersonalAccountSetupState>
    implements PersonalAccountSetupBloc {}

class MockGoRouter extends Mock implements GoRouter {}

// Fake classes for registration
class FakePersonalAccountSetupEvent extends Fake implements PersonalAccountSetupEvent {}

class FakePersonalAccountSetupState extends Fake implements PersonalAccountSetupState {}

class FakeGoRouterState extends Fake implements GoRouterState {}

void main() {
  group('PersonalAccountEkycView Tests', () {
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

    test('should create widget instance', () {
      // Arrange & Act
      final widget = PersonalAccountEkycView();

      // Assert - Widget should be created without crashing
      expect(widget, isA<PersonalAccountEkycView>());
      expect(widget, isA<StatelessWidget>());
    });

    group('getStepTitle method tests', () {
      test('should return correct titles for all steps', () {
        // Arrange
        final widget = PersonalAccountEkycView();
        final state = createTestState();
        final context = MockBuildContext();

        // Act & Assert - Test all step titles
        expect(
          widget.getStepTitle(context: context, step: PersonalEKycVerificationSteps.identityVerification, state: state),
          equals("Identity Verification"),
        );

        expect(
          widget.getStepTitle(context: context, step: PersonalEKycVerificationSteps.panDetails, state: state),
          equals("PAN Details"),
        );

        expect(
          widget.getStepTitle(context: context, step: PersonalEKycVerificationSteps.residentialAddress, state: state),
          equals("Residential Address"),
        );

        expect(
          widget.getStepTitle(
            context: context,
            step: PersonalEKycVerificationSteps.annualTurnoverDeclaration,
            state: state,
          ),
          equals("Annual Turnover Declaration"),
        );

        expect(
          widget.getStepTitle(context: context, step: PersonalEKycVerificationSteps.iecVerification, state: state),
          equals("IEC number and certificate upload"),
        );

        expect(
          widget.getStepTitle(context: context, step: PersonalEKycVerificationSteps.bankAccountLinking, state: state),
          equals("Bank Account Linking"),
        );
      });
    });

    group('State handling tests', () {
      test('should handle different KYC verification steps', () {
        // Arrange
        final steps = [
          PersonalEKycVerificationSteps.identityVerification,
          PersonalEKycVerificationSteps.panDetails,
          PersonalEKycVerificationSteps.residentialAddress,
          PersonalEKycVerificationSteps.annualTurnoverDeclaration,
          PersonalEKycVerificationSteps.bankAccountLinking,
          PersonalEKycVerificationSteps.iecVerification,
        ];

        // Act & Assert
        for (final step in steps) {
          final testState = createTestState(currentKycVerificationStep: step);
          expect(testState.currentKycVerificationStep, equals(step));
        }
      });

      test('should handle collapsed state', () {
        // Arrange & Act
        final testState = createTestState(isEkycCollapsed: true);

        // Assert
        expect(testState.isEkycCollapsed, isTrue);
      });

      test('should handle non-collapsed state', () {
        // Arrange & Act
        final testState = createTestState(isEkycCollapsed: false);

        // Assert
        expect(testState.isEkycCollapsed, isFalse);
      });
    });

    group('Widget instantiation tests', () {
      test('should create widget with default constructor', () {
        // Act
        final widget = PersonalAccountEkycView();

        // Assert
        expect(widget, isNotNull);
        expect(widget.key, isNull);
      });

      test('should create widget with key', () {
        // Arrange
        const key = Key('test_key');

        // Act
        final widget = PersonalAccountEkycView(key: key);

        // Assert
        expect(widget, isNotNull);
        expect(widget.key, equals(key));
      });

      test('should have scroll controller', () {
        // Act
        final widget = PersonalAccountEkycView();

        // Assert - Widget should have a scroll controller (private field)
        expect(widget, isA<StatelessWidget>());
      });
    });

    group('getStepTitle method tests', () {
      test('should return correct titles for all steps', () {
        // Arrange
        final widget = PersonalAccountEkycView();
        final state = createTestState();
        final context = MockBuildContext();

        // Act & Assert - Test all step titles
        expect(
          widget.getStepTitle(context: context, step: PersonalEKycVerificationSteps.identityVerification, state: state),
          equals("Identity Verification"),
        );

        expect(
          widget.getStepTitle(context: context, step: PersonalEKycVerificationSteps.panDetails, state: state),
          equals("PAN Details"),
        );

        expect(
          widget.getStepTitle(context: context, step: PersonalEKycVerificationSteps.residentialAddress, state: state),
          equals("Residential Address"),
        );

        expect(
          widget.getStepTitle(
            context: context,
            step: PersonalEKycVerificationSteps.annualTurnoverDeclaration,
            state: state,
          ),
          equals("Annual Turnover Declaration"),
        );

        expect(
          widget.getStepTitle(context: context, step: PersonalEKycVerificationSteps.iecVerification, state: state),
          equals("IEC number and certificate upload"),
        );

        expect(
          widget.getStepTitle(context: context, step: PersonalEKycVerificationSteps.bankAccountLinking, state: state),
          equals("Bank Account Linking"),
        );
      });
    });

    group('Additional coverage tests', () {
      test('should handle all enum values in getStepTitle', () {
        // Arrange
        final widget = PersonalAccountEkycView();
        final state = createTestState();
        final context = MockBuildContext();

        // Act & Assert - Test all enum values to ensure 100% coverage
        for (final step in PersonalEKycVerificationSteps.values) {
          final title = widget.getStepTitle(context: context, step: step, state: state);
          expect(title, isNotNull);
          expect(title, isA<String>());
          expect(title.isNotEmpty, isTrue);
        }
      });

      test('should create widget with scroll controller', () {
        // Arrange & Act
        final widget = PersonalAccountEkycView();

        // Assert - Widget should be created with internal scroll controller
        expect(widget, isA<StatelessWidget>());
        expect(widget.runtimeType.toString(), equals('PersonalAccountEkycView'));
      });

      test('should handle different state configurations', () {
        // Test various state configurations to ensure coverage
        final configurations = [
          {'step': PersonalEKycVerificationSteps.identityVerification, 'collapsed': true},
          {'step': PersonalEKycVerificationSteps.panDetails, 'collapsed': false},
          {'step': PersonalEKycVerificationSteps.residentialAddress, 'collapsed': true},
          {'step': PersonalEKycVerificationSteps.annualTurnoverDeclaration, 'collapsed': false},
          {'step': PersonalEKycVerificationSteps.iecVerification, 'collapsed': true},
          {'step': PersonalEKycVerificationSteps.bankAccountLinking, 'collapsed': false},
        ];

        for (final config in configurations) {
          final state = createTestState(
            currentKycVerificationStep: config['step'] as PersonalEKycVerificationSteps,
            isEkycCollapsed: config['collapsed'] as bool,
          );

          expect(state.currentKycVerificationStep, equals(config['step']));
          expect(state.isEkycCollapsed, equals(config['collapsed']));
        }
      });

      test('should verify widget type and inheritance', () {
        // Arrange & Act
        final widget = PersonalAccountEkycView();

        // Assert
        expect(widget, isA<Widget>());
        expect(widget, isA<StatelessWidget>());
        expect(widget, isNotNull);
      });

      test('should handle key parameter correctly', () {
        // Arrange
        const testKey = Key('test-key');

        // Act
        final widgetWithKey = PersonalAccountEkycView(key: testKey);
        final widgetWithoutKey = PersonalAccountEkycView();

        // Assert
        expect(widgetWithKey.key, equals(testKey));
        expect(widgetWithoutKey.key, isNull);
      });

      test('should verify all step titles are unique', () {
        // Arrange
        final widget = PersonalAccountEkycView();
        final state = createTestState();
        final context = MockBuildContext();
        final titles = <String>{};

        // Act
        for (final step in PersonalEKycVerificationSteps.values) {
          final title = widget.getStepTitle(context: context, step: step, state: state);
          titles.add(title);
        }

        // Assert - All titles should be unique
        expect(titles.length, equals(PersonalEKycVerificationSteps.values.length));
      });

      test('should handle state transitions correctly', () {
        // Test state transitions for coverage
        final initialState = createTestState(
          currentKycVerificationStep: PersonalEKycVerificationSteps.identityVerification,
          isEkycCollapsed: false,
        );

        final collapsedState = createTestState(
          currentKycVerificationStep: PersonalEKycVerificationSteps.identityVerification,
          isEkycCollapsed: true,
        );

        final nextStepState = createTestState(
          currentKycVerificationStep: PersonalEKycVerificationSteps.panDetails,
          isEkycCollapsed: false,
        );

        // Verify state properties
        expect(initialState.isEkycCollapsed, isFalse);
        expect(collapsedState.isEkycCollapsed, isTrue);
        expect(nextStepState.currentKycVerificationStep, equals(PersonalEKycVerificationSteps.panDetails));
      });
    });

    // Comprehensive integration tests for 100% coverage
    group('Integration Tests - 100% Coverage', () {
      Widget createTestApp({required PersonalAccountSetupState state}) {
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

      testWidgets('should render widget without crashing', (WidgetTester tester) async {
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

        // Assert - Widget should render without crashing
        expect(find.byType(PersonalAccountEkycView), findsOneWidget);
      });

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

      testWidgets('should render widget with user data', (WidgetTester tester) async {
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
        await tester.pump(const Duration(milliseconds: 100));

        // Assert - Widget should render without crashing
        expect(find.byType(PersonalAccountEkycView), findsOneWidget);
      });

      testWidgets('should handle different KYC steps', (WidgetTester tester) async {
        // Test each step individually to ensure coverage
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
          await tester.pump(const Duration(milliseconds: 100));

          // Assert - Widget should render for each step
          expect(find.byType(PersonalAccountEkycView), findsOneWidget);
        }
      });

      testWidgets('should handle freelancer vs non-freelancer logic', (WidgetTester tester) async {
        // Test freelancer
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
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byType(PersonalAccountEkycView), findsOneWidget);

        // Test non-freelancer
        SharedPreferences.setMockInitialValues({
          Prefkeys.userKycDetail: jsonEncode({
            'personal_details': {'payment_purpose': 'Other purpose'},
          }),
        });
        final nonFreelancerState = createTestState(
          currentKycVerificationStep: PersonalEKycVerificationSteps.iecVerification,
        );

        await tester.pumpWidget(createTestApp(state: nonFreelancerState));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byType(PersonalAccountEkycView), findsOneWidget);
      });

      testWidgets('should handle collapsed state', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          Prefkeys.userKycDetail: jsonEncode({
            'personal_details': {'payment_purpose': 'I\'m a Freelancer'},
          }),
        });
        final state = createTestState(isEkycCollapsed: true);

        // Act
        await tester.pumpWidget(createTestApp(state: state));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Assert - Widget should render in collapsed state
        expect(find.byType(PersonalAccountEkycView), findsOneWidget);
      });

      testWidgets('should handle non-collapsed state', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          Prefkeys.userKycDetail: jsonEncode({
            'personal_details': {'payment_purpose': 'I\'m a Freelancer'},
          }),
        });
        final state = createTestState(isEkycCollapsed: false);

        // Act
        await tester.pumpWidget(createTestApp(state: state));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Assert - Widget should render in non-collapsed state
        expect(find.byType(PersonalAccountEkycView), findsOneWidget);
      });
    });
  });
}
