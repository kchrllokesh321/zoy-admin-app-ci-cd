// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:cron/cron.dart';
import 'package:dio/dio.dart';
import 'package:exchek/core/utils/exports.dart';
import 'package:equatable/equatable.dart';
import 'package:exchek/models/auth_models/common_success_model.dart';
import 'package:exchek/models/personal_user_models/aadhar_otp_model.dart';
import 'package:exchek/models/personal_user_models/aadhar_verify_otp_model.dart';
import 'package:exchek/models/personal_user_models/captcha_model.dart';
import 'package:exchek/models/personal_user_models/get_city_and_state_model.dart';
import 'package:exchek/models/personal_user_models/get_pan_detail_model.dart';
import 'package:exchek/models/personal_user_models/recaptcha_model.dart';
import 'package:exchek/repository/business_user_kyc_repository.dart';
import 'package:exchek/repository/personal_user_kyc_repository.dart';
import 'package:exchek/views/account_setup_view/business_account_setup_view/business_transaction_and_payment_preferences_view.dart';
import 'package:exchek/models/personal_user_models/get_currency_model.dart';
import 'package:exchek/models/auth_models/get_user_kyc_detail_model.dart';

part 'business_account_setup_event.dart';
part 'business_account_setup_state.dart';

class BusinessAccountSetupBloc extends Bloc<BusinessAccountSetupEvent, BusinessAccountSetupState> {
  static const int initialTime = 120;
  Timer? _timer;

  Timer? _aadhartimer;

  Timer? _kartaAadhartimer;

  Timer? _otherDirectorAadhartimer;
  final AuthRepository _authRepository;
  final BusinessUserKycRepository _businessUserKycRepository;
  final PersonalUserKycRepository _personalUserKycRepository;
  Cron? cron;

  static final Country defaultSelectedCountry = Country(
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
  );

  // Static GlobalKeys to prevent conflicts
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _sePasswordFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _aadharVerificationFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _kartaAadharVerificationFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _hufPanVerificationKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _businessPanVerificationKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _directorsPanVerificationKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _beneficialOwnerPanVerificationKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _businessRepresentativeFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _registerAddressFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _annualTurnoverFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _iceVerificationKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _cinVerificationKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _bankAccountVerificationFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _directorContactInfoFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _otherDirectorsPanVerificationKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _llpPanVerificationKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _partnershipFirmPanVerificationKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _soleProprietorShipPanVerificationKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _kartaPanVerificationKey = GlobalKey<FormState>();

  BusinessAccountSetupBloc({
    required AuthRepository authRepository,
    required BusinessUserKycRepository businessUserKycRepository,
    required PersonalUserKycRepository personalUserKycRepository,
  }) : _authRepository = authRepository,
       _businessUserKycRepository = businessUserKycRepository,
       _personalUserKycRepository = personalUserKycRepository,

       super(
         BusinessAccountSetupState(
           currentStep: BusinessAccountSetupSteps.businessEntity,
           goodsAndServiceExportDescriptionController: TextEditingController(),
           goodsExportOtherController: TextEditingController(),
           serviceExportOtherController: TextEditingController(),
           businessActivityOtherController: TextEditingController(),
           scrollController: ScrollController(),
           formKey: _formKey,
           businessLegalNameController: TextEditingController(),
           dbaController: TextEditingController(),
           professionalWebsiteUrl: TextEditingController(),
           phoneController: TextEditingController(),
           otpController: TextEditingController(),
           sePasswordFormKey: _sePasswordFormKey,
           createPasswordController: TextEditingController(),
           confirmPasswordController: TextEditingController(),
           currentKycVerificationStep: KycVerificationSteps.panVerification,
           aadharNumberController: TextEditingController(),
           directorAadharNumberFocusNode: FocusNode(),
           aadharOtpController: TextEditingController(),
           aadharVerificationFormKey: _aadharVerificationFormKey,
           kartaAadharVerificationFormKey: _kartaAadharVerificationFormKey,
           kartaAadharNumberController: TextEditingController(),
           kartaAadharOtpController: TextEditingController(),
           hufPanVerificationKey: _hufPanVerificationKey,
           hufPanNumberController: TextEditingController(),
           isHUFPanVerifyingLoading: false,
           businessPanNumberController: TextEditingController(),
           businessPanNameController: TextEditingController(),
           businessPanVerificationKey: _businessPanVerificationKey,
           directorsPanVerificationKey: _directorsPanVerificationKey,
           director1PanNumberController: TextEditingController(),
           director1PanNameController: TextEditingController(),
           director2PanNumberController: TextEditingController(),
           director2PanNameController: TextEditingController(),
           beneficialOwnerPanVerificationKey: _beneficialOwnerPanVerificationKey,
           beneficialOwnerPanNumberController: TextEditingController(),
           beneficialOwnerPanNameController: TextEditingController(),
           businessRepresentativeFormKey: _businessRepresentativeFormKey,
           businessRepresentativePanNumberController: TextEditingController(),
           businessRepresentativePanNameController: TextEditingController(),
           registerAddressFormKey: _registerAddressFormKey,
           pinCodeController: TextEditingController(),
           stateNameController: TextEditingController(),
           cityNameController: TextEditingController(),
           address1NameController: TextEditingController(),
           address2NameController: TextEditingController(),
           annualTurnoverFormKey: _annualTurnoverFormKey,
           turnOverController: TextEditingController(),
           iceVerificationKey: _iceVerificationKey,
           iceNumberController: TextEditingController(),
           cinVerificationKey: _cinVerificationKey,
           cinNumberController: TextEditingController(),
           llpinNumberController: TextEditingController(),
           bankAccountVerificationFormKey: _bankAccountVerificationFormKey,
           bankAccountNumberController: TextEditingController(),
           reEnterbankAccountNumberController: TextEditingController(),
           ifscCodeController: TextEditingController(),
           gstNumberController: TextEditingController(),
           isGstCertificateMandatory: false,
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
           directorCaptchaInputController: TextEditingController(),
           partnerAadharNumberController: TextEditingController(),
           partnerAadharOtpController: TextEditingController(),
           partnerAadharVerificationFormKey: GlobalKey<FormState>(),
           partnerFrontSideAdharFile: null,
           partnerBackSideAdharFile: null,
           isPartnerOtpSent: false,
           isPartnerOtpLoading: false,
           partnerIsAadharOTPInvalidate: null,
           isPartnerAadharVerifiedLoading: false,
           isPartnerAadharVerified: false,
           partnerAadharNumber: null,
           partnerCaptchaInputController: TextEditingController(),
           kartaCaptchaInputController: TextEditingController(),
           proprietorAadharNumberController: TextEditingController(),
           proprietorAadharNumberFocusNode: FocusNode(),
           proprietorAadharOtpController: TextEditingController(),
           proprietorAadharVerificationFormKey: GlobalKey<FormState>(),
           proprietorFrontSideAdharFile: null,
           proprietorBackSideAdharFile: null,
           isProprietorOtpSent: false,
           isProprietorOtpLoading: false,
           proprietorIsAadharOTPInvalidate: null,
           isProprietorAadharVerifiedLoading: false,
           isProprietorAadharVerified: false,
           proprietorAadharNumber: null,
           proprietorCaptchaInputController: TextEditingController(),
           directorEmailIdNumberController: TextEditingController(),
           directorMobileNumberController: TextEditingController(),
           directorContactInformationKey: _directorContactInfoFormKey,
           otherDirectorsPanVerificationKey: _otherDirectorsPanVerificationKey,

           // Other Director Aadhar related properties
           otherDirectorVerificationFormKey: GlobalKey<FormState>(),
           otherDirectorAadharNumberController: TextEditingController(),
           otherDirectorAadharNumberFocusNode: FocusNode(),
           otherDirectoraadharOtpController: TextEditingController(),
           otherDirectorCaptchaInputController: TextEditingController(),
           directorKycStep: DirectorKycSteps.panDetails,
           companyPanNumberController: TextEditingController(),
           companyPanVerificationKey: GlobalKey<FormState>(),
           companyPanCardFile: null,
           isCompanyPanDetailsLoading: false,
           isCompanyPanDetailsVerified: false,
           fullCompanyNamePan: null,
           isCompanyPanVerifyingLoading: false,
           llpPanVerificationKey: _llpPanVerificationKey,
           llpPanNumberController: TextEditingController(),
           isLLPPanVerifyingLoading: false,
           partnershipFirmPanVerificationKey: _partnershipFirmPanVerificationKey,
           partnershipFirmPanNumberController: TextEditingController(),
           isPartnershipFirmPanVerifyingLoading: false,
           soleProprietorShipPanVerificationKey: _soleProprietorShipPanVerificationKey,
           soleProprietorShipPanNumberController: TextEditingController(),
           isSoleProprietorShipPanVerifyingLoading: false,
           kartaPanVerificationKey: _kartaPanVerificationKey,
           kartaPanNumberController: TextEditingController(),
           isKartaPanVerifyingLoading: false,
           authorizedPinCodeController: TextEditingController(),
           authorizedStateNameController: TextEditingController(),
           authorizedCityNameController: TextEditingController(),
           authorizedAddress1NameController: TextEditingController(),
           authorizedAddress2NameController: TextEditingController(),
           isAuthorizedCityAndStateLoading: false,
           authorizedSelectedCountry: defaultSelectedCountry,
           otherDirectorPinCodeController: TextEditingController(),
           otherDirectorStateNameController: TextEditingController(),
           otherDirectorCityNameController: TextEditingController(),
           otherDirectorAddress1NameController: TextEditingController(),
           otherDirectorAddress2NameController: TextEditingController(),
           isOtherDirectorCityAndStateLoading: false,
           otherDirectorSelectedCountry: defaultSelectedCountry,
           beneficialOwnerPinCodeController: TextEditingController(),
           beneficialOwnerStateNameController: TextEditingController(),
           beneficialOwnerCityNameController: TextEditingController(),
           beneficialOwnerAddress1NameController: TextEditingController(),
           beneficialOwnerAddress2NameController: TextEditingController(),
           isBeneficialOwnerCityAndStateLoading: false,
           beneficialOwnerSelectedCountry: defaultSelectedCountry,
           phoneFocusNode: FocusNode(),
           hufPanNumberFocusNode: FocusNode(),
           businessPanNumberFocusNode: FocusNode(),
           director1PanNumberFocusNode: FocusNode(),
           director2PanNumberFocusNode: FocusNode(),
           beneficialOwnerPanNumberFocusNode: FocusNode(),
           companyPanNumberFocusNode: FocusNode(),
           llpPanNumberFocusNode: FocusNode(),
           partnershipFirmPanNumberFocusNode: FocusNode(),
           soleProprietorShipPanNumberFocusNode: FocusNode(),
           kartaPanNumberFocusNode: FocusNode(),
         ),
       ) {
    on<StepChanged>(_onStepChange);
    on<ChangeBusinessEntityType>(_onChangeBusinessEnityType);
    on<ChangeBusinessMainActivity>(_onChangeBusinessMainActivity);
    on<ChangeBusinessGoodsExport>(_onChangeBusinessGoodsExport);
    on<ChangeBusinessServicesExport>(_onChangeBusinessServicesExport);
    on<ScrollToSection>(_onScrollToSection);
    on<CancelScrollDebounce>(_onCancelScrollDebounce);
    on<BusinessSendOtpPressed>(_onSendOtpPressed);
    on<ChangeMobileNumberPressed>(_onChangeMobileNumberPressed);

    on<BusinessOtpTimerTicked>(_onOtpTimerTicked);
    on<ChangeConfirmPasswordVisibility>(_onChangeConfirmPasswordVisibility);
    on<ChangeCreatePasswordVisibility>(_onChangeCreatePasswordVisibility);
    on<BusinessAccountSignUpSubmitted>(_onBusinessAccountSignUpSubmitted);
    on<ResetSignupSuccess>(_onResetSignupSuccess);
    on<SendBusinessInfoOtp>(_onSendBusinessInfoOtp);
    on<KycStepChanged>(_onKycStepChange);
    on<SendAadharOtp>(_onSendAadharOtp);
    on<ChangeOtpSentStatus>(_onChangeOtpSentStatus);
    on<AadharSendOtpPressed>(_onAadharSendOtpPressed);
    on<AadharOtpTimerTicked>(_onAadharOtpTimerTicked);
    on<AadharNumbeVerified>(_onAadharNumbeVerified);
    on<FrontSlideAadharCardUpload>(_onFrontSlideAadharCardUpload);
    on<BackSlideAadharCardUpload>(_onBackSlideAadharCardUpload);
    on<KartaSendAadharOtp>(_onKartaSendAadharOtp);
    on<KartaChangeOtpSentStatus>(_onKartaChangeOtpSentStatus);
    on<KartaAadharSendOtpPressed>(_onKartaAadharSendOtpPressed);
    on<KartaAadharOtpTimerTicked>(_onKartaAadharOtpTimerTicked);
    on<KartaAadharNumbeVerified>(_onKartaAadharNumbeVerified);
    on<KartaFrontSlideAadharCardUpload>(_onKartaFrontSlideAadharCardUpload);
    on<KartaBackSlideAadharCardUpload>(_onKartaBackSlideAadharCardUpload);
    on<UploadHUFPanCard>(_onUploadHUFPanCard);
    on<HUFPanVerificationSubmitted>(_onHUFPanVerificationSubmitted);
    on<AadharFileUploadSubmitted>(_onAadharFileUploadSubmitted);
    on<KartaAadharFileUploadSubmitted>(_onKartaAadharFileUploadSubmitted);
    on<ChangeSelectedPanUploadOption>(_onChangeSelectedPanUploadOption);
    on<BusinessUploadPanCard>(_onBusinessUploadPanCard);
    on<SaveBusinessPanDetails>(_onSaveBusinessPanDetails);
    on<Director1UploadPanCard>(_onDirector1UploadPanCard);
    on<Director2UploadPanCard>(_onDirector2UploadPanCard);
    on<SaveDirectorPanDetails>(_onSaveDirectorPanDetails);
    on<ChangeDirector1IsBeneficialOwner>(_onChangeDirector1IsBeneficialOwner);
    on<ChangeDirector2IsBeneficialOwner>(_onChangeDirector2IsBeneficialOwner);
    on<ChangeDirector1IsBusinessRepresentative>(_onChangeDirector1IsBusinessRepresentative);
    on<ChangeDirector2IsBusinessRepresentative>(_onChangeDirector2IsBusinessRepresentative);
    on<BeneficialOwnerUploadPanCard>(_onBeneficialOwnerUploadPanCard);
    on<ChangeBeneficialOwnerIsDirector>(_onChangeBeneficialOwnerIsDirector);
    on<ChangeBeneficialOwnerIsBusinessRepresentative>(_onChangeBeneficialOwnerIsBusinessRepresentative);
    on<SaveBeneficialOwnerPanDetails>(_onSaveBeneficialPanDetails);
    on<BusinessRepresentativeUploadPanCard>(_onBusinessRepresentativeUploadPanCard);
    on<ChangeBusinessReresentativeIsBeneficialOwner>(_onChangeBusinessReresentativeIsBeneficialOwner);
    on<ChangeBusinessReresentativeOwnerIsDirector>(_onChangeBusinessReresentativeOwnerIsDirector);
    on<SaveBusinessRepresentativePanDetails>(_onSaveBusinessRepresentativePanDetails);
    on<VerifyPanSubmitted>(_onVerifyPanSubmitted);
    on<UpdateSelectedCountry>(_onUpdateSelectedCountry);
    on<UploadAddressVerificationFile>(_onUploadAddressVerificationFile);
    on<UpdateAddressVerificationDocType>(_onUpdateAddressVerificationDocType);
    on<RegisterAddressSubmitted>(_onRegisterAddressSubmitted);
    on<AnnualTurnOverVerificationSubmitted>(_onAnnualTurnOverVerificationSubmitted);
    on<UploadICECertificate>(_onUploadICECertificate);
    on<IceNumberChanged>(_onIceNumberChanged);
    on<ICEVerificationSubmitted>(_onICEVerificationSubmitted);
    on<UploadGstCertificateFile>(_onUploadGstCertificateFile);
    on<UploadCOICertificate>(_onUploadCOICertificate);
    on<UploadLLPAgreement>(_onUploadLLPAgreement);
    on<UploadPartnershipDeed>(_onUploadPartnershipDeed);
    on<CINVerificationSubmitted>(_onCINVerificationSubmitted);
    on<BankAccountNumberVerify>(_onBankAccountNumberVerify);
    on<UpdateBankAccountVerificationDocType>(_onUpdateBankAccountVerificationDocType);
    on<UploadBankAccountVerificationFile>(_onUploadBankAccountVerificationFile);
    on<BankAccountDetailSubmitted>(_onBankAccountDetailSubmitted);
    on<ChangeEstimatedMonthlyTransaction>(_onChangeEstimatedMonthlyTransaction);
    on<ToggleCurrencySelection>(_onToggleCurrencySelection);
    on<BusinessTranscationDetailSubmitted>(_onBusinessTranscationDetailSubmitted);
    on<ResetData>(_onResetData);
    on<ValidateBusinessOtp>(_onValidateBusinessOtp);
    on<UpdateBusinessNatureString>(_onUpdateBusinessNatureString);
    on<GetBusinessCurrencyOptions>(_onGetBusinessCurrencyOptions);
    on<ChangeAnnualTurnover>(_onChangeAnnualTurnover);
    on<BusinessAppBarCollapseChanged>(_onBusinessAppBarCollapseChanged);
    on<BusinessEkycAppBarCollapseChanged>(_onBusinessEkycAppBarCollapseChanged);
    on<DirectorCaptchaSend>(_onDirectorCaptchaSend);
    on<DirectorReCaptchaSend>(_onDirectorReCaptchaSend);
    on<KartaCaptchaSend>(_onKartaCaptchaSend);
    on<KartaReCaptchaSend>(_onKartaReCaptchaSend);
    on<PartnerSendAadharOtp>(_onPartnerSendAadharOtp);
    on<PartnerChangeOtpSentStatus>(_onPartnerChangeOtpSentStatus);
    on<PartnerAadharSendOtpPressed>(_onPartnerAadharSendOtpPressed);
    on<PartnerAadharOtpTimerTicked>(_onPartnerAadharOtpTimerTicked);
    on<PartnerAadharNumbeVerified>(_onPartnerAadharNumbeVerified);
    on<PartnerFrontSlideAadharCardUpload>(_onPartnerFrontSlideAadharCardUpload);
    on<PartnerBackSlideAadharCardUpload>(_onPartnerBackSlideAadharCardUpload);
    on<PartnerAadharFileUploadSubmitted>(_onPartnerAadharFileUploadSubmitted);
    on<PartnerCaptchaSend>(_onPartnerCaptchaSend);
    on<PartnerReCaptchaSend>(_onPartnerReCaptchaSend);
    on<ProprietorSendAadharOtp>(_onProprietorSendAadharOtp);
    on<ProprietorChangeOtpSentStatus>(_onProprietorChangeOtpSentStatus);
    on<ProprietorAadharSendOtpPressed>(_onProprietorAadharSendOtpPressed);
    on<ProprietorAadharOtpTimerTicked>(_onProprietorAadharOtpTimerTicked);
    on<ProprietorAadharNumbeVerified>(_onProprietorAadharNumbeVerified);
    on<ProprietorFrontSlideAadharCardUpload>(_onProprietorFrontSlideAadharCardUpload);
    on<ProprietorBackSlideAadharCardUpload>(_onProprietorBackSlideAadharCardUpload);
    on<ProprietorAadharFileUploadSubmitted>(_onProprietorAadharFileUploadSubmitted);
    on<ProprietorCaptchaSend>(_onProprietorCaptchaSend);
    on<ProprietorReCaptchaSend>(_onProprietorReCaptchaSend);
    on<DirectorAadharNumberChanged>(_onDirectorAadharNumberChanged);
    on<KartaAadharNumberChanged>(_onKartaAadharNumberChanged);
    on<PartnerAadharNumberChanged>(_onPartnerAadharNumberChanged);
    on<ProprietorAadharNumberChanged>(_onProprietorAadharNumberChanged);
    on<LoadBusinessKycFromLocal>(_onLoadBusinessKycFromLocal);
    on<BusinessGetCityAndState>(_onBusinessGetCityAndState);
    on<LLPINVerificationSubmitted>(_onLLPINVerificationSubmitted);
    on<PartnerShipDeedVerificationSubmitted>(_onPartnerShipDeedVerificationSubmitted);
    on<BusinessGSTVerification>(_onBusinessGSTVerification);
    on<GetHUFPanDetails>(_onGetHUFPanDetails);
    on<HUFPanNumberChanged>(_onHUFPanNumberChanged);
    on<GetDirector1PanDetails>(_onGetDirector1PanDetails);
    on<Director1PanNumberChanged>(_onDirector1PanNumberChanged);
    on<GetDirector2PanDetails>(_onGetDirector2PanDetails);
    on<Director2PanNumberChanged>(_onDirector2PanNumberChanged);
    on<GetBeneficialOwnerPanDetails>(_onGetBeneficialOwnerPanDetails);
    on<BeneficialOwnerPanNumberChanged>(_onBeneficialOwnerPanNumberChanged);
    // on<GetBusinessRepresentativePanDetails>(_onGetBusinessRepresentativePanDetails);
    // on<BusinessRepresentativePanNumberChanged>(_onBusinessRepresentativePanNumberChanged);
    on<ContactInformationSubmitted>(_onContactInformationSubmitted);
    on<SaveOtherDirectorPanDetails>(_onSaveOtherDirectorPanDetails);

    // Other Director Aadhar Events
    on<OtherDirectorAadharNumberChanged>(_onOtherDirectorAadharNumberChanged);
    on<OtherDirectorCaptchaSend>(_onOtherDirectorCaptchaSend);
    on<OtherDirectorReCaptchaSend>(_onOtherDirectorReCaptchaSend);
    on<OtherDirectorSendAadharOtp>(_onOtherDirectorSendAadharOtp);
    on<OtherDirectorAadharNumbeVerified>(_onOtherDirectorAadharNumbeVerified);
    on<OtherDirectorFrontSlideAadharCardUpload>(_onOtherDirectorFrontSlideAadharCardUpload);
    on<OtherDirectorBackSlideAadharCardUpload>(_onOtherDirectorBackSlideAadharCardUpload);
    on<OtherDirectorAadharFileUploadSubmitted>(_onOtherDirectorAadharFileUploadSubmitted);
    on<OtherDirectorAadharSendOtpPressed>(_onOtherDirectorAadharSendOtpPressed);
    on<OtherDirectorAadharOtpTimerTicked>(_onOtherDirectorAadharOtpTimerTicked);
    on<DirectorKycStepChanged>(_onDirectorKycStepChange);
    on<OtherDirectorKycStepChanged>(_onOtherDirectorKycStepChange);
    on<ShowBusinessRepresentativeSelectionDialog>(_onShowBusinessRepresentativeSelectionDialog);
    on<SelectBusinessRepresentative>(_onSelectBusinessRepresentative);
    on<OtherDirectorShowDialogWidthoutAadharUpload>(_onOtherDirectorShowDialogWidthoutAadharUpload);
    on<ConfirmBusinessRepresentativeAndNextStep>(_onConfirmBusinessRepresentativeAndNextStep);
    on<CompanyPanNumberChanged>(_onCompanyPanNumberChanged);
    on<GetCompanyPanDetails>(_onGetCompanyPanDetails);
    on<UploadCompanyPanCard>(_onUploadCompanyPanCard);
    on<CompanyPanVerificationSubmitted>(_onCompanyPanVerificationSubmitted);
    on<NavigateToNextKycStep>(_onNavigateToNextKycStep);
    on<NavigateToPreviousKycStep>(_onNavigateToPreviousKycStep);
    on<GetAvailableKycSteps>(_onGetAvailableKycSteps);
    on<UploadLLPPanCard>(_onUploadLLPPanCard);
    on<LLPPanVerificationSubmitted>(_onLLPPanVerificationSubmitted);
    on<GetLLPPanDetails>(_onGetLLPPanDetails);
    on<LLPPanNumberChanged>(_onLLPPanNumberChanged);
    on<UploadPartnershipFirmPanCard>(_onUploadPartnershipFirmPanCard);
    on<PartnershipFirmPanVerificationSubmitted>(_onPartnershipFirmPanVerificationSubmitted);
    on<GetPartnershipFirmPanDetails>(_onGetPartnershipFirmPanDetails);
    on<PartnershipFirmPanNumberChanged>(_onPartnershipFirmPanNumberChanged);
    on<UploadSoleProprietorShipPanCard>(_onUploadSoleProprietorShipPanCard);
    on<SoleProprietorShipPanVerificationSubmitted>(_onSoleProprietorShipPanVerificationSubmitted);
    on<GetSoleProprietorShipPanDetails>(_onGetSoleProprietorShipPanDetails);
    on<SoleProprietorShipPanNumberChanged>(_onSoleProprietorShipPanNumberChanged);
    on<UploadKartaPanCard>(_onUploadKartaPanCard);
    on<KartaPanVerificationSubmitted>(_onKartaPanVerificationSubmitted);
    on<GetKartaPanDetails>(_onGetKartaPanDetails);
    on<KartaPanNumberChanged>(_onKartaPanNumberChanged);
    on<ChangeAadharAddressSameAsResidentialAddress>(_onChangeAadharAddressSameAsResidentialAddress);
    on<UpdateAuthorizedSelectedCountry>(_onUpdateAuthorizedSelectedCountry);
    on<BusinessAuthorizedGetCityAndState>(_onBusinessAuthorizedGetCityAndState);
    on<ChangeOtherDirectorAadharAddressSameAsResidentialAddress>(
      _onChangeOtherDirectorAadharAddressSameAsResidentialAddress,
    );
    on<UpdateOtherDirectorSelectedCountry>(_onUpdateOtherDirectorSelectedCountry);
    on<BusinessOtherDirectorGetCityAndState>(_onBusinessOtherDirectorGetCityAndState);
    on<BeneficialOwnerKycStepChanged>(_onBeneficialOwnerKycStepChanged);
    on<UpdateBeneficialOwnerSelectedCountry>(_onUpdateBeneficialOwnerSelectedCountry);
    on<BusinessBeneficialOwnerGetCityAndState>(_onBusinessBeneficialOwnerGetCityAndState);
    on<BusinessBeneficialOwnerAddressDetailsSubmitted>(_onBusinessBeneficialOwnerAddressDetailsSubmitted);
    on<UploadBeneficialOwnershipDeclaration>(_onUploadBeneficialOwnershipDeclaration);
    on<BeneficialOwnershipDeclarationSubmitted>(_onBeneficialOwnershipDeclarationSubmitted);
    on<VerifyLLPPanSubmitted>(_onVerifyLLPPanSubmitted);
    on<VerifyPartnershipFirmPanSubmitted>(_onVerifyPartnershipFirmPanSubmitted);
    on<HUFPanEditAttempt>(_onHUFPanEditAttempt);
    on<PartnershipFirmPanEditAttempt>(_onPartnershipFirmPanEditAttempt);
    on<SoleProprietorShipPanEditAttempt>(_onSoleProprietorShipPanEditAttempt);
    on<CompanyPanEditAttempt>(_onCompanyPanEditAttempt);
    on<KartaPanEditAttempt>(_onKartaPanEditAttempt);
    on<BeneficialOwnerPanEditAttempt>(_onBeneficialOwnerPanEditAttempt);
    on<LLPPanEditAttempt>(_onLLPPanEditAttempt);
    on<Director1PanEditAttempt>(_onDirector1PanEditAttempt);
    on<Director2PanEditAttempt>(_onDirector2PanEditAttempt);
    on<GSTINOrIECHasUploaded>(_onGSTINOrIECHasUploaded);
    on<UploadShopEstablishmentCertificate>(_onUploadShopEstablishmentCertificate);
    on<UploadUdyamCertificate>(_onUploadUdyamCertificate);
    on<UploadTaxProfessionalTaxRegistration>(_onUploadTaxProfessionalTaxRegistration);
    on<UploadUtilityBill>(_onUploadUtilityBill);
    on<BusinessDocumentsVerificationSubmitted>(_onBusinessDocumentsVerificationSubmitted);
    on<ICEVerificationSkipped>(_onICEVerificationSkipped);
    on<DeleteDocument>(_onDeleteDocument);
    on<AnnualTurnoverScrollToSection>(_onAnnualTurnoverScrollToSection);
    on<OtherDirectorEnableAadharEdit>(_onOtherDirectorEnableAadharEdit);
    on<ProprietorEnableAadharEdit>(_onProprietorEnableAadharEdit);
    on<LoadFilesFromApi>(_onLoadFilesFromApi);
    on<DirectorEnableAadharEdit>(_onDirectorEnableAadharEdit);

    // Data change tracking event handlers
    on<MarkIdentityVerificationDataChanged>(_onMarkIdentityVerificationDataChanged);
    on<MarkPanDetailsDataChanged>(_onMarkPanDetailsDataChanged);
    on<MarkResidentialAddressDataChanged>(_onMarkResidentialAddressDataChanged);
    on<MarkAnnualTurnoverDataChanged>(_onMarkAnnualTurnoverDataChanged);
    on<MarkBankAccountDataChanged>(_onMarkBankAccountDataChanged);
    on<MarkIceVerificationDataChanged>(_onMarkIceVerificationDataChanged);
    on<MarkBusinessDocumentsDataChanged>(_onMarkBusinessDocumentsDataChanged);

    // Screen-specific data change tracking event handlers
    on<MarkProprietorAadharDataChanged>(_onMarkProprietorAadharDataChanged);
    on<MarkSoleProprietorshipPanDataChanged>(_onMarkSoleProprietorshipPanDataChanged);
    on<MarkPartnershipFirmPanDataChanged>(_onMarkPartnershipFirmPanDataChanged);
    on<MarkLLPPanDataChanged>(_onMarkLLPPanDataChanged);
    on<MarkKartaPanDataChanged>(_onMarkKartaPanDataChanged);
    on<MarkHUFPanDataChanged>(_onMarkHUFPanDataChanged);
    on<MarkCompanyPanDataChanged>(_onMarkCompanyPanDataChanged);
    on<MarkCompanyIncorporationDataChanged>(_onMarkCompanyIncorporationDataChanged);
    on<MarkContactInformationDataChanged>(_onMarkContactInformationDataChanged);
    on<MarkBeneficialOwnershipDataChanged>(_onMarkBeneficialOwnershipDataChanged);
    on<MarkPanDetailViewDataChanged>(_onMarkPanDetailViewDataChanged);
    on<ResetDataChangeFlags>(_onResetDataChangeFlags);
    on<BusinessStoreOriginalGstNumber>(_onBusinessStoreOriginalGstNumber);
    on<BusinessStoreOriginalBankAccountNumber>(_onBusinessStoreOriginalBankAccountNumber);
    on<BusinessStoreOriginalAadharNumber>(_onBusinessStoreOriginalAadharNumber);
    on<BusinessStoreOriginalPanNumber>(_onBusinessStoreOriginalPanNumber);
    // Director and proprietor store original events
    on<BusinessStoreOriginalDirector1PanNumber>(_onBusinessStoreOriginalDirector1PanNumber);
    on<BusinessStoreOriginalDirector2PanNumber>(_onBusinessStoreOriginalDirector2PanNumber);
    on<BusinessStoreOriginalDirector1AadharNumber>(_onBusinessStoreOriginalDirector1AadharNumber);
    on<BusinessStoreOriginalDirector2AadharNumber>(_onBusinessStoreOriginalDirector2AadharNumber);
    on<BusinessStoreOriginalProprietorAadharNumber>(_onBusinessStoreOriginalProprietorAadharNumber);

    // Start cron job every 10 minutes to refresh only file data
    cron = Cron();
    cron!.schedule(Schedule.parse('*/10 * * * *'), () async {
      await _refreshKycFileData();
    });
  }

