import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/viewmodels/account_setup_bloc/account_type_selection/account_type_selection_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:country_picker/country_picker.dart';

@GenerateMocks([BusinessAccountSetupBloc, AccountTypeBloc])
import 'business_account_setup_view_test.mocks.dart';

// Mock GoRouter
class MockGoRouter extends Mock implements GoRouter {
  @override
  Future<T?> push<T extends Object?>(String location, {Object? extra}) async {
    return null;
  }

  @override
  void go(String location, {Object? extra}) {}

  @override
  void pop<T extends Object?>([T? result]) {}
}

// Helper function to create a complete BusinessAccountSetupState for testing
BusinessAccountSetupState createTestBusinessAccountSetupState({BusinessAccountSetupSteps? currentStep}) {
  return BusinessAccountSetupState(
    currentStep: currentStep ?? BusinessAccountSetupSteps.businessEntity,
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
  group('BusinessAccountSetupView Widget Tests', () {
    late MockBusinessAccountSetupBloc mockBusinessAccountSetupBloc;
    late MockAccountTypeBloc mockAccountTypeBloc;
    late MockGoRouter mockGoRouter;

    setUp(() {
      mockBusinessAccountSetupBloc = MockBusinessAccountSetupBloc();
      mockAccountTypeBloc = MockAccountTypeBloc();
      mockGoRouter = MockGoRouter();

      // Set up default stubs for stream properties
      when(mockBusinessAccountSetupBloc.stream).thenAnswer((_) => Stream<BusinessAccountSetupState>.empty());
      when(mockAccountTypeBloc.stream).thenAnswer((_) => Stream<AccountTypeState>.empty());
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
        home: InheritedGoRouter(
          goRouter: mockGoRouter,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<BusinessAccountSetupBloc>.value(value: mockBusinessAccountSetupBloc),
              BlocProvider<AccountTypeBloc>.value(value: mockAccountTypeBloc),
            ],
            child: BusinessAccountSetupView(),
          ),
        ),
      );
    }

    testWidgets('should display app bar with correct title', (WidgetTester tester) async {
      // Arrange
      when(
        mockBusinessAccountSetupBloc.state,
      ).thenReturn(createTestBusinessAccountSetupState(currentStep: BusinessAccountSetupSteps.businessEntity));
      when(mockAccountTypeBloc.state).thenReturn(const AccountTypeState(isLoading: false));

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(ExchekAppBar), findsOneWidget);
    });

    testWidgets('should display loading widget when account type is loading', (WidgetTester tester) async {
      // Arrange
      when(
        mockBusinessAccountSetupBloc.state,
      ).thenReturn(createTestBusinessAccountSetupState(currentStep: BusinessAccountSetupSteps.businessEntity));
      when(mockAccountTypeBloc.state).thenReturn(const AccountTypeState(isLoading: true));

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(AppLoaderWidget), findsOneWidget);
    });

    testWidgets('should display StepperSlider with correct current step', (WidgetTester tester) async {
      // Arrange
      when(
        mockBusinessAccountSetupBloc.state,
      ).thenReturn(createTestBusinessAccountSetupState(currentStep: BusinessAccountSetupSteps.businessInformation));
      when(mockAccountTypeBloc.state).thenReturn(const AccountTypeState(isLoading: false));

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(StepperSlider<BusinessAccountSetupSteps>), findsOneWidget);
    });

    // testWidgets('should display GetHelpTextButton', (WidgetTester tester) async {
    //   // Arrange
    //   when(
    //     mockBusinessAccountSetupBloc.state,
    //   ).thenReturn(createTestBusinessAccountSetupState(currentStep: BusinessAccountSetupSteps.businessEntity));
    //   when(mockAccountTypeBloc.state).thenReturn(const AccountTypeState(isLoading: false));

    //   // Act
    //   await tester.pumpWidget(createTestWidget());

    //   // Assert
    //   expect(find.byType(GetHelpTextButton), findsOneWidget);
    // });

    // testWidgets('should trigger ResetData event on widget build', (WidgetTester tester) async {
    //   // Arrange
    //   when(
    //     mockBusinessAccountSetupBloc.state,
    //   ).thenReturn(createTestBusinessAccountSetupState(currentStep: BusinessAccountSetupSteps.businessEntity));
    //   when(mockAccountTypeBloc.state).thenReturn(const AccountTypeState(isLoading: false));

    //   // Act
    //   await tester.pumpWidget(createTestWidget());
    //   await tester.pumpAndSettle();

    //   // Assert
    //   verify(mockBusinessAccountSetupBloc.add(any)).called(greaterThan(0));
    // });

    group('Back Navigation Tests', () {
      testWidgets('should navigate to previous step when not on first step', (WidgetTester tester) async {
        // Arrange
        when(
          mockBusinessAccountSetupBloc.state,
        ).thenReturn(createTestBusinessAccountSetupState(currentStep: BusinessAccountSetupSteps.businessInformation));
        when(mockAccountTypeBloc.state).thenReturn(const AccountTypeState(isLoading: false));

        // Act
        await tester.pumpWidget(createTestWidget());
        final appBar = tester.widget<ExchekAppBar>(find.byType(ExchekAppBar));
        appBar.onBackPressed?.call();

        // Assert
        verify(mockBusinessAccountSetupBloc.add(StepChanged(BusinessAccountSetupSteps.businessEntity))).called(1);
      });

      // testWidgets('should reset data and navigate back when on first step', (WidgetTester tester) async {
      //   // Arrange
      //   when(
      //     mockBusinessAccountSetupBloc.state,
      //   ).thenReturn(createTestBusinessAccountSetupState(currentStep: BusinessAccountSetupSteps.businessEntity));
      //   when(mockAccountTypeBloc.state).thenReturn(const AccountTypeState(isLoading: false));

      //   // Act
      //   await tester.pumpWidget(createTestWidget());
      //   final appBar = tester.widget<ExchekAppBar>(find.byType(ExchekAppBar));
      //   appBar.onBackPressed?.call();

      //   // Assert
      //   verify(mockBusinessAccountSetupBloc.add(ResetData())).called(greaterThan(0));
      // });
    });

    group('Step Title Tests', () {
      testWidgets('should return correct title for business entity step', (WidgetTester tester) async {
        // Arrange
        when(
          mockBusinessAccountSetupBloc.state,
        ).thenReturn(createTestBusinessAccountSetupState(currentStep: BusinessAccountSetupSteps.businessEntity));
        when(mockAccountTypeBloc.state).thenReturn(const AccountTypeState(isLoading: false));

        final widget = BusinessAccountSetupView();

        // Act
        await tester.pumpWidget(createTestWidget());
        final context = tester.element(find.byType(BusinessAccountSetupView));

        // Assert
        expect(widget.getStepTitle(context: context, step: BusinessAccountSetupSteps.businessEntity), isNotEmpty);
      });

      testWidgets('should return correct title for business information step', (WidgetTester tester) async {
        // Arrange
        when(
          mockBusinessAccountSetupBloc.state,
        ).thenReturn(createTestBusinessAccountSetupState(currentStep: BusinessAccountSetupSteps.businessInformation));
        when(mockAccountTypeBloc.state).thenReturn(const AccountTypeState(isLoading: false));

        final widget = BusinessAccountSetupView();

        // Act
        await tester.pumpWidget(createTestWidget());
        final context = tester.element(find.byType(BusinessAccountSetupView));

        // Assert
        expect(widget.getStepTitle(context: context, step: BusinessAccountSetupSteps.businessInformation), isNotEmpty);
      });
    });
  });
}
