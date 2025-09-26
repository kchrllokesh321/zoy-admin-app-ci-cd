part of 'business_account_setup_bloc.dart';

abstract class BusinessAccountSetupEvent extends Equatable {
  const BusinessAccountSetupEvent();

  @override
  List<Object?> get props => [];
}

class LoadInitialState extends BusinessAccountSetupEvent {}

class StepChanged extends BusinessAccountSetupEvent {
  final BusinessAccountSetupSteps stepIndex;
  const StepChanged(this.stepIndex);
  @override
  List<Object> get props => [stepIndex];
}

class ChangeBusinessEntityType extends BusinessAccountSetupEvent {
  final String selectedIndex;
  const ChangeBusinessEntityType(this.selectedIndex);
  @override
  List<Object> get props => [selectedIndex];
}

class ChangeAnnualTurnover extends BusinessAccountSetupEvent {
  final String selectedIndex;
  const ChangeAnnualTurnover(this.selectedIndex);
  @override
  List<Object> get props => [selectedIndex];
}

class ChangeBusinessMainActivity extends BusinessAccountSetupEvent {
  final BusinessMainActivity selected;

  const ChangeBusinessMainActivity(this.selected);
  @override
  List<Object> get props => [selected];
}

class ChangeBusinessGoodsExport extends BusinessAccountSetupEvent {
  final String selectedIndex;
  const ChangeBusinessGoodsExport(this.selectedIndex);
  @override
  List<Object> get props => [selectedIndex];
}

class ChangeBusinessServicesExport extends BusinessAccountSetupEvent {
  final String selectedIndex;
  const ChangeBusinessServicesExport(this.selectedIndex);
  @override
  List<Object> get props => [selectedIndex];
}

class BusinessSendOtpPressed extends BusinessAccountSetupEvent {}

class BusinessOtpTimerTicked extends BusinessAccountSetupEvent {
  final int remainingTime;
  const BusinessOtpTimerTicked(this.remainingTime);
  @override
  List<Object> get props => [remainingTime];
}

class ChangeMobileNumberPressed extends BusinessAccountSetupEvent {
  const ChangeMobileNumberPressed();

  @override
  List<Object> get props => [];
}

class ChangeCreatePasswordVisibility extends BusinessAccountSetupEvent {
  final bool obscuredText;
  const ChangeCreatePasswordVisibility({required this.obscuredText});
  @override
  List<Object> get props => [obscuredText];
}

class ChangeConfirmPasswordVisibility extends BusinessAccountSetupEvent {
  final bool obscuredText;
  const ChangeConfirmPasswordVisibility({required this.obscuredText});
  @override
  List<Object> get props => [obscuredText];
}

class BusinessAccountSignUpSubmitted extends BusinessAccountSetupEvent {}

class ResetSignupSuccess extends BusinessAccountSetupEvent {}

class SendBusinessInfoOtp extends BusinessAccountSetupEvent {
  final String phoneNumber;
  const SendBusinessInfoOtp(this.phoneNumber);
  @override
  List<Object> get props => [phoneNumber];
}

class ChangeBusinessInfoOtpSentStatus extends BusinessAccountSetupEvent {
  final bool isOtpSent;
  const ChangeBusinessInfoOtpSentStatus(this.isOtpSent);
  @override
  List<Object> get props => [isOtpSent];
}

class KycStepChanged extends BusinessAccountSetupEvent {
  final KycVerificationSteps stepIndex;
  const KycStepChanged(this.stepIndex);
  @override
  List<Object> get props => [stepIndex];
}

class SendAadharOtp extends BusinessAccountSetupEvent {
  final String aadhar;
  final String captcha;
  final String sessionId;
  const SendAadharOtp(this.aadhar, this.captcha, this.sessionId);
  @override
  List<Object> get props => [aadhar, captcha, sessionId];
}

class ChangeOtpSentStatus extends BusinessAccountSetupEvent {
  final bool isOtpSent;
  const ChangeOtpSentStatus(this.isOtpSent);
  @override
  List<Object> get props => [isOtpSent];
}

class KartaSendAadharOtp extends BusinessAccountSetupEvent {
  final String aadhar;
  final String captcha;
  final String sessionId;
  const KartaSendAadharOtp({required this.aadhar, required this.captcha, required this.sessionId});
  @override
  List<Object> get props => [aadhar, captcha, sessionId];
}

class KartaChangeOtpSentStatus extends BusinessAccountSetupEvent {
  final bool isOtpSent;
  const KartaChangeOtpSentStatus(this.isOtpSent);
  @override
  List<Object> get props => [isOtpSent];
}

class AadharSendOtpPressed extends BusinessAccountSetupEvent {
  @override
  List<Object> get props => [];
}

class AadharOtpTimerTicked extends BusinessAccountSetupEvent {
  final int remainingTime;
  const AadharOtpTimerTicked(this.remainingTime);
  @override
  List<Object> get props => [remainingTime];
}

class AadharNumbeVerified extends BusinessAccountSetupEvent {
  final String aadharNumber;
  final String otp;
  const AadharNumbeVerified(this.aadharNumber, this.otp);
  @override
  List<Object> get props => [aadharNumber, otp];
}

class FrontSlideAadharCardUpload extends BusinessAccountSetupEvent {
  final FileData? fileData;
  const FrontSlideAadharCardUpload(this.fileData);
  @override
  List<Object> get props => [fileData!];
}

class BackSlideAadharCardUpload extends BusinessAccountSetupEvent {
  final FileData? fileData;
  const BackSlideAadharCardUpload(this.fileData);
  @override
  List<Object> get props => [fileData!];
}

class AadharFileUploadSubmitted extends BusinessAccountSetupEvent {
  final FileData? frontAadharFileData;
  final FileData? backAadharFileData;
  const AadharFileUploadSubmitted({this.frontAadharFileData, this.backAadharFileData});
  @override
  List<Object> get props => [frontAadharFileData!, backAadharFileData!];
}

class KartaAadharSendOtpPressed extends BusinessAccountSetupEvent {
  @override
  List<Object> get props => [];
}

