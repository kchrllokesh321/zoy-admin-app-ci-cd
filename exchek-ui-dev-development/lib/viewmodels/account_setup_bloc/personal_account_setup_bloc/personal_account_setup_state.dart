part of 'personal_account_setup_bloc.dart';

class PersonalAccountSetupState extends Equatable {
  final PersonalAccountSetupSteps currentStep;
  final String? selectedPurpose;
  final List<String>? selectedProfession;
  final ScrollController scrollController;
  final TextEditingController professionOtherController;
  final TextEditingController productServiceDescriptionController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final BuildContext? context;
  final GlobalKey<FormState> personalInfoKey;
  final String? fullName;
  final String? email;
  final String? website;
  final String? phoneNumber;
  final String? password;
  final String? selectedEstimatedMonthlyTransaction;
  final List<CurrencyModel>? currencyList;
  final List<CurrencyModel>? selectedCurrencies;
  final List<String>? estimatedMonthlyVolumeList;
  final bool? isTransactionDetailLoading;
  final bool isPersonalAccount;
  final PersonalEKycVerificationSteps currentKycVerificationStep;
  final IDVerificationDocType? selectedIDVerificationDocType;
  final TextEditingController aadharNumberController;
  final TextEditingController aadharOtpController;
  final bool isOtpSent;
  final int aadharOtpRemainingTime;
  final bool isAadharOtpTimerRunning;
  final String? aadharNumber;
  final bool? isIdVerifiedLoading;
  final bool? isIdVerified;
  final GlobalKey<FormState> aadharVerificationFormKey;
  final GlobalKey<FormState> drivingVerificationFormKey;
  final TextEditingController drivingLicenceController;
  final String? drivingLicenseNumber;
  final bool? isDrivingIdVerifiedLoading;
  final bool? isDrivingIdVerified;
  final FileData? drivingLicenceFrontSideFile;
  final FileData? drivingLicenceBackSideFile;
  final FileData? frontSideAdharFile;
  final FileData? backSideAdharFile;
  final bool isIdFileSubmittedLoading;
  final GlobalKey<FormState> voterVerificationFormKey;
  final TextEditingController voterIdNumberController;
  final String? voterIDNumber;
  final bool? isvoterIdVerifiedLoading;
  final bool? isvoterIdVerified;
  final FileData? voterIdFrontFile;
  final FileData? voterIdBackFile;
  final GlobalKey<FormState> passportVerificationFormKey;
  final TextEditingController passportNumberController;
  final String? passporteNumber;
  final bool? ispassportIdVerifiedLoading;
  final bool? ispassportIdVerified;
  final FileData? passportFrontFile;
  final FileData? passportBackFile;
  final GlobalKey<FormState> panVerificationKey;
  final TextEditingController panNameController;
  final TextEditingController panNumberController;
  final FocusNode? panNumberFocusNode;
  final FileData? panFileData;
  final bool? isPanVerifyingLoading;
  final GlobalKey<FormState> registerAddressFormKey;
  final Country? selectedCountry;
  final TextEditingController pinCodeController;
  final TextEditingController stateNameController;
  final TextEditingController cityNameController;
  final TextEditingController address1NameController;
  final TextEditingController address2NameController;
  final String? selectedAddressVerificationDocType;
  final FileData? addressVerificationFile;
  final FileData? backAddressVerificationFile;
  final bool? isAddressVerificationLoading;
  final GlobalKey<FormState> annualTurnoverFormKey;
  final TextEditingController turnOverController;
  final TextEditingController gstNumberController;
  final FileData? gstCertificateFile;
  final bool? isGstCertificateMandatory;
  final bool? isGstVerificationLoading;
  final GlobalKey<FormState> personalBankAccountVerificationFormKey;
  final TextEditingController bankAccountNumberController;
  final TextEditingController reEnterbankAccountNumberController;
  final TextEditingController ifscCodeController;
  final String? bankAccountNumber;
  final String? ifscCode;
  final String? accountHolderName;
  final String? selectedBankAccountVerificationDocType;
  final FileData? bankVerificationFile;
  final bool? isBankAccountVerify;
  final bool? isBankAccountNumberVerifiedLoading;
  final bool isLoading;
  final bool isReady;
  final bool hasPermission;
  final CameraController? cameraController;
  final Uint8List? imageBytes;
  final String? errorMessage;
  final bool isImageCaptured;
  final bool isImageSubmitted;
  final bool navigateNext;
  final Timer? scrollDebounceTimer;
  final TextEditingController websiteController;
  final TextEditingController mobileController;
  final TextEditingController otpController;
  final bool isOTPSent;
  final bool isOtpVerified;
  final bool canResendOTP;
  final int timeLeft;
  final String? otpError;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final String? error;
  final GlobalKey<FormState> sePasswordFormKey;
  final bool? isSignupSuccess;
  final TextEditingController captchaInputController;
  final String captchaInput;
  final bool isCaptchaValid;
  final bool isCaptchaSubmitting;
  final String? isCaptchError;
  final bool isCaptchaSend;
  final bool? isCaptchaLoading;
  final String? captchaImage;
  final bool isOtpLoading;
  final int isResidenceAddressSameAsAadhar;
  final bool isPanDetailsLoading;
  final String? fullNamePan;
  final bool isPanDetailsVerified;
  final bool isCityAndStateLoading;
  final bool isCityAndStateVerified;
  final bool isAgreeToAddressSameAsAadhar;
  final bool isVerifyPersonalRegisterdInfo;
  final String? isAadharOTPInvalidate;
  final bool showPanNameOverwrittenPopup;
  final TextEditingController fullNameController;
  final TextEditingController familyAndFriendsDescriptionController;
  final String? selectedAnnualTurnover;
  final bool isCollapsed;
  final bool isEkycCollapsed;
  final String? gstLegalName;
  final bool isGSTNumberVerify;
  final GlobalKey<FormState> iceVerificationKey;
  final TextEditingController iceNumberController;
  final FileData? iceCertificateFile;
  final bool? isIceVerifyingLoading;
  final bool isLocalDataLoading;
  final bool? isShowServiceDescriptionBox;
  final bool isDrivingLicenceFrontSideFileDeleted;
  final bool isDrivingLicenceBackSideFileDeleted;
  final bool isFrontSideAdharFileDeleted;
  final bool isBackSideAdharFileDeleted;
  final bool isVoterIdFrontFileDeleted;
  final bool isVoterIdBackFileDeleted;
  final bool isPassportFrontFileDeleted;
  final bool isPassportBackFileDeleted;
  final bool isPanFileDataDeleted;
  final bool isAddressVerificationFileDeleted;
  final bool isBackAddressVerificationFileDeleted;
  final bool isGstCertificateFileDeleted;
  final bool isBankVerificationFileDeleted;
  final bool isIceCertificateFileDeleted;
  final String? panDetailsErrorMessage;
  final int personalPanEditAttempts;
  final bool isPersonalPanEditLocked;
  final DateTime? personalPanEditLockTime;
  final String? personalPanEditErrorMessage;
  final bool isPersonalPanModifiedAfterVerification;
  final bool isPassportFrontFileUploaded;
  final bool isVoteridFrontFileUploaded;
  final bool isDrivingLicenceFrontSideFileUploaded;
  final bool isFrontSideAdharFileUploaded;
  final bool isGstNumberVerifyingLoading;
  final FocusNode? mobileNumberFocusNode;
  final FocusNode? aadharNumberFocusNode;
  final bool isFrontSideAddressVerificationFileUploaded;
  final bool isFrontSideAddressAdharFileUploaded;

