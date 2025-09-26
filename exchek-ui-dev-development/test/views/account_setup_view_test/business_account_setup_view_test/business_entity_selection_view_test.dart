import 'package:exchek/core/utils/exports.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([BusinessAccountSetupBloc])
import 'business_entity_selection_view_test.mocks.dart';

BusinessAccountSetupState createTestState({
  String? selectedBusinessEntityType,
  BusinessMainActivity? selectedBusinessMainActivity,
  List<String>? selectedbusinessGoodsExportType,
  BusinessAccountSetupSteps? currentStep,
}) {
  return BusinessAccountSetupState(
    currentStep: currentStep ?? BusinessAccountSetupSteps.businessEntity,
    selectedBusinessEntityType: selectedBusinessEntityType,
    selectedBusinessMainActivity: selectedBusinessMainActivity,
    selectedbusinessGoodsExportType: selectedbusinessGoodsExportType,
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
  group('BusinessEntitySelectionView Widget Tests', () {
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
              height: 2000, // Provide enough height to prevent overflow
              child: BlocProvider<BusinessAccountSetupBloc>.value(
                value: mockBloc,
                child: const BusinessEntitySelectionView(),
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('should display business entity selection title and description', (WidgetTester tester) async {
      // Arrange
      when(
        mockBloc.state,
      ).thenReturn(createTestState(selectedBusinessEntityType: null, selectedBusinessMainActivity: null));

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.textContaining('Which type of business entity do you have'), findsAtLeastNWidgets(1));
    });

    testWidgets('should display all business entity types', (WidgetTester tester) async {
      // Arrange
      when(
        mockBloc.state,
      ).thenReturn(createTestState(selectedBusinessEntityType: null, selectedBusinessMainActivity: null));

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(CustomTileWidget), findsAtLeastNWidgets(5)); // 5 business entity types
    });

    testWidgets('should display business main activity section', (WidgetTester tester) async {
      // Arrange
      when(
        mockBloc.state,
      ).thenReturn(createTestState(selectedBusinessEntityType: 'Company', selectedBusinessMainActivity: null));

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.textContaining('How would you describe about your nature of business'), findsAtLeastNWidgets(1));
    });

    testWidgets('should display Next button', (WidgetTester tester) async {
      // Arrange
      when(
        mockBloc.state,
      ).thenReturn(createTestState(selectedBusinessEntityType: null, selectedBusinessMainActivity: null));

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(CustomElevatedButton), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
    });

    testWidgets('should disable Next button when no selections made', (WidgetTester tester) async {
      // Arrange
      when(
        mockBloc.state,
      ).thenReturn(createTestState(selectedBusinessEntityType: null, selectedBusinessMainActivity: null));

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
      expect(button.isDisabled, isTrue);
    });

    testWidgets('should enable Next button when all required selections made', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          selectedBusinessEntityType: 'Company',
          selectedBusinessMainActivity: BusinessMainActivity.exportGoods,
          selectedbusinessGoodsExportType: ['Electronics'],
        ),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
      expect(button.isDisabled, isFalse);
    });

    testWidgets('should trigger ChangeBusinessEntityType event when entity tile tapped', (WidgetTester tester) async {
      // Arrange
      when(
        mockBloc.state,
      ).thenReturn(createTestState(selectedBusinessEntityType: null, selectedBusinessMainActivity: null));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.tap(find.byType(CustomTileWidget).first);

      // Assert
      verify(mockBloc.add(any)).called(greaterThan(0));
    });

    testWidgets('should show text field for Others option in business activity', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          selectedBusinessEntityType: 'Company',
          selectedBusinessMainActivity: BusinessMainActivity.others,
        ),
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(TextField), findsAtLeastNWidgets(1));
    });

    testWidgets('should display export goods section when export goods selected', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          selectedBusinessEntityType: 'Company',
          selectedBusinessMainActivity: BusinessMainActivity.exportGoods,
        ),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('Export of goods'), findsAtLeastNWidgets(1));
    });

    testWidgets('should display export services section when export services selected', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          selectedBusinessEntityType: 'Company',
          selectedBusinessMainActivity: BusinessMainActivity.exportService,
        ),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('Export of services'), findsAtLeastNWidgets(1));
    });

    // testWidgets('should display both goods and services section when both selected', (WidgetTester tester) async {
    //   // Arrange
    //   when(mockBloc.state).thenReturn(
    //     createTestState(
    //       selectedBusinessEntityType: 'Company',
    //       selectedBusinessMainActivity: BusinessMainActivity.exportBoth,
    //     ),
    //   );

    //   // Act
    //   await tester.pumpWidget(createTestWidget());

    //   // Assert
    //   expect(find.textContaining('Export of goods and services'), findsAtLeastNWidgets(1));
    //   expect(find.byType(TextField), findsAtLeastNWidgets(1));
    // });

    testWidgets('should trigger StepChanged event when Next button pressed', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenReturn(
        createTestState(
          selectedBusinessEntityType: 'Company',
          selectedBusinessMainActivity: BusinessMainActivity.exportGoods,
          selectedbusinessGoodsExportType: ['Electronics'],
          currentStep: BusinessAccountSetupSteps.businessEntity,
        ),
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Scroll to make the button visible
      await tester.scrollUntilVisible(find.text('Next'), 500.0);
      await tester.tap(find.text('Next'), warnIfMissed: false);
      await tester.pumpAndSettle();

      // Assert - Use the pattern from your reference
      verify(mockBloc.add(any)).called(greaterThan(0));
    });
  });
}
