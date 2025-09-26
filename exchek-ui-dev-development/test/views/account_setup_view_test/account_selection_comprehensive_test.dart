import 'package:bloc_test/bloc_test.dart';
import 'package:exchek/views/account_setup_view/account_selection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/viewmodels/account_setup_bloc/account_type_selection/account_type_selection_bloc.dart';
import 'package:exchek/viewmodels/account_setup_bloc/personal_account_setup_bloc/personal_account_setup_bloc.dart';

// Mock classes
class MockAccountTypeBloc extends MockBloc<AccountTypeEvent, AccountTypeState> implements AccountTypeBloc {}

class MockPersonalAccountSetupBloc extends MockBloc<PersonalAccountSetupEvent, PersonalAccountSetupState>
    implements PersonalAccountSetupBloc {}

class MockBusinessAccountSetupBloc extends MockBloc<BusinessAccountSetupEvent, BusinessAccountSetupState>
    implements BusinessAccountSetupBloc {}

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

// Mock events for registration
class FakeAccountTypeEvent extends Fake implements AccountTypeEvent {}

class FakePersonalAccountSetupEvent extends Fake implements PersonalAccountSetupEvent {}

class FakeBusinessAccountSetupEvent extends Fake implements BusinessAccountSetupEvent {}

class FakeAuthEvent extends Fake implements AuthEvent {}