  // PDF merge progress
  final bool isMerging;
  final double? mergeProgress; // 0.0 - 1.0
  final String? mergeStatus;

  // Data change tracking properties
  final bool isIdentityVerificationDataChanged;
  final bool isPanDetailsDataChanged;
  final bool isResidentialAddressDataChanged;
  final bool isAnnualTurnoverDataChanged;
  final bool isBankAccountDataChanged;
  final bool isIceVerificationDataChanged;

  // Original values for edit functionality
  final String? originalAadharNumber;
  final String? originalPanNumber;
  final String? originalGstNumber;
  final String? originalBankAccountNumber;
  final TextEditingController personalDbaController;
  final bool panOverwriteMismatch;
  final String? panOverwriteName;
  final bool showOverwriteToast;
  final bool panVerificationSuccess;

  const PersonalAccountSetupState({
    this.currentStep = PersonalAccountSetupSteps.personalEntity,
    this.selectedPurpose,
    this.selectedProfession,
    required this.scrollController,
    required this.professionOtherController,
    required this.productServiceDescriptionController,
    required this.passwordController,
    required this.confirmPasswordController,
    this.context,
    required this.personalInfoKey,
    this.fullName,
    this.email,
    this.website,
    this.phoneNumber,
    this.password,
    this.selectedEstimatedMonthlyTransaction,
    this.currencyList,
    this.selectedCurrencies,
    this.estimatedMonthlyVolumeList,
    this.isTransactionDetailLoading,
    this.isPersonalAccount = true,
    this.selectedIDVerificationDocType,
    this.isOtpSent = false,
    this.aadharOtpRemainingTime = 0,
    this.isAadharOtpTimerRunning = false,
    required this.currentKycVerificationStep,
    required this.aadharNumberController,
    required this.aadharOtpController,
    this.aadharNumber,
    this.isIdVerifiedLoading = false,
    this.isIdVerified = false,
    this.isDrivingIdVerifiedLoading,
    this.isDrivingIdVerified,
    required this.aadharVerificationFormKey,
    required this.drivingVerificationFormKey,
    required this.drivingLicenceController,
    this.drivingLicenseNumber,
    this.drivingLicenceFrontSideFile,
    this.drivingLicenceBackSideFile,
    this.frontSideAdharFile,
    this.backSideAdharFile,
    this.isIdFileSubmittedLoading = false,
    required this.voterVerificationFormKey,
    required this.voterIdNumberController,
    this.voterIDNumber,
    this.isvoterIdVerifiedLoading,
    this.isvoterIdVerified,
    this.voterIdFrontFile,
    this.voterIdBackFile,
    required this.passportVerificationFormKey,
    required this.passportNumberController,
    this.passporteNumber,
    this.ispassportIdVerifiedLoading,
    this.ispassportIdVerified,
    this.passportFrontFile,
    this.passportBackFile,
    required this.panVerificationKey,
    required this.panNameController,
    required this.panNumberController,
    this.panNumberFocusNode,
    this.panFileData,
    this.isPanVerifyingLoading,
    required this.registerAddressFormKey,
    this.selectedCountry,
    required this.pinCodeController,
    required this.stateNameController,
    required this.cityNameController,
    required this.address1NameController,
    required this.address2NameController,
    this.selectedAddressVerificationDocType,
    this.addressVerificationFile,
    this.backAddressVerificationFile,
    this.isAddressVerificationLoading,
    required this.annualTurnoverFormKey,
    required this.turnOverController,
    required this.gstNumberController,
    this.gstCertificateFile,
    this.isGstCertificateMandatory,
    this.isGstVerificationLoading,
    required this.personalBankAccountVerificationFormKey,
    required this.bankAccountNumberController,
    required this.reEnterbankAccountNumberController,
    required this.ifscCodeController,
    this.bankAccountNumber,
    this.ifscCode,
    this.accountHolderName,
    this.selectedBankAccountVerificationDocType,
    this.bankVerificationFile,
    this.isBankAccountVerify,
    this.isBankAccountNumberVerifiedLoading,
    this.isLoading = false,
    this.isReady = false,
    this.hasPermission = false,
    this.cameraController,
    this.imageBytes,
    this.errorMessage,
    this.isImageCaptured = false,
    this.isImageSubmitted = false,
    this.navigateNext = false,
    this.scrollDebounceTimer,
    required this.websiteController,
    required this.mobileController,
    required this.otpController,
    this.isOTPSent = false,
    this.isOtpVerified = false,
    this.canResendOTP = false,
    this.timeLeft = 30,
    this.otpError,
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.error,
    required this.sePasswordFormKey,
    this.isSignupSuccess,
    required this.captchaInputController,
    this.captchaInput = '',
    this.isCaptchaValid = false,
    this.isCaptchaSubmitting = false,
    this.isCaptchError,
    this.isCaptchaSend = false,
    this.isCaptchaLoading = false,
    this.captchaImage,
    this.isOtpLoading = false,
    this.isResidenceAddressSameAsAadhar = 1,
    this.isPanDetailsLoading = false,
    this.fullNamePan,
    this.isPanDetailsVerified = false,
    this.isCityAndStateLoading = false,
    this.isCityAndStateVerified = false,
    this.isAgreeToAddressSameAsAadhar = false,
    this.isVerifyPersonalRegisterdInfo = false,
    this.isAadharOTPInvalidate,
    this.showPanNameOverwrittenPopup = false,
    required this.fullNameController,
    required this.familyAndFriendsDescriptionController,
    this.selectedAnnualTurnover,
    this.isCollapsed = false,
    this.isEkycCollapsed = false,
    this.gstLegalName,
    this.isGSTNumberVerify = false,
    required this.iceVerificationKey,
    required this.iceNumberController,
    this.iceCertificateFile,
    this.isIceVerifyingLoading = false,
    this.isLocalDataLoading = false,
    this.isShowServiceDescriptionBox = false,
    this.isDrivingLicenceFrontSideFileDeleted = false,
    this.isDrivingLicenceBackSideFileDeleted = false,
    this.isFrontSideAdharFileDeleted = false,
    this.isBackSideAdharFileDeleted = false,
    this.isVoterIdFrontFileDeleted = false,
    this.isVoterIdBackFileDeleted = false,
    this.isPassportFrontFileDeleted = false,
    this.isPassportBackFileDeleted = false,
    this.isPanFileDataDeleted = false,
    this.isAddressVerificationFileDeleted = false,
    this.isBackAddressVerificationFileDeleted = false,
    this.isGstCertificateFileDeleted = false,
    this.isBankVerificationFileDeleted = false,
    this.isIceCertificateFileDeleted = false,
    this.panDetailsErrorMessage,
    this.personalPanEditAttempts = 0,
    this.isPersonalPanEditLocked = false,
    this.personalPanEditLockTime,
    this.personalPanEditErrorMessage,
    this.isPersonalPanModifiedAfterVerification = false,
    this.isPassportFrontFileUploaded = false,
    this.isVoteridFrontFileUploaded = false,
    this.isDrivingLicenceFrontSideFileUploaded = false,
    this.isFrontSideAdharFileUploaded = false,
    this.isGstNumberVerifyingLoading = false,
    this.mobileNumberFocusNode,
    this.aadharNumberFocusNode,
    this.isFrontSideAddressVerificationFileUploaded = false,
    this.isFrontSideAddressAdharFileUploaded = false,
    this.isMerging = false,
    this.mergeProgress,
    this.mergeStatus,
    this.isIdentityVerificationDataChanged = false,
    this.isPanDetailsDataChanged = false,
    this.isResidentialAddressDataChanged = false,
    this.isAnnualTurnoverDataChanged = false,
    this.isBankAccountDataChanged = false,
    this.isIceVerificationDataChanged = false,
    this.originalAadharNumber,
    this.originalPanNumber,
    this.originalGstNumber,
    this.originalBankAccountNumber,
    required this.personalDbaController,
    this.panOverwriteMismatch = false,
    this.panOverwriteName,
    this.showOverwriteToast = false,
    this.panVerificationSuccess = false,
  });