class KartaAadharOtpTimerTicked extends BusinessAccountSetupEvent {
  final int remainingTime;
  const KartaAadharOtpTimerTicked(this.remainingTime);
  @override
  List<Object> get props => [remainingTime];
}

class KartaAadharNumbeVerified extends BusinessAccountSetupEvent {
  final String aadharNumber;
  final String otp;
  const KartaAadharNumbeVerified(this.aadharNumber, this.otp);
  @override
  List<Object> get props => [aadharNumber, otp];
}

class KartaFrontSlideAadharCardUpload extends BusinessAccountSetupEvent {
  final FileData? fileData;
  const KartaFrontSlideAadharCardUpload(this.fileData);
  @override
  List<Object> get props => [fileData!];
}

class KartaBackSlideAadharCardUpload extends BusinessAccountSetupEvent {
  final FileData? fileData;
  const KartaBackSlideAadharCardUpload(this.fileData);
  @override
  List<Object> get props => [fileData!];
}

class KartaAadharFileUploadSubmitted extends BusinessAccountSetupEvent {
  final FileData? frontAadharFileData;
  final FileData? backAadharFileData;
  const KartaAadharFileUploadSubmitted({this.frontAadharFileData, this.backAadharFileData});
  @override
  List<Object> get props => [frontAadharFileData!, backAadharFileData!];
}

class UploadHUFPanCard extends BusinessAccountSetupEvent {
  final FileData? fileData;
  const UploadHUFPanCard(this.fileData);
  @override
  List<Object> get props => [fileData!];
}

class HUFPanVerificationSubmitted extends BusinessAccountSetupEvent {
  final FileData? fileData;
  final String? panNumber;
  const HUFPanVerificationSubmitted({this.fileData, this.panNumber});
  @override
  List<Object> get props => [fileData!, panNumber!];
}

class ChangeSelectedPanUploadOption extends BusinessAccountSetupEvent {
  final String? panUploadOption;
  const ChangeSelectedPanUploadOption({required this.panUploadOption});
  @override
  List<Object> get props => [panUploadOption!];
}

class BusinessUploadPanCard extends BusinessAccountSetupEvent {
  final FileData? fileData;
  const BusinessUploadPanCard(this.fileData);
  @override
  List<Object> get props => [fileData!];
}

class Director1UploadPanCard extends BusinessAccountSetupEvent {
  final FileData? fileData;
  const Director1UploadPanCard(this.fileData);
  @override
  List<Object> get props => [fileData!];
}

class Director2UploadPanCard extends BusinessAccountSetupEvent {
  final FileData? fileData;
  const Director2UploadPanCard(this.fileData);

  @override
  List<Object> get props => [fileData!];
}

class SaveBusinessPanDetails extends BusinessAccountSetupEvent {
  final FileData? fileData;
  final String? panNumber;
  final String? panName;
  const SaveBusinessPanDetails({this.fileData, this.panNumber, this.panName});
  @override
  List<Object> get props => [fileData!, panNumber!, panName!];
}

class SaveDirectorPanDetails extends BusinessAccountSetupEvent {
  final FileData? director1fileData;
  final String? director1panName;
  final String? director1panNumber;
  const SaveDirectorPanDetails({this.director1fileData, this.director1panName, this.director1panNumber});
  @override
  List<Object> get props => [director1fileData!, director1panName!, director1panNumber!];
}

class ChangeDirector1IsBeneficialOwner extends BusinessAccountSetupEvent {
  final bool isSelected;
  const ChangeDirector1IsBeneficialOwner({required this.isSelected});
  @override
  List<Object> get props => [isSelected];
}

class ChangeDirector1IsBusinessRepresentative extends BusinessAccountSetupEvent {
  final bool isSelected;
  const ChangeDirector1IsBusinessRepresentative({required this.isSelected});
  @override
  List<Object> get props => [isSelected];
}

class ChangeDirector2IsBeneficialOwner extends BusinessAccountSetupEvent {
  final bool isSelected;
  const ChangeDirector2IsBeneficialOwner({required this.isSelected});
  @override
  List<Object> get props => [isSelected];
}

class ChangeDirector2IsBusinessRepresentative extends BusinessAccountSetupEvent {
  final bool isSelected;
  const ChangeDirector2IsBusinessRepresentative({required this.isSelected});
  @override
  List<Object> get props => [isSelected];
}

class BeneficialOwnerUploadPanCard extends BusinessAccountSetupEvent {
  final FileData? fileData;
  const BeneficialOwnerUploadPanCard(this.fileData);

  @override
  List<Object> get props => [fileData!];
}

class ChangeBeneficialOwnerIsDirector extends BusinessAccountSetupEvent {
  final bool isSelected;
  const ChangeBeneficialOwnerIsDirector({required this.isSelected});
  @override
  List<Object> get props => [isSelected];
}

class ChangeBeneficialOwnerIsBusinessRepresentative extends BusinessAccountSetupEvent {
  final bool isSelected;
  const ChangeBeneficialOwnerIsBusinessRepresentative({required this.isSelected});
  @override
  List<Object> get props => [isSelected];
}

class SaveBeneficialOwnerPanDetails extends BusinessAccountSetupEvent {
  final FileData? fileData;
  final String? panNumber;
  final String? panName;
  const SaveBeneficialOwnerPanDetails({this.fileData, this.panNumber, this.panName});
  @override
  List<Object> get props => [fileData!, panNumber!, panName!];
}

class BusinessRepresentativeUploadPanCard extends BusinessAccountSetupEvent {
  final FileData? fileData;
  const BusinessRepresentativeUploadPanCard(this.fileData);
  @override
  List<Object> get props => [fileData!];
}

class ChangeBusinessReresentativeOwnerIsDirector extends BusinessAccountSetupEvent {
  final bool isSelected;
  const ChangeBusinessReresentativeOwnerIsDirector({required this.isSelected});
  @override
  List<Object> get props => [isSelected];
}

class ChangeBusinessReresentativeIsBeneficialOwner extends BusinessAccountSetupEvent {
  final bool isSelected;
  const ChangeBusinessReresentativeIsBeneficialOwner({required this.isSelected});
  @override
  List<Object> get props => [isSelected];
}

