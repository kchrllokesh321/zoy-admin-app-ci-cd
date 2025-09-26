import 'package:exchek/core/enums/app_enums.dart';
import 'package:exchek/core/responsive_helper/responsive_scaffold.dart';
import 'package:exchek/views/account_setup_view/personal_account_setup_view/personal_entity_selection_view.dart';
import 'package:exchek/views/account_setup_view/personal_account_setup_view/personal_information_view.dart';
import 'package:exchek/views/account_setup_view/personal_account_setup_view/personal_set_password_view.dart';
import 'package:exchek/views/account_setup_view/personal_account_setup_view/personal_transaction_payment_reference_view.dart';
import 'package:exchek/widgets/account_setup_widgets/stepper_slider.dart';
import 'package:exchek/widgets/common_widget/app_bar.dart';
import 'package:exchek/widgets/common_widget/app_loader_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:go_router/go_router.dart';
import 'package:exchek/views/account_setup_view/personal_account_setup_view/personal_account_setup_view.dart';
import 'package:exchek/viewmodels/account_setup_bloc/personal_account_setup_bloc/personal_account_setup_bloc.dart';
import 'package:exchek/viewmodels/account_setup_bloc/account_type_selection/account_type_selection_bloc.dart';
import 'package:exchek/core/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MockPersonalAccountSetupBloc extends Mock implements PersonalAccountSetupBloc {}

class MockAccountTypeBloc extends Mock implements AccountTypeBloc {}

PersonalAccountSetupState createMockPersonalAccountSetupState({
  PersonalAccountSetupSteps currentStep = PersonalAccountSetupSteps.personalEntity,
  bool isCollapsed = false,
}) {
  return PersonalAccountSetupState(
    currentStep: currentStep,
    scrollController: ScrollController(),
    isCollapsed: isCollapsed,
    professionOtherController: TextEditingController(),
    productServiceDescriptionController: TextEditingController(),
    passwordController: TextEditingController(),
    confirmPasswordController: TextEditingController(),
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
    sePasswordFormKey: GlobalKey<FormState>(),
    captchaInputController: TextEditingController(),
    familyAndFriendsDescriptionController: TextEditingController(),
    iceVerificationKey: GlobalKey<FormState>(),
    iceNumberController: TextEditingController(),
    personalDbaController: TextEditingController(),
  );
}

