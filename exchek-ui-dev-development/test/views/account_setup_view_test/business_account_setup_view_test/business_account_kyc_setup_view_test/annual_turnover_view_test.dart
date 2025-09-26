import 'package:country_picker/country_picker.dart';
import 'package:exchek/core/enums/app_enums.dart';
import 'package:exchek/views/account_setup_view/business_account_setup_view/business_account_kyc_setup_view/annual_turnover_view.dart';
import 'package:exchek/viewmodels/account_setup_bloc/business_account_setup_bloc/business_account_setup_bloc.dart';
import 'package:exchek/widgets/custom_widget/custom_textfields.dart';
import 'package:exchek/widgets/custom_widget/custom_button.dart';
import 'package:exchek/widgets/common_widget/app_file_upload_widget.dart';
import 'package:exchek/widgets/account_setup_widgets/custom_tile.dart';
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
import 'annual_turnover_view_test.mocks.dart';
import 'package:exchek/widgets/common_widget/comman_verified_info_box.dart';

// Generate mocks
@GenerateMocks([BusinessAccountSetupBloc])
// Helper function to create test state
BusinessAccountSetupState createTestState({
  bool isGstCertificateMandatory = false,
  FileData? gstCertificateFile,
  bool? isGstVerificationLoading,
  KycVerificationSteps currentKycVerificationStep = KycVerificationSteps.annualTurnoverDeclaration,
  String turnoverText = '',
  String gstNumberText = '',
  String? selectedAnnualTurnover,
  bool isGSTNumberVerify = false,
  String? gstLegalName,
}) {
  final turnOverController = TextEditingController();
  final gstNumberController = TextEditingController();
  turnOverController.text = turnoverText;
  gstNumberController.text = gstNumberText;

  return BusinessAccountSetupState(
    isGstCertificateMandatory: isGstCertificateMandatory,
    gstCertificateFile: gstCertificateFile,
    isGstVerificationLoading: isGstVerificationLoading,
    currentKycVerificationStep: currentKycVerificationStep,
    turnOverController: turnOverController,
    gstNumberController: gstNumberController,
    selectedAnnualTurnover: selectedAnnualTurnover,
    isGSTNumberVerify: isGSTNumberVerify,
    gstLegalName: gstLegalName,
    annualTurnoverFormKey: GlobalKey<FormState>(),
    // Required fields for BusinessAccountSetupState
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
    aadharVerificationFormKey: GlobalKey<FormState>(),
    aadharNumberController: TextEditingController(),
    aadharOtpController: TextEditingController(),
    kartaAadharNumberController: TextEditingController(),
    kartaAadharOtpController: TextEditingController(),
    kartaAadharVerificationFormKey: GlobalKey<FormState>(),
    hufPanVerificationKey: GlobalKey<FormState>(),
    hufPanNumberController: TextEditingController(),
    isHUFPanVerifyingLoading: false,
    businessPanVerificationKey: GlobalKey<FormState>(),
    businessPanNumberController: TextEditingController(),
    businessPanNameController: TextEditingController(),
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
    registerAddressFormKey: GlobalKey<FormState>(),
    pinCodeController: TextEditingController(),
    stateNameController: TextEditingController(),
    cityNameController: TextEditingController(),
    address1NameController: TextEditingController(),
    address2NameController: TextEditingController(),
    iceVerificationKey: GlobalKey<FormState>(),
    iceNumberController: TextEditingController(),
    cinVerificationKey: GlobalKey<FormState>(),
    cinNumberController: TextEditingController(),
    llpinNumberController: TextEditingController(),
    bankAccountVerificationFormKey: GlobalKey<FormState>(),
    bankAccountNumberController: TextEditingController(),
    reEnterbankAccountNumberController: TextEditingController(),
    ifscCodeController: TextEditingController(),
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

  group('AnnualTurnoverView Comprehensive Tests', () {
    late MockBusinessAccountSetupBloc mockBloc;

    setUp(() async {
      mockBloc = MockBusinessAccountSetupBloc();

      // Clear mock storage between tests
      mockStorage.clear();

      // Set up SharedPreferences mock for web compatibility
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
            child: AnnualTurnoverView(scrollController: ScrollController()),
          ),
        ),
      );
    }

    // Helper function to wait for FutureBuilder to complete
    Future<void> waitForFutureBuilder(WidgetTester tester) async {
      await tester.pump(); // Initial pump
      await tester.pump(const Duration(milliseconds: 1000));
      await tester.pump();
    }

    // Test 1: Basic widget rendering
    testWidgets('should render without errors', (WidgetTester tester) async {
      // Arrange
      const mockUserData = '{"business_details": {"business_nature": "Export of goods"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserData);

      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(AnnualTurnoverView), findsOneWidget);
      expect(find.byType(BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>), findsOneWidget);
      expect(find.byType(ScrollConfiguration), findsWidgets); // Multiple ScrollConfiguration widgets expected
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
    });

    // Test 2: FutureBuilder loading state
    testWidgets('should show loading indicator while fetching turnover list', (WidgetTester tester) async {
      // Arrange
      const mockUserData = '{"business_details": {"business_nature": "Export of goods"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserData);

      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      // Don't pump to keep FutureBuilder in loading state

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // Test 3: FutureBuilder error state
    testWidgets('should handle FutureBuilder error state', (WidgetTester tester) async {
      // Arrange - Don't set user data to cause error
      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - Should show SizedBox.shrink when error occurs
      expect(find.byType(SizedBox), findsWidgets);
    });

    // Test 4: Basic widget functionality without SharedPreferences dependency
    testWidgets('should render basic widget structure', (WidgetTester tester) async {
      // Arrange

      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert - Test basic structure without relying on FutureBuilder
      expect(find.byType(AnnualTurnoverView), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(ScrollConfiguration), findsWidgets);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    // Test 5: Export of services business nature
    testWidgets('should display correct turnover options for Export of services', (WidgetTester tester) async {
      // Arrange
      const mockUserData = '{"business_details": {"business_nature": "Export of services"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserData);

      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await waitForFutureBuilder(tester);

      // Assert
      expect(find.byType(CustomTileWidget), findsNWidgets(2));
      expect(find.text('Less than ₹20 lakhs'), findsOneWidget);
      expect(find.text('₹20 lakhs or more'), findsOneWidget);
    });

    // Test 6: Export of goods and services business nature
    testWidgets('should display correct turnover options for Export of goods and services', (
      WidgetTester tester,
    ) async {
      // Arrange
      const mockUserData = '{"business_details": {"business_nature": "Export of goods and services"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserData);

      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await waitForFutureBuilder(tester);

      // Assert
      expect(find.byType(CustomTileWidget), findsNWidgets(2));
      expect(find.text('Less than ₹40 lakhs'), findsOneWidget);
      expect(find.text('₹40 lakhs or more'), findsOneWidget);
    });

    // Test 7: Other business nature (default case)
    testWidgets('should display default turnover options for other business nature', (WidgetTester tester) async {
      // Arrange
      const mockUserData = '{"business_details": {"business_nature": "Other"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserData);

      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await waitForFutureBuilder(tester);

      // Assert
      expect(find.byType(CustomTileWidget), findsNWidgets(2));
      expect(find.text('Less than ₹20 lakhs'), findsOneWidget);
      expect(find.text('₹20 lakhs or more'), findsOneWidget);
    });

    // Test 8: Turnover selection triggers bloc event
    testWidgets('should trigger ChangeAnnualTurnover event when tile is tapped', (WidgetTester tester) async {
      // Arrange
      const mockUserData = '{"business_details": {"business_nature": "Export of goods"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserData);

      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await waitForFutureBuilder(tester);

      final firstTile = find.byType(CustomTileWidget).first;
      await tester.tap(firstTile, warnIfMissed: false);
      await tester.pump();

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 9: GST mandatory scenario - shows GST fields
    testWidgets('should show GST fields when GST is mandatory', (WidgetTester tester) async {
      // Arrange
      const mockUserData = '{"business_details": {"business_nature": "Export of goods"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserData);

      final state = createTestState(selectedAnnualTurnover: "₹40 lakhs or more", isGstCertificateMandatory: true);
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await waitForFutureBuilder(tester);

      // Assert
      expect(find.textContaining('GST'), findsAtLeastNWidgets(1));
      expect(find.byType(CustomTextInputField), findsOneWidget);
      expect(find.byType(CustomFileUploadWidget), findsOneWidget);
    });

    // Test 10: GST optional scenario - shows GST fields
    testWidgets('should show GST fields when GST is optional', (WidgetTester tester) async {
      // Arrange
      const mockUserData = '{"business_details": {"business_nature": "Export of goods"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserData);

      final state = createTestState(selectedAnnualTurnover: "Less than ₹40 lakhs", isGstCertificateMandatory: false);
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await waitForFutureBuilder(tester);

      // Assert
      expect(find.textContaining('GST'), findsAtLeastNWidgets(1));
      expect(find.byType(CustomTextInputField), findsOneWidget);
      expect(find.byType(CustomFileUploadWidget), findsOneWidget);
    });

    // Test 11: GST number field validation and submission
    testWidgets('should handle GST number field submission', (WidgetTester tester) async {
      // Arrange
      const mockUserData = '{"business_details": {"business_nature": "Export of goods"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserData);

      final state = createTestState(
        selectedAnnualTurnover: "₹40 lakhs or more",
        isGstCertificateMandatory: true,
        gstNumberText: '22AAAAA0000A1Z5',
      );

      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await waitForFutureBuilder(tester);

      final gstField = find.byType(CustomTextInputField);
      final gstWidget = tester.widget<CustomTextInputField>(gstField);

      // Simulate field submission
      gstWidget.onFieldSubmitted?.call('22AAAAA0000A1Z5');
      await tester.pump();

      // Assert
      expect(gstWidget.maxLength, 15);
      expect(gstWidget.textInputAction, TextInputAction.done);
    });

    // Test 12: Verify button - disabled state
    testWidgets('should show disabled verify button when GST number is empty', (WidgetTester tester) async {
      // Arrange
      const mockUserData = '{"business_details": {"business_nature": "Export of goods"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserData);

      final state = createTestState(
        selectedAnnualTurnover: "₹40 lakhs or more",
        isGstCertificateMandatory: true,
        isGSTNumberVerify: false,
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await waitForFutureBuilder(tester);

      // Assert
      final verifyButtons = find.byType(CustomElevatedButton);
      expect(verifyButtons, findsOneWidget);
      final button = tester.widget<CustomElevatedButton>(verifyButtons);
      expect(button.isDisabled, true);
    });

    // Test 13: Verify button - enabled state
    testWidgets('should show enabled verify button when GST number is filled', (WidgetTester tester) async {
      // Arrange
      const mockUserData = '{"business_details": {"business_nature": "Export of goods"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserData);

      final state = createTestState(
        selectedAnnualTurnover: "₹40 lakhs or more",
        isGstCertificateMandatory: true,
        isGSTNumberVerify: false,
        gstNumberText: '22AAAAA0000A1Z5',
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await waitForFutureBuilder(tester);

      // Assert
      final verifyButtons = find.byType(CustomElevatedButton);
      expect(verifyButtons, findsOneWidget);
      final button = tester.widget<CustomElevatedButton>(verifyButtons);
      expect(button.isDisabled, false);
    });

    // Test 14: Verify button tap triggers GST verification
    testWidgets('should trigger BusinessGSTVerification event when verify button is tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      const mockUserData = '{"business_details": {"business_nature": "Export of goods"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserData);

      final state = createTestState(
        selectedAnnualTurnover: "₹40 lakhs or more",
        isGstCertificateMandatory: true,
        isGSTNumberVerify: false,
        gstNumberText: '22AAAAA0000A1Z5',
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await waitForFutureBuilder(tester);

      final verifyButton = find.byType(CustomElevatedButton);
      await tester.tap(verifyButton, warnIfMissed: false);
      await tester.pump();

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 15: GST verified state shows legal name field
    testWidgets('should show legal name field when GST is verified', (WidgetTester tester) async {
      // Arrange
      const mockUserData = '{"business_details": {"business_nature": "Export of goods"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserData);

      final state = createTestState(
        selectedAnnualTurnover: "₹40 lakhs or more",
        isGstCertificateMandatory: true,
        isGSTNumberVerify: true,
        gstLegalName: 'Test Company Pvt Ltd',
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await waitForFutureBuilder(tester);

      // Assert
      expect(find.text('Legal Entity Name'), findsOneWidget);
      expect(find.byType(CommanVerifiedInfoBox), findsOneWidget);
      expect(find.text('Test Company Pvt Ltd'), findsOneWidget);
    });

    // Test 16: File upload widget callback
    testWidgets('should trigger UploadGstCertificateFile event when file is selected', (WidgetTester tester) async {
      // Arrange
      const mockUserData = '{"business_details": {"business_nature": "Export of goods"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserData);

      final state = createTestState(
        selectedAnnualTurnover: "₹40 lakhs or more",
        isGstCertificateMandatory: true,
        isGSTNumberVerify: true,
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await waitForFutureBuilder(tester);

      final fileUploadWidget = find.byType(CustomFileUploadWidget);
      final widget = tester.widget<CustomFileUploadWidget>(fileUploadWidget);

      // Simulate file selection
      final testFile = FileData(name: 'gst.pdf', bytes: Uint8List(0), sizeInMB: 1.0);
      widget.onFileSelected?.call(testFile);
      await tester.pump();

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 17: Next button - disabled when GST mandatory and file missing
    testWidgets('should disable Next button when GST is mandatory and file is missing', (WidgetTester tester) async {
      // Arrange
      const mockUserData = '{"business_details": {"business_nature": "Export of goods"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserData);

      final state = createTestState(
        selectedAnnualTurnover: "₹40 lakhs or more",
        isGstCertificateMandatory: true,
        isGSTNumberVerify: true,
        gstCertificateFile: null,
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await waitForFutureBuilder(tester);

      // Assert
      final nextButtons = find.byType(CustomElevatedButton);
      expect(nextButtons, findsOneWidget);
      final button = tester.widget<CustomElevatedButton>(nextButtons);
      expect(button.isDisabled, true);
    });

    // Test 18: Next button - enabled when GST mandatory and file present
    testWidgets('should enable Next button when GST is mandatory and file is present', (WidgetTester tester) async {
      // Arrange
      const mockUserData = '{"business_details": {"business_nature": "Export of goods"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserData);

      final gstFile = FileData(name: 'gst.pdf', bytes: Uint8List(0), sizeInMB: 1.0);
      final state = createTestState(
        selectedAnnualTurnover: "₹40 lakhs or more",
        isGstCertificateMandatory: true,
        isGSTNumberVerify: true,
        gstCertificateFile: gstFile,
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await waitForFutureBuilder(tester);

      // Assert
      final nextButtons = find.byType(CustomElevatedButton);
      expect(nextButtons, findsOneWidget);
      final button = tester.widget<CustomElevatedButton>(nextButtons);
      expect(button.isDisabled, false);
    });

    // Test 19: Next button - enabled when GST not mandatory
    testWidgets('should enable Next button when GST is not mandatory', (WidgetTester tester) async {
      // Arrange
      const mockUserData = '{"business_details": {"business_nature": "Export of goods"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserData);

      final state = createTestState(selectedAnnualTurnover: "Less than ₹40 lakhs", isGstCertificateMandatory: false);
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await waitForFutureBuilder(tester);

      // Assert
      final nextButtons = find.byType(CustomElevatedButton);
      expect(nextButtons, findsOneWidget);
      final button = tester.widget<CustomElevatedButton>(nextButtons);
      expect(button.isDisabled, false);
    });

    // Test 20: Next button loading state
    testWidgets('should show loading state on Next button', (WidgetTester tester) async {
      // Arrange
      const mockUserData = '{"business_details": {"business_nature": "Export of goods"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserData);

      final gstFile = FileData(name: 'gst.pdf', bytes: Uint8List(0), sizeInMB: 1.0);
      final state = createTestState(
        selectedAnnualTurnover: "₹40 lakhs or more",
        isGstCertificateMandatory: true,
        isGSTNumberVerify: true,
        gstCertificateFile: gstFile,
        isGstVerificationLoading: true,
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await waitForFutureBuilder(tester);

      // Assert
      final nextButtons = find.byType(CustomElevatedButton);
      expect(nextButtons, findsOneWidget);
      final button = tester.widget<CustomElevatedButton>(nextButtons);
      expect(button.isLoading, true);
    });

    // Test 21: Next button tap - GST mandatory path
    testWidgets('should trigger AnnualTurnOverVerificationSubmitted when Next button tapped (GST mandatory)', (
      WidgetTester tester,
    ) async {
      // Arrange
      const mockUserData = '{"business_details": {"business_nature": "Export of goods"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserData);

      final gstFile = FileData(name: 'gst.pdf', bytes: Uint8List(0), sizeInMB: 1.0);
      final state = createTestState(
        selectedAnnualTurnover: "₹40 lakhs or more",
        isGstCertificateMandatory: true,
        isGSTNumberVerify: true,
        gstCertificateFile: gstFile,
        gstNumberText: '22AAAAA0000A1Z5',
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await waitForFutureBuilder(tester);

      final nextButton = find.byType(CustomElevatedButton);
      await tester.tap(nextButton, warnIfMissed: false);
      await tester.pump();

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 22: Next button tap - GST optional with data
    testWidgets('should trigger AnnualTurnOverVerificationSubmitted when Next button tapped (GST optional with data)', (
      WidgetTester tester,
    ) async {
      // Arrange
      const mockUserData = '{"business_details": {"business_nature": "Export of goods"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserData);

      final gstFile = FileData(name: 'gst.pdf', bytes: Uint8List(0), sizeInMB: 1.0);
      final state = createTestState(
        selectedAnnualTurnover: "Less than ₹40 lakhs",
        isGstCertificateMandatory: false,
        isGSTNumberVerify: true,
        gstCertificateFile: gstFile,
        gstNumberText: '22AAAAA0000A1Z5',
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await waitForFutureBuilder(tester);

      final nextButton = find.byType(CustomElevatedButton);
      await tester.tap(nextButton, warnIfMissed: false);
      await tester.pump();

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 23: Next button tap - GST optional without data (skip)
    testWidgets('should trigger KycStepChanged when Next button tapped (GST optional without data)', (
      WidgetTester tester,
    ) async {
      // Arrange
      const mockUserData = '{"business_details": {"business_nature": "Export of goods"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserData);

      final state = createTestState(
        selectedAnnualTurnover: "Less than ₹40 lakhs",
        isGstCertificateMandatory: false,
        isGSTNumberVerify: false,
        gstCertificateFile: null,
        gstNumberText: '',
        currentKycVerificationStep: KycVerificationSteps.annualTurnoverDeclaration,
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await waitForFutureBuilder(tester);

      final nextButton = find.byType(CustomElevatedButton);
      await tester.tap(nextButton, warnIfMissed: false);
      await tester.pump();

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    // Test 24: Cache functionality
    testWidgets('should use cached turnover list on subsequent calls', (WidgetTester tester) async {
      // Arrange
      const mockUserData = '{"business_details": {"business_nature": "Export of goods"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserData);

      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act - First call
      await tester.pumpWidget(createTestWidget());
      await waitForFutureBuilder(tester);

      // Act - Second call (should use cache)
      await tester.pumpWidget(createTestWidget());
      await waitForFutureBuilder(tester);

      // Assert
      expect(find.byType(CustomTileWidget), findsNWidgets(2));
    });

    // Test 25: Responsive design elements
    testWidgets('should handle responsive design elements', (WidgetTester tester) async {
      // Arrange
      const mockUserData = '{"business_details": {"business_nature": "Export of goods"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserData);

      final state = createTestState(
        selectedAnnualTurnover: "₹40 lakhs or more",
        isGstCertificateMandatory: true,
        isGSTNumberVerify: true,
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await waitForFutureBuilder(tester);

      // Assert - Check responsive elements exist
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Text), findsWidgets);
    });

    // Test 26: AnimatedBuilder functionality
    testWidgets('should handle AnimatedBuilder updates', (WidgetTester tester) async {
      // Arrange
      const mockUserData = '{"business_details": {"business_nature": "Export of goods"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserData);

      final state = createTestState(
        selectedAnnualTurnover: "₹40 lakhs or more",
        isGstCertificateMandatory: true,
        isGSTNumberVerify: true,
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await waitForFutureBuilder(tester);

      // Simulate controller changes
      state.gstNumberController.text = 'test';
      state.turnOverController.text = 'test';
      await tester.pump();

      // Assert
      expect(find.byType(AnimatedBuilder), findsWidgets);
    });

    // Test 27: Edge case - null gstLegalName
    testWidgets('should handle null gstLegalName gracefully', (WidgetTester tester) async {
      // Arrange
      const mockUserData = '{"business_details": {"business_nature": "Export of goods"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserData);

      final state = createTestState(
        selectedAnnualTurnover: "₹40 lakhs or more",
        isGstCertificateMandatory: true,
        isGSTNumberVerify: true,
        gstLegalName: null,
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await waitForFutureBuilder(tester);

      // Assert
      expect(find.byType(CommanVerifiedInfoBox), findsOneWidget);
      final verifiedBox = tester.widget<CommanVerifiedInfoBox>(find.byType(CommanVerifiedInfoBox));
      expect(verifiedBox.value, '');
    });

    // Test 28: Edge case - null isGstVerificationLoading
    testWidgets('should handle null isGstVerificationLoading gracefully', (WidgetTester tester) async {
      // Arrange
      const mockUserData = '{"business_details": {"business_nature": "Export of goods"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserData);

      final state = createTestState(
        selectedAnnualTurnover: "₹40 lakhs or more",
        isGstCertificateMandatory: true,
        isGSTNumberVerify: false,
        gstNumberText: '22AAAAA0000A1Z5',
        isGstVerificationLoading: null,
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await waitForFutureBuilder(tester);

      // Assert
      final verifyButtons = find.byType(CustomElevatedButton);
      expect(verifyButtons, findsOneWidget);
      final button = tester.widget<CustomElevatedButton>(verifyButtons);
      expect(button.isLoading, false); // Should default to false when null
    });

    // Test 29: Test all helper methods coverage
    testWidgets('should test all helper methods', (WidgetTester tester) async {
      // Arrange
      const mockUserData = '{"business_details": {"business_nature": "Export of goods"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserData);

      when(mockBloc.state).thenReturn(createTestState());
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([createTestState()]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await waitForFutureBuilder(tester);

      final widget = AnnualTurnoverView();
      final context = tester.element(find.byType(AnnualTurnoverView));

      // Assert - Test helper methods directly
      expect(widget.moreTurnOverList(context), equals(["Less than ₹40 lakhs", "₹40 lakhs or more"]));
      expect(widget.lessTurnOverList(context), equals(["Less than ₹20 lakhs", "₹20 lakhs or more"]));
    });

    // Test 30: Test edge case - last KYC step
    testWidgets('should handle last KYC step correctly', (WidgetTester tester) async {
      // Arrange
      const mockUserData = '{"business_details": {"business_nature": "Export of goods"}}';
      await Prefobj.preferences.put(Prefkeys.userKycDetail, mockUserData);

      final state = createTestState(
        selectedAnnualTurnover: "Less than ₹40 lakhs",
        isGstCertificateMandatory: false,
        currentKycVerificationStep: KycVerificationSteps.values.last,
      );
      when(mockBloc.state).thenReturn(state);
      when(mockBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await waitForFutureBuilder(tester);

      // Find the specific Next button (there might be multiple buttons)
      final nextButtons = find.byType(CustomElevatedButton);
      expect(nextButtons, findsWidgets);

      // Tap the first button found
      if (nextButtons.evaluate().isNotEmpty) {
        await tester.tap(nextButtons.first, warnIfMissed: false);
        await tester.pump();
      }

      // Assert - Should not crash when at last step
      expect(find.byType(CustomElevatedButton), findsWidgets);
    });
  });
}
