part of 'personal_account_setup_bloc.dart';

abstract class PersonalAccountSetupEvent extends Equatable {
  const PersonalAccountSetupEvent();

  @override
  List<Object?> get props => [];
}

class LoadInitialState extends PersonalAccountSetupEvent {
  @override
  List<Object> get props => [];
}

class PersonalUpdateIdVerificationDocType extends PersonalAccountSetupEvent {
  final IDVerificationDocType docType;

  const PersonalUpdateIdVerificationDocType(this.docType);
  @override
  List<Object> get props => [docType];
}

class PersonalKycStepChange extends PersonalAccountSetupEvent {
  final PersonalEKycVerificationSteps stepIndex;
  const PersonalKycStepChange(this.stepIndex);
  @override
  List<Object> get props => [stepIndex];
}

class PersonalSendAadharOtp extends PersonalAccountSetupEvent {
  final String aadhar;
  final String captcha;
  final String sessionId;
  const PersonalSendAadharOtp({required this.aadhar, required this.captcha, required this.sessionId});
  @override
  List<Object> get props => [aadhar, captcha, sessionId];
}

class ChangeOtpSentStatus extends PersonalAccountSetupEvent {
  final bool isOtpSent;
  const ChangeOtpSentStatus(this.isOtpSent);
  @override
  List<Object> get props => [isOtpSent];
}

class AadharSendOtpPressed extends PersonalAccountSetupEvent {
  @override
  List<Object> get props => [];
}

class AadharOtpTimerTicked extends PersonalAccountSetupEvent {
  final int remainingTime;
  const AadharOtpTimerTicked(this.remainingTime);
  @override
  List<Object> get props => [remainingTime];
}

class PersonalAadharNumbeVerified extends PersonalAccountSetupEvent {
  final String aadharNumber;
  final String otp;
  const PersonalAadharNumbeVerified({required this.aadharNumber, required this.otp});
  @override
  List<Object> get props => [aadharNumber, otp];
}

class PersonalDrivingLicenceVerified extends PersonalAccountSetupEvent {
  final String drivingLicence;
  const PersonalDrivingLicenceVerified(this.drivingLicence);
  @override
  List<Object> get props => [drivingLicence];
}

class PersonalFrontSlideAadharCardUpload extends PersonalAccountSetupEvent {
  final FileData? fileData;
  const PersonalFrontSlideAadharCardUpload(this.fileData);
  @override
  List<Object?> get props => [fileData];
}

class PersonalBackSlideAadharCardUpload extends PersonalAccountSetupEvent {
  final FileData? fileData;
  const PersonalBackSlideAadharCardUpload(this.fileData);
  @override
  List<Object?> get props => [fileData];
}

class PersonalAadharFileUploadSubmitted extends PersonalAccountSetupEvent {
  final FileData? frontAadharFileData;
  final FileData? backAadharFileData;
  const PersonalAadharFileUploadSubmitted({this.frontAadharFileData, this.backAadharFileData});
  @override
  List<Object?> get props => [frontAadharFileData, backAadharFileData];
}

class PersonalFrontSlideDrivingLicenceUpload extends PersonalAccountSetupEvent {
  final FileData? fileData;
  const PersonalFrontSlideDrivingLicenceUpload(this.fileData);
  @override
  List<Object?> get props => [fileData];
}

class PersonalBackSlideDrivingLicenceUpload extends PersonalAccountSetupEvent {
  final FileData? fileData;
  const PersonalBackSlideDrivingLicenceUpload(this.fileData);
  @override
  List<Object?> get props => [fileData];
}

class PersonalDrivingFileUploadSubmitted extends PersonalAccountSetupEvent {
  final FileData? frontDrivingLicenceFileData;
  final FileData? backDrivingLicenceFileData;
  const PersonalDrivingFileUploadSubmitted({this.frontDrivingLicenceFileData, this.backDrivingLicenceFileData});
  @override
  List<Object?> get props => [frontDrivingLicenceFileData, backDrivingLicenceFileData];
}

class PersonalVoterIdVerified extends PersonalAccountSetupEvent {
  final String voterId;
  const PersonalVoterIdVerified(this.voterId);
  @override
  List<Object> get props => [voterId];
}

class PersonalVoterIdFileUploadSubmitted extends PersonalAccountSetupEvent {
  final FileData? voterIdFrontFileData;
  final FileData? voterIdBackFileData;
  const PersonalVoterIdFileUploadSubmitted({this.voterIdFrontFileData, this.voterIdBackFileData});
  @override
  List<Object?> get props => [voterIdFrontFileData, voterIdBackFileData];
}