class SaveBusinessRepresentativePanDetails extends BusinessAccountSetupEvent {
  final FileData? fileData;
  final String? panNumber;
  final String? panName;
  const SaveBusinessRepresentativePanDetails({this.fileData, this.panNumber, this.panName});
  @override
  List<Object> get props => [fileData!, panNumber!, panName!];
}

class VerifyPanSubmitted extends BusinessAccountSetupEvent {
  const VerifyPanSubmitted();
}

class UpdateSelectedCountry extends BusinessAccountSetupEvent {
  final Country country;

  const UpdateSelectedCountry({required this.country});
  @override
  List<Object> get props => [country];
}

class UploadAddressVerificationFile extends BusinessAccountSetupEvent {
  final FileData? fileData;

  const UploadAddressVerificationFile({this.fileData});
  @override
  List<Object> get props => [fileData!];
}

class UpdateAddressVerificationDocType extends BusinessAccountSetupEvent {
  final String docType;

  const UpdateAddressVerificationDocType(this.docType);
  @override
  List<Object> get props => [docType];
}

class RegisterAddressSubmitted extends BusinessAccountSetupEvent {
  final FileData? addressValidateFileData;
  final String? docType;

  const RegisterAddressSubmitted({this.addressValidateFileData, this.docType});
  @override
  List<Object> get props => [addressValidateFileData!, docType!];
}

class AnnualTurnOverVerificationSubmitted extends BusinessAccountSetupEvent {
  final String? turnover;
  final String? gstNumber;
  final FileData? gstCertificate;

  const AnnualTurnOverVerificationSubmitted({this.turnover, this.gstNumber, this.gstCertificate});
  @override
  List<Object> get props => [turnover!, gstNumber!, gstCertificate!];
}

class UploadGstCertificateFile extends BusinessAccountSetupEvent {
  final FileData? fileData;
  const UploadGstCertificateFile({this.fileData});
  @override
  List<Object> get props => [fileData!];
}

class IceNumberChanged extends BusinessAccountSetupEvent {
  final String iceNumber;
  const IceNumberChanged(this.iceNumber);
}

class UploadICECertificate extends BusinessAccountSetupEvent {
  final FileData? fileData;
  const UploadICECertificate(this.fileData);
  @override
  List<Object> get props => [fileData!];
}

class ICEVerificationSubmitted extends BusinessAccountSetupEvent {
  final FileData? fileData;
  final String? iceNumber;
  const ICEVerificationSubmitted({this.fileData, this.iceNumber});
  @override
  List<Object> get props => [fileData!, iceNumber!];
}

class UploadCOICertificate extends BusinessAccountSetupEvent {
  final FileData? fileData;
  const UploadCOICertificate(this.fileData);
  @override
  List<Object> get props => [fileData!];
}

class UploadLLPAgreement extends BusinessAccountSetupEvent {
  final FileData? fileData;
  const UploadLLPAgreement(this.fileData);
  @override
  List<Object> get props => [fileData!];
}

class UploadPartnershipDeed extends BusinessAccountSetupEvent {
  final FileData? fileData;
  const UploadPartnershipDeed(this.fileData);
  @override
  List<Object> get props => [fileData!];
}

class CINVerificationSubmitted extends BusinessAccountSetupEvent {
  final FileData? fileData;
  final String? cinNumber;
  const CINVerificationSubmitted({this.fileData, this.cinNumber});
  @override
  List<Object> get props => [fileData!, cinNumber!];
}

class UploadBankAccountVerificationFile extends BusinessAccountSetupEvent {
  final FileData? fileData;

  const UploadBankAccountVerificationFile({this.fileData});
  @override
  List<Object> get props => [fileData!];
}

class UpdateBankAccountVerificationDocType extends BusinessAccountSetupEvent {
  final String docType;

  const UpdateBankAccountVerificationDocType(this.docType);
  @override
  List<Object> get props => [docType];
}

class BankAccountNumberVerify extends BusinessAccountSetupEvent {
  final String accountNumber;
  final String ifscCode;
  const BankAccountNumberVerify({required this.accountNumber, required this.ifscCode});
  @override
  List<Object> get props => [accountNumber, ifscCode];
}

class BankAccountDetailSubmitted extends BusinessAccountSetupEvent {
  final String? docType;
  final FileData bankAccountVerifyFile;
  final BuildContext context;
  const BankAccountDetailSubmitted({this.docType, required this.bankAccountVerifyFile, required this.context});
  @override
  List<Object> get props => [docType!, bankAccountVerifyFile, context];
}

class ChangeEstimatedMonthlyTransaction extends BusinessAccountSetupEvent {
  final String selectedTransaction;
  const ChangeEstimatedMonthlyTransaction(this.selectedTransaction);
  @override
  List<Object> get props => [selectedTransaction];
}

class ToggleCurrencySelection extends BusinessAccountSetupEvent {
  final CurrencyModel currency;

  const ToggleCurrencySelection(this.currency);
  @override
  List<Object> get props => [currency];
}

class BusinessTranscationDetailSubmitted extends BusinessAccountSetupEvent {
  final List<CurrencyModel> curruncyList;
  final String monthlyTranscation;

  const BusinessTranscationDetailSubmitted({required this.curruncyList, required this.monthlyTranscation});
  @override
  List<Object> get props => [curruncyList, monthlyTranscation];
}

class ScrollToSection extends BusinessAccountSetupEvent {
  final GlobalKey key;
  final ScrollController? scrollController;

  const ScrollToSection(this.key, {this.scrollController});

  @override
  List<Object> get props => [key];
}

class CancelScrollDebounce extends BusinessAccountSetupEvent {
  @override
  List<Object> get props => [];
}

class ResetData extends BusinessAccountSetupEvent {
  @override
  List<Object> get props => [];
}

class ValidateBusinessOtp extends BusinessAccountSetupEvent {
  final String phoneNumber;
  final String otp;
  const ValidateBusinessOtp({required this.phoneNumber, required this.otp});
  @override
  List<Object> get props => [phoneNumber, otp];
}

class UpdateBusinessNatureString extends BusinessAccountSetupEvent {
  final String businessNatureString;
  const UpdateBusinessNatureString(this.businessNatureString);
  @override
  List<Object> get props => [businessNatureString];
}

