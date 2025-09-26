import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/views/account_setup_view/business_account_setup_view/business_transaction_and_payment_preferences_view.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([BusinessAccountSetupBloc])
import 'business_transaction_preferences_view_test.mocks.dart';

// Helper function to create a complete BusinessAccountSetupState for testing
BusinessAccountSetupState createTestBusinessAccountSetupState({
  List<String>? estimatedMonthlyVolumeList,
  String? selectedEstimatedMonthlyTransaction,
  List<CurrencyModel>? curruncyList,
  List<CurrencyModel>? selectedCurrencies,
  bool? isTranscationDetailLoading,
}) {
  return BusinessAccountSetupState(
    currentStep: BusinessAccountSetupSteps.transactionAndPaymentPreferences,
    goodsAndServiceExportDescriptionController: TextEditingController(),
    goodsExportOtherController: TextEditingController(),
    serviceExportOtherController: TextEditingController(),
    businessActivityOtherController: TextEditingController(),
    scrollController: ScrollController(),
    formKey: GlobalKey<FormState>(),
    businessLegalNameController: TextEditingController(),
    professionalWebsiteUrl: TextEditingController(),
    phoneController: TextEditingController(),
    otpController: TextEditingController(),
    sePasswordFormKey: GlobalKey<FormState>(),
    createPasswordController: TextEditingController(),
    confirmPasswordController: TextEditingController(),
    currentKycVerificationStep: KycVerificationSteps.panVerification,
    aadharNumberController: TextEditingController(),
    aadharOtpController: TextEditingController(),
    aadharVerificationFormKey: GlobalKey<FormState>(),
    kartaAadharNumberController: TextEditingController(),
    kartaAadharOtpController: TextEditingController(),
    kartaAadharVerificationFormKey: GlobalKey<FormState>(),
    hufPanVerificationKey: GlobalKey<FormState>(),
    hufPanNumberController: TextEditingController(),
    isHUFPanVerifyingLoading: false,
    businessPanNumberController: TextEditingController(),
    businessPanNameController: TextEditingController(),
    businessPanVerificationKey: GlobalKey<FormState>(),
    directorsPanVerificationKey: GlobalKey<FormState>(),
    director1PanNumberController: TextEditingController(),
    director1PanNameController: TextEditingController(),
    director2PanNumberController: TextEditingController(),
    director2PanNameController: TextEditingController(),
    beneficialOwnerPanVerificationKey: GlobalKey<FormState>(),
    beneficialOwnerPanNumberController: TextEditingController(),
    beneficialOwnerPanNameController: TextEditingController(),
    businessRepresentativeFormKey: GlobalKey<FormState>(),
    businessRepresentativePanNumberController: TextEditingController(),
    businessRepresentativePanNameController: TextEditingController(),
    registerAddressFormKey: GlobalKey<FormState>(),
    selectedCountry: Country(
      phoneCode: '91',
      countryCode: 'IN',
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: 'India',
      example: '9123456789',
      displayName: 'India',
      displayNameNoCountryCode: 'India',
      e164Key: '',
    ),
    pinCodeController: TextEditingController(),
    stateNameController: TextEditingController(),
    cityNameController: TextEditingController(),
    address1NameController: TextEditingController(),
    address2NameController: TextEditingController(),
    turnOverController: TextEditingController(),
    gstNumberController: TextEditingController(),
    annualTurnoverFormKey: GlobalKey<FormState>(),
    isGstCertificateMandatory: false,
    iceVerificationKey: GlobalKey<FormState>(),
    iceNumberController: TextEditingController(),
    cinVerificationKey: GlobalKey<FormState>(),
    cinNumberController: TextEditingController(),
    llpinNumberController: TextEditingController(),
    bankAccountVerificationFormKey: GlobalKey<FormState>(),
    bankAccountNumberController: TextEditingController(),
    reEnterbankAccountNumberController: TextEditingController(),
    ifscCodeController: TextEditingController(),
    estimatedMonthlyVolumeList: estimatedMonthlyVolumeList,
    selectedEstimatedMonthlyTransaction: selectedEstimatedMonthlyTransaction,
    curruncyList: curruncyList,
    selectedCurrencies: selectedCurrencies,
    isTranscationDetailLoading: isTranscationDetailLoading,
    directorCaptchaInputController: TextEditingController(),
    kartaCaptchaInputController: TextEditingController(),
    partnerAadharNumberController: TextEditingController(),
    partnerAadharOtpController: TextEditingController(),
    partnerAadharVerificationFormKey: GlobalKey<FormState>(),
    partnerCaptchaInputController: TextEditingController(),
    proprietorAadharNumberController: TextEditingController(),
    proprietorAadharOtpController: TextEditingController(),
    proprietorAadharVerificationFormKey: GlobalKey<FormState>(),
    proprietorCaptchaInputController: TextEditingController(),
    directorEmailIdNumberController: TextEditingController(),
    directorMobileNumberController: TextEditingController(),
    directorContactInformationKey: GlobalKey<FormState>(),
    otherDirectorsPanVerificationKey: GlobalKey<FormState>(),
    otherDirectorVerificationFormKey: GlobalKey<FormState>(),
    otherDirectorAadharNumberController: TextEditingController(),
    otherDirectoraadharOtpController: TextEditingController(),
    otherDirectorCaptchaInputController: TextEditingController(),
    directorKycStep: DirectorKycSteps.panDetails,
    companyPanVerificationKey: GlobalKey<FormState>(),
    companyPanCardFile: null,
    isCompanyPanDetailsLoading: false,
    isCompanyPanDetailsVerified: false,
    fullCompanyNamePan: null,
    isCompanyPanVerifyingLoading: false,
    companyPanNumberController: TextEditingController(),
    llpPanVerificationKey: GlobalKey<FormState>(),
    llpPanNumberController: TextEditingController(),
    isLLPPanVerifyingLoading: false,
    partnershipFirmPanVerificationKey: GlobalKey<FormState>(),
    partnershipFirmPanNumberController: TextEditingController(),
    isPartnershipFirmPanVerifyingLoading: false,
    soleProprietorShipPanVerificationKey: GlobalKey<FormState>(),
    soleProprietorShipPanNumberController: TextEditingController(),
    isSoleProprietorShipPanVerifyingLoading: false,
    kartaPanVerificationKey: GlobalKey<FormState>(),
    kartaPanNumberController: TextEditingController(),
    isKartaPanVerifyingLoading: false,
    authorizedPinCodeController: TextEditingController(),
    authorizedStateNameController: TextEditingController(),
    authorizedCityNameController: TextEditingController(),
    authorizedAddress1NameController: TextEditingController(),
    authorizedAddress2NameController: TextEditingController(),
    otherDirectorPinCodeController: TextEditingController(),
    otherDirectorStateNameController: TextEditingController(),
    otherDirectorCityNameController: TextEditingController(),
    otherDirectorAddress1NameController: TextEditingController(),
    otherDirectorAddress2NameController: TextEditingController(),
    beneficialOwnerPinCodeController: TextEditingController(),
    beneficialOwnerStateNameController: TextEditingController(),
    beneficialOwnerCityNameController: TextEditingController(),
    beneficialOwnerAddress1NameController: TextEditingController(),
    beneficialOwnerAddress2NameController: TextEditingController(),
    dbaController: TextEditingController(),
  );
}