class PersonalVoterIdFrontFileUpload extends PersonalAccountSetupEvent {
  final FileData? fileData;
  const PersonalVoterIdFrontFileUpload(this.fileData);
  @override
  List<Object?> get props => [fileData];
}

class PersonalVoterIdBackFileUpload extends PersonalAccountSetupEvent {
  final FileData? fileData;
  const PersonalVoterIdBackFileUpload(this.fileData);
  @override
  List<Object?> get props => [fileData];
}

class PersonalPassportVerified extends PersonalAccountSetupEvent {
  final String passportNumber;
  const PersonalPassportVerified(this.passportNumber);
  @override
  List<Object> get props => [passportNumber];
}

class PersonalPassportFileUploadSubmitted extends PersonalAccountSetupEvent {
  final FileData? passportFrontFileData;
  final FileData? passportBackFileData;
  const PersonalPassportFileUploadSubmitted({this.passportFrontFileData, this.passportBackFileData});
  @override
  List<Object?> get props => [passportFrontFileData, passportBackFileData];
}

class PersonalPassportFrontFileUpload extends PersonalAccountSetupEvent {
  final FileData? fileData;
  const PersonalPassportFrontFileUpload(this.fileData);
  @override
  List<Object?> get props => [fileData];
}

class PersonalPassportBackFileUpload extends PersonalAccountSetupEvent {
  final FileData? fileData;
  const PersonalPassportBackFileUpload(this.fileData);
  @override
  List<Object?> get props => [fileData];
}

class PersonalUploadPanCard extends PersonalAccountSetupEvent {
  final FileData? fileData;
  const PersonalUploadPanCard(this.fileData);
  @override
  List<Object?> get props => [fileData];
}

class PersonalPanVerificationSubmitted extends PersonalAccountSetupEvent {
  final FileData? fileData;
  final String panName;
  final String panNumber;
  const PersonalPanVerificationSubmitted({this.fileData, required this.panName, required this.panNumber});
  @override
  List<Object?> get props => [fileData, panName, panNumber];
}

class PersonalUpdateSelectedCountry extends PersonalAccountSetupEvent {
  final Country country;
  const PersonalUpdateSelectedCountry({required this.country});
  @override
  List<Object> get props => [country];
}

class PersonalUpdateAddressVerificationDocType extends PersonalAccountSetupEvent {
  final String? docType;
  const PersonalUpdateAddressVerificationDocType(this.docType);
  @override
  List<Object?> get props => [docType];
}

class PersonalUploadAddressVerificationFile extends PersonalAccountSetupEvent {
  final FileData? fileData;
  const PersonalUploadAddressVerificationFile({required this.fileData});
  @override
  List<Object?> get props => [fileData];
}

class PersonalUploadBackAddressVerificationFile extends PersonalAccountSetupEvent {
  final FileData? fileData;
  const PersonalUploadBackAddressVerificationFile({required this.fileData});
  @override
  List<Object?> get props => [fileData];
}

class PersonalRegisterAddressSubmitted extends PersonalAccountSetupEvent {
  final FileData? addressValidateFileData;
  final FileData? backValiateFileData;
  final bool isAddharCard;
  final String docType;

  const PersonalRegisterAddressSubmitted({
    required this.addressValidateFileData,
    required this.isAddharCard,
    this.backValiateFileData,
    required this.docType,
  });
  @override
  List<Object?> get props => [addressValidateFileData, isAddharCard, backValiateFileData, docType];
}

class PersonalUploadGstCertificateFile extends PersonalAccountSetupEvent {
  final FileData? fileData;

  const PersonalUploadGstCertificateFile({required this.fileData});
  @override
  List<Object?> get props => [fileData];
}

class PersonalAnnualTurnOverVerificationSubmitted extends PersonalAccountSetupEvent {
  final String gstNumber;
  final FileData? gstCertificate;

  const PersonalAnnualTurnOverVerificationSubmitted({required this.gstNumber, this.gstCertificate});
  @override
  List<Object?> get props => [gstNumber, gstCertificate];
}

class PersonalGSTVerification extends PersonalAccountSetupEvent {
  final String turnover;
  final String gstNumber;

  const PersonalGSTVerification({required this.turnover, required this.gstNumber});
  @override
  List<Object?> get props => [turnover, gstNumber];
}

