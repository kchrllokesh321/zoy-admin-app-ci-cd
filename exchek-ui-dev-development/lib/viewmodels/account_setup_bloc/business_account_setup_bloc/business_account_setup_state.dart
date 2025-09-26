part of 'business_account_setup_bloc.dart';

class BusinessAccountSetupState extends Equatable {
  final BusinessAccountSetupSteps currentStep;
  final String? selectedBusinessEntityType;
  final BusinessMainActivity? selectedBusinessMainActivity;
  final List<String>? selectedbusinessGoodsExportType;
  final List<String>? selectedbusinessServiceExportType;
  final TextEditingController goodsAndServiceExportDescriptionController;
  final TextEditingController goodsExportOtherController;
  final TextEditingController serviceExportOtherController;
  final TextEditingController businessActivityOtherController;
  final ScrollController scrollController;
  final Timer? scrollDebounceTimer;
  final GlobalKey<FormState> formKey;
  final TextEditingController businessLegalNameController;
  final TextEditingController dbaController;
  final TextEditingController professionalWebsiteUrl;
  final TextEditingController phoneController;
  final FocusNode? phoneFocusNode;
  final TextEditingController otpController;
  final int otpRemainingTime;
  final bool isOtpTimerRunning;
  final GlobalKey<FormState> sePasswordFormKey;
  final TextEditingController createPasswordController;
  final TextEditingController confirmPasswordController;
  final bool isCreatePasswordObscure;
  final bool isConfirmPasswordObscure;
  final bool? isSignupLoading;
  final bool? isSignupSuccess;
  final bool isBusinessInfoOtpSent;
  final KycVerificationSteps currentKycVerificationStep;
  final TextEditingController aadharNumberController;
  final TextEditingController aadharOtpController;
  final bool isOtpSent;
  final int aadharOtpRemainingTime;
  final bool isAadharOtpTimerRunning;
  final String? aadharNumber;
  final bool? isAadharVerifiedLoading;
  final bool? isAadharVerified;
  final GlobalKey<FormState> aadharVerificationFormKey;
  final FileData? frontSideAdharFile;
  final FileData? backSideAdharFile;
  final bool isAadharFileUploading;
  final TextEditingController kartaAadharNumberController;
  final TextEditingController kartaAadharOtpController;
  final bool isKartaOtpSent;
  final int kartaAadharOtpRemainingTime;
  final bool isKartaAadharOtpTimerRunning;
  final String? kartaAadharNumber;
  final bool? isKartaAadharVerifiedLoading;
  final bool? isKartaAadharVerified;
  final GlobalKey<FormState> kartaAadharVerificationFormKey;
  final FileData? kartaFrontSideAdharFile;
  final FileData? kartaBackSideAdharFile;
  final bool isKartaAadharFileUploading;
  final GlobalKey<FormState> hufPanVerificationKey;
  final TextEditingController hufPanNumberController;
  final FocusNode? hufPanNumberFocusNode;
  final FileData? hufPanCardFile;
  final bool? isHUFPanVerifyingLoading;
  final String? selectedUploadPanOption;
  final TextEditingController businessPanNumberController;
  final FocusNode? businessPanNumberFocusNode;
  final TextEditingController businessPanNameController;
  final FileData? businessPanCardFile;
  final bool? isBusinessPanCardSaveLoading;
  final bool? isBusinessPanCardSave;
  final GlobalKey<FormState> businessPanVerificationKey;
  final GlobalKey<FormState> directorsPanVerificationKey;
  final TextEditingController director1PanNumberController;
  final FocusNode? director1PanNumberFocusNode;
  final TextEditingController director1PanNameController;
  final bool director1BeneficialOwner;
  final bool ditector1BusinessRepresentative;
  final FileData? director1PanCardFile;
  final TextEditingController director2PanNumberController;
  final FocusNode? director2PanNumberFocusNode;
  final TextEditingController director2PanNameController;
  final FileData? director2PanCardFile;
  final bool director2BeneficialOwner;
  final bool ditector2BusinessRepresentative;
  final bool? isDirectorPanCardSaveLoading;
  final bool? isDirectorPanCardSave;
  final GlobalKey<FormState> beneficialOwnerPanVerificationKey;
  final TextEditingController beneficialOwnerPanNumberController;
  final FocusNode? beneficialOwnerPanNumberFocusNode;
  final TextEditingController beneficialOwnerPanNameController;
  final bool beneficialOwnerIsDirector;
  final bool benificialOwnerBusinessRepresentative;
  final FileData? beneficialOwnerPanCardFile;
  final bool? isBeneficialOwnerPanCardSaveLoading;
  final bool? isBeneficialOwnerPanCardSave;
  final GlobalKey<FormState> businessRepresentativeFormKey;
  final TextEditingController businessRepresentativePanNumberController;
  final TextEditingController businessRepresentativePanNameController;
  final bool businessRepresentativeIsDirector;
  final bool businessRepresentativeIsBenificalOwner;
  final FileData? businessRepresentativePanCardFile;
  final bool? isbusinessRepresentativePanCardSaveLoading;
  final bool? isbusinessRepresentativePanCardSave;
  final bool? isPanDetailVerifyLoading;
  final bool? isPanDetailVerifySuccess;
  final GlobalKey<FormState> registerAddressFormKey;
  final Country? selectedCountry;
  final TextEditingController pinCodeController;
  final TextEditingController stateNameController;
  final TextEditingController cityNameController;
  final TextEditingController address1NameController;
  final TextEditingController address2NameController;
  final FileData? addressVerificationFile;
  final String? selectedAddressVerificationDocType;
  final bool? isAddressVerificationLoading;
  final TextEditingController turnOverController;
  final TextEditingController gstNumberController;
  final FileData? gstCertificateFile;
  final bool? isGstVerificationLoading;
  final GlobalKey<FormState> annualTurnoverFormKey;
  final bool isGstCertificateMandatory;
  final GlobalKey<FormState> iceVerificationKey;
  final TextEditingController iceNumberController;
  final FileData? iceCertificateFile;
  final bool? isIceVerifyingLoading;
  final GlobalKey<FormState> cinVerificationKey;
  final TextEditingController cinNumberController;
  final FileData? coiCertificateFile;
  final bool? isCINVerifyingLoading;
  final TextEditingController llpinNumberController;
  final FileData? uploadLLPAgreementFile;
  final FileData? uploadPartnershipDeed;
  final bool isBankAccountVerify;
  final bool? isBankAccountNumberVerifiedLoading;
  final GlobalKey<FormState> bankAccountVerificationFormKey;
  final TextEditingController bankAccountNumberController;
  final TextEditingController reEnterbankAccountNumberController;
  final TextEditingController ifscCodeController;
  final String? accountHolderName;
  final FileData? bankVerificationFile;
  final String? selectedBankAccountVerificationDocType;
  final String? bankAccountNumber;
  final String? ifscCode;
  final bool? isBankAccountVerificationLoading;
  final String? selectedEstimatedMonthlyTransaction;
  final List<CurrencyModel>? curruncyList;
  final List<CurrencyModel>? selectedCurrencies;
  final bool? isTranscationDetailLoading;
  final bool isBusinessOtpValidating;
  final String? businessNatureString;
  final List<String>? estimatedMonthlyVolumeList;
  final String? selectedAnnualTurnover;
  final bool isCollapsed;
  final bool isekycCollapsed;
  final bool isDirectorCaptchaSend;
  final bool? isDirectorCaptchaLoading;
  final String? directorCaptchaImage;
  final TextEditingController directorCaptchaInputController;
  final bool isDirectorAadharOtpLoading;
  final String isAadharOTPInvalidate;
  final TextEditingController kartaCaptchaInputController;
  final String kartaCaptchaInput;
  final bool isKartaCaptchaValid;
  final bool isKartaCaptchaSubmitting;
  final String? kartaCaptchaError;
  final bool isKartaCaptchaSend;
  final bool? isKartaCaptchaLoading;
  final String? kartaCaptchaImage;
  final bool isKartaOtpLoading;
  final String? kartaIsAadharOTPInvalidate;
  final bool isSendOtpLoading;
  final bool isVerifyBusinessRegisterdInfo;
  final TextEditingController partnerAadharNumberController;
  final TextEditingController partnerAadharOtpController;
  final bool isPartnerOtpSent;
  final int partnerAadharOtpRemainingTime;
  final bool isPartnerAadharOtpTimerRunning;
  final String? partnerAadharNumber;
  final bool? isPartnerAadharVerifiedLoading;
  final bool? isPartnerAadharVerified;
  final GlobalKey<FormState> partnerAadharVerificationFormKey;
  final FileData? partnerFrontSideAdharFile;
  final FileData? partnerBackSideAdharFile;
  final bool isPartnerAadharFileUploading;
  final TextEditingController partnerCaptchaInputController;
  final String partnerCaptchaInput;
  final bool isPartnerCaptchaValid;
  final bool isPartnerCaptchaSubmitting;
  final String? partnerCaptchaError;
  final bool isPartnerCaptchaSend;
  final bool? isPartnerCaptchaLoading;
  final String? partnerCaptchaImage;
  final bool isPartnerOtpLoading;
  final String? partnerIsAadharOTPInvalidate;
  final TextEditingController proprietorAadharNumberController;
  final TextEditingController proprietorAadharOtpController;
  final bool isProprietorOtpSent;
  final int proprietorAadharOtpRemainingTime;
  final bool isProprietorAadharOtpTimerRunning;
  final String? proprietorAadharNumber;
  final bool? isProprietorAadharVerifiedLoading;
  final bool? isProprietorAadharVerified;
  final GlobalKey<FormState> proprietorAadharVerificationFormKey;
  final FileData? proprietorFrontSideAdharFile;
  final FileData? proprietorBackSideAdharFile;
  final bool isProprietorAadharFileUploading;
  final TextEditingController proprietorCaptchaInputController;
  final String proprietorCaptchaInput;
  final bool isProprietorCaptchaValid;
  final bool isProprietorCaptchaSubmitting;
  final String? proprietorCaptchaError;
  final bool isProprietorCaptchaSend;
  final bool? isProprietorCaptchaLoading;
  final String? proprietorCaptchaImage;
  final bool isProprietorOtpLoading;
  final String? proprietorIsAadharOTPInvalidate;
  final bool isLocalDataLoading;
  final bool isCityAndStateLoading;
  final bool isCityAndStateVerified;
  final String? gstLegalName;
  final bool isGSTNumberVerify;
  final bool isHUFPanDetailsLoading;
  final String? fullHUFNamePan;
  final bool isHUFPanDetailsVerified;
  final bool isDirector1PanDetailsLoading;
  final String? fullDirector1NamePan;
  final bool isDirector1PanDetailsVerified;
  final bool isDirector2PanDetailsLoading;
  final String? fullDirector2NamePan;
  final bool isDirector2PanDetailsVerified;
  final bool isBeneficialOwnerPanDetailsLoading;
  final String? fullBeneficialOwnerNamePan;
  final bool isBeneficialOwnerPanDetailsVerified;
  final bool isBusinessRepresentativePanDetailsLoading;
  final String? fullBusinessRepresentativeNamePan;
  final bool isBusinessRepresentativePanDetailsVerified;
  final TextEditingController directorMobileNumberController;
  final TextEditingController directorEmailIdNumberController;
  final GlobalKey<FormState> directorContactInformationKey;
  final bool isContactInfoSubmitLoading;
  final bool isAuthorizedDirectorKycVerify;
  final bool? isOtherDirectorPanCardSave;
  final bool isOtherDirectorKycVerify;
  final bool? isOtherDirectorPanCardSaveLoading;
  final GlobalKey<FormState> otherDirectorsPanVerificationKey;

  // Other Director Aadhar related properties
  final bool? isOtherAadharDirectorVerified;
  final GlobalKey<FormState> otherDirectorVerificationFormKey;
  final TextEditingController otherDirectorAadharNumberController;
  final TextEditingController otherDirectoraadharOtpController;
  final bool isOtherDirectorOtpSent;
  final bool isOtherDitectorOtpSent;
  final int otherDirectorAadharOtpRemainingTime;
  final bool isOtherDirectorAadharOtpTimerRunning;
  final String? otherDirectorAadharNumber;
  final bool? isOtherDirectorAadharVerifiedLoading;
  final bool? isOtherDirectorAadharVerified;
  final FileData? otherDirectorAadharfrontSideAdharFile;
  final FileData? otherDirectorAadharBackSideAdharFile;
  final bool isOtherDirectorAadharFileUploading;

  // Other Director Captcha related properties
  final bool isOtherDirectorCaptchaSend;
  final bool? isOtherDirectorDirectorCaptchaLoading;
  final String? otherDirectorCaptchaImage;
  final TextEditingController otherDirectorCaptchaInputController;
  final bool? isOtherDirectorAadharOtpLoading;
  final String isOtherAadharOTPInvalidate;
  final DirectorKycSteps directorKycStep;
  final OtherDirectorKycSteps otherDirectorKycStep;
  final bool showBusinessRepresentativeSelectionDialog;
  final String? selectedBusinessRepresentativeOption;
  final bool isBusinessRepresentativeConfirmLoading;
  final GlobalKey<FormState> companyPanVerificationKey;
  final TextEditingController companyPanNumberController;
  final FocusNode? companyPanNumberFocusNode;
  final FileData? companyPanCardFile;
  final bool isCompanyPanDetailsLoading;
  final bool isCompanyPanDetailsVerified;
  final String? fullCompanyNamePan;
  final bool isCompanyPanVerifyingLoading;
  final bool shouldNavigateBack;
  final bool? isAadharAddressSameAsResidentialAddress;

  final GlobalKey<FormState> llpPanVerificationKey;
  final TextEditingController llpPanNumberController;
  final FocusNode? llpPanNumberFocusNode;
  final FileData? llpPanCardFile;
  final bool? isLLPPanVerifyingLoading;
  final bool isLLPPanDetailsLoading;
  final String? fullLLPNamePan;
  final bool isLLPPanDetailsVerified;
  final GlobalKey<FormState> partnershipFirmPanVerificationKey;
  final TextEditingController partnershipFirmPanNumberController;
  final FocusNode? partnershipFirmPanNumberFocusNode;
  final FileData? partnershipFirmPanCardFile;
  final bool? isPartnershipFirmPanVerifyingLoading;
  final bool isPartnershipFirmPanDetailsLoading;
  final String? fullPartnershipFirmNamePan;
  final bool isPartnershipFirmPanDetailsVerified;
  final GlobalKey<FormState> soleProprietorShipPanVerificationKey;
  final TextEditingController soleProprietorShipPanNumberController;
  final FocusNode? soleProprietorShipPanNumberFocusNode;
  final FileData? soleProprietorShipPanCardFile;
  final bool? isSoleProprietorShipPanVerifyingLoading;
  final bool isSoleProprietorShipPanDetailsLoading;
  final String? fullSoleProprietorShipNamePan;
  final bool isSoleProprietorShipPanDetailsVerified;
  final GlobalKey<FormState> kartaPanVerificationKey;
  final TextEditingController kartaPanNumberController;
  final FocusNode? kartaPanNumberFocusNode;
  final FileData? kartaPanCardFile;
  final bool? isKartaPanVerifyingLoading;
  final bool isKartaPanDetailsLoading;
  final String? fullKartaNamePan;
  final bool isKartaPanDetailsVerified;
  final bool isCompanyPanCardFileDeleted;
  final bool isFrontSideAdharFileDeleted;
  final bool isBackSideAdharFileDeleted;
  final bool isKartaFrontSideAdharFileDeleted;
  final bool isKartaBackSideAdharFileDeleted;
  final bool isHUFPanCardFileDeleted;
  final bool isBusinessPanCardFileDeleted;
  final bool isDirector1PanCardFileDeleted;
  final bool isDirector2PanCardFileDeleted;
  final bool isBeneficialOwnerPanCardFileDeleted;
  final bool isBusinessRepresentativePanCardFileDeleted;
  final bool isAddressVerificationFileDeleted;
  final bool isGstCertificateFileDeleted;
  final bool isIceCertificateFileDeleted;
  final bool isCoiCertificateFileDeleted;
  final bool isUploadLLPAgreementFileDeleted;
  final bool isUploadPartnershipDeedDeleted;
  final bool isBankVerificationFileDeleted;
  final bool isPartnerFrontSideAdharFileDeleted;
  final bool isPartnerBackSideAdharFileDeleted;
  final bool isProprietorFrontSideAdharFileDeleted;
  final bool isProprietorBackSideAdharFileDeleted;
  final bool isOtherDirectorAadharfrontSideAdharFileDeleted;
  final bool isOtherDirectorAadharBackSideAdharFileDeleted;
  final bool isLLPPanCardFileDeleted;
  final bool isPartnershipFirmPanCardFileDeleted;
  final bool isSoleProprietorShipPanCardFileDeleted;
  final bool isKartaPanCardFileDeleted;

  final Country? authorizedSelectedCountry;
  final TextEditingController authorizedPinCodeController;
  final TextEditingController authorizedStateNameController;
  final TextEditingController authorizedCityNameController;
  final TextEditingController authorizedAddress1NameController;
  final TextEditingController authorizedAddress2NameController;
  final bool isAuthorizedCityAndStateLoading;

  final Country? otherDirectorSelectedCountry;
  final TextEditingController otherDirectorPinCodeController;
  final TextEditingController otherDirectorStateNameController;
  final TextEditingController otherDirectorCityNameController;
  final TextEditingController otherDirectorAddress1NameController;
  final TextEditingController otherDirectorAddress2NameController;
  final bool isOtherDirectorCityAndStateLoading;
  final bool? isOtherDirectorAadharAddressSameAsResidentialAddress;

