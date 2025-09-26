import 'package:exchek/core/enums/app_enums.dart';
import 'package:exchek/viewmodels/account_setup_bloc/personal_account_setup_bloc/personal_account_setup_bloc.dart';
import 'package:exchek/widgets/account_setup_widgets/custom_tile.dart';
import 'package:exchek/widgets/custom_widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:exchek/views/account_setup_view/personal_account_setup_view/personal_transaction_payment_reference_view.dart';
import 'package:exchek/core/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

@GenerateMocks([PersonalAccountSetupBloc])
import 'personal_transaction_payment_reference_view_test.mocks.dart';

PersonalAccountSetupState createTestState({
  List<String>? estimatedMonthlyVolumeList,
  String? selectedEstimatedMonthlyTransaction,
  List<CurrencyModel>? currencyList,
  List<CurrencyModel>? selectedCurrencies,
  bool? isTransactionDetailLoading,
  PersonalAccountSetupSteps? currentStep,
}) {
  return PersonalAccountSetupState(
    estimatedMonthlyVolumeList: estimatedMonthlyVolumeList,
    selectedEstimatedMonthlyTransaction: selectedEstimatedMonthlyTransaction,
    currencyList: currencyList ?? [],
    selectedCurrencies: selectedCurrencies ?? [],
    isTransactionDetailLoading: isTransactionDetailLoading,
    scrollController: ScrollController(),
    currentStep: currentStep ?? PersonalAccountSetupSteps.personalTransactions,
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
  group('PersonalTransactionAndPaymentPreferencesView Widget Tests', () {
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
            child: BlocProvider<PersonalAccountSetupBloc>.value(
              value: mockBloc,
              child: const PersonalTransactionAndPaymentPreferencesView(),
            ),
          ),
        ),
      );
    }

    testWidgets('should display monthly transaction volume section', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          estimatedMonthlyVolumeList: [r'$0 - $1,000', r'$1,001 - $5,000', r'$5,001 - $10,000'],
          selectedEstimatedMonthlyTransaction: null,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            estimatedMonthlyVolumeList: [r'$0 - $1,000', r'$1,001 - $5,000', r'$5,001 - $10,000'],
            selectedEstimatedMonthlyTransaction: null,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.textContaining('estimated'), findsAtLeastNWidgets(1));
      expect(find.byType(CustomTileWidget), findsNWidgets(3));
    });

    testWidgets('should display currency selection section when currency list is available', (
      WidgetTester tester,
    ) async {
      // Arrange
      final currencies = [
        CurrencyModel(
          currencyName: 'US Dollar',
          currencySymbol: 'USD',
          currencyImagePath: 'assets/images/pngs/authentication/png_country_image.png',
        ),
        CurrencyModel(
          currencyName: 'Euro',
          currencySymbol: 'EUR',
          currencyImagePath: 'assets/images/pngs/authentication/png_country_image.png',
        ),
      ];

      when(mockBloc.state).thenReturn(
        createTestState(
          estimatedMonthlyVolumeList: [r'$0 - $1,000'],
          selectedEstimatedMonthlyTransaction: r'$0 - $1,000',
          currencyList: currencies,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            estimatedMonthlyVolumeList: [r'$0 - $1,000'],
            selectedEstimatedMonthlyTransaction: r'$0 - $1,000',
            currencyList: currencies,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.textContaining('transaction'), findsAtLeastNWidgets(1));
      expect(find.textContaining('USD'), findsOneWidget);
      expect(find.textContaining('EUR'), findsOneWidget);
    });

    testWidgets('should display Next button', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(estimatedMonthlyVolumeList: [r'$0 - $1,000'], selectedEstimatedMonthlyTransaction: null),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(estimatedMonthlyVolumeList: [r'$0 - $1,000'], selectedEstimatedMonthlyTransaction: null),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.text('Next'), findsOneWidget);
      expect(find.byType(CustomElevatedButton), findsOneWidget);
    });

    testWidgets('should disable Next button when no selections made', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(estimatedMonthlyVolumeList: [r'$0 - $1,000'], selectedEstimatedMonthlyTransaction: null),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(estimatedMonthlyVolumeList: [r'$0 - $1,000'], selectedEstimatedMonthlyTransaction: null),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
      expect(button.isDisabled, isTrue);
    });

    testWidgets('should enable Next button when all selections made', (WidgetTester tester) async {
      // Arrange
      final currencies = [
        CurrencyModel(
          currencyName: 'US Dollar',
          currencySymbol: 'USD',
          currencyImagePath: 'assets/images/pngs/authentication/png_country_image.png',
        ),
      ];

      when(mockBloc.state).thenReturn(
        createTestState(
          estimatedMonthlyVolumeList: [r'$0 - $1,000'],
          selectedEstimatedMonthlyTransaction: r'$0 - $1,000',
          currencyList: currencies,
          selectedCurrencies: [currencies.first],
          isTransactionDetailLoading: false,
          currentStep: PersonalAccountSetupSteps.personalTransactions,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            estimatedMonthlyVolumeList: [r'$0 - $1,000'],
            selectedEstimatedMonthlyTransaction: r'$0 - $1,000',
            currencyList: currencies,
            selectedCurrencies: [currencies.first],
            isTransactionDetailLoading: false,
            currentStep: PersonalAccountSetupSteps.personalTransactions,
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

    testWidgets('should show loading state when transaction detail is loading', (WidgetTester tester) async {
      // Arrange
      final currencies = [
        CurrencyModel(
          currencyName: 'US Dollar',
          currencySymbol: 'USD',
          currencyImagePath: 'assets/images/pngs/authentication/png_country_image.png',
        ),
      ];

      when(mockBloc.state).thenReturn(
        createTestState(
          estimatedMonthlyVolumeList: [r'$0 - $1,000'],
          selectedEstimatedMonthlyTransaction: r'$0 - $1,000',
          currencyList: currencies,
          selectedCurrencies: [currencies.first],
          isTransactionDetailLoading: true,
          currentStep: PersonalAccountSetupSteps.personalTransactions,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            estimatedMonthlyVolumeList: [r'$0 - $1,000'],
            selectedEstimatedMonthlyTransaction: r'$0 - $1,000',
            currencyList: currencies,
            selectedCurrencies: [currencies.first],
            isTransactionDetailLoading: true,
            currentStep: PersonalAccountSetupSteps.personalTransactions,
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

    testWidgets('should display transaction volume tiles that can be tapped', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          estimatedMonthlyVolumeList: [r'$0 - $1,000', r'$1,001 - $5,000'],
          selectedEstimatedMonthlyTransaction: null,
          currencyList: [],
          selectedCurrencies: [],
          currentStep: PersonalAccountSetupSteps.personalTransactions,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            estimatedMonthlyVolumeList: [r'$0 - $1,000', r'$1,001 - $5,000'],
            selectedEstimatedMonthlyTransaction: null,
            currencyList: [],
            selectedCurrencies: [],
            currentStep: PersonalAccountSetupSteps.personalTransactions,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(CustomTileWidget), findsNWidgets(2));
      expect(find.textContaining(r'$0 - $1,000'), findsOneWidget);
      expect(find.textContaining(r'$1,001 - $5,000'), findsOneWidget);
    });

    testWidgets('should display currency tiles with proper configuration', (WidgetTester tester) async {
      // Arrange
      final currencies = [
        CurrencyModel(
          currencyName: 'US Dollar',
          currencySymbol: 'USD',
          currencyImagePath: 'assets/images/pngs/authentication/png_country_image.png',
        ),
      ];

      when(mockBloc.state).thenReturn(
        createTestState(
          estimatedMonthlyVolumeList: [r'$0 - $1,000'],
          selectedEstimatedMonthlyTransaction: r'$0 - $1,000',
          currencyList: currencies,
          selectedCurrencies: [],
          currentStep: PersonalAccountSetupSteps.personalTransactions,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            estimatedMonthlyVolumeList: [r'$0 - $1,000'],
            selectedEstimatedMonthlyTransaction: r'$0 - $1,000',
            currencyList: currencies,
            selectedCurrencies: [],
            currentStep: PersonalAccountSetupSteps.personalTransactions,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(CustomTileWidget), findsNWidgets(2)); // 1 transaction + 1 currency
      expect(find.textContaining('USD'), findsOneWidget);
      expect(find.textContaining('US Dollar'), findsOneWidget);
    });

    testWidgets('should display enabled Next button when all selections are made', (WidgetTester tester) async {
      // Arrange
      final currencies = [
        CurrencyModel(
          currencyName: 'US Dollar',
          currencySymbol: 'USD',
          currencyImagePath: 'assets/images/pngs/authentication/png_country_image.png',
        ),
      ];

      when(mockBloc.state).thenReturn(
        createTestState(
          estimatedMonthlyVolumeList: [r'$0 - $1,000'],
          selectedEstimatedMonthlyTransaction: r'$0 - $1,000',
          currencyList: currencies,
          selectedCurrencies: [currencies.first],
          isTransactionDetailLoading: false,
          currentStep: PersonalAccountSetupSteps.personalTransactions,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            estimatedMonthlyVolumeList: [r'$0 - $1,000'],
            selectedEstimatedMonthlyTransaction: r'$0 - $1,000',
            currencyList: currencies,
            selectedCurrencies: [currencies.first],
            isTransactionDetailLoading: false,
            currentStep: PersonalAccountSetupSteps.personalTransactions,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(CustomElevatedButton), findsOneWidget);
      final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
      expect(button.isDisabled, isFalse);
    });

    testWidgets('should display currency with checkbox when showTrailingCheckbox is true', (WidgetTester tester) async {
      // Arrange
      final currencies = [
        CurrencyModel(
          currencyName: 'US Dollar',
          currencySymbol: 'USD',
          currencyImagePath: 'assets/images/pngs/authentication/png_country_image.png',
        ),
      ];

      when(mockBloc.state).thenReturn(
        createTestState(
          estimatedMonthlyVolumeList: [r'$0 - $1,000'],
          selectedEstimatedMonthlyTransaction: r'$0 - $1,000',
          currencyList: currencies,
          selectedCurrencies: [],
          currentStep: PersonalAccountSetupSteps.personalTransactions,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            estimatedMonthlyVolumeList: [r'$0 - $1,000'],
            selectedEstimatedMonthlyTransaction: r'$0 - $1,000',
            currencyList: currencies,
            selectedCurrencies: [],
            currentStep: PersonalAccountSetupSteps.personalTransactions,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final tileWidget = tester.widget<CustomTileWidget>(find.byType(CustomTileWidget).last);
      expect(tileWidget.showTrailingCheckbox, isTrue);
      expect(tileWidget.isShowTrailing, isTrue);
    });

    testWidgets('should display currency title with symbol and name', (WidgetTester tester) async {
      // Arrange
      final currencies = [
        CurrencyModel(
          currencyName: 'US Dollar',
          currencySymbol: 'USD',
          currencyImagePath: 'assets/images/pngs/authentication/png_country_image.png',
        ),
      ];

      when(mockBloc.state).thenReturn(
        createTestState(
          estimatedMonthlyVolumeList: [r'$0 - $1,000'],
          selectedEstimatedMonthlyTransaction: r'$0 - $1,000',
          currencyList: currencies,
          selectedCurrencies: [],
          currentStep: PersonalAccountSetupSteps.personalTransactions,
        ),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(
            estimatedMonthlyVolumeList: [r'$0 - $1,000'],
            selectedEstimatedMonthlyTransaction: r'$0 - $1,000',
            currencyList: currencies,
            selectedCurrencies: [],
            currentStep: PersonalAccountSetupSteps.personalTransactions,
          ),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.textContaining('USD'), findsOneWidget);
      expect(find.textContaining('US Dollar'), findsOneWidget);
    });
  });
}