class PersonalBankAccountNumberVerify extends PersonalAccountSetupEvent {
  final String accountNumber;
  final String ifscCode;

  const PersonalBankAccountNumberVerify({required this.accountNumber, required this.ifscCode});
  @override
  List<Object> get props => [accountNumber, ifscCode];
}

class PersonalUpdateBankAccountVerificationDocType extends PersonalAccountSetupEvent {
  final String? selectedType;

  const PersonalUpdateBankAccountVerificationDocType(this.selectedType);
  @override
  List<Object?> get props => [selectedType];
}

class PersonalUploadBankAccountVerificationFile extends PersonalAccountSetupEvent {
  final FileData? fileData;

  const PersonalUploadBankAccountVerificationFile({required this.fileData});
  @override
  List<Object?> get props => [fileData];
}

class PersonalBankAccountDetailSubmitted extends PersonalAccountSetupEvent {
  final FileData bankAccountVerifyFile;
  final String? documentType;
  final BuildContext context;

  const PersonalBankAccountDetailSubmitted({
    required this.bankAccountVerifyFile,
    this.documentType,
    required this.context,
  });
  @override
  List<Object?> get props => [bankAccountVerifyFile, documentType, context];
}

// class InitializeSelfieEvent extends PersonalAccountSetupEvent {
//   @override
//   List<Object> get props => [];
// }

// class CaptureImageEvent extends PersonalAccountSetupEvent {
//   @override
//   List<Object> get props => [];
// }

// class RetakeImageEvent extends PersonalAccountSetupEvent {
//   @override
//   List<Object> get props => [];
// }

// class SubmitImageEvent extends PersonalAccountSetupEvent {
//   @override
//   List<Object> get props => [];
// }

// class RequestPermissionEvent extends PersonalAccountSetupEvent {
//   @override
//   List<Object> get props => [];
// }

// class DisposeSelfieEvent extends PersonalAccountSetupEvent {
//   @override
//   List<Object> get props => [];
// }

class PersonalInfoStepChanged extends PersonalAccountSetupEvent {
  final PersonalAccountSetupSteps step;
  const PersonalInfoStepChanged(this.step);
  @override
  List<Object> get props => [step];
}

class NextStep extends PersonalAccountSetupEvent {
  const NextStep();
  @override
  List<Object> get props => [];
}

class PreviousStepEvent extends PersonalAccountSetupEvent {
  const PreviousStepEvent();
  @override
  List<Object> get props => [];
}

class ChangePurpose extends PersonalAccountSetupEvent {
  final String purpose;
  const ChangePurpose(this.purpose);
  @override
  List<Object> get props => [purpose];
}

class ChangeProfession extends PersonalAccountSetupEvent {
  final String profession;
  const ChangeProfession(this.profession);
  @override
  List<Object> get props => [profession];
}

class UpdatePersonalDetails extends PersonalAccountSetupEvent {
  final String fullName;
  // final String email;
  final String? website;
  final String phoneNumber;

  const UpdatePersonalDetails({
    required this.fullName,
    // required this.email,
    this.website,
    required this.phoneNumber,
  });
  @override
  List<Object> get props => [fullName, website!, phoneNumber];
}

class PersonalPasswordSubmitted extends PersonalAccountSetupEvent {
  @override
  List<Object> get props => [];
}

class PersonalChangeEstimatedMonthlyTransaction extends PersonalAccountSetupEvent {
  final String transactionAmount;
  const PersonalChangeEstimatedMonthlyTransaction(this.transactionAmount);
  @override
  List<Object> get props => [transactionAmount];
}

class PersonalToggleCurrencySelection extends PersonalAccountSetupEvent {
  final CurrencyModel currency;
  const PersonalToggleCurrencySelection(this.currency);
  @override
  List<Object> get props => [currency];
}

class PersonalTransactionDetailSubmitted extends PersonalAccountSetupEvent {
  final List<CurrencyModel> currencyList;
  final String monthlyTransaction;

  const PersonalTransactionDetailSubmitted({required this.currencyList, required this.monthlyTransaction});
  @override
  List<Object> get props => [currencyList, monthlyTransaction];
}

class PersonalScrollToPosition extends PersonalAccountSetupEvent {
  final GlobalKey key;
  final ScrollController? scrollController;

  const PersonalScrollToPosition(this.key, {this.scrollController});

  @override
  List<Object?> get props => [key, scrollController];
}

class SendOTP extends PersonalAccountSetupEvent {
  @override
  List<Object> get props => [];
}

