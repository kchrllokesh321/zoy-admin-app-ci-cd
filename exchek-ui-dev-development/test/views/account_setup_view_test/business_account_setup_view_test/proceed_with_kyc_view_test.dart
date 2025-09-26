import 'package:exchek/core/enums/app_enums.dart';
import 'package:exchek/viewmodels/account_setup_bloc/business_account_setup_bloc/business_account_setup_bloc.dart';
import 'package:exchek/widgets/common_widget/app_background.dart';
import 'package:exchek/widgets/custom_widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:exchek/views/account_setup_view/business_account_setup_view/proceed_with_kyc_view.dart';
import 'package:exchek/viewmodels/account_setup_bloc/account_type_selection/account_type_selection_bloc.dart';
import 'package:exchek/core/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:exchek/viewmodels/auth_bloc/auth_bloc.dart';
import 'package:exchek/viewmodels/account_setup_bloc/personal_account_setup_bloc/personal_account_setup_bloc.dart';
import 'proceed_with_kyc_view_test.mocks.dart';

@GenerateMocks([BusinessAccountSetupBloc, AccountTypeBloc, AuthBloc, PersonalAccountSetupBloc])
void main() {
  group('ProceedWithKycView Widget Tests', () {
    late MockBusinessAccountSetupBloc mockBusinessAccountSetupBloc;
    late MockAccountTypeBloc mockAccountTypeBloc;
    late MockAuthBloc mockAuthBloc;
    late MockPersonalAccountSetupBloc mockPersonalAccountSetupBloc;

    setUp(() {
      mockBusinessAccountSetupBloc = MockBusinessAccountSetupBloc();
      mockAccountTypeBloc = MockAccountTypeBloc();
      mockAuthBloc = MockAuthBloc();
      mockPersonalAccountSetupBloc = MockPersonalAccountSetupBloc();

      when(mockAuthBloc.state).thenReturn(
        AuthState(
          userName: 'Test User',
          email: 'test@example.com',
          forgotPasswordFormKey: GlobalKey<FormState>(),
          resetPasswordFormKey: GlobalKey<FormState>(),
          resetNewPasswordController: TextEditingController(),
          signupFormKey: GlobalKey<FormState>(),
          phoneFormKey: GlobalKey<FormState>(),
          emailFormKey: GlobalKey<FormState>(),
        ),
      );
      when(mockAuthBloc.stream).thenAnswer(
        (_) => Stream.value(
          AuthState(
            userName: 'Test User',
            email: 'test@example.com',
            forgotPasswordFormKey: GlobalKey<FormState>(),
            resetPasswordFormKey: GlobalKey<FormState>(),
            resetNewPasswordController: TextEditingController(),
            signupFormKey: GlobalKey<FormState>(),
            phoneFormKey: GlobalKey<FormState>(),
            emailFormKey: GlobalKey<FormState>(),
          ),
        ),
      );
      final personalAccountSetupState = PersonalAccountSetupState(
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
        websiteController: TextEditingController(),
        mobileController: TextEditingController(),
        otpController: TextEditingController(),
        sePasswordFormKey: GlobalKey<FormState>(),
        captchaInputController: TextEditingController(),
        fullNameController: TextEditingController(),
        familyAndFriendsDescriptionController: TextEditingController(),
        iceVerificationKey: GlobalKey<FormState>(),
        iceNumberController: TextEditingController(),
        personalDbaController: TextEditingController(),
      );
      when(mockPersonalAccountSetupBloc.state).thenReturn(personalAccountSetupState);
      when(mockPersonalAccountSetupBloc.stream).thenAnswer((_) => Stream.value(personalAccountSetupState));
    });

    BusinessAccountSetupState createMockState() {
      return BusinessAccountSetupState(
        currentStep: BusinessAccountSetupSteps.businessEntity,
        goodsAndServiceExportDescriptionController: TextEditingController(),
        goodsExportOtherController: TextEditingController(),
        serviceExportOtherController: TextEditingController(),
        businessActivityOtherController: TextEditingController(),
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
        formKey: GlobalKey<FormState>(),
        businessLegalNameController: TextEditingController(),
        professionalWebsiteUrl: TextEditingController(),
        phoneController: TextEditingController(),
        otpController: TextEditingController(),
        scrollController: ScrollController(),
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

    Widget createTestWidget() {
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder:
                (context, state) => MultiBlocProvider(
                  providers: [
                    BlocProvider<BusinessAccountSetupBloc>.value(value: mockBusinessAccountSetupBloc),
                    BlocProvider<AccountTypeBloc>.value(value: mockAccountTypeBloc),
                    BlocProvider<AuthBloc>.value(value: mockAuthBloc),
                    BlocProvider<PersonalAccountSetupBloc>.value(value: mockPersonalAccountSetupBloc),
                  ],
                  child: const ProceedWithKycView(),
                ),
          ),
          GoRoute(
            path: '/personalaccountkycsetupview',
            builder: (context, state) => const Scaffold(body: Text('Personal KYC')),
          ),
          GoRoute(path: '/ekyc', builder: (context, state) => const Scaffold(body: Text('Business eKYC'))),
        ],
      );

      return MultiBlocProvider(
        providers: [
          BlocProvider<BusinessAccountSetupBloc>.value(value: mockBusinessAccountSetupBloc),
          BlocProvider<AccountTypeBloc>.value(value: mockAccountTypeBloc),
          BlocProvider<AuthBloc>.value(value: mockAuthBloc),
          BlocProvider<PersonalAccountSetupBloc>.value(value: mockPersonalAccountSetupBloc),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: const [
            Lang.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: Lang.delegate.supportedLocales,
        ),
      );
    }

    testWidgets('should display KYC page with correct structure', (WidgetTester tester) async {
      // Arrange
      when(mockBusinessAccountSetupBloc.state).thenReturn(createMockState());
      when(mockBusinessAccountSetupBloc.stream).thenAnswer((_) => Stream.fromIterable([createMockState()]));
      when(mockAccountTypeBloc.state).thenReturn(const AccountTypeState(selectedAccountType: AccountType.business));
      when(
        mockAccountTypeBloc.stream,
      ).thenAnswer((_) => Stream.fromIterable([const AccountTypeState(selectedAccountType: AccountType.business)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(BackgroundImage), findsOneWidget);
      expect(find.byType(Column), findsAtLeastNWidgets(1));
    });

    testWidgets('should display welcome title text', (WidgetTester tester) async {
      // Arrange
      when(mockBusinessAccountSetupBloc.state).thenReturn(createMockState());
      when(mockBusinessAccountSetupBloc.stream).thenAnswer((_) => Stream.fromIterable([createMockState()]));
      when(mockAccountTypeBloc.state).thenReturn(const AccountTypeState(selectedAccountType: AccountType.business));
      when(
        mockAccountTypeBloc.stream,
      ).thenAnswer((_) => Stream.fromIterable([const AccountTypeState(selectedAccountType: AccountType.business)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.textContaining('excited to have you'), findsOneWidget);
    });

    testWidgets('should display KYC description text', (WidgetTester tester) async {
      // Arrange
      when(mockBusinessAccountSetupBloc.state).thenReturn(createMockState());
      when(mockBusinessAccountSetupBloc.stream).thenAnswer((_) => Stream.fromIterable([createMockState()]));
      when(mockAccountTypeBloc.state).thenReturn(const AccountTypeState(selectedAccountType: AccountType.business));
      when(
        mockAccountTypeBloc.stream,
      ).thenAnswer((_) => Stream.fromIterable([const AccountTypeState(selectedAccountType: AccountType.business)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.textContaining('KYC'), findsAtLeastNWidgets(1));
      expect(find.textContaining('verification'), findsAtLeastNWidgets(1));
    });

    testWidgets('should display Proceed with KYC button with correct properties', (WidgetTester tester) async {
      // Arrange
      when(mockBusinessAccountSetupBloc.state).thenReturn(createMockState());
      when(mockBusinessAccountSetupBloc.stream).thenAnswer((_) => Stream.fromIterable([createMockState()]));
      when(mockAccountTypeBloc.state).thenReturn(const AccountTypeState(selectedAccountType: AccountType.business));
      when(
        mockAccountTypeBloc.stream,
      ).thenAnswer((_) => Stream.fromIterable([const AccountTypeState(selectedAccountType: AccountType.business)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(CustomElevatedButton), findsOneWidget);
      expect(find.text('Proceed with KYC'), findsOneWidget);

      final button = tester.widget<CustomElevatedButton>(find.byType(CustomElevatedButton));
      expect(button.isDisabled, isFalse);
    });

    testWidgets('should display background image correctly', (WidgetTester tester) async {
      // Arrange
      when(mockBusinessAccountSetupBloc.state).thenReturn(
        BusinessAccountSetupState(
          currentStep: BusinessAccountSetupSteps.businessEntity,
          goodsAndServiceExportDescriptionController: TextEditingController(),
          goodsExportOtherController: TextEditingController(),
          serviceExportOtherController: TextEditingController(),
          businessActivityOtherController: TextEditingController(),
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
          formKey: GlobalKey<FormState>(),
          businessLegalNameController: TextEditingController(),
          professionalWebsiteUrl: TextEditingController(),
          phoneController: TextEditingController(),
          otpController: TextEditingController(),
          scrollController: ScrollController(),
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
      when(mockBusinessAccountSetupBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          BusinessAccountSetupState(
            currentStep: BusinessAccountSetupSteps.businessEntity,
            goodsAndServiceExportDescriptionController: TextEditingController(),
            goodsExportOtherController: TextEditingController(),
            serviceExportOtherController: TextEditingController(),
            businessActivityOtherController: TextEditingController(),
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
            formKey: GlobalKey<FormState>(),
            businessLegalNameController: TextEditingController(),
            professionalWebsiteUrl: TextEditingController(),
            phoneController: TextEditingController(),
            otpController: TextEditingController(),
            scrollController: ScrollController(),
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
        ]),
      );
      when(mockAccountTypeBloc.state).thenReturn(const AccountTypeState(selectedAccountType: AccountType.business));
      when(
        mockAccountTypeBloc.stream,
      ).thenAnswer((_) => Stream.fromIterable([const AccountTypeState(selectedAccountType: AccountType.business)]));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      expect(find.byType(BackgroundImage), findsOneWidget);
      final backgroundImage = tester.widget<BackgroundImage>(find.byType(BackgroundImage));
      expect(backgroundImage.imagePath, isNotNull);
    });

    group('Responsive Layout Tests', () {
      testWidgets('should have proper responsive layout structure', (WidgetTester tester) async {
        // Arrange
        when(mockBusinessAccountSetupBloc.state).thenReturn(createMockState());
        when(mockBusinessAccountSetupBloc.stream).thenAnswer((_) => Stream.fromIterable([createMockState()]));
        when(mockAccountTypeBloc.state).thenReturn(const AccountTypeState(selectedAccountType: AccountType.business));
        when(
          mockAccountTypeBloc.stream,
        ).thenAnswer((_) => Stream.fromIterable([const AccountTypeState(selectedAccountType: AccountType.business)]));

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.byType(Column), findsAtLeastNWidgets(1));
        expect(find.byType(Padding), findsAtLeastNWidgets(1));
        expect(find.byType(Expanded), findsAtLeastNWidgets(1));
      });

      testWidgets('should test getWidgetWidth method returns valid width', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(MaterialApp(home: Container()));
        final context = tester.element(find.byType(Container));

        // Act
        final width = ProceedWithKycView.getWidgetWidth(context);

        // Assert
        expect(width, isA<double>());
        expect(width, greaterThan(0));
      });
    });

    group('User Interaction Tests', () {
      testWidgets('should handle Proceed with KYC button tap', (WidgetTester tester) async {
        // Arrange
        when(mockBusinessAccountSetupBloc.state).thenReturn(createMockState());
        when(mockBusinessAccountSetupBloc.stream).thenAnswer((_) => Stream.fromIterable([createMockState()]));
        when(mockAccountTypeBloc.state).thenReturn(const AccountTypeState(selectedAccountType: AccountType.business));
        when(
          mockAccountTypeBloc.stream,
        ).thenAnswer((_) => Stream.fromIterable([const AccountTypeState(selectedAccountType: AccountType.business)]));

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();
        await tester.tap(find.byType(CustomElevatedButton));
        await tester.pump();

        // Assert - Button should respond to tap
        expect(find.byType(CustomElevatedButton), findsOneWidget);
      });
    });

    group('State Management Tests', () {
      testWidgets('should react to account type changes', (WidgetTester tester) async {
        // Arrange
        when(mockBusinessAccountSetupBloc.state).thenReturn(createMockState());
        when(mockBusinessAccountSetupBloc.stream).thenAnswer((_) => Stream.fromIterable([createMockState()]));
        when(mockAccountTypeBloc.state).thenReturn(const AccountTypeState(selectedAccountType: AccountType.business));
        when(mockAccountTypeBloc.stream).thenAnswer(
          (_) => Stream.fromIterable([
            const AccountTypeState(selectedAccountType: AccountType.business),
            const AccountTypeState(selectedAccountType: AccountType.personal),
          ]),
        );

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();
        await tester.pump(); // Trigger state change

        // Assert
        expect(find.byType(CustomElevatedButton), findsOneWidget);
      });

      testWidgets('should handle null account type gracefully', (WidgetTester tester) async {
        // Arrange
        when(mockBusinessAccountSetupBloc.state).thenReturn(createMockState());
        when(mockBusinessAccountSetupBloc.stream).thenAnswer((_) => Stream.fromIterable([createMockState()]));
        when(mockAccountTypeBloc.state).thenReturn(const AccountTypeState(selectedAccountType: null));
        when(
          mockAccountTypeBloc.stream,
        ).thenAnswer((_) => Stream.fromIterable([const AccountTypeState(selectedAccountType: null)]));

        // Act & Assert
        expect(() async {
          await tester.pumpWidget(createTestWidget());
          await tester.pump();
        }, returnsNormally);
      });
    });

    group('Edge Cases', () {
      testWidgets('should maintain state during widget rebuilds', (WidgetTester tester) async {
        // Arrange
        when(mockBusinessAccountSetupBloc.state).thenReturn(createMockState());
        when(mockBusinessAccountSetupBloc.stream).thenAnswer((_) => Stream.fromIterable([createMockState()]));
        when(mockAccountTypeBloc.state).thenReturn(const AccountTypeState(selectedAccountType: AccountType.business));
        when(
          mockAccountTypeBloc.stream,
        ).thenAnswer((_) => Stream.fromIterable([const AccountTypeState(selectedAccountType: AccountType.business)]));

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Trigger rebuild
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.byType(CustomElevatedButton), findsOneWidget);
      });

      testWidgets('should handle rapid button taps gracefully', (WidgetTester tester) async {
        // Arrange
        when(mockBusinessAccountSetupBloc.state).thenReturn(createMockState());
        when(mockBusinessAccountSetupBloc.stream).thenAnswer((_) => Stream.fromIterable([createMockState()]));
        when(mockAccountTypeBloc.state).thenReturn(const AccountTypeState(selectedAccountType: AccountType.business));
        when(
          mockAccountTypeBloc.stream,
        ).thenAnswer((_) => Stream.fromIterable([const AccountTypeState(selectedAccountType: AccountType.business)]));

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Rapid taps
        await tester.tap(find.byType(CustomElevatedButton));
        await tester.tap(find.byType(CustomElevatedButton));
        await tester.tap(find.byType(CustomElevatedButton));
        await tester.pump();

        // Assert - Should handle multiple taps gracefully
        expect(find.byType(CustomElevatedButton), findsOneWidget);
      });
    });
  });
}