  @override
  List<Object?> get props => [
    currentStep,
    selectedPurpose,
    selectedProfession,
    scrollController,
    professionOtherController,
    productServiceDescriptionController,
    passwordController.text,
    confirmPasswordController.text,
    personalInfoKey,
    fullName,
    website,
    phoneNumber,
    password,
    selectedEstimatedMonthlyTransaction,
    currencyList,
    selectedCurrencies,
    estimatedMonthlyVolumeList,
    isTransactionDetailLoading,
    isPersonalAccount,
    isOtpSent,
    selectedIDVerificationDocType,
    aadharOtpRemainingTime,
    isAadharOtpTimerRunning,
    currentKycVerificationStep,
    aadharNumberController,
    aadharOtpController,
    aadharNumber,
    isIdVerifiedLoading,
    isIdVerified,
    aadharVerificationFormKey,
    drivingVerificationFormKey,
    drivingLicenceController,
    drivingLicenseNumber,
    isDrivingIdVerifiedLoading,
    isDrivingIdVerified,
    frontSideAdharFile,
    drivingLicenceFrontSideFile,
    backSideAdharFile,
    isIdFileSubmittedLoading,
    voterVerificationFormKey,
    voterIdNumberController,
    voterIDNumber,
    isvoterIdVerifiedLoading,
    isvoterIdVerified,
    voterIdFrontFile,
    voterIdBackFile,
    passportVerificationFormKey,
    passportNumberController,
    passporteNumber,
    ispassportIdVerifiedLoading,
    ispassportIdVerified,
    passportFrontFile,
    passportBackFile,
    panVerificationKey,
    panNameController,
    panNumberController,
    panFileData,
    isPanVerifyingLoading,
    registerAddressFormKey,
    selectedCountry,
    pinCodeController,
    stateNameController,
    cityNameController,
    address1NameController,
    address2NameController,
    selectedAddressVerificationDocType,
    addressVerificationFile,
    backAddressVerificationFile,
    isAddressVerificationLoading,
    annualTurnoverFormKey,
    turnOverController,
    gstNumberController,
    gstCertificateFile,
    isGstCertificateMandatory,
    isGstVerificationLoading,
    personalBankAccountVerificationFormKey,
    bankAccountNumberController,
    reEnterbankAccountNumberController,
    ifscCodeController,
    bankAccountNumber,
    ifscCode,
    accountHolderName,
    selectedBankAccountVerificationDocType,
    bankVerificationFile,
    isBankAccountVerify,
    isBankAccountNumberVerifiedLoading,
    isLoading,
    isReady,
    hasPermission,
    cameraController,
    imageBytes,
    errorMessage,
    isImageCaptured,
    isImageSubmitted,
    navigateNext,
    scrollDebounceTimer,
    websiteController,
    mobileController,
    otpController,
    isOTPSent,
    isOtpVerified,
    canResendOTP,
    timeLeft,
    otpError,
    obscurePassword,
    obscureConfirmPassword,
    error,
    sePasswordFormKey,
    isSignupSuccess,
    captchaInputController,
    captchaInput,
    isCaptchaValid,
    isCaptchaSubmitting,
    isCaptchError,
    isCaptchaSend,
    isDrivingIdVerified,
    isDrivingIdVerifiedLoading,
    isCaptchaLoading,
    captchaImage,
    isOtpLoading,
    isResidenceAddressSameAsAadhar,
    isPanDetailsLoading,
    fullNamePan,
    isPanDetailsVerified,
    isCityAndStateLoading,
    isCityAndStateVerified,
    isAgreeToAddressSameAsAadhar,
    isVerifyPersonalRegisterdInfo,
    fullNameController,
    familyAndFriendsDescriptionController,
    selectedAnnualTurnover,
    isCollapsed,
    isEkycCollapsed,
    showPanNameOverwrittenPopup,
    gstLegalName,
    isGSTNumberVerify,
    iceVerificationKey,
    iceNumberController,
    iceCertificateFile,
    isIceVerifyingLoading,
    isLocalDataLoading,
    isShowServiceDescriptionBox,
    isDrivingLicenceFrontSideFileDeleted,
    isDrivingLicenceBackSideFileDeleted,
    isFrontSideAdharFileDeleted,
    isBackSideAdharFileDeleted,
    isVoterIdFrontFileDeleted,
    isVoterIdBackFileDeleted,
    isPassportFrontFileDeleted,
    isPassportBackFileDeleted,
    isPanFileDataDeleted,
    isAddressVerificationFileDeleted,
    isBackAddressVerificationFileDeleted,
    isGstCertificateFileDeleted,
    isBankVerificationFileDeleted,
    isIceCertificateFileDeleted,
    panDetailsErrorMessage,
    isPassportFrontFileUploaded,
    isVoteridFrontFileUploaded,
    drivingLicenceBackSideFile,
    isDrivingLicenceFrontSideFileUploaded,
    isFrontSideAdharFileUploaded,
    isGstNumberVerifyingLoading,
    isPersonalPanModifiedAfterVerification,
    personalPanEditAttempts,
    isPersonalPanEditLocked,
    personalPanEditLockTime,
    personalPanEditErrorMessage,
    isPersonalPanModifiedAfterVerification,
    isGstNumberVerifyingLoading,
    panNumberFocusNode,
    mobileNumberFocusNode,
    aadharNumberFocusNode,
    isFrontSideAddressVerificationFileUploaded,
    isFrontSideAddressAdharFileUploaded,
    isMerging,
    mergeProgress,
    mergeStatus,
    isIdentityVerificationDataChanged,
    isPanDetailsDataChanged,
    isResidentialAddressDataChanged,
    isAnnualTurnoverDataChanged,
    isBankAccountDataChanged,
    isIceVerificationDataChanged,
    originalAadharNumber,
    originalPanNumber,
    originalGstNumber,
    originalBankAccountNumber,
    personalDbaController,
    panOverwriteMismatch,
    panOverwriteName,
    showOverwriteToast,
    panVerificationSuccess,
  ];