  final Country? beneficialOwnerSelectedCountry;
  final TextEditingController beneficialOwnerPinCodeController;
  final TextEditingController beneficialOwnerStateNameController;
  final TextEditingController beneficialOwnerCityNameController;
  final TextEditingController beneficialOwnerAddress1NameController;
  final TextEditingController beneficialOwnerAddress2NameController;
  final bool isBeneficialOwnerCityAndStateLoading;
  final BeneficialOwnerKycSteps beneficialOwnerKycStep;

  final FileData? beneficialOwnershipDeclarationFile;
  final bool isBeneficialOwnershipDeclarationVerifyingLoading;
  final String? companyPanDetailsErrorMessage;
  final String? llpPanDetailsErrorMessage;
  final String? partnershipFirmPanDetailsErrorMessage;
  final String? soleProprietorShipPanDetailsErrorMessage;
  final String? kartaPanDetailsErrorMessage;
  final String? hufPanDetailsErrorMessage;
  final String? director1PanDetailsErrorMessage;
  final String? director2PanDetailsErrorMessage;
  final String? beneficialOwnerPanDetailsErrorMessage;
  final bool isBeneficialOwnershipDeclarationFileDeleted;
  final bool isGstNumberVerifyingLoading;
  final int llpPanEditAttempts;
  final bool isLLPPanEditLocked;
  final DateTime? llpPanEditLockTime;
  final bool isLLPPanModifiedAfterVerification;
  final bool isHUFPanModifiedAfterVerification;
  final bool isHUFPanEditLocked;
  final String? llpPanEditErrorMessage;
  final int hufPanEditAttempts;
  final DateTime? hufPanEditLockTime;
  final String? hufPanEditErrorMessage;
  final int partnershipFirmPanEditAttempts;
  final bool isPartnershipFirmPanEditLocked;
  final DateTime? partnershipFirmPanEditLockTime;
  final String? partnershipFirmPanEditErrorMessage;
  final bool isPartnershipFirmPanModifiedAfterVerification;
  final int soleProprietorShipPanEditAttempts;
  final bool isSoleProprietorShipPanEditLocked;
  final DateTime? soleProprietorShipPanEditLockTime;
  final String? soleProprietorShipPanEditErrorMessage;
  final bool isSoleProprietorShipPanModifiedAfterVerification;
  final int kartaPanEditAttempts;
  final bool isKartaPanEditLocked;
  final DateTime? kartaPanEditLockTime;
  final String? kartaPanEditErrorMessage;
  final bool isKartaPanModifiedAfterVerification;
  final int companyPanEditAttempts;
  final bool isCompanyPanEditLocked;
  final DateTime? companyPanEditLockTime;
  final String? companyPanEditErrorMessage;
  final bool isCompanyPanModifiedAfterVerification;
  final int beneficialOwnerPanEditAttempts;
  final bool isBeneficialOwnerPanEditLocked;
  final DateTime? beneficialOwnerPanEditLockTime;
  final String? beneficialOwnerPanEditErrorMessage;
  final bool isBeneficialOwnerPanModifiedAfterVerification;
  final int director1PanEditAttempts;
  final bool isDirector1PanEditLocked;
  final DateTime? director1PanEditLockTime;
  final String? director1PanEditErrorMessage;
  final bool isDirector1PanModifiedAfterVerification;
  final int director2PanEditAttempts;
  final bool isDirector2PanEditLocked;
  final DateTime? director2PanEditLockTime;
  final String? director2PanEditErrorMessage;
  final bool isDirector2PanModifiedAfterVerification;
  final String? directorPANValidationErrorMessage;
  final String? directorAadhaarValidationErrorMessage;
  final int isGSTINOrIECHasUploaded;
  final FileData? shopEstablishmentCertificateFile;
  final bool isShopEstablishmentCertificateFileDeleted;
  final FileData? udyamCertificateFile;
  final bool isUdyamCertificateFileDeleted;
  final FileData? taxProfessionalTaxRegistrationFile;
  final bool isTaxProfessionalTaxRegistrationFileDeleted;
  final FileData? utilityBillFile;
  final bool isUtilityBillFileDeleted;
  final bool isBusinessDocumentsVerificationLoading;
  final bool isDeleteDocumentLoading;
  final bool isDeleteDocumentSuccess;
  final FocusNode? directorAadharNumberFocusNode;
  final FocusNode? otherDirectorAadharNumberFocusNode;
  final FocusNode? proprietorAadharNumberFocusNode;

  // Data change tracking properties
  final bool isIdentityVerificationDataChanged;
  final bool isPanDetailsDataChanged;
  final bool isResidentialAddressDataChanged;
  final bool isAnnualTurnoverDataChanged;
  final bool isBankAccountDataChanged;
  final bool isIceVerificationDataChanged;
  final bool isBusinessDocumentsDataChanged;

  // Screen-specific data change tracking properties
  final bool isProprietorAadharDataChanged;
  final bool isSoleProprietorshipPanDataChanged;
  final bool isPartnershipFirmPanDataChanged;
  final bool isLLPPanDataChanged;
  final bool isKartaPanDataChanged;
  final bool isHUFPanDataChanged;
  final bool isCompanyPanDataChanged;
  final bool isCompanyIncorporationDataChanged;
  final bool isContactInformationDataChanged;
  final bool isBeneficialOwnershipDataChanged;
  final bool isPanDetailViewDataChanged;
  // Originals for skip-if-unchanged
  final String? originalBusinessGstNumber;
  final String? originalBusinessBankAccountNumber;
  final String? originalBusinessAadharNumber;
  final String? originalBusinessPanNumber;
  // Director and proprietor originals
  final String? originalDirector1PanNumber;
  final String? originalDirector2PanNumber;
  final String? originalDirector1AadharNumber;
  final String? originalDirector2AadharNumber;
  final String? originalProprietorAadharNumber;

  const BusinessAccountSetupState({
    required this.currentStep,
    this.selectedBusinessEntityType,
    this.selectedBusinessMainActivity,
    this.selectedbusinessGoodsExportType,
    this.selectedbusinessServiceExportType,
    required this.goodsAndServiceExportDescriptionController,
    required this.goodsExportOtherController,
    required this.serviceExportOtherController,
    required this.businessActivityOtherController,
    required this.scrollController,
    this.scrollDebounceTimer,
    required this.formKey,
    required this.businessLegalNameController,
    required this.dbaController,
    required this.professionalWebsiteUrl,
    required this.phoneController,
    this.phoneFocusNode,
    required this.otpController,
    this.otpRemainingTime = 0,
    this.isOtpTimerRunning = false,
    required this.sePasswordFormKey,
    required this.createPasswordController,
    required this.confirmPasswordController,
    this.isCreatePasswordObscure = true,
    this.isConfirmPasswordObscure = true,
    this.isSignupLoading = false,
    this.isSignupSuccess = false,
    this.isBusinessInfoOtpSent = false,
    this.isOtpSent = false,
    this.aadharOtpRemainingTime = 0,
    this.isAadharOtpTimerRunning = false,
    required this.currentKycVerificationStep,
    required this.aadharNumberController,
    required this.aadharOtpController,
    this.aadharNumber,
    this.isAadharVerifiedLoading = false,
    this.isAadharVerified = false,
    required this.aadharVerificationFormKey,
    this.frontSideAdharFile,
    this.backSideAdharFile,
    this.isAadharFileUploading = false,
    this.isKartaOtpSent = false,
    required this.kartaAadharNumberController,
    required this.kartaAadharOtpController,
    this.kartaAadharOtpRemainingTime = 0,
    this.isKartaAadharOtpTimerRunning = false,
    this.kartaAadharNumber,
    this.isKartaAadharVerifiedLoading = false,
    this.isKartaAadharVerified = false,
    required this.kartaAadharVerificationFormKey,
    this.kartaFrontSideAdharFile,
    this.kartaBackSideAdharFile,
    this.isKartaAadharFileUploading = false,
    required this.hufPanVerificationKey,
    required this.hufPanNumberController,
    this.hufPanNumberFocusNode,
    this.hufPanCardFile,
    required this.isHUFPanVerifyingLoading,
    this.selectedUploadPanOption,
    required this.businessPanNumberController,
    this.businessPanNumberFocusNode,
    required this.businessPanNameController,
    this.businessPanCardFile,
    this.isBusinessPanCardSaveLoading = false,
    this.isBusinessPanCardSave = false,
    required this.businessPanVerificationKey,
    required this.directorsPanVerificationKey,
    required this.director1PanNumberController,
    this.director1PanNumberFocusNode,
    required this.director1PanNameController,
    this.director1BeneficialOwner = false,
    this.ditector1BusinessRepresentative = false,
    this.director1PanCardFile,
    required this.director2PanNumberController,
    this.director2PanNumberFocusNode,
    required this.director2PanNameController,
    this.director2PanCardFile,
    this.director2BeneficialOwner = false,
    this.ditector2BusinessRepresentative = false,
    this.isDirectorPanCardSaveLoading,
    this.isDirectorPanCardSave,
    required this.beneficialOwnerPanVerificationKey,
    required this.beneficialOwnerPanNumberController,
    this.beneficialOwnerPanNumberFocusNode,
    required this.beneficialOwnerPanNameController,
    this.beneficialOwnerIsDirector = false,
    this.benificialOwnerBusinessRepresentative = false,
    this.beneficialOwnerPanCardFile,
    this.isBeneficialOwnerPanCardSaveLoading,
    this.isBeneficialOwnerPanCardSave,
    required this.businessRepresentativeFormKey,
    required this.businessRepresentativePanNumberController,
    required this.businessRepresentativePanNameController,
    this.businessRepresentativeIsDirector = false,
    this.businessRepresentativeIsBenificalOwner = false,
    this.businessRepresentativePanCardFile,
    this.isbusinessRepresentativePanCardSaveLoading,
    this.isbusinessRepresentativePanCardSave,
    this.isPanDetailVerifyLoading,
    this.isPanDetailVerifySuccess,
    required this.registerAddressFormKey,
    required this.selectedCountry,
    required this.pinCodeController,
    required this.stateNameController,
    required this.cityNameController,
    required this.address1NameController,
    required this.address2NameController,
    this.addressVerificationFile,
    this.selectedAddressVerificationDocType,
    this.isAddressVerificationLoading,
    required this.turnOverController,
    required this.gstNumberController,
    this.gstCertificateFile,
    this.isGstVerificationLoading,
    required this.annualTurnoverFormKey,
    required this.isGstCertificateMandatory,
    required this.iceVerificationKey,
    required this.iceNumberController,
    this.iceCertificateFile,
    this.isIceVerifyingLoading,
    required this.cinVerificationKey,
    required this.cinNumberController,
    this.coiCertificateFile,
    this.isCINVerifyingLoading,
    required this.llpinNumberController,
    this.uploadLLPAgreementFile,
    this.uploadPartnershipDeed,
    this.isBankAccountVerify = false,
    this.isBankAccountNumberVerifiedLoading,
    required this.bankAccountVerificationFormKey,
    required this.bankAccountNumberController,
    required this.reEnterbankAccountNumberController,
    required this.ifscCodeController,
    this.accountHolderName,
    this.bankVerificationFile,
    this.selectedBankAccountVerificationDocType,
    this.bankAccountNumber,
    this.ifscCode,
    this.isBankAccountVerificationLoading,
    this.selectedEstimatedMonthlyTransaction,
    this.curruncyList,
    this.selectedCurrencies,
    this.isTranscationDetailLoading,
    this.isBusinessOtpValidating = false,
    this.businessNatureString,
    this.estimatedMonthlyVolumeList,
    this.selectedAnnualTurnover,
    this.isCollapsed = false,
    this.isekycCollapsed = false,

    this.isDirectorCaptchaSend = false,
    this.isDirectorCaptchaLoading = false,
    this.directorCaptchaImage,
    required this.directorCaptchaInputController,
    this.isDirectorAadharOtpLoading = false,
    this.isAadharOTPInvalidate = '',
    required this.kartaCaptchaInputController,
    this.kartaCaptchaInput = '',
    this.isKartaCaptchaValid = false,
    this.isKartaCaptchaSubmitting = false,
    this.kartaCaptchaError,
    this.isKartaCaptchaSend = false,
    this.isKartaCaptchaLoading = false,
    this.kartaCaptchaImage,
    this.isKartaOtpLoading = false,
    this.kartaIsAadharOTPInvalidate,
    this.isSendOtpLoading = false,
    this.isVerifyBusinessRegisterdInfo = false,
    required this.partnerAadharNumberController,
    required this.partnerAadharOtpController,
    this.isPartnerOtpSent = false,
    this.partnerAadharOtpRemainingTime = 0,
    this.isPartnerAadharOtpTimerRunning = false,
    this.partnerAadharNumber,
    this.isPartnerAadharVerifiedLoading = false,
    this.isPartnerAadharVerified = false,
    required this.partnerAadharVerificationFormKey,
    this.partnerFrontSideAdharFile,
    this.partnerBackSideAdharFile,
    this.isPartnerAadharFileUploading = false,
    required this.partnerCaptchaInputController,
    this.partnerCaptchaInput = '',
    this.isPartnerCaptchaValid = false,
    this.isPartnerCaptchaSubmitting = false,
    this.partnerCaptchaError,
    this.isPartnerCaptchaSend = false,
    this.isPartnerCaptchaLoading = false,
    this.partnerCaptchaImage,
    this.isPartnerOtpLoading = false,
    this.partnerIsAadharOTPInvalidate,
    required this.proprietorAadharNumberController,
    required this.proprietorAadharOtpController,
    this.isProprietorOtpSent = false,
    this.proprietorAadharOtpRemainingTime = 0,
    this.isProprietorAadharOtpTimerRunning = false,
    this.proprietorAadharNumber,
    this.isProprietorAadharVerifiedLoading = false,
    this.isProprietorAadharVerified = false,
    required this.proprietorAadharVerificationFormKey,
    this.proprietorFrontSideAdharFile,
    this.proprietorBackSideAdharFile,
    this.isProprietorAadharFileUploading = false,
    required this.proprietorCaptchaInputController,
    this.proprietorCaptchaInput = '',
    this.isProprietorCaptchaValid = false,
    this.isProprietorCaptchaSubmitting = false,
    this.proprietorCaptchaError,
    this.isProprietorCaptchaSend = false,
    this.isProprietorCaptchaLoading = false,
    this.proprietorCaptchaImage,
    this.isProprietorOtpLoading = false,
    this.proprietorIsAadharOTPInvalidate,
    this.isLocalDataLoading = false,
    this.isCityAndStateLoading = false,
    this.isCityAndStateVerified = false,
    this.gstLegalName,
    this.isGSTNumberVerify = false,
    this.isHUFPanDetailsLoading = false,
    this.fullHUFNamePan,
    this.isHUFPanDetailsVerified = false,
    this.isDirector1PanDetailsLoading = false,
    this.fullDirector1NamePan,
    this.isDirector1PanDetailsVerified = false,
    this.isDirector2PanDetailsLoading = false,
    this.fullDirector2NamePan,
    this.isDirector2PanDetailsVerified = false,
    this.fullBeneficialOwnerNamePan,
    this.isBeneficialOwnerPanDetailsLoading = false,
    this.isBeneficialOwnerPanDetailsVerified = false,
    this.isBusinessRepresentativePanDetailsLoading = false,
    this.fullBusinessRepresentativeNamePan,
    this.isBusinessRepresentativePanDetailsVerified = false,
    required this.directorEmailIdNumberController,
    required this.directorMobileNumberController,
    required this.directorContactInformationKey,
    this.isContactInfoSubmitLoading = false,
    this.isAuthorizedDirectorKycVerify = false,
    this.isOtherDirectorPanCardSave = false,
    this.isOtherDirectorKycVerify = false,
    this.isOtherDirectorPanCardSaveLoading = false,
    required this.otherDirectorsPanVerificationKey,

    // Other Director Aadhar related properties
    this.isOtherAadharDirectorVerified = false,
    required this.otherDirectorVerificationFormKey,
    required this.otherDirectorAadharNumberController,
    required this.otherDirectoraadharOtpController,
    this.isOtherDirectorOtpSent = false,
    this.isOtherDitectorOtpSent = false,
    this.otherDirectorAadharOtpRemainingTime = 0,
    this.isOtherDirectorAadharOtpTimerRunning = false,
    this.otherDirectorAadharNumber,
    this.isOtherDirectorAadharVerifiedLoading = false,
    this.isOtherDirectorAadharVerified = false,
    this.otherDirectorAadharfrontSideAdharFile,
    this.otherDirectorAadharBackSideAdharFile,
    this.isOtherDirectorAadharFileUploading = false,

    // Other Director Captcha related properties
    this.isOtherDirectorCaptchaSend = false,
    this.isOtherDirectorDirectorCaptchaLoading = false,
    this.otherDirectorCaptchaImage,
    required this.otherDirectorCaptchaInputController,
    this.isOtherDirectorAadharOtpLoading = false,
    this.isOtherAadharOTPInvalidate = '',
    required this.directorKycStep,
    this.otherDirectorKycStep = OtherDirectorKycSteps.panDetails,
    this.showBusinessRepresentativeSelectionDialog = false,
    this.selectedBusinessRepresentativeOption,
    this.isBusinessRepresentativeConfirmLoading = false,
    required this.companyPanVerificationKey,
    required this.companyPanNumberController,
    this.companyPanNumberFocusNode,
    this.companyPanCardFile,
    this.isCompanyPanDetailsLoading = false,
    this.isCompanyPanDetailsVerified = false,
    this.fullCompanyNamePan,
    this.isCompanyPanVerifyingLoading = false,
    this.shouldNavigateBack = false,
    this.isAadharAddressSameAsResidentialAddress,
    required this.llpPanVerificationKey,
    required this.llpPanNumberController,
    this.llpPanNumberFocusNode,
    this.llpPanCardFile,
    required this.isLLPPanVerifyingLoading,
    this.isLLPPanDetailsLoading = false,
    this.fullLLPNamePan,
    this.isLLPPanDetailsVerified = false,
    required this.partnershipFirmPanVerificationKey,
    required this.partnershipFirmPanNumberController,
    this.partnershipFirmPanNumberFocusNode,
    this.partnershipFirmPanCardFile,
    required this.isPartnershipFirmPanVerifyingLoading,
    this.isPartnershipFirmPanDetailsLoading = false,
    this.fullPartnershipFirmNamePan,
    this.isPartnershipFirmPanDetailsVerified = false,
    required this.soleProprietorShipPanVerificationKey,
    required this.soleProprietorShipPanNumberController,
    this.soleProprietorShipPanNumberFocusNode,
    this.soleProprietorShipPanCardFile,
    required this.isSoleProprietorShipPanVerifyingLoading,
    this.isSoleProprietorShipPanDetailsLoading = false,
    this.fullSoleProprietorShipNamePan,
    this.isSoleProprietorShipPanDetailsVerified = false,
    required this.kartaPanVerificationKey,
    required this.kartaPanNumberController,
    this.kartaPanNumberFocusNode,
    this.kartaPanCardFile,
    required this.isKartaPanVerifyingLoading,
    this.isKartaPanDetailsLoading = false,
    this.fullKartaNamePan,
    this.isKartaPanDetailsVerified = false,
    this.isCompanyPanCardFileDeleted = false,
    this.isFrontSideAdharFileDeleted = false,
    this.isBackSideAdharFileDeleted = false,
    this.isKartaFrontSideAdharFileDeleted = false,
    this.isKartaBackSideAdharFileDeleted = false,
    this.isHUFPanCardFileDeleted = false,
    this.isBusinessPanCardFileDeleted = false,
    this.isDirector1PanCardFileDeleted = false,
    this.isDirector2PanCardFileDeleted = false,
    this.isBeneficialOwnerPanCardFileDeleted = false,
    this.isBusinessRepresentativePanCardFileDeleted = false,
    this.isAddressVerificationFileDeleted = false,
    this.isGstCertificateFileDeleted = false,
    this.isIceCertificateFileDeleted = false,
    this.isCoiCertificateFileDeleted = false,
    this.isUploadLLPAgreementFileDeleted = false,
    this.isUploadPartnershipDeedDeleted = false,
    this.isBankVerificationFileDeleted = false,
    this.isPartnerFrontSideAdharFileDeleted = false,
    this.isPartnerBackSideAdharFileDeleted = false,
    this.isProprietorFrontSideAdharFileDeleted = false,
    this.isProprietorBackSideAdharFileDeleted = false,
    this.isOtherDirectorAadharfrontSideAdharFileDeleted = false,
    this.isOtherDirectorAadharBackSideAdharFileDeleted = false,
    this.isLLPPanCardFileDeleted = false,
    this.isPartnershipFirmPanCardFileDeleted = false,
    this.isSoleProprietorShipPanCardFileDeleted = false,
    this.isKartaPanCardFileDeleted = false,
    this.authorizedSelectedCountry,
    required this.authorizedPinCodeController,
    required this.authorizedStateNameController,
    required this.authorizedCityNameController,
    required this.authorizedAddress1NameController,
    required this.authorizedAddress2NameController,
    this.isAuthorizedCityAndStateLoading = false,
    this.otherDirectorSelectedCountry,
    required this.otherDirectorPinCodeController,
    required this.otherDirectorStateNameController,
    required this.otherDirectorCityNameController,
    required this.otherDirectorAddress1NameController,
    required this.otherDirectorAddress2NameController,
    this.isOtherDirectorCityAndStateLoading = false,
    this.isOtherDirectorAadharAddressSameAsResidentialAddress,
    this.beneficialOwnerKycStep = BeneficialOwnerKycSteps.panDetails,
    this.beneficialOwnerSelectedCountry,
    required this.beneficialOwnerPinCodeController,
    required this.beneficialOwnerStateNameController,
    required this.beneficialOwnerCityNameController,
    required this.beneficialOwnerAddress1NameController,
    required this.beneficialOwnerAddress2NameController,
    this.isBeneficialOwnerCityAndStateLoading = false,
    this.beneficialOwnershipDeclarationFile,
    this.isBeneficialOwnershipDeclarationVerifyingLoading = false,
    this.companyPanDetailsErrorMessage,
    this.llpPanDetailsErrorMessage,
    this.partnershipFirmPanDetailsErrorMessage,
    this.soleProprietorShipPanDetailsErrorMessage,
    this.kartaPanDetailsErrorMessage,
    this.hufPanDetailsErrorMessage,
    this.director1PanDetailsErrorMessage,
    this.director2PanDetailsErrorMessage,
    this.beneficialOwnerPanDetailsErrorMessage,
    this.isBeneficialOwnershipDeclarationFileDeleted = false,
    this.isGstNumberVerifyingLoading = false,
    this.llpPanEditAttempts = 0,
    this.isLLPPanEditLocked = false,
    this.llpPanEditLockTime,
    this.isLLPPanModifiedAfterVerification = false,
    this.isHUFPanModifiedAfterVerification = false,
    this.isHUFPanEditLocked = false,
    this.llpPanEditErrorMessage,
    this.hufPanEditAttempts = 0,
    this.hufPanEditLockTime,
    this.hufPanEditErrorMessage,
    this.partnershipFirmPanEditAttempts = 0,
    this.isPartnershipFirmPanEditLocked = false,
    this.partnershipFirmPanEditLockTime,
    this.partnershipFirmPanEditErrorMessage,
    this.isPartnershipFirmPanModifiedAfterVerification = false,
    this.soleProprietorShipPanEditAttempts = 0,
    this.isSoleProprietorShipPanEditLocked = false,
    this.kartaPanEditAttempts = 0,
    this.isKartaPanEditLocked = false,
    this.kartaPanEditLockTime,
    this.kartaPanEditErrorMessage,
    this.isKartaPanModifiedAfterVerification = false,
    this.isCompanyPanModifiedAfterVerification = false,
    this.soleProprietorShipPanEditLockTime,
    this.soleProprietorShipPanEditErrorMessage,
    this.isSoleProprietorShipPanModifiedAfterVerification = false,
    this.companyPanEditAttempts = 0,
    this.isCompanyPanEditLocked = false,
    this.companyPanEditLockTime,
    this.companyPanEditErrorMessage,
    this.beneficialOwnerPanEditAttempts = 0,
    this.isBeneficialOwnerPanEditLocked = false,
    this.beneficialOwnerPanEditLockTime,
    this.beneficialOwnerPanEditErrorMessage,
    this.isBeneficialOwnerPanModifiedAfterVerification = false,
    this.director1PanEditAttempts = 0,
    this.isDirector1PanEditLocked = false,
    this.director1PanEditLockTime,
    this.director1PanEditErrorMessage,
    this.isDirector1PanModifiedAfterVerification = false,
    this.director2PanEditAttempts = 0,
    this.isDirector2PanEditLocked = false,
    this.director2PanEditLockTime,
    this.director2PanEditErrorMessage,
    this.isDirector2PanModifiedAfterVerification = false,
    this.directorPANValidationErrorMessage,
    this.directorAadhaarValidationErrorMessage,
    this.isGSTINOrIECHasUploaded = 0,
    this.shopEstablishmentCertificateFile,
    this.isShopEstablishmentCertificateFileDeleted = false,
    this.udyamCertificateFile,
    this.isUdyamCertificateFileDeleted = false,
    this.taxProfessionalTaxRegistrationFile,
    this.isTaxProfessionalTaxRegistrationFileDeleted = false,
    this.utilityBillFile,
    this.isUtilityBillFileDeleted = false,
    this.isBusinessDocumentsVerificationLoading = false,
    this.isDeleteDocumentLoading = false,
    this.isDeleteDocumentSuccess = false,
    this.otherDirectorAadharNumberFocusNode,
    this.proprietorAadharNumberFocusNode,
    this.directorAadharNumberFocusNode,

    // Data change tracking properties
    this.isIdentityVerificationDataChanged = false,
    this.isPanDetailsDataChanged = false,
    this.isResidentialAddressDataChanged = false,
    this.isAnnualTurnoverDataChanged = false,
    this.isBankAccountDataChanged = false,
    this.isIceVerificationDataChanged = false,
    this.isBusinessDocumentsDataChanged = false,

    // Screen-specific data change tracking properties
    this.isProprietorAadharDataChanged = false,
    this.isSoleProprietorshipPanDataChanged = false,
    this.isPartnershipFirmPanDataChanged = false,
    this.isLLPPanDataChanged = false,
    this.isKartaPanDataChanged = false,
    this.isHUFPanDataChanged = false,
    this.isCompanyPanDataChanged = false,
    this.isCompanyIncorporationDataChanged = false,
    this.isContactInformationDataChanged = false,
    this.isBeneficialOwnershipDataChanged = false,
    this.isPanDetailViewDataChanged = false,
    this.originalBusinessGstNumber,
    this.originalBusinessBankAccountNumber,
    this.originalBusinessAadharNumber,
    this.originalBusinessPanNumber,
    this.originalDirector1PanNumber,
    this.originalDirector2PanNumber,
    this.originalDirector1AadharNumber,
    this.originalDirector2AadharNumber,
    this.originalProprietorAadharNumber,
  });