  void _onStepChange(StepChanged event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(currentStep: event.stepIndex));
  }

  void _onChangeBusinessEnityType(ChangeBusinessEntityType event, Emitter<BusinessAccountSetupState> emit) async {
    try {
      await Prefobj.preferences.put(Prefkeys.businessEntityType, event.selectedIndex);
      emit(state.copyWith(selectedBusinessEntityType: event.selectedIndex));
    } catch (e) {
      Logger.error('Error saving business entity type: $e');
    }
  }

  void _onChangeAnnualTurnover(ChangeAnnualTurnover event, Emitter<BusinessAccountSetupState> emit) async {
    try {
      bool isMandatory = !(event.selectedIndex.contains("Less than"));
      emit(
        state.copyWith(
          selectedAnnualTurnover: event.selectedIndex,
          isGstCertificateMandatory: isMandatory,
          isGSTNumberVerify: false,
          gstCertificateFile: null,
          gstLegalName: '',
          gstNumberController: TextEditingController(),
        ),
      );
    } catch (e) {
      Logger.error('Error saving business entity type: $e');
    }
  }

  void _onChangeEstimatedMonthlyTransaction(
    ChangeEstimatedMonthlyTransaction event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    try {
      emit(state.copyWith(selectedEstimatedMonthlyTransaction: event.selectedTransaction));
    } catch (e) {
      Logger.error('Error saving business entity type: $e');
    }
  }

  void _onChangeBusinessMainActivity(ChangeBusinessMainActivity event, Emitter<BusinessAccountSetupState> emit) {
    state.goodsExportOtherController.clear();
    state.serviceExportOtherController.clear();
    state.businessActivityOtherController.clear();
    state.goodsAndServiceExportDescriptionController.clear();
    emit(
      state.copyWith(
        selectedBusinessMainActivity: event.selected,
        selectedbusinessGoodsExportType: [],
        selectedbusinessServiceExportType: [],
      ),
    );
    // The string value should be set from the UI by dispatching UpdateBusinessNatureString
  }

  void _onChangeBusinessGoodsExport(ChangeBusinessGoodsExport event, Emitter<BusinessAccountSetupState> emit) {
    final currentSelections = List<String>.from(state.selectedbusinessGoodsExportType ?? []);
    if (event.selectedIndex == 'Others') {
      emit(state.copyWith(selectedbusinessGoodsExportType: ['Others']));
    } else {
      if (currentSelections.contains('Others')) {
        currentSelections.remove('Others');
      }
      if (currentSelections.contains(event.selectedIndex)) {
        currentSelections.remove(event.selectedIndex);
      } else {
        currentSelections.add(event.selectedIndex);
      }
      emit(state.copyWith(selectedbusinessGoodsExportType: currentSelections));
    }
  }

  void _onChangeBusinessServicesExport(ChangeBusinessServicesExport event, Emitter<BusinessAccountSetupState> emit) {
    final currentSelections = List<String>.from(state.selectedbusinessServiceExportType ?? []);
    if (event.selectedIndex == 'Others') {
      emit(state.copyWith(selectedbusinessServiceExportType: ['Others']));
    } else {
      if (currentSelections.contains('Others')) {
        currentSelections.remove('Others');
      }
      if (currentSelections.contains(event.selectedIndex)) {
        currentSelections.remove(event.selectedIndex);
      } else {
        currentSelections.add(event.selectedIndex);
      }
      emit(state.copyWith(selectedbusinessServiceExportType: currentSelections));
    }
  }

  Future<void> _onSendOtpPressed(BusinessSendOtpPressed event, Emitter<BusinessAccountSetupState> emit) async {
    try {
      emit(state.copyWith(isSendOtpLoading: true));
      final mobileAvailability = await _authRepository.mobileAvailability(mobileNumber: state.phoneController.text);
      if (mobileAvailability.data?.exists == true) {
        AppToast.show(message: 'Mobile number already exists', type: ToastificationType.error);
        emit(state.copyWith(isSendOtpLoading: false));
        return;
      }

      final response = await _authRepository.sendOtp(mobile: state.phoneController.text, type: 'registration');
      if (response.success == true) {
        AppToast.show(message: response.message ?? '', type: ToastificationType.success);
        _timer?.cancel();
        emit(
          state.copyWith(
            isOtpTimerRunning: true,
            otpRemainingTime: initialTime,
            isBusinessInfoOtpSent: true,
            isSendOtpLoading: false,
          ),
        );
        _timer = Timer.periodic(Duration(seconds: 1), (timer) {
          final newTime = state.otpRemainingTime - 1;
          if (newTime <= 0) {
            timer.cancel();
            add(BusinessOtpTimerTicked(0));
          } else {
            add(BusinessOtpTimerTicked(newTime));
          }
        });
      }
    } catch (e) {
      emit(state.copyWith(isSendOtpLoading: false));
      Logger.error(e.toString());
    }
  }

  void _onChangeMobileNumberPressed(ChangeMobileNumberPressed event, Emitter<BusinessAccountSetupState> emit) {
    // Cancel the existing timer if running
    _timer?.cancel();

    // Clear the OTP controller
    state.otpController.clear();

    // Reset the OTP-related state to allow user to change mobile number
    emit(
      state.copyWith(
        isBusinessInfoOtpSent: false,
        isOtpTimerRunning: false,
        otpRemainingTime: 0,
        isBusinessOtpValidating: false,
        isSendOtpLoading: false,
      ),
    );
  }

  void _onOtpTimerTicked(BusinessOtpTimerTicked event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(otpRemainingTime: event.remainingTime, isOtpTimerRunning: event.remainingTime > 0));
  }

  void _onChangeCreatePasswordVisibility(
    ChangeCreatePasswordVisibility event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(isCreatePasswordObscure: event.obscuredText));
  }

  void _onChangeConfirmPasswordVisibility(
    ChangeConfirmPasswordVisibility event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(isConfirmPasswordObscure: event.obscuredText));
  }

  void _onBusinessAccountSignUpSubmitted(
    BusinessAccountSignUpSubmitted event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    emit(state.copyWith(isSignupLoading: true));
    try {
      final emailId = await Prefobj.preferences.get(Prefkeys.verifyemailToken) ?? '';
      final tosacceptance = await UserAgentHelper.getPlatformMetaInfo();
      // final List<String> multicurrencyStrings =
      //     (state.selectedCurrencies ?? [])
      //         .map((currency) => '${currency.currencySymbol} ${currency.currencyName}')
      //         .toList();

      List<String> exportstype = [];
      if (state.selectedBusinessMainActivity == BusinessMainActivity.others) {
        if (state.businessActivityOtherController.text.trim().isNotEmpty) {
          exportstype = [state.businessActivityOtherController.text.trim()];
        }
      } else {
        if ((state.selectedbusinessGoodsExportType?.isNotEmpty ?? false)) {
          if (state.selectedbusinessGoodsExportType!.length == 1 &&
              state.selectedbusinessGoodsExportType!.first == 'Others') {
            if (state.goodsExportOtherController.text.trim().isNotEmpty) {
              exportstype = [state.goodsExportOtherController.text.trim()];
            } else {
              exportstype = state.selectedbusinessGoodsExportType!;
            }
          } else {
            exportstype = state.selectedbusinessGoodsExportType!;
          }
        } else if ((state.selectedbusinessServiceExportType?.isNotEmpty ?? false)) {
          if (state.selectedbusinessServiceExportType!.length == 1 &&
              state.selectedbusinessServiceExportType!.first == 'Others') {
            if (state.serviceExportOtherController.text.trim().isNotEmpty) {
              exportstype = [state.serviceExportOtherController.text.trim()];
            } else {
              exportstype = state.selectedbusinessServiceExportType!;
            }
          } else {
            exportstype = state.selectedbusinessServiceExportType!;
          }
        } else if (state.goodsAndServiceExportDescriptionController.text.trim().isNotEmpty) {
          exportstype = [state.goodsAndServiceExportDescriptionController.text.trim()];
        }
      }

      String selectedBusinessType() {
        if (state.selectedBusinessEntityType == "Company") {
          return 'company';
        } else if (state.selectedBusinessEntityType == "HUF (Hindu Undivided Family)") {
          return 'hindu_undivided_family';
        } else if (state.selectedBusinessEntityType == "LLP (Limited Liability Partnership)") {
          return 'limited_liability_partnership';
        } else if (state.selectedBusinessEntityType == "Partnership Firm") {
          return 'partnership';
        } else if (state.selectedBusinessEntityType == "Sole Proprietorship") {
          return 'sole_proprietor';
        } else {
          return '';
        }
      }

      String extractLastAmount(String value) {
        // This will match numbers with optional commas
        final regex = RegExp(r'([\d,]+)(?!.*\d)');
        final match = regex.firstMatch(value);
        return match != null ? match.group(0)!.replaceAll(',', '') : '';
      }

      final response = await _authRepository.registerBusinessUser(
        email: emailId,
        // estimatedMonthlyVolume: state.selectedEstimatedMonthlyTransaction ?? '',
        estimatedMonthlyVolume: extractLastAmount(state.selectedEstimatedMonthlyTransaction ?? ''),
        // multicurrency: multicurrencyStrings,
        mobileNumber: state.phoneController.text,
        businesstype: selectedBusinessType(),
        businessnature: state.businessNatureString ?? '',
        exportstype: exportstype,
        businesslegalname: state.businessLegalNameController.text,
        password: state.createPasswordController.text,
        tosacceptance: tosacceptance,
        usertype: 'business',
        username: state.businessLegalNameController.text,
        website: state.professionalWebsiteUrl.text,
        doingBusinessAs: state.dbaController.text,
      );
      if (response.success == true) {
        // AppToast.show(message: 'Business user created successfully', type: ToastificationType.success);
        await Prefobj.preferences.put(Prefkeys.authToken, 'exchek@123');
        await Prefobj.preferences.delete(Prefkeys.verifyemailToken);
        emit(state.copyWith(isSignupLoading: false, isSignupSuccess: true));
      } else {
        emit(state.copyWith(isSignupLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isSignupLoading: false));
    }
  }

  void _onResetSignupSuccess(ResetSignupSuccess event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(isSignupSuccess: false));
  }

  void _onSendBusinessInfoOtp(SendBusinessInfoOtp event, Emitter<BusinessAccountSetupState> emit) async {
    try {
      add(BusinessSendOtpPressed());
      emit(state.copyWith(isBusinessInfoOtpSent: true));
    } catch (e) {
      emit(state.copyWith(isBusinessInfoOtpSent: false));
    }
  }

  void _onKycStepChange(KycStepChanged event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(currentKycVerificationStep: event.stepIndex));
  }

  void _onSendAadharOtp(SendAadharOtp event, Emitter<BusinessAccountSetupState> emit) async {
    try {
      state.aadharOtpController.clear();
      emit(state.copyWith(isOtpSent: false, isDirectorAadharOtpLoading: true, isAadharOTPInvalidate: ''));

      // Simulate API call for now - replace with actual API call when ready
      await Future.delayed(Duration(seconds: 1)); // Simulate network delay

      AadharOTPSendModel response = await _businessUserKycRepository.generateAadharOTP(
        aadhaarNumber: event.aadhar.replaceAll("-", ""),
        captcha: event.captcha,
        sessionId: event.sessionId,
      );
      if (response.code == 200) {
        emit(state.copyWith(isOtpSent: true, isDirectorAadharOtpLoading: false));
        add(AadharSendOtpPressed()); // Start the timer only after successful OTP send
      } else {
        AppToast.show(message: response.message ?? '', type: ToastificationType.error);
        emit(state.copyWith(isDirectorAadharOtpLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isOtpSent: false, isDirectorAadharOtpLoading: false));
      Logger.error(e.toString());
    }
  }

  void _onChangeOtpSentStatus(ChangeOtpSentStatus event, Emitter<BusinessAccountSetupState> emit) async {
    emit(state.copyWith(isOtpSent: event.isOtpSent));
  }

  void _onAadharSendOtpPressed(AadharSendOtpPressed event, Emitter<BusinessAccountSetupState> emit) {
    _aadhartimer?.cancel();
    emit(state.copyWith(isAadharOtpTimerRunning: true, aadharOtpRemainingTime: initialTime));
    _aadhartimer = Timer.periodic(Duration(seconds: 1), (timer) {
      final newTime = state.aadharOtpRemainingTime - 1;
      if (newTime <= 0) {
        timer.cancel();
        add(AadharOtpTimerTicked(0));
      } else {
        add(AadharOtpTimerTicked(newTime));
      }
    });
  }

  void _onAadharOtpTimerTicked(AadharOtpTimerTicked event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(aadharOtpRemainingTime: event.remainingTime, isAadharOtpTimerRunning: event.remainingTime > 0));
  }

  void _onAadharNumbeVerified(AadharNumbeVerified event, Emitter<BusinessAccountSetupState> emit) async {
    // Skip API if Aadhaar unchanged from original and no data changed, and already verified
    final bool unchangedFromOriginal =
        state.originalDirector1AadharNumber != null && state.originalDirector1AadharNumber == event.aadharNumber;
    if (unchangedFromOriginal && !state.isIdentityVerificationDataChanged && state.isAadharVerified == true) {
      emit(state.copyWith(isAadharVerifiedLoading: false, isAadharVerified: true));
      return;
    }
    emit(state.copyWith(isAadharVerifiedLoading: true, isAadharOTPInvalidate: ''));
    try {
      final sessionId = await Prefobj.preferences.get(Prefkeys.sessionId) ?? '';
      final userId = await Prefobj.preferences.get(Prefkeys.userId) ?? '';
      final userJson = await Prefobj.preferences.get(Prefkeys.userKycDetail);
      final userData = jsonDecode(userJson!);
      final businessDetails = userData['business_details'] ?? {};
      final businessType = businessDetails['business_type'] ?? '';

      String kycRole = '';
      if (businessType == 'limited_liability_partnership' || businessType == 'partnership') {
        kycRole = "AUTH_PARTNER";
      } else {
        kycRole = "AUTH_DIRECTOR";
      }

      final AadharOTPVerifyModel response = await _businessUserKycRepository.validateAadharOtp(
        faker: false,
        otp: event.otp,
        sessionId: sessionId,
        userId: userId,
        kycRole: kycRole,
        userType: 'business',
        aadhaarNumber: event.aadharNumber,
      );
      if (response.code == 200) {
        emit(state.copyWith(isAadharVerifiedLoading: false, isAadharVerified: true, aadharNumber: event.aadharNumber));
        _aadhartimer?.cancel();
      } else {
        emit(state.copyWith(isAadharVerifiedLoading: false, isAadharOTPInvalidate: response.message.toString()));
      }
    } catch (e) {
      emit(state.copyWith(isAadharVerifiedLoading: false));
      Logger.error(e.toString());
    }
  }

  void _onFrontSlideAadharCardUpload(FrontSlideAadharCardUpload event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(isFrontSideAdharFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(frontSideAdharFile: null, isFrontSideAdharFileDeleted: true));
    } else {
      emit(state.copyWith(frontSideAdharFile: event.fileData, isFrontSideAdharFileDeleted: false));
    }
  }

  void _onBackSlideAadharCardUpload(BackSlideAadharCardUpload event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(isBackSideAdharFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(backSideAdharFile: null, isBackSideAdharFileDeleted: true));
    } else {
      emit(state.copyWith(backSideAdharFile: event.fileData, isBackSideAdharFileDeleted: false));
    }
  }

  void _onKartaSendAadharOtp(KartaSendAadharOtp event, Emitter<BusinessAccountSetupState> emit) async {
    try {
      state.kartaAadharOtpController.clear();
      emit(state.copyWith(isKartaOtpSent: false, isKartaOtpLoading: true, kartaIsAadharOTPInvalidate: ''));
      AadharOTPSendModel response = await _businessUserKycRepository.generateAadharOTP(
        aadhaarNumber: event.aadhar.replaceAll("-", ""),
        captcha: event.captcha,
        sessionId: event.sessionId,
      );
      if (response.code == 200) {
        emit(state.copyWith(isKartaOtpSent: true, isKartaOtpLoading: false));
        add(KartaAadharSendOtpPressed());
      } else {
        AppToast.show(message: response.message ?? '', type: ToastificationType.error);
        emit(state.copyWith(isKartaOtpLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isKartaOtpSent: false));
    }
  }

  void _onKartaChangeOtpSentStatus(KartaChangeOtpSentStatus event, Emitter<BusinessAccountSetupState> emit) async {
    emit(state.copyWith(isKartaOtpSent: event.isOtpSent));
  }

  void _onKartaAadharSendOtpPressed(KartaAadharSendOtpPressed event, Emitter<BusinessAccountSetupState> emit) {
    _kartaAadhartimer?.cancel();
    emit(state.copyWith(isKartaAadharOtpTimerRunning: true, kartaAadharOtpRemainingTime: initialTime));
    _kartaAadhartimer = Timer.periodic(Duration(seconds: 1), (timer) {
      final newTime = state.kartaAadharOtpRemainingTime - 1;
      if (newTime <= 0) {
        timer.cancel();
        add(KartaAadharOtpTimerTicked(0));
      } else {
        add(KartaAadharOtpTimerTicked(newTime));
      }
    });
  }

  void _onKartaAadharOtpTimerTicked(KartaAadharOtpTimerTicked event, Emitter<BusinessAccountSetupState> emit) {
    emit(
      state.copyWith(
        kartaAadharOtpRemainingTime: event.remainingTime,
        isKartaAadharOtpTimerRunning: event.remainingTime > 0,
      ),
    );
  }

  void _onKartaAadharNumbeVerified(KartaAadharNumbeVerified event, Emitter<BusinessAccountSetupState> emit) async {
    emit(state.copyWith(isKartaAadharVerifiedLoading: true, kartaIsAadharOTPInvalidate: null));
    try {
      final sessionId = await Prefobj.preferences.get(Prefkeys.sessionId) ?? '';
      final userId = await Prefobj.preferences.get(Prefkeys.userId) ?? '';

      final AadharOTPVerifyModel response = await _businessUserKycRepository.validateAadharOtp(
        faker: false,
        otp: event.otp,
        sessionId: sessionId,
        userId: userId,
        userType: 'business',
        aadhaarNumber: event.aadharNumber,
      );
      if (response.code == 200) {
        emit(
          state.copyWith(
            isKartaAadharVerifiedLoading: false,
            isKartaAadharVerified: true,
            kartaAadharNumber: event.aadharNumber,
          ),
        );
        _kartaAadhartimer?.cancel();
      } else {
        emit(
          state.copyWith(isKartaAadharVerifiedLoading: false, kartaIsAadharOTPInvalidate: response.message.toString()),
        );
      }
    } catch (e) {
      emit(state.copyWith(isKartaAadharVerifiedLoading: false));
      Logger.error(e.toString());
    }
  }

  void _onKartaFrontSlideAadharCardUpload(
    KartaFrontSlideAadharCardUpload event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(isKartaFrontSideAdharFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(kartaFrontSideAdharFile: null, isKartaFrontSideAdharFileDeleted: true));
    } else {
      emit(state.copyWith(kartaFrontSideAdharFile: event.fileData, isKartaFrontSideAdharFileDeleted: false));
    }
  }

  void _onKartaBackSlideAadharCardUpload(
    KartaBackSlideAadharCardUpload event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(isKartaBackSideAdharFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(kartaBackSideAdharFile: null, isKartaBackSideAdharFileDeleted: true));
    } else {
      emit(state.copyWith(kartaBackSideAdharFile: event.fileData, isKartaBackSideAdharFileDeleted: false));
    }
  }

  void _onUploadHUFPanCard(UploadHUFPanCard event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(isHUFPanCardFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(hufPanCardFile: null, isHUFPanCardFileDeleted: true));
    } else {
      emit(state.copyWith(hufPanCardFile: event.fileData, isHUFPanCardFileDeleted: false));
    }
  }

  void _onHUFPanVerificationSubmitted(
    HUFPanVerificationSubmitted event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    // Check if data has changed and files are already uploaded
    if (!state.isHUFPanDataChanged && state.hufPanCardFile != null) {
      // Skip API call and navigate to next step
      final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
      if (nextStep != null) {
        add(KycStepChanged(nextStep));
      }
      return;
    }

    emit(state.copyWith(isHUFPanVerifyingLoading: true));

    try {
      final String? userId = await Prefobj.preferences.get(Prefkeys.userId);

      final response = await _personalUserKycRepository.uploadPanDetails(
        userID: userId ?? '',
        userType: 'business',
        panNumber: state.hufPanNumberController.text.trim(),
        nameOnPan: state.fullHUFNamePan ?? '',
        panDoc: state.hufPanCardFile!,
        kycRole: "HUF",
      );
      if (response.success == true) {
        // Reset data change flag after successful API call
        add(ResetDataChangeFlags());
        final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
        if (nextStep != null) {
          add(KycStepChanged(nextStep));
        }
        emit(state.copyWith(isHUFPanVerifyingLoading: false));
      } else {
        emit(state.copyWith(isHUFPanVerifyingLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isHUFPanVerifyingLoading: false));
    }
  }

  void _onIceNumberChanged(IceNumberChanged event, Emitter<BusinessAccountSetupState> emit) {
    final uppercased = event.iceNumber.toUpperCase();

    // Update the controller text if changed to avoid loops
    if (state.iceNumberController.text != uppercased) {
      // Preserve the cursor position
      final selection = state.iceNumberController.selection;
      state.iceNumberController.value = TextEditingValue(text: uppercased, selection: selection);
    }

    // Emit new state with updated controller (optional, controller is updated by ref)
    emit(state.copyWith());
  }

  void _onUploadICECertificate(UploadICECertificate event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(isIceCertificateFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(iceCertificateFile: null, isIceCertificateFileDeleted: true));
    } else {
      emit(state.copyWith(iceCertificateFile: event.fileData, isIceCertificateFileDeleted: false));
    }
  }

  void _onICEVerificationSubmitted(ICEVerificationSubmitted event, Emitter<BusinessAccountSetupState> emit) async {
    // Check if data has changed and files are already uploaded
    if (!state.isIceVerificationDataChanged && event.fileData != null) {
      // Skip API call and navigate to next step
      final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
      if (nextStep != null) {
        add(KycStepChanged(nextStep));
      }
      return;
    }

    emit(state.copyWith(isIceVerifyingLoading: true));
    final String? userId = await Prefobj.preferences.get(Prefkeys.userId);
    try {
      final response = await _personalUserKycRepository.uploadBusinessLegalDocuments(
        userID: userId ?? '',
        userType: 'business',
        documentType: 'IEC',
        documentNumber: event.iceNumber ?? '',
        documentFrontImage: event.fileData,
      );
      if (response.success == true) {
        // Reset data change flag after successful API call
        add(ResetDataChangeFlags());
        final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
        if (nextStep != null) {
          add(KycStepChanged(nextStep));
        }
        emit(state.copyWith(isIceVerifyingLoading: false));
      } else {
        emit(state.copyWith(isIceVerifyingLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isIceVerifyingLoading: false));
    }
  }

  void _onAadharFileUploadSubmitted(AadharFileUploadSubmitted event, Emitter<BusinessAccountSetupState> emit) async {
 //   emit(state.copyWith(isAadharFileUploading: true, isAuthorizedDirectorKycVerify: false));

    try {
      emit(state.copyWith(isAadharFileUploading: false, isAuthorizedDirectorKycVerify: true));
    } catch (e) {
      emit(state.copyWith(isAadharFileUploading: false));
      Logger.error(e.toString());
    }
  }

  void _onKartaAadharFileUploadSubmitted(
    KartaAadharFileUploadSubmitted event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    emit(state.copyWith(isKartaAadharFileUploading: true));

    final String? userId = await Prefobj.preferences.get(Prefkeys.userId);
    try {
      final response = await _businessUserKycRepository.uploadbusinessKyc(
        userID: userId ?? '',
        documentType: 'Aadhaar',
        documentNumber: state.kartaAadharNumber?.replaceAll("-", "") ?? '',
        documentFrontImage: event.frontAadharFileData!,
        documentBackImage: event.backAadharFileData,
        isAddharCard: true,
        nameOnPan: '',
        userType: 'business',
        kycRole: "KARTA",
      );
      if (response.success == true) {
        final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
        if (nextStep != null) {
          add(KycStepChanged(nextStep));
        }
        emit(state.copyWith(isKartaAadharFileUploading: false));
      } else {
        emit(state.copyWith(isKartaAadharFileUploading: false));
      }
    } catch (e) {
      emit(state.copyWith(isKartaAadharFileUploading: false));
    }
  }

  void _onChangeSelectedPanUploadOption(ChangeSelectedPanUploadOption event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(selectedUploadPanOption: event.panUploadOption));
  }

  void _onBusinessUploadPanCard(BusinessUploadPanCard event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(isBusinessPanCardFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(businessPanCardFile: null, isBusinessPanCardFileDeleted: true));
    } else {
      emit(state.copyWith(businessPanCardFile: event.fileData, isBusinessPanCardFileDeleted: false));
    }
  }

  void _onSaveBusinessPanDetails(SaveBusinessPanDetails event, Emitter<BusinessAccountSetupState> emit) async {
    emit(state.copyWith(isBusinessPanCardSaveLoading: true, isBusinessPanCardSave: false));
    try {
      await Future.delayed(Duration(seconds: 2));
      emit(state.copyWith(isBusinessPanCardSaveLoading: false, isBusinessPanCardSave: true));
    } catch (e) {
      Logger.error('Error saving business PAN details: $e');
      emit(state.copyWith(isBusinessPanCardSaveLoading: false));
    }
  }

  void _onDirector1UploadPanCard(Director1UploadPanCard event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(isDirector1PanCardFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(director1PanCardFile: null, isDirector1PanCardFileDeleted: true));
    } else {
      emit(state.copyWith(director1PanCardFile: event.fileData, isDirector1PanCardFileDeleted: false));
    }
  }

  void _onDirector2UploadPanCard(Director2UploadPanCard event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(isDirector2PanCardFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(director2PanCardFile: null, isDirector2PanCardFileDeleted: true));
    } else {
      emit(state.copyWith(director2PanCardFile: event.fileData, isDirector2PanCardFileDeleted: false));
    }
  }

  void _onSaveDirectorPanDetails(SaveDirectorPanDetails event, Emitter<BusinessAccountSetupState> emit) async {
    emit(state.copyWith(isDirectorPanCardSaveLoading: true, isDirectorPanCardSave: false));
    try {
      emit(state.copyWith(isDirectorPanCardSaveLoading: false, isDirectorPanCardSave: true));
      add(DirectorKycStepChanged(DirectorKycSteps.aadharDetails));
    } catch (e) {
      Logger.error('Error saving director PAN details: $e');
      emit(state.copyWith(isDirectorPanCardSaveLoading: false));
    }
  }

  void _onChangeDirector1IsBeneficialOwner(
    ChangeDirector1IsBeneficialOwner event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(director1BeneficialOwner: event.isSelected));
  }

  void _onChangeDirector2IsBeneficialOwner(
    ChangeDirector2IsBeneficialOwner event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(director2BeneficialOwner: event.isSelected));
  }

  void _onChangeDirector1IsBusinessRepresentative(
    ChangeDirector1IsBusinessRepresentative event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    // If director 1 is being selected as business representative, unselect director 2
    if (event.isSelected) {
      emit(state.copyWith(ditector1BusinessRepresentative: true, ditector2BusinessRepresentative: false));
    } else {
      emit(state.copyWith(ditector1BusinessRepresentative: false));
    }
  }

  void _onChangeDirector2IsBusinessRepresentative(
    ChangeDirector2IsBusinessRepresentative event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    // If director 2 is being selected as business representative, unselect director 1
    if (event.isSelected) {
      emit(state.copyWith(ditector2BusinessRepresentative: true, ditector1BusinessRepresentative: false));
    } else {
      emit(state.copyWith(ditector2BusinessRepresentative: false));
    }
  }

  void _onBeneficialOwnerUploadPanCard(BeneficialOwnerUploadPanCard event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(isBeneficialOwnerPanCardFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(beneficialOwnerPanCardFile: null, isBeneficialOwnerPanCardFileDeleted: true));
    } else {
      emit(state.copyWith(beneficialOwnerPanCardFile: event.fileData, isBeneficialOwnerPanCardFileDeleted: false));
    }
  }

  void _onChangeBeneficialOwnerIsDirector(
    ChangeBeneficialOwnerIsDirector event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(beneficialOwnerIsDirector: event.isSelected));
  }

  void _onChangeBeneficialOwnerIsBusinessRepresentative(
    ChangeBeneficialOwnerIsBusinessRepresentative event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(benificialOwnerBusinessRepresentative: event.isSelected));
  }

  void _onSaveBeneficialPanDetails(SaveBeneficialOwnerPanDetails event, Emitter<BusinessAccountSetupState> emit) async {
    emit(state.copyWith(isBeneficialOwnerPanCardSaveLoading: true));
    try {
      emit(state.copyWith(isBeneficialOwnerPanCardSaveLoading: false));
      add(BeneficialOwnerKycStepChanged(BeneficialOwnerKycSteps.addressDetails));
    } catch (e) {
      Logger.error('Error saving director PAN details: $e');
      emit(state.copyWith(isBeneficialOwnerPanCardSaveLoading: false));
    }
  }

  void _onBusinessRepresentativeUploadPanCard(
    BusinessRepresentativeUploadPanCard event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(isBusinessRepresentativePanCardFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(businessRepresentativePanCardFile: null, isBusinessRepresentativePanCardFileDeleted: true));
    } else {
      emit(
        state.copyWith(
          businessRepresentativePanCardFile: event.fileData,
          isBusinessRepresentativePanCardFileDeleted: false,
        ),
      );
    }
  }

  void _onChangeBusinessReresentativeIsBeneficialOwner(
    ChangeBusinessReresentativeIsBeneficialOwner event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(businessRepresentativeIsBenificalOwner: event.isSelected));
  }

  void _onChangeBusinessReresentativeOwnerIsDirector(
    ChangeBusinessReresentativeOwnerIsDirector event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(businessRepresentativeIsDirector: event.isSelected));
  }

  void _onSaveBusinessRepresentativePanDetails(
    SaveBusinessRepresentativePanDetails event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    emit(state.copyWith(isbusinessRepresentativePanCardSaveLoading: true, isbusinessRepresentativePanCardSave: false));
    try {
      await Future.delayed(Duration(seconds: 2));
      emit(
        state.copyWith(isbusinessRepresentativePanCardSaveLoading: false, isbusinessRepresentativePanCardSave: true),
      );
    } catch (e) {
      Logger.error('Error saving director PAN details: $e');
      emit(state.copyWith(isbusinessRepresentativePanCardSaveLoading: false));
    }
  }

  void _onVerifyPanSubmitted(VerifyPanSubmitted event, Emitter<BusinessAccountSetupState> emit) async {
    // Check if data has changed
    if (!state.isPanDetailViewDataChanged) {
      // Skip API call and navigate to next step
      final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
      if (nextStep != null) {
        add(KycStepChanged(nextStep));
      }
      return;
    }

    emit(state.copyWith(isPanDetailVerifyLoading: true, isPanDetailVerifySuccess: false));

    try {
      bool isBeneficialOwnerPanUploaded = (state.director1BeneficialOwner || state.director2BeneficialOwner);

      final String? userId = await Prefobj.preferences.get(Prefkeys.userId);
      final userJson = await Prefobj.preferences.get(Prefkeys.userKycDetail);
      final userData = jsonDecode(userJson!);
      final businessDetails = userData['business_details'] ?? {};
      final businessType = businessDetails['business_type'] ?? '';
      // final List multicurrency = userData['multicurrency'] ?? [];
      String otherDirectorKycRole = '';
      if (businessType == 'limited_liability_partnership' || businessType == 'partnership') {
        otherDirectorKycRole = "OTHER_PARTNER";
      } else {
        otherDirectorKycRole = "OTHER_DIRECTOR";
      }

      String authKycRole = '';
      if (businessType == 'limited_liability_partnership' || businessType == 'partnership') {
        authKycRole = "AUTH_PARTNER";
      } else {
        authKycRole = "AUTH_DIRECTOR";
      }

      final authDirectorPanResponse = await _personalUserKycRepository.uploadPanDetails(
        userID: userId ?? '',
        userType: 'business',
        panNumber: state.director1PanNumberController.text.trim(),
        nameOnPan: state.fullDirector1NamePan ?? '',
        panDoc: state.director1PanCardFile!,
        kycRole: authKycRole,
        isBeneficialOwnerisBeneficialOwner: state.director1BeneficialOwner ? 'yes' : 'no',
        isBusinessRepresentative: state.ditector1BusinessRepresentative ? 'yes' : 'no',
      );
      final authDirectorAadharResponse = await _businessUserKycRepository.uploadbusinessKyc(
        userID: userId ?? '',
        documentType: 'Aadhaar',
        documentNumber: state.aadharNumber?.replaceAll("-", "") ?? '',
        documentFrontImage: state.frontSideAdharFile!,
        documentBackImage: state.backSideAdharFile!,
        isAddharCard: true,
        nameOnPan: state.fullDirector1NamePan ?? '',
        userType: 'business',
        kycRole: authKycRole,
      );
      final otherDirectorPanResponse = await _personalUserKycRepository.uploadPanDetails(
        userID: userId ?? '',
        userType: 'business',
        panNumber: state.director2PanNumberController.text.trim(),
        nameOnPan: state.fullDirector2NamePan ?? '',
        panDoc: state.director2PanCardFile!,
        kycRole: otherDirectorKycRole,
        isBeneficialOwnerisBeneficialOwner: state.director2BeneficialOwner ? 'yes' : 'no',
        isBusinessRepresentative: state.ditector2BusinessRepresentative ? 'yes' : 'no',
      );

      // // 4. Other Director Aadhaar (if needed)
      final otherDirectorAadharResponse = await _businessUserKycRepository.uploadbusinessKyc(
        userID: userId ?? '',
        documentType: 'Aadhaar',
        documentNumber: state.otherDirectorAadharNumber?.replaceAll("-", "") ?? '',
        documentFrontImage: state.otherDirectorAadharfrontSideAdharFile!,
        documentBackImage: state.otherDirectorAadharBackSideAdharFile,
        isAddharCard: true,
        nameOnPan: state.fullDirector2NamePan ?? '',
        userType: 'business',
        kycRole: otherDirectorKycRole,
      );

      // // 5. Beneficial Owner PAN (if needed)
      CommonSuccessModel? beneficialOwnerResponse;
      if (!isBeneficialOwnerPanUploaded) {
        try {
          beneficialOwnerResponse = await _personalUserKycRepository.uploadPanDetails(
            userID: userId ?? '',
            userType: 'business',
            panNumber: state.beneficialOwnerPanNumberController.text.trim(),
            nameOnPan: state.fullBeneficialOwnerNamePan ?? '',
            panDoc: state.beneficialOwnerPanCardFile!,
            kycRole: "OWNER",
          );
        } catch (beneficialOwnerError) {
          beneficialOwnerResponse = null;
        }
      }

      // Beneficial Owner Address is only required for multi-currency users AND if director is marked as Beneficial Owner
      bool isUploadAuthAddress = (state.director1BeneficialOwner == true);
      CommonSuccessModel? authBeneficialOwnerAddressResponse;
      if (isUploadAuthAddress) {
        bool isAuthBeneficialOwnerAddressUploaded = (state.isAadharAddressSameAsResidentialAddress == false);
        if (isAuthBeneficialOwnerAddressUploaded) {
          authBeneficialOwnerAddressResponse = await _businessUserKycRepository.uploadBeneficialOwnerAddress(
            userID: userId ?? '',
            useAadhaar: 'false',
            kycRole: authKycRole,
            country: state.authorizedSelectedCountry?.name ?? '',
            state: state.authorizedStateNameController.text.trim(),
            city: state.authorizedCityNameController.text.trim(),
            pincode: state.authorizedPinCodeController.text.trim(),
            addressLine1: state.authorizedAddress1NameController.text.trim(),
            addressLine2: state.authorizedAddress2NameController.text.trim(),
          );
        } else {
          authBeneficialOwnerAddressResponse = await _businessUserKycRepository.uploadBeneficialOwnerAddress(
            userID: userId ?? '',
            useAadhaar: 'true',
            kycRole: authKycRole,
          );
        }
      }

      // Beneficial Owner Address is only required for multi-currency users AND if director is marked as Beneficial Owner
      bool isUploadOtherBeneficialOwnerAddress = (state.director2BeneficialOwner == true);
      CommonSuccessModel? otherBeneficialOwnerAddressResponse;
      if (isUploadOtherBeneficialOwnerAddress) {
        bool isOtherBeneficialOwnerAddressUploaded =
            state.isOtherDirectorAadharAddressSameAsResidentialAddress == false;
        if (isOtherBeneficialOwnerAddressUploaded) {
          otherBeneficialOwnerAddressResponse = await _businessUserKycRepository.uploadBeneficialOwnerAddress(
            userID: userId ?? '',
            useAadhaar: 'false',
            kycRole: otherDirectorKycRole,
            country: state.authorizedSelectedCountry?.name ?? '',
            state: state.authorizedStateNameController.text.trim(),
            city: state.authorizedCityNameController.text.trim(),
            pincode: state.authorizedPinCodeController.text.trim(),
            addressLine1: state.authorizedAddress1NameController.text.trim(),
            addressLine2: state.authorizedAddress2NameController.text.trim(),
          );
        } else {
          otherBeneficialOwnerAddressResponse = await _businessUserKycRepository.uploadBeneficialOwnerAddress(
            userID: userId ?? '',
            useAadhaar: 'true',
            kycRole: otherDirectorKycRole,
          );
        }
      }

      // Check if at least one director is selected as Business Representative
      bool isBusinessRepresentativeSelected =
          state.ditector1BusinessRepresentative || state.ditector2BusinessRepresentative;

      // Validate required responses based on story requirements
      bool isPanDetailsValid = authDirectorPanResponse.success == true && otherDirectorPanResponse.success == true;
      bool isAadharDetailsValid =
          authDirectorAadharResponse.success == true && otherDirectorAadharResponse.success == true;
      bool isBeneficialOwnerValid = isBeneficialOwnerPanUploaded || beneficialOwnerResponse?.success == true;
      bool isBusinessRepresentativeValid = isBusinessRepresentativeSelected;

      // // Beneficial Owner Address validation - only required for multi-currency users
      bool isAuthAddressValid = !isUploadAuthAddress || authBeneficialOwnerAddressResponse?.success == true;
      bool isOtherAddressValid =
          !isUploadOtherBeneficialOwnerAddress || otherBeneficialOwnerAddressResponse?.success == true;

      if (isPanDetailsValid &&
          isAadharDetailsValid &&
          isBeneficialOwnerValid &&
          isBusinessRepresentativeValid &&
          isAuthAddressValid &&
          isOtherAddressValid) {
        // Reset data change flag after successful API call
        add(ResetDataChangeFlags());
        final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
        if (nextStep != null) {
          add(KycStepChanged(nextStep));
        }
        emit(state.copyWith(isPanDetailVerifyLoading: false, isPanDetailVerifySuccess: true));
      } else {
        emit(state.copyWith(isPanDetailVerifyLoading: false, isPanDetailVerifySuccess: false));
      }
    } catch (e) {
      emit(state.copyWith(isPanDetailVerifyLoading: false, isPanDetailVerifySuccess: false));
    }
  }

  void _onUpdateSelectedCountry(UpdateSelectedCountry event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(selectedCountry: event.country));
  }

  void _onUploadAddressVerificationFile(UploadAddressVerificationFile event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(isAddressVerificationFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(addressVerificationFile: null, isAddressVerificationFileDeleted: true));
    } else {
      emit(state.copyWith(addressVerificationFile: event.fileData, isAddressVerificationFileDeleted: false));
    }
  }

  void _onUploadBankAccountVerificationFile(
    UploadBankAccountVerificationFile event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(isBankVerificationFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(bankVerificationFile: null, isBankVerificationFileDeleted: true));
    } else {
      emit(state.copyWith(bankVerificationFile: event.fileData, isBankVerificationFileDeleted: false));
    }
  }

  void _onUploadGstCertificateFile(UploadGstCertificateFile event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(isGstCertificateFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(gstCertificateFile: null, isGstCertificateFileDeleted: true));
    } else {
      emit(state.copyWith(gstCertificateFile: event.fileData, isGstCertificateFileDeleted: false));
    }
  }

  void _onUpdateAddressVerificationDocType(
    UpdateAddressVerificationDocType event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(selectedAddressVerificationDocType: event.docType));
  }

  void _onUpdateBankAccountVerificationDocType(
    UpdateBankAccountVerificationDocType event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(selectedBankAccountVerificationDocType: event.docType));
  }

  void _onRegisterAddressSubmitted(RegisterAddressSubmitted event, Emitter<BusinessAccountSetupState> emit) async {
    // Check if data has changed and files are already uploaded
    if (!state.isResidentialAddressDataChanged && event.addressValidateFileData != null) {
      // Skip API call and navigate to next step
      final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
      if (nextStep != null) {
        add(KycStepChanged(nextStep));
      }
      return;
    }

    emit(state.copyWith(isAddressVerificationLoading: true));
    await Future.delayed(Duration.zero);

    final String? userId = await Prefobj.preferences.get(Prefkeys.userId);

    final user = await Prefobj.preferences.get(Prefkeys.userKycDetail);
    final userDetail = jsonDecode(user!);

    try {
      final response = await _personalUserKycRepository.uploadResidentialAddressDetails(
        userID: userId ?? '',
        userType: userDetail['user_type'],
        documentType: event.docType ?? '',
        addressLine1: state.address1NameController.text.trim(),
        addressLine2: state.address2NameController.text.trim(),
        city: state.cityNameController.text.trim(),
        isAddharCard: false,
        country: state.selectedCountry?.name ?? '',
        pinCode: state.pinCodeController.text.trim(),
        state: state.stateNameController.text.trim(),
        documentFrontImage: event.addressValidateFileData,
        documentBackImage: null,
        aadhaarUsedAsIdentity: 'no',
      );
      if (response.success == true) {
        // Reset data change flag after successful API call
        add(ResetDataChangeFlags());
        final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
        if (nextStep != null) {
          add(KycStepChanged(nextStep));
        }
        emit(state.copyWith(isAddressVerificationLoading: false));
      } else {
        AppToast.show(message: response.message ?? '', type: ToastificationType.error);
        emit(state.copyWith(isAddressVerificationLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isAddressVerificationLoading: false));
    }
  }

  void _onAnnualTurnOverVerificationSubmitted(
    AnnualTurnOverVerificationSubmitted event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    if (!state.isAnnualTurnoverDataChanged) {
      final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
      if (nextStep != null) {
        add(KycStepChanged(nextStep));
      }
      return;
    }
    emit(state.copyWith(isGstVerificationLoading: true));

    final String? userId = await Prefobj.preferences.get(Prefkeys.userId);

    try {
      final response = await _personalUserKycRepository.uploadGSTDocument(
        userID: userId ?? '',
        gstNumber: event.gstNumber ?? '',
        userType: 'business',
        gstCertificate: event.gstCertificate,
      );
      if (response.success == true) {
        final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
        if (nextStep != null) {
          add(KycStepChanged(nextStep));
        }
        emit(state.copyWith(isGstVerificationLoading: false));
      } else {
        emit(state.copyWith(isGstVerificationLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isGstVerificationLoading: false));
    }
  }

  void _onUploadCOICertificate(UploadCOICertificate event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(isCoiCertificateFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(coiCertificateFile: null, isCoiCertificateFileDeleted: true));
    } else {
      emit(state.copyWith(coiCertificateFile: event.fileData, isCoiCertificateFileDeleted: false));
    }
  }

  void _onUploadLLPAgreement(UploadLLPAgreement event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(isUploadLLPAgreementFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(uploadLLPAgreementFile: null, isUploadLLPAgreementFileDeleted: true));
    } else {
      emit(state.copyWith(uploadLLPAgreementFile: event.fileData, isUploadLLPAgreementFileDeleted: false));
    }
  }

  void _onUploadPartnershipDeed(UploadPartnershipDeed event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(isUploadPartnershipDeedDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(uploadPartnershipDeed: null, isUploadPartnershipDeedDeleted: true));
    } else {
      emit(state.copyWith(uploadPartnershipDeed: event.fileData, isUploadPartnershipDeedDeleted: false));
    }
  }

  void _onCINVerificationSubmitted(CINVerificationSubmitted event, Emitter<BusinessAccountSetupState> emit) async {
    // Check if data has changed and files are already uploaded
    if (!state.isCompanyIncorporationDataChanged && event.fileData != null) {
      // Skip API call and navigate to next step
      final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
      if (nextStep != null) {
        add(KycStepChanged(nextStep));
      }
      return;
    }

    emit(state.copyWith(isCINVerifyingLoading: true));
    final String? userId = await Prefobj.preferences.get(Prefkeys.userId);
    try {
      final response = await _personalUserKycRepository.uploadBusinessLegalDocuments(
        userID: userId ?? '',
        userType: 'business',
        documentType: 'CIN',
        documentNumber: event.cinNumber ?? '',
        documentFrontImage: event.fileData,
      );
      if (response.success == true) {
        // Reset data change flag after successful API call
        add(ResetDataChangeFlags());
        final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
        if (nextStep != null) {
          add(KycStepChanged(nextStep));
        }
        emit(state.copyWith(isCINVerifyingLoading: false));
      } else {
        emit(state.copyWith(isCINVerifyingLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isCINVerifyingLoading: false));
    }
  }

  void _onBankAccountNumberVerify(BankAccountNumberVerify event, Emitter<BusinessAccountSetupState> emit) async {
    emit(state.copyWith(isBankAccountNumberVerifiedLoading: true));
    try {
      final String? userId = await Prefobj.preferences.get(Prefkeys.userId);

      final user = await Prefobj.preferences.get(Prefkeys.userKycDetail);
      final userDetail = jsonDecode(user!);

      final response = await _personalUserKycRepository.verifyBankAccount(
        userID: userId ?? '',
        userType: userDetail['user_type'],
        accountNumber: event.accountNumber,
        ifscCode: event.ifscCode,
      );
      if (response.success == true) {
        emit(
          state.copyWith(
            isBankAccountNumberVerifiedLoading: false,
            isBankAccountVerify: true,
            bankAccountNumber: event.accountNumber,
            ifscCode: event.ifscCode,
            accountHolderName: response.data?.accountHolderName ?? '', // from API ideally
          ),
        );
      } else {
        emit(state.copyWith(isBankAccountNumberVerifiedLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isBankAccountNumberVerifiedLoading: false));
      Logger.error(e.toString());
    }
  }

  void _onBankAccountDetailSubmitted(BankAccountDetailSubmitted event, Emitter<BusinessAccountSetupState> emit) async {
    // Check if data has changed and files are already uploaded
    if (!state.isBankAccountDataChanged) {
      // Skip API call and navigate to next step
      final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
      if (nextStep != null) {
        add(KycStepChanged(nextStep));
      }
      if (kIsWeb) {
        GoRouter.of(event.context).go(RouteUri.ekycconfirmationroute);
      } else {
        GoRouter.of(event.context).push(RouteUri.ekycconfirmationroute);
      }
      return;
    }

    emit(state.copyWith(isBankAccountNumberVerifiedLoading: true));

    final String? userId = await Prefobj.preferences.get(Prefkeys.userId);

    final user = await Prefobj.preferences.get(Prefkeys.userKycDetail);
    final userDetail = jsonDecode(user!);

    try {
      final response = await _personalUserKycRepository.uploadBankDocuments(
        userID: userId ?? '',
        userType: userDetail['user_type'] ?? '',
        accountNumber: state.bankAccountNumber ?? '',
        documentType: event.docType ?? '',
        ifscCode: state.ifscCode ?? '',
        proofDocumentImage: event.bankAccountVerifyFile,
      );
      if (response.success == true) {
        // Reset data change flag after successful API call
        add(ResetDataChangeFlags());
        final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
        if (nextStep != null) {
          add(KycStepChanged(nextStep));
        }
        if (kIsWeb) {
          GoRouter.of(event.context).go(RouteUri.ekycconfirmationroute);
        } else {
          GoRouter.of(event.context).push(RouteUri.ekycconfirmationroute);
        }
        emit(state.copyWith(isBankAccountNumberVerifiedLoading: false));
      } else {
        emit(state.copyWith(isBankAccountNumberVerifiedLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isBankAccountNumberVerifiedLoading: false));
    }
  }

  void _onToggleCurrencySelection(ToggleCurrencySelection event, Emitter<BusinessAccountSetupState> emit) async {
    final currentList = List<CurrencyModel>.from(state.selectedCurrencies ?? []);
    final exists = currentList.any((c) => c.currencySymbol == event.currency.currencySymbol);

    if (exists) {
      currentList.removeWhere((c) => c.currencySymbol == event.currency.currencySymbol);
    } else {
      currentList.add(event.currency);
    }

    emit(state.copyWith(selectedCurrencies: currentList));
  }

  void _onBusinessTranscationDetailSubmitted(
    BusinessTranscationDetailSubmitted event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    emit(state.copyWith(isTranscationDetailLoading: true));
    try {
      emit(state.copyWith(isTranscationDetailLoading: false));
      final index = state.currentStep.index;
      if (index < BusinessAccountSetupSteps.values.length - 1) {
        add(StepChanged(BusinessAccountSetupSteps.values[index + 1]));
      }
    } catch (e) {
      emit(state.copyWith(isTranscationDetailLoading: false));
      Logger.error(e.toString());
    }
  }

  void _onScrollToSection(ScrollToSection event, Emitter<BusinessAccountSetupState> emit) {
    state.scrollDebounceTimer?.cancel();

    final scrollController = event.scrollController ?? state.scrollController;

    final newTimer = Timer(const Duration(milliseconds: 300), () {
      final RenderObject? renderObject = event.key.currentContext?.findRenderObject();
      if (renderObject != null) {
        scrollController.position.ensureVisible(
          renderObject,
          alignment: -0.12,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });

    emit(state.copyWith(scrollDebounceTimer: newTimer));
  }

  void _onCancelScrollDebounce(CancelScrollDebounce event, Emitter<BusinessAccountSetupState> emit) {
    state.scrollDebounceTimer?.cancel();
    emit(state.copyWith(scrollDebounceTimer: null));
  }

  void _onResetData(ResetData event, Emitter<BusinessAccountSetupState> emit) {
    // Cancel all timers
    _timer?.cancel();
    _aadhartimer?.cancel();
    _kartaAadhartimer?.cancel();

    // Clear all text controllers
    state.goodsAndServiceExportDescriptionController.clear();
    state.goodsExportOtherController.clear();
    state.serviceExportOtherController.clear();
    state.businessActivityOtherController.clear();
    state.businessLegalNameController.clear();
    state.professionalWebsiteUrl.clear();
    state.phoneController.clear();
    state.otpController.clear();
    state.createPasswordController.clear();
    state.confirmPasswordController.clear();
    state.aadharNumberController.clear();
    state.aadharOtpController.clear();
    state.kartaAadharNumberController.clear();
    state.kartaAadharOtpController.clear();
    state.hufPanNumberController.clear();
    state.businessPanNumberController.clear();
    state.businessPanNameController.clear();
    state.director1PanNumberController.clear();
    state.director1PanNameController.clear();
    state.director2PanNumberController.clear();
    state.director2PanNameController.clear();
    state.beneficialOwnerPanNumberController.clear();
    state.beneficialOwnerPanNameController.clear();
    state.businessRepresentativePanNumberController.clear();
    state.businessRepresentativePanNameController.clear();
    state.pinCodeController.clear();
    state.stateNameController.clear();
    state.cityNameController.clear();
    state.address1NameController.clear();
    state.address2NameController.clear();
    state.turnOverController.clear();
    state.gstNumberController.clear();
    state.iceNumberController.clear();
    state.cinNumberController.clear();
    state.llpinNumberController.clear();
    state.bankAccountNumberController.clear();
    state.reEnterbankAccountNumberController.clear();
    state.ifscCodeController.clear();
    state.partnerAadharNumberController.clear();
    state.partnerAadharOtpController.clear();
    state.proprietorAadharNumberController.clear();
    state.proprietorAadharOtpController.clear();
    state.proprietorCaptchaInputController.clear();
    state.directorCaptchaInputController.clear();
    state.proprietorCaptchaInputController.clear();
    state.directorMobileNumberController.clear();
    state.directorEmailIdNumberController.clear();

    emit(
      BusinessAccountSetupState(
        currentStep: BusinessAccountSetupSteps.businessEntity,
        goodsAndServiceExportDescriptionController: state.goodsAndServiceExportDescriptionController,
        goodsExportOtherController: state.goodsExportOtherController,
        serviceExportOtherController: state.serviceExportOtherController,
        businessActivityOtherController: state.businessActivityOtherController,
        scrollController: state.scrollController,
        formKey: _formKey,
        businessLegalNameController: state.businessLegalNameController,
        professionalWebsiteUrl: state.professionalWebsiteUrl,
        phoneController: state.phoneController,
        otpController: state.otpController,
        sePasswordFormKey: _sePasswordFormKey,
        createPasswordController: state.createPasswordController,
        confirmPasswordController: state.confirmPasswordController,
        currentKycVerificationStep: KycVerificationSteps.panVerification,
        aadharNumberController: state.aadharNumberController,
        directorAadharNumberFocusNode: state.directorAadharNumberFocusNode,
        aadharOtpController: state.aadharOtpController,
        aadharVerificationFormKey: _aadharVerificationFormKey,
        kartaAadharVerificationFormKey: _kartaAadharVerificationFormKey,
        kartaAadharNumberController: state.kartaAadharNumberController,
        kartaAadharOtpController: state.kartaAadharOtpController,
        hufPanVerificationKey: _hufPanVerificationKey,
        hufPanNumberController: state.hufPanNumberController,
        hufPanNumberFocusNode: state.hufPanNumberFocusNode,
        isHUFPanVerifyingLoading: false,
        businessPanNumberController: state.businessPanNumberController,
        businessPanNumberFocusNode: state.businessPanNumberFocusNode,
        businessPanNameController: state.businessPanNameController,
        businessPanVerificationKey: _businessPanVerificationKey,
        directorsPanVerificationKey: _directorsPanVerificationKey,
        director1PanNumberController: state.director1PanNumberController,
        director1PanNumberFocusNode: state.director1PanNumberFocusNode,
        director1PanNameController: state.director1PanNameController,
        director2PanNumberController: state.director2PanNumberController,
        director2PanNumberFocusNode: state.director2PanNumberFocusNode,
        director2PanNameController: state.director2PanNameController,
        beneficialOwnerPanVerificationKey: _beneficialOwnerPanVerificationKey,
        beneficialOwnerPanNumberController: state.beneficialOwnerPanNumberController,
        beneficialOwnerPanNumberFocusNode: state.beneficialOwnerPanNumberFocusNode,
        beneficialOwnerPanNameController: state.beneficialOwnerPanNameController,
        businessRepresentativeFormKey: _businessRepresentativeFormKey,
        businessRepresentativePanNumberController: state.businessRepresentativePanNumberController,
        businessRepresentativePanNameController: state.businessRepresentativePanNameController,
        registerAddressFormKey: _registerAddressFormKey,
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
        pinCodeController: state.pinCodeController,
        stateNameController: state.stateNameController,
        cityNameController: state.cityNameController,
        address1NameController: state.address1NameController,
        address2NameController: state.address2NameController,
        turnOverController: state.turnOverController,
        gstNumberController: state.gstNumberController,
        annualTurnoverFormKey: _annualTurnoverFormKey,
        isGstCertificateMandatory: false,
        iceNumberController: state.iceNumberController,
        iceVerificationKey: _iceVerificationKey,
        cinNumberController: state.cinNumberController,
        cinVerificationKey: _cinVerificationKey,
        llpinNumberController: state.llpinNumberController,
        bankAccountVerificationFormKey: _bankAccountVerificationFormKey,
        bankAccountNumberController: state.bankAccountNumberController,
        reEnterbankAccountNumberController: state.reEnterbankAccountNumberController,
        ifscCodeController: state.ifscCodeController,
        curruncyList: [],
        directorCaptchaInputController: state.directorCaptchaInputController,
        kartaCaptchaInputController: state.kartaCaptchaInputController,
        partnerAadharNumberController: state.partnerAadharNumberController,
        partnerAadharOtpController: state.partnerAadharOtpController,
        partnerAadharVerificationFormKey: state.partnerAadharVerificationFormKey,
        proprietorAadharNumberController: state.proprietorAadharNumberController,
        proprietorAadharOtpController: state.proprietorAadharOtpController,
        proprietorAadharVerificationFormKey: state.proprietorAadharVerificationFormKey,
        partnerCaptchaInputController: state.directorCaptchaInputController,
        proprietorCaptchaInputController: state.proprietorCaptchaInputController,
        directorEmailIdNumberController: state.directorEmailIdNumberController,
        directorMobileNumberController: state.directorMobileNumberController,
        directorContactInformationKey: state.partnerAadharVerificationFormKey,
        otherDirectorsPanVerificationKey: state.otherDirectorsPanVerificationKey,

        // Other Director Aadhar related properties
        otherDirectorVerificationFormKey: state.otherDirectorVerificationFormKey,
        otherDirectorAadharNumberController: state.otherDirectorAadharNumberController,
        otherDirectorAadharNumberFocusNode: state.otherDirectorAadharNumberFocusNode,
        otherDirectoraadharOtpController: state.otherDirectoraadharOtpController,
        otherDirectorCaptchaInputController: state.otherDirectorCaptchaInputController,
        directorKycStep: DirectorKycSteps.panDetails,
        companyPanNumberController: state.companyPanNumberController,
        companyPanNumberFocusNode: state.companyPanNumberFocusNode,
        companyPanVerificationKey: state.companyPanVerificationKey,
        companyPanCardFile: state.companyPanCardFile,
        isCompanyPanDetailsLoading: state.isCompanyPanDetailsLoading,
        isCompanyPanDetailsVerified: state.isCompanyPanDetailsVerified,
        fullCompanyNamePan: state.fullCompanyNamePan,
        isCompanyPanVerifyingLoading: state.isCompanyPanVerifyingLoading,
        llpPanVerificationKey: _llpPanVerificationKey,
        llpPanNumberController: state.llpPanNumberController,
        llpPanNumberFocusNode: state.llpPanNumberFocusNode,
        isLLPPanVerifyingLoading: false,
        partnershipFirmPanVerificationKey: _partnershipFirmPanVerificationKey,
        partnershipFirmPanNumberController: state.partnershipFirmPanNumberController,
        partnershipFirmPanNumberFocusNode: state.partnershipFirmPanNumberFocusNode,
        isPartnershipFirmPanVerifyingLoading: false,
        soleProprietorShipPanVerificationKey: _soleProprietorShipPanVerificationKey,
        soleProprietorShipPanNumberController: state.soleProprietorShipPanNumberController,
        soleProprietorShipPanNumberFocusNode: state.soleProprietorShipPanNumberFocusNode,
        isSoleProprietorShipPanVerifyingLoading: false,
        kartaPanVerificationKey: _kartaPanVerificationKey,
        kartaPanNumberController: state.kartaPanNumberController,
        kartaPanNumberFocusNode: state.kartaPanNumberFocusNode,
        isKartaPanVerifyingLoading: false,
        authorizedSelectedCountry: state.authorizedSelectedCountry,
        authorizedPinCodeController: state.authorizedPinCodeController,
        authorizedStateNameController: state.authorizedStateNameController,
        authorizedCityNameController: state.authorizedCityNameController,
        authorizedAddress1NameController: state.authorizedAddress1NameController,
        authorizedAddress2NameController: state.authorizedAddress2NameController,
        isAuthorizedCityAndStateLoading: state.isAuthorizedCityAndStateLoading,
        otherDirectorPinCodeController: state.otherDirectorPinCodeController,
        otherDirectorStateNameController: state.otherDirectorStateNameController,
        otherDirectorCityNameController: state.otherDirectorCityNameController,
        otherDirectorAddress1NameController: state.otherDirectorAddress1NameController,
        otherDirectorAddress2NameController: state.otherDirectorAddress2NameController,
        isOtherDirectorCityAndStateLoading: state.isOtherDirectorCityAndStateLoading,
        otherDirectorSelectedCountry: state.otherDirectorSelectedCountry,
        beneficialOwnerPinCodeController: state.beneficialOwnerPinCodeController,
        beneficialOwnerStateNameController: state.beneficialOwnerStateNameController,
        beneficialOwnerCityNameController: state.beneficialOwnerCityNameController,
        beneficialOwnerAddress1NameController: state.beneficialOwnerAddress1NameController,
        beneficialOwnerAddress2NameController: state.beneficialOwnerAddress2NameController,
        isBeneficialOwnerCityAndStateLoading: state.isBeneficialOwnerCityAndStateLoading,
        beneficialOwnerSelectedCountry: state.beneficialOwnerSelectedCountry,
        dbaController: state.dbaController,
      ),
    );
  }

  void _onValidateBusinessOtp(ValidateBusinessOtp event, Emitter<BusinessAccountSetupState> emit) async {
    emit(state.copyWith(isBusinessOtpValidating: true));
    try {
      final response = await _authRepository.validateregistrationOtp(mobile: event.phoneNumber, otp: event.otp);
      if (response.success == true) {
        _timer?.cancel();
        emit(state.copyWith(isBusinessOtpValidating: false, isVerifyBusinessRegisterdInfo: true));
        final index = state.currentStep.index;
        add(StepChanged(BusinessAccountSetupSteps.values[index + 1]));
        state.otpController.clear();
        add(GetBusinessCurrencyOptions());
      }
    } catch (e) {
      emit(state.copyWith(isBusinessOtpValidating: false));
      Logger.error(e.toString());
    }
  }

  void _onUpdateBusinessNatureString(UpdateBusinessNatureString event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(businessNatureString: event.businessNatureString));
  }

  Future<void> _onGetBusinessCurrencyOptions(
    GetBusinessCurrencyOptions event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    emit(state.copyWith(isSignupLoading: true));
    try {
      final GetCurrencyOptionModel response = await _authRepository.getCurrencyOptions();
      if (response.success == true) {
        final List<CurrencyModel> currencyList =
            (response.data?.multicurrency ?? []).map((currency) {
              final parts = currency.split(' ');
              final symbol = parts[0];
              final name = parts.sublist(1).join(' ');

              return CurrencyModel(
                currencyName: name,
                currencySymbol: symbol,
                currencyImagePath:
                    symbol == "TRY" ? "assets/images/svgs/country/TRI.svg" : "assets/images/svgs/country/$symbol.svg",
              );
            }).toList();
        emit(
          state.copyWith(
            curruncyList: currencyList,
            estimatedMonthlyVolumeList: response.data?.estimatedMonthlyVolume ?? [],
            isSignupLoading: false,
          ),
        );
      } else {
        emit(state.copyWith(isSignupLoading: false));
      }
    } catch (e) {
      Logger.error(e.toString());
      emit(state.copyWith(isSignupLoading: false));
    }
  }

  void _onBusinessAppBarCollapseChanged(BusinessAppBarCollapseChanged event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(isCollapsed: event.isCollapsed));
  }

  void _onBusinessEkycAppBarCollapseChanged(
    BusinessEkycAppBarCollapseChanged event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(isekycCollapsed: event.isCollapsed));
  }

  Future<void> _onDirectorCaptchaSend(DirectorCaptchaSend event, Emitter<BusinessAccountSetupState> emit) async {
    try {
      emit(state.copyWith(isDirectorCaptchaLoading: true, isDirectorCaptchaSend: false));

      final userId = await Prefobj.preferences.get(Prefkeys.userId) ?? '';

      final userJson = await Prefobj.preferences.get(Prefkeys.userKycDetail);
      final userData = jsonDecode(userJson!);
      final businessDetails = userData['business_details'] ?? {};
      final businessType = businessDetails['business_type'] ?? '';
      String authKycRole = '';
      if (businessType == 'limited_liability_partnership' || businessType == 'partnership') {
        authKycRole = "AUTH_PARTNER";
      } else {
        authKycRole = "AUTH_DIRECTOR";
      }

      final CaptchaModel response = await _businessUserKycRepository.generateCaptcha(
        userID: userId,
        aadhaarNumber: state.aadharNumberController.text,
        userType: 'business',
        kycRole: authKycRole,
      );
      if (response.code == 200) {
        emit(
          state.copyWith(
            isDirectorCaptchaSend: true,
            isDirectorCaptchaLoading: false,
            directorCaptchaImage: response.data?.captcha ?? '',
          ),
        );
        await Prefobj.preferences.put(Prefkeys.sessionId, response.data?.sessionId ?? '');
      } else {
        emit(state.copyWith(isDirectorCaptchaLoading: false, isDirectorCaptchaSend: false));
      }
    } catch (e) {
      emit(state.copyWith(isDirectorCaptchaLoading: false, isDirectorCaptchaSend: false));
      Logger.error('Error :: $e');
    }
  }

  void _onDirectorReCaptchaSend(DirectorReCaptchaSend event, Emitter<BusinessAccountSetupState> emit) async {
    try {
      emit(state.copyWith(isDirectorCaptchaLoading: true, isDirectorCaptchaSend: false));
      final sessionId = await Prefobj.preferences.get(Prefkeys.sessionId) ?? '';

      final RecaptchaModel response = await _businessUserKycRepository.reGenerateCaptcha(sessionId: sessionId);
      if (response.code == 200) {
        emit(
          state.copyWith(
            isDirectorCaptchaSend: true,
            isDirectorCaptchaLoading: false,
            directorCaptchaImage: response.data?.captcha ?? '',
          ),
        );
        state.directorCaptchaInputController.clear();
      } else {
        emit(state.copyWith(isDirectorCaptchaLoading: false, isDirectorCaptchaSend: false));
      }
    } catch (e) {
      emit(state.copyWith(isDirectorCaptchaLoading: false, isDirectorCaptchaSend: false));
      Logger.error(e.toString());
    }
  }

  void _onKartaCaptchaSend(KartaCaptchaSend event, Emitter<BusinessAccountSetupState> emit) async {
    try {
      emit(state.copyWith(isKartaCaptchaLoading: true, isKartaCaptchaSend: false));
      final userId = await Prefobj.preferences.get(Prefkeys.userId) ?? '';
      final CaptchaModel response = await _businessUserKycRepository.generateCaptcha(
        userID: userId,
        aadhaarNumber: state.kartaAadharNumberController.text,
        userType: 'business',
        kycRole: '',
      );
      if (response.code == 200) {
        emit(
          state.copyWith(
            isKartaCaptchaSend: true,
            isKartaCaptchaLoading: false,
            kartaCaptchaImage: response.data?.captcha ?? '',
          ),
        );
        await Prefobj.preferences.put(Prefkeys.sessionId, response.data?.sessionId ?? '');
      } else {
        emit(state.copyWith(isKartaCaptchaLoading: false, isKartaCaptchaSend: false));
      }
    } catch (e) {
      emit(state.copyWith(isKartaCaptchaLoading: false, isKartaCaptchaSend: false));
      Logger.error('Error :: $e');
    }
  }

  void _onKartaReCaptchaSend(KartaReCaptchaSend event, Emitter<BusinessAccountSetupState> emit) async {
    try {
      emit(state.copyWith(isKartaCaptchaLoading: true, isKartaCaptchaSend: false));
      final sessionId = await Prefobj.preferences.get(Prefkeys.sessionId) ?? '';

      final RecaptchaModel response = await _businessUserKycRepository.reGenerateCaptcha(sessionId: sessionId);
      if (response.code == 200) {
        emit(
          state.copyWith(
            isKartaCaptchaSend: true,
            isKartaCaptchaLoading: false,
            kartaCaptchaImage: response.data?.captcha ?? '',
          ),
        );
        state.kartaCaptchaInputController.clear();
      } else {
        emit(state.copyWith(isKartaCaptchaLoading: false, isKartaCaptchaSend: false));
      }
    } catch (e) {
      emit(state.copyWith(isKartaCaptchaLoading: false, isKartaCaptchaSend: false));
      Logger.error(e.toString());
    }
  }

  // ================= PARTNER AADHAAR HANDLERS =================
  void _onPartnerSendAadharOtp(PartnerSendAadharOtp event, Emitter<BusinessAccountSetupState> emit) async {
    try {
      state.partnerAadharOtpController.clear();
      emit(state.copyWith(isPartnerOtpSent: false, isPartnerOtpLoading: true, partnerIsAadharOTPInvalidate: ''));
      AadharOTPSendModel response = await _businessUserKycRepository.generateAadharOTP(
        aadhaarNumber: event.aadhar.replaceAll("-", ""),
        captcha: event.captcha,
        sessionId: event.sessionId,
      );
      if (response.code == 200) {
        emit(state.copyWith(isPartnerOtpSent: true, isPartnerOtpLoading: false));
        add(PartnerAadharSendOtpPressed());
      } else {
        AppToast.show(message: response.message ?? '', type: ToastificationType.error);
        emit(state.copyWith(isPartnerOtpLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isPartnerOtpSent: false));
    }
  }

  void _onPartnerChangeOtpSentStatus(PartnerChangeOtpSentStatus event, Emitter<BusinessAccountSetupState> emit) async {
    emit(state.copyWith(isPartnerOtpSent: event.isOtpSent));
  }

  void _onPartnerAadharSendOtpPressed(PartnerAadharSendOtpPressed event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(isPartnerAadharOtpTimerRunning: true, partnerAadharOtpRemainingTime: initialTime));
    Timer.periodic(Duration(seconds: 1), (timer) {
      final newTime = state.partnerAadharOtpRemainingTime - 1;
      if (newTime <= 0) {
        timer.cancel();
        add(PartnerAadharOtpTimerTicked(0));
      } else {
        add(PartnerAadharOtpTimerTicked(newTime));
      }
    });
  }

  void _onPartnerAadharOtpTimerTicked(PartnerAadharOtpTimerTicked event, Emitter<BusinessAccountSetupState> emit) {
    emit(
      state.copyWith(
        partnerAadharOtpRemainingTime: event.remainingTime,
        isPartnerAadharOtpTimerRunning: event.remainingTime > 0,
      ),
    );
  }

  void _onPartnerAadharNumbeVerified(PartnerAadharNumbeVerified event, Emitter<BusinessAccountSetupState> emit) async {
    emit(state.copyWith(isPartnerAadharVerifiedLoading: true, partnerIsAadharOTPInvalidate: null));
    try {
      final sessionId = await Prefobj.preferences.get(Prefkeys.sessionId) ?? '';
      final userId = await Prefobj.preferences.get(Prefkeys.userId) ?? '';
      final AadharOTPVerifyModel response = await _businessUserKycRepository.validateAadharOtp(
        faker: false,
        otp: event.otp,
        sessionId: sessionId,
        userId: userId,
        userType: 'business',
        aadhaarNumber: event.aadharNumber,
      );
      if (response.code == 200) {
        emit(
          state.copyWith(
            isPartnerAadharVerifiedLoading: false,
            isPartnerAadharVerified: true,
            partnerAadharNumber: event.aadharNumber,
          ),
        );
      } else {
        emit(
          state.copyWith(
            isPartnerAadharVerifiedLoading: false,
            partnerIsAadharOTPInvalidate: response.message.toString(),
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(isPartnerAadharVerifiedLoading: false));
      Logger.error(e.toString());
    }
  }

  void _onPartnerFrontSlideAadharCardUpload(
    PartnerFrontSlideAadharCardUpload event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(isPartnerFrontSideAdharFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(partnerFrontSideAdharFile: null, isPartnerFrontSideAdharFileDeleted: true));
    } else {
      emit(state.copyWith(partnerFrontSideAdharFile: event.fileData, isPartnerFrontSideAdharFileDeleted: false));
    }
  }

  void _onPartnerBackSlideAadharCardUpload(
    PartnerBackSlideAadharCardUpload event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(isPartnerBackSideAdharFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(partnerBackSideAdharFile: null, isPartnerBackSideAdharFileDeleted: true));
    } else {
      emit(state.copyWith(partnerBackSideAdharFile: event.fileData, isPartnerBackSideAdharFileDeleted: false));
    }
  }

  void _onPartnerAadharFileUploadSubmitted(
    PartnerAadharFileUploadSubmitted event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    // Check if data has changed and files are already uploaded
    if (!state.isIdentityVerificationDataChanged &&
        event.frontAadharFileData != null &&
        event.backAadharFileData != null) {
      // Skip API call and navigate to next step
      final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
      if (nextStep != null) {
        add(KycStepChanged(nextStep));
      }
      return;
    }

    emit(state.copyWith(isPartnerAadharFileUploading: true));
    final String? userId = await Prefobj.preferences.get(Prefkeys.userId);
    try {
      final response = await _businessUserKycRepository.uploadbusinessKyc(
        userID: userId ?? '',
        documentType: 'Aadhaar',
        documentNumber: state.partnerAadharNumberController.text.replaceAll("-", ""),
        documentFrontImage: event.frontAadharFileData!,
        documentBackImage: event.backAadharFileData,
        isAddharCard: true,
        nameOnPan: '',
        userType: 'business',
        kycRole: "PARTNER",
      );
      if (response.success == true) {
        // Reset data change flag after successful API call
        add(ResetDataChangeFlags());
        final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
        if (nextStep != null) {
          add(KycStepChanged(nextStep));
        }
        emit(state.copyWith(isPartnerAadharFileUploading: false));
      } else {
        emit(state.copyWith(isPartnerAadharFileUploading: false));
      }
    } catch (e) {
      emit(state.copyWith(isPartnerAadharFileUploading: false));
      Logger.error(e.toString());
    }
  }

  void _onPartnerCaptchaSend(PartnerCaptchaSend event, Emitter<BusinessAccountSetupState> emit) async {
    try {
      emit(state.copyWith(isPartnerCaptchaLoading: true, isPartnerCaptchaSend: false));
      final userId = await Prefobj.preferences.get(Prefkeys.userId) ?? '';
      final CaptchaModel response = await _businessUserKycRepository.generateCaptcha(
        userID: userId,
        aadhaarNumber: state.partnerAadharNumberController.text,
        userType: 'business',
        kycRole: '',
      );
      if (response.code == 200) {
        emit(
          state.copyWith(
            isPartnerCaptchaSend: true,
            isPartnerCaptchaLoading: false,
            partnerCaptchaImage: response.data?.captcha ?? '',
          ),
        );
        await Prefobj.preferences.put(Prefkeys.sessionId, response.data?.sessionId ?? '');
      } else {
        emit(state.copyWith(isPartnerCaptchaLoading: false, isPartnerCaptchaSend: false));
      }
    } catch (e) {
      emit(state.copyWith(isPartnerCaptchaLoading: false, isPartnerCaptchaSend: false));
      Logger.error('Error :: $e');
    }
  }

  void _onPartnerReCaptchaSend(PartnerReCaptchaSend event, Emitter<BusinessAccountSetupState> emit) async {
    try {
      emit(state.copyWith(isPartnerCaptchaLoading: true, isPartnerCaptchaSend: false));
      final sessionId = await Prefobj.preferences.get(Prefkeys.sessionId) ?? '';
      final RecaptchaModel response = await _businessUserKycRepository.reGenerateCaptcha(sessionId: sessionId);
      if (response.code == 200) {
        emit(
          state.copyWith(
            isPartnerCaptchaSend: true,
            isPartnerCaptchaLoading: false,
            partnerCaptchaImage: response.data?.captcha ?? '',
          ),
        );
        state.partnerCaptchaInputController.clear();
      } else {
        emit(state.copyWith(isPartnerCaptchaLoading: false, isPartnerCaptchaSend: false));
      }
    } catch (e) {
      emit(state.copyWith(isPartnerCaptchaLoading: false, isPartnerCaptchaSend: false));
      Logger.error(e.toString());
    }
  }

  // ================= PROPRIETOR AADHAAR HANDLERS =================
  void _onProprietorSendAadharOtp(ProprietorSendAadharOtp event, Emitter<BusinessAccountSetupState> emit) async {
    try {
      state.proprietorAadharOtpController.clear();
      emit(
        state.copyWith(isProprietorOtpSent: false, isProprietorOtpLoading: true, proprietorIsAadharOTPInvalidate: ''),
      );
      AadharOTPSendModel response = await _businessUserKycRepository.generateAadharOTP(
        aadhaarNumber: event.aadhar.replaceAll("-", ""),
        captcha: event.captcha,
        sessionId: event.sessionId,
      );
      if (response.code == 200) {
        emit(state.copyWith(isProprietorOtpSent: true, isProprietorOtpLoading: false));
        add(ProprietorAadharSendOtpPressed());
      } else {
        AppToast.show(message: response.message ?? '', type: ToastificationType.error);
        emit(state.copyWith(isProprietorOtpLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isProprietorOtpSent: false));
    }
  }

  void _onProprietorChangeOtpSentStatus(
    ProprietorChangeOtpSentStatus event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    emit(state.copyWith(isProprietorOtpSent: event.isOtpSent));
  }

  void _onProprietorAadharSendOtpPressed(
    ProprietorAadharSendOtpPressed event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(isProprietorAadharOtpTimerRunning: true, proprietorAadharOtpRemainingTime: initialTime));
    Timer.periodic(Duration(seconds: 1), (timer) {
      final newTime = state.proprietorAadharOtpRemainingTime - 1;
      if (newTime <= 0) {
        timer.cancel();
        add(ProprietorAadharOtpTimerTicked(0));
      } else {
        add(ProprietorAadharOtpTimerTicked(newTime));
      }
    });
  }

  void _onProprietorAadharOtpTimerTicked(
    ProprietorAadharOtpTimerTicked event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(
      state.copyWith(
        proprietorAadharOtpRemainingTime: event.remainingTime,
        isProprietorAadharOtpTimerRunning: event.remainingTime > 0,
      ),
    );
  }

  void _onProprietorAadharNumbeVerified(
    ProprietorAadharNumbeVerified event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    // Skip API if Aadhaar unchanged from original and no data changed, and already verified
    final bool unchangedFromOriginal =
        state.originalProprietorAadharNumber != null && state.originalProprietorAadharNumber == event.aadharNumber;
    if (unchangedFromOriginal && !state.isProprietorAadharDataChanged && state.isProprietorAadharVerified == true) {
      emit(state.copyWith(isProprietorAadharVerifiedLoading: false, isProprietorAadharVerified: true));
      return;
    }
    emit(state.copyWith(isProprietorAadharVerifiedLoading: true, proprietorIsAadharOTPInvalidate: null));
    try {
      final sessionId = await Prefobj.preferences.get(Prefkeys.sessionId) ?? '';
      final userId = await Prefobj.preferences.get(Prefkeys.userId) ?? '';
      final AadharOTPVerifyModel response = await _businessUserKycRepository.validateAadharOtp(
        faker: false,
        otp: event.otp,
        sessionId: sessionId,
        userId: userId,
        userType: 'business',
        aadhaarNumber: event.aadharNumber,
      );
      if (response.code == 200) {
        emit(
          state.copyWith(
            isProprietorAadharVerifiedLoading: false,
            isProprietorAadharVerified: true,
            proprietorAadharNumber: event.aadharNumber,
          ),
        );
      } else {
        emit(
          state.copyWith(
            isProprietorAadharVerifiedLoading: false,
            proprietorIsAadharOTPInvalidate: response.message.toString(),
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(isProprietorAadharVerifiedLoading: false));
      Logger.error(e.toString());
    }
  }

  void _onProprietorFrontSlideAadharCardUpload(
    ProprietorFrontSlideAadharCardUpload event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(isProprietorFrontSideAdharFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(proprietorFrontSideAdharFile: null, isProprietorFrontSideAdharFileDeleted: true));
    } else {
      emit(state.copyWith(proprietorFrontSideAdharFile: event.fileData, isProprietorFrontSideAdharFileDeleted: false));
    }
  }

  void _onProprietorBackSlideAadharCardUpload(
    ProprietorBackSlideAadharCardUpload event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(isProprietorBackSideAdharFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(proprietorBackSideAdharFile: null, isProprietorBackSideAdharFileDeleted: true));
    } else {
      emit(state.copyWith(proprietorBackSideAdharFile: event.fileData, isProprietorBackSideAdharFileDeleted: false));
    }
  }

  void _onProprietorAadharFileUploadSubmitted(
    ProprietorAadharFileUploadSubmitted event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    // Check if data has changed and files are already uploaded
    if (!state.isProprietorAadharDataChanged &&
        state.proprietorFrontSideAdharFile != null &&
        state.proprietorBackSideAdharFile != null) {
      // Skip API call and navigate to next step
      final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
      if (nextStep != null) {
        add(KycStepChanged(nextStep));
      }
      return;
    }

    emit(state.copyWith(isProprietorAadharFileUploading: true));
    final String? userId = await Prefobj.preferences.get(Prefkeys.userId);
    try {
      final response = await _businessUserKycRepository.uploadbusinessKyc(
        userID: userId ?? '',
        documentType: 'Aadhaar',
        documentNumber: state.proprietorAadharNumberController.text.replaceAll("-", ""),
        documentFrontImage: event.frontAadharFileData!,
        documentBackImage: event.backAadharFileData,
        isAddharCard: true,
        nameOnPan: '',
        userType: 'business',
        kycRole: "PROPRIETOR",
      );
      if (response.success == true) {
        // Reset data change flag after successful API call
        add(ResetDataChangeFlags());
        final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
        if (nextStep != null) {
          add(KycStepChanged(nextStep));
        }
        emit(state.copyWith(isProprietorAadharFileUploading: false));
      } else {
        emit(state.copyWith(isProprietorAadharFileUploading: false));
      }
    } catch (e) {
      emit(state.copyWith(isProprietorAadharFileUploading: false));
      Logger.error(e.toString());
    }
  }

  void _onProprietorCaptchaSend(ProprietorCaptchaSend event, Emitter<BusinessAccountSetupState> emit) async {
    try {
      emit(state.copyWith(isProprietorCaptchaLoading: true, isProprietorCaptchaSend: false));
      final userId = await Prefobj.preferences.get(Prefkeys.userId) ?? '';
      final CaptchaModel response = await _businessUserKycRepository.generateCaptcha(
        userID: userId,
        aadhaarNumber: state.proprietorAadharNumberController.text,
        userType: 'business',
        kycRole: '',
      );
      if (response.code == 200) {
        emit(
          state.copyWith(
            isProprietorCaptchaSend: true,
            isProprietorCaptchaLoading: false,
            proprietorCaptchaImage: response.data?.captcha ?? '',
          ),
        );
        await Prefobj.preferences.put(Prefkeys.sessionId, response.data?.sessionId ?? '');
      } else {
        emit(state.copyWith(isProprietorCaptchaLoading: false, isProprietorCaptchaSend: false));
      }
    } catch (e) {
      emit(state.copyWith(isProprietorCaptchaLoading: false, isProprietorCaptchaSend: false));
      Logger.error('Error :: $e');
    }
  }

  void _onProprietorReCaptchaSend(ProprietorReCaptchaSend event, Emitter<BusinessAccountSetupState> emit) async {
    try {
      emit(state.copyWith(isProprietorCaptchaLoading: true, isProprietorCaptchaSend: false));
      final sessionId = await Prefobj.preferences.get(Prefkeys.sessionId) ?? '';
      final RecaptchaModel response = await _businessUserKycRepository.reGenerateCaptcha(sessionId: sessionId);
      if (response.code == 200) {
        emit(
          state.copyWith(
            isProprietorCaptchaSend: true,
            isProprietorCaptchaLoading: false,
            proprietorCaptchaImage: response.data?.captcha ?? '',
          ),
        );
        state.proprietorCaptchaInputController.clear();
      } else {
        emit(state.copyWith(isProprietorCaptchaLoading: false, isProprietorCaptchaSend: false));
      }
    } catch (e) {
      emit(state.copyWith(isProprietorCaptchaLoading: false, isProprietorCaptchaSend: false));
      Logger.error(e.toString());
    }
  }

  void _onDirectorAadharNumberChanged(
    DirectorAadharNumberChanged event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    emit(
      state.copyWith(
        isDirectorCaptchaSend: false,
        isOtpSent: false,
        directorCaptchaImage: null,
        directorCaptchaInputController: TextEditingController(),
        aadharOtpController: TextEditingController(),
        isAadharVerified: false,
        directorAadhaarValidationErrorMessage: '',
        // Reset any other relevant fields
      ),
    );

    // Validate that Aadhaar numbers are different
    final aadhaarValidationError = ExchekValidations.validateDirectorAadhaarsAreDifferent(
      event.newAadharNumber,
      state.otherDirectorAadharNumberController.text,
    );

    emit(state.copyWith(directorAadhaarValidationErrorMessage: aadhaarValidationError));
  }

  void _onKartaAadharNumberChanged(KartaAadharNumberChanged event, Emitter<BusinessAccountSetupState> emit) async {
    emit(
      state.copyWith(
        isKartaCaptchaSend: false,
        isKartaOtpSent: false,
        kartaCaptchaImage: null,
        kartaCaptchaInputController: TextEditingController(),
        kartaAadharOtpController: TextEditingController(),
        isKartaAadharVerified: false,
        // Reset any other relevant fields
      ),
    );
  }

  void _onPartnerAadharNumberChanged(PartnerAadharNumberChanged event, Emitter<BusinessAccountSetupState> emit) async {
    emit(
      state.copyWith(
        isPartnerCaptchaSend: false,
        isPartnerOtpSent: false,
        partnerCaptchaImage: null,
        partnerCaptchaInputController: TextEditingController(),
        partnerAadharOtpController: TextEditingController(),
        isPartnerAadharVerified: false,
        // Reset any other relevant fields
      ),
    );
  }

  void _onProprietorAadharNumberChanged(
    ProprietorAadharNumberChanged event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    emit(
      state.copyWith(
        isProprietorCaptchaSend: false,
        isProprietorOtpSent: false,
        proprietorCaptchaImage: null,
        proprietorCaptchaInputController: TextEditingController(),
        proprietorAadharOtpController: TextEditingController(),
        isProprietorAadharVerified: false,
        // Reset any other relevant fields
      ),
    );
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    _aadhartimer?.cancel();
    _kartaAadhartimer?.cancel();
    _otherDirectorAadhartimer?.cancel();
    return super.close();
  }

  /// Helper method to convert business nature string to enum
  BusinessMainActivity? _getBusinessMainActivity(String? businessNature) {
    switch (businessNature?.toLowerCase()) {
      case 'export of goods':
        return BusinessMainActivity.exportGoods;
      case 'export of services':
        return BusinessMainActivity.exportService;
      // case 'export of goods and services':
      //   return BusinessMainActivity.exportBoth;
      default:
        return BusinessMainActivity.others;
    }
  }

  Future<void> _onLoadBusinessKycFromLocal(
    LoadBusinessKycFromLocal event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    add(ResetData());
    await Future.delayed(Duration.zero);
    emit(state.copyWith(isLocalDataLoading: true));
    final userId = await Prefobj.preferences.get(Prefkeys.userId);
    await _authRepository.getKycDetails(userId: userId ?? '').then((value) async {
      if (value.success == true) {
        await Prefobj.preferences.put(Prefkeys.userKycDetail, jsonEncode(value.data));

        final userJson = await Prefobj.preferences.get(Prefkeys.userKycDetail);
        if (userJson != null) {
          final userData = jsonDecode(userJson);

          // Extract data from new API structure
          final businessDetails = userData['business_details'] ?? {};
          final businessType = businessDetails['business_type'] ?? '';
          final panDetails = userData['pan_details'] ?? {};
          final kartaPanDetails = userData['karta_pan_details'] ?? {};
          final businessIdentity = userData['business_identity'] ?? {};
          final iecDetails = userData['iec_details'] ?? {};
          final address = userData['user_address_documents'] ?? {};
          final gst = userData['user_gst_details'] ?? {};
          final bankDetails = userData['user_bank_details'] ?? {};
          final businessDirectorListRaw = userData['business_director_list'] as List? ?? [];
          final businessDirectorList =
              businessDirectorListRaw.map((director) => BusinessDirectorList.fromJson(director)).toList();
          // final kycStatusDetails = userData['kyc_status_details'] ?? {}; // TODO: Use when needed for additional status tracking
          final multicurrency = userData['multicurrency'] as List? ?? [];
          final estimatedMonthlyVolume = userData['estimated_monthly_volume'] ?? '';

          // Get director information from business_director_list
          // New structure has separate entries for PAN and Aadhaar documents
          BusinessDirectorList? authDirectorPan;
          BusinessDirectorList? authDirectorAadhaar;
          BusinessDirectorList? otherDirectorPan;
          BusinessDirectorList? otherDirectorAadhaar;

          try {
            authDirectorPan = businessDirectorList.firstWhere(
              (director) => director.directorType == 'AUTH_DIRECTOR' && director.documentType == 'Pan',
            );
          } catch (e) {
            authDirectorPan = null;
          }

          try {
            authDirectorAadhaar = businessDirectorList.firstWhere(
              (director) => director.directorType == 'AUTH_DIRECTOR' && director.documentType == 'Aadhaar',
            );
          } catch (e) {
            authDirectorAadhaar = null;
          }

          try {
            otherDirectorPan = businessDirectorList.firstWhere(
              (director) => director.directorType == 'OTHER_DIRECTOR' && director.documentType == 'Pan',
            );
          } catch (e) {
            otherDirectorPan = null;
          }

          try {
            otherDirectorAadhaar = businessDirectorList.firstWhere(
              (director) => director.directorType == 'OTHER_DIRECTOR' && director.documentType == 'Aadhaar',
            );
          } catch (e) {
            otherDirectorAadhaar = null;
          }

          // Set exports type if available
          final exportsType = businessDetails['exports_type'] as List?;

          // Assign controllers/state with new structure
          state.businessLegalNameController.text = businessDetails['business_legal_name'] ?? '';
          state.pinCodeController.text = address['pincode'] ?? '';
          state.stateNameController.text = address['state'] ?? '';
          state.cityNameController.text = address['city'] ?? '';
          state.address1NameController.text = address['address_line1'] ?? '';
          state.address2NameController.text = address['address_line2'] ?? '';
          state.gstNumberController.text = gst['gst_number'] ?? '';
          state.turnOverController.text = gst['estimated_annual_income'] ?? '';
          state.iceNumberController.text = iecDetails['document_number'] ?? '';

          // Set additional data from API response - use emit for final fields
          emit(
            state.copyWith(
              selectedEstimatedMonthlyTransaction: estimatedMonthlyVolume,
              businessNatureString: businessDetails['business_nature'] ?? '',
            ),
          );

          // Set CIN details for Company from business_identity
          if (businessType == 'company' && businessIdentity['document_type'] == 'CIN') {
            state.cinNumberController.text = businessIdentity['document_number'] ?? '';
            emit(state.copyWith(isCINVerifyingLoading: businessIdentity['cin_verify_status'] == 'SUBMITTED'));
          }

          // Set LLPIN details for LLP from business_identity
          if (businessType == 'limited_liability_partnership' && businessIdentity['document_type'] == 'LLPIN') {
            state.llpinNumberController.text = businessIdentity['document_number'] ?? '';
          }

          // PAN details - now from separate pan_details object
          state.businessPanNumberController.text = panDetails['document_number'] ?? '';
          state.businessPanNameController.text = panDetails['name_on_pan'] ?? '';

          // Director PAN - from business_director_list
          if (authDirectorPan != null) {
            state.director1PanNumberController.text = authDirectorPan.documentNumber ?? '';
            final fullDirector1NamePan = authDirectorPan.nameOnPan ?? '';
            final isDirector1PanDetailsVerified = (authDirectorPan.nameOnPan ?? '').isNotEmpty ? true : false;
            final isAuthDirectorBusinessOwner = authDirectorPan.isBusinessOwner ?? false;
            final isAuthDirectorBusinessRepresentative = authDirectorPan.isBusinessRepresentative ?? false;

            // Set director PAN name for Company
            // if (businessType == 'Company') {
            emit(
              state.copyWith(
                fullDirector1NamePan: fullDirector1NamePan,
                director1BeneficialOwner: isAuthDirectorBusinessOwner,
                isDirector1PanDetailsVerified: isDirector1PanDetailsVerified,
                ditector1BusinessRepresentative: isAuthDirectorBusinessRepresentative,
              ),
            );
            // }

            // Download PAN file if available
            if (authDirectorPan.frontDocUrl != null) {
              final fileData = await getFileDataFromPath(authDirectorPan.frontDocUrl!, 'Pan');
              if (fileData != null) {
                emit(state.copyWith(director1PanCardFile: fileData));
              }
            }
          }

          // Other Director PAN - from business_director_list
          if (otherDirectorPan != null) {
            state.director2PanNumberController.text = otherDirectorPan.documentNumber ?? '';
            final fullDirector2NamePan = otherDirectorPan.nameOnPan ?? '';
            final isOtherDirectorBusinessOwner = otherDirectorPan.isBusinessOwner ?? false;
            final isOtherDirectorBusinessRepresentative = otherDirectorPan.isBusinessRepresentative ?? false;
            final isOtherPanDetailsVerified = (otherDirectorPan.nameOnPan ?? '').isNotEmpty ? true : false;

            // Set other director PAN name for Company
            // if (businessType == 'company') {
            emit(
              state.copyWith(
                fullDirector2NamePan: fullDirector2NamePan,
                director2BeneficialOwner: isOtherDirectorBusinessOwner,
                ditector2BusinessRepresentative: isOtherDirectorBusinessRepresentative,
                isDirector2PanDetailsVerified: isOtherPanDetailsVerified,
              ),
            );
            // }

            // Download PAN file if available
            if (otherDirectorPan.frontDocUrl != null) {
              final fileData = await getFileDataFromPath(otherDirectorPan.frontDocUrl!, 'Pan');
              if (fileData != null) {
                emit(state.copyWith(director2PanCardFile: fileData));
              }
            }
          }

          // Director Aadhaar - from business_director_list
          if (authDirectorAadhaar != null) {
            state.aadharNumberController.text = authDirectorAadhaar.documentNumber ?? '';

            // Download Aadhaar files if available
            if (authDirectorAadhaar.frontDocUrl != null) {
              final frontFileData = await getFileDataFromPath(authDirectorAadhaar.frontDocUrl!, 'Aadhaar');
              if (frontFileData != null) {
                emit(state.copyWith(frontSideAdharFile: frontFileData));
              }
            }

            if (authDirectorAadhaar.backDocUrl != null) {
              final backFileData = await getFileDataFromPath(authDirectorAadhaar.backDocUrl!, 'Aadhaar');
              if (backFileData != null) {
                emit(state.copyWith(backSideAdharFile: backFileData));
              }
            }
          }

          // Other Director Aadhaar - from business_director_list
          if (otherDirectorAadhaar != null) {
            state.otherDirectorAadharNumberController.text = otherDirectorAadhaar.documentNumber ?? '';

            // Download Aadhaar files if available
            if (otherDirectorAadhaar.frontDocUrl != null) {
              final frontFileData = await getFileDataFromPath(otherDirectorAadhaar.frontDocUrl!, 'Aadhaar');
              if (frontFileData != null) {
                emit(state.copyWith(otherDirectorAadharfrontSideAdharFile: frontFileData));
              }
            }

            if (otherDirectorAadhaar.backDocUrl != null) {
              final backFileData = await getFileDataFromPath(otherDirectorAadhaar.backDocUrl!, 'Aadhaar');
              if (backFileData != null) {
                emit(state.copyWith(otherDirectorAadharBackSideAdharFile: backFileData));
              }
            }
          }

          String selectedBusinessType() {
            if (state.selectedBusinessEntityType == "company") {
              return "Company";
            } else if (state.selectedBusinessEntityType == 'hindu_undivided_family') {
              return "HUF (Hindu Undivided Family)";
            } else if (state.selectedBusinessEntityType == 'limited_liability_partnership') {
              return "LLP (Limited Liability Partnership)";
            } else if (state.selectedBusinessEntityType == 'partnership') {
              return "Partnership Firm";
            } else if (state.selectedBusinessEntityType == 'sole_proprietor') {
              return "Sole Proprietorship";
            } else {
              return '';
            }
          }

          // Set business type and nature - use emit to update state
          emit(
            state.copyWith(
              selectedBusinessEntityType: selectedBusinessType(),
              selectedBusinessMainActivity: _getBusinessMainActivity(businessDetails['business_nature']),
              selectedbusinessGoodsExportType: exportsType?.cast<String>(),
            ),
          );

          // Bank details - now available in API response
          state.bankAccountNumberController.text = bankDetails['account_number'] ?? '';
          state.ifscCodeController.text = bankDetails['ifsc_code'] ?? '';
          state.reEnterbankAccountNumberController.text = bankDetails['account_number'] ?? '';

          // Aadhaar details - available for HUF in business_identity
          if (businessType == 'hindu_undivided_family' && businessIdentity['document_type'] == 'Aadhaar') {
            state.kartaAadharNumberController.text = businessIdentity['document_number'] ?? '';
            // Set Karta Aadhaar number for verification status
            emit(state.copyWith(kartaAadharNumber: businessIdentity['document_number'] ?? ''));
          } else {
            state.kartaAadharNumberController.text = ''; // TODO: Add when available in API
          }
          state.partnerAadharNumberController.text = ''; // TODO: Add when available in API
          state.proprietorAadharNumberController.text = ''; // TODO: Add when available in API
          state.aadharNumberController.text = ''; // TODO: Add when available in API

          // Set PAN number controllers and names based on business type
          if (businessType == 'hindu_undivided_family') {
            // HUF has both business PAN and Karta PAN
            state.hufPanNumberController.text = panDetails['document_number'] ?? '';
            state.kartaPanNumberController.text = kartaPanDetails['document_number'] ?? '';
            // Set HUF PAN name if available
            if (panDetails['name_on_pan'] != null) {
              emit(state.copyWith(fullHUFNamePan: panDetails['name_on_pan']));
            }
            // Set Karta PAN name if available
            if (kartaPanDetails['name_on_pan'] != null) {
              emit(state.copyWith(fullKartaNamePan: kartaPanDetails['name_on_pan']));
            }
          } else if (businessType == 'limited_liability_partnership') {
            state.llpPanNumberController.text = panDetails['document_number'] ?? '';
            if (panDetails['name_on_pan'] != null) {
              emit(state.copyWith(fullLLPNamePan: panDetails['name_on_pan']));
            }
          } else if (businessType == 'partnership') {
            state.partnershipFirmPanNumberController.text = panDetails['document_number'] ?? '';
            if (panDetails['name_on_pan'] != null) {
              emit(state.copyWith(fullPartnershipFirmNamePan: panDetails['name_on_pan']));
            }
          } else if (businessType == 'sole_proprietor') {
            state.soleProprietorShipPanNumberController.text = panDetails['document_number'] ?? '';
            if (panDetails['name_on_pan'] != null) {
              emit(state.copyWith(fullSoleProprietorShipNamePan: panDetails['name_on_pan']));
            }
          } else if (businessType == 'company') {
            // Company has business PAN
            state.companyPanNumberController.text = panDetails['document_number'] ?? '';
            if (panDetails['name_on_pan'] != null) {
              emit(state.copyWith(fullCompanyNamePan: panDetails['name_on_pan']));
            }
          } else {
            // Default business PAN for other business types
            state.businessPanNumberController.text = panDetails['document_number'] ?? '';
          }

          // Set business legal name in controller
          state.businessLegalNameController.text = businessDetails['business_legal_name'] ?? '';

          // Load all data immediately without waiting for file downloads
          // Files will be downloaded asynchronously in the background
          _loadFilesAsynchronously(userData, businessType, emit);

          // Note: COI, LLP Agreement, Partnership Deed, and Bank details are not in current API response
          // These will need to be handled when those APIs are available

          // Get the first incomplete step from API response data
          final firstIncompleteStep = await KycStepUtils.getFirstIncompleteStep(userData);

          // Set the current step to the first incomplete step, or default to PAN verification
          KycVerificationSteps nextKycStep = firstIncompleteStep ?? KycVerificationSteps.panVerification;

          // // Set PAN verification status based on business type
          // bool isHUFPanDetailsVerified = false;
          // bool isLLPPanDetailsVerified = false;
          // bool isPartnershipFirmPanDetailsVerified = false;
          // bool isSoleProprietorShipPanDetailsVerified = false;

          // if (businessType == 'HUF (Hindu Undivided Family)') {
          //   isHUFPanDetailsVerified = hasKartaPanDoc && hasKartaPanFile;
          // } else if (businessType == 'LLP (Limited Liability Partnership)') {
          //   isLLPPanDetailsVerified = panDetails['document_number'] != null && state.businessPanCardFile != null;
          // } else if (businessType == 'Partnership Firm') {
          //   isPartnershipFirmPanDetailsVerified =
          //       panDetails['document_number'] != null && state.businessPanCardFile != null;
          // } else if (businessType == 'Sole Proprietorship') {
          //   isSoleProprietorShipPanDetailsVerified =
          //       panDetails['document_number'] != null && state.businessPanCardFile != null;
          // }

          emit(
            state.copyWith(
              // Controllers
              businessLegalNameController: state.businessLegalNameController,
              pinCodeController: state.pinCodeController,
              stateNameController: state.stateNameController,
              cityNameController: state.cityNameController,
              address1NameController: state.address1NameController,
              address2NameController: state.address2NameController,
              gstNumberController: state.gstNumberController,
              turnOverController: state.turnOverController,
              iceNumberController: state.iceNumberController,
              cinNumberController: state.cinNumberController,
              llpinNumberController: state.llpinNumberController,
              bankAccountNumberController: state.bankAccountNumberController,
              reEnterbankAccountNumberController: state.reEnterbankAccountNumberController,
              ifscCodeController: state.ifscCodeController,

              // Business details
              businessNatureString: businessDetails['business_nature'] ?? '',
              selectedBusinessEntityType: businessType,
              selectedbusinessGoodsExportType: exportsType?.cast<String>(),

              // Current step
              currentKycVerificationStep: nextKycStep,
              // Aadhaar verification statuses
              isKartaAadharVerified:
                  businessType == 'hindu_undivided_family' &&
                  businessIdentity['document_type'] == 'Aadhaar' &&
                  businessIdentity['document_number'] != null &&
                  state.kartaFrontSideAdharFile != null &&
                  state.kartaBackSideAdharFile != null,
              kartaAadharNumber:
                  businessType == 'hindu_undivided_family' ? businessIdentity['document_number'] ?? '' : '',
              isPartnerAadharVerified: false, // TODO: Update when Aadhaar API is available
              partnerAadharNumber: '', // TODO: Update when Aadhaar API is available
              isProprietorAadharVerified: false, // TODO: Update when Aadhaar API is available
              proprietorAadharNumber: '', // TODO: Update when Aadhaar API is available
              isAadharVerified: authDirectorAadhaar != null && authDirectorAadhaar.verifyStatus == 'SUBMITTED',
              aadharNumber: '', // TODO: Update when Aadhaar API is available
              // PAN verification statuses
              isHUFPanDetailsVerified: (panDetails['name_on_pan'] ?? '').isNotEmpty ? true : false,
              isHUFPanModifiedAfterVerification: (panDetails['name_on_pan'] ?? '').isNotEmpty ? true : false,
              isLLPPanDetailsVerified: (panDetails['name_on_pan'] ?? '').isNotEmpty ? true : false,
              isLLPPanModifiedAfterVerification: (panDetails['name_on_pan'] ?? '').isNotEmpty ? true : false,
              isPartnershipFirmPanDetailsVerified: (panDetails['name_on_pan'] ?? '').isNotEmpty ? true : false,
              isPartnershipFirmPanModifiedAfterVerification:
                  (panDetails['name_on_pan'] ?? '').isNotEmpty ? true : false,
              isSoleProprietorShipPanDetailsVerified: (panDetails['name_on_pan'] ?? '').isNotEmpty ? true : false,
              isSoleProprietorShipPanModifiedAfterVerification:
                  (panDetails['name_on_pan'] ?? '').isNotEmpty ? true : false,

              isBusinessPanCardSave: (panDetails['name_on_pan'] ?? '').isNotEmpty ? true : false,
              isKartaPanDetailsVerified: (panDetails['name_on_pan'] ?? '').isNotEmpty ? true : false,
              isKartaPanModifiedAfterVerification: (panDetails['name_on_pan'] ?? '').isNotEmpty ? true : false,

              // Director PAN verification statuses
              isDirector1PanDetailsVerified: (authDirectorPan?.nameOnPan ?? '').isNotEmpty ? true : false,
              isDirector1PanModifiedAfterVerification: (authDirectorPan?.nameOnPan ?? '').isNotEmpty ? true : false,
              isDirector2PanDetailsVerified: (otherDirectorPan?.nameOnPan ?? '').isNotEmpty ? true : false,
              isDirector2PanModifiedAfterVerification: (otherDirectorPan?.nameOnPan ?? '').isNotEmpty ? true : false,

              // Director Aadhaar verification statuses
              isOtherDirectorAadharVerified:
                  otherDirectorAadhaar != null && otherDirectorAadhaar.verifyStatus == 'SUBMITTED',

              // GST verification statuses
              isGstCertificateMandatory:
                  gst != null && gst['estimated_annual_income'] != null
                      ? (gst['estimated_annual_income'].contains("Less than") ? false : true)
                      : false,
              isGSTNumberVerify: (gst['legal_name'] ?? '').isNotEmpty ? true : false,
              isCompanyPanDetailsVerified: (panDetails['name_on_pan'] ?? '').isNotEmpty ? true : false,
              isCompanyPanModifiedAfterVerification: (panDetails['name_on_pan'] ?? '').isNotEmpty ? true : false,
              selectedAnnualTurnover: gst['estimated_annual_income'] ?? '',
              gstLegalName: gst['legal_name'] ?? '',

              // Address verification statuses
              selectedAddressVerificationDocType:
                  address != null && address['document_type'] != null
                      ? (address['document_type']).replaceAllMapped(
                        RegExp(r'(?<!^)([A-Z])'),
                        (match) => ' ${match.group(1)}',
                      )
                      : '',

              // ICE verification status
              // isIceVerifyingLoading: iecDetails['iec_verify_status'] == 'SUBMITTED',

              // Additional data from API response
              selectedEstimatedMonthlyTransaction: estimatedMonthlyVolume,

              // Currency and transaction data
              selectedCurrencies:
                  multicurrency
                      .map(
                        (currency) => CurrencyModel(
                          currencyName: currency ?? '',
                          currencySymbol: (currency ?? '').split(' ').first, // Extract symbol from "GBP UK Sterling"
                          currencyImagePath: '', // TODO: Add proper image path when available
                        ),
                      )
                      .toList(),

              // Bank account details
              accountHolderName: bankDetails['account_holder_name'],
            ),
          );
          emit(state.copyWith(isLocalDataLoading: false));
          event.completer?.complete();
        }
      }
    });
  }

  Future<FileData?> getFileDataFromPath(String path, String fallbackName) async {
    try {
      // Validate path
      if (path.isEmpty) {
        Logger.error('getFileDataFromPath: Empty path provided');
        return null;
      }

      final response = await _personalUserKycRepository.getPresignedUrl(urlPath: path);
      if (response.url != null && response.url!.isNotEmpty) {
        Logger.success(response.url);
        // Extract the real file name from the URL
        final fileName = _extractFileNameFromUrl(response.url!) ?? fallbackName;
        return await downloadFileDataFromUrl(response.url!, fileName);
      } else {
        Logger.error('getFileDataFromPath: No presigned URL received for path: $path');
      }
    } catch (e) {
      Logger.error('getFileDataFromPath error: $e for path: $path');
    }
    return null;
  }

  Future<FileData?> downloadFileDataFromUrl(String url, String name) async {
    try {
      // Validate URL
      if (url.isEmpty) {
        Logger.error('Download error: Empty URL provided');
        return null;
      }

      final response = await Dio().get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          validateStatus: (status) => status != null && status < 500,
          receiveTimeout: const Duration(seconds: 30),
          // sendTimeout: const Duration(seconds: 30),
        ),
      );

      // Check if response is successful
      if (response.statusCode != 200) {
        Logger.error('Download error: HTTP ${response.statusCode} for URL: $url');
        return null;
      }

      // Validate response data
      if (response.data == null || response.data!.isEmpty) {
        Logger.error('Download error: Empty response data for URL: $url');
        return null;
      }

      // Validate data is actually bytes
      if (response.data is! List<int>) {
        Logger.error('Download error: Invalid response type for URL: $url');
        return null;
      }

      return FileData(
        name: name,
        bytes: Uint8List.fromList(response.data!),
        path: url,
        sizeInMB: response.data!.length / (1024 * 1024),
      );
    } on DioException catch (e) {
      Logger.error('Download error: DioException - ${e.message} for URL: $url');
      return null;
    } catch (e) {
      Logger.error('Download error: Unexpected error - $e for URL: $url');
      return null;
    }
  }

  String? _extractFileNameFromUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;
    return uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;
  }

  Future<void> _refreshKycFileData() async {
    final userJson = await Prefobj.preferences.get(Prefkeys.userKycDetail);
    if (userJson != null) {
      final userData = jsonDecode(userJson);
      // TODO: Update for new API structure - user_identity_documents is now a single object, not a list
      final userIdentityDocs = userData['user_identity_documents'] != null ? [userData['user_identity_documents']] : [];
      // TODO: Update for new API structure - business documents are now separate objects
      final businessLegalDocs =
          userData['user_business_legal_documents'] != null ? [userData['user_business_legal_documents']] : [];
      final address = userData['user_address_documents'] ?? {};
      final gst = userData['user_gst_details'] ?? {};

      final partnershipDeedDoc = businessLegalDocs.firstWhere(
        (doc) => doc['document_type'] == 'PARTNERSHIP_DEED',
        orElse: () => null,
      );
      // Bank
      final bankDoc = userData['user_bank_account_documents'] ?? {};

      // ICE/IEC
      final iceDoc = businessLegalDocs.firstWhere((doc) => doc['document_type'] == 'IEC', orElse: () => null);
      // COI
      final coiDoc = businessLegalDocs.firstWhere((doc) => doc['document_type'] == 'COI', orElse: () => null);
      // LLP Agreement
      final llpDoc = businessLegalDocs.firstWhere((doc) => doc['document_type'] == 'LLP_AGREEMENT', orElse: () => null);
      // Partnership Deed

      final kartaAadhaarDoc = userIdentityDocs.firstWhere(
        (doc) => doc['document_type'] == 'Aadhaar' && doc['kyc_role'] == 'KARTA',
        orElse: () => null,
      );
      final directorAadhaarDoc = userIdentityDocs.firstWhere(
        (doc) => doc['document_type'] == 'Aadhaar' && doc['kyc_role'] == 'DIRECTOR',
        orElse: () => null,
      );
      final partnerAadhaarDoc = userIdentityDocs.firstWhere(
        (doc) => doc['document_type'] == 'Aadhaar' && doc['kyc_role'] == 'PARTNER',
        orElse: () => null,
      );
      final proprietorAadhaarDoc = userIdentityDocs.firstWhere(
        (doc) => doc['document_type'] == 'Aadhaar' && doc['kyc_role'] == 'PROPRIETOR',
        orElse: () => null,
      );
      // PAN for all roles
      final businessPanDoc = userIdentityDocs.firstWhere(
        (doc) => doc['document_type'] == 'Pan' && doc['kyc_role'] == 'BUSINESS',
        orElse: () => null,
      );
      final director1PanDoc = userIdentityDocs.firstWhere(
        (doc) => doc['document_type'] == 'Pan' && doc['kyc_role'] == 'DIRECTOR1',
        orElse: () => null,
      );
      final director2PanDoc = userIdentityDocs.firstWhere(
        (doc) => doc['document_type'] == 'Pan' && doc['kyc_role'] == 'DIRECTOR2',
        orElse: () => null,
      );
      final kartaPanDoc = userIdentityDocs.firstWhere(
        (doc) => doc['document_type'] == 'Pan' && doc['kyc_role'] == 'KARTA',
        orElse: () => null,
      );
      // final partnerPanDoc = userIdentityDocs.firstWhere(
      //   (doc) => doc['document_type'] == 'Pan' && doc['kyc_role'] == 'PARTNER',
      //   orElse: () => null,
      // );
      // final proprietorPanDoc = userIdentityDocs.firstWhere(
      //   (doc) => doc['document_type'] == 'Pan' && doc['kyc_role'] == 'PROPRIETOR',
      //   orElse: () => null,
      // );
      final beneficialOwnerPanDoc = userIdentityDocs.firstWhere(
        (doc) => doc['document_type'] == 'Pan' && doc['kyc_role'] == 'BENEFICIAL_OWNER',
        orElse: () => null,
      );
      final businessRepPanDoc = userIdentityDocs.firstWhere(
        (doc) => doc['document_type'] == 'Pan' && doc['kyc_role'] == 'BUSINESS_REPRESENTATIVE',
        orElse: () => null,
      );
      // final hufPanDoc = userIdentityDocs.firstWhere(
      //   (doc) => doc['document_type'] == 'Pan' && doc['kyc_role'] == 'HUF',
      //   orElse: () => null,
      // );

      if (kartaAadhaarDoc != null && kartaAadhaarDoc['front_doc_url'] != null) {
        final fileData = await getFileDataFromPath(kartaAadhaarDoc['front_doc_url'], 'Aadhaar');
        if (fileData != null) {
          emit(state.copyWith(kartaFrontSideAdharFile: fileData));
        }
      }
      if (kartaAadhaarDoc != null && kartaAadhaarDoc['back_doc_url'] != null) {
        final fileData = await getFileDataFromPath(kartaAadhaarDoc['back_doc_url'], 'Aadhaar');
        if (fileData != null) {
          emit(state.copyWith(kartaBackSideAdharFile: fileData));
        }
      }

      if (directorAadhaarDoc != null && directorAadhaarDoc['front_doc_url'] != null) {
        final fileData = await getFileDataFromPath(directorAadhaarDoc['front_doc_url'], 'Aadhaar');
        if (fileData != null) {
          emit(state.copyWith(frontSideAdharFile: fileData));
        }
      }
      if (directorAadhaarDoc != null && directorAadhaarDoc['back_doc_url'] != null) {
        final fileData = await getFileDataFromPath(directorAadhaarDoc['back_doc_url'], 'Aadhaar');
        if (fileData != null) {
          emit(state.copyWith(backSideAdharFile: fileData));
        }
      }
      if (partnerAadhaarDoc != null && partnerAadhaarDoc['front_doc_url'] != null) {
        final fileData = await getFileDataFromPath(partnerAadhaarDoc['front_doc_url'], 'Aadhaar');
        if (fileData != null) {
          emit(state.copyWith(partnerFrontSideAdharFile: fileData));
        }
      }
      if (partnerAadhaarDoc != null && partnerAadhaarDoc['back_doc_url'] != null) {
        final fileData = await getFileDataFromPath(partnerAadhaarDoc['back_doc_url'], 'Aadhaar');
        if (fileData != null) {
          emit(state.copyWith(partnerBackSideAdharFile: fileData));
        }
      }
      if (proprietorAadhaarDoc != null && proprietorAadhaarDoc['front_doc_url'] != null) {
        final fileData = await getFileDataFromPath(proprietorAadhaarDoc['front_doc_url'], 'Aadhaar');
        if (fileData != null) {
          emit(state.copyWith(proprietorFrontSideAdharFile: fileData));
        }
      }
      if (proprietorAadhaarDoc != null && proprietorAadhaarDoc['back_doc_url'] != null) {
        final fileData = await getFileDataFromPath(proprietorAadhaarDoc['back_doc_url'], 'Aadhaar');
        if (fileData != null) {
          emit(state.copyWith(proprietorBackSideAdharFile: fileData));
        }
      }
      // PAN
      if (businessPanDoc != null && businessPanDoc['front_doc_url'] != null) {
        final fileData = await getFileDataFromPath(businessPanDoc['front_doc_url'], 'Pan');
        if (fileData != null) {
          emit(state.copyWith(businessPanCardFile: fileData));
        }
      }
      if (director1PanDoc != null && director1PanDoc['front_doc_url'] != null) {
        final fileData = await getFileDataFromPath(director1PanDoc['front_doc_url'], 'Pan');
        if (fileData != null) {
          emit(state.copyWith(director1PanCardFile: fileData));
        }
      }
      if (director2PanDoc != null && director2PanDoc['front_doc_url'] != null) {
        final fileData = await getFileDataFromPath(director2PanDoc['front_doc_url'], 'Pan');
        if (fileData != null) {
          emit(state.copyWith(director2PanCardFile: fileData));
        }
      }
      if (kartaPanDoc != null && kartaPanDoc['front_doc_url'] != null) {
        final fileData = await getFileDataFromPath(kartaPanDoc['front_doc_url'], 'Pan');
        if (fileData != null) {
          emit(state.copyWith(hufPanCardFile: fileData));
        }
      }
      // partnerPanCardFile and proprietorPanCardFile do not exist in state, so skip them
      if (beneficialOwnerPanDoc != null && beneficialOwnerPanDoc['front_doc_url'] != null) {
        final fileData = await getFileDataFromPath(beneficialOwnerPanDoc['front_doc_url'], 'Pan');
        if (fileData != null) {
          emit(state.copyWith(beneficialOwnerPanCardFile: fileData));
        }
      }
      if (businessRepPanDoc != null && businessRepPanDoc['front_doc_url'] != null) {
        final fileData = await getFileDataFromPath(businessRepPanDoc['front_doc_url'], 'Pan');
        if (fileData != null) {
          emit(state.copyWith(businessRepresentativePanCardFile: fileData));
        }
      }
      // GST Certificate
      if (gst != null && gst['gst_certificate_url'] != '') {
        final fileData = await getFileDataFromPath(gst['gst_certificate_url'], 'GST');
        if (fileData != null) {
          emit(state.copyWith(gstCertificateFile: fileData));
        }
      }
      // Address
      if (address != null && address['front_doc_url'] != '') {
        final fileData = await getFileDataFromPath(address['front_doc_url'], address['document_type'] ?? 'Address');
        if (fileData != null) {
          emit(state.copyWith(addressVerificationFile: fileData));
        }
      }
      // ICE Certificate
      if (iceDoc != null && iceDoc['doc_url'] != null) {
        final fileData = await getFileDataFromPath(iceDoc['doc_url'], "ICE");
        if (fileData != null) {
          emit(state.copyWith(iceCertificateFile: fileData));
        }
      }
      // COI
      if (coiDoc != null && coiDoc['doc_url'] != null) {
        final fileData = await getFileDataFromPath(coiDoc['doc_url'], "COI");
        if (fileData != null) {
          emit(state.copyWith(coiCertificateFile: fileData));
        }
      }
      // LLP Agreement
      if (llpDoc != null && llpDoc['doc_url'] != null) {
        final fileData = await getFileDataFromPath(llpDoc['doc_url'], "LLP_AGREEMENT");
        if (fileData != null) {
          emit(state.copyWith(uploadLLPAgreementFile: fileData));
        }
      }
      // Partnership Deed
      if (partnershipDeedDoc != null && partnershipDeedDoc['doc_url'] != null) {
        final fileData = await getFileDataFromPath(partnershipDeedDoc['doc_url'], "PARTNERSHIP_DEED");
        if (fileData != null) {
          emit(state.copyWith(uploadPartnershipDeed: fileData));
        }
      }
      // Bank Verification File
      if (bankDoc != null && bankDoc['front_doc_url'] != null) {
        final fileData = await getFileDataFromPath(bankDoc['front_doc_url'], 'Bank');
        if (fileData != null) {
          emit(state.copyWith(bankVerificationFile: fileData));
        }
      }
    }
  }

  Future<void> _onBusinessGetCityAndState(
    BusinessGetCityAndState event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    emit(state.copyWith(isCityAndStateLoading: true, isCityAndStateVerified: false));
    try {
      final GetCityAndStateModel response = await _personalUserKycRepository.getCityAndState(pincode: event.pinCode);
      if (response.success == true) {
        emit(
          state.copyWith(
            isCityAndStateLoading: false,
            cityNameController: TextEditingController(text: response.data?.city ?? ''),
            stateNameController: TextEditingController(text: response.data?.state ?? ''),
            isCityAndStateVerified: true,
          ),
        );
      } else {
        emit(state.copyWith(isCityAndStateLoading: false, isCityAndStateVerified: false));
      }
    } catch (e) {
      Logger.error(e.toString());
      emit(state.copyWith(isCityAndStateLoading: false, isCityAndStateVerified: false));
    }
  }

  void _onLLPINVerificationSubmitted(LLPINVerificationSubmitted event, Emitter<BusinessAccountSetupState> emit) async {
    // Check if data has changed and files are already uploaded
    if (!state.isCompanyIncorporationDataChanged && event.coifile != null && event.llpfile != null) {
      // Skip API call and navigate to next step
      final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
      if (nextStep != null) {
        add(KycStepChanged(nextStep));
      }
      return;
    }

    emit(state.copyWith(isCINVerifyingLoading: true));
    final String? userId = await Prefobj.preferences.get(Prefkeys.userId);
    try {
      final response = await _personalUserKycRepository.uploadBusinessLegalDocuments(
        userID: userId ?? '',
        userType: 'business',
        documentType: 'LLPIN',
        documentNumber: event.llpinNumber ?? '',
        documentFrontImage: event.coifile,
        documentbackImage: event.llpfile,
      );
      if (response.success == true) {
        // Reset data change flag after successful API call
        add(ResetDataChangeFlags());
        final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
        if (nextStep != null) {
          add(KycStepChanged(nextStep));
        }
        emit(state.copyWith(isCINVerifyingLoading: false));
      } else {
        emit(state.copyWith(isCINVerifyingLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isCINVerifyingLoading: false));
    }
  }

  void _onPartnerShipDeedVerificationSubmitted(
    PartnerShipDeedVerificationSubmitted event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    // Check if data has changed and files are already uploaded
    if (!state.isCompanyIncorporationDataChanged && event.partnerShipDeedDoc != null) {
      // Skip API call and navigate to next step
      final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
      if (nextStep != null) {
        add(KycStepChanged(nextStep));
      }
      return;
    }

    emit(state.copyWith(isCINVerifyingLoading: true));
    final String? userId = await Prefobj.preferences.get(Prefkeys.userId);
    try {
      final response = await _personalUserKycRepository.uploadBusinessLegalDocuments(
        userID: userId ?? '',
        userType: 'business',
        documentType: 'PARTNERSHIP_DEED',
        documentFrontImage: event.partnerShipDeedDoc,
      );
      if (response.success == true) {
        // Reset data change flag after successful API call
        add(ResetDataChangeFlags());
        final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
        if (nextStep != null) {
          add(KycStepChanged(nextStep));
        }
        emit(state.copyWith(isCINVerifyingLoading: false));
      } else {
        emit(state.copyWith(isCINVerifyingLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isCINVerifyingLoading: false));
    }
  }

  void _onBusinessGSTVerification(BusinessGSTVerification event, Emitter<BusinessAccountSetupState> emit) async {
    try {
      // Skip when unchanged from original and no other related data changed
      final bool unchangedFromOriginal =
          state.originalBusinessGstNumber != null && state.originalBusinessGstNumber == event.gstNumber;

      if (unchangedFromOriginal) {
        emit(
          state.copyWith(
            isGstNumberVerifyingLoading: false,
            isGSTNumberVerify: true,
            // keep existing gstLegalName
          ),
        );
        return;
      }

      emit(state.copyWith(isGstNumberVerifyingLoading: true));

      final String? userId = await Prefobj.preferences.get(Prefkeys.userId);

      final response = await _personalUserKycRepository.getGSTDetails(
        userID: userId ?? '',
        estimatedAnnualIncome: event.turnover,
        gstNumber: event.gstNumber,
      );
      if (response.success == true) {
        emit(
          state.copyWith(
            isGstNumberVerifyingLoading: false,
            gstLegalName: response.data?.legalName ?? '',
            isGSTNumberVerify: true,
          ),
        );
      } else {
        emit(state.copyWith(isGstNumberVerifyingLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isGstNumberVerifyingLoading: false));
    }
  }

  Future<void> _onGetHUFPanDetails(GetHUFPanDetails event, Emitter<BusinessAccountSetupState> emit) async {
    // Skip API if PAN unchanged from original and no data changed, and we have cached name
    final bool unchangedFromOriginal =
        state.originalBusinessPanNumber != null && state.originalBusinessPanNumber == event.panNumber;
    if (unchangedFromOriginal && !state.isHUFPanDataChanged && (state.fullHUFNamePan ?? '').isNotEmpty) {
      emit(state.copyWith(isHUFPanDetailsLoading: false, isHUFPanDetailsVerified: true));
      return;
    }
    emit(state.copyWith(isHUFPanDetailsLoading: true, isHUFPanDetailsVerified: false, hufPanDetailsErrorMessage: ''));
    try {
      final userId = await Prefobj.preferences.get(Prefkeys.userId) ?? '';
      final GetPanDetailModel response = await _personalUserKycRepository.getPanDetails(
        panNumber: event.panNumber,
        userId: userId,
        kycRole: 'HUF',
      );
      if (response.success == true) {
        final String panName = response.data?.nameInformation?.panNameCleaned ?? '';
        emit(
          state.copyWith(
            isHUFPanDetailsLoading: false,
            fullHUFNamePan: panName,
            isHUFPanDetailsVerified: true,
            isHUFPanModifiedAfterVerification: true,
          ),
        );
        add(HUFPanEditAttempt());
      } else {
        emit(
          state.copyWith(
            isHUFPanDetailsLoading: false,
            isHUFPanDetailsVerified: false,
            hufPanDetailsErrorMessage: response.error ?? '',
            isHUFPanModifiedAfterVerification: false,
            originalBusinessPanNumber: '',
            fullHUFNamePan: '',
          ),
        );
      }
    } catch (e) {
      Logger.error(e.toString());
      emit(state.copyWith(isHUFPanDetailsLoading: false, isHUFPanDetailsVerified: false));
    }
  }

  Future<void> _onHUFPanEditAttempt(HUFPanEditAttempt event, Emitter<BusinessAccountSetupState> emit) async {
    final result = handlePanEditAttempt(
      isLocked: state.isHUFPanEditLocked,
      lockTime: state.hufPanEditLockTime,
      attempts: state.hufPanEditAttempts,
      panType: 'PAN',
    );

    if (result.shouldUnlock) {
      emit(
        state.copyWith(
          isHUFPanEditLocked: false,
          hufPanEditLockTime: null,
          hufPanEditAttempts: 0,
          hufPanEditErrorMessage: '',
        ),
      );
      return;
    }

    if (result.isLocked) {
      emit(
        state.copyWith(
          hufPanEditErrorMessage: result.errorMessage,
          isHUFPanEditLocked: result.isLocked,
          hufPanEditLockTime: result.lockTime,
          hufPanEditAttempts: result.attempts,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        hufPanEditAttempts: result.attempts,
        hufPanEditErrorMessage: result.errorMessage,
        isHUFPanEditLocked: result.isLocked,
        hufPanEditLockTime: result.lockTime,
      ),
    );
  }

  Future<void> _onGetPartnershipFirmPanDetails(
    GetPartnershipFirmPanDetails event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    // Skip API if PAN unchanged from original and no data changed, and we have cached name
    final bool unchangedFromOriginal =
        state.originalBusinessPanNumber != null && state.originalBusinessPanNumber == event.panNumber;
    if (unchangedFromOriginal &&
        !state.isPartnershipFirmPanDataChanged &&
        (state.fullPartnershipFirmNamePan ?? '').isNotEmpty) {
      emit(state.copyWith(isPartnershipFirmPanDetailsLoading: false, isPartnershipFirmPanDetailsVerified: true));
      return;
    }
    emit(
      state.copyWith(
        isPartnershipFirmPanDetailsLoading: true,
        isPartnershipFirmPanDetailsVerified: false,
        partnershipFirmPanDetailsErrorMessage: '',
        isPartnershipFirmPanModifiedAfterVerification: false,
      ),
    );
    try {
      final userId = await Prefobj.preferences.get(Prefkeys.userId) ?? '';
      final GetPanDetailModel response = await _personalUserKycRepository.getPanDetails(
        panNumber: event.panNumber,
        userId: userId,
        kycRole: 'PARTNERSHIP',
      );
      if (response.success == true) {
        final String panName = response.data?.nameInformation?.panNameCleaned ?? '';
        emit(
          state.copyWith(
            isPartnershipFirmPanDetailsLoading: false,
            fullPartnershipFirmNamePan: panName,
            isPartnershipFirmPanDetailsVerified: true,
            isPartnershipFirmPanModifiedAfterVerification: true,
          ),
        );
        add(PartnershipFirmPanEditAttempt());
      } else {
        emit(
          state.copyWith(
            isPartnershipFirmPanDetailsLoading: false,
            isPartnershipFirmPanDetailsVerified: false,
            partnershipFirmPanDetailsErrorMessage: response.error ?? '',
            isPartnershipFirmPanModifiedAfterVerification: false,
            originalBusinessPanNumber: '',
            fullPartnershipFirmNamePan: '',
          ),
        );
      }
    } catch (e) {
      Logger.error(e.toString());
      emit(
        state.copyWith(
          isPartnershipFirmPanDetailsLoading: false,
          isPartnershipFirmPanDetailsVerified: false,
          isPartnershipFirmPanModifiedAfterVerification: false,
        ),
      );
    }
  }

  Future<void> _onPartnershipFirmPanEditAttempt(
    PartnershipFirmPanEditAttempt event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    final result = handlePanEditAttempt(
      isLocked: state.isPartnershipFirmPanEditLocked,
      lockTime: state.partnershipFirmPanEditLockTime,
      attempts: state.partnershipFirmPanEditAttempts,
      panType: 'PAN',
    );

    if (result.shouldUnlock) {
      emit(
        state.copyWith(
          isPartnershipFirmPanEditLocked: false,
          partnershipFirmPanEditLockTime: null,
          partnershipFirmPanEditAttempts: 0,
          partnershipFirmPanEditErrorMessage: '',
        ),
      );
      return;
    }

    if (result.isLocked) {
      emit(
        state.copyWith(
          partnershipFirmPanEditErrorMessage: result.errorMessage,
          isPartnershipFirmPanEditLocked: result.isLocked,
          partnershipFirmPanEditLockTime: result.lockTime,
          partnershipFirmPanEditAttempts: result.attempts,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        partnershipFirmPanEditAttempts: result.attempts,
        partnershipFirmPanEditErrorMessage: result.errorMessage,
        isPartnershipFirmPanEditLocked: result.isLocked,
        partnershipFirmPanEditLockTime: result.lockTime,
      ),
    );
  }

  Future<void> _onGetSoleProprietorShipPanDetails(
    GetSoleProprietorShipPanDetails event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    // Skip API if PAN unchanged from original and no data changed, and we have cached name
    final bool unchangedFromOriginal =
        state.originalBusinessPanNumber != null && state.originalBusinessPanNumber == event.panNumber;
    if (unchangedFromOriginal &&
        !state.isSoleProprietorshipPanDataChanged &&
        (state.fullSoleProprietorShipNamePan ?? '').isNotEmpty) {
      emit(state.copyWith(isSoleProprietorShipPanDetailsLoading: false, isSoleProprietorShipPanDetailsVerified: true));
      return;
    }
    emit(
      state.copyWith(
        isSoleProprietorShipPanDetailsLoading: true,
        isSoleProprietorShipPanDetailsVerified: false,
        soleProprietorShipPanDetailsErrorMessage: '',
        isSoleProprietorShipPanModifiedAfterVerification: false,
      ),
    );
    try {
      final userId = await Prefobj.preferences.get(Prefkeys.userId) ?? '';
      final GetPanDetailModel response = await _personalUserKycRepository.getPanDetails(
        panNumber: event.panNumber,
        userId: userId,
        kycRole: 'PROPRIETOR',
      );
      if (response.success == true) {
        emit(
          state.copyWith(
            isSoleProprietorShipPanDetailsLoading: false,
            isSoleProprietorShipPanDetailsVerified: true,
            isSoleProprietorShipPanModifiedAfterVerification: true,
            fullSoleProprietorShipNamePan: response.data?.nameInformation?.panNameCleaned ?? '',
          ),
        );
        add(SoleProprietorShipPanEditAttempt());
      } else {
        emit(
          state.copyWith(
            isSoleProprietorShipPanDetailsLoading: false,
            isSoleProprietorShipPanDetailsVerified: false,
            soleProprietorShipPanDetailsErrorMessage: response.error ?? '',
            isSoleProprietorShipPanModifiedAfterVerification: false,
            originalBusinessPanNumber: '',
            fullSoleProprietorShipNamePan: '',
          ),
        );
      }
    } catch (e) {
      Logger.error(e.toString());
      emit(
        state.copyWith(
          isSoleProprietorShipPanDetailsLoading: false,
          isSoleProprietorShipPanDetailsVerified: false,
          isSoleProprietorShipPanModifiedAfterVerification: false,
          originalBusinessPanNumber: '',
          fullSoleProprietorShipNamePan: '',
        ),
      );
    }
  }

  Future<void> _onSoleProprietorShipPanEditAttempt(
    SoleProprietorShipPanEditAttempt event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    final result = handlePanEditAttempt(
      isLocked: state.isSoleProprietorShipPanEditLocked,
      lockTime: state.soleProprietorShipPanEditLockTime,
      attempts: state.soleProprietorShipPanEditAttempts,
      panType: 'PAN',
    );

    if (result.shouldUnlock) {
      emit(
        state.copyWith(
          isSoleProprietorShipPanEditLocked: false,
          soleProprietorShipPanEditLockTime: null,
          soleProprietorShipPanEditAttempts: 0,
          soleProprietorShipPanEditErrorMessage: '',
        ),
      );
      return;
    }

    if (result.isLocked) {
      emit(
        state.copyWith(
          soleProprietorShipPanEditErrorMessage: result.errorMessage,
          isSoleProprietorShipPanEditLocked: result.isLocked,
          soleProprietorShipPanEditLockTime: result.lockTime,
          soleProprietorShipPanEditAttempts: result.attempts,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        soleProprietorShipPanEditAttempts: result.attempts,
        soleProprietorShipPanEditErrorMessage: result.errorMessage,
        isSoleProprietorShipPanEditLocked: result.isLocked,
        soleProprietorShipPanEditLockTime: result.lockTime,
      ),
    );
  }

  Future<void> _onCompanyPanEditAttempt(CompanyPanEditAttempt event, Emitter<BusinessAccountSetupState> emit) async {
    final result = handlePanEditAttempt(
      isLocked: state.isCompanyPanEditLocked,
      lockTime: state.companyPanEditLockTime,
      attempts: state.companyPanEditAttempts,
      panType: 'PAN',
    );

    if (result.shouldUnlock) {
      emit(
        state.copyWith(
          isCompanyPanEditLocked: false,
          companyPanEditLockTime: null,
          companyPanEditAttempts: 0,
          companyPanEditErrorMessage: '',
        ),
      );
      return;
    }

    if (result.isLocked) {
      emit(
        state.copyWith(
          companyPanEditErrorMessage: result.errorMessage,
          isCompanyPanEditLocked: result.isLocked,
          companyPanEditLockTime: result.lockTime,
          companyPanEditAttempts: result.attempts,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        companyPanEditAttempts: result.attempts,
        companyPanEditErrorMessage: result.errorMessage,
        isCompanyPanEditLocked: result.isLocked,
        companyPanEditLockTime: result.lockTime,
      ),
    );
  }

  void _onHUFPanNumberChanged(HUFPanNumberChanged event, Emitter<BusinessAccountSetupState> emit) {
    if (state.isHUFPanEditLocked) {
      add(HUFPanEditAttempt());
    } else if (state.isHUFPanModifiedAfterVerification == true) {
      emit(
        state.copyWith(isHUFPanModifiedAfterVerification: false, fullHUFNamePan: '', isHUFPanDetailsVerified: false),
      );
    } else {
      emit(
        state.copyWith(
          isHUFPanDetailsVerified: false,
          hufPanDetailsErrorMessage: '',
          fullHUFNamePan: '',
          isHUFPanModifiedAfterVerification: false,
        ),
      );
    }
  }

  Future<void> _onGetDirector1PanDetails(GetDirector1PanDetails event, Emitter<BusinessAccountSetupState> emit) async {
    // Skip API if PAN unchanged from original and no data changed, and we have cached name
    final bool unchangedFromOriginal =
        state.originalDirector1PanNumber != null && state.originalDirector1PanNumber == event.panNumber;
    if (unchangedFromOriginal && !state.isPanDetailsDataChanged && (state.fullDirector1NamePan ?? '').isNotEmpty) {
      emit(state.copyWith(isDirector1PanDetailsLoading: false, isDirector1PanDetailsVerified: true));
      return;
    }
    emit(
      state.copyWith(
        isDirector1PanDetailsLoading: true,
        isDirector1PanDetailsVerified: false,
        director1PanDetailsErrorMessage: '',
        isDirector1PanModifiedAfterVerification: false,
      ),
    );
    try {
      final userId = await Prefobj.preferences.get(Prefkeys.userId) ?? '';
      final GetPanDetailModel response = await _personalUserKycRepository.getPanDetails(
        panNumber: event.panNumber,
        userId: userId,
        kycRole: 'AUTH_DIRECTOR',
      );
      if (response.success == true) {
        final String panName = response.data?.nameInformation?.panNameCleaned ?? '';
        emit(
          state.copyWith(
            isDirector1PanDetailsLoading: false,
            fullDirector1NamePan: panName,
            isDirector1PanDetailsVerified: true,
            isDirector1PanModifiedAfterVerification: true,
          ),
        );
        add(Director1PanEditAttempt());
      } else {
        emit(
          state.copyWith(
            isDirector1PanDetailsLoading: false,
            isDirector1PanDetailsVerified: false,
            director1PanDetailsErrorMessage: response.error ?? '',
            isDirector1PanModifiedAfterVerification: false,
            originalDirector1PanNumber: '',
            fullDirector1NamePan: '',
          ),
        );
      }
    } catch (e) {
      Logger.error(e.toString());
      emit(
        state.copyWith(
          isDirector1PanDetailsLoading: false,
          isDirector1PanDetailsVerified: false,
          isDirector1PanModifiedAfterVerification: false,
        ),
      );
    }
  }

  void _onDirector1PanNumberChanged(Director1PanNumberChanged event, Emitter<BusinessAccountSetupState> emit) {
    if (state.isDirector1PanEditLocked) {
      add(Director1PanEditAttempt());
    } else if (state.isDirector1PanDetailsVerified == true) {
      emit(
        state.copyWith(
          isDirector1PanModifiedAfterVerification: false,
          fullDirector1NamePan: '',
          isDirector1PanDetailsVerified: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isDirector1PanDetailsVerified: false,
          director1PanDetailsErrorMessage: '',
          fullDirector1NamePan: '',
          isDirector1PanModifiedAfterVerification: false,
          directorPANValidationErrorMessage: '',
        ),
      );
    }

    // Validate that PAN numbers are different
    final panValidationError = ExchekValidations.validateDirectorPANsAreDifferent(
      event.panNumber,
      state.director2PanNumberController.text,
    );

    emit(state.copyWith(directorPANValidationErrorMessage: panValidationError));
  }

  Future<void> _onDirector1PanEditAttempt(
    Director1PanEditAttempt event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    final result = handlePanEditAttempt(
      isLocked: state.isDirector1PanEditLocked,
      lockTime: state.director1PanEditLockTime,
      attempts: state.director1PanEditAttempts,
      panType: 'PAN',
    );

    if (result.shouldUnlock) {
      emit(
        state.copyWith(
          isDirector1PanEditLocked: false,
          director1PanEditLockTime: null,
          director1PanEditAttempts: 0,
          director1PanEditErrorMessage: '',
        ),
      );
      return;
    }

    if (result.isLocked) {
      emit(
        state.copyWith(
          director1PanEditErrorMessage: result.errorMessage,
          isDirector1PanEditLocked: result.isLocked,
          director1PanEditLockTime: result.lockTime,
          director1PanEditAttempts: result.attempts,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        director1PanEditAttempts: result.attempts,
        director1PanEditErrorMessage: result.errorMessage,
        isDirector1PanEditLocked: result.isLocked,
        director1PanEditLockTime: result.lockTime,
      ),
    );
  }

  Future<void> _onGetDirector2PanDetails(GetDirector2PanDetails event, Emitter<BusinessAccountSetupState> emit) async {
    // Skip API if PAN unchanged from original and no data changed, and we have cached name
    final bool unchangedFromOriginal =
        state.originalDirector2PanNumber != null && state.originalDirector2PanNumber == event.panNumber;
    if (unchangedFromOriginal && !state.isPanDetailsDataChanged && (state.fullDirector2NamePan ?? '').isNotEmpty) {
      emit(state.copyWith(isDirector2PanDetailsLoading: false, isDirector2PanDetailsVerified: true));
      return;
    }
    emit(
      state.copyWith(
        isDirector2PanDetailsLoading: true,
        isDirector2PanDetailsVerified: false,
        director2PanDetailsErrorMessage: '',
        isDirector2PanModifiedAfterVerification: false,
      ),
    );
    try {
      final userId = await Prefobj.preferences.get(Prefkeys.userId) ?? '';
      final GetPanDetailModel response = await _personalUserKycRepository.getPanDetails(
        kycRole: "OTHER_DIRECTOR",
        panNumber: event.panNumber,
        userId: userId,
      );
      if (response.success == true) {
        final String panName = response.data?.nameInformation?.panNameCleaned ?? '';
        emit(
          state.copyWith(
            isDirector2PanDetailsLoading: false,
            fullDirector2NamePan: panName,
            isDirector2PanDetailsVerified: true,
            isDirector2PanModifiedAfterVerification: true,
          ),
        );
        add(Director2PanEditAttempt());
      } else {
        emit(
          state.copyWith(
            isDirector2PanDetailsLoading: false,
            isDirector2PanDetailsVerified: false,
            director2PanDetailsErrorMessage: response.error ?? '',
            isDirector2PanModifiedAfterVerification: false,
            originalDirector2PanNumber: '',
            fullDirector2NamePan: '',
          ),
        );
      }
    } catch (e) {
      Logger.error(e.toString());
      emit(
        state.copyWith(
          isDirector2PanDetailsLoading: false,
          isDirector2PanDetailsVerified: false,
          isDirector2PanModifiedAfterVerification: false,
        ),
      );
    }
  }

  void _onDirector2PanNumberChanged(Director2PanNumberChanged event, Emitter<BusinessAccountSetupState> emit) {
    if (state.isDirector2PanEditLocked) {
      add(Director2PanEditAttempt());
    } else if (state.isDirector2PanDetailsVerified == true) {
      emit(
        state.copyWith(
          isDirector2PanModifiedAfterVerification: false,
          fullDirector2NamePan: '',
          isDirector2PanDetailsVerified: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isDirector2PanDetailsVerified: false,
          director2PanDetailsErrorMessage: '',
          fullDirector2NamePan: '',
          isDirector2PanModifiedAfterVerification: false,
          directorPANValidationErrorMessage: '',
        ),
      );
    }

    // Validate that PAN numbers are different
    final panValidationError = ExchekValidations.validateDirectorPANsAreDifferent(
      state.director1PanNumberController.text,
      event.panNumber,
    );

    emit(state.copyWith(directorPANValidationErrorMessage: panValidationError));
  }

  Future<void> _onDirector2PanEditAttempt(
    Director2PanEditAttempt event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    final result = handlePanEditAttempt(
      isLocked: state.isDirector2PanEditLocked,
      lockTime: state.director2PanEditLockTime,
      attempts: state.director2PanEditAttempts,
      panType: 'PAN',
    );

    if (result.shouldUnlock) {
      emit(
        state.copyWith(
          isDirector2PanEditLocked: false,
          director2PanEditLockTime: null,
          director2PanEditAttempts: 0,
          director2PanEditErrorMessage: '',
        ),
      );
      return;
    }

    if (result.isLocked) {
      emit(
        state.copyWith(
          director2PanEditErrorMessage: result.errorMessage,
          isDirector2PanEditLocked: result.isLocked,
          director2PanEditLockTime: result.lockTime,
          director2PanEditAttempts: result.attempts,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        director2PanEditAttempts: result.attempts,
        director2PanEditErrorMessage: result.errorMessage,
        isDirector2PanEditLocked: result.isLocked,
        director2PanEditLockTime: result.lockTime,
      ),
    );
  }

  Future<void> _onGetBeneficialOwnerPanDetails(
    GetBeneficialOwnerPanDetails event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    emit(
      state.copyWith(
        isBeneficialOwnerPanDetailsLoading: true,
        isBeneficialOwnerPanDetailsVerified: false,
        beneficialOwnerPanDetailsErrorMessage: '',
        isBeneficialOwnerPanModifiedAfterVerification: false,
      ),
    );
    try {
      final userId = await Prefobj.preferences.get(Prefkeys.userId) ?? '';
      final GetPanDetailModel response = await _personalUserKycRepository.getPanDetails(
        panNumber: event.panNumber,
        userId: userId,
        kycRole: "OWNER",
      );
      if (response.success == true) {
        final String panName = response.data?.nameInformation?.panNameCleaned ?? '';
        emit(
          state.copyWith(
            isBeneficialOwnerPanDetailsLoading: false,
            fullBeneficialOwnerNamePan: panName,
            isBeneficialOwnerPanDetailsVerified: true,
            isBeneficialOwnerPanModifiedAfterVerification: true,
          ),
        );
        add(BeneficialOwnerPanEditAttempt());
      } else {
        emit(
          state.copyWith(
            isBeneficialOwnerPanDetailsLoading: false,
            isBeneficialOwnerPanDetailsVerified: false,
            beneficialOwnerPanDetailsErrorMessage: response.error ?? '',
            isBeneficialOwnerPanModifiedAfterVerification: false,
            originalBusinessPanNumber: '',
            fullBeneficialOwnerNamePan: '',
          ),
        );
      }
    } catch (e) {
      Logger.error(e.toString());
      emit(
        state.copyWith(
          isBeneficialOwnerPanDetailsLoading: false,
          isBeneficialOwnerPanDetailsVerified: false,
          isBeneficialOwnerPanModifiedAfterVerification: false,
        ),
      );
    }
  }

  void _onBeneficialOwnerPanNumberChanged(
    BeneficialOwnerPanNumberChanged event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    if (state.isBeneficialOwnerPanEditLocked) {
      add(BeneficialOwnerPanEditAttempt());
    } else if (state.isBeneficialOwnerPanDetailsVerified == true) {
      emit(
        state.copyWith(
          isBeneficialOwnerPanModifiedAfterVerification: false,
          fullBeneficialOwnerNamePan: '',
          isBeneficialOwnerPanDetailsVerified: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isBeneficialOwnerPanDetailsVerified: false,
          beneficialOwnerPanDetailsErrorMessage: '',
          fullBeneficialOwnerNamePan: '',
          isBeneficialOwnerPanModifiedAfterVerification: false,
        ),
      );
    }
  }

  Future<void> _onBeneficialOwnerPanEditAttempt(
    BeneficialOwnerPanEditAttempt event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    final result = handlePanEditAttempt(
      isLocked: state.isBeneficialOwnerPanEditLocked,
      lockTime: state.beneficialOwnerPanEditLockTime,
      attempts: state.beneficialOwnerPanEditAttempts,
      panType: 'PAN',
    );

    if (result.shouldUnlock) {
      emit(
        state.copyWith(
          isBeneficialOwnerPanEditLocked: false,
          beneficialOwnerPanEditLockTime: null,
          beneficialOwnerPanEditAttempts: 0,
          beneficialOwnerPanEditErrorMessage: '',
        ),
      );
      return;
    }

    if (result.isLocked) {
      emit(
        state.copyWith(
          beneficialOwnerPanEditErrorMessage: result.errorMessage,
          isBeneficialOwnerPanEditLocked: result.isLocked,
          beneficialOwnerPanEditLockTime: result.lockTime,
          beneficialOwnerPanEditAttempts: result.attempts,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        beneficialOwnerPanEditAttempts: result.attempts,
        beneficialOwnerPanEditErrorMessage: result.errorMessage,
        isBeneficialOwnerPanEditLocked: result.isLocked,
        beneficialOwnerPanEditLockTime: result.lockTime,
      ),
    );
  }

  void _onContactInformationSubmitted(
    ContactInformationSubmitted event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    // Check if data has changed
    if (!state.isContactInformationDataChanged) {
      // Skip API call and navigate to next step
      final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
      if (nextStep != null) {
        add(KycStepChanged(nextStep));
      }
      return;
    }

    emit(state.copyWith(isContactInfoSubmitLoading: true));
    try {
      final String? userId = await Prefobj.preferences.get(Prefkeys.userId);

      final response = await _businessUserKycRepository.uploadContactDetails(
        userID: userId ?? '',
        mobileNumber: event.mobileNumber,
        emailId: event.emailId,
      );
      if (response.success == true) {
        // Reset data change flag after successful API call
        add(ResetDataChangeFlags());
        emit(state.copyWith(isContactInfoSubmitLoading: false));
        final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
        if (nextStep != null) {
          add(KycStepChanged(nextStep));
        }
      } else {
        emit(state.copyWith(isContactInfoSubmitLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isContactInfoSubmitLoading: false));
    }
  }

  void _onSaveOtherDirectorPanDetails(
    SaveOtherDirectorPanDetails event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    emit(state.copyWith(isOtherDirectorPanCardSaveLoading: true, isOtherDirectorPanCardSave: false));
    try {
      emit(state.copyWith(isOtherDirectorPanCardSaveLoading: false, isOtherDirectorPanCardSave: true));
      add(OtherDirectorKycStepChanged(OtherDirectorKycSteps.aadharDetails));
    } catch (e) {
      Logger.error('Error saving director PAN details: $e');
      emit(state.copyWith(isOtherDirectorPanCardSaveLoading: false));
    }
  }

  // Other Director Aadhar Event Handlers
  void _onOtherDirectorAadharNumberChanged(
    OtherDirectorAadharNumberChanged event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(
      state.copyWith(
        isOtherDirectorCaptchaSend: false,
        isOtherDirectorOtpSent: false,
        otherDirectorCaptchaImage: null,
        otherDirectorCaptchaInputController: TextEditingController(),
        otherDirectoraadharOtpController: TextEditingController(),
        isOtherDirectorAadharVerified: false,
        directorAadhaarValidationErrorMessage: '',
      ),
    );

    // Validate that Aadhaar numbers are different
    final aadhaarValidationError = ExchekValidations.validateDirectorAadhaarsAreDifferent(
      state.aadharNumberController.text,
      event.aadharNumber,
    );

    emit(state.copyWith(directorAadhaarValidationErrorMessage: aadhaarValidationError));
  }

  Future<void> _onOtherDirectorCaptchaSend(
    OtherDirectorCaptchaSend event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    try {
      emit(state.copyWith(isOtherDirectorDirectorCaptchaLoading: true, isOtherDirectorCaptchaSend: false));
      final userId = await Prefobj.preferences.get(Prefkeys.userId) ?? '';
      String kycRole = '';
      final userJson = await Prefobj.preferences.get(Prefkeys.userKycDetail);
      final userData = jsonDecode(userJson!);
      final businessDetails = userData['business_details'] ?? {};
      final businessType = businessDetails['business_type'] ?? '';
      if (businessType == 'limited_liability_partnership' || businessType == 'partnership') {
        kycRole = "OTHER_PARTNER";
      } else {
        kycRole = "OTHER_DIRECTOR";
      }

      final CaptchaModel response = await _businessUserKycRepository.generateCaptcha(
        userID: userId,
        aadhaarNumber: state.otherDirectorAadharNumberController.text,
        userType: 'business',
        kycRole: kycRole,
      );
      if (response.code == 200) {
        emit(
          state.copyWith(
            isOtherDirectorCaptchaSend: true,
            isOtherDirectorDirectorCaptchaLoading: false,
            otherDirectorCaptchaImage: response.data?.captcha ?? '',
          ),
        );
        await Prefobj.preferences.put(Prefkeys.sessionId, response.data?.sessionId ?? '');
      } else {
        emit(state.copyWith(isOtherDirectorDirectorCaptchaLoading: false, isOtherDirectorCaptchaSend: false));
      }
    } catch (e) {
      emit(state.copyWith(isOtherDirectorDirectorCaptchaLoading: false, isOtherDirectorCaptchaSend: false));
      Logger.error('Error :: $e');
    }
  }

  void _onOtherDirectorReCaptchaSend(OtherDirectorReCaptchaSend event, Emitter<BusinessAccountSetupState> emit) async {
    try {
      emit(state.copyWith(isOtherDirectorDirectorCaptchaLoading: true, isOtherDirectorCaptchaSend: false));
      final sessionId = await Prefobj.preferences.get(Prefkeys.sessionId) ?? '';

      final RecaptchaModel response = await _businessUserKycRepository.reGenerateCaptcha(sessionId: sessionId);
      if (response.code == 200) {
        emit(
          state.copyWith(
            isOtherDirectorCaptchaSend: true,
            isOtherDirectorDirectorCaptchaLoading: false,
            otherDirectorCaptchaImage: response.data?.captcha ?? '',
          ),
        );
        state.otherDirectorCaptchaInputController.clear();
      } else {
        emit(state.copyWith(isOtherDirectorDirectorCaptchaLoading: false, isOtherDirectorCaptchaSend: false));
      }
    } catch (e) {
      emit(state.copyWith(isOtherDirectorDirectorCaptchaLoading: false, isOtherDirectorCaptchaSend: false));
      Logger.error(e.toString());
    }
  }

  Future<void> _onOtherDirectorSendAadharOtp(
    OtherDirectorSendAadharOtp event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    try {
      state.otherDirectoraadharOtpController.clear();
      emit(
        state.copyWith(
          isOtherDirectorOtpSent: false,
          isOtherDirectorAadharOtpLoading: true,
          isOtherAadharOTPInvalidate: '',
        ),
      );
      AadharOTPSendModel response = await _businessUserKycRepository.generateAadharOTP(
        aadhaarNumber: event.aadharNumber.replaceAll("-", ""),
        captcha: event.captchaInput,
        sessionId: event.sessionId,
      );
      if (response.code == 200) {
        emit(state.copyWith(isOtherDirectorOtpSent: true, isOtherDirectorAadharOtpLoading: false));
        add(OtherDirectorAadharSendOtpPressed());
      } else {
        AppToast.show(message: response.message ?? '', type: ToastificationType.error);
        emit(state.copyWith(isOtherDirectorAadharOtpLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isOtherDirectorOtpSent: false, isOtherDirectorAadharOtpLoading: false));
    }
  }

  void _onOtherDirectorAadharSendOtpPressed(
    OtherDirectorAadharSendOtpPressed event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    _otherDirectorAadhartimer?.cancel();
    emit(state.copyWith(isOtherDirectorAadharOtpTimerRunning: true, otherDirectorAadharOtpRemainingTime: initialTime));
    _otherDirectorAadhartimer = Timer.periodic(Duration(seconds: 1), (timer) {
      final newTime = state.otherDirectorAadharOtpRemainingTime - 1;
      if (newTime <= 0) {
        timer.cancel();
        add(OtherDirectorAadharOtpTimerTicked(0));
      } else {
        add(OtherDirectorAadharOtpTimerTicked(newTime));
      }
    });
  }

  void _onOtherDirectorAadharOtpTimerTicked(
    OtherDirectorAadharOtpTimerTicked event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(
      state.copyWith(
        otherDirectorAadharOtpRemainingTime: event.remainingTime,
        isOtherDirectorAadharOtpTimerRunning: event.remainingTime > 0,
      ),
    );
  }

  void _onOtherDirectorAadharNumbeVerified(
    OtherDirectorAadharNumbeVerified event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    emit(state.copyWith(isOtherDirectorAadharVerifiedLoading: true, isOtherAadharOTPInvalidate: null));
    try {
      final sessionId = await Prefobj.preferences.get(Prefkeys.sessionId) ?? '';
      final userId = await Prefobj.preferences.get(Prefkeys.userId) ?? '';

      String kycRole = '';
      final userJson = await Prefobj.preferences.get(Prefkeys.userKycDetail);
      final userData = jsonDecode(userJson!);
      final businessDetails = userData['business_details'] ?? {};
      final businessType = businessDetails['business_type'] ?? '';
      if (businessType == 'limited_liability_partnership' || businessType == 'partnership') {
        kycRole = "OTHER_PARTNER";
      } else {
        kycRole = "OTHER_DIRECTOR";
      }

      final AadharOTPVerifyModel response = await _businessUserKycRepository.validateAadharOtp(
        faker: false,
        otp: event.otp,
        sessionId: sessionId,
        userId: userId,
        kycRole: kycRole,
        userType: 'business',
        aadhaarNumber: event.aadharNumber,
      );
      if (response.code == 200) {
        emit(
          state.copyWith(
            isOtherDirectorAadharVerifiedLoading: false,
            isOtherDirectorAadharVerified: true,
            otherDirectorAadharNumber: event.aadharNumber,
          ),
        );
        _otherDirectorAadhartimer?.cancel();
      } else {
        emit(
          state.copyWith(
            isOtherDirectorAadharVerifiedLoading: false,
            isOtherAadharOTPInvalidate: response.message.toString(),
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(isOtherDirectorAadharVerifiedLoading: false));
      Logger.error(e.toString());
    }
  }

  void _onOtherDirectorFrontSlideAadharCardUpload(
    OtherDirectorFrontSlideAadharCardUpload event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(isOtherDirectorAadharfrontSideAdharFileDeleted: false));
    if (event.fileData == null) {
      emit(
        state.copyWith(
          otherDirectorAadharfrontSideAdharFile: null,
          isOtherDirectorAadharfrontSideAdharFileDeleted: true,
        ),
      );
    } else {
      emit(
        state.copyWith(
          otherDirectorAadharfrontSideAdharFile: event.fileData,
          isOtherDirectorAadharfrontSideAdharFileDeleted: false,
        ),
      );
    }
  }

  void _onOtherDirectorBackSlideAadharCardUpload(
    OtherDirectorBackSlideAadharCardUpload event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(isOtherDirectorAadharBackSideAdharFileDeleted: false));
    if (event.fileData == null) {
      emit(
        state.copyWith(otherDirectorAadharBackSideAdharFile: null, isOtherDirectorAadharBackSideAdharFileDeleted: true),
      );
    } else {
      emit(
        state.copyWith(
          otherDirectorAadharBackSideAdharFile: event.fileData,
          isOtherDirectorAadharBackSideAdharFileDeleted: false,
        ),
      );
    }
  }

  void _onOtherDirectorAadharFileUploadSubmitted(
    OtherDirectorAadharFileUploadSubmitted event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    if (!state.ditector1BusinessRepresentative && !state.ditector2BusinessRepresentative) {
      emit(state.copyWith(isOtherDirectorAadharFileUploading: true));

      try {
        emit(state.copyWith(isOtherDirectorAadharFileUploading: false));
      } catch (e) {
        Logger.error('Error uploading Aadhaar files: $e');
        emit(state.copyWith(isOtherDirectorAadharFileUploading: false));
      }
    } else {
      emit(state.copyWith(isOtherDirectorAadharFileUploading: true, isOtherDirectorKycVerify: false));

      try {
        emit(state.copyWith(isOtherDirectorAadharFileUploading: false, isOtherDirectorKycVerify: true));
      } catch (e) {
        Logger.error('Error uploading Aadhaar files: $e');
        emit(state.copyWith(isOtherDirectorAadharFileUploading: false, isOtherDirectorKycVerify: false));
      }
    }
  }

  void _onOtherDirectorShowDialogWidthoutAadharUpload(
    OtherDirectorShowDialogWidthoutAadharUpload event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    if (!state.ditector1BusinessRepresentative && !state.ditector2BusinessRepresentative) {
      emit(state.copyWith(isOtherDirectorAadharFileUploading: true));
      try {
        emit(state.copyWith(isOtherDirectorAadharFileUploading: false));
      } catch (e) {
        Logger.error('Error uploading Aadhaar files: $e');
        emit(state.copyWith(isOtherDirectorAadharFileUploading: false));
      }
    } else {
      emit(state.copyWith(isOtherDirectorAadharFileUploading: true, isOtherDirectorKycVerify: false));
      try {
        emit(state.copyWith(isOtherDirectorAadharFileUploading: false, isOtherDirectorKycVerify: true));
      } catch (e) {
        Logger.error('Error uploading Aadhaar files: $e');
        emit(state.copyWith(isOtherDirectorAadharFileUploading: false, isOtherDirectorKycVerify: false));
      }
    }
  }

  void _onDirectorKycStepChange(DirectorKycStepChanged event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(directorKycStep: event.stepIndex));
  }

  void _onOtherDirectorKycStepChange(OtherDirectorKycStepChanged event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(otherDirectorKycStep: event.stepIndex));
  }

  void _onShowBusinessRepresentativeSelectionDialog(
    ShowBusinessRepresentativeSelectionDialog event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(showBusinessRepresentativeSelectionDialog: true));
  }

  void _onSelectBusinessRepresentative(SelectBusinessRepresentative event, Emitter<BusinessAccountSetupState> emit) {
    // Set the selected option and update the director business representative flags
    bool director1BusinessRepresentative = false;
    bool director2BusinessRepresentative = false;

    if (event.selectedOption == "Authorized Director") {
      director1BusinessRepresentative = true;
      director2BusinessRepresentative = false;
    } else if (event.selectedOption == "Other Director") {
      director1BusinessRepresentative = false;
      director2BusinessRepresentative = true;
    }

    emit(
      state.copyWith(
        selectedBusinessRepresentativeOption: event.selectedOption,
        ditector1BusinessRepresentative: director1BusinessRepresentative,
        ditector2BusinessRepresentative: director2BusinessRepresentative,
        showBusinessRepresentativeSelectionDialog: false,
      ),
    );
  }

  void _onConfirmBusinessRepresentativeAndNextStep(
    ConfirmBusinessRepresentativeAndNextStep event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    emit(state.copyWith(isBusinessRepresentativeConfirmLoading: true, isOtherDirectorKycVerify: false));
    try {
      emit(state.copyWith(isBusinessRepresentativeConfirmLoading: false, isOtherDirectorKycVerify: true));
    } catch (e) {
      emit(state.copyWith(isBusinessRepresentativeConfirmLoading: false));
      Logger.error(e.toString());
    }
  }

  Future<void> _onGetCompanyPanDetails(GetCompanyPanDetails event, Emitter<BusinessAccountSetupState> emit) async {
    // Skip API if PAN unchanged from original and no data changed, and we have cached name
    final bool unchangedFromOriginal =
        state.originalBusinessPanNumber != null && state.originalBusinessPanNumber == event.panNumber;
    if (unchangedFromOriginal) {
      emit(state.copyWith(isCompanyPanDetailsLoading: false, isCompanyPanDetailsVerified: true));
      return;
    }
    emit(
      state.copyWith(
        isCompanyPanDetailsLoading: true,
        isCompanyPanDetailsVerified: false,
        companyPanDetailsErrorMessage: '',
        isCompanyPanModifiedAfterVerification: false,
      ),
    );
    try {
      final userId = await Prefobj.preferences.get(Prefkeys.userId) ?? '';
      final GetPanDetailModel response = await _personalUserKycRepository.getPanDetails(
        panNumber: event.panNumber,
        userId: userId,
        kycRole: 'COMPANY',
      );
      if (response.success == true) {
        final String panName = response.data?.nameInformation?.panNameCleaned ?? '';
        emit(
          state.copyWith(
            isCompanyPanDetailsLoading: false,
            fullCompanyNamePan: panName,
            isCompanyPanDetailsVerified: true,
            isCompanyPanModifiedAfterVerification: true,
          ),
        );
        add(CompanyPanEditAttempt());
      } else {
        emit(
          state.copyWith(
            isCompanyPanDetailsLoading: false,
            companyPanDetailsErrorMessage: response.error ?? '',
            isCompanyPanModifiedAfterVerification: false,
            originalBusinessPanNumber: '',
            fullCompanyNamePan: '',
          ),
        );
      }
    } catch (e) {
      Logger.error(e.toString());
      emit(
        state.copyWith(
          isCompanyPanDetailsLoading: false,
          isCompanyPanDetailsVerified: false,
          isCompanyPanModifiedAfterVerification: false,
          originalBusinessPanNumber: '',
        ),
      );
    }
  }

  void _onCompanyPanNumberChanged(CompanyPanNumberChanged event, Emitter<BusinessAccountSetupState> emit) {
    if (state.isCompanyPanEditLocked) {
      add(CompanyPanEditAttempt());
    } else if (state.isCompanyPanDetailsVerified == true) {
      emit(
        state.copyWith(
          isCompanyPanModifiedAfterVerification: false,
          isCompanyPanDetailsVerified: false,
          fullCompanyNamePan: '',
        ),
      );
    } else {
      emit(
        state.copyWith(
          isCompanyPanDetailsVerified: false,
          fullCompanyNamePan: '',
          companyPanDetailsErrorMessage: '',
          isCompanyPanModifiedAfterVerification: false,
        ),
      );
    }
  }

  void _onUploadCompanyPanCard(UploadCompanyPanCard event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(isCompanyPanCardFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(companyPanCardFile: null, isCompanyPanCardFileDeleted: true));
    } else {
      emit(state.copyWith(companyPanCardFile: event.fileData, isCompanyPanCardFileDeleted: false));
    }
  }

  void _onCompanyPanVerificationSubmitted(
    CompanyPanVerificationSubmitted event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    // Check if data has changed and files are already uploaded
    if (!state.isCompanyPanDataChanged && state.companyPanCardFile != null) {
      // Skip API call and navigate to next step
      final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
      if (nextStep != null) {
        add(KycStepChanged(nextStep));
      }
      return;
    }

    emit(state.copyWith(isCompanyPanVerifyingLoading: true));
    try {
      final String? userId = await Prefobj.preferences.get(Prefkeys.userId);

      final response = await _personalUserKycRepository.uploadPanDetails(
        userID: userId ?? '',
        userType: 'business',
        panNumber: state.companyPanNumberController.text.trim(),
        nameOnPan: state.fullCompanyNamePan ?? '',
        panDoc: state.companyPanCardFile!,
        kycRole: "COMPANY",
      );
      if (response.success == true) {
        // Reset data change flag after successful API call
        add(ResetDataChangeFlags());
        final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
        if (nextStep != null) {
          add(KycStepChanged(nextStep));
        }
        emit(state.copyWith(isCompanyPanVerifyingLoading: false));
      } else {
        emit(state.copyWith(isCompanyPanVerifyingLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isCompanyPanVerifyingLoading: false));
    }
  }

  /// Helper method to get the next KYC step based on business type
  Future<KycVerificationSteps?> _getNextKycStep(KycVerificationSteps currentStep) async {
    try {
      // Get all steps from API data for navigation
      final userJson = await Prefobj.preferences.get(Prefkeys.userKycDetail);
      if (userJson != null) {
        final userData = jsonDecode(userJson);
        final allSteps = await KycStepUtils.getAllStepsForDisplay(userData);
        print('steps: $allSteps');
        print('steps:2 ${KycStepUtils.getNextStepFromFilteredSteps(currentStep, allSteps)}');
        return KycStepUtils.getNextStepFromFilteredSteps(currentStep, allSteps);
      }

      // Fallback to original method if no API data
      return await KycStepUtils.getNextStep(currentStep, state);
    } catch (e) {
      Logger.error('Error getting next KYC step: $e');
      return null;
    }
  }

  /// Helper method to get the previous KYC step based on business type
  Future<KycVerificationSteps?> _getPreviousKycStep(KycVerificationSteps currentStep) async {
    try {
      // Get all steps from API data for navigation
      final userJson = await Prefobj.preferences.get(Prefkeys.userKycDetail);
      if (userJson != null) {
        final userData = jsonDecode(userJson);
        final allSteps = await KycStepUtils.getAllStepsForDisplay(userData);
        return KycStepUtils.getPreviousStepFromFilteredSteps(currentStep, allSteps);
      }

      // Fallback to original method if no API data
      return await KycStepUtils.getPreviousStep(currentStep, state);
    } catch (e) {
      Logger.error('Error getting previous KYC step: $e');
      return null;
    }
  }

  /// Helper method to get all available steps for a business type
  Future<List<KycVerificationSteps>> getAvailableSteps() async {
    try {
      // Get all steps from API data for display
      final userJson = await Prefobj.preferences.get(Prefkeys.userKycDetail);
      if (userJson != null) {
        final userData = jsonDecode(userJson);
        return await KycStepUtils.getAllStepsForDisplay(userData);
      }

      // Fallback to original method if no API data
      return await KycStepUtils.getStepsForCurrentUser(state);
    } catch (e) {
      Logger.error('Error getting available steps: $e');
      return [];
    }
  }

  void _onNavigateToNextKycStep(NavigateToNextKycStep event, Emitter<BusinessAccountSetupState> emit) async {
    final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
    if (nextStep != null) {
      add(KycStepChanged(nextStep));
    }
  }

  void _onNavigateToPreviousKycStep(NavigateToPreviousKycStep event, Emitter<BusinessAccountSetupState> emit) async {
    final previousStep = await _getPreviousKycStep(state.currentKycVerificationStep);
    if (previousStep != null) {
      add(KycStepChanged(previousStep));
    }
    // If no previous step, the UI will handle navigation back
  }

  void _onGetAvailableKycSteps(GetAvailableKycSteps event, Emitter<BusinessAccountSetupState> emit) async {
    // This event can be used to get available steps if needed in the future
    // For now, we'll just log the available steps
    final availableSteps = await getAvailableSteps();
    debugPrint('Available KYC Steps: $availableSteps');
  }

  void _onUploadLLPPanCard(UploadLLPPanCard event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(isLLPPanCardFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(llpPanCardFile: null, isLLPPanCardFileDeleted: true));
    } else {
      emit(state.copyWith(llpPanCardFile: event.fileData, isLLPPanCardFileDeleted: false));
    }
  }

  void _onLLPPanVerificationSubmitted(
    LLPPanVerificationSubmitted event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    // Check if data has changed and files are already uploaded
    if (!state.isLLPPanDataChanged && state.llpPanCardFile != null) {
      // Skip API call and navigate to next step
      final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
      if (nextStep != null) {
        add(KycStepChanged(nextStep));
      }
      return;
    }

    emit(state.copyWith(isLLPPanVerifyingLoading: true));
    try {
      final String? userId = await Prefobj.preferences.get(Prefkeys.userId);

      final response = await _personalUserKycRepository.uploadPanDetails(
        userID: userId ?? '',
        userType: 'business',
        panNumber: state.llpPanNumberController.text.trim(),
        nameOnPan: state.fullLLPNamePan ?? '',
        panDoc: state.llpPanCardFile!,
        kycRole: "LLP",
      );
      if (response.success == true) {
        // Reset data change flag after successful API call
        add(ResetDataChangeFlags());
        final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
        if (nextStep != null) {
          add(KycStepChanged(nextStep));
        }
        emit(state.copyWith(isLLPPanVerifyingLoading: false));
      } else {
        emit(state.copyWith(isLLPPanVerifyingLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLLPPanVerifyingLoading: false));
    }
  }

  Future<void> _onGetLLPPanDetails(GetLLPPanDetails event, Emitter<BusinessAccountSetupState> emit) async {
    // Skip API if PAN unchanged from original and no data changed, and we have cached name
    final bool unchangedFromOriginal =
        state.originalBusinessPanNumber != null && state.originalBusinessPanNumber == event.panNumber;
    if (unchangedFromOriginal && !state.isLLPPanDataChanged && (state.fullLLPNamePan ?? '').isNotEmpty) {
      emit(state.copyWith(isLLPPanDetailsLoading: false, isLLPPanDetailsVerified: true));
      return;
    }
    emit(
      state.copyWith(
        isLLPPanDetailsLoading: true,
        isLLPPanDetailsVerified: false,
        llpPanDetailsErrorMessage: '',
        isLLPPanModifiedAfterVerification: false,
      ),
    );
    try {
      final userId = await Prefobj.preferences.get(Prefkeys.userId) ?? '';
      final GetPanDetailModel response = await _personalUserKycRepository.getPanDetails(
        panNumber: event.panNumber,
        userId: userId,
        kycRole: 'LLP',
      );
      if (response.success == true) {
        final String panName = response.data?.nameInformation?.panNameCleaned ?? '';
        emit(
          state.copyWith(
            isLLPPanDetailsLoading: false,
            fullLLPNamePan: panName,
            isLLPPanDetailsVerified: true,
            isLLPPanModifiedAfterVerification: true,
          ),
        );
        add(LLPPanEditAttempt());
      } else {
        emit(
          state.copyWith(
            isLLPPanDetailsLoading: false,
            isLLPPanDetailsVerified: false,
            llpPanDetailsErrorMessage: response.error ?? '',
            isLLPPanModifiedAfterVerification: false,
            originalBusinessPanNumber: '',
            fullLLPNamePan: '',
          ),
        );
      }
    } catch (e) {
      Logger.error(e.toString());
      emit(
        state.copyWith(
          isLLPPanDetailsLoading: false,
          isLLPPanDetailsVerified: false,
          isLLPPanModifiedAfterVerification: false,
        ),
      );
    }
  }

  void _onLLPPanNumberChanged(LLPPanNumberChanged event, Emitter<BusinessAccountSetupState> emit) {
    if (state.isLLPPanEditLocked) {
      add(LLPPanEditAttempt());
    } else if (state.isLLPPanDetailsVerified == true) {
      emit(
        state.copyWith(isLLPPanModifiedAfterVerification: false, fullLLPNamePan: '', isLLPPanDetailsVerified: false),
      );
    } else {
      emit(
        state.copyWith(
          isLLPPanDetailsVerified: false,
          llpPanDetailsErrorMessage: '',
          fullLLPNamePan: '',
          isLLPPanModifiedAfterVerification: false,
        ),
      );
    }
  }

  Future<void> _onLLPPanEditAttempt(LLPPanEditAttempt event, Emitter<BusinessAccountSetupState> emit) async {
    final result = handlePanEditAttempt(
      isLocked: state.isLLPPanEditLocked,
      lockTime: state.llpPanEditLockTime,
      attempts: state.llpPanEditAttempts,
      panType: 'PAN',
    );

    if (result.shouldUnlock) {
      emit(
        state.copyWith(
          isLLPPanEditLocked: false,
          llpPanEditLockTime: null,
          llpPanEditAttempts: 0,
          llpPanEditErrorMessage: '',
        ),
      );
      return;
    }

    if (result.isLocked) {
      emit(
        state.copyWith(
          llpPanEditErrorMessage: result.errorMessage,
          isLLPPanEditLocked: result.isLocked,
          llpPanEditLockTime: result.lockTime,
          llpPanEditAttempts: result.attempts,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        llpPanEditAttempts: result.attempts,
        llpPanEditErrorMessage: result.errorMessage,
        isLLPPanEditLocked: result.isLocked,
        llpPanEditLockTime: result.lockTime,
      ),
    );
  }

  void _onUploadPartnershipFirmPanCard(UploadPartnershipFirmPanCard event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(isPartnershipFirmPanCardFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(partnershipFirmPanCardFile: null, isPartnershipFirmPanCardFileDeleted: true));
    } else {
      emit(state.copyWith(partnershipFirmPanCardFile: event.fileData, isPartnershipFirmPanCardFileDeleted: false));
    }
  }

  void _onPartnershipFirmPanVerificationSubmitted(
    PartnershipFirmPanVerificationSubmitted event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    // Check if data has changed and files are already uploaded
    if (!state.isPartnershipFirmPanDataChanged && state.partnershipFirmPanCardFile != null) {
      // Skip API call and navigate to next step
      final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
      if (nextStep != null) {
        add(KycStepChanged(nextStep));
      }
      return;
    }

    emit(state.copyWith(isPartnershipFirmPanVerifyingLoading: true));
    try {
      final String? userId = await Prefobj.preferences.get(Prefkeys.userId);

      final response = await _personalUserKycRepository.uploadPanDetails(
        userID: userId ?? '',
        userType: 'business',
        panNumber: state.partnershipFirmPanNumberController.text.trim(),
        nameOnPan: state.fullPartnershipFirmNamePan ?? '',
        panDoc: state.partnershipFirmPanCardFile!,
        kycRole: "PARTNERSHIP",
      );
      if (response.success == true) {
        // Reset data change flag after successful API call
        add(ResetDataChangeFlags());
        final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
        if (nextStep != null) {
          add(KycStepChanged(nextStep));
        }
        emit(state.copyWith(isPartnershipFirmPanVerifyingLoading: false));
      } else {
        emit(state.copyWith(isPartnershipFirmPanVerifyingLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isPartnershipFirmPanVerifyingLoading: false));
    }
  }

  void _onPartnershipFirmPanNumberChanged(
    PartnershipFirmPanNumberChanged event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    if (state.isPartnershipFirmPanEditLocked) {
      add(PartnershipFirmPanEditAttempt());
    } else if (state.isPartnershipFirmPanDetailsVerified == true) {
      emit(
        state.copyWith(
          isPartnershipFirmPanModifiedAfterVerification: false,
          fullPartnershipFirmNamePan: '',
          isPartnershipFirmPanDetailsVerified: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isPartnershipFirmPanDetailsVerified: false,
          partnershipFirmPanDetailsErrorMessage: '',
          fullPartnershipFirmNamePan: '',
          isPartnershipFirmPanModifiedAfterVerification: false,
        ),
      );
    }
  }

  void _onUploadSoleProprietorShipPanCard(
    UploadSoleProprietorShipPanCard event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(isSoleProprietorShipPanCardFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(soleProprietorShipPanCardFile: null, isSoleProprietorShipPanCardFileDeleted: true));
    } else {
      emit(
        state.copyWith(soleProprietorShipPanCardFile: event.fileData, isSoleProprietorShipPanCardFileDeleted: false),
      );
    }
  }

  void _onSoleProprietorShipPanVerificationSubmitted(
    SoleProprietorShipPanVerificationSubmitted event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    // Check if data has changed and files are already uploaded
    if (!state.isSoleProprietorshipPanDataChanged && state.soleProprietorShipPanCardFile != null) {
      // Skip API call and navigate to next step
      final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
      if (nextStep != null) {
        add(KycStepChanged(nextStep));
      }
      return;
    }

    emit(state.copyWith(isSoleProprietorShipPanVerifyingLoading: true));
    try {
      final String? userId = await Prefobj.preferences.get(Prefkeys.userId);

      final response = await _personalUserKycRepository.uploadPanDetails(
        userID: userId ?? '',
        userType: 'business',
        panNumber: state.soleProprietorShipPanNumberController.text.trim(),
        nameOnPan: state.fullSoleProprietorShipNamePan ?? '',
        panDoc: state.soleProprietorShipPanCardFile!,
        kycRole: "PROPRIETOR",
      );
      if (response.success == true) {
        // Reset data change flag after successful API call
        add(ResetDataChangeFlags());
        final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
        if (nextStep != null) {
          add(KycStepChanged(nextStep));
        }
        emit(state.copyWith(isSoleProprietorShipPanVerifyingLoading: false));
      } else {
        emit(state.copyWith(isSoleProprietorShipPanVerifyingLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isSoleProprietorShipPanVerifyingLoading: false));
    }
  }

  void _onSoleProprietorShipPanNumberChanged(
    SoleProprietorShipPanNumberChanged event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    if (state.isSoleProprietorShipPanEditLocked) {
      add(SoleProprietorShipPanEditAttempt());
    } else if (state.isSoleProprietorShipPanDetailsVerified == true) {
      emit(
        state.copyWith(
          isSoleProprietorShipPanModifiedAfterVerification: false,
          fullSoleProprietorShipNamePan: '',
          isSoleProprietorShipPanDetailsVerified: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isSoleProprietorShipPanDetailsVerified: false,
          soleProprietorShipPanDetailsErrorMessage: '',
          fullSoleProprietorShipNamePan: '',
          isSoleProprietorShipPanModifiedAfterVerification: false,
        ),
      );
    }
  }

  void _onUploadKartaPanCard(UploadKartaPanCard event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(isKartaPanCardFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(kartaPanCardFile: null, isKartaPanCardFileDeleted: true));
    } else {
      emit(state.copyWith(kartaPanCardFile: event.fileData, isKartaPanCardFileDeleted: false));
    }
  }

  void _onKartaPanVerificationSubmitted(
    KartaPanVerificationSubmitted event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    // Check if data has changed and files are already uploaded
    if (!state.isKartaPanDataChanged && state.kartaPanCardFile != null) {
      // Skip API call and navigate to next step
      final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
      if (nextStep != null) {
        add(KycStepChanged(nextStep));
      }
      return;
    }

    emit(state.copyWith(isKartaPanVerifyingLoading: true));
    try {
      final String? userId = await Prefobj.preferences.get(Prefkeys.userId);

      final response = await _personalUserKycRepository.uploadPanDetails(
        userID: userId ?? '',
        userType: 'business',
        panNumber: state.kartaPanNumberController.text.trim(),
        nameOnPan: state.fullKartaNamePan ?? '',
        panDoc: state.kartaPanCardFile!,
        kycRole: "KARTA",
      );
      if (response.success == true) {
        // Reset data change flag after successful API call
        add(ResetDataChangeFlags());
        final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
        if (nextStep != null) {
          add(KycStepChanged(nextStep));
        }
        emit(state.copyWith(isKartaPanVerifyingLoading: false));
      } else {
        emit(state.copyWith(isKartaPanVerifyingLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isKartaPanVerifyingLoading: false));
    }
  }

  Future<void> _onGetKartaPanDetails(GetKartaPanDetails event, Emitter<BusinessAccountSetupState> emit) async {
    // Skip API if PAN unchanged from original and no data changed, and we have cached name
    final bool unchangedFromOriginal =
        state.originalBusinessPanNumber != null && state.originalBusinessPanNumber == event.panNumber;
    if (unchangedFromOriginal && !state.isKartaPanDataChanged && (state.fullKartaNamePan ?? '').isNotEmpty) {
      emit(state.copyWith(isKartaPanDetailsLoading: false, isKartaPanDetailsVerified: true));
      return;
    }
    emit(
      state.copyWith(
        isKartaPanDetailsLoading: true,
        isKartaPanDetailsVerified: false,
        kartaPanDetailsErrorMessage: '',
        isKartaPanModifiedAfterVerification: false,
      ),
    );
    try {
      final userId = await Prefobj.preferences.get(Prefkeys.userId) ?? '';
      final GetPanDetailModel response = await _personalUserKycRepository.getPanDetails(
        panNumber: event.panNumber,
        userId: userId,
        kycRole: 'KARTA',
      );
      if (response.success == true) {
        final String panName = response.data?.nameInformation?.panNameCleaned ?? '';
        emit(
          state.copyWith(
            isKartaPanDetailsLoading: false,
            fullKartaNamePan: panName,
            isKartaPanDetailsVerified: true,
            isKartaPanModifiedAfterVerification: true,
          ),
        );
        add(KartaPanEditAttempt());
      } else {
        emit(
          state.copyWith(
            isKartaPanDetailsLoading: false,
            isKartaPanDetailsVerified: false,
            kartaPanDetailsErrorMessage: response.error ?? '',
            isKartaPanModifiedAfterVerification: false,
            originalBusinessPanNumber: '',
            fullKartaNamePan: '',
          ),
        );
      }
    } catch (e) {
      Logger.error(e.toString());
      emit(
        state.copyWith(
          isKartaPanDetailsLoading: false,
          isKartaPanDetailsVerified: false,
          isKartaPanModifiedAfterVerification: false,
        ),
      );
    }
  }

  void _onKartaPanNumberChanged(KartaPanNumberChanged event, Emitter<BusinessAccountSetupState> emit) {
    if (state.isKartaPanEditLocked) {
      add(KartaPanEditAttempt());
    } else if (state.isKartaPanDetailsVerified == true) {
      emit(
        state.copyWith(
          isKartaPanModifiedAfterVerification: false,
          fullKartaNamePan: '',
          isKartaPanDetailsVerified: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isKartaPanDetailsVerified: false,
          kartaPanDetailsErrorMessage: '',
          fullKartaNamePan: '',
          isKartaPanModifiedAfterVerification: false,
        ),
      );
    }
  }

  Future<void> _onKartaPanEditAttempt(KartaPanEditAttempt event, Emitter<BusinessAccountSetupState> emit) async {
    final result = handlePanEditAttempt(
      isLocked: state.isKartaPanEditLocked,
      lockTime: state.kartaPanEditLockTime,
      attempts: state.kartaPanEditAttempts,
      panType: 'PAN',
    );

    if (result.shouldUnlock) {
      emit(
        state.copyWith(
          isKartaPanEditLocked: false,
          kartaPanEditLockTime: null,
          kartaPanEditAttempts: 0,
          kartaPanEditErrorMessage: '',
        ),
      );
      return;
    }

    if (result.isLocked) {
      emit(
        state.copyWith(
          kartaPanEditErrorMessage: result.errorMessage,
          isKartaPanEditLocked: result.isLocked,
          kartaPanEditLockTime: result.lockTime,
          kartaPanEditAttempts: result.attempts,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        kartaPanEditAttempts: result.attempts,
        kartaPanEditErrorMessage: result.errorMessage,
        isKartaPanEditLocked: result.isLocked,
        kartaPanEditLockTime: result.lockTime,
      ),
    );
  }

  void _onChangeAadharAddressSameAsResidentialAddress(
    ChangeAadharAddressSameAsResidentialAddress event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(isAadharAddressSameAsResidentialAddress: event.isSame));
  }

  void _onUpdateAuthorizedSelectedCountry(
    UpdateAuthorizedSelectedCountry event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(authorizedSelectedCountry: event.country));
  }

  Future<void> _onBusinessAuthorizedGetCityAndState(
    BusinessAuthorizedGetCityAndState event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    emit(state.copyWith(isAuthorizedCityAndStateLoading: true));
    try {
      final GetCityAndStateModel response = await _personalUserKycRepository.getCityAndState(pincode: event.pinCode);
      if (response.success == true) {
        emit(
          state.copyWith(
            isAuthorizedCityAndStateLoading: false,
            authorizedCityNameController: TextEditingController(text: response.data?.city ?? ''),
            authorizedStateNameController: TextEditingController(text: response.data?.state ?? ''),
          ),
        );
      } else {
        emit(state.copyWith(isAuthorizedCityAndStateLoading: false));
      }
    } catch (e) {
      Logger.error(e.toString());
      emit(state.copyWith(isAuthorizedCityAndStateLoading: false));
    }
  }

  void _onChangeOtherDirectorAadharAddressSameAsResidentialAddress(
    ChangeOtherDirectorAadharAddressSameAsResidentialAddress event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(isOtherDirectorAadharAddressSameAsResidentialAddress: event.isSame));
  }

  void _onUpdateOtherDirectorSelectedCountry(
    UpdateOtherDirectorSelectedCountry event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(otherDirectorSelectedCountry: event.country));
  }

  Future<void> _onBusinessOtherDirectorGetCityAndState(
    BusinessOtherDirectorGetCityAndState event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    emit(state.copyWith(isOtherDirectorCityAndStateLoading: true));
    try {
      final GetCityAndStateModel response = await _personalUserKycRepository.getCityAndState(pincode: event.pinCode);
      if (response.success == true) {
        emit(
          state.copyWith(
            isOtherDirectorCityAndStateLoading: false,
            otherDirectorCityNameController: TextEditingController(text: response.data?.city ?? ''),
            otherDirectorStateNameController: TextEditingController(text: response.data?.state ?? ''),
          ),
        );
      } else {
        emit(state.copyWith(isOtherDirectorCityAndStateLoading: false));
      }
    } catch (e) {
      Logger.error(e.toString());
      emit(state.copyWith(isOtherDirectorCityAndStateLoading: false));
    }
  }

  void _onBeneficialOwnerKycStepChanged(BeneficialOwnerKycStepChanged event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(beneficialOwnerKycStep: event.step));
  }

  void _onUpdateBeneficialOwnerSelectedCountry(
    UpdateBeneficialOwnerSelectedCountry event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(beneficialOwnerSelectedCountry: event.country));
  }

  Future<void> _onBusinessBeneficialOwnerGetCityAndState(
    BusinessBeneficialOwnerGetCityAndState event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    emit(state.copyWith(isBeneficialOwnerCityAndStateLoading: true));
    try {
      final GetCityAndStateModel response = await _personalUserKycRepository.getCityAndState(pincode: event.pinCode);
      if (response.success == true) {
        emit(
          state.copyWith(
            isBeneficialOwnerCityAndStateLoading: false,
            beneficialOwnerCityNameController: TextEditingController(text: response.data?.city ?? ''),
            beneficialOwnerStateNameController: TextEditingController(text: response.data?.state ?? ''),
          ),
        );
      } else {
        emit(state.copyWith(isBeneficialOwnerCityAndStateLoading: false));
      }
    } catch (e) {
      Logger.error(e.toString());
      emit(state.copyWith(isBeneficialOwnerCityAndStateLoading: false));
    }
  }

  void _onBusinessBeneficialOwnerAddressDetailsSubmitted(
    BusinessBeneficialOwnerAddressDetailsSubmitted event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    emit(state.copyWith(isBeneficialOwnerPanCardSave: false));
    try {
      emit(state.copyWith(isBeneficialOwnerPanCardSave: true));
    } catch (e) {
      Logger.error('Error saving director PAN details: $e');
      emit(state.copyWith(isBeneficialOwnerPanCardSave: false));
    }
  }

  void _onUploadBeneficialOwnershipDeclaration(
    UploadBeneficialOwnershipDeclaration event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(isBeneficialOwnershipDeclarationFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(beneficialOwnershipDeclarationFile: null, isBeneficialOwnershipDeclarationFileDeleted: true));
    } else {
      emit(
        state.copyWith(
          beneficialOwnershipDeclarationFile: event.fileData,
          isBeneficialOwnershipDeclarationFileDeleted: false,
        ),
      );
    }
  }

  Future<void> _onBeneficialOwnershipDeclarationSubmitted(
    BeneficialOwnershipDeclarationSubmitted event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    // Check if data has changed and files are already uploaded
    if (!state.isBeneficialOwnershipDataChanged && event.fileData == null) {
      // Skip API call and navigate to next step
      final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
      if (nextStep != null) {
        add(KycStepChanged(nextStep));
      }
      return;
    }

    emit(state.copyWith(isBeneficialOwnershipDeclarationVerifyingLoading: true));
    final String? userId = await Prefobj.preferences.get(Prefkeys.userId);
    try {
      if (event.fileData == null) {
        emit(state.copyWith(isBeneficialOwnershipDeclarationVerifyingLoading: false));
        final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
        if (nextStep != null) {
          add(KycStepChanged(nextStep));
        }
      } else {
        final response = await _personalUserKycRepository.uploadBusinessLegalDocuments(
          userID: userId ?? '',
          userType: 'business',
          documentType: 'BENEFICIAL_OWNERSHIP_DECLARATION',
          documentFrontImage: event.fileData,
        );
        if (response.success == true) {
          // Reset data change flag after successful API call
          add(ResetDataChangeFlags());
          final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
          if (nextStep != null) {
            add(KycStepChanged(nextStep));
          }
          emit(state.copyWith(isBeneficialOwnershipDeclarationVerifyingLoading: false));
        } else {
          emit(state.copyWith(isBeneficialOwnershipDeclarationVerifyingLoading: false));
        }
      }
    } catch (e) {
      Logger.error('Error uploading beneficial ownership declaration: $e');
      emit(state.copyWith(isBeneficialOwnershipDeclarationVerifyingLoading: false));
    }
  }

  void _onVerifyLLPPanSubmitted(VerifyLLPPanSubmitted event, Emitter<BusinessAccountSetupState> emit) async {
    emit(state.copyWith(isPanDetailVerifyLoading: true, isPanDetailVerifySuccess: false));
    try {
      final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
      if (nextStep != null) {
        add(KycStepChanged(nextStep));
      }
      emit(state.copyWith(isPanDetailVerifyLoading: false, isPanDetailVerifySuccess: true));
    } catch (e) {
      emit(state.copyWith(isPanDetailVerifyLoading: false, isPanDetailVerifySuccess: false));
    }
  }

  void _onVerifyPartnershipFirmPanSubmitted(
    VerifyPartnershipFirmPanSubmitted event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    emit(state.copyWith(isPanDetailVerifyLoading: true, isPanDetailVerifySuccess: false));

    try {
      final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
      if (nextStep != null) {
        add(KycStepChanged(nextStep));
      }
      emit(state.copyWith(isPanDetailVerifyLoading: false, isPanDetailVerifySuccess: true));
    } catch (e) {
      emit(state.copyWith(isPanDetailVerifyLoading: false, isPanDetailVerifySuccess: false));
    }
  }

  void _onGSTINOrIECHasUploaded(GSTINOrIECHasUploaded event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(isGSTINOrIECHasUploaded: event.isGSTINOrIECHasUploaded));
  }

  void _onUploadShopEstablishmentCertificate(
    UploadShopEstablishmentCertificate event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(isShopEstablishmentCertificateFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(shopEstablishmentCertificateFile: null, isShopEstablishmentCertificateFileDeleted: true));
    } else {
      emit(
        state.copyWith(
          shopEstablishmentCertificateFile: event.fileData,
          isShopEstablishmentCertificateFileDeleted: false,
        ),
      );
    }
  }

  void _onUploadUdyamCertificate(UploadUdyamCertificate event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(isUdyamCertificateFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(udyamCertificateFile: null, isUdyamCertificateFileDeleted: true));
    } else {
      emit(state.copyWith(udyamCertificateFile: event.fileData, isUdyamCertificateFileDeleted: false));
    }
  }

  void _onUploadTaxProfessionalTaxRegistration(
    UploadTaxProfessionalTaxRegistration event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(isTaxProfessionalTaxRegistrationFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(taxProfessionalTaxRegistrationFile: null, isTaxProfessionalTaxRegistrationFileDeleted: true));
    } else {
      emit(
        state.copyWith(
          taxProfessionalTaxRegistrationFile: event.fileData,
          isTaxProfessionalTaxRegistrationFileDeleted: false,
        ),
      );
    }
  }

  void _onUploadUtilityBill(UploadUtilityBill event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(isUtilityBillFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(utilityBillFile: null, isUtilityBillFileDeleted: true));
    } else {
      emit(state.copyWith(utilityBillFile: event.fileData, isUtilityBillFileDeleted: false));
    }
  }

  void _onBusinessDocumentsVerificationSubmitted(
    BusinessDocumentsVerificationSubmitted event,
    Emitter<BusinessAccountSetupState> emit,
  ) async {
    // Check if data has changed
    if (!state.isBusinessDocumentsDataChanged) {
      // Skip API call and navigate to next step
      final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
      if (nextStep != null) {
        add(KycStepChanged(nextStep));
      }
      return;
    }

    emit(state.copyWith(isBusinessDocumentsVerificationLoading: true));
    final userId = await Prefobj.preferences.get(Prefkeys.userId) ?? '';
    try {
      if (state.isGSTINOrIECHasUploaded == 0) {
        final response = await _businessUserKycRepository.uploadProofOfBusiness(
          hasProofOfBusiness: 'yes',
          udyam: state.udyamCertificateFile,
          shopLicense: state.shopEstablishmentCertificateFile,
          proftaxReg: state.taxProfessionalTaxRegistrationFile,
          utilityBill: state.utilityBillFile,
          userID: userId,
        );

        if (response.success == true) {
          // Reset data change flag after successful API call
          add(ResetDataChangeFlags());
          emit(state.copyWith(isBusinessDocumentsVerificationLoading: false));
          final nextStep = await _getNextKycStep(state.currentKycVerificationStep);
          if (nextStep != null) {
            add(KycStepChanged(nextStep));
          }
        } else {
          emit(state.copyWith(isBusinessDocumentsVerificationLoading: false));
        }
      } else {
        final response = await _businessUserKycRepository.uploadProofOfBusiness(
          hasProofOfBusiness: 'no',
          userID: userId,
        );
        if (response.success == true) {
          // Refresh user KYC details from backend to get updated freelancer status
          final userId = await Prefobj.preferences.get(Prefkeys.userId);
          final userKycDetailResponse = await _authRepository.getKycDetails(userId: userId ?? '');
          if (userKycDetailResponse.success == true) {
            await Prefobj.preferences.put(Prefkeys.userKycDetail, jsonEncode(userKycDetailResponse.data));
            emit(state.copyWith(isBusinessDocumentsVerificationLoading: false));
            final user = await Prefobj.preferences.get(Prefkeys.userKycDetail);
            final userDetail = jsonDecode(user!);
            if (userDetail['user_type'] == "personal") {
              if (kIsWeb) {
                GoRouter.of(event.context).go(RouteUri.personalAccountKycSetupView);
              } else {
                GoRouter.of(event.context).push(RouteUri.personalAccountKycSetupView);
              }
            } else {
              if (kIsWeb) {
                GoRouter.of(event.context).go(RouteUri.businessAccountKycSetupView);
              } else {
                GoRouter.of(event.context).push(RouteUri.businessAccountKycSetupView);
              }
            }
          }
        } else {
          emit(state.copyWith(isBusinessDocumentsVerificationLoading: false));
        }
      }
    } catch (e) {
      Logger.error('Error uploading business documents: $e');
      emit(state.copyWith(isBusinessDocumentsVerificationLoading: false));
    }
  }

  void _onICEVerificationSkipped(ICEVerificationSkipped event, Emitter<BusinessAccountSetupState> emit) async {
    try {
      // First, clear the ICE data to get the correct step list
      final stateWithoutIce = state.copyWith(iceCertificateFile: null, iceNumberController: TextEditingController());

      // Get the next step using the state without ICE data
      final nextStep = await KycStepUtils.getNextStep(state.currentKycVerificationStep, stateWithoutIce);
      if (nextStep != null) {
        add(KycStepChanged(nextStep));
      }

      // Emit the state with cleared ICE data
      emit(stateWithoutIce);
    } catch (e) {
      Logger.error('Error skipping ICE verification: $e');
    }
  }

  void _onDeleteDocument(DeleteDocument event, Emitter<BusinessAccountSetupState> emit) async {
    emit(state.copyWith(isDeleteDocumentLoading: true, isDeleteDocumentSuccess: false));
    final userId = await Prefobj.preferences.get(Prefkeys.userId) ?? '';
    try {
      final response = await _businessUserKycRepository.deleteDocument(
        documentNumber: event.documentNumber,
        documentType: event.documentType,
        kycRole: event.kycRole,
        path: event.path,
        screenName: event.screenName,
        userId: userId,
      );
      if (response.success == true) {
        emit(state.copyWith(isDeleteDocumentLoading: false, isDeleteDocumentSuccess: true));
      } else {
        emit(state.copyWith(isDeleteDocumentLoading: false, isDeleteDocumentSuccess: false));
      }
    } catch (e) {
      Logger.error('Error deleting document: $e');
      emit(state.copyWith(isDeleteDocumentLoading: false, isDeleteDocumentSuccess: false));
    }
  }

  void _onAnnualTurnoverScrollToSection(AnnualTurnoverScrollToSection event, Emitter<BusinessAccountSetupState> emit) {
    state.scrollDebounceTimer?.cancel();

    final scrollController = event.scrollController ?? state.scrollController;

    final newTimer = Timer(const Duration(milliseconds: 300), () {
      final RenderObject? renderObject = event.key.currentContext?.findRenderObject();
      if (renderObject != null) {
        scrollController.position.ensureVisible(
          renderObject,
          alignment: 0.7,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });

    emit(state.copyWith(scrollDebounceTimer: newTimer));
  }

  void _onProprietorEnableAadharEdit(ProprietorEnableAadharEdit event, Emitter<BusinessAccountSetupState> emit) {
    state.proprietorCaptchaInputController.clear();
    state.proprietorAadharOtpController.clear();

    emit(
      state.copyWith(
        isProprietorCaptchaSend: false,
        isProprietorCaptchaLoading: false,
        proprietorCaptchaImage: '',
        isProprietorOtpSent: false,
        isProprietorOtpLoading: false,
        isProprietorAadharOtpTimerRunning: false,
        proprietorAadharOtpRemainingTime: 0,
        proprietorIsAadharOTPInvalidate: null,
      ),
    );
  }

  void _onDirectorEnableAadharEdit(DirectorEnableAadharEdit event, Emitter<BusinessAccountSetupState> emit) {
    state.directorCaptchaInputController.clear();
    state.aadharOtpController.clear();

    emit(
      state.copyWith(
        isDirectorCaptchaSend: false,
        isDirectorCaptchaLoading: false,
        directorCaptchaImage: '',
        isOtpSent: false,
        isDirectorAadharOtpLoading: false,
        isAadharOtpTimerRunning: false,
        aadharOtpRemainingTime: 0,
        isAadharOTPInvalidate: '',
      ),
    );
  }

  void _onOtherDirectorEnableAadharEdit(OtherDirectorEnableAadharEdit event, Emitter<BusinessAccountSetupState> emit) {
    state.otherDirectorCaptchaInputController.clear();
    state.otherDirectoraadharOtpController.clear();

    emit(
      state.copyWith(
        isOtherDirectorCaptchaSend: false,
        isOtherDirectorDirectorCaptchaLoading: false,
        otherDirectorCaptchaImage: '',
        isOtherDirectorOtpSent: false,
        isOtherDirectorAadharOtpTimerRunning: false,
        otherDirectorAadharOtpRemainingTime: 0,
        isOtherAadharOTPInvalidate: '',
      ),
    );
  }

  /// Load files asynchronously to avoid blocking the UI during data loading
  void _loadFilesAsynchronously(
    Map<String, dynamic> userData,
    String businessType,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    // Use a separate event to handle file loading to avoid emit after completion error
    add(LoadFilesFromApi(userData: userData, businessType: businessType));
    emit(state.copyWith(isLocalDataLoading: false));
  }

  /// Handle loading files from API asynchronously
  void _onLoadFilesFromApi(LoadFilesFromApi event, Emitter<BusinessAccountSetupState> emit) async {
    try {
      final panDetails = event.userData['pan_details'] ?? {};
      final kartaPanDetails = event.userData['karta_pan_details'] ?? {};
      final businessIdentity = event.userData['business_identity'] ?? {};
      final iecDetails = event.userData['iec_details'] ?? {};
      final address = event.userData['user_address_documents'] ?? {};
      final gst = event.userData['user_gst_details'] ?? {};
      final businessDirectorListRaw = event.userData['business_director_list'] as List? ?? [];
      final businessDirectorList =
          businessDirectorListRaw.map((director) => BusinessDirectorList.fromJson(director)).toList();

      // Get director information
      BusinessDirectorList? authDirectorPan;
      BusinessDirectorList? authDirectorAadhaar;
      BusinessDirectorList? otherDirectorPan;
      BusinessDirectorList? otherDirectorAadhaar;

      try {
        authDirectorPan = businessDirectorList.firstWhere(
          (director) => director.directorType == 'AUTH_DIRECTOR' && director.documentType == 'Pan',
        );
      } catch (e) {
        authDirectorPan = null;
      }

      try {
        authDirectorAadhaar = businessDirectorList.firstWhere(
          (director) => director.directorType == 'AUTH_DIRECTOR' && director.documentType == 'Aadhaar',
        );
      } catch (e) {
        authDirectorAadhaar = null;
      }

      try {
        otherDirectorPan = businessDirectorList.firstWhere(
          (director) => director.directorType == 'OTHER_DIRECTOR' && director.documentType == 'Pan',
        );
      } catch (e) {
        otherDirectorPan = null;
      }

      try {
        otherDirectorAadhaar = businessDirectorList.firstWhere(
          (director) => director.directorType == 'OTHER_DIRECTOR' && director.documentType == 'Aadhaar',
        );
      } catch (e) {
        otherDirectorAadhaar = null;
      }

      // Download PAN files
      if (panDetails['front_doc_url'] != null && panDetails['front_doc_url'].isNotEmpty) {
        final fileData = await getFileDataFromPath(panDetails['front_doc_url'], 'Pan');
        if (fileData != null) {
          if (event.businessType == 'hindu_undivided_family') {
            emit(state.copyWith(hufPanCardFile: fileData));
          } else if (event.businessType == 'limited_liability_partnership') {
            emit(state.copyWith(llpPanCardFile: fileData));
          } else if (event.businessType == 'partnership') {
            emit(state.copyWith(partnershipFirmPanCardFile: fileData));
          } else if (event.businessType == 'sole_proprietor') {
            emit(state.copyWith(soleProprietorShipPanCardFile: fileData));
          } else if (event.businessType == 'company') {
            emit(state.copyWith(companyPanCardFile: fileData));
          } else {
            emit(state.copyWith(businessPanCardFile: fileData));
          }
        }
      }

      // Download Karta PAN files
      if (kartaPanDetails['front_doc_url'] != null && kartaPanDetails['front_doc_url'].isNotEmpty) {
        final fileData = await getFileDataFromPath(kartaPanDetails['front_doc_url'], 'Pan');
        if (fileData != null) {
          emit(state.copyWith(kartaPanCardFile: fileData));
        }
      }

      // Download Director PAN files
      if (authDirectorPan?.frontDocUrl != null) {
        final fileData = await getFileDataFromPath(authDirectorPan!.frontDocUrl!, 'Pan');
        if (fileData != null) {
          emit(state.copyWith(director1PanCardFile: fileData));
        }
      }

      if (otherDirectorPan?.frontDocUrl != null) {
        final fileData = await getFileDataFromPath(otherDirectorPan!.frontDocUrl!, 'Pan');
        if (fileData != null) {
          emit(state.copyWith(director2PanCardFile: fileData));
        }
      }

      // Download Director Aadhaar files
      if (authDirectorAadhaar?.frontDocUrl != null) {
        final frontFileData = await getFileDataFromPath(authDirectorAadhaar!.frontDocUrl!, 'Aadhaar');
        if (frontFileData != null) {
          emit(state.copyWith(frontSideAdharFile: frontFileData));
        }
      }

      if (authDirectorAadhaar?.backDocUrl != null) {
        final backFileData = await getFileDataFromPath(authDirectorAadhaar!.backDocUrl!, 'Aadhaar');
        if (backFileData != null) {
          emit(state.copyWith(backSideAdharFile: backFileData));
        }
      }

      if (otherDirectorAadhaar?.frontDocUrl != null) {
        final frontFileData = await getFileDataFromPath(otherDirectorAadhaar!.frontDocUrl!, 'Aadhaar');
        if (frontFileData != null) {
          emit(state.copyWith(otherDirectorAadharfrontSideAdharFile: frontFileData));
        }
      }

      if (otherDirectorAadhaar?.backDocUrl != null) {
        final backFileData = await getFileDataFromPath(otherDirectorAadhaar!.backDocUrl!, 'Aadhaar');
        if (backFileData != null) {
          emit(state.copyWith(otherDirectorAadharBackSideAdharFile: backFileData));
        }
      }

      // Download GST Certificate
      if (gst != null && gst['gst_certificate_url'] != null && gst['gst_certificate_url'].isNotEmpty) {
        final fileData = await getFileDataFromPath(gst['gst_certificate_url'], 'GST');
        if (fileData != null) {
          emit(state.copyWith(gstCertificateFile: fileData));
        }
      }

      // Download Address document
      if (address != null && address['front_doc_url'] != null && address['front_doc_url'].isNotEmpty) {
        final fileData = await getFileDataFromPath(address['front_doc_url'], address['document_type'] ?? 'Address');
        if (fileData != null) {
          emit(state.copyWith(addressVerificationFile: fileData));
        }
      }

      // Download ICE Certificate
      if (iecDetails['doc_url'] != null && iecDetails['doc_url'].isNotEmpty) {
        final fileData = await getFileDataFromPath(iecDetails['doc_url'], "ICE");
        if (fileData != null) {
          emit(state.copyWith(iceCertificateFile: fileData));
        }
      }

      // Download Business Identity documents
      if (businessIdentity['front_doc_url'] != null && businessIdentity['front_doc_url'].isNotEmpty) {
        final fileData = await getFileDataFromPath(businessIdentity['front_doc_url'], "BusinessIdentity");
        if (fileData != null) {
          if (event.businessType == 'hindu_undivided_family' && businessIdentity['document_type'] == 'Aadhaar') {
            emit(state.copyWith(kartaFrontSideAdharFile: fileData));
          } else if (event.businessType == 'company' && businessIdentity['document_type'] == 'CIN') {
            emit(state.copyWith(coiCertificateFile: fileData));
          } else if (event.businessType == 'limited_liability_partnership' &&
              businessIdentity['document_type'] == 'LLPIN') {
            emit(state.copyWith(coiCertificateFile: fileData));
            // Force immediate rebuild for LLP files
            await Future.delayed(Duration.zero);
            emit(state.copyWith());
          } else {
            emit(state.copyWith(iceCertificateFile: fileData));
          }
        }
      }

      // Download Business Identity back documents
      if (businessIdentity['back_doc_url'] != null && businessIdentity['back_doc_url'].isNotEmpty) {
        final fileData = await getFileDataFromPath(businessIdentity['back_doc_url'], "BusinessIdentity");
        if (fileData != null) {
          if (event.businessType == 'hindu_undivided_family' && businessIdentity['document_type'] == 'Aadhaar') {
            emit(state.copyWith(kartaBackSideAdharFile: fileData));
          } else if (event.businessType == 'limited_liability_partnership' &&
              businessIdentity['document_type'] == 'LLPIN') {
            emit(state.copyWith(uploadLLPAgreementFile: fileData));
            // Force immediate rebuild for LLP Agreement file
            await Future.delayed(Duration.zero);
            emit(state.copyWith());
          }
        }
      }

      // Force a rebuild by emitting a state change
      emit(state.copyWith());
    } catch (e) {
      Logger.error('Error loading files from API: $e');
    }
  }

  // Data change tracking event handlers
  void _onMarkIdentityVerificationDataChanged(
    MarkIdentityVerificationDataChanged event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(isIdentityVerificationDataChanged: true));
  }

  void _onMarkPanDetailsDataChanged(MarkPanDetailsDataChanged event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(isPanDetailsDataChanged: true));
  }

  void _onMarkResidentialAddressDataChanged(
    MarkResidentialAddressDataChanged event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(isResidentialAddressDataChanged: true));
  }

  void _onMarkAnnualTurnoverDataChanged(MarkAnnualTurnoverDataChanged event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(isAnnualTurnoverDataChanged: true));
  }

  void _onMarkBankAccountDataChanged(MarkBankAccountDataChanged event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(isBankAccountDataChanged: true));
  }

  void _onMarkIceVerificationDataChanged(
    MarkIceVerificationDataChanged event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(isIceVerificationDataChanged: true));
  }

  void _onMarkBusinessDocumentsDataChanged(
    MarkBusinessDocumentsDataChanged event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(isBusinessDocumentsDataChanged: true));
  }

  void _onResetDataChangeFlags(ResetDataChangeFlags event, Emitter<BusinessAccountSetupState> emit) {
    emit(
      state.copyWith(
        isIdentityVerificationDataChanged: false,
        isPanDetailsDataChanged: false,
        isResidentialAddressDataChanged: false,
        isAnnualTurnoverDataChanged: false,
        isBankAccountDataChanged: false,
        isIceVerificationDataChanged: false,
        isBusinessDocumentsDataChanged: false,
        isProprietorAadharDataChanged: false,
        isSoleProprietorshipPanDataChanged: false,
        isPartnershipFirmPanDataChanged: false,
        isLLPPanDataChanged: false,
        isKartaPanDataChanged: false,
        isHUFPanDataChanged: false,
        isCompanyPanDataChanged: false,
        isCompanyIncorporationDataChanged: false,
        isContactInformationDataChanged: false,
        isBeneficialOwnershipDataChanged: false,
        isPanDetailViewDataChanged: false,
      ),
    );
  }

  // Screen-specific data change tracking event handlers
  void _onMarkProprietorAadharDataChanged(
    MarkProprietorAadharDataChanged event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(isProprietorAadharDataChanged: true));
  }

  void _onMarkSoleProprietorshipPanDataChanged(
    MarkSoleProprietorshipPanDataChanged event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(isSoleProprietorshipPanDataChanged: true));
  }

  void _onMarkPartnershipFirmPanDataChanged(
    MarkPartnershipFirmPanDataChanged event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(isPartnershipFirmPanDataChanged: true));
  }

  void _onMarkLLPPanDataChanged(MarkLLPPanDataChanged event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(isLLPPanDataChanged: true));
  }

  void _onMarkKartaPanDataChanged(MarkKartaPanDataChanged event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(isKartaPanDataChanged: true));
  }

  void _onMarkHUFPanDataChanged(MarkHUFPanDataChanged event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(isHUFPanDataChanged: true));
  }

  void _onMarkCompanyPanDataChanged(MarkCompanyPanDataChanged event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(isCompanyPanDataChanged: true));
  }

  void _onMarkCompanyIncorporationDataChanged(
    MarkCompanyIncorporationDataChanged event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(isCompanyIncorporationDataChanged: true));
  }

  void _onMarkContactInformationDataChanged(
    MarkContactInformationDataChanged event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(isContactInformationDataChanged: true));
  }

  void _onMarkBeneficialOwnershipDataChanged(
    MarkBeneficialOwnershipDataChanged event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(isBeneficialOwnershipDataChanged: true));
  }

  void _onMarkPanDetailViewDataChanged(MarkPanDetailViewDataChanged event, Emitter<BusinessAccountSetupState> emit) {
    emit(state.copyWith(isPanDetailViewDataChanged: true));
  }

  // Original value storage event handlers
  void _onBusinessStoreOriginalAadharNumber(
    BusinessStoreOriginalAadharNumber event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(originalBusinessAadharNumber: event.originalNumber));
  }

  void _onBusinessStoreOriginalPanNumber(
    BusinessStoreOriginalPanNumber event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(originalBusinessPanNumber: event.originalNumber));
  }

  void _onBusinessStoreOriginalGstNumber(
    BusinessStoreOriginalGstNumber event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(originalBusinessGstNumber: event.originalNumber, isGSTNumberVerify: false));
  }

  void _onBusinessStoreOriginalBankAccountNumber(
    BusinessStoreOriginalBankAccountNumber event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(originalBusinessBankAccountNumber: event.originalNumber));
  }

  void _onBusinessStoreOriginalDirector1PanNumber(
    BusinessStoreOriginalDirector1PanNumber event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(originalDirector1PanNumber: event.originalNumber));
  }

  void _onBusinessStoreOriginalDirector2PanNumber(
    BusinessStoreOriginalDirector2PanNumber event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(originalDirector2PanNumber: event.originalNumber));
  }

  void _onBusinessStoreOriginalDirector1AadharNumber(
    BusinessStoreOriginalDirector1AadharNumber event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(originalDirector1AadharNumber: event.originalNumber));
  }

  void _onBusinessStoreOriginalDirector2AadharNumber(
    BusinessStoreOriginalDirector2AadharNumber event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(originalDirector2AadharNumber: event.originalNumber));
  }

  void _onBusinessStoreOriginalProprietorAadharNumber(
    BusinessStoreOriginalProprietorAadharNumber event,
    Emitter<BusinessAccountSetupState> emit,
  ) {
    emit(state.copyWith(originalProprietorAadharNumber: event.originalNumber));
  }
}