  PersonalAccountSetupState copyWith({
    PersonalAccountSetupSteps? currentStep,
    String? selectedPurpose,
    List<String>? selectedProfession,
    ScrollController? scrollController,
    TextEditingController? professionOtherController,
    TextEditingController? productServiceDescriptionController,
    TextEditingController? passwordController,
    TextEditingController? confirmPasswordController,
    BuildContext? context,
    GlobalKey<FormState>? personalInfoKey,
    String? fullName,
    String? email,
    String? website,
    String? phoneNumber,
    String? password,
    String? selectedEstimatedMonthlyTransaction,
    List<CurrencyModel>? currencyList,
    List<CurrencyModel>? selectedCurrencies,
    List<String>? estimatedMonthlyVolumeList,
    bool? isTransactionDetailLoading,
    bool? isPersonalAccount,
    bool? isOtpSent,
    IDVerificationDocType? selectedIDVerificationDocType,
    int? aadharOtpRemainingTime,
    bool? isAadharOtpTimerRunning,
    PersonalEKycVerificationSteps? currentKycVerificationStep,
    TextEditingController? aadharNumberController,
    TextEditingController? aadharOtpController,
    String? aadharNumber,
    bool? isIdVerifiedLoading,
    bool? isIdVerified,
    bool? isDrivingIdVerifiedLoading,
    bool? isDrivingIdVerified,
    GlobalKey<FormState>? aadharVerificationFormKey,
    GlobalKey<FormState>? drivingVerificationFormKey,
    TextEditingController? drivingLicenceController,
    String? drivingLicenseNumber,
    FileData? drivingLicenceFrontSideFile,
    FileData? drivingLicenceBackSideFile,
    FileData? frontSideAdharFile,
    FileData? backSideAdharFile,
    bool? isIdFileSubmittedLoading,
    GlobalKey<FormState>? voterVerificationFormKey,
    TextEditingController? voterIdNumberController,
    String? voterIDNumber,
    bool? isvoterIdVerifiedLoading,
    bool? isvoterIdVerified,
    FileData? voterIdFrontFile,
    FileData? voterIdBackFile,
    GlobalKey<FormState>? passportVerificationFormKey,
    TextEditingController? passportNumberController,
    String? passporteNumber,
    bool? ispassportIdVerifiedLoading,
    bool? ispassportIdVerified,
    FileData? passportFrontFile,
    FileData? passportBackFile,
    GlobalKey<FormState>? panVerificationKey,
    TextEditingController? panNameController,
    TextEditingController? panNumberController,
    FocusNode? panNumberFocusNode,
    FileData? panFileData,
    bool? isPanVerifyingLoading,
    GlobalKey<FormState>? registerAddressFormKey,
    Country? selectedCountry,
    TextEditingController? pinCodeController,
    TextEditingController? stateNameController,
    TextEditingController? cityNameController,
    TextEditingController? address1NameController,
    TextEditingController? address2NameController,
    String? selectedAddressVerificationDocType,
    FileData? addressVerificationFile,
    FileData? backAddressVerificationFile,
    bool? isAddressVerificationLoading,
    GlobalKey<FormState>? annualTurnoverFormKey,
    TextEditingController? turnOverController,
    TextEditingController? gstNumberController,
    FileData? gstCertificateFile,
    bool? isGstCertificateMandatory,
    bool? isGstVerificationLoading,
    GlobalKey<FormState>? personalBankAccountVerificationFormKey,
    TextEditingController? bankAccountNumberController,
    TextEditingController? reEnterbankAccountNumberController,
    TextEditingController? ifscCodeController,
    String? bankAccountNumber,
    String? ifscCode,
    String? accountHolderName,
    String? selectedBankAccountVerificationDocType,
    FileData? bankVerificationFile,
    bool? isBankAccountVerify,
    bool? isBankAccountNumberVerifiedLoading,
    bool? isLoading,
    bool? isReady,
    bool? hasPermission,
    CameraController? cameraController,
    Uint8List? imageBytes,
    String? errorMessage,
    bool? isImageCaptured,
    bool? isImageSubmitted,
    bool? navigateNext,
    Timer? scrollDebounceTimer,
    TextEditingController? websiteController,
    TextEditingController? mobileController,
    TextEditingController? otpController,
    bool? isOTPSent,
    bool? isOtpVerified,
    bool? canResendOTP,
    int? timeLeft,
    String? otpError,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    String? error,
    GlobalKey<FormState>? sePasswordFormKey,
    bool? isSignupSuccess,
    bool? isSignupLoading,
    bool? isSignupError,
    TextEditingController? captchaInputController,
    String? captchaInput,
    bool? isCaptchaValid,
    bool? isCaptchaSubmitting,
    String? isCaptchError,
    bool? isCaptchaSend,
    bool? isCaptchaLoading,
    String? captchaImage,
    bool? isOtpLoading,
    int? isResidenceAddressSameAsAadhar,
    bool? isPanDetailsLoading,
    String? fullNamePan,
    bool? isPanDetailsVerified,
    bool? isCityAndStateLoading,
    bool? isCityAndStateVerified,
    bool? isAgreeToAddressSameAsAadhar,
    bool? isVerifyPersonalRegisterdInfo,
    String? isAadharOTPInvalidate,
    bool? showPanNameOverwrittenPopup,
    TextEditingController? fullNameController,
    TextEditingController? familyAndFriendsDescriptionController,
    String? selectedAnnualTurnover,
    bool? isCollapsed,
    bool? isEkycCollapsed,
    String? gstLegalName,
    bool? isGSTNumberVerify,
    GlobalKey<FormState>? iceVerificationKey,
    TextEditingController? iceNumberController,
    FileData? iceCertificateFile,
    bool? isIceVerifyingLoading,
    bool? isLocalDataLoading,
    bool? isShowServiceDescriptionBox,
    bool? isDrivingLicenceFrontSideFileDeleted,
    bool? isDrivingLicenceBackSideFileDeleted,
    bool? isFrontSideAdharFileDeleted,
    bool? isBackSideAdharFileDeleted,
    bool? isVoterIdFrontFileDeleted,
    bool? isVoterIdBackFileDeleted,
    bool? isPassportFrontFileDeleted,
    bool? isPassportBackFileDeleted,
    bool? isPanFileDataDeleted,
    bool? isAddressVerificationFileDeleted,
    bool? isBackAddressVerificationFileDeleted,
    bool? isGstCertificateFileDeleted,
    bool? isBankVerificationFileDeleted,
    bool? isIceCertificateFileDeleted,
    String? panDetailsErrorMessage,
    int? personalPanEditAttempts,
    bool? isPersonalPanEditLocked,
    DateTime? personalPanEditLockTime,
    String? personalPanEditErrorMessage,
    bool? isPersonalPanModifiedAfterVerification,
    bool? isPassportFrontFileUploaded,
    bool? isVoteridFrontFileUploaded,
    bool? isDrivingLicenceFrontSideFileUploaded,
    bool? isFrontSideAdharFileUploaded,
    bool? isGstNumberVerifyingLoading,
    FocusNode? mobileNumberFocusNode,
    FocusNode? aadharNumberFocusNode,
    bool? isFrontSideAddressVerificationFileUploaded,
    bool? isFrontSideAddressAdharFileUploaded,
    bool? isMerging,
    double? mergeProgress,
    String? mergeStatus,
    bool? isIdentityVerificationDataChanged,
    bool? isPanDetailsDataChanged,
    bool? isResidentialAddressDataChanged,
    bool? isAnnualTurnoverDataChanged,
    bool? isBankAccountDataChanged,
    bool? isIceVerificationDataChanged,
    String? originalAadharNumber,
    String? originalPanNumber,
    String? originalGstNumber,
    String? originalBankAccountNumber,
    TextEditingController? personalDbaController,
    bool? panOverwriteMismatch,
    String? panOverwriteName,
    bool? showOverwriteToast,
    bool? panVerificationSuccess,
  }) {
    return PersonalAccountSetupState(
      currentStep: currentStep ?? this.currentStep,
      selectedPurpose: selectedPurpose ?? this.selectedPurpose,
      selectedProfession: selectedProfession ?? this.selectedProfession,
      scrollController: scrollController ?? this.scrollController,
      professionOtherController: professionOtherController ?? this.professionOtherController,
      productServiceDescriptionController:
          productServiceDescriptionController ?? this.productServiceDescriptionController,
      passwordController: passwordController ?? this.passwordController,
      confirmPasswordController: confirmPasswordController ?? this.confirmPasswordController,
      context: context ?? this.context,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      website: website ?? this.website,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      selectedEstimatedMonthlyTransaction:
          selectedEstimatedMonthlyTransaction ?? this.selectedEstimatedMonthlyTransaction,
      currencyList: currencyList ?? this.currencyList,
      selectedCurrencies: selectedCurrencies ?? this.selectedCurrencies,
      estimatedMonthlyVolumeList: estimatedMonthlyVolumeList ?? this.estimatedMonthlyVolumeList,
      isTransactionDetailLoading: isTransactionDetailLoading ?? this.isTransactionDetailLoading,
      isPersonalAccount: isPersonalAccount ?? this.isPersonalAccount,
      isOtpSent: isOtpSent ?? this.isOtpSent,
      selectedIDVerificationDocType: selectedIDVerificationDocType ?? this.selectedIDVerificationDocType,
      aadharOtpRemainingTime: aadharOtpRemainingTime ?? this.aadharOtpRemainingTime,
      isAadharOtpTimerRunning: isAadharOtpTimerRunning ?? this.isAadharOtpTimerRunning,
      currentKycVerificationStep: currentKycVerificationStep ?? this.currentKycVerificationStep,
      aadharNumberController: aadharNumberController ?? this.aadharNumberController,
      aadharOtpController: aadharOtpController ?? this.aadharOtpController,
      aadharNumber: aadharNumber ?? this.aadharNumber,
      isIdVerifiedLoading: isIdVerifiedLoading ?? this.isIdVerifiedLoading,
      isIdVerified: isIdVerified ?? this.isIdVerified,
      aadharVerificationFormKey: aadharVerificationFormKey ?? this.aadharVerificationFormKey,
      drivingVerificationFormKey: drivingVerificationFormKey ?? this.drivingVerificationFormKey,
      drivingLicenceController: drivingLicenceController ?? this.drivingLicenceController,
      drivingLicenseNumber: drivingLicenseNumber ?? this.drivingLicenseNumber,
      drivingLicenceFrontSideFile:
          (isDrivingLicenceFrontSideFileDeleted == true)
              ? (drivingLicenceFrontSideFile)
              : (drivingLicenceFrontSideFile ?? this.drivingLicenceFrontSideFile),
      drivingLicenceBackSideFile:
          (isDrivingLicenceFrontSideFileDeleted == true)
              ? (drivingLicenceBackSideFile)
              : (drivingLicenceBackSideFile ?? this.drivingLicenceBackSideFile),
      frontSideAdharFile:
          (isFrontSideAdharFileDeleted == true)
              ? (frontSideAdharFile)
              : (frontSideAdharFile ?? this.frontSideAdharFile),
      backSideAdharFile:
          (isBackSideAdharFileDeleted == true) ? (backSideAdharFile) : (backSideAdharFile ?? this.backSideAdharFile),
      isIdFileSubmittedLoading: isIdFileSubmittedLoading ?? this.isIdFileSubmittedLoading,
      voterVerificationFormKey: voterVerificationFormKey ?? this.voterVerificationFormKey,
      voterIdNumberController: voterIdNumberController ?? this.voterIdNumberController,
      voterIDNumber: voterIDNumber ?? this.voterIDNumber,
      isvoterIdVerifiedLoading: isvoterIdVerifiedLoading ?? this.isvoterIdVerifiedLoading,
      isvoterIdVerified: isvoterIdVerified ?? this.isvoterIdVerified,
      voterIdFrontFile:
          (isVoterIdFrontFileDeleted == true) ? (voterIdFrontFile) : (voterIdFrontFile ?? this.voterIdFrontFile),
      voterIdBackFile:
          (isVoterIdBackFileDeleted == true) ? (voterIdBackFile) : (voterIdBackFile ?? this.voterIdBackFile),
      passportVerificationFormKey: passportVerificationFormKey ?? this.passportVerificationFormKey,
      passportNumberController: passportNumberController ?? this.passportNumberController,
      passporteNumber: passporteNumber ?? this.passporteNumber,
      ispassportIdVerifiedLoading: ispassportIdVerifiedLoading ?? this.ispassportIdVerifiedLoading,
      ispassportIdVerified: ispassportIdVerified ?? this.ispassportIdVerified,
      passportFrontFile:
          (isPassportFrontFileDeleted == true) ? (passportFrontFile) : (passportFrontFile ?? this.passportFrontFile),
      passportBackFile:
          (isPassportBackFileDeleted == true) ? (passportBackFile) : (passportBackFile ?? this.passportBackFile),
      panVerificationKey: panVerificationKey ?? this.panVerificationKey,
      panNameController: panNameController ?? this.panNameController,
      panNumberController: panNumberController ?? this.panNumberController,
      panNumberFocusNode: panNumberFocusNode ?? this.panNumberFocusNode,
      panFileData: (isPanFileDataDeleted == true) ? (panFileData) : (panFileData ?? this.panFileData),
      isPanVerifyingLoading: isPanVerifyingLoading ?? this.isPanVerifyingLoading,
      registerAddressFormKey: registerAddressFormKey ?? this.registerAddressFormKey,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      pinCodeController: pinCodeController ?? this.pinCodeController,
      stateNameController: stateNameController ?? this.stateNameController,
      cityNameController: cityNameController ?? this.cityNameController,
      address1NameController: address1NameController ?? this.address1NameController,
      address2NameController: address2NameController ?? this.address2NameController,
      selectedAddressVerificationDocType: selectedAddressVerificationDocType ?? this.selectedAddressVerificationDocType,
      addressVerificationFile:
          (isAddressVerificationFileDeleted == true)
              ? (addressVerificationFile)
              : (addressVerificationFile ?? this.addressVerificationFile),
      backAddressVerificationFile:
          (isBackAddressVerificationFileDeleted == true)
              ? (backAddressVerificationFile)
              : (backAddressVerificationFile ?? this.backAddressVerificationFile),
      isAddressVerificationLoading: isAddressVerificationLoading ?? this.isAddressVerificationLoading,
      annualTurnoverFormKey: annualTurnoverFormKey ?? this.annualTurnoverFormKey,
      turnOverController: turnOverController ?? this.turnOverController,
      gstNumberController: gstNumberController ?? this.gstNumberController,
      gstCertificateFile:
          (isGstCertificateFileDeleted == true)
              ? (gstCertificateFile)
              : (gstCertificateFile ?? this.gstCertificateFile),
      isGstCertificateMandatory: isGstCertificateMandatory ?? this.isGstCertificateMandatory,
      isGstVerificationLoading: isGstVerificationLoading ?? this.isGstVerificationLoading,
      personalBankAccountVerificationFormKey:
          personalBankAccountVerificationFormKey ?? this.personalBankAccountVerificationFormKey,
      bankAccountNumberController: bankAccountNumberController ?? this.bankAccountNumberController,
      reEnterbankAccountNumberController: reEnterbankAccountNumberController ?? this.reEnterbankAccountNumberController,
      ifscCodeController: ifscCodeController ?? this.ifscCodeController,
      bankAccountNumber: bankAccountNumber ?? this.bankAccountNumber,
      bankVerificationFile:
          (isBankVerificationFileDeleted == true)
              ? (bankVerificationFile)
              : (bankVerificationFile ?? this.bankVerificationFile),
      ifscCode: ifscCode ?? this.ifscCode,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      selectedBankAccountVerificationDocType:
          selectedBankAccountVerificationDocType ?? this.selectedBankAccountVerificationDocType,
      isBankAccountVerify: isBankAccountVerify ?? this.isBankAccountVerify,
      isBankAccountNumberVerifiedLoading: isBankAccountNumberVerifiedLoading ?? this.isBankAccountNumberVerifiedLoading,
      isLoading: isLoading ?? this.isLoading,
      isReady: isReady ?? this.isReady,
      hasPermission: hasPermission ?? this.hasPermission,
      cameraController: cameraController ?? this.cameraController,
      imageBytes: imageBytes,
      errorMessage: errorMessage,
      isImageCaptured: isImageCaptured ?? this.isImageCaptured,
      isImageSubmitted: isImageSubmitted ?? this.isImageSubmitted,
      navigateNext: navigateNext ?? this.navigateNext,
      scrollDebounceTimer: scrollDebounceTimer ?? this.scrollDebounceTimer,
      websiteController: websiteController ?? this.websiteController,
      mobileController: mobileController ?? this.mobileController,
      otpController: otpController ?? this.otpController,
      isOTPSent: isOTPSent ?? this.isOTPSent,
      isOtpVerified: isOtpVerified ?? this.isOtpVerified,
      canResendOTP: canResendOTP ?? this.canResendOTP,
      timeLeft: timeLeft ?? this.timeLeft,
      otpError: otpError ?? this.otpError,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword: obscureConfirmPassword ?? this.obscureConfirmPassword,
      error: error ?? this.error,
      personalInfoKey: personalInfoKey ?? this.personalInfoKey,
      sePasswordFormKey: sePasswordFormKey ?? this.sePasswordFormKey,
      isSignupSuccess: isSignupSuccess ?? this.isSignupSuccess,
      captchaInputController: captchaInputController ?? this.captchaInputController,
      captchaInput: captchaInput ?? this.captchaInput,
      isCaptchaValid: isCaptchaValid ?? this.isCaptchaValid,
      isCaptchaSubmitting: isCaptchaSubmitting ?? this.isCaptchaSubmitting,
      isCaptchError: isCaptchError ?? this.isCaptchError,
      isCaptchaSend: isCaptchaSend ?? this.isCaptchaSend,
      isDrivingIdVerified: isDrivingIdVerified ?? this.isDrivingIdVerified,
      isDrivingIdVerifiedLoading: isDrivingIdVerifiedLoading ?? this.isDrivingIdVerifiedLoading,
      isCaptchaLoading: isCaptchaLoading ?? this.isCaptchaLoading,
      captchaImage: captchaImage ?? this.captchaImage,
      isOtpLoading: isOtpLoading ?? this.isOtpLoading,
      isResidenceAddressSameAsAadhar: isResidenceAddressSameAsAadhar ?? this.isResidenceAddressSameAsAadhar,
      isPanDetailsLoading: isPanDetailsLoading ?? this.isPanDetailsLoading,
      fullNamePan: fullNamePan ?? this.fullNamePan,
      isPanDetailsVerified: isPanDetailsVerified ?? this.isPanDetailsVerified,
      isCityAndStateLoading: isCityAndStateLoading ?? this.isCityAndStateLoading,
      isCityAndStateVerified: isCityAndStateVerified ?? this.isCityAndStateVerified,
      isAgreeToAddressSameAsAadhar: isAgreeToAddressSameAsAadhar ?? this.isAgreeToAddressSameAsAadhar,
      isVerifyPersonalRegisterdInfo: isVerifyPersonalRegisterdInfo ?? this.isVerifyPersonalRegisterdInfo,
      isAadharOTPInvalidate: isAadharOTPInvalidate ?? this.isAadharOTPInvalidate,
      fullNameController: fullNameController ?? this.fullNameController,
      familyAndFriendsDescriptionController:
          familyAndFriendsDescriptionController ?? this.familyAndFriendsDescriptionController,
      selectedAnnualTurnover: selectedAnnualTurnover ?? this.selectedAnnualTurnover,
      isCollapsed: isCollapsed ?? this.isCollapsed,
      isEkycCollapsed: isEkycCollapsed ?? this.isEkycCollapsed,
      showPanNameOverwrittenPopup: showPanNameOverwrittenPopup ?? this.showPanNameOverwrittenPopup,
      gstLegalName: gstLegalName ?? this.gstLegalName,
      isGSTNumberVerify: isGSTNumberVerify ?? this.isGSTNumberVerify,
      iceVerificationKey: iceVerificationKey ?? this.iceVerificationKey,
      iceNumberController: iceNumberController ?? this.iceNumberController,
      iceCertificateFile:
          (isIceCertificateFileDeleted == true)
              ? (iceCertificateFile)
              : (iceCertificateFile ?? this.iceCertificateFile),
      isIceVerifyingLoading: isIceVerifyingLoading ?? this.isIceVerifyingLoading,
      isLocalDataLoading: isLocalDataLoading ?? this.isLocalDataLoading,
      isShowServiceDescriptionBox: isShowServiceDescriptionBox ?? this.isShowServiceDescriptionBox,
      isDrivingLicenceFrontSideFileDeleted:
          isDrivingLicenceFrontSideFileDeleted ?? this.isDrivingLicenceFrontSideFileDeleted,
      isDrivingLicenceBackSideFileDeleted:
          isDrivingLicenceBackSideFileDeleted ?? this.isDrivingLicenceBackSideFileDeleted,
      isFrontSideAdharFileDeleted: isFrontSideAdharFileDeleted ?? this.isFrontSideAdharFileDeleted,
      isBackSideAdharFileDeleted: isBackSideAdharFileDeleted ?? this.isBackSideAdharFileDeleted,
      isVoterIdFrontFileDeleted: isVoterIdFrontFileDeleted ?? this.isVoterIdFrontFileDeleted,
      isVoterIdBackFileDeleted: isVoterIdBackFileDeleted ?? this.isVoterIdBackFileDeleted,
      isPassportFrontFileDeleted: isPassportFrontFileDeleted ?? this.isPassportFrontFileDeleted,
      isPassportBackFileDeleted: isPassportBackFileDeleted ?? this.isPassportBackFileDeleted,
      isPanFileDataDeleted: isPanFileDataDeleted ?? this.isPanFileDataDeleted,
      isAddressVerificationFileDeleted: isAddressVerificationFileDeleted ?? this.isAddressVerificationFileDeleted,
      isBackAddressVerificationFileDeleted:
          isBackAddressVerificationFileDeleted ?? this.isBackAddressVerificationFileDeleted,
      isGstCertificateFileDeleted: isGstCertificateFileDeleted ?? this.isGstCertificateFileDeleted,
      isBankVerificationFileDeleted: isBankVerificationFileDeleted ?? this.isBankVerificationFileDeleted,
      isIceCertificateFileDeleted: isIceCertificateFileDeleted ?? this.isIceCertificateFileDeleted,
      panDetailsErrorMessage: panDetailsErrorMessage ?? this.panDetailsErrorMessage,
      personalPanEditAttempts: personalPanEditAttempts ?? this.personalPanEditAttempts,
      isPersonalPanEditLocked: isPersonalPanEditLocked ?? this.isPersonalPanEditLocked,
      personalPanEditLockTime: personalPanEditLockTime ?? this.personalPanEditLockTime,
      personalPanEditErrorMessage: personalPanEditErrorMessage ?? this.personalPanEditErrorMessage,
      isPersonalPanModifiedAfterVerification:
          isPersonalPanModifiedAfterVerification ?? this.isPersonalPanModifiedAfterVerification,
      isPassportFrontFileUploaded: isPassportFrontFileUploaded ?? this.isPassportFrontFileUploaded,
      isVoteridFrontFileUploaded: isVoteridFrontFileUploaded ?? this.isVoteridFrontFileUploaded,
      isDrivingLicenceFrontSideFileUploaded:
          isDrivingLicenceFrontSideFileUploaded ?? this.isDrivingLicenceFrontSideFileUploaded,
      isFrontSideAdharFileUploaded: isFrontSideAdharFileUploaded ?? this.isFrontSideAdharFileUploaded,
      isGstNumberVerifyingLoading: isGstNumberVerifyingLoading ?? this.isGstNumberVerifyingLoading,
      mobileNumberFocusNode: mobileNumberFocusNode ?? this.mobileNumberFocusNode,
      aadharNumberFocusNode: aadharNumberFocusNode ?? this.aadharNumberFocusNode,
      isFrontSideAddressVerificationFileUploaded:
          isFrontSideAddressVerificationFileUploaded ?? this.isFrontSideAddressVerificationFileUploaded,
      isFrontSideAddressAdharFileUploaded:
          isFrontSideAddressAdharFileUploaded ?? this.isFrontSideAddressAdharFileUploaded,
      isMerging: isMerging ?? this.isMerging,
      mergeProgress: mergeProgress ?? this.mergeProgress,
      mergeStatus: mergeStatus ?? this.mergeStatus,
      isIdentityVerificationDataChanged: isIdentityVerificationDataChanged ?? this.isIdentityVerificationDataChanged,
      isPanDetailsDataChanged: isPanDetailsDataChanged ?? this.isPanDetailsDataChanged,
      isResidentialAddressDataChanged: isResidentialAddressDataChanged ?? this.isResidentialAddressDataChanged,
      isAnnualTurnoverDataChanged: isAnnualTurnoverDataChanged ?? this.isAnnualTurnoverDataChanged,
      isBankAccountDataChanged: isBankAccountDataChanged ?? this.isBankAccountDataChanged,
      isIceVerificationDataChanged: isIceVerificationDataChanged ?? this.isIceVerificationDataChanged,
      originalAadharNumber: originalAadharNumber ?? this.originalAadharNumber,
      originalPanNumber: originalPanNumber ?? this.originalPanNumber,
      originalGstNumber: originalGstNumber ?? this.originalGstNumber,
      originalBankAccountNumber: originalBankAccountNumber ?? this.originalBankAccountNumber,
      personalDbaController: personalDbaController ?? this.personalDbaController,
      panOverwriteMismatch: panOverwriteMismatch ?? this.panOverwriteMismatch,
      panOverwriteName: panOverwriteName ?? this.panOverwriteName,
      showOverwriteToast: showOverwriteToast ?? this.showOverwriteToast,
      panVerificationSuccess: panVerificationSuccess ?? this.panVerificationSuccess,
    );
  }
}