void main() {
  group('BusinessTransactionAndPaymentPreferencesView Widget Tests', () {
    late MockBusinessAccountSetupBloc mockBloc;

    setUp(() {
      mockBloc = MockBusinessAccountSetupBloc();
      when(mockBloc.stream).thenAnswer((_) => Stream<BusinessAccountSetupState>.empty());
    });

    Widget createTestWidget() {
      return MaterialApp(
        localizationsDelegates: const [
          Lang.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        locale: const Locale('en'),
        home: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              height: 1500, // Provide enough height to prevent overflow
              child: BlocProvider<BusinessAccountSetupBloc>.value(
                value: mockBloc,
                child: const BusinessTransactionAndPaymentPreferencesView(),
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('should display monthly transaction volume section', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestBusinessAccountSetupState(
          estimatedMonthlyVolumeList: ['\$0 - \$1,000', '\$1,001 - \$5,000', '\$5,001 - \$10,000'],
          selectedEstimatedMonthlyTransaction: null,
          curruncyList: [],
          selectedCurrencies: [],
        ),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.textContaining('estimated monthly transaction volume'), findsAtLeastNWidgets(1));
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
        createTestBusinessAccountSetupState(
          estimatedMonthlyVolumeList: ['\$0 - \$1,000'],
          selectedEstimatedMonthlyTransaction: '\$0 - \$1,000',
          curruncyList: currencies,
          selectedCurrencies: [],
        ),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.textContaining('receive payments'), findsAtLeastNWidgets(1));
      expect(find.textContaining('USD'), findsOneWidget);
      expect(find.textContaining('EUR'), findsOneWidget);
    });

    testWidgets('should display Next button', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestBusinessAccountSetupState(
          estimatedMonthlyVolumeList: ['\$0 - \$1,000'],
          selectedEstimatedMonthlyTransaction: null,
          curruncyList: [],
          selectedCurrencies: [],
        ),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Next'), findsOneWidget);
      expect(find.byType(CustomElevatedButton), findsOneWidget);
    });

    testWidgets('should disable Next button when no selections made', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestBusinessAccountSetupState(
          estimatedMonthlyVolumeList: ['\$0 - \$1,000'],
          selectedEstimatedMonthlyTransaction: null,
          curruncyList: [],
          selectedCurrencies: [],
        ),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

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
        createTestBusinessAccountSetupState(
          estimatedMonthlyVolumeList: ['\$0 - \$1,000'],
          selectedEstimatedMonthlyTransaction: '\$0 - \$1,000',
          curruncyList: currencies,
          selectedCurrencies: [currencies.first],
          isTranscationDetailLoading: false,
        ),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

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
        createTestBusinessAccountSetupState(
          estimatedMonthlyVolumeList: ['\$0 - \$1,000'],
          selectedEstimatedMonthlyTransaction: '\$0 - \$1,000',
          curruncyList: currencies,
          selectedCurrencies: [currencies.first],
          isTranscationDetailLoading: true,
        ),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
      expect(button.isLoading, isTrue);
    });

    testWidgets('should trigger ChangeEstimatedMonthlyTransaction when transaction volume selected', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestBusinessAccountSetupState(
          estimatedMonthlyVolumeList: ['\$0 - \$1,000', '\$1,001 - \$5,000'],
          selectedEstimatedMonthlyTransaction: null,
          curruncyList: [],
          selectedCurrencies: [],
        ),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      await tester.tap(find.byType(CustomTileWidget).first, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    testWidgets('should display currency tiles with proper structure', (WidgetTester tester) async {
      // Arrange
      final currencies = [
        CurrencyModel(
          currencyName: 'US Dollar',
          currencySymbol: 'USD',
          currencyImagePath: 'assets/images/pngs/authentication/png_country_image.png',
        ),
      ];

      when(mockBloc.state).thenReturn(
        createTestBusinessAccountSetupState(
          estimatedMonthlyVolumeList: ['\$0 - \$1,000'],
          selectedEstimatedMonthlyTransaction: '\$0 - \$1,000',
          curruncyList: currencies,
          selectedCurrencies: [],
        ),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert - Check that currency tiles are displayed
      expect(find.textContaining('USD'), findsAtLeastNWidgets(1));
      expect(find.textContaining('US Dollar'), findsAtLeastNWidgets(1));
      expect(find.byType(CustomTileWidget), findsAtLeastNWidgets(2)); // Transaction volume + currency
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
        createTestBusinessAccountSetupState(
          estimatedMonthlyVolumeList: ['\$0 - \$1,000'],
          selectedEstimatedMonthlyTransaction: '\$0 - \$1,000',
          curruncyList: currencies,
          selectedCurrencies: [currencies.first],
          isTranscationDetailLoading: false,
        ),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert - Check that Next button is present and enabled
      expect(find.text('Next'), findsOneWidget);
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
        createTestBusinessAccountSetupState(
          estimatedMonthlyVolumeList: ['\$0 - \$1,000'],
          selectedEstimatedMonthlyTransaction: '\$0 - \$1,000',
          curruncyList: currencies,
          selectedCurrencies: [],
        ),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      final tileWidget = tester.widget<CustomTileWidget>(find.byType(CustomTileWidget).last);
      expect(tileWidget.showTrailingCheckbox, isTrue);
      expect(tileWidget.isShowTrailing, isTrue);
    });
  });
}
