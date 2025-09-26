import 'package:exchek/core/enums/app_enums.dart';
import 'package:exchek/viewmodels/account_setup_bloc/business_account_setup_bloc/business_account_setup_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

void main() {
  group('BusinessAccountSetupState', () {
    late BusinessAccountSetupState state;

    setUp(() {
      state = BusinessAccountSetupState(
        currentStep: BusinessAccountSetupSteps.businessEntity,
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
        turnOverController: TextEditingController(),
        gstNumberController: TextEditingController(),
        annualTurnoverFormKey: GlobalKey<FormState>(),
        isGstCertificateMandatory: false,
        iceNumberController: TextEditingController(),
        iceVerificationKey: GlobalKey<FormState>(),
        cinNumberController: TextEditingController(),
        cinVerificationKey: GlobalKey<FormState>(),
        llpinNumberController: TextEditingController(),
        bankAccountVerificationFormKey: GlobalKey<FormState>(),
        bankAccountNumberController: TextEditingController(),
        reEnterbankAccountNumberController: TextEditingController(),
        ifscCodeController: TextEditingController(),
        curruncyList: [],
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
    });

    test('should have correct default values', () {
      expect(state.currentStep, BusinessAccountSetupSteps.businessEntity);
      expect(state.selectedBusinessEntityType, isNull);
      expect(state.selectedBusinessMainActivity, isNull);
      expect(state.otpRemainingTime, 0);
      expect(state.isOtpTimerRunning, false);
      expect(state.isCreatePasswordObscure, true);
      expect(state.isConfirmPasswordObscure, true);
      expect(state.isSignupLoading, false);
      expect(state.isSignupSuccess, false);
      expect(state.isBusinessInfoOtpSent, false);
      expect(state.currentKycVerificationStep, KycVerificationSteps.panVerification);
      expect(state.isOtpSent, false);
      expect(state.aadharOtpRemainingTime, 0);
      expect(state.isAadharOtpTimerRunning, false);
      expect(state.isAadharVerifiedLoading, false);
      expect(state.isAadharVerified, false);
      expect(state.isAadharFileUploading, false);
      expect(state.selectedCountry?.countryCode, 'IN');
      expect(state.isGstCertificateMandatory, false);
      expect(state.isBankAccountVerify, false);
      expect(state.curruncyList, isEmpty);
    });

    test('should support value equality', () {
      final state1 = BusinessAccountSetupState(
        currentStep: BusinessAccountSetupSteps.businessEntity,
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
        turnOverController: TextEditingController(),
        gstNumberController: TextEditingController(),
        annualTurnoverFormKey: GlobalKey<FormState>(),
        isGstCertificateMandatory: false,
        iceNumberController: TextEditingController(),
        iceVerificationKey: GlobalKey<FormState>(),
        cinNumberController: TextEditingController(),
        cinVerificationKey: GlobalKey<FormState>(),
        llpinNumberController: TextEditingController(),
        bankAccountVerificationFormKey: GlobalKey<FormState>(),
        bankAccountNumberController: TextEditingController(),
        reEnterbankAccountNumberController: TextEditingController(),
        ifscCodeController: TextEditingController(),
        curruncyList: [],
        selectedBusinessEntityType: 'Private Limited',
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

      final state2 = state1.copyWith(selectedBusinessEntityType: 'Private Limited');

      expect(state1.selectedBusinessEntityType, state2.selectedBusinessEntityType);
    });

    test('copyWith should work correctly', () {
      final newState = state.copyWith(
        currentStep: BusinessAccountSetupSteps.businessInformation,
        selectedBusinessEntityType: 'Private Limited Company',
        isSignupLoading: true,
        otpRemainingTime: 120,
        isOtpTimerRunning: true,
      );

      expect(newState.currentStep, BusinessAccountSetupSteps.businessInformation);
      expect(newState.selectedBusinessEntityType, 'Private Limited Company');
      expect(newState.isSignupLoading, true);
      expect(newState.otpRemainingTime, 120);
      expect(newState.isOtpTimerRunning, true);

      // Original state should remain unchanged
      expect(state.currentStep, BusinessAccountSetupSteps.businessEntity);
      expect(state.selectedBusinessEntityType, isNull);
      expect(state.isSignupLoading, false);
      expect(state.otpRemainingTime, 0);
      expect(state.isOtpTimerRunning, false);
    });

    test('copyWith with null values should keep original values', () {
      final originalState = state.copyWith(selectedBusinessEntityType: 'Private Limited', isSignupLoading: true);

      final newState = originalState.copyWith(selectedBusinessEntityType: null, isSignupLoading: null);

      expect(newState.selectedBusinessEntityType, 'Private Limited');
      expect(newState.isSignupLoading, true);
    });

    test('props should include all properties', () {
      expect(state.props, isNotEmpty);
      expect(state.props.contains(state.currentStep), true);
      expect(state.props.contains(state.selectedBusinessEntityType), true);
      expect(state.props.contains(state.isSignupLoading), true);
      expect(state.props.contains(state.otpRemainingTime), true);
    });
  });
}