class ChangePersonalMobileNumberPressed extends PersonalAccountSetupEvent {
  const ChangePersonalMobileNumberPressed();

  @override
  List<Object> get props => [];
}

class UpdateOTPError extends PersonalAccountSetupEvent {
  final String error;
  const UpdateOTPError(this.error);
  @override
  List<Object> get props => [error];
}

class ConfirmAndContinue extends PersonalAccountSetupEvent {
  @override
  List<Object> get props => [];
}

class UpdateResendTimerState extends PersonalAccountSetupEvent {
  final int? timeLeft;
  final bool? canResend;

  const UpdateResendTimerState({this.timeLeft, this.canResend});

  @override
  List<Object?> get props => [timeLeft, canResend];
}

class TogglePasswordVisibility extends PersonalAccountSetupEvent {
  const TogglePasswordVisibility();
  @override
  List<Object> get props => [];
}

class ToggleConfirmPasswordVisibility extends PersonalAccountSetupEvent {
  const ToggleConfirmPasswordVisibility();
  @override
  List<Object> get props => [];
}

class PasswordChanged extends PersonalAccountSetupEvent {
  final String password;

  const PasswordChanged({required this.password});

  @override
  List<Object?> get props => [password];
}

class ConfirmPasswordChanged extends PersonalAccountSetupEvent {
  final String password;

  const ConfirmPasswordChanged({required this.password});

  @override
  List<Object?> get props => [password];
}

class PersonalResetData extends PersonalAccountSetupEvent {
  const PersonalResetData();
  @override
  List<Object> get props => [];
}

class PersonalResetSignupSuccess extends PersonalAccountSetupEvent {
  const PersonalResetSignupSuccess();
  @override
  List<Object> get props => [];
}

class GetPersonalCurrencyOptions extends PersonalAccountSetupEvent {
  const GetPersonalCurrencyOptions();
  @override
  List<Object> get props => [];
}

class CaptchaSend extends PersonalAccountSetupEvent {
  const CaptchaSend();
  @override
  List<Object> get props => [];
}

class ReCaptchaSend extends PersonalAccountSetupEvent {
  const ReCaptchaSend();
  @override
  List<Object> get props => [];
}

class PersonalClearIdentityVerificationFields extends PersonalAccountSetupEvent {
  @override
  List<Object?> get props => [];
}

class ResidenceAddressSameAsAadhar extends PersonalAccountSetupEvent {
  final int sameAddressSelected;
  const ResidenceAddressSameAsAadhar(this.sameAddressSelected);
  @override
  List<Object> get props => [sameAddressSelected];
}

class GetPanDetails extends PersonalAccountSetupEvent {
  final String panNumber;
  const GetPanDetails(this.panNumber);
  @override
  List<Object?> get props => [];
}

class PersonalPanNumberChanged extends PersonalAccountSetupEvent {
  final String panNumber;
  const PersonalPanNumberChanged(this.panNumber);
  @override
  List<Object?> get props => [panNumber];
}

class PersonalPanEditAttempt extends PersonalAccountSetupEvent {
  const PersonalPanEditAttempt();
}

class PersonalAadharNumberChanged extends PersonalAccountSetupEvent {
  final String newAadharNumber;
  const PersonalAadharNumberChanged(this.newAadharNumber);
}

class GetCityAndState extends PersonalAccountSetupEvent {
  final String pinCode;
  const GetCityAndState(this.pinCode);
  @override
  List<Object?> get props => [pinCode];
}

class ChangeAgreeToAddressSameAsAadhar extends PersonalAccountSetupEvent {
  final bool isAgree;
  const ChangeAgreeToAddressSameAsAadhar(this.isAgree);
  @override
  List<Object?> get props => [isAgree];
}

class PersonalChangeAnnualTurnover extends PersonalAccountSetupEvent {
  final String selectedIndex;
  const PersonalChangeAnnualTurnover(this.selectedIndex);
  @override
  List<Object> get props => [selectedIndex];
}

class PersonalAppBarCollapseChanged extends PersonalAccountSetupEvent {
  final bool isCollapsed;
  const PersonalAppBarCollapseChanged(this.isCollapsed);
}

class PersonalEkycAppBarCollapseChanged extends PersonalAccountSetupEvent {
  final bool isCollapsed;
  const PersonalEkycAppBarCollapseChanged(this.isCollapsed);
  @override
  List<Object> get props => [isCollapsed];
}