class GetBusinessCurrencyOptions extends BusinessAccountSetupEvent {
  @override
  List<Object> get props => [];
}

class BusinessAppBarCollapseChanged extends BusinessAccountSetupEvent {
  final bool isCollapsed;
  const BusinessAppBarCollapseChanged(this.isCollapsed);
  @override
  List<Object> get props => [isCollapsed];
}

class BusinessEkycAppBarCollapseChanged extends BusinessAccountSetupEvent {
  final bool isCollapsed;
  const BusinessEkycAppBarCollapseChanged(this.isCollapsed);
  @override
  List<Object> get props => [isCollapsed];
}

class DirectorCaptchaSend extends BusinessAccountSetupEvent {
  const DirectorCaptchaSend();
  @override
  List<Object> get props => [];
}

class DirectorReCaptchaSend extends BusinessAccountSetupEvent {
  const DirectorReCaptchaSend();
  @override
  List<Object> get props => [];
}

class KartaCaptchaSend extends BusinessAccountSetupEvent {
  const KartaCaptchaSend();
  @override
  List<Object> get props => [];
}

class KartaReCaptchaSend extends BusinessAccountSetupEvent {
  const KartaReCaptchaSend();
  @override
  List<Object> get props => [];
}

class PartnerSendAadharOtp extends BusinessAccountSetupEvent {
  final String aadhar;
  final String captcha;
  final String sessionId;
  const PartnerSendAadharOtp({required this.aadhar, required this.captcha, required this.sessionId});
  @override
  List<Object> get props => [aadhar, captcha, sessionId];
}

class PartnerChangeOtpSentStatus extends BusinessAccountSetupEvent {
  final bool isOtpSent;
  const PartnerChangeOtpSentStatus(this.isOtpSent);
  @override
  List<Object> get props => [isOtpSent];
}

class PartnerAadharSendOtpPressed extends BusinessAccountSetupEvent {
  @override
  List<Object> get props => [];
}

class PartnerAadharOtpTimerTicked extends BusinessAccountSetupEvent {
  final int remainingTime;
  const PartnerAadharOtpTimerTicked(this.remainingTime);
  @override
  List<Object> get props => [remainingTime];
}

class PartnerAadharNumbeVerified extends BusinessAccountSetupEvent {
  final String aadharNumber;
  final String otp;
  const PartnerAadharNumbeVerified(this.aadharNumber, this.otp);
  @override
  List<Object> get props => [aadharNumber, otp];
}

class PartnerFrontSlideAadharCardUpload extends BusinessAccountSetupEvent {
  final FileData? fileData;
  const PartnerFrontSlideAadharCardUpload(this.fileData);
  @override
  List<Object> get props => [fileData!];
}

class PartnerBackSlideAadharCardUpload extends BusinessAccountSetupEvent {
  final FileData? fileData;
  const PartnerBackSlideAadharCardUpload(this.fileData);
  @override
  List<Object> get props => [fileData!];
}

class PartnerAadharFileUploadSubmitted extends BusinessAccountSetupEvent {
  final FileData? frontAadharFileData;
  final FileData? backAadharFileData;
  const PartnerAadharFileUploadSubmitted({this.frontAadharFileData, this.backAadharFileData});
  @override
  List<Object> get props => [frontAadharFileData!, backAadharFileData!];
}

class PartnerCaptchaSend extends BusinessAccountSetupEvent {}

class PartnerReCaptchaSend extends BusinessAccountSetupEvent {}

class ProprietorSendAadharOtp extends BusinessAccountSetupEvent {
  final String aadhar;
  final String captcha;
  final String sessionId;
  const ProprietorSendAadharOtp({required this.aadhar, required this.captcha, required this.sessionId});
  @override
  List<Object> get props => [aadhar, captcha, sessionId];
}

class ProprietorChangeOtpSentStatus extends BusinessAccountSetupEvent {
  final bool isOtpSent;
  const ProprietorChangeOtpSentStatus(this.isOtpSent);
  @override
  List<Object> get props => [isOtpSent];
}

class ProprietorAadharSendOtpPressed extends BusinessAccountSetupEvent {
  @override
  List<Object> get props => [];
}

class ProprietorAadharOtpTimerTicked extends BusinessAccountSetupEvent {
  final int remainingTime;
  const ProprietorAadharOtpTimerTicked(this.remainingTime);
  @override
  List<Object> get props => [remainingTime];
}

class ProprietorAadharNumbeVerified extends BusinessAccountSetupEvent {
  final String aadharNumber;
  final String otp;
  const ProprietorAadharNumbeVerified(this.aadharNumber, this.otp);
  @override
  List<Object> get props => [aadharNumber, otp];
}

class ProprietorFrontSlideAadharCardUpload extends BusinessAccountSetupEvent {
  final FileData? fileData;
  const ProprietorFrontSlideAadharCardUpload(this.fileData);
  @override
  List<Object> get props => [fileData!];
}

class ProprietorBackSlideAadharCardUpload extends BusinessAccountSetupEvent {
  final FileData? fileData;
  const ProprietorBackSlideAadharCardUpload(this.fileData);
  @override
  List<Object> get props => [fileData!];
}

class ProprietorAadharFileUploadSubmitted extends BusinessAccountSetupEvent {
  final FileData? frontAadharFileData;
  final FileData? backAadharFileData;
  const ProprietorAadharFileUploadSubmitted({this.frontAadharFileData, this.backAadharFileData});
  @override
  List<Object> get props => [frontAadharFileData!, backAadharFileData!];
}

class ProprietorCaptchaSend extends BusinessAccountSetupEvent {}

class ProprietorReCaptchaSend extends BusinessAccountSetupEvent {}

class DirectorAadharNumberChanged extends BusinessAccountSetupEvent {
  final String newAadharNumber;
  const DirectorAadharNumberChanged(this.newAadharNumber);
}

class KartaAadharNumberChanged extends BusinessAccountSetupEvent {
  final String newAadharNumber;
  const KartaAadharNumberChanged(this.newAadharNumber);
}

class PartnerAadharNumberChanged extends BusinessAccountSetupEvent {
  final String newAadharNumber;
  const PartnerAadharNumberChanged(this.newAadharNumber);
}