  @override
  List<Object?> get props => [
    currentStep,
    selectedBusinessEntityType,
    selectedBusinessMainActivity,
    selectedbusinessGoodsExportType,
    selectedbusinessServiceExportType,
    goodsAndServiceExportDescriptionController,
    goodsExportOtherController,
    serviceExportOtherController,
    businessActivityOtherController,
    scrollController,
    scrollDebounceTimer,
    formKey,
    businessLegalNameController,
    dbaController,
    professionalWebsiteUrl,
    phoneController,
    phoneFocusNode,
    otpController,
    otpRemainingTime,
    isOtpTimerRunning,
    sePasswordFormKey,
    createPasswordController,
    confirmPasswordController,
    isCreatePasswordObscure,
    isConfirmPasswordObscure,
    isSignupLoading,
    isSignupSuccess,
    isBusinessInfoOtpSent,
    currentKycVerificationStep,
    aadharNumberController,
    aadharOtpController,
    aadharNumber,
    isAadharVerifiedLoading,
    isAadharVerified,
    aadharVerificationFormKey,
    frontSideAdharFile,
    backSideAdharFile,
    isAadharFileUploading,
    isKartaOtpSent,
    kartaAadharNumberController,
    kartaAadharOtpController,
    kartaAadharOtpRemainingTime,
    isKartaAadharOtpTimerRunning,
    kartaAadharNumber,
    isKartaAadharVerifiedLoading,
    isKartaAadharVerified,
    kartaAadharVerificationFormKey,
    kartaFrontSideAdharFile,
    kartaBackSideAdharFile,
    isKartaAadharFileUploading,
    hufPanVerificationKey,
    hufPanNumberController,
    hufPanCardFile,
    isHUFPanVerifyingLoading,
    selectedUploadPanOption,
    businessPanNumberController,
    businessPanNameController,
    businessPanCardFile,
    isBusinessPanCardSaveLoading,
    isBusinessPanCardSave,
    businessPanVerificationKey,
    directorsPanVerificationKey,
    director1PanNumberController,
    director1PanNameController,
    director1BeneficialOwner,
    ditector1BusinessRepresentative,
    director1PanCardFile,
    director2PanNumberController,
    director2PanNameController,
    director2PanCardFile,
    director2BeneficialOwner,
    ditector2BusinessRepresentative,
    isDirectorPanCardSaveLoading,
    isDirectorPanCardSave,
    beneficialOwnerPanVerificationKey,
    beneficialOwnerPanNumberController,
    beneficialOwnerPanNameController,
    beneficialOwnerIsDirector,
    benificialOwnerBusinessRepresentative,
    beneficialOwnerPanCardFile,
    isBeneficialOwnerPanCardSaveLoading,
    isBeneficialOwnerPanCardSave,
    businessRepresentativeFormKey,
    businessRepresentativePanNumberController,
    businessRepresentativePanNameController,
    businessRepresentativeIsDirector,
    businessRepresentativeIsBenificalOwner,
    businessRepresentativePanCardFile,
    isbusinessRepresentativePanCardSaveLoading,
    isbusinessRepresentativePanCardSave,
    isPanDetailVerifyLoading,
    isPanDetailVerifySuccess,
    registerAddressFormKey,
    selectedCountry,
    pinCodeController,
    stateNameController,
    cityNameController,
    address1NameController,
    address2NameController,
    addressVerificationFile,
    isAddressVerificationLoading,
    turnOverController,
    gstNumberController,
    gstCertificateFile,
    isGstVerificationLoading,
    annualTurnoverFormKey,
    isGstCertificateMandatory,
    iceNumberController,
    iceVerificationKey,
    isIceVerifyingLoading,
    iceCertificateFile,
    cinNumberController,
    cinVerificationKey,
    coiCertificateFile,
    isCINVerifyingLoading,
    llpinNumberController,
    uploadLLPAgreementFile,
    uploadPartnershipDeed,
    isBankAccountVerify,
    isBankAccountNumberVerifiedLoading,
    bankAccountVerificationFormKey,
    bankAccountNumberController,
    reEnterbankAccountNumberController,
    ifscCodeController,
    accountHolderName,
    bankVerificationFile,
    selectedBankAccountVerificationDocType,
    bankAccountNumber,
    ifscCode,
    isBankAccountVerificationLoading,
    selectedEstimatedMonthlyTransaction,
    curruncyList,
    selectedCurrencies,
    isTranscationDetailLoading,
    isBusinessOtpValidating,
    businessNatureString,
    estimatedMonthlyVolumeList,
    selectedAnnualTurnover,
    isCollapsed,
    isekycCollapsed,

    isDirectorCaptchaSend,
    isDirectorCaptchaLoading,
    directorCaptchaImage,
    directorCaptchaInputController,
    isDirectorAadharOtpLoading,
    isAadharOTPInvalidate,
    kartaCaptchaInputController,
    kartaCaptchaInput,
    isKartaCaptchaValid,
    isKartaCaptchaSubmitting,
    kartaCaptchaError,
    isKartaCaptchaSend,
    isKartaCaptchaLoading,
    kartaCaptchaImage,
    isKartaOtpLoading,
    kartaIsAadharOTPInvalidate,
    isSendOtpLoading,
    isVerifyBusinessRegisterdInfo,
    partnerAadharNumberController,
    partnerAadharOtpController,
    isPartnerOtpSent,
    partnerAadharOtpRemainingTime,
    isPartnerAadharOtpTimerRunning,
    partnerAadharNumber,
    isPartnerAadharVerifiedLoading,
    isPartnerAadharVerified,
    partnerAadharVerificationFormKey,
    partnerFrontSideAdharFile,
    partnerBackSideAdharFile,
    isPartnerAadharFileUploading,
    partnerCaptchaInputController,
    partnerCaptchaInput,
    isPartnerCaptchaValid,
    isPartnerCaptchaSubmitting,
    partnerCaptchaError,
    isPartnerCaptchaSend,
    isPartnerCaptchaLoading,
    partnerCaptchaImage,
    isPartnerOtpLoading,
    partnerIsAadharOTPInvalidate,
    proprietorAadharNumberController,
    proprietorAadharOtpController,
    isProprietorOtpSent,
    proprietorAadharOtpRemainingTime,
    isProprietorAadharOtpTimerRunning,
    proprietorAadharNumber,
    isProprietorAadharVerifiedLoading,
    isProprietorAadharVerified,
    proprietorAadharVerificationFormKey,
    proprietorFrontSideAdharFile,
    proprietorBackSideAdharFile,
    isProprietorAadharFileUploading,
    proprietorCaptchaInputController,
    proprietorCaptchaInput,
    isProprietorCaptchaValid,
    isProprietorCaptchaSubmitting,
    proprietorCaptchaError,
    isProprietorCaptchaSend,
    isProprietorCaptchaLoading,
    proprietorCaptchaImage,
    isProprietorOtpLoading,
    proprietorIsAadharOTPInvalidate,
    isLocalDataLoading,
    selectedAddressVerificationDocType,
    isCityAndStateLoading,
    isCityAndStateVerified,
    gstLegalName,
    isGSTNumberVerify,
    isHUFPanDetailsLoading,
    fullHUFNamePan,
    isHUFPanDetailsVerified,
    isDirector1PanDetailsLoading,
    fullDirector1NamePan,
    isDirector1PanDetailsVerified,
    isDirector2PanDetailsLoading,
    fullDirector2NamePan,
    isDirector2PanDetailsVerified,
    fullBeneficialOwnerNamePan,
    isBeneficialOwnerPanDetailsLoading,
    isBeneficialOwnerPanDetailsVerified,
    isBusinessRepresentativePanDetailsLoading,
    fullBusinessRepresentativeNamePan,
    isBusinessRepresentativePanDetailsVerified,
    directorEmailIdNumberController,
    directorMobileNumberController,
    directorContactInformationKey,
    isContactInfoSubmitLoading,
    isAuthorizedDirectorKycVerify,
    isOtherDirectorPanCardSave,
    isOtherDirectorKycVerify,
    isOtherDirectorPanCardSaveLoading,
    otherDirectorsPanVerificationKey,

    // Other Director Aadhar related properties
    isOtherAadharDirectorVerified,
    otherDirectorVerificationFormKey,
    otherDirectorAadharNumberController,
    otherDirectoraadharOtpController,
    isOtherDirectorOtpSent,
    isOtherDitectorOtpSent,
    otherDirectorAadharOtpRemainingTime,
    isOtherDirectorAadharOtpTimerRunning,
    otherDirectorAadharNumber,
    isOtherDirectorAadharVerifiedLoading,
    isOtherDirectorAadharVerified,
    otherDirectorAadharfrontSideAdharFile,
    otherDirectorAadharBackSideAdharFile,
    isOtherDirectorAadharFileUploading,

    // Other Director Captcha related properties
    isOtherDirectorCaptchaSend,
    isOtherDirectorDirectorCaptchaLoading,
    otherDirectorCaptchaImage,
    otherDirectorCaptchaInputController,
    isOtherDirectorAadharOtpLoading,
    isOtherAadharOTPInvalidate,
    directorKycStep,
    otherDirectorKycStep,
    showBusinessRepresentativeSelectionDialog,
    selectedBusinessRepresentativeOption,
    isBusinessRepresentativeConfirmLoading,
    companyPanVerificationKey,
    companyPanNumberController,
    companyPanCardFile,
    isCompanyPanDetailsLoading,
    isCompanyPanDetailsVerified,
    fullCompanyNamePan,
    isCompanyPanVerifyingLoading,
    shouldNavigateBack,
    isAadharAddressSameAsResidentialAddress,
    llpPanVerificationKey,
    llpPanNumberController,
    llpPanNumberFocusNode,
    llpPanCardFile,
    isLLPPanVerifyingLoading,
    isLLPPanDetailsLoading,
    fullLLPNamePan,
    isLLPPanDetailsVerified,
    partnershipFirmPanVerificationKey,
    partnershipFirmPanNumberController,
    partnershipFirmPanNumberFocusNode,
    partnershipFirmPanCardFile,
    isPartnershipFirmPanVerifyingLoading,
    isPartnershipFirmPanDetailsLoading,
    fullPartnershipFirmNamePan,
    isPartnershipFirmPanDetailsVerified,
    soleProprietorShipPanVerificationKey,
    soleProprietorShipPanNumberController,
    soleProprietorShipPanNumberFocusNode,
    soleProprietorShipPanCardFile,
    isSoleProprietorShipPanVerifyingLoading,
    isSoleProprietorShipPanDetailsLoading,
    fullSoleProprietorShipNamePan,
    isSoleProprietorShipPanDetailsVerified,
    kartaPanVerificationKey,
    kartaPanNumberController,
    kartaPanCardFile,
    isKartaPanVerifyingLoading,
    isKartaPanDetailsLoading,
    fullKartaNamePan,
    isKartaPanDetailsVerified,
    aadharOtpRemainingTime,
    isCompanyPanCardFileDeleted,
    isFrontSideAdharFileDeleted,
    isBackSideAdharFileDeleted,
    isKartaFrontSideAdharFileDeleted,
    isKartaBackSideAdharFileDeleted,
    isHUFPanCardFileDeleted,
    isBusinessPanCardFileDeleted,
    isDirector1PanCardFileDeleted,
    isDirector2PanCardFileDeleted,
    isBeneficialOwnerPanCardFileDeleted,
    isBusinessRepresentativePanCardFileDeleted,
    isAddressVerificationFileDeleted,
    isGstCertificateFileDeleted,
    isIceCertificateFileDeleted,
    isCoiCertificateFileDeleted,
    isUploadLLPAgreementFileDeleted,
    isUploadPartnershipDeedDeleted,
    isBankVerificationFileDeleted,
    isPartnerFrontSideAdharFileDeleted,
    isPartnerBackSideAdharFileDeleted,
    isProprietorFrontSideAdharFileDeleted,
    isProprietorBackSideAdharFileDeleted,
    isOtherDirectorAadharfrontSideAdharFileDeleted,
    isOtherDirectorAadharBackSideAdharFileDeleted,
    isLLPPanCardFileDeleted,
    isPartnershipFirmPanCardFileDeleted,
    isSoleProprietorShipPanCardFileDeleted,
    isKartaPanCardFileDeleted,
    authorizedSelectedCountry,
    authorizedPinCodeController,
    authorizedStateNameController,
    authorizedCityNameController,
    authorizedAddress1NameController,
    authorizedAddress2NameController,
    isAuthorizedCityAndStateLoading,
    otherDirectorSelectedCountry,
    otherDirectorPinCodeController,
    otherDirectorStateNameController,
    otherDirectorCityNameController,
    otherDirectorAddress1NameController,
    otherDirectorAddress2NameController,
    isOtherDirectorCityAndStateLoading,
    isOtherDirectorAadharAddressSameAsResidentialAddress,
    beneficialOwnerKycStep,
    beneficialOwnerSelectedCountry,
    beneficialOwnerPinCodeController,
    beneficialOwnerStateNameController,
    beneficialOwnerCityNameController,
    beneficialOwnerAddress1NameController,
    beneficialOwnerAddress2NameController,
    isBeneficialOwnerCityAndStateLoading,
    beneficialOwnershipDeclarationFile,
    isBeneficialOwnershipDeclarationVerifyingLoading,
    companyPanDetailsErrorMessage,
    llpPanDetailsErrorMessage,
    partnershipFirmPanDetailsErrorMessage,
    soleProprietorShipPanDetailsErrorMessage,
    kartaPanDetailsErrorMessage,
    hufPanDetailsErrorMessage,
    director1PanDetailsErrorMessage,
    director2PanDetailsErrorMessage,
    beneficialOwnerPanDetailsErrorMessage,
    isGstNumberVerifyingLoading,
    llpPanEditAttempts,
    isLLPPanEditLocked,
    llpPanEditLockTime,
    isLLPPanModifiedAfterVerification,
    isHUFPanModifiedAfterVerification,
    isHUFPanEditLocked,
    llpPanEditErrorMessage,
    hufPanEditAttempts,
    hufPanEditLockTime,
    hufPanEditErrorMessage,
    partnershipFirmPanEditAttempts,
    isPartnershipFirmPanEditLocked,
    partnershipFirmPanEditLockTime,
    partnershipFirmPanEditErrorMessage,
    soleProprietorShipPanEditAttempts,
    isSoleProprietorShipPanEditLocked,
    soleProprietorShipPanEditLockTime,
    soleProprietorShipPanEditErrorMessage,
    companyPanEditAttempts,
    isCompanyPanEditLocked,
    companyPanEditLockTime,
    companyPanEditErrorMessage,
    isCompanyPanModifiedAfterVerification,
    isSoleProprietorShipPanModifiedAfterVerification,
    beneficialOwnerPanEditAttempts,
    isBeneficialOwnerPanEditLocked,
    beneficialOwnerPanEditLockTime,
    beneficialOwnerPanEditErrorMessage,
    isBeneficialOwnerPanModifiedAfterVerification,
    director1PanEditAttempts,
    isDirector1PanEditLocked,
    director1PanEditLockTime,
    director1PanEditErrorMessage,
    isDirector1PanModifiedAfterVerification,
    director2PanEditAttempts,
    isDirector2PanEditLocked,
    director2PanEditLockTime,
    director2PanEditErrorMessage,
    isDirector2PanModifiedAfterVerification,
    isGSTINOrIECHasUploaded,
    shopEstablishmentCertificateFile,
    isShopEstablishmentCertificateFileDeleted,
    udyamCertificateFile,
    isUdyamCertificateFileDeleted,
    taxProfessionalTaxRegistrationFile,
    isTaxProfessionalTaxRegistrationFileDeleted,
    utilityBillFile,
    isUtilityBillFileDeleted,
    isBusinessDocumentsVerificationLoading,
    isPartnershipFirmPanModifiedAfterVerification,
    kartaPanEditAttempts,
    isKartaPanEditLocked,
    kartaPanEditLockTime,
    kartaPanEditErrorMessage,
    isKartaPanModifiedAfterVerification,
    isDeleteDocumentLoading,
    isDeleteDocumentSuccess,
    directorAadharNumberFocusNode,
    kartaPanNumberFocusNode,
    soleProprietorShipPanNumberFocusNode,
    partnershipFirmPanNumberFocusNode,
    llpPanNumberFocusNode,
    companyPanNumberFocusNode,
    proprietorAadharNumberFocusNode,
    otherDirectorAadharNumberFocusNode,
    directorPANValidationErrorMessage,
    directorAadhaarValidationErrorMessage,

    // Data change tracking properties
    isIdentityVerificationDataChanged,
    isPanDetailsDataChanged,
    isResidentialAddressDataChanged,
    isAnnualTurnoverDataChanged,
    isBankAccountDataChanged,
    isIceVerificationDataChanged,
    isBusinessDocumentsDataChanged,

    // Screen-specific data change tracking properties
    isProprietorAadharDataChanged,
    isSoleProprietorshipPanDataChanged,
    isPartnershipFirmPanDataChanged,
    isLLPPanDataChanged,
    isKartaPanDataChanged,
    isHUFPanDataChanged,
    isCompanyPanDataChanged,
    isCompanyIncorporationDataChanged,
    isContactInformationDataChanged,
    isBeneficialOwnershipDataChanged,
    isPanDetailViewDataChanged,
    originalBusinessGstNumber,
    originalBusinessBankAccountNumber,
    originalBusinessAadharNumber,
    originalBusinessPanNumber,
    originalDirector1PanNumber,
    originalDirector2PanNumber,
    originalDirector1AadharNumber,
    originalDirector2AadharNumber,
    originalProprietorAadharNumber,
  ];

