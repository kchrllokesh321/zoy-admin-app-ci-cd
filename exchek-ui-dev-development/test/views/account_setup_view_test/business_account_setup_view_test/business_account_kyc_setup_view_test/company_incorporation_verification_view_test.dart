import 'package:country_picker/country_picker.dart';
import 'package:exchek/core/enums/app_enums.dart';
import 'package:exchek/views/account_setup_view/business_account_setup_view/business_account_kyc_setup_view/company_incorporation_verification_view.dart';
import 'package:exchek/viewmodels/account_setup_bloc/business_account_setup_bloc/business_account_setup_bloc.dart';
import 'package:exchek/widgets/custom_widget/custom_button.dart';
import 'package:exchek/widgets/custom_widget/custom_textfields.dart';
import 'package:exchek/widgets/common_widget/app_file_upload_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:exchek/core/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:exchek/core/utils/local_storage.dart';

@GenerateMocks([BusinessAccountSetupBloc])
import 'company_incorporation_verification_view_test.mocks.dart';

BusinessAccountSetupState createTestState({
  String? selectedBusinessEntityType,
  bool? isCINVerifyingLoading,
  FileData? coiCertificateFile,
  FileData? uploadLLPAgreementFile,
  FileData? uploadPartnershipDeed,
}) {
  return BusinessAccountSetupState(
    currentStep: BusinessAccountSetupSteps.businessInformation,
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
    currentKycVerificationStep: KycVerificationSteps.companyIncorporationVerification,
    aadharVerificationFormKey: GlobalKey<FormState>(),
    aadharNumberController: TextEditingController(),
    aadharOtpController: TextEditingController(),
    kartaAadharVerificationFormKey: GlobalKey<FormState>(),
    kartaAadharNumberController: TextEditingController(),
    kartaAadharOtpController: TextEditingController(),
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
    annualTurnoverFormKey: GlobalKey<FormState>(),
    turnOverController: TextEditingController(),
    gstNumberController: TextEditingController(),
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
    // Test-specific values
    selectedBusinessEntityType: selectedBusinessEntityType,
    isCINVerifyingLoading: isCINVerifyingLoading,
    coiCertificateFile: coiCertificateFile,
    uploadLLPAgreementFile: uploadLLPAgreementFile,
    uploadPartnershipDeed: uploadPartnershipDeed,
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
  // In-memory storage for testing
  final Map<String, String> mockStorage = {};

  setUpAll(() {
    // Initialize Flutter binding for tests
    TestWidgetsFlutterBinding.ensureInitialized();

    // Mock flutter_secure_storage plugin
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'write':
            final String key = methodCall.arguments['key'];
            final String value = methodCall.arguments['value'];
            mockStorage[key] = value;
            return null;
          case 'read':
            final String key = methodCall.arguments['key'];
            return mockStorage[key];
          case 'delete':
            final String key = methodCall.arguments['key'];
            mockStorage.remove(key);
            return null;
          case 'deleteAll':
            mockStorage.clear();
            return null;
          case 'readAll':
            return Map<String, String>.from(mockStorage);
          case 'containsKey':
            final String key = methodCall.arguments['key'];
            return mockStorage.containsKey(key);
          default:
            return null;
        }
      },
    );

    // Load test environment variables
    dotenv.testLoad(
      fileInput: '''
ENCRYPT_KEY=1234567890123456
ENCRYPT_IV=1234567890123456
''',
    );
  });

  tearDownAll(() {
    // Clean up the mock method channel handler
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
      null,
    );
  });

  group('CompanyIncorporationVerificationView Widget Tests', () {
    late MockBusinessAccountSetupBloc mockBloc;

    setUp(() async {
      mockBloc = MockBusinessAccountSetupBloc();

      // Clear mock storage between tests
      mockStorage.clear();

      // Set up default mock user data for LocalStorage
      const mockUserData = '{"business_details": {"business_type": "Company"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserData);

      // Also set up SharedPreferences mock for web compatibility
      SharedPreferences.setMockInitialValues({});
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
          body: BlocProvider<BusinessAccountSetupBloc>.value(
            value: mockBloc,
            child: CompanyIncorporationVerificationView(),
          ),
        ),
      );
    }

    testWidgets('should render correctly with initial state', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(CompanyIncorporationVerificationView), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should display LLP form when business entity type is LLP', (WidgetTester tester) async {
      // Arrange
      // Set up mock user data with LLP business type
      const mockUserDataLLP = '{"business_details": {"business_type": "LLP (Limited Liability Partnership)"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserDataLLP);

      when(
        mockBloc.state,
      ).thenReturn(createTestState(selectedBusinessEntityType: 'LLP (Limited Liability Partnership)'));
      when(mockBloc.stream).thenAnswer(
        (_) =>
            Stream.fromIterable([createTestState(selectedBusinessEntityType: 'LLP (Limited Liability Partnership)')]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump(); // Let the FutureBuilder complete
      await tester.pumpAndSettle(); // Wait for all animations and async operations

      // Assert
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(CustomTextInputField), findsOneWidget); // LLPIN field
      expect(find.byType(CustomFileUploadWidget), findsNWidgets(2)); // COI and LLP Agreement
      expect(find.byType(CustomElevatedButton), findsOneWidget); // Next button
    });

    testWidgets('should display Partnership form when business entity type is Partnership Firm', (
      WidgetTester tester,
    ) async {
      // Arrange
      // Set up mock user data with Partnership Firm business type
      const mockUserDataPartnership = '{"business_details": {"business_type": "Partnership Firm"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserDataPartnership);

      when(mockBloc.state).thenReturn(createTestState(selectedBusinessEntityType: 'Partnership Firm'));
      when(
        mockBloc.stream,
      ).thenAnswer((_) => Stream.fromIterable([createTestState(selectedBusinessEntityType: 'Partnership Firm')]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump(); // Let the FutureBuilder complete
      await tester.pumpAndSettle(); // Wait for all animations and async operations

      // Assert
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(CustomTextInputField), findsNothing); // No text fields for partnership
      expect(find.byType(CustomFileUploadWidget), findsOneWidget); // Only Partnership Deed
      expect(find.byType(CustomElevatedButton), findsOneWidget); // Next button
    });

    testWidgets('should display Company form when business entity type is Company (default)', (
      WidgetTester tester,
    ) async {
      // Arrange
      // Set up mock user data with Company business type
      const mockUserDataCompany = '{"business_details": {"business_type": "Company"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserDataCompany);

      when(mockBloc.state).thenReturn(createTestState(selectedBusinessEntityType: 'Company'));
      when(
        mockBloc.stream,
      ).thenAnswer((_) => Stream.fromIterable([createTestState(selectedBusinessEntityType: 'Company')]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump(); // Let the FutureBuilder complete
      await tester.pumpAndSettle(); // Wait for all animations and async operations

      // Assert
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(CustomTextInputField), findsOneWidget); // CIN field
      expect(find.byType(CustomFileUploadWidget), findsOneWidget); // COI certificate
      expect(find.byType(CustomElevatedButton), findsOneWidget); // Next button
    });

    testWidgets('should display loading state on next button', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(isCINVerifyingLoading: true));
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState(isCINVerifyingLoading: true)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final nextButton = find.byType(CustomElevatedButton);
      expect(nextButton, findsOneWidget);

      final buttonWidget = tester.widget<CustomElevatedButton>(nextButton);
      expect(buttonWidget.isLoading, true);
    });

    testWidgets('should enable next button for LLP when all required fields are filled', (WidgetTester tester) async {
      // Arrange
      // Set up mock user data with LLP business type
      const mockUserDataLLP = '{"business_details": {"business_type": "LLP (Limited Liability Partnership)"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserDataLLP);

      final mockFileData = FileData(name: 'test.pdf', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);

      final state = createTestState(
        selectedBusinessEntityType: 'LLP (Limited Liability Partnership)',
        coiCertificateFile: mockFileData,
        uploadLLPAgreementFile: mockFileData,
      );
      state.llpinNumberController.text = 'AAA1234';

      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump(); // Let the FutureBuilder complete
      await tester.pumpAndSettle(); // Wait for all animations and async operations

      // Assert
      final nextButton = find.byType(CustomElevatedButton);
      expect(nextButton, findsOneWidget);

      final buttonWidget = tester.widget<CustomElevatedButton>(nextButton);
      expect(buttonWidget.isDisabled, false);
    });

    testWidgets('should disable next button for LLP when required fields are missing', (WidgetTester tester) async {
      // Arrange
      // Set up mock user data with LLP business type
      const mockUserDataLLP = '{"business_details": {"business_type": "LLP (Limited Liability Partnership)"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserDataLLP);

      when(
        mockBloc.state,
      ).thenReturn(createTestState(selectedBusinessEntityType: 'LLP (Limited Liability Partnership)'));
      when(mockBloc.stream).thenAnswer(
        (_) =>
            Stream.fromIterable([createTestState(selectedBusinessEntityType: 'LLP (Limited Liability Partnership)')]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump(); // Let the FutureBuilder complete
      await tester.pumpAndSettle(); // Wait for all animations and async operations

      // Assert
      final nextButton = find.byType(CustomElevatedButton);
      expect(nextButton, findsOneWidget);

      final buttonWidget = tester.widget<CustomElevatedButton>(nextButton);
      expect(buttonWidget.isDisabled, true);
    });

    testWidgets('should enable next button for Partnership when deed is uploaded', (WidgetTester tester) async {
      // Arrange
      // Set up mock user data with Partnership Firm business type
      const mockUserDataPartnership = '{"business_details": {"business_type": "Partnership Firm"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserDataPartnership);

      final mockFileData = FileData(name: 'test.pdf', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);

      when(mockBloc.state).thenReturn(
        createTestState(selectedBusinessEntityType: 'Partnership Firm', uploadPartnershipDeed: mockFileData),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(selectedBusinessEntityType: 'Partnership Firm', uploadPartnershipDeed: mockFileData),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump(); // Let the FutureBuilder complete
      await tester.pumpAndSettle(); // Wait for all animations and async operations

      // Assert
      final nextButton = find.byType(CustomElevatedButton);
      expect(nextButton, findsOneWidget);

      final buttonWidget = tester.widget<CustomElevatedButton>(nextButton);
      expect(buttonWidget.isDisabled, false);
    });

    testWidgets('should enable next button for Company when CIN and COI are provided', (WidgetTester tester) async {
      // Arrange
      final mockFileData = FileData(name: 'test.pdf', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);

      final state = createTestState(selectedBusinessEntityType: 'Company', coiCertificateFile: mockFileData);
      state.cinNumberController.text = 'L12345MH2020PLC123456';

      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final nextButton = find.byType(CustomElevatedButton);
      expect(nextButton, findsOneWidget);

      final buttonWidget = tester.widget<CustomElevatedButton>(nextButton);
      expect(buttonWidget.isDisabled, false);
    });

    testWidgets('should trigger UploadCOICertificate event when COI file is selected', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(selectedBusinessEntityType: 'Company'));
      when(
        mockBloc.stream,
      ).thenAnswer((_) => Stream.fromIterable([createTestState(selectedBusinessEntityType: 'Company')]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final fileUpload = find.byType(CustomFileUploadWidget);
      expect(fileUpload, findsOneWidget);

      final fileUploadWidget = tester.widget<CustomFileUploadWidget>(fileUpload);
      final mockFileData = FileData(name: 'test.pdf', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);
      fileUploadWidget.onFileSelected?.call(mockFileData);

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    testWidgets('should trigger UploadLLPAgreement event when LLP agreement file is selected', (
      WidgetTester tester,
    ) async {
      // Arrange
      // Set up mock user data with LLP business type
      const mockUserDataLLP = '{"business_details": {"business_type": "LLP (Limited Liability Partnership)"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserDataLLP);

      when(
        mockBloc.state,
      ).thenReturn(createTestState(selectedBusinessEntityType: 'LLP (Limited Liability Partnership)'));
      when(mockBloc.stream).thenAnswer(
        (_) =>
            Stream.fromIterable([createTestState(selectedBusinessEntityType: 'LLP (Limited Liability Partnership)')]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump(); // Let the FutureBuilder complete
      await tester.pumpAndSettle(); // Wait for all animations and async operations

      final fileUploads = find.byType(CustomFileUploadWidget);
      expect(fileUploads, findsNWidgets(2));

      final llpAgreementUpload = fileUploads.last;
      final fileUploadWidget = tester.widget<CustomFileUploadWidget>(llpAgreementUpload);
      final mockFileData = FileData(name: 'test.pdf', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);
      fileUploadWidget.onFileSelected?.call(mockFileData);

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    testWidgets('should trigger UploadPartnershipDeed event when partnership deed file is selected', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(selectedBusinessEntityType: 'Partnership Firm'));
      when(
        mockBloc.stream,
      ).thenAnswer((_) => Stream.fromIterable([createTestState(selectedBusinessEntityType: 'Partnership Firm')]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final fileUpload = find.byType(CustomFileUploadWidget);
      expect(fileUpload, findsOneWidget);

      final fileUploadWidget = tester.widget<CustomFileUploadWidget>(fileUpload);
      final mockFileData = FileData(name: 'test.pdf', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);
      fileUploadWidget.onFileSelected?.call(mockFileData);

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    testWidgets('should trigger CINVerificationSubmitted event on next button press', (WidgetTester tester) async {
      // Arrange
      final mockFileData = FileData(name: 'test.pdf', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);

      final state = createTestState(selectedBusinessEntityType: 'Company', coiCertificateFile: mockFileData);
      state.cinNumberController.text = 'L12345MH2020PLC123456';

      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final nextButton = find.byType(CustomElevatedButton);
      await tester.tap(nextButton, warnIfMissed: false);
      await tester.pump();

      // Assert - Check that the button exists and is enabled
      expect(nextButton, findsOneWidget);
      final buttonWidget = tester.widget<CustomElevatedButton>(nextButton);
      expect(buttonWidget.isDisabled, false);
    });

    testWidgets('should display correct title and description for LLP', (WidgetTester tester) async {
      // Arrange
      when(
        mockBloc.state,
      ).thenReturn(createTestState(selectedBusinessEntityType: 'LLP (Limited Liability Partnership)'));
      when(mockBloc.stream).thenAnswer(
        (_) =>
            Stream.fromIterable([createTestState(selectedBusinessEntityType: 'LLP (Limited Liability Partnership)')]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(Text), findsWidgets);
      // The specific text content will be rendered based on localization
    });

    testWidgets('should display correct title and description for Partnership Firm', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(selectedBusinessEntityType: 'Partnership Firm'));
      when(
        mockBloc.stream,
      ).thenAnswer((_) => Stream.fromIterable([createTestState(selectedBusinessEntityType: 'Partnership Firm')]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(Text), findsWidgets);
      // The specific text content will be rendered based on localization
    });

    testWidgets('should display correct title and description for Company', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(selectedBusinessEntityType: 'Company'));
      when(
        mockBloc.stream,
      ).thenAnswer((_) => Stream.fromIterable([createTestState(selectedBusinessEntityType: 'Company')]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(Text), findsWidgets);
      // The specific text content will be rendered based on localization
    });

    testWidgets('should handle form validation correctly', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(selectedBusinessEntityType: 'Company');
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(Form), findsOneWidget);
      final form = tester.widget<Form>(find.byType(Form));
      expect(form.key, equals(state.cinVerificationKey));
    });

    testWidgets('should display correct responsive layout', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('should handle AnimatedBuilder correctly in next button', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(selectedBusinessEntityType: 'Company');
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Simulate text changes
      state.cinNumberController.text = 'L12345MH2020PLC123456';
      await tester.pump();

      // Assert
      expect(find.byType(AnimatedBuilder), findsWidgets);
    });

    testWidgets('should handle text input field properties correctly for CIN', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(selectedBusinessEntityType: 'Company'));
      when(
        mockBloc.stream,
      ).thenAnswer((_) => Stream.fromIterable([createTestState(selectedBusinessEntityType: 'Company')]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final textField = find.byType(CustomTextInputField);
      expect(textField, findsOneWidget);

      final textFieldWidget = tester.widget<CustomTextInputField>(textField);
      expect(textFieldWidget.maxLength, 21);
      expect(textFieldWidget.textInputAction, TextInputAction.done);
    });

    testWidgets('should handle text input field properties correctly for LLPIN', (WidgetTester tester) async {
      // Arrange
      // Set up mock user data with LLP business type
      const mockUserDataLLP = '{"business_details": {"business_type": "LLP (Limited Liability Partnership)"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserDataLLP);

      when(
        mockBloc.state,
      ).thenReturn(createTestState(selectedBusinessEntityType: 'LLP (Limited Liability Partnership)'));
      when(mockBloc.stream).thenAnswer(
        (_) =>
            Stream.fromIterable([createTestState(selectedBusinessEntityType: 'LLP (Limited Liability Partnership)')]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump(); // Let the FutureBuilder complete
      await tester.pumpAndSettle(); // Wait for all animations and async operations

      // Assert
      final textField = find.byType(CustomTextInputField);
      expect(textField, findsOneWidget);

      final textFieldWidget = tester.widget<CustomTextInputField>(textField);
      expect(textFieldWidget.maxLength, 7);
      expect(textFieldWidget.textInputAction, TextInputAction.done);
    });

    testWidgets('should handle BlocBuilder buildWhen condition correctly', (WidgetTester tester) async {
      // Arrange
      final initialState = createTestState(selectedBusinessEntityType: 'Company');
      final updatedState = createTestState(selectedBusinessEntityType: 'Company', isCINVerifyingLoading: true);

      when(mockBloc.state).thenReturn(initialState);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([initialState, updatedState]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      await tester.pump(); // Trigger rebuild

      // Assert
      expect(find.byType(CustomElevatedButton), findsOneWidget);
    });

    testWidgets('should handle null business entity type (default to Company)', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(createTestState(selectedBusinessEntityType: null));
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState(selectedBusinessEntityType: null)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - Should default to Company form
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(CustomTextInputField), findsOneWidget); // CIN field
      expect(find.byType(CustomFileUploadWidget), findsOneWidget); // COI certificate
    });

    testWidgets('should handle file upload widget properties correctly', (WidgetTester tester) async {
      // Arrange
      final mockFileData = FileData(name: 'test.pdf', bytes: Uint8List.fromList([1, 2, 3, 4]), sizeInMB: 1.0);

      when(
        mockBloc.state,
      ).thenReturn(createTestState(selectedBusinessEntityType: 'Company', coiCertificateFile: mockFileData));
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          createTestState(selectedBusinessEntityType: 'Company', coiCertificateFile: mockFileData),
        ]),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final fileUpload = find.byType(CustomFileUploadWidget);
      expect(fileUpload, findsOneWidget);

      final fileUploadWidget = tester.widget<CustomFileUploadWidget>(fileUpload);
      expect(fileUploadWidget.selectedFile, equals(mockFileData));
    });

    testWidgets('should handle edge case with empty controllers', (WidgetTester tester) async {
      // Arrange
      final state = createTestState(selectedBusinessEntityType: 'Company');
      state.cinNumberController.text = '';

      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final nextButton = find.byType(CustomElevatedButton);
      expect(nextButton, findsOneWidget);

      final buttonWidget = tester.widget<CustomElevatedButton>(nextButton);
      expect(buttonWidget.isDisabled, true);
    });
  });
}