class ProprietorAadharNumberChanged extends BusinessAccountSetupEvent {
  final String newAadharNumber;
  const ProprietorAadharNumberChanged(this.newAadharNumber);
}

class LoadBusinessKycFromLocal extends BusinessAccountSetupEvent {
  final Completer<void>? completer;
  const LoadBusinessKycFromLocal([this.completer]);
}

class BusinessGetCityAndState extends BusinessAccountSetupEvent {
  final String pinCode;
  const BusinessGetCityAndState(this.pinCode);
}

class LLPINVerificationSubmitted extends BusinessAccountSetupEvent {
  final FileData? coifile;
  final FileData? llpfile;
  final String? llpinNumber;
  const LLPINVerificationSubmitted({this.coifile, this.llpfile, this.llpinNumber});
  @override
  List<Object> get props => [coifile!, llpfile!, llpinNumber!];
}

class PartnerShipDeedVerificationSubmitted extends BusinessAccountSetupEvent {
  final FileData? partnerShipDeedDoc;
  const PartnerShipDeedVerificationSubmitted({this.partnerShipDeedDoc});
  @override
  List<Object> get props => [partnerShipDeedDoc!];
}

class BusinessGSTVerification extends BusinessAccountSetupEvent {
  final String turnover;
  final String gstNumber;

  const BusinessGSTVerification({required this.turnover, required this.gstNumber});
  @override
  List<Object> get props => [turnover, gstNumber];
}

class GetHUFPanDetails extends BusinessAccountSetupEvent {
  final String panNumber;
  const GetHUFPanDetails(this.panNumber);
}

class HUFPanNumberChanged extends BusinessAccountSetupEvent {
  final String panNumber;
  const HUFPanNumberChanged(this.panNumber);
}

class GetDirector1PanDetails extends BusinessAccountSetupEvent {
  final String panNumber;
  const GetDirector1PanDetails(this.panNumber);
}

class Director1PanNumberChanged extends BusinessAccountSetupEvent {
  final String panNumber;
  const Director1PanNumberChanged(this.panNumber);
}

class GetDirector2PanDetails extends BusinessAccountSetupEvent {
  final String panNumber;
  const GetDirector2PanDetails(this.panNumber);
}

class Director2PanNumberChanged extends BusinessAccountSetupEvent {
  final String panNumber;
  const Director2PanNumberChanged(this.panNumber);
}

class GetBeneficialOwnerPanDetails extends BusinessAccountSetupEvent {
  final String panNumber;
  const GetBeneficialOwnerPanDetails(this.panNumber);
}

class BeneficialOwnerPanNumberChanged extends BusinessAccountSetupEvent {
  final String panNumber;
  const BeneficialOwnerPanNumberChanged(this.panNumber);
}

// class GetBusinessRepresentativePanDetails extends BusinessAccountSetupEvent {
//   final String panNumber;
//   const GetBusinessRepresentativePanDetails(this.panNumber);
// }

// class BusinessRepresentativePanNumberChanged extends BusinessAccountSetupEvent {
//   final String panNumber;
//   const BusinessRepresentativePanNumberChanged(this.panNumber);
// }

class ContactInformationSubmitted extends BusinessAccountSetupEvent {
  final String mobileNumber;
  final String emailId;
  const ContactInformationSubmitted({required this.mobileNumber, required this.emailId});
}

class SaveOtherDirectorPanDetails extends BusinessAccountSetupEvent {
  final FileData? director2fileData;
  final String? directorpanName;
  final String? director2panNumber;
  const SaveOtherDirectorPanDetails({this.director2fileData, this.directorpanName, this.director2panNumber});
  @override
  List<Object> get props => [director2fileData!, directorpanName!, director2panNumber!];
}

// Other Director Aadhar Events
class OtherDirectorAadharNumberChanged extends BusinessAccountSetupEvent {
  final String aadharNumber;
  const OtherDirectorAadharNumberChanged(this.aadharNumber);
  @override
  List<Object> get props => [aadharNumber];
}

class OtherDirectorCaptchaSend extends BusinessAccountSetupEvent {
  const OtherDirectorCaptchaSend();
}

class OtherDirectorReCaptchaSend extends BusinessAccountSetupEvent {
  const OtherDirectorReCaptchaSend();
}

class OtherDirectorSendAadharOtp extends BusinessAccountSetupEvent {
  final String aadharNumber;
  final String captchaInput;
  final String sessionId;
  const OtherDirectorSendAadharOtp(this.aadharNumber, this.captchaInput, this.sessionId);
  @override
  List<Object> get props => [aadharNumber, captchaInput, sessionId];
}

class OtherDirectorAadharNumbeVerified extends BusinessAccountSetupEvent {
  final String aadharNumber;
  final String otp;
  const OtherDirectorAadharNumbeVerified(this.aadharNumber, this.otp);
  @override
  List<Object> get props => [aadharNumber, otp];
}

class OtherDirectorFrontSlideAadharCardUpload extends BusinessAccountSetupEvent {
  final FileData? fileData;
  const OtherDirectorFrontSlideAadharCardUpload(this.fileData);
  @override
  List<Object> get props => [fileData!];
}

class OtherDirectorBackSlideAadharCardUpload extends BusinessAccountSetupEvent {
  final FileData? fileData;
  const OtherDirectorBackSlideAadharCardUpload(this.fileData);
  @override
  List<Object> get props => [fileData!];
}

class OtherDirectorAadharFileUploadSubmitted extends BusinessAccountSetupEvent {
  const OtherDirectorAadharFileUploadSubmitted();
  @override
  List<Object> get props => [];
}

class OtherDirectorAadharSendOtpPressed extends BusinessAccountSetupEvent {
  @override
  List<Object> get props => [];
}

class OtherDirectorAadharOtpTimerTicked extends BusinessAccountSetupEvent {
  final int remainingTime;
  const OtherDirectorAadharOtpTimerTicked(this.remainingTime);
  @override
  List<Object> get props => [remainingTime];
}

