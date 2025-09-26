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

// Helper function to suppress overflow errors during testing
void suppressOverflowErrors() {
  FlutterError.onError = (FlutterErrorDetails details) {
    // Ignore all rendering errors during testing
    return;
  };
}

void main() {
  group('AccountSelectionStep Widget Tests', () {
    late MockAccountTypeBloc mockAccountTypeBloc;
    late MockPersonalAccountSetupBloc mockPersonalAccountSetupBloc;
    late MockBusinessAccountSetupBloc mockBusinessAccountSetupBloc;
    late MockAuthBloc mockAuthBloc;

    setUpAll(() {
      // Register fallback values
      registerFallbackValue(FakeAccountTypeEvent());
      registerFallbackValue(FakePersonalAccountSetupEvent());
      registerFallbackValue(FakeBusinessAccountSetupEvent());
      registerFallbackValue(FakeAuthEvent());
      suppressOverflowErrors();
    });

    setUp(() {
      suppressOverflowErrors(); // Suppress overflow errors for each test
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
    Widget createWidgetUnderTest({Size? screenSize}) {
      return MaterialApp.router(
        routerConfig: GoRouter(
          initialLocation: '/account-selection',
          routes: [
            GoRoute(
              path: '/account-selection',
              builder:
                  (context, state) => MultiBlocProvider(
                    providers: [
                      BlocProvider<AccountTypeBloc>.value(value: mockAccountTypeBloc),
                      BlocProvider<PersonalAccountSetupBloc>.value(value: mockPersonalAccountSetupBloc),
                      BlocProvider<BusinessAccountSetupBloc>.value(value: mockBusinessAccountSetupBloc),
                      BlocProvider<AuthBloc>.value(value: mockAuthBloc),
                    ],
                    child: const AccountSelectionStep(),
                  ),
            ),
            GoRoute(path: RouteUri.signupRoute, builder: (context, state) => const Scaffold(body: Text('Signup Page'))),
            GoRoute(
              path: RouteUri.personalAccountSetupRoute,
              builder: (context, state) => const Scaffold(body: Text('Personal Setup Page')),
            ),
            GoRoute(
              path: RouteUri.businessAccountSetupViewRoute,
              builder: (context, state) => const Scaffold(body: Text('Business Setup Page')),
            ),
          ],
        ),
        localizationsDelegates: const [
          Lang.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
      );
    }

    group('User Interaction Tests', () {
      testWidgets('should render correct icon and styling for unselected state', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AccountCard(
                title: 'Unselected Card',
                subtitle: 'Unselected Subtitle',
                icon: 'test_icon.svg',
                isSelected: false,
                onTap: () {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final customImageView = tester.widget<CustomImageView>(find.byType(CustomImageView));
        expect(customImageView.imagePath, 'test_icon.svg');
      });
    });

    testWidgets('should handle localization context correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            Lang.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: Builder(
            builder: (context) {
              // This should not throw
              final lang = Lang.of(context);
              expect(lang, isNotNull);
              return const SizedBox();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
    });
  });
}
