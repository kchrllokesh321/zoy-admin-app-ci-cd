import 'package:exchek/core/enums/app_enums.dart';
import 'package:exchek/viewmodels/account_setup_bloc/personal_account_setup_bloc/personal_account_setup_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:exchek/core/generated/l10n.dart';

void main() {
  group('PersonalAccountSetupState', () {
    late PersonalAccountSetupState state;

    setUp(() {
      state = PersonalAccountSetupState(
        scrollController: ScrollController(),
        professionOtherController: TextEditingController(),
        productServiceDescriptionController: TextEditingController(),
        passwordController: TextEditingController(),
        confirmPasswordController: TextEditingController(),
        currencyList: [],
        selectedCurrencies: [],
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
        personalInfoKey: GlobalKey<FormState>(),
        sePasswordFormKey: GlobalKey<FormState>(),
        captchaInputController: TextEditingController(),
        familyAndFriendsDescriptionController: TextEditingController(),
        iceVerificationKey: GlobalKey<FormState>(),
        iceNumberController: TextEditingController(),
        personalDbaController: TextEditingController(),
      );
    });

    test('should have correct default values', () {
      expect(state.currentStep, PersonalAccountSetupSteps.personalEntity);
      expect(state.selectedPurpose, isNull);
      expect(state.selectedProfession, isNull);
      expect(state.fullName, isNull);
      expect(state.email, isNull);
      expect(state.website, isNull);
      expect(state.phoneNumber, isNull);
      expect(state.password, isNull);
      expect(state.selectedEstimatedMonthlyTransaction, isNull);
      expect(state.currencyList, isEmpty);
      expect(state.selectedCurrencies, isEmpty);
      expect(state.isTransactionDetailLoading, isNull);
      expect(state.isPersonalAccount, true);
      expect(state.currentKycVerificationStep, PersonalEKycVerificationSteps.identityVerification);
      expect(state.selectedIDVerificationDocType, isNull);
      expect(state.isOtpSent, false);
      expect(state.aadharOtpRemainingTime, 0);
      expect(state.isAadharOtpTimerRunning, false);
      expect(state.aadharNumber, isNull);
      expect(state.isIdVerifiedLoading, false);
      expect(state.isIdVerified, false);
      expect(state.isLoading, false);
      expect(state.isReady, false);
      expect(state.hasPermission, false);
      expect(state.cameraController, isNull);
      expect(state.imageBytes, isNull);
      expect(state.errorMessage, isNull);
      expect(state.isImageCaptured, false);
      expect(state.isImageSubmitted, false);
      expect(state.navigateNext, false);
      expect(state.isOTPSent, false);
      expect(state.isOtpVerified, false);
      expect(state.canResendOTP, false);
      expect(state.timeLeft, 30);
      expect(state.otpError, isNull);
      expect(state.obscurePassword, true);
      expect(state.obscureConfirmPassword, true);
      expect(state.error, isNull);
      expect(state.isSignupSuccess, isNull);
    });

    test('should support value equality', () {
      final state1 = PersonalAccountSetupState(
        scrollController: ScrollController(),
        professionOtherController: TextEditingController(),
        productServiceDescriptionController: TextEditingController(),
        passwordController: TextEditingController(),
        confirmPasswordController: TextEditingController(),
        currencyList: [],
        selectedCurrencies: [],
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
        personalInfoKey: GlobalKey<FormState>(),
        sePasswordFormKey: GlobalKey<FormState>(),
        selectedPurpose: 'Business',
        captchaInputController: TextEditingController(),
        fullNameController: TextEditingController(),
        familyAndFriendsDescriptionController: TextEditingController(),
        iceVerificationKey: GlobalKey<FormState>(),
        iceNumberController: TextEditingController(),
        personalDbaController: TextEditingController(),
      );

      final state2 = state1.copyWith(selectedPurpose: 'Business');

      expect(state1.selectedPurpose, state2.selectedPurpose);
    });

    test('copyWith should work correctly', () {
      final newState = state.copyWith(
        currentStep: PersonalAccountSetupSteps.personalInformation,
        selectedPurpose: 'Business',
        selectedProfession: ['Software Engineer'],
        fullName: 'John Doe',
        isLoading: true,
        obscurePassword: false,
      );

      expect(newState.currentStep, PersonalAccountSetupSteps.personalInformation);
      expect(newState.selectedPurpose, 'Business');
      expect(newState.selectedProfession, ['Software Engineer']);
      expect(newState.fullName, 'John Doe');
      expect(newState.isLoading, true);
      expect(newState.obscurePassword, false);

      // Original state should remain unchanged
      expect(state.currentStep, PersonalAccountSetupSteps.personalEntity);
      expect(state.selectedPurpose, isNull);
      expect(state.selectedProfession, isNull);
      expect(state.fullName, isNull);
      expect(state.isLoading, false);
      expect(state.obscurePassword, true);
    });

    test('copyWith with null values should keep original values', () {
      final originalState = state.copyWith(selectedPurpose: 'Business', isLoading: true, obscurePassword: false);

      final newState = originalState.copyWith(selectedPurpose: null, isLoading: null, obscurePassword: null);

      expect(newState.selectedPurpose, 'Business');
      expect(newState.isLoading, true);
      expect(newState.obscurePassword, false);
    });

    test('props should include all properties', () {
      expect(state.props, isNotEmpty);
      expect(state.props.contains(state.currentStep), true);
      expect(state.props.contains(state.selectedPurpose), true);
      expect(state.props.contains(state.selectedProfession), true);
      expect(state.props.contains(state.fullName), true);
      expect(state.props.contains(state.isLoading), true);
      expect(state.props.contains(state.obscurePassword), true);
    });

    testWidgets('IDVerificationDocType extension should return correct display names', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            Lang.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: Lang.delegate.supportedLocales,
          home: const SizedBox(),
        ),
      );

      expect(IDVerificationDocType.aadharCard.displayName, contains('Aadhaar'));
      expect(IDVerificationDocType.drivingLicense.displayName, contains('Driving'));
      expect(IDVerificationDocType.voterID.displayName, contains('Voter'));
      expect(IDVerificationDocType.passport.displayName, contains('Passport'));
    });
  });
}