class PanNameOverwritePopupDismissed extends PersonalAccountSetupEvent {
  const PanNameOverwritePopupDismissed();
}

class PersonalUploadICECertificate extends PersonalAccountSetupEvent {
  final FileData? fileData;
  const PersonalUploadICECertificate(this.fileData);
  @override
  List<Object?> get props => [fileData];
}

class PersonalICEVerificationSubmitted extends PersonalAccountSetupEvent {
  final FileData? fileData;
  final String? iceNumber;
  const PersonalICEVerificationSubmitted({this.fileData, this.iceNumber});
  @override
  List<Object?> get props => [fileData, iceNumber];
}

class LoadPersonalKycFromLocal extends PersonalAccountSetupEvent {
  final Completer<void>? completer;
  const LoadPersonalKycFromLocal([this.completer]);
}

class LoadFilesFromApi extends PersonalAccountSetupEvent {
  final Map<String, dynamic> userData;
  const LoadFilesFromApi(this.userData);
  @override
  List<Object> get props => [userData];
}

class PersonalChangeShowDescription extends PersonalAccountSetupEvent {
  final bool isShowDescriptionbox;
  const PersonalChangeShowDescription(this.isShowDescriptionbox);
  @override
  List<Object> get props => [isShowDescriptionbox];
}

class PersonalEnableAadharEdit extends PersonalAccountSetupEvent {
  const PersonalEnableAadharEdit();
  @override
  List<Object> get props => [];
}

// Data change tracking events
class PersonalMarkIdentityVerificationDataChanged extends PersonalAccountSetupEvent {
  const PersonalMarkIdentityVerificationDataChanged();
  @override
  List<Object> get props => [];
}

class PersonalMarkPanDetailsDataChanged extends PersonalAccountSetupEvent {
  const PersonalMarkPanDetailsDataChanged();
  @override
  List<Object> get props => [];
}

class PersonalMarkResidentialAddressDataChanged extends PersonalAccountSetupEvent {
  const PersonalMarkResidentialAddressDataChanged();
  @override
  List<Object> get props => [];
}

class PersonalMarkAnnualTurnoverDataChanged extends PersonalAccountSetupEvent {
  const PersonalMarkAnnualTurnoverDataChanged();
  @override
  List<Object> get props => [];
}

class PersonalMarkBankAccountDataChanged extends PersonalAccountSetupEvent {
  const PersonalMarkBankAccountDataChanged();
  @override
  List<Object> get props => [];
}

class PersonalMarkIceVerificationDataChanged extends PersonalAccountSetupEvent {
  const PersonalMarkIceVerificationDataChanged();
  @override
  List<Object> get props => [];
}

class PersonalResetDataChangeFlags extends PersonalAccountSetupEvent {
  const PersonalResetDataChangeFlags();
  @override
  List<Object> get props => [];
}

class PersonalMergeProgress extends PersonalAccountSetupEvent {
  final double progress; // 0.0 - 1.0
  final String status;
  const PersonalMergeProgress({required this.progress, required this.status});
  @override
  List<Object> get props => [progress, status];
}

// Original value storage events
class PersonalStoreOriginalAadharNumber extends PersonalAccountSetupEvent {
  final String originalNumber;
  const PersonalStoreOriginalAadharNumber(this.originalNumber);
  @override
  List<Object> get props => [originalNumber];
}

class PersonalStoreOriginalPanNumber extends PersonalAccountSetupEvent {
  final String originalNumber;
  const PersonalStoreOriginalPanNumber(this.originalNumber);
  @override
  List<Object> get props => [originalNumber];
}

class PersonalStoreOriginalGstNumber extends PersonalAccountSetupEvent {
  final String originalNumber;
  const PersonalStoreOriginalGstNumber(this.originalNumber);
  @override
  List<Object> get props => [originalNumber];
}

class PersonalStoreOriginalBankAccountNumber extends PersonalAccountSetupEvent {
  final String originalNumber;
  const PersonalStoreOriginalBankAccountNumber(this.originalNumber);
  @override
  List<Object> get props => [originalNumber];
}


class PersonalConfirmOverwrite extends PersonalAccountSetupEvent {
  const PersonalConfirmOverwrite();
}

class PersonalOverwriteToastAcknowledged extends PersonalAccountSetupEvent {
  const PersonalOverwriteToastAcknowledged();
}

class ShowOverwriteToast extends PersonalAccountSetupEvent {
  const ShowOverwriteToast();
  @override
  List<Object?> get props => [];
}