void main() {
  group('PersonalAccountSetupContent Widget Tests', () {
    late MockPersonalAccountSetupBloc mockPersonalAccountSetupBloc;
    late MockAccountTypeBloc mockAccountTypeBloc;

    setUp(() {
      mockPersonalAccountSetupBloc = MockPersonalAccountSetupBloc();
      mockAccountTypeBloc = MockAccountTypeBloc();

      // Register fallback values for mocktail
      registerFallbackValue(PersonalResetData());
      registerFallbackValue(PersonalInfoStepChanged(PersonalAccountSetupSteps.personalEntity));
      registerFallbackValue(PersonalAppBarCollapseChanged(false));
    });

    Widget createTestWidget({Size? screenSize}) {
      final router = GoRouter(
        initialLocation: '/personal-setup',
        routes: [
          GoRoute(path: '/', builder: (context, state) => const Scaffold(body: Text('Home'))),
          GoRoute(
            path: '/select-account-type',
            builder: (context, state) => const Scaffold(body: Text('Select Account Type')),
          ),
          GoRoute(
            path: '/personal-setup',
            builder:
                (context, state) =>
                    screenSize != null
                        ? MediaQuery(
                          data: MediaQueryData(size: screenSize),
                          child: MultiBlocProvider(
                            providers: [
                              BlocProvider<PersonalAccountSetupBloc>.value(value: mockPersonalAccountSetupBloc),
                              BlocProvider<AccountTypeBloc>.value(value: mockAccountTypeBloc),
                            ],
                            child: PersonalAccountSetupContent(),
                          ),
                        )
                        : MultiBlocProvider(
                          providers: [
                            BlocProvider<PersonalAccountSetupBloc>.value(value: mockPersonalAccountSetupBloc),
                            BlocProvider<AccountTypeBloc>.value(value: mockAccountTypeBloc),
                          ],
                          child: PersonalAccountSetupContent(),
                        ),
          ),
        ],
      );

      return MaterialApp.router(
        localizationsDelegates: const [
          Lang.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: Lang.delegate.supportedLocales,
        routerConfig: router,
      );
    }

    testWidgets('should display app bar with correct structure', (WidgetTester tester) async {
      // Arrange
      when(() => mockPersonalAccountSetupBloc.state).thenReturn(createMockPersonalAccountSetupState());
      when(
        () => mockPersonalAccountSetupBloc.stream,
      ).thenAnswer((_) => Stream.fromIterable([createMockPersonalAccountSetupState()]));
      when(() => mockAccountTypeBloc.state).thenReturn(const AccountTypeState(isLoading: false));
      when(
        () => mockAccountTypeBloc.stream,
      ).thenAnswer((_) => Stream.fromIterable([const AccountTypeState(isLoading: false)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(ExchekAppBar), findsOneWidget);
      expect(find.byType(ResponsiveScaffold), findsOneWidget);
    });

    testWidgets('should display loading widget when account type is loading', (WidgetTester tester) async {
      // Arrange
      when(() => mockPersonalAccountSetupBloc.state).thenReturn(createMockPersonalAccountSetupState());
      when(
        () => mockPersonalAccountSetupBloc.stream,
      ).thenAnswer((_) => Stream.fromIterable([createMockPersonalAccountSetupState()]));
      when(() => mockAccountTypeBloc.state).thenReturn(const AccountTypeState(isLoading: true));
      when(
        () => mockAccountTypeBloc.stream,
      ).thenAnswer((_) => Stream.fromIterable([const AccountTypeState(isLoading: true)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(AppLoaderWidget), findsOneWidget);
    });

    testWidgets('should display CustomScrollView with correct children when not loading', (WidgetTester tester) async {
      // Arrange
      when(() => mockPersonalAccountSetupBloc.state).thenReturn(createMockPersonalAccountSetupState());
      when(
        () => mockPersonalAccountSetupBloc.stream,
      ).thenAnswer((_) => Stream.fromIterable([createMockPersonalAccountSetupState()]));
      when(() => mockAccountTypeBloc.state).thenReturn(const AccountTypeState(isLoading: false));
      when(
        () => mockAccountTypeBloc.stream,
      ).thenAnswer((_) => Stream.fromIterable([const AccountTypeState(isLoading: false)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(CustomScrollView), findsOneWidget);
      expect(find.byType(PersonalAccountPurposeView), findsOneWidget);
    });

    testWidgets('should display StepperSlider', (WidgetTester tester) async {
      // Arrange
      when(() => mockPersonalAccountSetupBloc.state).thenReturn(createMockPersonalAccountSetupState());
      when(
        () => mockPersonalAccountSetupBloc.stream,
      ).thenAnswer((_) => Stream.fromIterable([createMockPersonalAccountSetupState()]));
      when(() => mockAccountTypeBloc.state).thenReturn(const AccountTypeState(isLoading: false));
      when(
        () => mockAccountTypeBloc.stream,
      ).thenAnswer((_) => Stream.fromIterable([const AccountTypeState(isLoading: false)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle(); // Wait for all animations and async operations

      // Check if the widget tree contains the expected structure
      expect(find.byType(ResponsiveScaffold), findsOneWidget);

      // Assert
      expect(find.byType(StepperSlider<PersonalAccountSetupSteps>), findsOneWidget);
    });

    // testWidgets('should display GetHelpTextButton', (WidgetTester tester) async {
    //   // Arrange
    //   when(() => mockPersonalAccountSetupBloc.state).thenReturn(createMockPersonalAccountSetupState());
    //   when(
    //     () => mockPersonalAccountSetupBloc.stream,
    //   ).thenAnswer((_) => Stream.fromIterable([createMockPersonalAccountSetupState()]));
    //   when(() => mockAccountTypeBloc.state).thenReturn(const AccountTypeState(isLoading: false));
    //   when(
    //     () => mockAccountTypeBloc.stream,
    //   ).thenAnswer((_) => Stream.fromIterable([const AccountTypeState(isLoading: false)]));
    //
    //   // Act
    //   await tester.pumpWidget(createTestWidget());
    //   await tester.pump();
    //
    //   // Assert
    //   expect(find.byType(GetHelpTextButton), findsOneWidget);
    // });

    group('Step Title Tests', () {
      testWidgets('should return correct title for personal entity step', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const [
              Lang.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: Lang.delegate.supportedLocales,
            home: Container(),
          ),
        );
        final context = tester.element(find.byType(Container));
        final widget = PersonalAccountSetupContent();

        // Act & Assert
        expect(widget.getStepTitle(context, PersonalAccountSetupSteps.personalEntity), isNotEmpty);
      });

      testWidgets('should return correct title for personal information step', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const [
              Lang.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: Lang.delegate.supportedLocales,
            home: Container(),
          ),
        );
        final context = tester.element(find.byType(Container));
        final widget = PersonalAccountSetupContent();

        // Act & Assert
        expect(widget.getStepTitle(context, PersonalAccountSetupSteps.personalInformation), isNotEmpty);
      });

      testWidgets('should return correct title for transaction preferences step', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const [
              Lang.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: Lang.delegate.supportedLocales,
            home: Container(),
          ),
        );
        final context = tester.element(find.byType(Container));
        final widget = PersonalAccountSetupContent();

        // Act & Assert
        expect(widget.getStepTitle(context, PersonalAccountSetupSteps.personalTransactions), isNotEmpty);
      });

      testWidgets('should return correct title for set password step', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const [
              Lang.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: Lang.delegate.supportedLocales,
            home: Container(),
          ),
        );
        final context = tester.element(find.byType(Container));
        final widget = PersonalAccountSetupContent();

        // Act & Assert
        expect(widget.getStepTitle(context, PersonalAccountSetupSteps.setPassword), isNotEmpty);
      });
    });

    group('Navigation Tests', () {
      testWidgets('should handle back navigation correctly', (WidgetTester tester) async {
        // Arrange
        when(
          () => mockPersonalAccountSetupBloc.state,
        ).thenReturn(createMockPersonalAccountSetupState(currentStep: PersonalAccountSetupSteps.personalInformation));
        when(() => mockPersonalAccountSetupBloc.stream).thenAnswer(
          (_) => Stream.fromIterable([
            createMockPersonalAccountSetupState(currentStep: PersonalAccountSetupSteps.personalInformation),
          ]),
        );
        when(() => mockAccountTypeBloc.state).thenReturn(const AccountTypeState(isLoading: false));
        when(
          () => mockAccountTypeBloc.stream,
        ).thenAnswer((_) => Stream.fromIterable([const AccountTypeState(isLoading: false)]));

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle(); // Wait for all async operations including addPostFrameCallback

        // Reset the mock to clear any calls from widget initialization
        reset(mockPersonalAccountSetupBloc);

        // Re-setup the mock state for the back button test
        when(
          () => mockPersonalAccountSetupBloc.state,
        ).thenReturn(createMockPersonalAccountSetupState(currentStep: PersonalAccountSetupSteps.personalInformation));

        // Find and tap the back button in the app bar
        final backButton = find.byType(IconButton);
        expect(backButton, findsOneWidget); // Ensure we find exactly one IconButton
        await tester.tap(backButton);

        // Assert
        verify(() => mockPersonalAccountSetupBloc.add(any<PersonalInfoStepChanged>())).called(1);
      });

      testWidgets('should handle back navigation from first step logic', (WidgetTester tester) async {
        // Arrange
        when(
          () => mockPersonalAccountSetupBloc.state,
        ).thenReturn(createMockPersonalAccountSetupState(currentStep: PersonalAccountSetupSteps.personalEntity));
        when(() => mockPersonalAccountSetupBloc.stream).thenAnswer(
          (_) => Stream.fromIterable([
            createMockPersonalAccountSetupState(currentStep: PersonalAccountSetupSteps.personalEntity),
          ]),
        );
        when(() => mockAccountTypeBloc.state).thenReturn(const AccountTypeState(isLoading: false));
        when(
          () => mockAccountTypeBloc.stream,
        ).thenAnswer((_) => Stream.fromIterable([const AccountTypeState(isLoading: false)]));

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert - Verify the widget renders correctly for first step
        expect(find.byType(PersonalAccountPurposeView), findsOneWidget);
        expect(find.byType(ExchekAppBar), findsOneWidget);

        // Verify the app bar has the back button functionality
        final appBar = tester.widget<ExchekAppBar>(find.byType(ExchekAppBar));
        expect(appBar.onBackPressed, isNotNull);
      });

      testWidgets('should render main content when not loading', (WidgetTester tester) async {
        // Arrange
        when(() => mockPersonalAccountSetupBloc.state).thenReturn(createMockPersonalAccountSetupState());
        when(
          () => mockPersonalAccountSetupBloc.stream,
        ).thenAnswer((_) => Stream.fromIterable([createMockPersonalAccountSetupState()]));
        when(() => mockAccountTypeBloc.state).thenReturn(const AccountTypeState(isLoading: false));
        when(
          () => mockAccountTypeBloc.stream,
        ).thenAnswer((_) => Stream.fromIterable([const AccountTypeState(isLoading: false)]));

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle(); // Wait for all animations and async operations

        // Assert - Main content should be rendered when not loading
        expect(find.byType(Center), findsWidgets);
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(CustomScrollView), findsOneWidget);
        // expect(find.byType(GetHelpTextButton), findsOneWidget);

        // Verify that AppLoaderWidget is not shown
        expect(find.byType(AppLoaderWidget), findsNothing);
      });
    });

    group('Step Content Tests', () {
      testWidgets('should display PersonalTransactionAndPaymentPreferencesView for transaction step', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(
          () => mockPersonalAccountSetupBloc.state,
        ).thenReturn(createMockPersonalAccountSetupState(currentStep: PersonalAccountSetupSteps.personalTransactions));
        when(() => mockPersonalAccountSetupBloc.stream).thenAnswer(
          (_) => Stream.fromIterable([
            createMockPersonalAccountSetupState(currentStep: PersonalAccountSetupSteps.personalTransactions),
          ]),
        );
        when(() => mockAccountTypeBloc.state).thenReturn(const AccountTypeState(isLoading: false));
        when(
          () => mockAccountTypeBloc.stream,
        ).thenAnswer((_) => Stream.fromIterable([const AccountTypeState(isLoading: false)]));

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.byType(PersonalTransactionAndPaymentPreferencesView), findsOneWidget);
      });

      testWidgets('should display PersonalSetPasswordView for set password step', (WidgetTester tester) async {
        // Arrange
        when(
          () => mockPersonalAccountSetupBloc.state,
        ).thenReturn(createMockPersonalAccountSetupState(currentStep: PersonalAccountSetupSteps.setPassword));
        when(() => mockPersonalAccountSetupBloc.stream).thenAnswer(
          (_) => Stream.fromIterable([
            createMockPersonalAccountSetupState(currentStep: PersonalAccountSetupSteps.setPassword),
          ]),
        );
        when(() => mockAccountTypeBloc.state).thenReturn(const AccountTypeState(isLoading: false));
        when(
          () => mockAccountTypeBloc.stream,
        ).thenAnswer((_) => Stream.fromIterable([const AccountTypeState(isLoading: false)]));

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.byType(PersonalSetPasswordView), findsOneWidget);
      });

      testWidgets('should display PersonalLegalNameContactView for personal information step', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(
          () => mockPersonalAccountSetupBloc.state,
        ).thenReturn(createMockPersonalAccountSetupState(currentStep: PersonalAccountSetupSteps.personalInformation));
        when(() => mockPersonalAccountSetupBloc.stream).thenAnswer(
          (_) => Stream.fromIterable([
            createMockPersonalAccountSetupState(currentStep: PersonalAccountSetupSteps.personalInformation),
          ]),
        );
        when(() => mockAccountTypeBloc.state).thenReturn(const AccountTypeState(isLoading: false));
        when(
          () => mockAccountTypeBloc.stream,
        ).thenAnswer((_) => Stream.fromIterable([const AccountTypeState(isLoading: false)]));

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.byType(PersonalLegalNameContactView), findsOneWidget);
      });
    });

    group('App Bar Tests', () {
      testWidgets('should call onClose handler when close button is tapped', (WidgetTester tester) async {
        // Arrange
        when(() => mockPersonalAccountSetupBloc.state).thenReturn(createMockPersonalAccountSetupState());
        when(
          () => mockPersonalAccountSetupBloc.stream,
        ).thenAnswer((_) => Stream.fromIterable([createMockPersonalAccountSetupState()]));
        when(() => mockAccountTypeBloc.state).thenReturn(const AccountTypeState(isLoading: false));
        when(
          () => mockAccountTypeBloc.stream,
        ).thenAnswer((_) => Stream.fromIterable([const AccountTypeState(isLoading: false)]));

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Find the ExchekAppBar and verify onClose is set
        final appBar = tester.widget<ExchekAppBar>(find.byType(ExchekAppBar));
        expect(appBar.onClose, isNotNull);

        // Call onClose to cover the line
        appBar.onClose!();

        // Assert - onClose handler should be callable without errors
        // The actual implementation is commented out, so we just verify it doesn't throw
      });

      testWidgets('should handle scroll notification and trigger app bar collapse', (WidgetTester tester) async {
        // Arrange
        when(() => mockPersonalAccountSetupBloc.state).thenReturn(createMockPersonalAccountSetupState());
        when(
          () => mockPersonalAccountSetupBloc.stream,
        ).thenAnswer((_) => Stream.fromIterable([createMockPersonalAccountSetupState()]));
        when(() => mockAccountTypeBloc.state).thenReturn(const AccountTypeState(isLoading: false));
        when(
          () => mockAccountTypeBloc.stream,
        ).thenAnswer((_) => Stream.fromIterable([const AccountTypeState(isLoading: false)]));

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Find the CustomScrollView and simulate scroll
        final scrollView = find.byType(CustomScrollView);
        expect(scrollView, findsOneWidget);

        // Simulate scroll to trigger notification
        await tester.drag(scrollView, const Offset(0, -100));
        await tester.pump();

        // Assert - verify that scroll notification was handled
        // The scroll notification should trigger PersonalAppBarCollapseChanged event
        verify(() => mockPersonalAccountSetupBloc.add(any<PersonalAppBarCollapseChanged>())).called(greaterThan(0));
      });
    });

    group('Responsive Layout Tests', () {
      testWidgets('should display mobile layout for small screens', (WidgetTester tester) async {
        // Arrange
        when(() => mockPersonalAccountSetupBloc.state).thenReturn(createMockPersonalAccountSetupState());
        when(
          () => mockPersonalAccountSetupBloc.stream,
        ).thenAnswer((_) => Stream.fromIterable([createMockPersonalAccountSetupState()]));
        when(() => mockAccountTypeBloc.state).thenReturn(const AccountTypeState(isLoading: false));
        when(
          () => mockAccountTypeBloc.stream,
        ).thenAnswer((_) => Stream.fromIterable([const AccountTypeState(isLoading: false)]));

        // Act - Test with mobile screen size
        await tester.pumpWidget(createTestWidget(screenSize: const Size(400, 800)));
        await tester.pump();

        // Assert
        expect(find.byType(ResponsiveScaffold), findsOneWidget);
        expect(find.byType(StepperSlider<PersonalAccountSetupSteps>), findsOneWidget);
      });

      testWidgets('should display web layout for large screens', (WidgetTester tester) async {
        // Arrange
        when(() => mockPersonalAccountSetupBloc.state).thenReturn(createMockPersonalAccountSetupState());
        when(
          () => mockPersonalAccountSetupBloc.stream,
        ).thenAnswer((_) => Stream.fromIterable([createMockPersonalAccountSetupState()]));
        when(() => mockAccountTypeBloc.state).thenReturn(const AccountTypeState(isLoading: false));
        when(
          () => mockAccountTypeBloc.stream,
        ).thenAnswer((_) => Stream.fromIterable([const AccountTypeState(isLoading: false)]));

        // Act - Test with desktop screen size
        await tester.pumpWidget(createTestWidget(screenSize: const Size(1200, 800)));
        await tester.pump();

        // Assert
        expect(find.byType(ResponsiveScaffold), findsOneWidget);
        expect(find.byType(StepperSlider<PersonalAccountSetupSteps>), findsOneWidget);
      });

      testWidgets('should handle collapsed state properly', (WidgetTester tester) async {
        // Arrange
        final collapsedState = createMockPersonalAccountSetupState().copyWith(isCollapsed: true);
        when(() => mockPersonalAccountSetupBloc.state).thenReturn(collapsedState);
        when(() => mockPersonalAccountSetupBloc.stream).thenAnswer((_) => Stream.fromIterable([collapsedState]));
        when(() => mockAccountTypeBloc.state).thenReturn(const AccountTypeState(isLoading: false));
        when(
          () => mockAccountTypeBloc.stream,
        ).thenAnswer((_) => Stream.fromIterable([const AccountTypeState(isLoading: false)]));

        // Act - Test with desktop screen size to trigger web layout
        await tester.pumpWidget(createTestWidget(screenSize: const Size(1200, 800)));
        await tester.pump();

        // Assert
        expect(find.byType(ResponsiveScaffold), findsOneWidget);
        // In collapsed state, the stepper slider should still be present
        expect(find.byType(StepperSlider<PersonalAccountSetupSteps>), findsWidgets);
      });
    });

    group('BlocListener Tests', () {
      testWidgets('should handle step change without scroll animation', (WidgetTester tester) async {
        // Arrange
        final initialState = createMockPersonalAccountSetupState(currentStep: PersonalAccountSetupSteps.personalEntity);

        when(() => mockPersonalAccountSetupBloc.state).thenReturn(initialState);
        when(() => mockPersonalAccountSetupBloc.stream).thenAnswer((_) => Stream.fromIterable([initialState]));
        when(() => mockAccountTypeBloc.state).thenReturn(const AccountTypeState(isLoading: false));
        when(
          () => mockAccountTypeBloc.stream,
        ).thenAnswer((_) => Stream.fromIterable([const AccountTypeState(isLoading: false)]));

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();
        await tester.pumpAndSettle();

        // Assert - The widget should render without errors
        expect(find.byType(PersonalAccountPurposeView), findsOneWidget);
      });
    });

    group('Responsive Layout Tests - Additional Coverage', () {
      testWidgets('should handle different screen sizes correctly', (WidgetTester tester) async {
        // Arrange
        when(() => mockPersonalAccountSetupBloc.state).thenReturn(createMockPersonalAccountSetupState());
        when(
          () => mockPersonalAccountSetupBloc.stream,
        ).thenAnswer((_) => Stream.fromIterable([createMockPersonalAccountSetupState()]));
        when(() => mockAccountTypeBloc.state).thenReturn(const AccountTypeState(isLoading: false));
        when(
          () => mockAccountTypeBloc.stream,
        ).thenAnswer((_) => Stream.fromIterable([const AccountTypeState(isLoading: false)]));

        // Act - Test with tablet screen size (600-1200)
        await tester.pumpWidget(createTestWidget(screenSize: const Size(800, 600)));
        await tester.pump();

        // Assert - Should render without errors for tablet size
        expect(find.byType(ResponsiveScaffold), findsOneWidget);
        expect(find.byType(StepperSlider<PersonalAccountSetupSteps>), findsOneWidget);
      });

      testWidgets('should handle collapsed state transitions', (WidgetTester tester) async {
        // Arrange
        final initialState = createMockPersonalAccountSetupState(isCollapsed: false);
        final collapsedState = createMockPersonalAccountSetupState(isCollapsed: true);

        when(() => mockPersonalAccountSetupBloc.state).thenReturn(initialState);
        when(
          () => mockPersonalAccountSetupBloc.stream,
        ).thenAnswer((_) => Stream.fromIterable([initialState, collapsedState]));
        when(() => mockAccountTypeBloc.state).thenReturn(const AccountTypeState(isLoading: false));
        when(
          () => mockAccountTypeBloc.stream,
        ).thenAnswer((_) => Stream.fromIterable([const AccountTypeState(isLoading: false)]));

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Trigger state change to collapsed
        await tester.pump();

        // Assert - Should handle collapsed state transition
        expect(find.byType(StepperSlider<PersonalAccountSetupSteps>), findsWidgets);
      });

      testWidgets('should render stepper slider with correct configuration', (WidgetTester tester) async {
        // Arrange
        when(() => mockPersonalAccountSetupBloc.state).thenReturn(createMockPersonalAccountSetupState());
        when(
          () => mockPersonalAccountSetupBloc.stream,
        ).thenAnswer((_) => Stream.fromIterable([createMockPersonalAccountSetupState()]));
        when(() => mockAccountTypeBloc.state).thenReturn(const AccountTypeState(isLoading: false));
        when(
          () => mockAccountTypeBloc.stream,
        ).thenAnswer((_) => Stream.fromIterable([const AccountTypeState(isLoading: false)]));

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert - Should show stepper slider with correct configuration
        final stepperSlider = tester.widget<StepperSlider<PersonalAccountSetupSteps>>(
          find.byType(StepperSlider<PersonalAccountSetupSteps>),
        );
        expect(stepperSlider.currentStep, PersonalAccountSetupSteps.personalEntity);
        expect(stepperSlider.steps, PersonalAccountSetupSteps.values);
      });
    });
  });
}