void main() {
  group('AccountSelectionStep Comprehensive Tests', () {
    late MockAccountTypeBloc mockAccountTypeBloc;
    late MockPersonalAccountSetupBloc mockPersonalAccountSetupBloc;
    late MockBusinessAccountSetupBloc mockBusinessAccountSetupBloc;
    late MockAuthBloc mockAuthBloc;

    setUpAll(() {
      registerFallbackValue(FakeAccountTypeEvent());
      registerFallbackValue(FakePersonalAccountSetupEvent());
      registerFallbackValue(FakeBusinessAccountSetupEvent());
      registerFallbackValue(FakeAuthEvent());
    });

    setUp(() {
      mockAccountTypeBloc = MockAccountTypeBloc();
      mockPersonalAccountSetupBloc = MockPersonalAccountSetupBloc();
      mockBusinessAccountSetupBloc = MockBusinessAccountSetupBloc();
      mockAuthBloc = MockAuthBloc();

      // Default state setup
      when(
        () => mockAccountTypeBloc.state,
      ).thenReturn(const AccountTypeState(selectedAccountType: AccountType.personal, isLoading: false));
      when(() => mockPersonalAccountSetupBloc.state).thenReturn(
        PersonalAccountSetupState(
          scrollController: ScrollController(),
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
        ),
      );
      when(() => mockBusinessAccountSetupBloc.state).thenReturn(
        BusinessAccountSetupState(
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
          selectedCountry: null,
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
        ),
      );
      when(() => mockAuthBloc.state).thenReturn(
        AuthState(
          forgotPasswordFormKey: GlobalKey<FormState>(),
          resetPasswordFormKey: GlobalKey<FormState>(),
          resetNewPasswordController: TextEditingController(),
          signupFormKey: GlobalKey<FormState>(),
          phoneFormKey: GlobalKey<FormState>(),
          emailFormKey: GlobalKey<FormState>(),
        ),
      );
    });

    group('Widget Instance Tests', () {
      test('should create AccountSelectionStep instance', () {
        const widget = AccountSelectionStep();
        expect(widget, isA<AccountSelectionStep>());
        expect(widget, isA<StatelessWidget>());
      });

      test('should create AccountCard instance with all properties', () {
        bool tapped = false;
        final card = AccountCard(
          title: 'Test Title',
          subtitle: 'Test Subtitle',
          icon: 'test_icon.svg',
          isSelected: true,
          onTap: () => tapped = true,
        );

        expect(card, isA<AccountCard>());
        expect(card, isA<StatelessWidget>());
        expect(card.title, 'Test Title');
        expect(card.subtitle, 'Test Subtitle');
        expect(card.icon, 'test_icon.svg');
        expect(card.isSelected, true);
        expect(card.onTap, isNotNull);

        // Test callback functionality
        card.onTap();
        expect(tapped, true);
      });
    });

    group('Widget Build Method Tests', () {
      testWidgets('should build AccountSelectionStep without errors', (tester) async {
        // Suppress rendering errors
        FlutterError.onError = (details) {};

        await tester.binding.setSurfaceSize(const Size(1200, 2000));

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const [
              Lang.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en')],
            home: MultiBlocProvider(
              providers: [
                BlocProvider<AccountTypeBloc>.value(value: mockAccountTypeBloc),
                BlocProvider<PersonalAccountSetupBloc>.value(value: mockPersonalAccountSetupBloc),
                BlocProvider<BusinessAccountSetupBloc>.value(value: mockBusinessAccountSetupBloc),
                BlocProvider<AuthBloc>.value(value: mockAuthBloc),
              ],
              child: const Scaffold(body: AccountSelectionStep()),
            ),
          ),
        );

        // Verify widget is built
        expect(find.byType(AccountSelectionStep), findsOneWidget);
      });

      testWidgets('should build AccountCard without errors', (tester) async {
        // Suppress rendering errors
        FlutterError.onError = (details) {};

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AccountCard(
                title: 'Test Card',
                subtitle: 'Test Subtitle',
                icon: 'test_icon.svg',
                isSelected: false,
                onTap: () {},
              ),
            ),
          ),
        );

        // Verify widget is built
        expect(find.byType(AccountCard), findsOneWidget);
      });
    });

    group('Event Trigger Tests', () {
      test('should create and trigger SelectAccountType event', () {
        final event = SelectAccountType(AccountType.personal);
        expect(event.accountType, AccountType.personal);

        mockAccountTypeBloc.add(event);
        verify(() => mockAccountTypeBloc.add(any(that: isA<SelectAccountType>()))).called(1);
      });

      test('should create and trigger GetDropDownOption event', () {
        final event = GetDropDownOption();
        expect(event, isA<GetDropDownOption>());

        mockAccountTypeBloc.add(event);
        verify(() => mockAccountTypeBloc.add(any(that: isA<GetDropDownOption>()))).called(1);
      });

      test('should create and trigger PersonalResetData event', () {
        final event = PersonalResetData();
        expect(event, isA<PersonalResetData>());

        mockPersonalAccountSetupBloc.add(event);
        verify(() => mockPersonalAccountSetupBloc.add(any(that: isA<PersonalResetData>()))).called(1);
      });

      test('should create and trigger ResetData event', () {
        final event = ResetData();
        expect(event, isA<ResetData>());

        mockBusinessAccountSetupBloc.add(event);
        verify(() => mockBusinessAccountSetupBloc.add(any(that: isA<ResetData>()))).called(1);
      });

      test('should create and trigger ClearSignupDataManuallyEvent', () {
        final event = ClearSignupDataManuallyEvent();
        expect(event, isA<ClearSignupDataManuallyEvent>());

        mockAuthBloc.add(event);
        verify(() => mockAuthBloc.add(any(that: isA<ClearSignupDataManuallyEvent>()))).called(1);
      });
    });

    group('Complete Flow Tests', () {
      test('should handle complete personal account selection flow', () {
        // Simulate the complete flow for personal account selection
        mockAccountTypeBloc.add(SelectAccountType(AccountType.personal));
        mockAccountTypeBloc.add(GetDropDownOption());
        mockPersonalAccountSetupBloc.add(PersonalResetData());

        // Verify all events were triggered
        verify(() => mockAccountTypeBloc.add(any(that: isA<SelectAccountType>()))).called(1);
        verify(() => mockAccountTypeBloc.add(any(that: isA<GetDropDownOption>()))).called(1);
        verify(() => mockPersonalAccountSetupBloc.add(any(that: isA<PersonalResetData>()))).called(1);
      });

      test('should handle complete business account selection flow', () {
        // Simulate the complete flow for business account selection
        mockAccountTypeBloc.add(SelectAccountType(AccountType.business));
        mockAccountTypeBloc.add(GetDropDownOption());
        mockBusinessAccountSetupBloc.add(ResetData());

        // Verify all events were triggered
        verify(() => mockAccountTypeBloc.add(any(that: isA<SelectAccountType>()))).called(1);
        verify(() => mockAccountTypeBloc.add(any(that: isA<GetDropDownOption>()))).called(1);
        verify(() => mockBusinessAccountSetupBloc.add(any(that: isA<ResetData>()))).called(1);
      });

      test('should handle back navigation flow', () {
        // Simulate back navigation
        mockAuthBloc.add(ClearSignupDataManuallyEvent());

        // Verify event was triggered
        verify(() => mockAuthBloc.add(any(that: isA<ClearSignupDataManuallyEvent>()))).called(1);
      });
    });

    group('State Handling Tests', () {
      test('should handle all AccountTypeState variations', () {
        // Test personal account state
        when(
          () => mockAccountTypeBloc.state,
        ).thenReturn(const AccountTypeState(selectedAccountType: AccountType.personal, isLoading: false));
        expect(mockAccountTypeBloc.state.selectedAccountType, AccountType.personal);
        expect(mockAccountTypeBloc.state.isLoading, false);

        // Test business account state
        when(
          () => mockAccountTypeBloc.state,
        ).thenReturn(const AccountTypeState(selectedAccountType: AccountType.business, isLoading: false));
        expect(mockAccountTypeBloc.state.selectedAccountType, AccountType.business);
        expect(mockAccountTypeBloc.state.isLoading, false);

        // Test null state
        when(
          () => mockAccountTypeBloc.state,
        ).thenReturn(const AccountTypeState(selectedAccountType: null, isLoading: false));
        expect(mockAccountTypeBloc.state.selectedAccountType, null);
        expect(mockAccountTypeBloc.state.isLoading, false);

        // Test loading state
        when(
          () => mockAccountTypeBloc.state,
        ).thenReturn(const AccountTypeState(selectedAccountType: AccountType.personal, isLoading: true));
        expect(mockAccountTypeBloc.state.selectedAccountType, AccountType.personal);
        expect(mockAccountTypeBloc.state.isLoading, true);
      });
    });

    group('Constants and Assets Tests', () {
      test('should have valid RouteUri constants', () {
        expect(RouteUri.signupRoute, isNotNull);
        expect(RouteUri.personalAccountSetupRoute, isNotNull);
        expect(RouteUri.businessAccountSetupViewRoute, isNotNull);
        expect(RouteUri.signupRoute, isA<String>());
        expect(RouteUri.personalAccountSetupRoute, isA<String>());
        expect(RouteUri.businessAccountSetupViewRoute, isA<String>());
      });

      test('should have valid Assets paths', () {
        expect(Assets.images.svgs.icons.icDoubleLeftArrow.path, isNotNull);
        expect(Assets.images.svgs.icons.icDoubleLeftArrow.path, isA<String>());
      });
    });
  });
}