class DirectorKycStepChanged extends BusinessAccountSetupEvent {
  final DirectorKycSteps stepIndex;
  const DirectorKycStepChanged(this.stepIndex);
  @override
  List<Object> get props => [stepIndex];
}

class OtherDirectorKycStepChanged extends BusinessAccountSetupEvent {
  final OtherDirectorKycSteps stepIndex;
  const OtherDirectorKycStepChanged(this.stepIndex);
  @override
  List<Object> get props => [stepIndex];
}

class ShowBusinessRepresentativeSelectionDialog extends BusinessAccountSetupEvent {
  const ShowBusinessRepresentativeSelectionDialog();
  @override
  List<Object> get props => [];
}

class SelectBusinessRepresentative extends BusinessAccountSetupEvent {
  final String selectedOption;
  const SelectBusinessRepresentative(this.selectedOption);
  @override
  List<Object> get props => [selectedOption];
}

class OtherDirectorShowDialogWidthoutAadharUpload extends BusinessAccountSetupEvent {
  const OtherDirectorShowDialogWidthoutAadharUpload();
  @override
  List<Object> get props => [];
}

class ConfirmBusinessRepresentativeAndNextStep extends BusinessAccountSetupEvent {}

class CompanyPanNumberChanged extends BusinessAccountSetupEvent {
  final String value;
  const CompanyPanNumberChanged(this.value);
  @override
  List<Object> get props => [value];
}

class GetCompanyPanDetails extends BusinessAccountSetupEvent {
  final String panNumber;
  const GetCompanyPanDetails(this.panNumber);
  @override
  List<Object> get props => [panNumber];
}

class UploadCompanyPanCard extends BusinessAccountSetupEvent {
  final FileData? fileData;
  const UploadCompanyPanCard(this.fileData);
  @override
  List<Object> get props => [fileData!];
}

class CompanyPanVerificationSubmitted extends BusinessAccountSetupEvent {}

class NavigateToNextKycStep extends BusinessAccountSetupEvent {}

class NavigateToPreviousKycStep extends BusinessAccountSetupEvent {}

class GetAvailableKycSteps extends BusinessAccountSetupEvent {}

class GetLLPPanDetails extends BusinessAccountSetupEvent {
  final String panNumber;
  const GetLLPPanDetails(this.panNumber);
}

class LLPPanNumberChanged extends BusinessAccountSetupEvent {
  final String panNumber;
  const LLPPanNumberChanged(this.panNumber);
}

class UploadLLPPanCard extends BusinessAccountSetupEvent {
  final FileData? fileData;
  const UploadLLPPanCard(this.fileData);
  @override
  List<Object> get props => [fileData!];
}

class LLPPanVerificationSubmitted extends BusinessAccountSetupEvent {
  final FileData? fileData;
  final String? panNumber;
  const LLPPanVerificationSubmitted({this.fileData, this.panNumber});
  @override
  List<Object> get props => [fileData!, panNumber!];
}

class UploadPartnershipFirmPanCard extends BusinessAccountSetupEvent {
  final FileData? fileData;
  const UploadPartnershipFirmPanCard(this.fileData);
  @override
  List<Object> get props => [fileData!];
}

class PartnershipFirmPanVerificationSubmitted extends BusinessAccountSetupEvent {
  final FileData? fileData;
  final String? panNumber;
  const PartnershipFirmPanVerificationSubmitted({this.fileData, this.panNumber});
  @override
  List<Object> get props => [fileData!, panNumber!];
}

class GetPartnershipFirmPanDetails extends BusinessAccountSetupEvent {
  final String panNumber;
  const GetPartnershipFirmPanDetails(this.panNumber);
}

class PartnershipFirmPanNumberChanged extends BusinessAccountSetupEvent {
  final String panNumber;
  const PartnershipFirmPanNumberChanged(this.panNumber);
}

class UploadSoleProprietorShipPanCard extends BusinessAccountSetupEvent {
  final FileData? fileData;
  const UploadSoleProprietorShipPanCard(this.fileData);
  @override
  List<Object> get props => [fileData!];
}

class SoleProprietorShipPanVerificationSubmitted extends BusinessAccountSetupEvent {
  final FileData? fileData;
  final String? panNumber;
  const SoleProprietorShipPanVerificationSubmitted({this.fileData, this.panNumber});
  @override
  List<Object> get props => [fileData!, panNumber!];
}

class GetSoleProprietorShipPanDetails extends BusinessAccountSetupEvent {
  final String panNumber;
  const GetSoleProprietorShipPanDetails(this.panNumber);
}

class SoleProprietorShipPanNumberChanged extends BusinessAccountSetupEvent {
  final String panNumber;
  const SoleProprietorShipPanNumberChanged(this.panNumber);
}

class UploadKartaPanCard extends BusinessAccountSetupEvent {
  final FileData? fileData;
  const UploadKartaPanCard(this.fileData);
  @override
  List<Object> get props => [fileData!];
}

class KartaPanVerificationSubmitted extends BusinessAccountSetupEvent {
  final FileData? fileData;
  final String? panNumber;
  const KartaPanVerificationSubmitted({this.fileData, this.panNumber});
  @override
  List<Object> get props => [fileData!, panNumber!];
}

class GetKartaPanDetails extends BusinessAccountSetupEvent {
  final String panNumber;
  const GetKartaPanDetails(this.panNumber);
}

class KartaPanNumberChanged extends BusinessAccountSetupEvent {
  final String panNumber;
  const KartaPanNumberChanged(this.panNumber);
}

class ChangeAadharAddressSameAsResidentialAddress extends BusinessAccountSetupEvent {
  final bool isSame;
  const ChangeAadharAddressSameAsResidentialAddress(this.isSame);
  @override
  List<Object> get props => [isSame];
}

class UpdateAuthorizedSelectedCountry extends BusinessAccountSetupEvent {
  final Country country;
  const UpdateAuthorizedSelectedCountry({required this.country});
  @override
  List<Object> get props => [country];
}

class BusinessAuthorizedGetCityAndState extends BusinessAccountSetupEvent {
  final String pinCode;
  const BusinessAuthorizedGetCityAndState(this.pinCode);
  @override
  List<Object> get props => [pinCode];
}