  BusinessAccountSetupState copyWith({
    BusinessAccountSetupSteps? currentStep,
    List<String>? businessEntityList,
    String? selectedBusinessEntityType,
    BusinessMainActivity? selectedBusinessMainActivity,
    List<String>? selectedbusinessGoodsExportType,
    List<String>? selectedbusinessServiceExportType,
    TextEditingController? goodsAndServiceExportDescriptionController,
    TextEditingController? goodsExportOtherController,
    TextEditingController? serviceExportOtherController,
    TextEditingController? businessActivityOtherController,
    ScrollController? scrollController,
    Timer? scrollDebounceTimer,
    GlobalKey<FormState>? formKey,
    TextEditingController? businessLegalNameController,
    TextEditingController? professionalWebsiteUrl,
    TextEditingController? phoneController,
    FocusNode? phoneFocusNode,
    TextEditingController? otpController,
    int? otpRemainingTime,
    bool? isOtpTimerRunning,
    GlobalKey<FormState>? sePasswordFormKey,
    TextEditingController? createPasswordController,
    TextEditingController? confirmPasswordController,
    bool? isCreatePasswordObscure,
    bool? isConfirmPasswordObscure,
    bool? isSignupLoading,
    bool? isSignupSuccess,
    bool? isBusinessInfoOtpSent,
    bool? isOtpSent,
    int? aadharOtpRemainingTime,
    bool? isAadharOtpTimerRunning,
    KycVerificationSteps? currentKycVerificationStep,
    TextEditingController? aadharNumberController,
    TextEditingController? aadharOtpController,
    String? aadharNumber,
    bool? isAadharVerifiedLoading,
    bool? isAadharVerified,
    GlobalKey<FormState>? aadharVerificationFormKey,
    FileData? frontSideAdharFile,
    FileData? backSideAdharFile,
    bool? isAadharFileUploading,
    TextEditingController? kartaAadharNumberController,
    TextEditingController? kartaAadharOtpController,
    bool? isKartaOtpSent,
    int? kartaAadharOtpRemainingTime,
    bool? isKartaAadharOtpTimerRunning,
    String? kartaAadharNumber,
    bool? isKartaAadharVerifiedLoading,
    bool? isKartaAadharVerified,
    GlobalKey<FormState>? kartaAadharVerificationFormKey,
    FileData? kartaFrontSideAdharFile,
    FileData? kartaBackSideAdharFile,
    bool? isKartaAadharFileUploading,
    GlobalKey<FormState>? hufPanVerificationKey,
    TextEditingController? hufPanNumberController,
    FocusNode? hufPanNumberFocusNode,
    FileData? hufPanCardFile,
    bool? isHUFPanVerifyingLoading,
    String? selectedUploadPanOption,
    TextEditingController? businessPanNumberController,
    FocusNode? businessPanNumberFocusNode,
    TextEditingController? businessPanNameController,
    FileData? businessPanCardFile,
    bool? isBusinessPanCardSaveLoading,
    bool? isBusinessPanCardSave,
    GlobalKey<FormState>? businessPanVerificationKey,
    GlobalKey<FormState>? directorsPanVerificationKey,
    TextEditingController? director1PanNumberController,
    FocusNode? director1PanNumberFocusNode,
    TextEditingController? director1PanNameController,
    bool? director1BeneficialOwner,
    bool? ditector1BusinessRepresentative,
    FileData? director1PanCardFile,
    TextEditingController? director2PanNumberController,
    FocusNode? director2PanNumberFocusNode,
    TextEditingController? director2PanNameController,
    FileData? director2PanCardFile,
    bool? director2BeneficialOwner,
    bool? ditector2BusinessRepresentative,
    bool? isDirectorPanCardSaveLoading,
    bool? isDirectorPanCardSave,
    GlobalKey<FormState>? beneficialOwnerPanVerificationKey,
    TextEditingController? beneficialOwnerPanNumberController,
    FocusNode? beneficialOwnerPanNumberFocusNode,
    TextEditingController? beneficialOwnerPanNameController,
    bool? beneficialOwnerIsDirector,
    bool? benificialOwnerBusinessRepresentative,
    FileData? beneficialOwnerPanCardFile,
    bool? isBeneficialOwnerPanCardSaveLoading,
    bool? isBeneficialOwnerPanCardSave,
    GlobalKey<FormState>? businessRepresentativeFormKey,
    TextEditingController? businessRepresentativePanNumberController,
    TextEditingController? businessRepresentativePanNameController,
    bool? businessRepresentativeIsDirector,
    bool? businessRepresentativeIsBenificalOwner,
    FileData? businessRepresentativePanCardFile,
    bool? isbusinessRepresentativePanCardSaveLoading,
    bool? isbusinessRepresentativePanCardSave,
    bool? isPanDetailVerifyLoading,
    bool? isPanDetailVerifySuccess,
    GlobalKey<FormState>? registerAddressFormKey,
    Country? selectedCountry,
    TextEditingController? pinCodeController,
    TextEditingController? stateNameController,
    TextEditingController? cityNameController,
    TextEditingController? address1NameController,
    TextEditingController? address2NameController,
    FileData? addressVerificationFile,
    String? selectedAddressVerificationDocType,
    bool? isAddressVerificationLoading,
    TextEditingController? turnOverController,
    TextEditingController? gstNumberController,
    FileData? gstCertificateFile,
    bool? isGstVerificationLoading,
    GlobalKey<FormState>? annualTurnoverFormKey,
    bool? isGstCertificateMandatory,
    GlobalKey<FormState>? iceVerificationKey,
    TextEditingController? iceNumberController,
    FileData? iceCertificateFile,
    bool? isIceVerifyingLoading,
    GlobalKey<FormState>? cinVerificationKey,
    TextEditingController? cinNumberController,
    FileData? coiCertificateFile,
    bool? isCINVerifyingLoading,
    TextEditingController? llpinNumberController,
    FileData? uploadLLPAgreementFile,
    FileData? uploadPartnershipDeed,
    bool? isBankAccountVerify,
    bool? isBankAccountNumberVerifiedLoading,
    GlobalKey<FormState>? bankAccountVerificationFormKey,
    TextEditingController? bankAccountNumberController,
    TextEditingController? ifscCodeController,
    String? accountHolderName,
    FileData? bankVerificationFile,
    String? selectedBankAccountVerificationDocType,
    TextEditingController? reEnterbankAccountNumberController,
    String? bankAccountNumber,
    String? ifscCode,
    bool? isBankAccountVerificationLoading,
    String? selectedEstimatedMonthlyTransaction,
    List<CurrencyModel>? curruncyList,
    List<CurrencyModel>? selectedCurrencies,
    bool? isTranscationDetailLoading,
    bool? isBusinessOtpValidating,
    String? businessNatureString,
    List<String>? estimatedMonthlyVolumeList,
    String? selectedAnnualTurnover,
    bool? isCollapsed,
    bool? isekycCollapsed,

    bool? isDirectorCaptchaSend,
    bool? isDirectorCaptchaLoading,
    String? directorCaptchaImage,
    TextEditingController? directorCaptchaInputController,
    bool? isDirectorAadharOtpLoading,
    String? isAadharOTPInvalidate,
    TextEditingController? kartaCaptchaInputController,
    String? kartaCaptchaInput,
    bool? isKartaCaptchaValid,
    bool? isKartaCaptchaSubmitting,
    String? kartaCaptchaError,
    bool? isKartaCaptchaSend,
    bool? isKartaCaptchaLoading,
    String? kartaCaptchaImage,
    bool? isKartaOtpLoading,
    String? kartaIsAadharOTPInvalidate,
    bool? isSendOtpLoading,
    bool? isVerifyBusinessRegisterdInfo,
    TextEditingController? partnerAadharNumberController,
    TextEditingController? partnerAadharOtpController,
    bool? isPartnerOtpSent,
    int? partnerAadharOtpRemainingTime,
    bool? isPartnerAadharOtpTimerRunning,
    String? partnerAadharNumber,
    bool? isPartnerAadharVerifiedLoading,
    bool? isPartnerAadharVerified,
    GlobalKey<FormState>? partnerAadharVerificationFormKey,
    FileData? partnerFrontSideAdharFile,
    FileData? partnerBackSideAdharFile,
    bool? isPartnerAadharFileUploading,
    TextEditingController? partnerCaptchaInputController,
    String? partnerCaptchaInput,
    bool? isPartnerCaptchaValid,
    bool? isPartnerCaptchaSubmitting,
    String? partnerCaptchaError,
    bool? isPartnerCaptchaSend,
    bool? isPartnerCaptchaLoading,
    String? partnerCaptchaImage,
    bool? isPartnerOtpLoading,
    String? partnerIsAadharOTPInvalidate,
    TextEditingController? proprietorAadharNumberController,
    TextEditingController? proprietorAadharOtpController,
    bool? isProprietorOtpSent,
    int? proprietorAadharOtpRemainingTime,
    bool? isProprietorAadharOtpTimerRunning,
    String? proprietorAadharNumber,
    bool? isProprietorAadharVerifiedLoading,
    bool? isProprietorAadharVerified,
    GlobalKey<FormState>? proprietorAadharVerificationFormKey,
    FileData? proprietorFrontSideAdharFile,
    FileData? proprietorBackSideAdharFile,
    bool? isProprietorAadharFileUploading,
    TextEditingController? proprietorCaptchaInputController,
    String? proprietorCaptchaInput,
    bool? isProprietorCaptchaValid,
    bool? isProprietorCaptchaSubmitting,
    String? proprietorCaptchaError,
    bool? isProprietorCaptchaSend,
    bool? isProprietorCaptchaLoading,
    String? proprietorCaptchaImage,
    bool? isProprietorOtpLoading,
    String? proprietorIsAadharOTPInvalidate,
    bool? isLocalDataLoading,
    bool? isCityAndStateLoading,
    bool? isCityAndStateVerified,
    String? gstLegalName,
    bool? isGSTNumberVerify,
    bool? isHUFPanDetailsLoading,
    String? fullHUFNamePan,
    bool? isHUFPanDetailsVerified,
    bool? isDirector1PanDetailsLoading,
    String? fullDirector1NamePan,
    bool? isDirector1PanDetailsVerified,
    bool? isDirector2PanDetailsLoading,
    String? fullDirector2NamePan,
    bool? isDirector2PanDetailsVerified,
    bool? isBeneficialOwnerPanDetailsLoading,
    String? fullBeneficialOwnerNamePan,
    bool? isBeneficialOwnerPanDetailsVerified,
    bool? isBusinessRepresentativePanDetailsLoading,
    String? fullBusinessRepresentativeNamePan,
    bool? isBusinessRepresentativePanDetailsVerified,
    TextEditingController? directorMobileNumberController,
    TextEditingController? directorEmailIdNumberController,
    GlobalKey<FormState>? directorContactInformationKey,
    bool? isContactInfoSubmitLoading,
    bool? isAuthorizedDirectorKycVerify,
    bool? isOtherDirectorPanCardSave,
    bool? isOtherDirectorKycVerify,
    final bool? isOtherDirectorPanCardSaveLoading,
    GlobalKey<FormState>? otherDirectorsPanVerificationKey,

    // Other Director Aadhar related properties
    bool? isOtherAadharDirectorVerified,
    GlobalKey<FormState>? otherDirectorVerificationFormKey,
    TextEditingController? otherDirectorAadharNumberController,
    TextEditingController? otherDirectoraadharOtpController,
    bool? isOtherDirectorOtpSent,
    bool? isOtherDitectorOtpSent,
    int? otherDirectorAadharOtpRemainingTime,
    bool? isOtherDirectorAadharOtpTimerRunning,
    String? otherDirectorAadharNumber,
    bool? isOtherDirectorAadharVerifiedLoading,
    bool? isOtherDirectorAadharVerified,
    FileData? otherDirectorAadharfrontSideAdharFile,
    FileData? otherDirectorAadharBackSideAdharFile,
    bool? isOtherDirectorAadharFileUploading,

    // Other Director Captcha related properties
    bool? isOtherDirectorCaptchaSend,
    bool? isOtherDirectorDirectorCaptchaLoading,
    String? otherDirectorCaptchaImage,
    TextEditingController? otherDirectorCaptchaInputController,
    bool? isOtherDirectorAadharOtpLoading,
    String? isOtherAadharOTPInvalidate,
    DirectorKycSteps? directorKycStep,
    OtherDirectorKycSteps? otherDirectorKycStep,
    bool? showBusinessRepresentativeSelectionDialog,
    String? selectedBusinessRepresentativeOption,
    bool? isBusinessRepresentativeConfirmLoading,
    GlobalKey<FormState>? companyPanVerificationKey,
    TextEditingController? companyPanNumberController,
    FocusNode? companyPanNumberFocusNode,
    FileData? companyPanCardFile,
    bool? isCompanyPanDetailsLoading,
    bool? isCompanyPanDetailsVerified,
    String? fullCompanyNamePan,
    bool? isCompanyPanVerifyingLoading,
    bool? shouldNavigateBack,
    GlobalKey<FormState>? llpPanVerificationKey,
    TextEditingController? llpPanNumberController,
    FocusNode? llpPanNumberFocusNode,
    FileData? llpPanCardFile,
    bool? isLLPPanVerifyingLoading,
    bool? isLLPPanDetailsLoading,
    String? fullLLPNamePan,
    bool? isLLPPanDetailsVerified,
    GlobalKey<FormState>? partnershipFirmPanVerificationKey,
    TextEditingController? partnershipFirmPanNumberController,
    FocusNode? partnershipFirmPanNumberFocusNode,
    FileData? partnershipFirmPanCardFile,
    bool? isPartnershipFirmPanVerifyingLoading,
    bool? isPartnershipFirmPanDetailsLoading,
    String? fullPartnershipFirmNamePan,
    bool? isPartnershipFirmPanDetailsVerified,
    GlobalKey<FormState>? soleProprietorShipPanVerificationKey,
    TextEditingController? soleProprietorShipPanNumberController,
    FocusNode? soleProprietorShipPanNumberFocusNode,
    FileData? soleProprietorShipPanCardFile,
    bool? isSoleProprietorShipPanVerifyingLoading,
    bool? isSoleProprietorShipPanDetailsLoading,
    String? fullSoleProprietorShipNamePan,
    bool? isSoleProprietorShipPanDetailsVerified,
    GlobalKey<FormState>? kartaPanVerificationKey,
    TextEditingController? kartaPanNumberController,
    FocusNode? kartaPanNumberFocusNode,
    FileData? kartaPanCardFile,
    bool? isKartaPanVerifyingLoading,
    bool? isKartaPanDetailsLoading,
    String? fullKartaNamePan,
    bool? isKartaPanDetailsVerified,
    bool? isCompanyPanCardFileDeleted,
    bool? isFrontSideAdharFileDeleted,
    bool? isBackSideAdharFileDeleted,
    bool? isKartaFrontSideAdharFileDeleted,
    bool? isKartaBackSideAdharFileDeleted,
    bool? isHUFPanCardFileDeleted,
    bool? isBusinessPanCardFileDeleted,
    bool? isDirector1PanCardFileDeleted,
    bool? isDirector2PanCardFileDeleted,
    bool? isBeneficialOwnerPanCardFileDeleted,
    bool? isBusinessRepresentativePanCardFileDeleted,
    bool? isAddressVerificationFileDeleted,
    bool? isGstCertificateFileDeleted,
    bool? isIceCertificateFileDeleted,
    bool? isCoiCertificateFileDeleted,
    bool? isUploadLLPAgreementFileDeleted,
    bool? isUploadPartnershipDeedDeleted,
    bool? isBankVerificationFileDeleted,
    bool? isPartnerFrontSideAdharFileDeleted,
    bool? isPartnerBackSideAdharFileDeleted,
    bool? isProprietorFrontSideAdharFileDeleted,
    bool? isProprietorBackSideAdharFileDeleted,
    bool? isOtherDirectorAadharfrontSideAdharFileDeleted,
    bool? isOtherDirectorAadharBackSideAdharFileDeleted,
    bool? isLLPPanCardFileDeleted,
    bool? isPartnershipFirmPanCardFileDeleted,
    bool? isSoleProprietorShipPanCardFileDeleted,
    bool? isKartaPanCardFileDeleted,
    bool? isAadharAddressSameAsResidentialAddress,
    Country? authorizedSelectedCountry,
    TextEditingController? authorizedPinCodeController,
    TextEditingController? authorizedStateNameController,
    TextEditingController? authorizedCityNameController,
    TextEditingController? authorizedAddress1NameController,
    TextEditingController? authorizedAddress2NameController,
    bool? isAuthorizedCityAndStateLoading,
    Country? otherDirectorSelectedCountry,
    TextEditingController? otherDirectorPinCodeController,
    TextEditingController? otherDirectorStateNameController,
    TextEditingController? otherDirectorCityNameController,
    TextEditingController? otherDirectorAddress1NameController,
    TextEditingController? otherDirectorAddress2NameController,
    bool? isOtherDirectorCityAndStateLoading,
    bool? isOtherDirectorAadharAddressSameAsResidentialAddress,
    BeneficialOwnerKycSteps? beneficialOwnerKycStep,
    Country? beneficialOwnerSelectedCountry,
    TextEditingController? beneficialOwnerPinCodeController,
    TextEditingController? beneficialOwnerStateNameController,
    TextEditingController? beneficialOwnerCityNameController,
    TextEditingController? beneficialOwnerAddress1NameController,
    TextEditingController? beneficialOwnerAddress2NameController,
    bool? isBeneficialOwnerCityAndStateLoading,
    FileData? beneficialOwnershipDeclarationFile,
    bool? isBeneficialOwnershipDeclarationVerifyingLoading,
    String? companyPanDetailsErrorMessage,
    String? llpPanDetailsErrorMessage,
    String? partnershipFirmPanDetailsErrorMessage,
    String? soleProprietorShipPanDetailsErrorMessage,
    String? kartaPanDetailsErrorMessage,
    String? hufPanDetailsErrorMessage,
    String? director1PanDetailsErrorMessage,
    String? director2PanDetailsErrorMessage,
    String? beneficialOwnerPanDetailsErrorMessage,
    bool? isBeneficialOwnershipDeclarationFileDeleted,
    bool? isGstNumberVerifyingLoading,
    int? llpPanEditAttempts,
    bool? isLLPPanEditLocked,
    DateTime? llpPanEditLockTime,
    bool? isLLPPanModifiedAfterVerification,
    bool? isHUFPanModifiedAfterVerification,
    bool? isHUFPanEditLocked,
    String? llpPanEditErrorMessage,
    int? hufPanEditAttempts,
    DateTime? hufPanEditLockTime,
    String? hufPanEditErrorMessage,
    int? partnershipFirmPanEditAttempts,
    bool? isPartnershipFirmPanEditLocked,
    DateTime? partnershipFirmPanEditLockTime,
    String? partnershipFirmPanEditErrorMessage,
    bool? isPartnershipFirmPanModifiedAfterVerification,
    int? soleProprietorShipPanEditAttempts,
    bool? isSoleProprietorShipPanEditLocked,
    DateTime? soleProprietorShipPanEditLockTime,
    String? soleProprietorShipPanEditErrorMessage,
    bool? isSoleProprietorShipPanModifiedAfterVerification,
    int? kartaPanEditAttempts,
    bool? isKartaPanEditLocked,
    DateTime? kartaPanEditLockTime,
    String? kartaPanEditErrorMessage,
    bool? isKartaPanModifiedAfterVerification,
    int? companyPanEditAttempts,
    bool? isCompanyPanEditLocked,
    DateTime? companyPanEditLockTime,
    String? companyPanEditErrorMessage,
    bool? isCompanyPanModifiedAfterVerification,
    int? beneficialOwnerPanEditAttempts,
    bool? isBeneficialOwnerPanEditLocked,
    DateTime? beneficialOwnerPanEditLockTime,
    String? beneficialOwnerPanEditErrorMessage,
    bool? isBeneficialOwnerPanModifiedAfterVerification,
    int? director1PanEditAttempts,
    bool? isDirector1PanEditLocked,
    DateTime? director1PanEditLockTime,
    String? director1PanEditErrorMessage,
    bool? isDirector1PanModifiedAfterVerification,
    int? director2PanEditAttempts,
    bool? isDirector2PanEditLocked,
    DateTime? director2PanEditLockTime,
    String? director2PanEditErrorMessage,
    String? directorPANValidationErrorMessage,
    String? directorAadhaarValidationErrorMessage,
    bool? isDirector2PanModifiedAfterVerification,
    int? isGSTINOrIECHasUploaded,
    FileData? shopEstablishmentCertificateFile,
    bool? isShopEstablishmentCertificateFileDeleted,
    FileData? udyamCertificateFile,
    bool? isUdyamCertificateFileDeleted,
    FileData? taxProfessionalTaxRegistrationFile,
    bool? isTaxProfessionalTaxRegistrationFileDeleted,
    FileData? utilityBillFile,
    bool? isUtilityBillFileDeleted,
    bool? isBusinessDocumentsVerificationLoading,
    bool? isDeleteDocumentLoading,
    bool? isDeleteDocumentSuccess,
    FocusNode? directorAadharNumberFocusNode,
    FocusNode? otherDirectorAadharNumberFocusNode,
    FocusNode? proprietorAadharNumberFocusNode,

    // Data change tracking properties
    bool? isIdentityVerificationDataChanged,
    bool? isPanDetailsDataChanged,
    bool? isResidentialAddressDataChanged,
    bool? isAnnualTurnoverDataChanged,
    bool? isBankAccountDataChanged,
    bool? isIceVerificationDataChanged,
    bool? isBusinessDocumentsDataChanged,

    // Screen-specific data change tracking properties
    bool? isProprietorAadharDataChanged,
    bool? isSoleProprietorshipPanDataChanged,
    bool? isPartnershipFirmPanDataChanged,
    bool? isLLPPanDataChanged,
    bool? isKartaPanDataChanged,
    bool? isHUFPanDataChanged,
    bool? isCompanyPanDataChanged,
    bool? isCompanyIncorporationDataChanged,
    bool? isContactInformationDataChanged,
    bool? isBeneficialOwnershipDataChanged,
    bool? isPanDetailViewDataChanged,
    String? originalBusinessGstNumber,
    String? originalBusinessBankAccountNumber,
    String? originalBusinessAadharNumber,
    String? originalBusinessPanNumber,
    String? originalDirector1PanNumber,
    String? originalDirector2PanNumber,
    String? originalDirector1AadharNumber,
    String? originalDirector2AadharNumber,
    String? originalProprietorAadharNumber,
    TextEditingController? dbaController,
  }) {
    return BusinessAccountSetupState(
      currentStep: currentStep ?? this.currentStep,
      selectedBusinessEntityType: selectedBusinessEntityType ?? this.selectedBusinessEntityType,
      selectedBusinessMainActivity: selectedBusinessMainActivity ?? this.selectedBusinessMainActivity,
      selectedbusinessGoodsExportType: selectedbusinessGoodsExportType ?? this.selectedbusinessGoodsExportType,
      selectedbusinessServiceExportType: selectedbusinessServiceExportType ?? this.selectedbusinessServiceExportType,
      goodsAndServiceExportDescriptionController:
          goodsAndServiceExportDescriptionController ?? this.goodsAndServiceExportDescriptionController,
      goodsExportOtherController: goodsExportOtherController ?? this.goodsExportOtherController,
      serviceExportOtherController: serviceExportOtherController ?? this.serviceExportOtherController,
      businessActivityOtherController: businessActivityOtherController ?? this.businessActivityOtherController,
      scrollController: scrollController ?? this.scrollController,
      scrollDebounceTimer: scrollDebounceTimer ?? this.scrollDebounceTimer,
      formKey: formKey ?? this.formKey,
      businessLegalNameController: businessLegalNameController ?? this.businessLegalNameController,
      professionalWebsiteUrl: professionalWebsiteUrl ?? this.professionalWebsiteUrl,
      phoneController: phoneController ?? this.phoneController,
      phoneFocusNode: phoneFocusNode ?? this.phoneFocusNode,
      otpController: otpController ?? this.otpController,
      otpRemainingTime: otpRemainingTime ?? this.otpRemainingTime,
      isOtpTimerRunning: isOtpTimerRunning ?? this.isOtpTimerRunning,
      sePasswordFormKey: sePasswordFormKey ?? this.sePasswordFormKey,
      createPasswordController: createPasswordController ?? this.createPasswordController,
      confirmPasswordController: confirmPasswordController ?? this.confirmPasswordController,
      isCreatePasswordObscure: isCreatePasswordObscure ?? this.isCreatePasswordObscure,
      isConfirmPasswordObscure: isConfirmPasswordObscure ?? this.isConfirmPasswordObscure,
      isSignupLoading: isSignupLoading ?? this.isSignupLoading,
      isSignupSuccess: isSignupSuccess ?? this.isSignupSuccess,
      isBusinessInfoOtpSent: isBusinessInfoOtpSent ?? this.isBusinessInfoOtpSent,
      isOtpSent: isOtpSent ?? this.isOtpSent,
      aadharOtpRemainingTime: aadharOtpRemainingTime ?? this.aadharOtpRemainingTime,
      isAadharOtpTimerRunning: isAadharOtpTimerRunning ?? this.isAadharOtpTimerRunning,
      currentKycVerificationStep: currentKycVerificationStep ?? this.currentKycVerificationStep,
      aadharNumberController: aadharNumberController ?? this.aadharNumberController,
      aadharOtpController: aadharOtpController ?? this.aadharOtpController,
      aadharNumber: aadharNumber ?? this.aadharNumber,
      isAadharVerifiedLoading: isAadharVerifiedLoading ?? this.isAadharVerifiedLoading,
      isAadharVerified: isAadharVerified ?? this.isAadharVerified,
      aadharVerificationFormKey: aadharVerificationFormKey ?? this.aadharVerificationFormKey,
      frontSideAdharFile:
          (isFrontSideAdharFileDeleted == true)
              ? (frontSideAdharFile)
              : (frontSideAdharFile ?? this.frontSideAdharFile),
      backSideAdharFile:
          (isBackSideAdharFileDeleted == true) ? (backSideAdharFile) : (backSideAdharFile ?? this.backSideAdharFile),
      isAadharFileUploading: isAadharFileUploading ?? this.isAadharFileUploading,
      kartaAadharNumberController: kartaAadharNumberController ?? this.kartaAadharNumberController,
      kartaAadharOtpController: kartaAadharOtpController ?? this.kartaAadharOtpController,
      isKartaOtpSent: isKartaOtpSent ?? this.isKartaOtpSent,
      kartaAadharOtpRemainingTime: kartaAadharOtpRemainingTime ?? this.kartaAadharOtpRemainingTime,
      isKartaAadharOtpTimerRunning: isKartaAadharOtpTimerRunning ?? this.isKartaAadharOtpTimerRunning,
      kartaAadharNumber: kartaAadharNumber ?? this.kartaAadharNumber,
      isKartaAadharVerifiedLoading: isKartaAadharVerifiedLoading ?? this.isKartaAadharVerifiedLoading,
      isKartaAadharVerified: isKartaAadharVerified ?? this.isKartaAadharVerified,
      kartaAadharVerificationFormKey: kartaAadharVerificationFormKey ?? this.kartaAadharVerificationFormKey,
      kartaFrontSideAdharFile:
          (isKartaFrontSideAdharFileDeleted == true)
              ? (kartaFrontSideAdharFile)
              : (kartaFrontSideAdharFile ?? this.kartaFrontSideAdharFile),
      kartaBackSideAdharFile:
          (isKartaBackSideAdharFileDeleted == true)
              ? (kartaBackSideAdharFile)
              : (kartaBackSideAdharFile ?? this.kartaBackSideAdharFile),
      isKartaAadharFileUploading: isKartaAadharFileUploading ?? this.isKartaAadharFileUploading,
      hufPanVerificationKey: hufPanVerificationKey ?? this.hufPanVerificationKey,
      hufPanNumberController: hufPanNumberController ?? this.hufPanNumberController,
      hufPanNumberFocusNode: hufPanNumberFocusNode ?? this.hufPanNumberFocusNode,
      hufPanCardFile: (isHUFPanCardFileDeleted == true) ? (hufPanCardFile) : (hufPanCardFile ?? this.hufPanCardFile),
      isHUFPanVerifyingLoading: isHUFPanVerifyingLoading ?? this.isHUFPanVerifyingLoading,
      selectedUploadPanOption: selectedUploadPanOption ?? this.selectedUploadPanOption,
      businessPanNumberController: businessPanNumberController ?? this.businessPanNumberController,
      businessPanNumberFocusNode: businessPanNumberFocusNode ?? this.businessPanNumberFocusNode,
      businessPanNameController: businessPanNameController ?? this.businessPanNameController,
      businessPanCardFile:
          (isBusinessPanCardFileDeleted == true)
              ? (businessPanCardFile)
              : (businessPanCardFile ?? this.businessPanCardFile),
      isBusinessPanCardSaveLoading: isBusinessPanCardSaveLoading ?? this.isBusinessPanCardSaveLoading,
      isBusinessPanCardSave: isBusinessPanCardSave ?? this.isBusinessPanCardSave,
      businessPanVerificationKey: businessPanVerificationKey ?? this.businessPanVerificationKey,
      director1PanNameController: director1PanNameController ?? this.director1PanNameController,
      director1PanNumberController: director1PanNumberController ?? this.director1PanNumberController,
      director1PanNumberFocusNode: director1PanNumberFocusNode ?? this.director1PanNumberFocusNode,
      director2BeneficialOwner: director2BeneficialOwner ?? this.director2BeneficialOwner,
      director2PanNameController: director2PanNameController ?? this.director2PanNameController,
      director2PanNumberController: director2PanNumberController ?? this.director2PanNumberController,
      director2PanNumberFocusNode: director2PanNumberFocusNode ?? this.director2PanNumberFocusNode,
      director1PanCardFile:
          (isDirector1PanCardFileDeleted == true)
              ? (director1PanCardFile)
              : (director1PanCardFile ?? this.director1PanCardFile),
      director2PanCardFile:
          (isDirector2PanCardFileDeleted == true)
              ? (director2PanCardFile)
              : (director2PanCardFile ?? this.director2PanCardFile),
      directorsPanVerificationKey: directorsPanVerificationKey ?? this.directorsPanVerificationKey,
      ditector2BusinessRepresentative: ditector2BusinessRepresentative ?? this.ditector2BusinessRepresentative,
      director1BeneficialOwner: director1BeneficialOwner ?? this.director1BeneficialOwner,
      ditector1BusinessRepresentative: ditector1BusinessRepresentative ?? this.ditector1BusinessRepresentative,
      isDirectorPanCardSave: isDirectorPanCardSave ?? this.isDirectorPanCardSave,
      isDirectorPanCardSaveLoading: isDirectorPanCardSaveLoading ?? this.isDirectorPanCardSaveLoading,
      beneficialOwnerPanNameController: beneficialOwnerPanNameController ?? this.beneficialOwnerPanNameController,
      beneficialOwnerPanNumberController: beneficialOwnerPanNumberController ?? this.beneficialOwnerPanNumberController,
      beneficialOwnerPanNumberFocusNode: beneficialOwnerPanNumberFocusNode ?? this.beneficialOwnerPanNumberFocusNode,
      beneficialOwnerPanCardFile:
          (isBeneficialOwnerPanCardFileDeleted == true)
              ? (beneficialOwnerPanCardFile)
              : (beneficialOwnerPanCardFile ?? this.beneficialOwnerPanCardFile),
      isBeneficialOwnerPanCardSave: isBeneficialOwnerPanCardSave ?? this.isBeneficialOwnerPanCardSave,
      isBeneficialOwnerPanCardSaveLoading:
          isBeneficialOwnerPanCardSaveLoading ?? this.isBeneficialOwnerPanCardSaveLoading,
      beneficialOwnerPanVerificationKey: beneficialOwnerPanVerificationKey ?? this.beneficialOwnerPanVerificationKey,
      beneficialOwnerIsDirector: beneficialOwnerIsDirector ?? this.beneficialOwnerIsDirector,
      benificialOwnerBusinessRepresentative:
          benificialOwnerBusinessRepresentative ?? this.benificialOwnerBusinessRepresentative,
      businessRepresentativeFormKey: businessRepresentativeFormKey ?? this.businessRepresentativeFormKey,
      businessRepresentativePanNameController:
          businessRepresentativePanNameController ?? this.businessRepresentativePanNameController,
      businessRepresentativePanNumberController:
          businessRepresentativePanNumberController ?? this.businessRepresentativePanNumberController,
      businessRepresentativeIsBenificalOwner:
          businessRepresentativeIsBenificalOwner ?? this.businessRepresentativeIsBenificalOwner,
      businessRepresentativeIsDirector: businessRepresentativeIsDirector ?? this.businessRepresentativeIsDirector,
      businessRepresentativePanCardFile:
          (isBusinessRepresentativePanCardFileDeleted == true)
              ? (businessRepresentativePanCardFile)
              : (businessRepresentativePanCardFile ?? this.businessRepresentativePanCardFile),
      isbusinessRepresentativePanCardSave:
          isbusinessRepresentativePanCardSave ?? this.isbusinessRepresentativePanCardSave,
      isbusinessRepresentativePanCardSaveLoading:
          isbusinessRepresentativePanCardSaveLoading ?? this.isbusinessRepresentativePanCardSaveLoading,
      isPanDetailVerifyLoading: isPanDetailVerifyLoading ?? this.isPanDetailVerifyLoading,
      isPanDetailVerifySuccess: isPanDetailVerifySuccess ?? this.isPanDetailVerifySuccess,
      registerAddressFormKey: registerAddressFormKey ?? this.registerAddressFormKey,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      address1NameController: address1NameController ?? this.address1NameController,
      address2NameController: address2NameController ?? this.address2NameController,
      cityNameController: cityNameController ?? this.cityNameController,
      pinCodeController: pinCodeController ?? this.pinCodeController,
      stateNameController: stateNameController ?? this.stateNameController,
      addressVerificationFile:
          (isAddressVerificationFileDeleted == true)
              ? (addressVerificationFile)
              : (addressVerificationFile ?? this.addressVerificationFile),
      selectedAddressVerificationDocType: selectedAddressVerificationDocType ?? this.selectedAddressVerificationDocType,
      isAddressVerificationLoading: isAddressVerificationLoading ?? this.isAddressVerificationLoading,
      gstNumberController: gstNumberController ?? this.gstNumberController,
      turnOverController: turnOverController ?? this.turnOverController,
      gstCertificateFile:
          (isGstCertificateFileDeleted == true)
              ? (gstCertificateFile)
              : (gstCertificateFile ?? this.gstCertificateFile),
      isGstVerificationLoading: isGstVerificationLoading ?? this.isGstVerificationLoading,
      annualTurnoverFormKey: annualTurnoverFormKey ?? this.annualTurnoverFormKey,
      isGstCertificateMandatory: isGstCertificateMandatory ?? this.isGstCertificateMandatory,
      iceNumberController: iceNumberController ?? this.iceNumberController,
      iceVerificationKey: iceVerificationKey ?? this.iceVerificationKey,
      isIceVerifyingLoading: isIceVerifyingLoading ?? this.isIceVerifyingLoading,
      iceCertificateFile:
          (isIceCertificateFileDeleted == true)
              ? (iceCertificateFile)
              : (iceCertificateFile ?? this.iceCertificateFile),
      cinNumberController: cinNumberController ?? this.cinNumberController,
      cinVerificationKey: cinVerificationKey ?? this.cinVerificationKey,
      coiCertificateFile:
          (isCoiCertificateFileDeleted == true)
              ? (coiCertificateFile)
              : (coiCertificateFile ?? this.coiCertificateFile),
      isCINVerifyingLoading: isCINVerifyingLoading ?? this.isCINVerifyingLoading,
      llpinNumberController: llpinNumberController ?? this.llpinNumberController,
      uploadLLPAgreementFile:
          (isUploadLLPAgreementFileDeleted == true)
              ? (uploadLLPAgreementFile)
              : (uploadLLPAgreementFile ?? this.uploadLLPAgreementFile),
      uploadPartnershipDeed:
          (isUploadPartnershipDeedDeleted == true)
              ? (uploadPartnershipDeed)
              : (uploadPartnershipDeed ?? this.uploadPartnershipDeed),
      isBankAccountVerify: isBankAccountVerify ?? this.isBankAccountVerify,
      isBankAccountNumberVerifiedLoading: isBankAccountNumberVerifiedLoading ?? this.isBankAccountNumberVerifiedLoading,
      bankAccountNumberController: bankAccountNumberController ?? this.bankAccountNumberController,
      bankAccountVerificationFormKey: bankAccountVerificationFormKey ?? this.bankAccountVerificationFormKey,
      ifscCodeController: ifscCodeController ?? this.ifscCodeController,
      reEnterbankAccountNumberController: reEnterbankAccountNumberController ?? this.reEnterbankAccountNumberController,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      bankVerificationFile:
          (isBankVerificationFileDeleted == true)
              ? (bankVerificationFile)
              : (bankVerificationFile ?? this.bankVerificationFile),
      selectedBankAccountVerificationDocType:
          selectedBankAccountVerificationDocType ?? this.selectedBankAccountVerificationDocType,
      bankAccountNumber: bankAccountNumber ?? this.bankAccountNumber,
      ifscCode: ifscCode ?? this.ifscCode,
      isBankAccountVerificationLoading: isBankAccountVerificationLoading ?? this.isBankAccountVerificationLoading,
      selectedEstimatedMonthlyTransaction:
          selectedEstimatedMonthlyTransaction ?? this.selectedEstimatedMonthlyTransaction,
      curruncyList: curruncyList ?? this.curruncyList,
      selectedCurrencies: selectedCurrencies ?? this.selectedCurrencies,
      isTranscationDetailLoading: isTranscationDetailLoading ?? this.isTranscationDetailLoading,
      isBusinessOtpValidating: isBusinessOtpValidating ?? this.isBusinessOtpValidating,
      businessNatureString: businessNatureString ?? this.businessNatureString,
      estimatedMonthlyVolumeList: estimatedMonthlyVolumeList ?? this.estimatedMonthlyVolumeList,
      selectedAnnualTurnover: selectedAnnualTurnover ?? this.selectedAnnualTurnover,
      isCollapsed: isCollapsed ?? this.isCollapsed,
      isekycCollapsed: isekycCollapsed ?? this.isekycCollapsed,

      isDirectorCaptchaSend: isDirectorCaptchaSend ?? this.isDirectorCaptchaSend,
      isDirectorCaptchaLoading: isDirectorCaptchaLoading ?? this.isDirectorCaptchaLoading,
      directorCaptchaImage: directorCaptchaImage ?? this.directorCaptchaImage,
      directorCaptchaInputController: directorCaptchaInputController ?? this.directorCaptchaInputController,
      isDirectorAadharOtpLoading: isDirectorAadharOtpLoading ?? this.isDirectorAadharOtpLoading,
      isAadharOTPInvalidate: isAadharOTPInvalidate ?? this.isAadharOTPInvalidate,
      kartaCaptchaInputController: kartaCaptchaInputController ?? this.kartaCaptchaInputController,
      kartaCaptchaInput: kartaCaptchaInput ?? this.kartaCaptchaInput,
      isKartaCaptchaValid: isKartaCaptchaValid ?? this.isKartaCaptchaValid,
      isKartaCaptchaSubmitting: isKartaCaptchaSubmitting ?? this.isKartaCaptchaSubmitting,
      kartaCaptchaError: kartaCaptchaError ?? this.kartaCaptchaError,
      isKartaCaptchaSend: isKartaCaptchaSend ?? this.isKartaCaptchaSend,
      isKartaCaptchaLoading: isKartaCaptchaLoading ?? this.isKartaCaptchaLoading,
      kartaCaptchaImage: kartaCaptchaImage ?? this.kartaCaptchaImage,
      isKartaOtpLoading: isKartaOtpLoading ?? this.isKartaOtpLoading,
      kartaIsAadharOTPInvalidate: kartaIsAadharOTPInvalidate ?? this.kartaIsAadharOTPInvalidate,
      isSendOtpLoading: isSendOtpLoading ?? this.isSendOtpLoading,
      isVerifyBusinessRegisterdInfo: isVerifyBusinessRegisterdInfo ?? this.isVerifyBusinessRegisterdInfo,
      partnerAadharNumberController: partnerAadharNumberController ?? this.partnerAadharNumberController,
      partnerAadharOtpController: partnerAadharOtpController ?? this.partnerAadharOtpController,
      isPartnerOtpSent: isPartnerOtpSent ?? this.isPartnerOtpSent,
      partnerAadharOtpRemainingTime: partnerAadharOtpRemainingTime ?? this.partnerAadharOtpRemainingTime,
      isPartnerAadharOtpTimerRunning: isPartnerAadharOtpTimerRunning ?? this.isPartnerAadharOtpTimerRunning,
      partnerAadharNumber: partnerAadharNumber ?? this.partnerAadharNumber,
      isPartnerAadharVerifiedLoading: isPartnerAadharVerifiedLoading ?? this.isPartnerAadharVerifiedLoading,
      isPartnerAadharVerified: isPartnerAadharVerified ?? this.isPartnerAadharVerified,
      partnerAadharVerificationFormKey: partnerAadharVerificationFormKey ?? this.partnerAadharVerificationFormKey,
      partnerFrontSideAdharFile:
          (isPartnerFrontSideAdharFileDeleted == true)
              ? (partnerFrontSideAdharFile)
              : (partnerFrontSideAdharFile ?? this.partnerFrontSideAdharFile),
      partnerBackSideAdharFile:
          (isPartnerBackSideAdharFileDeleted == true)
              ? (partnerBackSideAdharFile)
              : (partnerBackSideAdharFile ?? this.partnerBackSideAdharFile),
      isPartnerAadharFileUploading: isPartnerAadharFileUploading ?? this.isPartnerAadharFileUploading,
      partnerCaptchaInputController: partnerCaptchaInputController ?? this.partnerCaptchaInputController,
      partnerCaptchaInput: partnerCaptchaInput ?? this.partnerCaptchaInput,
      isPartnerCaptchaValid: isPartnerCaptchaValid ?? this.isPartnerCaptchaValid,
      isPartnerCaptchaSubmitting: isPartnerCaptchaSubmitting ?? this.isPartnerCaptchaSubmitting,
      partnerCaptchaError: partnerCaptchaError ?? this.partnerCaptchaError,
      isPartnerCaptchaSend: isPartnerCaptchaSend ?? this.isPartnerCaptchaSend,
      isPartnerCaptchaLoading: isPartnerCaptchaLoading ?? this.isPartnerCaptchaLoading,
      partnerCaptchaImage: partnerCaptchaImage ?? this.partnerCaptchaImage,
      isPartnerOtpLoading: isPartnerOtpLoading ?? this.isPartnerOtpLoading,
      partnerIsAadharOTPInvalidate: partnerIsAadharOTPInvalidate ?? this.partnerIsAadharOTPInvalidate,
      proprietorAadharNumberController: proprietorAadharNumberController ?? this.proprietorAadharNumberController,
      proprietorAadharOtpController: proprietorAadharOtpController ?? this.proprietorAadharOtpController,
      isProprietorOtpSent: isProprietorOtpSent ?? this.isProprietorOtpSent,
      proprietorAadharOtpRemainingTime: proprietorAadharOtpRemainingTime ?? this.proprietorAadharOtpRemainingTime,
      isProprietorAadharOtpTimerRunning: isProprietorAadharOtpTimerRunning ?? this.isProprietorAadharOtpTimerRunning,
      proprietorAadharNumber: proprietorAadharNumber ?? this.proprietorAadharNumber,
      isProprietorAadharVerifiedLoading: isProprietorAadharVerifiedLoading ?? this.isProprietorAadharVerifiedLoading,
      isProprietorAadharVerified: isProprietorAadharVerified ?? this.isProprietorAadharVerified,
      proprietorAadharVerificationFormKey:
          proprietorAadharVerificationFormKey ?? this.proprietorAadharVerificationFormKey,
      proprietorFrontSideAdharFile:
          (isProprietorFrontSideAdharFileDeleted == true)
              ? (proprietorFrontSideAdharFile)
              : (proprietorFrontSideAdharFile ?? this.proprietorFrontSideAdharFile),
      proprietorBackSideAdharFile:
          (isProprietorBackSideAdharFileDeleted == true)
              ? (proprietorBackSideAdharFile)
              : (proprietorBackSideAdharFile ?? this.proprietorBackSideAdharFile),
      isProprietorAadharFileUploading: isProprietorAadharFileUploading ?? this.isProprietorAadharFileUploading,
      proprietorCaptchaInputController: proprietorCaptchaInputController ?? this.proprietorCaptchaInputController,
      proprietorCaptchaInput: proprietorCaptchaInput ?? this.proprietorCaptchaInput,
      isProprietorCaptchaValid: isProprietorCaptchaValid ?? this.isProprietorCaptchaValid,
      isProprietorCaptchaSubmitting: isProprietorCaptchaSubmitting ?? this.isProprietorCaptchaSubmitting,
      proprietorCaptchaError: proprietorCaptchaError ?? this.proprietorCaptchaError,
      isProprietorCaptchaSend: isProprietorCaptchaSend ?? this.isProprietorCaptchaSend,
      isProprietorCaptchaLoading: isProprietorCaptchaLoading ?? this.isProprietorCaptchaLoading,
      proprietorCaptchaImage: proprietorCaptchaImage ?? this.proprietorCaptchaImage,
      isProprietorOtpLoading: isProprietorOtpLoading ?? this.isProprietorOtpLoading,
      proprietorIsAadharOTPInvalidate: proprietorIsAadharOTPInvalidate ?? this.proprietorIsAadharOTPInvalidate,
      isLocalDataLoading: isLocalDataLoading ?? this.isLocalDataLoading,
      isCityAndStateLoading: isCityAndStateLoading ?? this.isCityAndStateLoading,
      isCityAndStateVerified: isCityAndStateVerified ?? this.isCityAndStateVerified,
      gstLegalName: gstLegalName ?? this.gstLegalName,
      isGSTNumberVerify: isGSTNumberVerify ?? this.isGSTNumberVerify,
      isHUFPanDetailsLoading: isHUFPanDetailsLoading ?? this.isHUFPanDetailsLoading,
      fullHUFNamePan: fullHUFNamePan ?? this.fullHUFNamePan,
      isHUFPanDetailsVerified: isHUFPanDetailsVerified ?? this.isHUFPanDetailsVerified,
      isDirector1PanDetailsLoading: isDirector1PanDetailsLoading ?? this.isDirector1PanDetailsLoading,
      fullDirector1NamePan: fullDirector1NamePan ?? this.fullDirector1NamePan,
      isDirector1PanDetailsVerified: isDirector1PanDetailsVerified ?? this.isDirector1PanDetailsVerified,
      fullDirector2NamePan: fullDirector2NamePan ?? this.fullDirector2NamePan,
      isDirector2PanDetailsLoading: isDirector2PanDetailsLoading ?? this.isDirector2PanDetailsLoading,
      isDirector2PanDetailsVerified: isDirector2PanDetailsVerified ?? this.isDirector2PanDetailsVerified,
      fullBeneficialOwnerNamePan: fullBeneficialOwnerNamePan ?? this.fullBeneficialOwnerNamePan,
      isBeneficialOwnerPanDetailsLoading: isBeneficialOwnerPanDetailsLoading ?? this.isBeneficialOwnerPanDetailsLoading,
      isBeneficialOwnerPanDetailsVerified:
          isBeneficialOwnerPanDetailsVerified ?? this.isBeneficialOwnerPanDetailsVerified,
      isBusinessRepresentativePanDetailsLoading:
          isBusinessRepresentativePanDetailsLoading ?? this.isBusinessRepresentativePanDetailsLoading,
      fullBusinessRepresentativeNamePan: fullBusinessRepresentativeNamePan ?? this.fullBusinessRepresentativeNamePan,
      isBusinessRepresentativePanDetailsVerified:
          isBusinessRepresentativePanDetailsVerified ?? this.isBusinessRepresentativePanDetailsVerified,
      directorEmailIdNumberController: directorEmailIdNumberController ?? this.directorEmailIdNumberController,
      directorMobileNumberController: directorMobileNumberController ?? this.directorMobileNumberController,
      directorContactInformationKey: directorContactInformationKey ?? this.directorContactInformationKey,
      isContactInfoSubmitLoading: isContactInfoSubmitLoading ?? this.isContactInfoSubmitLoading,
      isAuthorizedDirectorKycVerify: isAuthorizedDirectorKycVerify ?? this.isAuthorizedDirectorKycVerify,
      isOtherDirectorPanCardSave: isOtherDirectorPanCardSave ?? this.isOtherDirectorPanCardSave,
      isOtherDirectorKycVerify: isOtherDirectorKycVerify ?? this.isOtherDirectorKycVerify,
      isOtherDirectorPanCardSaveLoading: isOtherDirectorPanCardSaveLoading ?? this.isOtherDirectorPanCardSaveLoading,
      otherDirectorsPanVerificationKey: otherDirectorsPanVerificationKey ?? this.otherDirectorsPanVerificationKey,

      // Other Director Aadhar related properties
      isOtherAadharDirectorVerified: isOtherAadharDirectorVerified ?? this.isOtherAadharDirectorVerified,
      otherDirectorVerificationFormKey: otherDirectorVerificationFormKey ?? this.otherDirectorVerificationFormKey,
      otherDirectorAadharNumberController:
          otherDirectorAadharNumberController ?? this.otherDirectorAadharNumberController,
      otherDirectoraadharOtpController: otherDirectoraadharOtpController ?? this.otherDirectoraadharOtpController,
      isOtherDirectorOtpSent: isOtherDirectorOtpSent ?? this.isOtherDirectorOtpSent,
      isOtherDitectorOtpSent: isOtherDitectorOtpSent ?? this.isOtherDitectorOtpSent,
      otherDirectorAadharOtpRemainingTime:
          otherDirectorAadharOtpRemainingTime ?? this.otherDirectorAadharOtpRemainingTime,
      isOtherDirectorAadharOtpTimerRunning:
          isOtherDirectorAadharOtpTimerRunning ?? this.isOtherDirectorAadharOtpTimerRunning,
      otherDirectorAadharNumber: otherDirectorAadharNumber ?? this.otherDirectorAadharNumber,
      isOtherDirectorAadharVerifiedLoading:
          isOtherDirectorAadharVerifiedLoading ?? this.isOtherDirectorAadharVerifiedLoading,
      isOtherDirectorAadharVerified: isOtherDirectorAadharVerified ?? this.isOtherDirectorAadharVerified,
      otherDirectorAadharfrontSideAdharFile:
          (isOtherDirectorAadharfrontSideAdharFileDeleted == true)
              ? (otherDirectorAadharfrontSideAdharFile)
              : (otherDirectorAadharfrontSideAdharFile ?? this.otherDirectorAadharfrontSideAdharFile),
      otherDirectorAadharBackSideAdharFile:
          (isOtherDirectorAadharBackSideAdharFileDeleted == true)
              ? (otherDirectorAadharBackSideAdharFile)
              : (otherDirectorAadharBackSideAdharFile ?? this.otherDirectorAadharBackSideAdharFile),
      isOtherDirectorAadharFileUploading: isOtherDirectorAadharFileUploading ?? this.isOtherDirectorAadharFileUploading,

      // Other Director Captcha related properties
      isOtherDirectorCaptchaSend: isOtherDirectorCaptchaSend ?? this.isOtherDirectorCaptchaSend,
      isOtherDirectorDirectorCaptchaLoading:
          isOtherDirectorDirectorCaptchaLoading ?? this.isOtherDirectorDirectorCaptchaLoading,
      otherDirectorCaptchaImage: otherDirectorCaptchaImage ?? this.otherDirectorCaptchaImage,
      otherDirectorCaptchaInputController:
          otherDirectorCaptchaInputController ?? this.otherDirectorCaptchaInputController,
      isOtherDirectorAadharOtpLoading: isOtherDirectorAadharOtpLoading ?? this.isOtherDirectorAadharOtpLoading,
      isOtherAadharOTPInvalidate: isOtherAadharOTPInvalidate ?? this.isOtherAadharOTPInvalidate,
      directorKycStep: directorKycStep ?? this.directorKycStep,
      otherDirectorKycStep: otherDirectorKycStep ?? this.otherDirectorKycStep,
      showBusinessRepresentativeSelectionDialog:
          showBusinessRepresentativeSelectionDialog ?? this.showBusinessRepresentativeSelectionDialog,
      selectedBusinessRepresentativeOption:
          selectedBusinessRepresentativeOption ?? this.selectedBusinessRepresentativeOption,
      isBusinessRepresentativeConfirmLoading:
          isBusinessRepresentativeConfirmLoading ?? this.isBusinessRepresentativeConfirmLoading,
      companyPanVerificationKey: companyPanVerificationKey ?? this.companyPanVerificationKey,
      companyPanNumberController: companyPanNumberController ?? this.companyPanNumberController,
      companyPanNumberFocusNode: companyPanNumberFocusNode ?? this.companyPanNumberFocusNode,
      companyPanCardFile:
          (isCompanyPanCardFileDeleted == true)
              ? (companyPanCardFile)
              : (companyPanCardFile ?? this.companyPanCardFile),
      isCompanyPanDetailsLoading: isCompanyPanDetailsLoading ?? this.isCompanyPanDetailsLoading,
      isCompanyPanDetailsVerified: isCompanyPanDetailsVerified ?? this.isCompanyPanDetailsVerified,
      fullCompanyNamePan: fullCompanyNamePan ?? this.fullCompanyNamePan,
      isCompanyPanVerifyingLoading: isCompanyPanVerifyingLoading ?? this.isCompanyPanVerifyingLoading,
      shouldNavigateBack: shouldNavigateBack ?? this.shouldNavigateBack,
      llpPanVerificationKey: llpPanVerificationKey ?? this.llpPanVerificationKey,
      llpPanNumberController: llpPanNumberController ?? this.llpPanNumberController,
      llpPanNumberFocusNode: llpPanNumberFocusNode ?? this.llpPanNumberFocusNode,
      llpPanCardFile: (isLLPPanCardFileDeleted == true) ? (llpPanCardFile) : (llpPanCardFile ?? this.llpPanCardFile),
      isLLPPanVerifyingLoading: isLLPPanVerifyingLoading ?? this.isLLPPanVerifyingLoading,
      isLLPPanDetailsLoading: isLLPPanDetailsLoading ?? this.isLLPPanDetailsLoading,
      fullLLPNamePan: fullLLPNamePan ?? this.fullLLPNamePan,
      isLLPPanDetailsVerified: isLLPPanDetailsVerified ?? this.isLLPPanDetailsVerified,
      partnershipFirmPanVerificationKey: partnershipFirmPanVerificationKey ?? this.partnershipFirmPanVerificationKey,
      partnershipFirmPanNumberController: partnershipFirmPanNumberController ?? this.partnershipFirmPanNumberController,
      partnershipFirmPanNumberFocusNode: partnershipFirmPanNumberFocusNode ?? this.partnershipFirmPanNumberFocusNode,
      partnershipFirmPanCardFile:
          (isPartnershipFirmPanCardFileDeleted == true)
              ? (partnershipFirmPanCardFile)
              : (partnershipFirmPanCardFile ?? this.partnershipFirmPanCardFile),
      isPartnershipFirmPanVerifyingLoading:
          isPartnershipFirmPanVerifyingLoading ?? this.isPartnershipFirmPanVerifyingLoading,
      isPartnershipFirmPanDetailsLoading: isPartnershipFirmPanDetailsLoading ?? this.isPartnershipFirmPanDetailsLoading,
      fullPartnershipFirmNamePan: fullPartnershipFirmNamePan ?? this.fullPartnershipFirmNamePan,
      isPartnershipFirmPanDetailsVerified:
          isPartnershipFirmPanDetailsVerified ?? this.isPartnershipFirmPanDetailsVerified,
      soleProprietorShipPanVerificationKey:
          soleProprietorShipPanVerificationKey ?? this.soleProprietorShipPanVerificationKey,
      soleProprietorShipPanNumberController:
          soleProprietorShipPanNumberController ?? this.soleProprietorShipPanNumberController,
      soleProprietorShipPanNumberFocusNode:
          soleProprietorShipPanNumberFocusNode ?? this.soleProprietorShipPanNumberFocusNode,
      soleProprietorShipPanCardFile:
          (isSoleProprietorShipPanCardFileDeleted == true)
              ? (soleProprietorShipPanCardFile)
              : (soleProprietorShipPanCardFile ?? this.soleProprietorShipPanCardFile),
      isSoleProprietorShipPanVerifyingLoading:
          isSoleProprietorShipPanVerifyingLoading ?? this.isSoleProprietorShipPanVerifyingLoading,
      isSoleProprietorShipPanDetailsLoading:
          isSoleProprietorShipPanDetailsLoading ?? this.isSoleProprietorShipPanDetailsLoading,
      fullSoleProprietorShipNamePan: fullSoleProprietorShipNamePan ?? this.fullSoleProprietorShipNamePan,
      isSoleProprietorShipPanDetailsVerified:
          isSoleProprietorShipPanDetailsVerified ?? this.isSoleProprietorShipPanDetailsVerified,
      kartaPanVerificationKey: kartaPanVerificationKey ?? this.kartaPanVerificationKey,
      kartaPanNumberController: kartaPanNumberController ?? this.kartaPanNumberController,
      kartaPanNumberFocusNode: kartaPanNumberFocusNode ?? this.kartaPanNumberFocusNode,
      kartaPanCardFile:
          (isKartaPanCardFileDeleted == true) ? (kartaPanCardFile) : (kartaPanCardFile ?? this.kartaPanCardFile),
      isKartaPanVerifyingLoading: isKartaPanVerifyingLoading ?? this.isKartaPanVerifyingLoading,
      isKartaPanDetailsLoading: isKartaPanDetailsLoading ?? this.isKartaPanDetailsLoading,
      fullKartaNamePan: fullKartaNamePan ?? this.fullKartaNamePan,
      isKartaPanDetailsVerified: isKartaPanDetailsVerified ?? this.isKartaPanDetailsVerified,
      isCompanyPanCardFileDeleted: isCompanyPanCardFileDeleted ?? this.isCompanyPanCardFileDeleted,
      isFrontSideAdharFileDeleted: isFrontSideAdharFileDeleted ?? this.isFrontSideAdharFileDeleted,
      isBackSideAdharFileDeleted: isBackSideAdharFileDeleted ?? this.isBackSideAdharFileDeleted,
      isKartaFrontSideAdharFileDeleted: isKartaFrontSideAdharFileDeleted ?? this.isKartaFrontSideAdharFileDeleted,
      isKartaBackSideAdharFileDeleted: isKartaBackSideAdharFileDeleted ?? this.isKartaBackSideAdharFileDeleted,
      isHUFPanCardFileDeleted: isHUFPanCardFileDeleted ?? this.isHUFPanCardFileDeleted,
      isBusinessPanCardFileDeleted: isBusinessPanCardFileDeleted ?? this.isBusinessPanCardFileDeleted,
      isDirector1PanCardFileDeleted: isDirector1PanCardFileDeleted ?? this.isDirector1PanCardFileDeleted,
      isDirector2PanCardFileDeleted: isDirector2PanCardFileDeleted ?? this.isDirector2PanCardFileDeleted,
      isBeneficialOwnerPanCardFileDeleted:
          isBeneficialOwnerPanCardFileDeleted ?? this.isBeneficialOwnerPanCardFileDeleted,
      isBusinessRepresentativePanCardFileDeleted:
          isBusinessRepresentativePanCardFileDeleted ?? this.isBusinessRepresentativePanCardFileDeleted,
      isAddressVerificationFileDeleted: isAddressVerificationFileDeleted ?? this.isAddressVerificationFileDeleted,
      isGstCertificateFileDeleted: isGstCertificateFileDeleted ?? this.isGstCertificateFileDeleted,
      isIceCertificateFileDeleted: isIceCertificateFileDeleted ?? this.isIceCertificateFileDeleted,
      isCoiCertificateFileDeleted: isCoiCertificateFileDeleted ?? this.isCoiCertificateFileDeleted,
      isUploadLLPAgreementFileDeleted: isUploadLLPAgreementFileDeleted ?? this.isUploadLLPAgreementFileDeleted,
      isUploadPartnershipDeedDeleted: isUploadPartnershipDeedDeleted ?? this.isUploadPartnershipDeedDeleted,
      isBankVerificationFileDeleted: isBankVerificationFileDeleted ?? this.isBankVerificationFileDeleted,
      isPartnerFrontSideAdharFileDeleted: isPartnerFrontSideAdharFileDeleted ?? this.isPartnerFrontSideAdharFileDeleted,
      isPartnerBackSideAdharFileDeleted: isPartnerBackSideAdharFileDeleted ?? this.isPartnerBackSideAdharFileDeleted,
      isProprietorFrontSideAdharFileDeleted:
          isProprietorFrontSideAdharFileDeleted ?? this.isProprietorFrontSideAdharFileDeleted,
      isProprietorBackSideAdharFileDeleted:
          isProprietorBackSideAdharFileDeleted ?? this.isProprietorBackSideAdharFileDeleted,
      isOtherDirectorAadharfrontSideAdharFileDeleted:
          isOtherDirectorAadharfrontSideAdharFileDeleted ?? this.isOtherDirectorAadharfrontSideAdharFileDeleted,
      isOtherDirectorAadharBackSideAdharFileDeleted:
          isOtherDirectorAadharBackSideAdharFileDeleted ?? this.isOtherDirectorAadharBackSideAdharFileDeleted,
      isLLPPanCardFileDeleted: isLLPPanCardFileDeleted ?? this.isLLPPanCardFileDeleted,
      isPartnershipFirmPanCardFileDeleted:
          isPartnershipFirmPanCardFileDeleted ?? this.isPartnershipFirmPanCardFileDeleted,
      isSoleProprietorShipPanCardFileDeleted:
          isSoleProprietorShipPanCardFileDeleted ?? this.isSoleProprietorShipPanCardFileDeleted,
      isKartaPanCardFileDeleted: isKartaPanCardFileDeleted ?? this.isKartaPanCardFileDeleted,
      isAadharAddressSameAsResidentialAddress:
          isAadharAddressSameAsResidentialAddress ?? this.isAadharAddressSameAsResidentialAddress,
      authorizedSelectedCountry: authorizedSelectedCountry ?? this.authorizedSelectedCountry,
      authorizedPinCodeController: authorizedPinCodeController ?? this.authorizedPinCodeController,
      authorizedStateNameController: authorizedStateNameController ?? this.authorizedStateNameController,
      authorizedCityNameController: authorizedCityNameController ?? this.authorizedCityNameController,
      authorizedAddress1NameController: authorizedAddress1NameController ?? this.authorizedAddress1NameController,
      authorizedAddress2NameController: authorizedAddress2NameController ?? this.authorizedAddress2NameController,
      isAuthorizedCityAndStateLoading: isAuthorizedCityAndStateLoading ?? this.isAuthorizedCityAndStateLoading,
      otherDirectorSelectedCountry: otherDirectorSelectedCountry ?? this.otherDirectorSelectedCountry,
      otherDirectorPinCodeController: otherDirectorPinCodeController ?? this.otherDirectorPinCodeController,
      otherDirectorStateNameController: otherDirectorStateNameController ?? this.otherDirectorStateNameController,
      otherDirectorCityNameController: otherDirectorCityNameController ?? this.otherDirectorCityNameController,
      otherDirectorAddress1NameController:
          otherDirectorAddress1NameController ?? this.otherDirectorAddress1NameController,
      otherDirectorAddress2NameController:
          otherDirectorAddress2NameController ?? this.otherDirectorAddress2NameController,
      isOtherDirectorCityAndStateLoading: isOtherDirectorCityAndStateLoading ?? this.isOtherDirectorCityAndStateLoading,
      isOtherDirectorAadharAddressSameAsResidentialAddress:
          isOtherDirectorAadharAddressSameAsResidentialAddress ??
          this.isOtherDirectorAadharAddressSameAsResidentialAddress,
      beneficialOwnerKycStep: beneficialOwnerKycStep ?? this.beneficialOwnerKycStep,
      beneficialOwnerSelectedCountry: beneficialOwnerSelectedCountry ?? this.beneficialOwnerSelectedCountry,
      beneficialOwnerPinCodeController: beneficialOwnerPinCodeController ?? this.beneficialOwnerPinCodeController,
      beneficialOwnerStateNameController: beneficialOwnerStateNameController ?? this.beneficialOwnerStateNameController,
      beneficialOwnerCityNameController: beneficialOwnerCityNameController ?? this.beneficialOwnerCityNameController,
      beneficialOwnerAddress1NameController:
          beneficialOwnerAddress1NameController ?? this.beneficialOwnerAddress1NameController,
      beneficialOwnerAddress2NameController:
          beneficialOwnerAddress2NameController ?? this.beneficialOwnerAddress2NameController,
      isBeneficialOwnerCityAndStateLoading:
          isBeneficialOwnerCityAndStateLoading ?? this.isBeneficialOwnerCityAndStateLoading,
      beneficialOwnershipDeclarationFile:
          (isBeneficialOwnershipDeclarationFileDeleted == true)
              ? (beneficialOwnershipDeclarationFile)
              : (beneficialOwnershipDeclarationFile ?? this.beneficialOwnershipDeclarationFile),
      isBeneficialOwnershipDeclarationVerifyingLoading:
          isBeneficialOwnershipDeclarationVerifyingLoading ?? this.isBeneficialOwnershipDeclarationVerifyingLoading,
      companyPanDetailsErrorMessage: companyPanDetailsErrorMessage ?? this.companyPanDetailsErrorMessage,
      llpPanDetailsErrorMessage: llpPanDetailsErrorMessage ?? this.llpPanDetailsErrorMessage,
      partnershipFirmPanDetailsErrorMessage:
          partnershipFirmPanDetailsErrorMessage ?? this.partnershipFirmPanDetailsErrorMessage,
      soleProprietorShipPanDetailsErrorMessage:
          soleProprietorShipPanDetailsErrorMessage ?? this.soleProprietorShipPanDetailsErrorMessage,
      kartaPanDetailsErrorMessage: kartaPanDetailsErrorMessage ?? this.kartaPanDetailsErrorMessage,
      hufPanDetailsErrorMessage: hufPanDetailsErrorMessage ?? this.hufPanDetailsErrorMessage,
      director1PanDetailsErrorMessage: director1PanDetailsErrorMessage ?? this.director1PanDetailsErrorMessage,
      director2PanDetailsErrorMessage: director2PanDetailsErrorMessage ?? this.director2PanDetailsErrorMessage,
      beneficialOwnerPanDetailsErrorMessage:
          beneficialOwnerPanDetailsErrorMessage ?? this.beneficialOwnerPanDetailsErrorMessage,
      isGstNumberVerifyingLoading: isGstNumberVerifyingLoading ?? this.isGstNumberVerifyingLoading,
      llpPanEditAttempts: llpPanEditAttempts ?? this.llpPanEditAttempts,
      isLLPPanEditLocked: isLLPPanEditLocked ?? this.isLLPPanEditLocked,
      llpPanEditLockTime: llpPanEditLockTime ?? this.llpPanEditLockTime,
      isLLPPanModifiedAfterVerification: isLLPPanModifiedAfterVerification ?? this.isLLPPanModifiedAfterVerification,
      isHUFPanModifiedAfterVerification: isHUFPanModifiedAfterVerification ?? this.isHUFPanModifiedAfterVerification,
      isHUFPanEditLocked: isHUFPanEditLocked ?? this.isHUFPanEditLocked,
      llpPanEditErrorMessage: llpPanEditErrorMessage ?? this.llpPanEditErrorMessage,
      hufPanEditAttempts: hufPanEditAttempts ?? this.hufPanEditAttempts,
      hufPanEditLockTime: hufPanEditLockTime ?? this.hufPanEditLockTime,
      hufPanEditErrorMessage: hufPanEditErrorMessage ?? this.hufPanEditErrorMessage,
      partnershipFirmPanEditAttempts: partnershipFirmPanEditAttempts ?? this.partnershipFirmPanEditAttempts,
      isPartnershipFirmPanEditLocked: isPartnershipFirmPanEditLocked ?? this.isPartnershipFirmPanEditLocked,
      partnershipFirmPanEditLockTime: partnershipFirmPanEditLockTime ?? this.partnershipFirmPanEditLockTime,
      partnershipFirmPanEditErrorMessage: partnershipFirmPanEditErrorMessage ?? this.partnershipFirmPanEditErrorMessage,
      isPartnershipFirmPanModifiedAfterVerification:
          isPartnershipFirmPanModifiedAfterVerification ?? this.isPartnershipFirmPanModifiedAfterVerification,
      soleProprietorShipPanEditAttempts: soleProprietorShipPanEditAttempts ?? this.soleProprietorShipPanEditAttempts,
      isSoleProprietorShipPanEditLocked: isSoleProprietorShipPanEditLocked ?? this.isSoleProprietorShipPanEditLocked,
      soleProprietorShipPanEditLockTime: soleProprietorShipPanEditLockTime ?? this.soleProprietorShipPanEditLockTime,
      soleProprietorShipPanEditErrorMessage:
          soleProprietorShipPanEditErrorMessage ?? this.soleProprietorShipPanEditErrorMessage,
      isSoleProprietorShipPanModifiedAfterVerification:
          isSoleProprietorShipPanModifiedAfterVerification ?? this.isSoleProprietorShipPanModifiedAfterVerification,
      kartaPanEditAttempts: kartaPanEditAttempts ?? this.kartaPanEditAttempts,
      isKartaPanEditLocked: isKartaPanEditLocked ?? this.isKartaPanEditLocked,
      kartaPanEditLockTime: kartaPanEditLockTime ?? this.kartaPanEditLockTime,
      kartaPanEditErrorMessage: kartaPanEditErrorMessage ?? this.kartaPanEditErrorMessage,
      isKartaPanModifiedAfterVerification:
          isKartaPanModifiedAfterVerification ?? this.isKartaPanModifiedAfterVerification,
      companyPanEditAttempts: companyPanEditAttempts ?? this.companyPanEditAttempts,
      isCompanyPanEditLocked: isCompanyPanEditLocked ?? this.isCompanyPanEditLocked,
      companyPanEditLockTime: companyPanEditLockTime ?? this.companyPanEditLockTime,
      companyPanEditErrorMessage: companyPanEditErrorMessage ?? this.companyPanEditErrorMessage,
      isCompanyPanModifiedAfterVerification:
          isCompanyPanModifiedAfterVerification ?? this.isCompanyPanModifiedAfterVerification,
      beneficialOwnerPanEditAttempts: beneficialOwnerPanEditAttempts ?? this.beneficialOwnerPanEditAttempts,
      isBeneficialOwnerPanEditLocked: isBeneficialOwnerPanEditLocked ?? this.isBeneficialOwnerPanEditLocked,
      beneficialOwnerPanEditLockTime: beneficialOwnerPanEditLockTime ?? this.beneficialOwnerPanEditLockTime,
      beneficialOwnerPanEditErrorMessage: beneficialOwnerPanEditErrorMessage ?? this.beneficialOwnerPanEditErrorMessage,
      isBeneficialOwnerPanModifiedAfterVerification:
          isBeneficialOwnerPanModifiedAfterVerification ?? this.isBeneficialOwnerPanModifiedAfterVerification,
      director1PanEditAttempts: director1PanEditAttempts ?? this.director1PanEditAttempts,
      isDirector1PanEditLocked: isDirector1PanEditLocked ?? this.isDirector1PanEditLocked,
      director1PanEditLockTime: director1PanEditLockTime ?? this.director1PanEditLockTime,
      director1PanEditErrorMessage: director1PanEditErrorMessage ?? this.director1PanEditErrorMessage,
      isDirector1PanModifiedAfterVerification:
          isDirector1PanModifiedAfterVerification ?? this.isDirector1PanModifiedAfterVerification,
      director2PanEditAttempts: director2PanEditAttempts ?? this.director2PanEditAttempts,
      isDirector2PanEditLocked: isDirector2PanEditLocked ?? this.isDirector2PanEditLocked,
      director2PanEditLockTime: director2PanEditLockTime ?? this.director2PanEditLockTime,
      director2PanEditErrorMessage: director2PanEditErrorMessage ?? this.director2PanEditErrorMessage,
      directorPANValidationErrorMessage: directorPANValidationErrorMessage ?? this.directorPANValidationErrorMessage,
      directorAadhaarValidationErrorMessage:
          directorAadhaarValidationErrorMessage ?? this.directorAadhaarValidationErrorMessage,
      isDirector2PanModifiedAfterVerification:
          isDirector2PanModifiedAfterVerification ?? this.isDirector2PanModifiedAfterVerification,
      isGSTINOrIECHasUploaded: isGSTINOrIECHasUploaded ?? this.isGSTINOrIECHasUploaded,
      shopEstablishmentCertificateFile:
          (isShopEstablishmentCertificateFileDeleted == true)
              ? (shopEstablishmentCertificateFile)
              : (shopEstablishmentCertificateFile ?? this.shopEstablishmentCertificateFile),
      isShopEstablishmentCertificateFileDeleted:
          isShopEstablishmentCertificateFileDeleted ?? this.isShopEstablishmentCertificateFileDeleted,
      udyamCertificateFile:
          (isUdyamCertificateFileDeleted == true)
              ? (udyamCertificateFile)
              : (udyamCertificateFile ?? this.udyamCertificateFile),
      isUdyamCertificateFileDeleted: isUdyamCertificateFileDeleted ?? this.isUdyamCertificateFileDeleted,
      taxProfessionalTaxRegistrationFile:
          (isTaxProfessionalTaxRegistrationFileDeleted == true)
              ? (taxProfessionalTaxRegistrationFile)
              : (taxProfessionalTaxRegistrationFile ?? this.taxProfessionalTaxRegistrationFile),
      isTaxProfessionalTaxRegistrationFileDeleted:
          isTaxProfessionalTaxRegistrationFileDeleted ?? this.isTaxProfessionalTaxRegistrationFileDeleted,
      utilityBillFile:
          (isUtilityBillFileDeleted == true) ? (utilityBillFile) : (utilityBillFile ?? this.utilityBillFile),
      isUtilityBillFileDeleted: isUtilityBillFileDeleted ?? this.isUtilityBillFileDeleted,
      isBusinessDocumentsVerificationLoading:
          isBusinessDocumentsVerificationLoading ?? this.isBusinessDocumentsVerificationLoading,
      isDeleteDocumentLoading: isDeleteDocumentLoading ?? this.isDeleteDocumentLoading,
      isDeleteDocumentSuccess: isDeleteDocumentSuccess ?? this.isDeleteDocumentSuccess,
      directorAadharNumberFocusNode: directorAadharNumberFocusNode ?? this.directorAadharNumberFocusNode,
      otherDirectorAadharNumberFocusNode: otherDirectorAadharNumberFocusNode ?? this.otherDirectorAadharNumberFocusNode,
      proprietorAadharNumberFocusNode: proprietorAadharNumberFocusNode ?? this.proprietorAadharNumberFocusNode,

      // Data change tracking properties
      isIdentityVerificationDataChanged: isIdentityVerificationDataChanged ?? this.isIdentityVerificationDataChanged,
      isPanDetailsDataChanged: isPanDetailsDataChanged ?? this.isPanDetailsDataChanged,
      isResidentialAddressDataChanged: isResidentialAddressDataChanged ?? this.isResidentialAddressDataChanged,
      isAnnualTurnoverDataChanged: isAnnualTurnoverDataChanged ?? this.isAnnualTurnoverDataChanged,
      isBankAccountDataChanged: isBankAccountDataChanged ?? this.isBankAccountDataChanged,
      isIceVerificationDataChanged: isIceVerificationDataChanged ?? this.isIceVerificationDataChanged,
      isBusinessDocumentsDataChanged: isBusinessDocumentsDataChanged ?? this.isBusinessDocumentsDataChanged,

      // Screen-specific data change tracking properties
      isProprietorAadharDataChanged: isProprietorAadharDataChanged ?? this.isProprietorAadharDataChanged,
      isSoleProprietorshipPanDataChanged: isSoleProprietorshipPanDataChanged ?? this.isSoleProprietorshipPanDataChanged,
      isPartnershipFirmPanDataChanged: isPartnershipFirmPanDataChanged ?? this.isPartnershipFirmPanDataChanged,
      isLLPPanDataChanged: isLLPPanDataChanged ?? this.isLLPPanDataChanged,
      isKartaPanDataChanged: isKartaPanDataChanged ?? this.isKartaPanDataChanged,
      isHUFPanDataChanged: isHUFPanDataChanged ?? this.isHUFPanDataChanged,
      isCompanyPanDataChanged: isCompanyPanDataChanged ?? this.isCompanyPanDataChanged,
      isCompanyIncorporationDataChanged: isCompanyIncorporationDataChanged ?? this.isCompanyIncorporationDataChanged,
      isContactInformationDataChanged: isContactInformationDataChanged ?? this.isContactInformationDataChanged,
      isBeneficialOwnershipDataChanged: isBeneficialOwnershipDataChanged ?? this.isBeneficialOwnershipDataChanged,
      isPanDetailViewDataChanged: isPanDetailViewDataChanged ?? this.isPanDetailViewDataChanged,
      originalBusinessGstNumber: originalBusinessGstNumber ?? this.originalBusinessGstNumber,
      originalBusinessBankAccountNumber: originalBusinessBankAccountNumber ?? this.originalBusinessBankAccountNumber,
      originalBusinessAadharNumber: originalBusinessAadharNumber ?? this.originalBusinessAadharNumber,
      originalBusinessPanNumber: originalBusinessPanNumber ?? this.originalBusinessPanNumber,
      originalDirector1PanNumber: originalDirector1PanNumber ?? this.originalDirector1PanNumber,
      originalDirector2PanNumber: originalDirector2PanNumber ?? this.originalDirector2PanNumber,
      originalDirector1AadharNumber: originalDirector1AadharNumber ?? this.originalDirector1AadharNumber,
      originalDirector2AadharNumber: originalDirector2AadharNumber ?? this.originalDirector2AadharNumber,
      originalProprietorAadharNumber: originalProprietorAadharNumber ?? this.originalProprietorAadharNumber,
      dbaController: dbaController ?? this.dbaController,
    );
  }
}