class ChangeOtherDirectorAadharAddressSameAsResidentialAddress extends BusinessAccountSetupEvent {
  final bool isSame;
  const ChangeOtherDirectorAadharAddressSameAsResidentialAddress(this.isSame);
  @override
  List<Object> get props => [isSame];
}

class UpdateOtherDirectorSelectedCountry extends BusinessAccountSetupEvent {
  final Country country;
  const UpdateOtherDirectorSelectedCountry({required this.country});
  @override
  List<Object> get props => [country];
}

class BusinessOtherDirectorGetCityAndState extends BusinessAccountSetupEvent {
  final String pinCode;
  const BusinessOtherDirectorGetCityAndState(this.pinCode);
  @override
  List<Object> get props => [pinCode];
}

class BeneficialOwnerKycStepChanged extends BusinessAccountSetupEvent {
  final BeneficialOwnerKycSteps step;
  const BeneficialOwnerKycStepChanged(this.step);
  @override
  List<Object> get props => [step];
}

class UpdateBeneficialOwnerSelectedCountry extends BusinessAccountSetupEvent {
  final Country country;
  const UpdateBeneficialOwnerSelectedCountry({required this.country});
  @override
  List<Object> get props => [country];
}

class BusinessBeneficialOwnerGetCityAndState extends BusinessAccountSetupEvent {
  final String pinCode;
  const BusinessBeneficialOwnerGetCityAndState(this.pinCode);
  @override
  List<Object> get props => [pinCode];
}

class BusinessBeneficialOwnerAddressDetailsSubmitted extends BusinessAccountSetupEvent {
  const BusinessBeneficialOwnerAddressDetailsSubmitted();
  @override
  List<Object> get props => [];
}

class UploadBeneficialOwnershipDeclaration extends BusinessAccountSetupEvent {
  final FileData? fileData;
  const UploadBeneficialOwnershipDeclaration(this.fileData);
  @override
  List<Object> get props => [fileData!];
}

class BeneficialOwnershipDeclarationSubmitted extends BusinessAccountSetupEvent {
  final FileData? fileData;
  const BeneficialOwnershipDeclarationSubmitted({this.fileData});
  @override
  List<Object> get props => [fileData!];
}

class VerifyLLPPanSubmitted extends BusinessAccountSetupEvent {
  const VerifyLLPPanSubmitted();
}

class VerifyPartnershipFirmPanSubmitted extends BusinessAccountSetupEvent {
  const VerifyPartnershipFirmPanSubmitted();
}

class BeneficialOwnerPanEditAttempt extends BusinessAccountSetupEvent {
  const BeneficialOwnerPanEditAttempt();
}

class LLPPanEditAttempt extends BusinessAccountSetupEvent {
  const LLPPanEditAttempt();
}

class HUFPanEditAttempt extends BusinessAccountSetupEvent {
  const HUFPanEditAttempt();
}

class PartnershipFirmPanEditAttempt extends BusinessAccountSetupEvent {
  const PartnershipFirmPanEditAttempt();
}

class SoleProprietorShipPanEditAttempt extends BusinessAccountSetupEvent {
  const SoleProprietorShipPanEditAttempt();
}

class CompanyPanEditAttempt extends BusinessAccountSetupEvent {
  const CompanyPanEditAttempt();
}

class KartaPanEditAttempt extends BusinessAccountSetupEvent {
  const KartaPanEditAttempt();
}

class Director1PanEditAttempt extends BusinessAccountSetupEvent {
  const Director1PanEditAttempt();
}

class Director2PanEditAttempt extends BusinessAccountSetupEvent {
  const Director2PanEditAttempt();
}

class GSTINOrIECHasUploaded extends BusinessAccountSetupEvent {
  final int isGSTINOrIECHasUploaded;
  const GSTINOrIECHasUploaded(this.isGSTINOrIECHasUploaded);
  @override
  List<Object> get props => [isGSTINOrIECHasUploaded];
}

class UploadShopEstablishmentCertificate extends BusinessAccountSetupEvent {
  final FileData? fileData;
  const UploadShopEstablishmentCertificate(this.fileData);
  @override
  List<Object> get props => [fileData!];
}

class UploadUdyamCertificate extends BusinessAccountSetupEvent {
  final FileData? fileData;
  const UploadUdyamCertificate(this.fileData);
  @override
  List<Object> get props => [fileData!];
}

class UploadTaxProfessionalTaxRegistration extends BusinessAccountSetupEvent {
  final FileData? fileData;
  const UploadTaxProfessionalTaxRegistration(this.fileData);
  @override
  List<Object> get props => [fileData!];
}

class UploadUtilityBill extends BusinessAccountSetupEvent {
  final FileData? fileData;
  const UploadUtilityBill(this.fileData);
  @override
  List<Object> get props => [fileData!];
}

class BusinessDocumentsVerificationSubmitted extends BusinessAccountSetupEvent {
  final BuildContext context;
  const BusinessDocumentsVerificationSubmitted(this.context);
  @override
  List<Object> get props => [];
}

class ICEVerificationSkipped extends BusinessAccountSetupEvent {
  const ICEVerificationSkipped();
  @override
  List<Object> get props => [];
}

class DeleteDocument extends BusinessAccountSetupEvent {
  final String? documentNumber;
  final String? documentType;
  final String? kycRole;
  final String? path;
  final String? screenName;
  const DeleteDocument({this.documentNumber, this.documentType, this.kycRole, this.path, this.screenName});
  @override
  List<Object> get props => [documentNumber!, documentType!, kycRole!, path!, screenName!];
}

class AnnualTurnoverScrollToSection extends BusinessAccountSetupEvent {
  final GlobalKey key;
  final ScrollController? scrollController;

  const AnnualTurnoverScrollToSection(this.key, {this.scrollController});

  @override
  List<Object> get props => [key];
}

class OtherDirectorEnableAadharEdit extends BusinessAccountSetupEvent {
  const OtherDirectorEnableAadharEdit();
  @override
  List<Object?> get props => [];
}

class ProprietorEnableAadharEdit extends BusinessAccountSetupEvent {
  const ProprietorEnableAadharEdit();
  @override
  List<Object?> get props => [];
}

class DirectorEnableAadharEdit extends BusinessAccountSetupEvent {
  const DirectorEnableAadharEdit();
  @override
  List<Object?> get props => [];
}

class LoadFilesFromApi extends BusinessAccountSetupEvent {
  final Map<String, dynamic> userData;
  final String businessType;
  const LoadFilesFromApi({required this.userData, required this.businessType});
  @override
  List<Object> get props => [userData, businessType];
}

// Data change tracking events
class MarkIdentityVerificationDataChanged extends BusinessAccountSetupEvent {
  const MarkIdentityVerificationDataChanged();
  @override
  List<Object> get props => [];
}

class MarkPanDetailsDataChanged extends BusinessAccountSetupEvent {
  const MarkPanDetailsDataChanged();
  @override
  List<Object> get props => [];
}

class MarkResidentialAddressDataChanged extends BusinessAccountSetupEvent {
  const MarkResidentialAddressDataChanged();
  @override
  List<Object> get props => [];
}

class MarkAnnualTurnoverDataChanged extends BusinessAccountSetupEvent {
  const MarkAnnualTurnoverDataChanged();
  @override
  List<Object> get props => [];
}

class MarkBankAccountDataChanged extends BusinessAccountSetupEvent {
  const MarkBankAccountDataChanged();
  @override
  List<Object> get props => [];
}

class MarkIceVerificationDataChanged extends BusinessAccountSetupEvent {
  const MarkIceVerificationDataChanged();
  @override
  List<Object> get props => [];
}

class MarkBusinessDocumentsDataChanged extends BusinessAccountSetupEvent {
  const MarkBusinessDocumentsDataChanged();
  @override
  List<Object> get props => [];
}

class ResetDataChangeFlags extends BusinessAccountSetupEvent {
  const ResetDataChangeFlags();
  @override
  List<Object> get props => [];
}

// Screen-specific data change tracking events
class MarkProprietorAadharDataChanged extends BusinessAccountSetupEvent {
  const MarkProprietorAadharDataChanged();
  @override
  List<Object> get props => [];
}

class MarkSoleProprietorshipPanDataChanged extends BusinessAccountSetupEvent {
  const MarkSoleProprietorshipPanDataChanged();
  @override
  List<Object> get props => [];
}

class MarkPartnershipFirmPanDataChanged extends BusinessAccountSetupEvent {
  const MarkPartnershipFirmPanDataChanged();
  @override
  List<Object> get props => [];
}

class MarkLLPPanDataChanged extends BusinessAccountSetupEvent {
  const MarkLLPPanDataChanged();
  @override
  List<Object> get props => [];
}

class MarkKartaPanDataChanged extends BusinessAccountSetupEvent {
  const MarkKartaPanDataChanged();
  @override
  List<Object> get props => [];
}

class MarkHUFPanDataChanged extends BusinessAccountSetupEvent {
  const MarkHUFPanDataChanged();
  @override
  List<Object> get props => [];
}

class MarkCompanyPanDataChanged extends BusinessAccountSetupEvent {
  const MarkCompanyPanDataChanged();
  @override
  List<Object> get props => [];
}

class MarkCompanyIncorporationDataChanged extends BusinessAccountSetupEvent {
  const MarkCompanyIncorporationDataChanged();
  @override
  List<Object> get props => [];
}

class MarkContactInformationDataChanged extends BusinessAccountSetupEvent {
  const MarkContactInformationDataChanged();
  @override
  List<Object> get props => [];
}

class MarkBeneficialOwnershipDataChanged extends BusinessAccountSetupEvent {
  const MarkBeneficialOwnershipDataChanged();
  @override
  List<Object> get props => [];
}

class MarkPanDetailViewDataChanged extends BusinessAccountSetupEvent {
  const MarkPanDetailViewDataChanged();
  @override
  List<Object> get props => [];
}

// Store original values for skip-if-unchanged logic
class BusinessStoreOriginalGstNumber extends BusinessAccountSetupEvent {
  final String originalNumber;
  const BusinessStoreOriginalGstNumber(this.originalNumber);
  @override
  List<Object> get props => [originalNumber];
}

class BusinessStoreOriginalBankAccountNumber extends BusinessAccountSetupEvent {
  final String originalNumber;
  const BusinessStoreOriginalBankAccountNumber(this.originalNumber);
  @override
  List<Object> get props => [originalNumber];
}

class BusinessStoreOriginalAadharNumber extends BusinessAccountSetupEvent {
  final String originalNumber;
  const BusinessStoreOriginalAadharNumber(this.originalNumber);
  @override
  List<Object> get props => [originalNumber];
}

class BusinessStoreOriginalPanNumber extends BusinessAccountSetupEvent {
  final String originalNumber;
  const BusinessStoreOriginalPanNumber(this.originalNumber);
  @override
  List<Object> get props => [originalNumber];
}

// Store original values for director dialogs and proprietor Aadhaar
class BusinessStoreOriginalDirector1PanNumber extends BusinessAccountSetupEvent {
  final String originalNumber;
  const BusinessStoreOriginalDirector1PanNumber(this.originalNumber);
  @override
  List<Object> get props => [originalNumber];
}

class BusinessStoreOriginalDirector2PanNumber extends BusinessAccountSetupEvent {
  final String originalNumber;
  const BusinessStoreOriginalDirector2PanNumber(this.originalNumber);
  @override
  List<Object> get props => [originalNumber];
}

class BusinessStoreOriginalDirector1AadharNumber extends BusinessAccountSetupEvent {
  final String originalNumber;
  const BusinessStoreOriginalDirector1AadharNumber(this.originalNumber);
  @override
  List<Object> get props => [originalNumber];
}

class BusinessStoreOriginalDirector2AadharNumber extends BusinessAccountSetupEvent {
  final String originalNumber;
  const BusinessStoreOriginalDirector2AadharNumber(this.originalNumber);
  @override
  List<Object> get props => [originalNumber];
}

class BusinessStoreOriginalProprietorAadharNumber extends BusinessAccountSetupEvent {
  final String originalNumber;
  const BusinessStoreOriginalProprietorAadharNumber(this.originalNumber);
  @override
  List<Object> get props => [originalNumber];
}
