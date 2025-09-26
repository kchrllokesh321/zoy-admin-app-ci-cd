// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:country_picker/country_picker.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/models/personal_user_models/aadhar_otp_model.dart';
import 'package:exchek/core/utils/pdf_merge_util.dart';
import 'package:exchek/models/personal_user_models/aadhar_verify_otp_model.dart';
import 'package:exchek/models/personal_user_models/captcha_model.dart';
import 'package:exchek/models/personal_user_models/get_city_and_state_model.dart';
import 'package:exchek/models/personal_user_models/get_pan_detail_model.dart';
import 'package:exchek/models/personal_user_models/recaptcha_model.dart';
import 'package:exchek/repository/personal_user_kyc_repository.dart';
import 'package:exchek/views/account_setup_view/personal_account_setup_view/personal_transaction_payment_reference_view.dart';
import 'package:exchek/models/personal_user_models/get_currency_model.dart';
import 'package:cron/cron.dart';
part 'personal_account_setup_event.dart';
part 'personal_account_setup_state.dart';

extension IDVerificationDocTypeExtension on IDVerificationDocType {
  String get displayName {
    switch (this) {
      case IDVerificationDocType.aadharCard:
        return Lang.current.lbl_aadhar_card;
      case IDVerificationDocType.drivingLicense:
        return Lang.current.lbl_driving_license;
      case IDVerificationDocType.voterID:
        return Lang.current.lbl_voter_id;
      case IDVerificationDocType.passport:
        return Lang.current.lbl_passport;
    }
  }
}

class PersonalAccountSetupBloc extends Bloc<PersonalAccountSetupEvent, PersonalAccountSetupState> {
  static const int initialTime = 120;
  Timer? _timer;

  Timer? _aadhartimer;

  Timer? _resendTimer;

  CameraController? _cameraController;
  // List<CameraDescription>? _cameras;
  // Uint8List? _capturedImageBytes;
  final AuthRepository _authRepository;
  final PersonalUserKycRepository _personalUserKycRepository;
  Cron? cron;

  // Static GlobalKeys to prevent conflicts
  static final GlobalKey<FormState> _aadharVerificationFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _drivingVerificationFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _voterVerificationFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _passportVerificationFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _panVerificationKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _registerAddressFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _annualTurnoverFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _personalBankAccountVerificationFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _personalInfoKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _sePasswordFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _iceVerificationKey = GlobalKey<FormState>();

  PersonalAccountSetupBloc({
    required AuthRepository authRepository,
    required PersonalUserKycRepository personalUserKycRepository,
  }) : _authRepository = authRepository,
       _personalUserKycRepository = personalUserKycRepository,
       super(
         PersonalAccountSetupState(
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
           aadharVerificationFormKey: _aadharVerificationFormKey,
           drivingVerificationFormKey: _drivingVerificationFormKey,
           drivingLicenceController: TextEditingController(),
           voterVerificationFormKey: _voterVerificationFormKey,
           voterIdNumberController: TextEditingController(),
           passportVerificationFormKey: _passportVerificationFormKey,
           passportNumberController: TextEditingController(),
           panVerificationKey: _panVerificationKey,
           panNameController: TextEditingController(),
           panNumberController: TextEditingController(),
           registerAddressFormKey: _registerAddressFormKey,
           pinCodeController: TextEditingController(),
           stateNameController: TextEditingController(),
           cityNameController: TextEditingController(),
           address1NameController: TextEditingController(),
           address2NameController: TextEditingController(),
           annualTurnoverFormKey: _annualTurnoverFormKey,
           turnOverController: TextEditingController(),
           gstNumberController: TextEditingController(),
           personalBankAccountVerificationFormKey: _personalBankAccountVerificationFormKey,
           bankAccountNumberController: TextEditingController(),
           reEnterbankAccountNumberController: TextEditingController(),
           ifscCodeController: TextEditingController(),
           fullNameController: TextEditingController(),
           websiteController: TextEditingController(),
           personalDbaController: TextEditingController(),
           mobileController: TextEditingController(),
           otpController: TextEditingController(),
           personalInfoKey: _personalInfoKey,
           sePasswordFormKey: _sePasswordFormKey,
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
           captchaInputController: TextEditingController(),
           familyAndFriendsDescriptionController: TextEditingController(),
           iceVerificationKey: _iceVerificationKey,
           iceNumberController: TextEditingController(),
           panNumberFocusNode: FocusNode(),
           aadharNumberFocusNode: FocusNode(),
         ),
       ) {
    on<PersonalInfoStepChanged>(_onPersonalInfoStepChanged);
    on<NextStep>(_onNextStep);
    on<PreviousStepEvent>(_onPreviousStep);
    on<ChangePurpose>(_onChangePurpose);
    on<ChangeProfession>(_onChangeProfession);
    on<UpdatePersonalDetails>(_onUpdatePersonalDetails);
    on<ChangePersonalMobileNumberPressed>(_onChangePersonalMobileNumberPressed);
    on<PersonalPasswordSubmitted>(_onPersonalPasswordSubmitted);
    on<PersonalChangeEstimatedMonthlyTransaction>(_onPersonalChangeEstimatedMonthlyTransaction);
    on<PersonalToggleCurrencySelection>(_onPersonalToggleCurrencySelection);
    on<PersonalTransactionDetailSubmitted>(_onPersonalTransactionDetailSubmitted);
    on<PersonalKycStepChange>(_onPersonalKycStepChange);
    on<PersonalUpdateIdVerificationDocType>(_onPersonalUpdateIdVerificationDocType);
    on<PersonalSendAadharOtp>(_onPersonalSendAadharOtp);
    on<ChangeOtpSentStatus>(_onChangeOtpSentStatus);
    on<AadharSendOtpPressed>(_onAadharSendOtpPressed);
    on<AadharOtpTimerTicked>(_onAadharOtpTimerTicked);
    on<PersonalAadharNumbeVerified>(_onPersonalAadharNumbeVerified);
    on<PersonalDrivingLicenceVerified>(_onPersonalDrivingLicenceVerified);
    on<PersonalFrontSlideAadharCardUpload>(_onPersonalFrontSlideAadharCardUpload);
    on<PersonalBackSlideAadharCardUpload>(_onPersonalBackSlideAadharCardUpload);
    on<PersonalAadharFileUploadSubmitted>(_onPersonalAadharFileUploadSubmitted);
    on<PersonalFrontSlideDrivingLicenceUpload>(_onPersonalFrontSlideDrivingLicenceUpload);
    on<PersonalBackSlideDrivingLicenceUpload>(_onPersonalBackSlideDrivingLicenceUpload);
    on<PersonalDrivingFileUploadSubmitted>(_onPersonalDrivingFileUploadSubmitted);
    on<PersonalVoterIdVerified>(_onPersonalVoterIdVerified);
    on<PersonalVoterIdFrontFileUpload>(_onPersonalVoterIdFrontFileUpload);
    on<PersonalVoterIdBackFileUpload>(_onPersonalVoterIdBackFileUpload);
    on<PersonalVoterIdFileUploadSubmitted>(_onPersonalVoterIdFileUploadSubmitted);
    on<PersonalPassportVerified>(_onPersonalPassportVerified);
    on<PersonalPassportFrontFileUpload>(_onPersonalPassportFrontFileUpload);
    on<PersonalPassportBackFileUpload>(_onPersonalPassportBackFileUpload);
    on<PersonalPassportFileUploadSubmitted>(_onPersonalPassportFileUploadSubmitted);
    on<PersonalUploadPanCard>(_onPersonalUploadPanCard);
    on<PersonalPanVerificationSubmitted>(_onPersonalPanVerificationSubmitted);
    on<PersonalUpdateSelectedCountry>(_onPersonalUpdateSelectedCountry);
    on<PersonalUpdateAddressVerificationDocType>(_onPersonalUpdateAddressVerificationDocType);
    on<PersonalUploadAddressVerificationFile>(_onPersonalUploadAddressVerificationFile);
    on<PersonalUploadBackAddressVerificationFile>(_onPersonalUploadBackAddressVerificationFile);
    on<PersonalRegisterAddressSubmitted>(_onPersonalRegisterAddressSubmitted);
    on<PersonalUploadGstCertificateFile>(_onPersonalUploadGstCertificateFile);
    on<PersonalAnnualTurnOverVerificationSubmitted>(_onPersonalAnnualTurnOverVerificationSubmitted);
    on<PersonalBankAccountNumberVerify>(_onPersonalBankAccountNumberVerify);
    on<PersonalUpdateBankAccountVerificationDocType>(_onPersonalUpdateBankAccountVerificationDocType);
    on<PersonalUploadBankAccountVerificationFile>(_onPersonalUploadBankAccountVerificationFile);
    on<PersonalBankAccountDetailSubmitted>(_onPersonalBankAccountDetailSubmitted);
    on<PersonalMergeProgress>(_onPersonalMergeProgress);
    // on<InitializeSelfieEvent>(_onInitializeSelfie);
    // on<CaptureImageEvent>(_onCaptureImage);
    // on<RetakeImageEvent>(_onRetakeImage);
    // on<SubmitImageEvent>(_onSubmitImage);
    // on<RequestPermissionEvent>(_onRequestPermission);
    // on<DisposeSelfieEvent>(_onDisposeSelfie);
    on<PersonalScrollToPosition>(_onScrollToSection);
    on<SendOTP>(_onSendOTP);
    on<UpdateOTPError>(_onUpdateOTPError);
    on<ConfirmAndContinue>(_onConfirmAndContinue);
    on<UpdateResendTimerState>(_onUpdateResendTimerState);
    on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
    on<ToggleConfirmPasswordVisibility>(_onToggleConfirmPasswordVisibility);
    on<PasswordChanged>(_onPasswordChanged);
    on<ConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<PersonalResetData>(_onPersonalResetData);
    on<PersonalResetSignupSuccess>(_onPersonalResetSignupSuccess);
    on<GetPersonalCurrencyOptions>(_onGetPersonalCurrencyOptions);
    on<CaptchaSend>(_onCaptchaSend);
    on<ReCaptchaSend>(_onReCaptchaSend);
    on<PersonalClearIdentityVerificationFields>(_onClearIdentityVerificationFields);
    on<ResidenceAddressSameAsAadhar>(_onResidenceAddressSameAsAadhar);
    on<GetPanDetails>(_onGetPanDetails);
    on<PersonalPanNumberChanged>(_onPersonalPanNumberChanged);
    on<PersonalPanEditAttempt>(_onPersonalPanEditAttempt);
    on<GetCityAndState>(_onGetCityAndState);
    on<ChangeAgreeToAddressSameAsAadhar>(_onChangeAgreeToAddressSameAsAadhar);
    on<PersonalChangeAnnualTurnover>(_onPersonalChangeAnnualTurnover);
    on<PersonalAppBarCollapseChanged>(_onPersonalAppBarCollapseChanged);
    on<PersonalEkycAppBarCollapseChanged>(_onPersonalEkycAppBarCollapseChanged);
    on<PanNameOverwritePopupDismissed>(_onPanNameOverwritePopupDismissed);
    on<PersonalGSTVerification>(_onPersonalGSTVerification);
    on<PersonalUploadICECertificate>(_onUploadICECertificate);
    on<PersonalICEVerificationSubmitted>(_onICEVerificationSubmitted);
    on<PersonalAadharNumberChanged>(_onPersonalAadharNumberChanged);
    on<LoadPersonalKycFromLocal>(_onLoadPersonalKycFromLocal);
    on<LoadFilesFromApi>(_onLoadFilesFromApi);
    on<PersonalChangeShowDescription>(_onPersonalChangeShowDescription);
    on<PersonalEnableAadharEdit>(_onPersonalEnableAadharEdit);

    // Data change tracking event handlers
    on<PersonalMarkIdentityVerificationDataChanged>(_onPersonalMarkIdentityVerificationDataChanged);
    on<PersonalMarkPanDetailsDataChanged>(_onPersonalMarkPanDetailsDataChanged);
    on<PersonalMarkResidentialAddressDataChanged>(_onPersonalMarkResidentialAddressDataChanged);
    on<PersonalMarkAnnualTurnoverDataChanged>(_onPersonalMarkAnnualTurnoverDataChanged);
    on<PersonalMarkBankAccountDataChanged>(_onPersonalMarkBankAccountDataChanged);
    on<PersonalMarkIceVerificationDataChanged>(_onPersonalMarkIceVerificationDataChanged);
    on<PersonalResetDataChangeFlags>(_onPersonalResetDataChangeFlags);

    // Original value storage event handlers
    on<PersonalStoreOriginalAadharNumber>(_onPersonalStoreOriginalAadharNumber);
    on<PersonalStoreOriginalPanNumber>(_onPersonalStoreOriginalPanNumber);
    on<PersonalStoreOriginalGstNumber>(_onPersonalStoreOriginalGstNumber);
    on<PersonalStoreOriginalBankAccountNumber>(_onPersonalStoreOriginalBankAccountNumber);
    on<PersonalConfirmOverwrite>(_onPersonalConfirmOverwrite);
    on<PersonalOverwriteToastAcknowledged>(_onPersonalOverwriteToastAcknowledged);
    on<ShowOverwriteToast>((event, emit) {
      emit(state.copyWith(showOverwriteToast: true));
    });

    // Start cron job every 9 minutes to refresh only file data
    cron = Cron();
    cron!.schedule(Schedule.parse('*/10 * * * *'), () async {
      await _refreshKycFileData();
    });
  }

  void _onPersonalMergeProgress(PersonalMergeProgress event, Emitter<PersonalAccountSetupState> emit) {
    emit(state.copyWith(isMerging: true, mergeProgress: event.progress, mergeStatus: event.status));
  }

  void _onPersonalInfoStepChanged(PersonalInfoStepChanged event, Emitter<PersonalAccountSetupState> emit) {
    emit(state.copyWith(currentStep: event.step));
  }

  void _onPanNameOverwritePopupDismissed(
    PanNameOverwritePopupDismissed event,
    Emitter<PersonalAccountSetupState> emit,
  ) {
    emit(state.copyWith(showPanNameOverwrittenPopup: false));
  }

  void _onNextStep(NextStep event, Emitter<PersonalAccountSetupState> emit) {
    final currentIndex = PersonalAccountSetupSteps.values.indexOf(state.currentStep);
    if (currentIndex < PersonalAccountSetupSteps.values.length - 1) {
      emit(state.copyWith(currentStep: PersonalAccountSetupSteps.values[currentIndex + 1]));
    }
  }

  void _onPreviousStep(PreviousStepEvent event, Emitter<PersonalAccountSetupState> emit) {
    final currentIndex = PersonalAccountSetupSteps.values.indexOf(state.currentStep);
    if (currentIndex > 0) {
      emit(state.copyWith(currentStep: PersonalAccountSetupSteps.values[currentIndex - 1]));
    }
  }

  void _onChangePurpose(ChangePurpose event, Emitter<PersonalAccountSetupState> emit) {
    emit(state.copyWith(selectedPurpose: event.purpose));
  }

  void _onChangeProfession(ChangeProfession event, Emitter<PersonalAccountSetupState> emit) {
    final currentSelected = List<String>.from(state.selectedProfession ?? []);
    if (event.profession == 'Others') {
      emit(state.copyWith(selectedProfession: ['Others']));
    } else {
      if (currentSelected.contains('Others')) {
        currentSelected.remove('Others');
      }
      if (currentSelected.contains(event.profession)) {
        currentSelected.remove(event.profession);
      } else {
        currentSelected.add(event.profession);
      }
      emit(state.copyWith(selectedProfession: currentSelected));
      if ((state.selectedProfession ?? []).isEmpty) {
        add(PersonalChangeShowDescription(false));
      }
    }
  }

  void _onPersonalChangeAnnualTurnover(
    PersonalChangeAnnualTurnover event,
    Emitter<PersonalAccountSetupState> emit,
  ) async {
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

  void _onUpdatePersonalDetails(UpdatePersonalDetails event, Emitter<PersonalAccountSetupState> emit) {
    emit(state.copyWith(fullName: event.fullName, website: event.website, phoneNumber: event.phoneNumber));
  }

  Future<void> _onPersonalPasswordSubmitted(
    PersonalPasswordSubmitted event,
    Emitter<PersonalAccountSetupState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, navigateNext: false));
    try {
      final emailIdtoken = await Prefobj.preferences.get(Prefkeys.verifyemailToken) ?? '';
      final tosacceptance = await UserAgentHelper.getPlatformMetaInfo();

      // Convert CurrencyModel list to String list for API
      // final List<String> multicurrencyStrings =
      //     (state.selectedCurrencies ?? [])
      //         .map((currency) => '${currency.currencySymbol} ${currency.currencyName}')
      //         .toList();
      List<String> professionList = [];
      if ((state.selectedProfession?.isNotEmpty ?? false)) {
        if (state.selectedProfession!.length == 1 && state.selectedProfession!.first == 'Others') {
          if (state.productServiceDescriptionController.text.trim().isNotEmpty) {
            professionList = [state.productServiceDescriptionController.text.trim()];
          } else {
            professionList = state.selectedProfession ?? [];
          }
        } else {
          professionList = state.selectedProfession ?? [];
        }
      }

      final receivingReason = state.selectedPurpose == 'I\'m a Freelancer' ? 'freelancer' : 'family_and_friends';

      String extractLastAmount(String value) {
        // This will match numbers with optional commas
        final regex = RegExp(r'([\d,]+)(?!.*\d)');
        final match = regex.firstMatch(value);
        return match != null ? match.group(0)!.replaceAll(',', '') : '';
      }

      final response = await _authRepository.registerPersonalUser(
        email: emailIdtoken,
        // estimatedMonthlyVolume: state.selectedEstimatedMonthlyTransaction ?? '',
        estimatedMonthlyVolume: extractLastAmount(state.selectedEstimatedMonthlyTransaction ?? ''),
        // multicurrency: multicurrencyStrings,
        mobileNumber: state.phoneNumber ?? '',
        // receivingreason: state.selectedPurpose ?? '',
        receivingreason: receivingReason,
        profession: professionList,
        productDescription: receivingReason == 'family_and_friends' ? state.familyAndFriendsDescriptionController.text : state.productServiceDescriptionController.text,
        legalFullName: state.fullName ?? '',
        password: state.passwordController.text,
        tosacceptance: tosacceptance,
        usertype: 'personal',
        website: state.website ?? '',
        doingBusinessAs: state.personalDbaController.text,
      );
      if (response.success == true) {
        await Prefobj.preferences.put(Prefkeys.authToken, 'exchek@123');
        await Prefobj.preferences.delete(Prefkeys.verifyemailToken);
        emit(state.copyWith(isLoading: false, isSignupSuccess: true));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      Logger.error('Error during personal user registration: $e');
    }
  }

  void _onChangePersonalMobileNumberPressed(
    ChangePersonalMobileNumberPressed event,
    Emitter<PersonalAccountSetupState> emit,
  ) {
    // Cancel the existing timer if running
    _timer?.cancel();

    // Clear the OTP controller
    state.otpController.clear();

    // Reset the OTP-related state
    emit(state.copyWith(isOTPSent: false, timeLeft: 0, isLoading: false));
  }

  void _onPersonalResetSignupSuccess(PersonalResetSignupSuccess event, Emitter<PersonalAccountSetupState> emit) {
    emit(state.copyWith(isSignupSuccess: false));
  }

  void _onPersonalChangeEstimatedMonthlyTransaction(
    PersonalChangeEstimatedMonthlyTransaction event,
    Emitter<PersonalAccountSetupState> emit,
  ) {
    emit(state.copyWith(selectedEstimatedMonthlyTransaction: event.transactionAmount));
  }

  void _onPersonalToggleCurrencySelection(
    PersonalToggleCurrencySelection event,
    Emitter<PersonalAccountSetupState> emit,
  ) {
    final currentSelected = List<CurrencyModel>.from(state.selectedCurrencies ?? []);
    final existingIndex = currentSelected.indexWhere(
      (currency) => currency.currencySymbol == event.currency.currencySymbol,
    );

    if (existingIndex != -1) {
      currentSelected.removeAt(existingIndex);
    } else {
      currentSelected.add(event.currency);
    }

    emit(state.copyWith(selectedCurrencies: currentSelected));
  }

  Future<void> _onPersonalTransactionDetailSubmitted(
    PersonalTransactionDetailSubmitted event,
    Emitter<PersonalAccountSetupState> emit,
  ) async {
    emit(state.copyWith(isTransactionDetailLoading: true));

    try {
      await Future.delayed(const Duration(seconds: 2));
      add(const NextStep());
      emit(state.copyWith(isTransactionDetailLoading: false));
    } catch (e) {
      emit(state.copyWith(isTransactionDetailLoading: false));
      debugPrint('Error submitting transaction details: $e');
    }
  }

  void _onPersonalKycStepChange(PersonalKycStepChange event, Emitter<PersonalAccountSetupState> emit) {
    emit(state.copyWith(currentKycVerificationStep: event.stepIndex));
  }

  void _onPersonalUpdateIdVerificationDocType(
    PersonalUpdateIdVerificationDocType event,
    Emitter<PersonalAccountSetupState> emit,
  ) {
    add(PersonalClearIdentityVerificationFields());
    emit(state.copyWith(selectedIDVerificationDocType: event.docType, isIdVerified: false, isDrivingIdVerified: false));
  }

  void _onPersonalSendAadharOtp(PersonalSendAadharOtp event, Emitter<PersonalAccountSetupState> emit) async {
    if (state.originalAadharNumber != null && state.originalAadharNumber == event.aadhar) {
      emit(state.copyWith(isOtpSent: true, isOtpLoading: false, isAadharOTPInvalidate: ''));
      return;
    }
    try {
      emit(state.copyWith(isOtpSent: false, isOtpLoading: true, isAadharOTPInvalidate: ''));
      AadharOTPSendModel response = await _personalUserKycRepository.generateAadharOTP(
        aadhaarNumber: event.aadhar.replaceAll("-", ""),
        captcha: event.captcha,
        sessionId: event.sessionId,
      );
      if (response.code == 200) {
        emit(state.copyWith(isOtpSent: true, isOtpLoading: false));
        add(AadharSendOtpPressed());
      } else {
        AppToast.show(message: response.message ?? '', type: ToastificationType.error);
        emit(state.copyWith(isOtpLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isOtpSent: false, isOtpLoading: false));
    }
  }

  void _onCaptchaSend(CaptchaSend event, Emitter<PersonalAccountSetupState> emit) async {
    try {
      emit(state.copyWith(isCaptchaLoading: true, isCaptchaSend: false));
      final userId = await Prefobj.preferences.get(Prefkeys.userId) ?? '';
      final CaptchaModel response = await _personalUserKycRepository.generateCaptcha(
        userID: userId,
        aadhaarNumber: state.aadharNumberController.text,
        userType: 'personal',
        kycRole: '',
      );
      if (response.code == 200) {
        emit(state.copyWith(isCaptchaSend: true, isCaptchaLoading: false, captchaImage: response.data?.captcha ?? ''));
        await Prefobj.preferences.put(Prefkeys.sessionId, response.data?.sessionId ?? '');
      } else {
        emit(state.copyWith(isCaptchaLoading: false, isCaptchaSend: false));
      }
    } catch (e) {
      emit(state.copyWith(isCaptchaLoading: false, isCaptchaSend: false));
      Logger.error('Error :: $e');
    }
  }

  void _onReCaptchaSend(ReCaptchaSend event, Emitter<PersonalAccountSetupState> emit) async {
    try {
      emit(state.copyWith(isCaptchaLoading: true, isCaptchaSend: false));
      final sessionId = await Prefobj.preferences.get(Prefkeys.sessionId) ?? '';

      final RecaptchaModel response = await _personalUserKycRepository.reGenerateCaptcha(sessionId: sessionId);
      if (response.code == 200) {
        emit(state.copyWith(isCaptchaSend: true, isCaptchaLoading: false, captchaImage: response.data?.captcha ?? ''));
        state.captchaInputController.clear();
      } else {
        emit(state.copyWith(isCaptchaLoading: false, isCaptchaSend: false));
      }
    } catch (e) {
      emit(state.copyWith(isCaptchaLoading: false, isCaptchaSend: false));
      Logger.error(e.toString());
    }
  }

  void _onChangeOtpSentStatus(ChangeOtpSentStatus event, Emitter<PersonalAccountSetupState> emit) async {
    emit(state.copyWith(isOtpSent: event.isOtpSent));
  }

  void _onAadharSendOtpPressed(AadharSendOtpPressed event, Emitter<PersonalAccountSetupState> emit) {
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

  void _onAadharOtpTimerTicked(AadharOtpTimerTicked event, Emitter<PersonalAccountSetupState> emit) {
    emit(state.copyWith(aadharOtpRemainingTime: event.remainingTime, isAadharOtpTimerRunning: event.remainingTime > 0));
  }

  void _onPersonalAadharNumbeVerified(
    PersonalAadharNumbeVerified event,
    Emitter<PersonalAccountSetupState> emit,
  ) async {
    emit(state.copyWith(isIdVerifiedLoading: true, isAadharOTPInvalidate: null));
    try {
      final sessionId = await Prefobj.preferences.get(Prefkeys.sessionId) ?? '';
      final userId = await Prefobj.preferences.get(Prefkeys.userId) ?? '';

      final AadharOTPVerifyModel response = await _personalUserKycRepository.validateAadharOtp(
        faker: false,
        otp: event.otp,
        sessionId: sessionId,
        userId: userId,
        userType: 'personal',
        aadhaarNumber: event.aadharNumber,
      );
      if (response.code == 200) {
        emit(state.copyWith(isIdVerifiedLoading: false, isIdVerified: true, aadharNumber: event.aadharNumber));
        _aadhartimer?.cancel();
      } else {
        emit(state.copyWith(isIdVerifiedLoading: false, isAadharOTPInvalidate: response.message.toString()));
      }
    } catch (e) {
      emit(state.copyWith(isIdVerifiedLoading: false));
      Logger.error(e.toString());
    }
  }

  void _onPersonalDrivingLicenceVerified(
    PersonalDrivingLicenceVerified event,
    Emitter<PersonalAccountSetupState> emit,
  ) async {
    emit(state.copyWith(isIdVerifiedLoading: true));
    try {
      await Future.delayed(Duration(milliseconds: 300));
      emit(state.copyWith(isIdVerifiedLoading: false, isIdVerified: true, drivingLicenseNumber: event.drivingLicence));
    } catch (e) {
      emit(state.copyWith(isIdVerifiedLoading: false));
      Logger.error(e.toString());
    }
  }

  void _onPersonalFrontSlideAadharCardUpload(
    PersonalFrontSlideAadharCardUpload event,
    Emitter<PersonalAccountSetupState> emit,
  ) {
    emit(state.copyWith(isFrontSideAdharFileDeleted: false));
    if (event.fileData == null) {
      emit(
        state.copyWith(
          frontSideAdharFile: null,
          isFrontSideAdharFileDeleted: true,
          isFrontSideAdharFileUploaded: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          frontSideAdharFile: event.fileData,
          isFrontSideAdharFileDeleted: false,
          isFrontSideAdharFileUploaded: false,
        ),
      );
    }
  }

  void _onPersonalBackSlideAadharCardUpload(
    PersonalBackSlideAadharCardUpload event,
    Emitter<PersonalAccountSetupState> emit,
  ) {
    emit(state.copyWith(isBackSideAdharFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(backSideAdharFile: null, isBackSideAdharFileDeleted: true));
    } else {
      emit(state.copyWith(backSideAdharFile: event.fileData, isBackSideAdharFileDeleted: false));
    }
  }

  void _onPersonalFrontSlideDrivingLicenceUpload(
    PersonalFrontSlideDrivingLicenceUpload event,
    Emitter<PersonalAccountSetupState> emit,
  ) {
    emit(state.copyWith(isDrivingLicenceFrontSideFileDeleted: false));
    if (event.fileData == null) {
      emit(
        state.copyWith(
          drivingLicenceFrontSideFile: null,
          isDrivingLicenceFrontSideFileDeleted: true,
          isDrivingLicenceFrontSideFileUploaded: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          drivingLicenceFrontSideFile: event.fileData,
          isDrivingLicenceFrontSideFileDeleted: false,
          isDrivingLicenceFrontSideFileUploaded: false,
        ),
      );
    }
  }

  void _onPersonalAadharFileUploadSubmitted(
    PersonalAadharFileUploadSubmitted event,
    Emitter<PersonalAccountSetupState> emit,
  ) async {
    emit(state.copyWith(isIdFileSubmittedLoading: true));
    // Check if data has been changed, if not, skip API call and just navigate
    if (!state.isIdentityVerificationDataChanged && state.isFrontSideAdharFileUploaded) {
      final index = state.currentKycVerificationStep.index;
      if (index < KycVerificationSteps.values.length - 1) {
        add(PersonalKycStepChange(PersonalEKycVerificationSteps.values[index + 1]));
      }
      return;
    }

    final String? userId = await Prefobj.preferences.get(Prefkeys.userId);

    try {
      FileData? merged;
      if (state.isFrontSideAdharFileUploaded == false) {
        // Merge two docs into single PDF with progress
        emit(state.copyWith(isMerging: true, mergeProgress: 0.0, mergeStatus: 'Starting merge...'));
        merged = await PdfMergeUtil.mergeFrontBackToSinglePdf(
          front: event.frontAadharFileData!,
          back: event.backAadharFileData!,
          outputName: 'aadhaar_merged.pdf',
          onProgress: (p, s) => add(PersonalMergeProgress(progress: p, status: s)),
          useBackground: true,
        );
      } else {
        merged = event.frontAadharFileData;
      }

      final response = await _personalUserKycRepository.uploadPersonalKyc(
        userID: userId ?? '',
        documentType: 'Aadhaar',
        documentNumber: state.aadharNumber?.replaceAll("-", "") ?? '',
        documentFrontImage:
            merged ?? FileData(name: 'aadhaar_front.pdf', path: 'aadhaar_front.pdf', bytes: Uint8List(0), sizeInMB: 0),
        nameOnPan: state.panNameController.text,
        userType: 'personal',
      );
      if (response.success == true) {
        final index = state.currentKycVerificationStep.index;
        if (index < KycVerificationSteps.values.length - 1) {
          add(PersonalKycStepChange(PersonalEKycVerificationSteps.values[index + 1]));
        }
        emit(state.copyWith(isIdFileSubmittedLoading: false, isMerging: false, mergeProgress: 1.0));
        // Reset the data change flag after successful save
        add(PersonalResetDataChangeFlags());
      } else {
        emit(state.copyWith(isIdFileSubmittedLoading: false, isMerging: false));
      }
    } catch (e) {
      emit(state.copyWith(isIdFileSubmittedLoading: false, isMerging: false));
      Logger.error(e.toString());
    }
  }

  void _onPersonalBackSlideDrivingLicenceUpload(
    PersonalBackSlideDrivingLicenceUpload event,
    Emitter<PersonalAccountSetupState> emit,
  ) {
    emit(state.copyWith(isDrivingLicenceBackSideFileDeleted: false));

    if (event.fileData == null) {
      emit(state.copyWith(drivingLicenceBackSideFile: null, isDrivingLicenceBackSideFileDeleted: true));
    } else {
      emit(state.copyWith(drivingLicenceBackSideFile: event.fileData, isDrivingLicenceBackSideFileDeleted: false));
    }
  }

  void _onPersonalDrivingFileUploadSubmitted(
    PersonalDrivingFileUploadSubmitted event,
    Emitter<PersonalAccountSetupState> emit,
  ) async {
    emit(state.copyWith(isIdFileSubmittedLoading: true));
    // Check if data has been changed, if not, skip API call and just navigate
    if (!state.isIdentityVerificationDataChanged && state.isDrivingLicenceFrontSideFileUploaded) {
      final index = state.currentKycVerificationStep.index;
      if (index < KycVerificationSteps.values.length - 1) {
        add(PersonalKycStepChange(PersonalEKycVerificationSteps.values[index + 1]));
      }
      return;
    }

    final String? userId = await Prefobj.preferences.get(Prefkeys.userId);

    try {
      FileData? merged;
      if (state.isDrivingLicenceFrontSideFileUploaded == false) {
        emit(state.copyWith(isMerging: true, mergeProgress: 0.0, mergeStatus: 'Starting merge...'));
        merged = await PdfMergeUtil.mergeFrontBackToSinglePdf(
          front: event.frontDrivingLicenceFileData!,
          back: event.backDrivingLicenceFileData!,
          outputName: 'driving_licence_merged.pdf',
          onProgress: (p, s) => add(PersonalMergeProgress(progress: p, status: s)),
          useBackground: true,
        );
      } else {
        merged = event.frontDrivingLicenceFileData;
      }

      final response = await _personalUserKycRepository.uploadPersonalKyc(
        userID: userId ?? '',
        documentType: 'DrivingLicense',
        documentNumber: state.drivingLicenceController.text.trim(),
        documentFrontImage:
            merged ??
            FileData(
              name: 'driving_licence_front.pdf',
              path: 'driving_licence_front.pdf',
              bytes: Uint8List(0),
              sizeInMB: 0,
            ),
        nameOnPan: state.panNameController.text,
        userType: 'personal',
      );
      if (response.success == true) {
        final index = state.currentKycVerificationStep.index;
        if (index < KycVerificationSteps.values.length - 1) {
          add(PersonalKycStepChange(PersonalEKycVerificationSteps.values[index + 1]));
        }
        emit(state.copyWith(isIdFileSubmittedLoading: false, isMerging: false, mergeProgress: 1.0));
        // Reset the data change flag after successful save
        add(PersonalResetDataChangeFlags());
      } else {
        emit(state.copyWith(isIdFileSubmittedLoading: false, isMerging: false));
      }
    } catch (e) {
      emit(state.copyWith(isIdFileSubmittedLoading: false, isMerging: false));
      Logger.error(e.toString());
    }
  }

  void _onPersonalVoterIdVerified(PersonalVoterIdVerified event, Emitter<PersonalAccountSetupState> emit) async {
    emit(state.copyWith(isIdVerifiedLoading: true));
    try {
      await Future.delayed(Duration(milliseconds: 300));
      emit(state.copyWith(isIdVerifiedLoading: false, isIdVerified: true, voterIDNumber: event.voterId));
    } catch (e) {
      emit(state.copyWith(isIdVerifiedLoading: false));
      Logger.error(e.toString());
    }
  }

  void _onPersonalVoterIdFrontFileUpload(
    PersonalVoterIdFrontFileUpload event,
    Emitter<PersonalAccountSetupState> emit,
  ) {
    emit(state.copyWith(isVoterIdFrontFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(voterIdFrontFile: null, isVoterIdFrontFileDeleted: true, isVoteridFrontFileUploaded: false));
    } else {
      emit(
        state.copyWith(
          voterIdFrontFile: event.fileData,
          isVoterIdFrontFileDeleted: false,
          isVoteridFrontFileUploaded: false,
        ),
      );
    }
  }

  void _onPersonalVoterIdBackFileUpload(PersonalVoterIdBackFileUpload event, Emitter<PersonalAccountSetupState> emit) {
    emit(state.copyWith(isVoterIdBackFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(voterIdBackFile: null, isVoterIdBackFileDeleted: true));
    } else {
      emit(state.copyWith(voterIdBackFile: event.fileData, isVoterIdBackFileDeleted: false));
    }
  }

  void _onPersonalVoterIdFileUploadSubmitted(
    PersonalVoterIdFileUploadSubmitted event,
    Emitter<PersonalAccountSetupState> emit,
  ) async {
    emit(state.copyWith(isIdFileSubmittedLoading: true));
    // Check if data has been changed, if not, skip API call and just navigate
    if (!state.isIdentityVerificationDataChanged && state.isVoteridFrontFileUploaded) {
      final index = state.currentKycVerificationStep.index;
      if (index < KycVerificationSteps.values.length - 1) {
        add(PersonalKycStepChange(PersonalEKycVerificationSteps.values[index + 1]));
      }
      return;
    }

    final String? userId = await Prefobj.preferences.get(Prefkeys.userId);

    try {
      FileData? merged;
      if (state.isVoteridFrontFileUploaded == false) {
        emit(state.copyWith(isMerging: true, mergeProgress: 0.0, mergeStatus: 'Starting merge...'));
        merged = await PdfMergeUtil.mergeFrontBackToSinglePdf(
          front: event.voterIdFrontFileData!,
          back: event.voterIdBackFileData!,
          outputName: 'voter_id_merged.pdf',
          onProgress: (p, s) => add(PersonalMergeProgress(progress: p, status: s)),
          useBackground: true,
        );
      } else {
        merged = event.voterIdFrontFileData;
      }

      final response = await _personalUserKycRepository.uploadPersonalKyc(
        userID: userId ?? '',
        documentType: 'VoterID',
        documentNumber: state.voterIdNumberController.text.trim(),
        documentFrontImage:
            merged ??
            FileData(name: 'voter_id_front.pdf', path: 'voter_id_front.pdf', bytes: Uint8List(0), sizeInMB: 0),
        nameOnPan: state.panNameController.text,
        userType: 'personal',
      );
      if (response.success == true) {
        final index = state.currentKycVerificationStep.index;
        if (index < KycVerificationSteps.values.length - 1) {
          add(PersonalKycStepChange(PersonalEKycVerificationSteps.values[index + 1]));
        }
        emit(state.copyWith(isIdFileSubmittedLoading: false, isMerging: false, mergeProgress: 1.0));
        // Reset the data change flag after successful save
        add(PersonalResetDataChangeFlags());
      } else {
        emit(state.copyWith(isIdVerifiedLoading: false, isMerging: false));
      }
    } catch (e) {
      emit(state.copyWith(isIdFileSubmittedLoading: false, isMerging: false));
      Logger.error(e.toString());
    }
  }

  void _onPersonalPassportVerified(PersonalPassportVerified event, Emitter<PersonalAccountSetupState> emit) async {
    emit(state.copyWith(isIdVerifiedLoading: true));
    try {
      await Future.delayed(Duration(milliseconds: 300));
      emit(state.copyWith(isIdVerifiedLoading: false, isIdVerified: true, passporteNumber: event.passportNumber));
    } catch (e) {
      emit(state.copyWith(isIdVerifiedLoading: false));
      Logger.error(e.toString());
    }
  }

  void _onPersonalPassportFrontFileUpload(
    PersonalPassportFrontFileUpload event,
    Emitter<PersonalAccountSetupState> emit,
  ) {
    emit(state.copyWith(isPassportFrontFileDeleted: false));
    if (event.fileData == null) {
      emit(
        state.copyWith(passportFrontFile: null, isPassportFrontFileDeleted: true, isPassportFrontFileUploaded: false),
      );
    } else {
      emit(
        state.copyWith(
          passportFrontFile: event.fileData,
          isPassportFrontFileDeleted: false,
          isPassportFrontFileUploaded: false,
        ),
      );
    }
  }

  void _onPersonalPassportBackFileUpload(
    PersonalPassportBackFileUpload event,
    Emitter<PersonalAccountSetupState> emit,
  ) {
    emit(state.copyWith(isPassportBackFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(passportBackFile: null, isPassportBackFileDeleted: true));
    } else {
      emit(state.copyWith(passportBackFile: event.fileData, isPassportBackFileDeleted: false));
    }
  }

  void _onPersonalPassportFileUploadSubmitted(
    PersonalPassportFileUploadSubmitted event,
    Emitter<PersonalAccountSetupState> emit,
  ) async {
    emit(state.copyWith(isIdFileSubmittedLoading: true));
    // Check if data has been changed, if not, skip API call and just navigate
    if (!state.isIdentityVerificationDataChanged && state.isPassportFrontFileUploaded) {
      final index = state.currentKycVerificationStep.index;
      if (index < KycVerificationSteps.values.length - 1) {
        add(PersonalKycStepChange(PersonalEKycVerificationSteps.values[index + 1]));
      }
      return;
    }

    final String? userId = await Prefobj.preferences.get(Prefkeys.userId);
    try {
      FileData? merged;
      if (state.isPassportFrontFileUploaded == false) {
        // Only merge if not editing (first time upload)
        emit(state.copyWith(isMerging: true, mergeProgress: 0.0, mergeStatus: 'Starting merge...'));
        merged = await PdfMergeUtil.mergeFrontBackToSinglePdf(
          front: event.passportFrontFileData!,
          back: event.passportBackFileData!,
          outputName: 'passport_merged.pdf',
          onProgress: (p, s) => add(PersonalMergeProgress(progress: p, status: s)),
          useBackground: true,
        );
      } else {
        // If editing, use the existing front file data
        merged = event.passportFrontFileData;
      }

      final response = await _personalUserKycRepository.uploadPersonalKyc(
        userID: userId ?? '',
        documentType: 'Passport',
        documentNumber: state.passportNumberController.text.trim(),
        documentFrontImage:
            merged ??
            FileData(name: 'passport_front.pdf', path: 'passport_front.pdf', bytes: Uint8List(0), sizeInMB: 0),
        nameOnPan: state.panNameController.text,
        userType: 'personal',
      );
      if (response.success == true) {
        final index = state.currentKycVerificationStep.index;
        if (index < KycVerificationSteps.values.length - 1) {
          add(PersonalKycStepChange(PersonalEKycVerificationSteps.values[index + 1]));
        }
        emit(state.copyWith(isIdFileSubmittedLoading: false, isMerging: false, mergeProgress: 1.0));
        // Reset the data change flag after successful save
        add(PersonalResetDataChangeFlags());
      } else {
        emit(state.copyWith(isIdVerifiedLoading: false, isMerging: false));
      }
    } catch (e) {
      emit(state.copyWith(isIdFileSubmittedLoading: false, isMerging: false));
      Logger.error(e.toString());
    }
  }

  void _onPersonalUploadPanCard(PersonalUploadPanCard event, Emitter<PersonalAccountSetupState> emit) async {
    emit(state.copyWith(isPanFileDataDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(panFileData: null, isPanFileDataDeleted: true));
    } else {
      emit(state.copyWith(panFileData: event.fileData, isPanFileDataDeleted: false));
    }
  }

  void _onPersonalPanVerificationSubmitted(
    PersonalPanVerificationSubmitted event,
    Emitter<PersonalAccountSetupState> emit,
  ) async {
    // Check if data has been changed, if not, skip API call and just navigate
    if (!state.isPanDetailsDataChanged && state.panFileData != null) {
      final index = state.currentKycVerificationStep.index;
      if (index < KycVerificationSteps.values.length - 1) {
        add(PersonalKycStepChange(PersonalEKycVerificationSteps.values[index + 1]));
      }
      return;
    }

    if (state.panVerificationKey.currentState?.validate() ?? false) {
      emit(state.copyWith(isPanVerifyingLoading: true));

      final String? userId = await Prefobj.preferences.get(Prefkeys.userId);

      final user = await Prefobj.preferences.get(Prefkeys.userKycDetail);
      final userDetail = jsonDecode(user!);
      final isFreelancer = userDetail['personal_details']['payment_purpose'] == "freelancer";

      try {
        final response = await _personalUserKycRepository.uploadPanDetails(
          userID: userId ?? '',
          userType: 'personal',
          panNumber: state.panNumberController.text.trim(),
          nameOnPan: state.panNameController.text,
          panDoc: event.fileData!,
          kycRole: isFreelancer ? "FREELANCER" : "FAMILY_&_FRIENDS",
        );
        if (response.success == true) {
          final index = state.currentKycVerificationStep.index;
          if (index < KycVerificationSteps.values.length - 1) {
            add(PersonalKycStepChange(PersonalEKycVerificationSteps.values[index + 1]));
          }
          emit(state.copyWith(panVerificationSuccess: true, isPanVerifyingLoading: false));
          // Reset the data change flag after successful save
          add(PersonalResetDataChangeFlags());
        } else {
          emit(state.copyWith(panVerificationSuccess: false, isPanVerifyingLoading: false));
        }
      } catch (e) {
        emit(state.copyWith(panVerificationSuccess: false, isPanVerifyingLoading: false));
      }
    }
  }

  void _onPersonalUpdateSelectedCountry(
    PersonalUpdateSelectedCountry event,
    Emitter<PersonalAccountSetupState> emit,
  ) async {
    emit(state.copyWith(selectedCountry: event.country));
  }

  void _onPersonalUpdateAddressVerificationDocType(
    PersonalUpdateAddressVerificationDocType event,
    Emitter<PersonalAccountSetupState> emit,
  ) async {
    emit(state.copyWith(selectedAddressVerificationDocType: event.docType));
  }

  void _onPersonalUploadAddressVerificationFile(
    PersonalUploadAddressVerificationFile event,
    Emitter<PersonalAccountSetupState> emit,
  ) async {
    emit(state.copyWith(isAddressVerificationFileDeleted: false));
    if (event.fileData == null) {
      emit(
        state.copyWith(
          addressVerificationFile: null,
          isAddressVerificationFileDeleted: true,
          isFrontSideAddressAdharFileUploaded: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          addressVerificationFile: event.fileData,
          isAddressVerificationFileDeleted: false,
          isFrontSideAddressAdharFileUploaded: false,
        ),
      );
    }
  }

  void _onPersonalUploadBackAddressVerificationFile(
    PersonalUploadBackAddressVerificationFile event,
    Emitter<PersonalAccountSetupState> emit,
  ) async {
    emit(state.copyWith(isBackAddressVerificationFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(backAddressVerificationFile: null, isBackAddressVerificationFileDeleted: true));
    } else {
      emit(state.copyWith(backAddressVerificationFile: event.fileData, isBackAddressVerificationFileDeleted: false));
    }
  }

void _onPersonalRegisterAddressSubmitted(
  PersonalRegisterAddressSubmitted event,
  Emitter<PersonalAccountSetupState> emit,
) async {
    // Emit loading early to trigger spinner in UI
  emit(state.copyWith(isAddressVerificationLoading: true, isMerging: false));
  await Future.delayed(Duration.zero); // Yield to UI

  // Skip API call if no change and files already uploaded
  if (!state.isResidentialAddressDataChanged &&
      (state.isFrontSideAddressVerificationFileUploaded || state.isFrontSideAddressAdharFileUploaded)) {
    final index = state.currentKycVerificationStep.index;
    if (index < KycVerificationSteps.values.length - 1) {
      add(PersonalKycStepChange(PersonalEKycVerificationSteps.values[index + 1]));
    }
    return;
  }

  final String? userId = await Prefobj.preferences.get(Prefkeys.userId);
  FileData? merged;

  try {
    if (event.isAddharCard == true && !state.isFrontSideAddressAdharFileUploaded) {
      // Set merging true to show merging UI
      emit(state.copyWith(isMerging: true, mergeProgress: 0.0, mergeStatus: 'Starting Aadhaar card merge...'));

      // Run merge on background isolate via PdfMergeUtil (useBackground: true triggers compute inside)
      merged = await PdfMergeUtil.mergeFrontBackToSinglePdf(
        front: event.addressValidateFileData!,
        back: event.backValiateFileData!,
        outputName: 'address_verification_merged.pdf',
        onProgress: (progress, status) {
          // Dispatch progress events to update UI
          add(PersonalMergeProgress(progress: progress, status: status));
        },
        useBackground: true,  // Make sure this triggers isolate usage internally
      );

      // Merge done, reset merging flag (UI should show progress to complete)
      emit(state.copyWith(isMerging: false));
    } else {
      merged = event.addressValidateFileData;
    }

    // Now upload merged or original file
    final response = await _personalUserKycRepository.uploadResidentialAddressDetails(
      userID: userId ?? '',
      userType: 'personal',
      documentType: event.docType,
      addressLine1: state.address1NameController.text.trim(),
      addressLine2: state.address2NameController.text.trim(),
      city: state.cityNameController.text.trim(),
      isAddharCard: event.isAddharCard,
      country: state.selectedCountry?.name ?? '',
      pinCode: state.pinCodeController.text.trim(),
      state: state.stateNameController.text.trim(),
      documentFrontImage: event.isAddharCard
          ? (merged ?? FileData(
              name: 'address_aadhaar_front.pdf',
              path: 'address_aadhaar_front.pdf',
              bytes: Uint8List(0),
              sizeInMB: 0,
            ))
          : event.addressValidateFileData,
      aadhaarUsedAsIdentity: state.isResidenceAddressSameAsAadhar == 0 ? 'yes' : 'no',
    );

    // Handle upload success
    if (response.success == true) {
      final index = state.currentKycVerificationStep.index;
      if (index < KycVerificationSteps.values.length - 1) {
        add(PersonalKycStepChange(PersonalEKycVerificationSteps.values[index + 1]));
      }
      emit(state.copyWith(isAddressVerificationLoading: false, isMerging: false, mergeProgress: 1.0));
      add(PersonalResetDataChangeFlags());
    } else {
      AppToast.show(message: response.message ?? '', type: ToastificationType.error);
      emit(state.copyWith(isAddressVerificationLoading: false, isMerging: false));
    }
  } catch (e) {
    emit(state.copyWith(isAddressVerificationLoading: false, isMerging: false));
  }
}

  void _onPersonalUploadGstCertificateFile(
    PersonalUploadGstCertificateFile event,
    Emitter<PersonalAccountSetupState> emit,
  ) async {
    emit(state.copyWith(isGstCertificateFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(gstCertificateFile: null, isGstCertificateFileDeleted: true));
    } else {
      emit(state.copyWith(gstCertificateFile: event.fileData, isGstCertificateFileDeleted: false));
    }
  }

  void _onPersonalGSTVerification(PersonalGSTVerification event, Emitter<PersonalAccountSetupState> emit) async {
    // Check if GST number has actually changed from original
    final String currentGstNumberText = state.gstNumberController.text;
    final bool unchangedFromOriginal = state.originalGstNumber != null && state.originalGstNumber == event.gstNumber;
    final bool matchesCurrentlyVerified =
        state.isGSTNumberVerify == true &&
        currentGstNumberText == event.gstNumber &&
        (state.gstLegalName?.isNotEmpty ?? false);

    if (unchangedFromOriginal || matchesCurrentlyVerified) {
      // Skip API call and keep verified state using cached data
      emit(state.copyWith(isGstNumberVerifyingLoading: false, isGSTNumberVerify: true));
      return;
    }

    try {
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

  void _onPersonalAnnualTurnOverVerificationSubmitted(
    PersonalAnnualTurnOverVerificationSubmitted event,
    Emitter<PersonalAccountSetupState> emit,
  ) async {
    // Check if data has been changed, if not, skip API call and just navigate
    if (!state.isAnnualTurnoverDataChanged && state.gstCertificateFile != null) {
      final currentIndex = state.currentKycVerificationStep.index;
      if (currentIndex < PersonalEKycVerificationSteps.values.length - 1) {
        add(PersonalKycStepChange(PersonalEKycVerificationSteps.values[currentIndex + 1]));
      }
      return;
    }

    emit(state.copyWith(isGstVerificationLoading: true));

    final String? userId = await Prefobj.preferences.get(Prefkeys.userId);

    try {
      final response = await _personalUserKycRepository.uploadGSTDocument(
        userID: userId ?? '',
        gstNumber: event.gstNumber,
        userType: 'personal',
        gstCertificate: event.gstCertificate,
      );
      if (response.success == true) {
        final currentIndex = state.currentKycVerificationStep.index;
        if (currentIndex < PersonalEKycVerificationSteps.values.length - 1) {
          add(PersonalKycStepChange(PersonalEKycVerificationSteps.values[currentIndex + 1]));
        }
        emit(state.copyWith(isGstVerificationLoading: false));
        // Reset the data change flag after successful save
        add(PersonalResetDataChangeFlags());
      } else {
        emit(state.copyWith(isGstVerificationLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isGstVerificationLoading: false));
    }
  }

  void _onPersonalBankAccountNumberVerify(
    PersonalBankAccountNumberVerify event,
    Emitter<PersonalAccountSetupState> emit,
  ) async {
    // Check if bank account number has actually changed from original
    if (state.originalBankAccountNumber != null && state.originalBankAccountNumber == event.accountNumber) {
      // Skip API call when unchanged and we have verified/cached details
      final bool hasCachedVerification =
          (state.isBankAccountVerify == true) || ((state.accountHolderName ?? '').isNotEmpty);
      if (hasCachedVerification) {
        emit(
          state.copyWith(
            isBankAccountNumberVerifiedLoading: false,
            isBankAccountVerify: true,
            bankAccountNumber: event.accountNumber,
            ifscCode: event.ifscCode,
          ),
        );
        return;
      }
    }

    try {
      emit(state.copyWith(isBankAccountNumberVerifiedLoading: true));

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
    }
  }

  void _onPersonalUpdateBankAccountVerificationDocType(
    PersonalUpdateBankAccountVerificationDocType event,
    Emitter<PersonalAccountSetupState> emit,
  ) async {
    emit(state.copyWith(selectedBankAccountVerificationDocType: event.selectedType));
  }

  void _onPersonalUploadBankAccountVerificationFile(
    PersonalUploadBankAccountVerificationFile event,
    Emitter<PersonalAccountSetupState> emit,
  ) async {
    emit(state.copyWith(isBankVerificationFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(bankVerificationFile: null, isBankVerificationFileDeleted: true));
    } else {
      emit(state.copyWith(bankVerificationFile: event.fileData, isBankVerificationFileDeleted: false));
    }
  }

  void _onPersonalBankAccountDetailSubmitted(
    PersonalBankAccountDetailSubmitted event,
    Emitter<PersonalAccountSetupState> emit,
  ) async {
    // Check if data has been changed, if not, skip API call and just navigate
    if (!state.isBankAccountDataChanged && state.bankVerificationFile != null) {
      final currentIndex = state.currentKycVerificationStep.index;
      if (currentIndex < PersonalEKycVerificationSteps.values.length - 1) {
        add(PersonalKycStepChange(PersonalEKycVerificationSteps.values[currentIndex + 1]));
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
        documentType: event.documentType ?? '',
        ifscCode: state.ifscCode ?? '',
        proofDocumentImage: event.bankAccountVerifyFile,
      );
      if (response.success == true) {
        final currentIndex = state.currentKycVerificationStep.index;
        if (currentIndex < PersonalEKycVerificationSteps.values.length - 1) {
          add(PersonalKycStepChange(PersonalEKycVerificationSteps.values[currentIndex + 1]));
        }
        if (kIsWeb) {
          GoRouter.of(event.context).go(RouteUri.ekycconfirmationroute);
        } else {
          GoRouter.of(event.context).push(RouteUri.ekycconfirmationroute);
        }
        emit(state.copyWith(isBankAccountNumberVerifiedLoading: false));
        // Reset the data change flag after successful save
        add(PersonalResetDataChangeFlags());
      } else {
        emit(state.copyWith(isBankAccountNumberVerifiedLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isBankAccountNumberVerifiedLoading: false));
    }
  }

  // void _onInitializeSelfie(InitializeSelfieEvent event, Emitter<PersonalAccountSetupState> emit) async {
  //   emit(
  //     state.copyWith(
  //       imageBytes: null,
  //       cameraController: null,
  //       hasPermission: true,
  //       errorMessage: null,
  //       isLoading: true,
  //     ),
  //   );

  //   try {
  //     _cameraController?.dispose();

  //     // Request camera permission
  //     final permissionStatus = await Permission.camera.request();

  //     if (permissionStatus == PermissionStatus.granted) {
  //       // Get available cameras
  //       _cameras = await availableCameras();

  //       if (_cameras != null && _cameras!.isNotEmpty) {
  //         // Initialize camera controller
  //         _cameraController = CameraController(_cameras![0], ResolutionPreset.high, enableAudio: false);

  //         await _cameraController!.initialize();

  //         emit(
  //           state.copyWith(
  //             isLoading: false,
  //             cameraController: _cameraController,
  //             hasPermission: true,
  //             errorMessage: null,
  //           ),
  //         );
  //       } else {
  //         emit(
  //           state.copyWith(isLoading: false, errorMessage: 'No cameras available on this device', hasPermission: true),
  //         );
  //       }
  //     } else {
  //       emit(
  //         state.copyWith(
  //           isLoading: false,
  //           errorMessage: 'Camera permission is required to use this feature',
  //           hasPermission: false,
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     emit(
  //       state.copyWith(
  //         isLoading: false,
  //         errorMessage: 'Failed to initialize camera: ${e.toString()}',
  //         hasPermission: false,
  //       ),
  //     );
  //   }
  // }

  // void _onCaptureImage(CaptureImageEvent event, Emitter<PersonalAccountSetupState> emit) async {
  //   if (_cameraController == null || !_cameraController!.value.isInitialized) {
  //     return;
  //   }

  //   try {
  //     emit(state.copyWith(isLoading: true));

  //     final XFile image = await _cameraController!.takePicture();
  //     final Uint8List imageBytes = await image.readAsBytes();

  //     _capturedImageBytes = imageBytes;

  //     emit(
  //       state.copyWith(
  //         isLoading: false,
  //         imageBytes: imageBytes,
  //         cameraController: _cameraController,
  //         hasPermission: true,
  //         errorMessage: null,
  //       ),
  //     );
  //   } catch (e) {
  //     emit(
  //       state.copyWith(isLoading: false, errorMessage: 'Failed to capture image: ${e.toString()}', hasPermission: true),
  //     );
  //   }
  // }

  // void _onRetakeImage(RetakeImageEvent event, Emitter<PersonalAccountSetupState> emit) async {
  //   _capturedImageBytes = null;

  //   try {
  //     // Dispose the current camera controller
  //     await _cameraController?.dispose();
  //     _cameraController = null;

  //     // Reinitialize the camera
  //     if (_cameras != null && _cameras!.isNotEmpty) {
  //       _cameraController = CameraController(_cameras![0], ResolutionPreset.high, enableAudio: false);
  //       await _cameraController!.initialize();

  //       emit(
  //         state.copyWith(
  //           imageBytes: null,
  //           cameraController: _cameraController,
  //           hasPermission: true,
  //           errorMessage: null,
  //           isLoading: false,
  //           isImageSubmitted: false,
  //         ),
  //       );
  //     } else {
  //       emit(
  //         state.copyWith(
  //           imageBytes: null,
  //           errorMessage: 'No cameras available on this device',
  //           hasPermission: true,
  //           isLoading: false,
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     emit(
  //       state.copyWith(
  //         imageBytes: null,
  //         errorMessage: 'Failed to reinitialize camera: ${e.toString()}',
  //         hasPermission: true,
  //         isLoading: false,
  //       ),
  //     );
  //   }
  // }

  // void _onSubmitImage(SubmitImageEvent event, Emitter<PersonalAccountSetupState> emit) async {
  //   if (_capturedImageBytes != null) {
  //     emit(state.copyWith(isLoading: true));

  //     try {
  //       await Future.delayed(const Duration(seconds: 1)); // Simulate processing

  //       emit(state.copyWith(isLoading: false, isImageSubmitted: true));

  //       // Optionally reset to camera ready state after submission
  //       await Future.delayed(const Duration(seconds: 2));
  //       _cameraController = CameraController(_cameras![0], ResolutionPreset.high, enableAudio: false);
  //       await _cameraController!.initialize();
  //       emit(
  //         state.copyWith(
  //           imageBytes: null,
  //           cameraController: _cameraController,
  //           hasPermission: true,
  //           errorMessage: null,
  //           isLoading: false,
  //           isImageSubmitted: false,
  //         ),
  //       );
  //     } catch (e) {
  //       emit(state.copyWith(isLoading: false, errorMessage: 'Failed to submit image: ${e.toString()}'));
  //     }
  //   }
  // }

  // void _onRequestPermission(RequestPermissionEvent event, Emitter<PersonalAccountSetupState> emit) {
  //   add(InitializeSelfieEvent());
  // }

  // void _onDisposeSelfie(DisposeSelfieEvent event, Emitter<PersonalAccountSetupState> emit) async {
  //   await _cameraController?.dispose();
  //   _cameraController = null;
  //   _capturedImageBytes = null;
  // }

  void _onScrollToSection(PersonalScrollToPosition event, Emitter<PersonalAccountSetupState> emit) {
    state.scrollDebounceTimer?.cancel();

    final scrollController = event.scrollController ?? state.scrollController;

    final newTimer = Timer(const Duration(milliseconds: 300), () {
      if (!scrollController.hasClients) {
        // If not attached, try to attach it
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!scrollController.hasClients) return;

          final RenderObject? renderObject = event.key.currentContext?.findRenderObject();
          if (renderObject != null) {
            scrollController.position.ensureVisible(
              renderObject,
              alignment: 0.06,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        });
        return;
      }

      final RenderObject? renderObject = event.key.currentContext?.findRenderObject();
      if (renderObject != null) {
        scrollController.position.ensureVisible(
          renderObject,
          alignment: 0.06,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });

    emit(state.copyWith(scrollDebounceTimer: newTimer));
  }

  Future<void> _onSendOTP(SendOTP event, Emitter<PersonalAccountSetupState> emit) async {
    final mobileAvailability = await _authRepository.mobileAvailability(mobileNumber: state.mobileController.text);
    if (mobileAvailability.data?.exists == true) {
      AppToast.show(message: 'Mobile number already exists', type: ToastificationType.error);
      return;
    }
    emit(state.copyWith(isLoading: true));

    try {
      final response = await _authRepository.sendOtp(mobile: state.mobileController.text.trim(), type: 'registration');
      if (response.success == true) {
        emit(state.copyWith(isOTPSent: true, isLoading: false));
        _startResendTimer(emit);
        AppToast.show(message: response.message ?? '', type: ToastificationType.success);
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onUpdateOTPError(UpdateOTPError event, Emitter<PersonalAccountSetupState> emit) {
    emit(state.copyWith(otpError: event.error));
  }

  Future<void> _onConfirmAndContinue(ConfirmAndContinue event, Emitter<PersonalAccountSetupState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      final response = await _authRepository.validateregistrationOtp(
        mobile: state.mobileController.text.trim(),
        otp: state.otpController.text.trim(),
      );
      if (response.success == true) {
        add(
          UpdatePersonalDetails(
            fullName: state.fullNameController.text.trim(),
            website: state.websiteController.text.trim().isEmpty ? null : state.websiteController.text.trim(),
            phoneNumber: state.mobileController.text.trim(),
          ),
        );
        final index = state.currentStep.index;
        if (index < PersonalAccountSetupSteps.values.length - 1) {
          add(PersonalInfoStepChanged(PersonalAccountSetupSteps.values[index + 1]));
        }
        state.otpController.clear();
        _resendTimer?.cancel();

        emit(state.copyWith(isLoading: false, isVerifyPersonalRegisterdInfo: true));
        add(GetPersonalCurrencyOptions());
      } else {
        emit(state.copyWith(isLoading: false, isOTPSent: false));
        state.otpController.clear();
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onUpdateResendTimerState(UpdateResendTimerState event, Emitter<PersonalAccountSetupState> emit) {
    emit(
      state.copyWith(timeLeft: event.timeLeft ?? state.timeLeft, canResendOTP: event.canResend ?? state.canResendOTP),
    );
  }

  void _startResendTimer(Emitter<PersonalAccountSetupState> emit) {
    _resendTimer?.cancel();
    int timeLeft = 120;

    emit(state.copyWith(timeLeft: timeLeft, canResendOTP: false));

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }

      timeLeft--;
      if (timeLeft < 0) {
        timer.cancel();
        add(UpdateResendTimerState(canResend: true));
      } else {
        add(UpdateResendTimerState(timeLeft: timeLeft));
      }
    });
  }

  void _onTogglePasswordVisibility(TogglePasswordVisibility event, Emitter<PersonalAccountSetupState> emit) {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void _onToggleConfirmPasswordVisibility(
    ToggleConfirmPasswordVisibility event,
    Emitter<PersonalAccountSetupState> emit,
  ) {
    emit(state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<PersonalAccountSetupState> emit) {
    state.passwordController.text = event.password;
    emit(state.copyWith());
  }

  void _onConfirmPasswordChanged(ConfirmPasswordChanged event, Emitter<PersonalAccountSetupState> emit) {
    state.confirmPasswordController.text = event.password;
    emit(state.copyWith());
  }

  void _onPersonalResetData(PersonalResetData event, Emitter<PersonalAccountSetupState> emit) {
    // Cancel all timers
    _timer?.cancel();
    _aadhartimer?.cancel();
    _resendTimer?.cancel();

    // Clear all text controllers
    state.professionOtherController.clear();
    state.productServiceDescriptionController.clear();
    state.passwordController.clear();
    state.confirmPasswordController.clear();
    state.aadharNumberController.clear();
    state.aadharOtpController.clear();
    state.drivingLicenceController.clear();
    state.voterIdNumberController.clear();
    state.passportNumberController.clear();
    state.panNameController.clear();
    state.panNumberController.clear();
    state.pinCodeController.clear();
    state.stateNameController.clear();
    state.cityNameController.clear();
    state.address1NameController.clear();
    state.address2NameController.clear();
    state.turnOverController.clear();
    state.gstNumberController.clear();
    state.bankAccountNumberController.clear();
    state.reEnterbankAccountNumberController.clear();
    state.ifscCodeController.clear();
    state.fullNameController.clear();
    state.websiteController.clear();
    state.personalDbaController.clear();
    state.mobileController.clear();
    state.otpController.clear();
    state.familyAndFriendsDescriptionController.clear();
    state.iceNumberController.clear();

    emit(
      PersonalAccountSetupState(
        familyAndFriendsDescriptionController: state.familyAndFriendsDescriptionController,
        currentStep: PersonalAccountSetupSteps.personalEntity,
        selectedPurpose: null,
        selectedProfession: null,
        fullName: null,
        email: null,
        website: null,
        phoneNumber: null,
        password: null,
        selectedEstimatedMonthlyTransaction: null,
        selectedCurrencies: [],
        isTransactionDetailLoading: false,
        currentKycVerificationStep: PersonalEKycVerificationSteps.identityVerification,
        selectedIDVerificationDocType: null,
        isOtpSent: false,
        aadharOtpRemainingTime: 0,
        isAadharOtpTimerRunning: false,
        aadharNumber: null,
        isIdVerifiedLoading: false,
        isIdVerified: false,
        drivingLicenseNumber: null,
        isDrivingIdVerifiedLoading: false,
        isDrivingIdVerified: false,
        drivingLicenceFrontSideFile: null,
        frontSideAdharFile: null,
        backSideAdharFile: null,
        isIdFileSubmittedLoading: false,
        voterIDNumber: null,
        isvoterIdVerifiedLoading: false,
        isvoterIdVerified: false,
        voterIdFrontFile: null,
        voterIdBackFile: null,
        passporteNumber: null,
        ispassportIdVerifiedLoading: false,
        ispassportIdVerified: false,
        passportFrontFile: null,
        passportBackFile: null,
        panFileData: null,
        isPanVerifyingLoading: false,
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
        selectedAddressVerificationDocType: state.selectedAddressVerificationDocType,
        addressVerificationFile: null,
        isAddressVerificationLoading: false,
        gstCertificateFile: null,
        isGstCertificateMandatory: false,
        isGstVerificationLoading: false,
        bankAccountNumber: null,
        ifscCode: null,
        accountHolderName: null,
        selectedBankAccountVerificationDocType: null,
        bankVerificationFile: null,
        isBankAccountVerify: false,
        isBankAccountNumberVerifiedLoading: false,
        isLoading: false,
        isReady: false,
        hasPermission: false,
        cameraController: null,
        imageBytes: null,
        errorMessage: null,
        isImageCaptured: false,
        isImageSubmitted: false,
        navigateNext: false,
        scrollDebounceTimer: null,
        otpError: null,
        isSignupSuccess: false,
        scrollController: state.scrollController,
        professionOtherController: state.professionOtherController,
        productServiceDescriptionController: state.productServiceDescriptionController,
        passwordController: state.passwordController,
        confirmPasswordController: state.confirmPasswordController,
        personalInfoKey: state.personalInfoKey,
        aadharNumberController: state.aadharNumberController,
        aadharOtpController: state.aadharOtpController,
        aadharVerificationFormKey: state.aadharVerificationFormKey,
        drivingVerificationFormKey: state.drivingVerificationFormKey,
        drivingLicenceController: state.drivingLicenceController,
        voterVerificationFormKey: state.voterVerificationFormKey,
        voterIdNumberController: state.voterIdNumberController,
        passportVerificationFormKey: state.passportVerificationFormKey,
        passportNumberController: state.passportNumberController,
        panVerificationKey: state.panVerificationKey,
        panNameController: state.panNameController,
        panNumberController: state.panNumberController,
        panNumberFocusNode: state.panNumberFocusNode,
        registerAddressFormKey: state.registerAddressFormKey,
        pinCodeController: state.pinCodeController,
        stateNameController: state.stateNameController,
        cityNameController: state.cityNameController,
        address1NameController: state.address1NameController,
        address2NameController: state.address2NameController,
        annualTurnoverFormKey: state.annualTurnoverFormKey,
        turnOverController: state.turnOverController,
        gstNumberController: state.gstNumberController,
        personalBankAccountVerificationFormKey: state.personalBankAccountVerificationFormKey,
        bankAccountNumberController: state.bankAccountNumberController,
        reEnterbankAccountNumberController: state.reEnterbankAccountNumberController,
        ifscCodeController: state.ifscCodeController,
        fullNameController: state.fullNameController,
        websiteController: state.websiteController,
        personalDbaController: state.personalDbaController,
        mobileController: state.mobileController,
        otpController: state.otpController,
        sePasswordFormKey: state.sePasswordFormKey,
        captchaInputController: state.captchaInputController,
        backAddressVerificationFile: null,
        currencyList: [],
        iceVerificationKey: state.iceVerificationKey,
        iceNumberController: state.iceNumberController,
        isLocalDataLoading: false,
        aadharNumberFocusNode: state.aadharNumberFocusNode,
      ),
    );
  }

  Future<void> _onGetPersonalCurrencyOptions(
    GetPersonalCurrencyOptions event,
    Emitter<PersonalAccountSetupState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
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
            currencyList: currencyList,
            estimatedMonthlyVolumeList: response.data?.estimatedMonthlyVolume ?? [],
            isLoading: false,
          ),
        );
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      Logger.error(e.toString());
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onClearIdentityVerificationFields(
    PersonalClearIdentityVerificationFields event,
    Emitter<PersonalAccountSetupState> emit,
  ) {
    // Reset all fields and variables used in PersonalIdentityVerificationView
    state.aadharNumberController.clear();
    state.aadharOtpController.clear();
    state.captchaInputController.clear();
    state.drivingLicenceController.clear();
    state.voterIdNumberController.clear();
    state.passportNumberController.clear();

    emit(
      state.copyWith(
        isIdVerified: false,
        isIdVerifiedLoading: false,
        isCaptchaSend: false,
        isCaptchaLoading: false,
        captchaImage: '',
        isOtpSent: false,
        isOtpLoading: false,
        frontSideAdharFile: null,
        backSideAdharFile: null,
        drivingLicenceFrontSideFile: null,
        voterIdFrontFile: null,
        voterIdBackFile: null,
        passportFrontFile: null,
        passportBackFile: null,
        aadharNumber: null,
        drivingLicenseNumber: null,
        voterIDNumber: null,
        passporteNumber: null,
      ),
    );
  }

  void _onResidenceAddressSameAsAadhar(ResidenceAddressSameAsAadhar event, Emitter<PersonalAccountSetupState> emit) {
    emit(
      state.copyWith(
        isResidenceAddressSameAsAadhar: event.sameAddressSelected,
        addressVerificationFile: null,
        backAddressVerificationFile: null,
        selectedAddressVerificationDocType: '',
        pinCodeController: TextEditingController(),
        stateNameController: TextEditingController(),
        cityNameController: TextEditingController(),
        address1NameController: TextEditingController(),
        address2NameController: TextEditingController(),
      ),
    );
  }

  // Enable editing Aadhaar by resetting captcha/OTP state but keeping the Aadhaar number text
  void _onPersonalEnableAadharEdit(PersonalEnableAadharEdit event, Emitter<PersonalAccountSetupState> emit) {
    state.captchaInputController.clear();
    state.aadharOtpController.clear();

    emit(
      state.copyWith(
        isCaptchaSend: false,
        isCaptchaLoading: false,
        captchaImage: '',
        isOtpSent: false,
        isOtpLoading: false,
        isAadharOtpTimerRunning: false,
        aadharOtpRemainingTime: 0,
        isAadharOTPInvalidate: null,
      ),
    );
  }

  Future<void> _onGetPanDetails(GetPanDetails event, Emitter<PersonalAccountSetupState> emit) async {
    // Check if PAN number unchanged and already verified, skip fetching
    if (state.originalPanNumber != null && state.originalPanNumber == event.panNumber) {
      if (state.isPanDetailsVerified == true && state.panOverwriteName != null) {
        emit(
          state.copyWith(
            isPanDetailsLoading: false,
            isPanDetailsVerified: true,
            panOverwriteMismatch: false,
            panOverwriteName: null,
            panDetailsErrorMessage: '',
          ),
        );
        return;
      }
    }

    emit(
      state.copyWith(
        isPanDetailsLoading: true,
        isPanDetailsVerified: false,
        panDetailsErrorMessage: '',
        panOverwriteMismatch: false,
        panOverwriteName: null,
        isPersonalPanModifiedAfterVerification: false,
      ),
    );

    try {
      final userId = await Prefobj.preferences.get(Prefkeys.userId) ?? '';
      final userJson = await Prefobj.preferences.get(Prefkeys.userKycDetail);
      final userDetail = userJson != null ? jsonDecode(userJson) : null;
      final isFreelancer = userDetail?['personal_details']?['payment_purpose'] == "freelancer";

      final GetPanDetailModel response = await _personalUserKycRepository.getPanDetails(
        panNumber: event.panNumber,
        userId: userId,
        kycRole: isFreelancer ? "FREELANCER" : "FAMILY_&_FRIENDS",
      );

      if (response.success == true) {
        final String panName = response.data?.nameInformation?.panNameCleaned ?? '';
        final String previousName = state.fullNameController.text.trim();
        final bool isDifferent = panName.isNotEmpty && panName.toLowerCase() != previousName.toLowerCase();

        // IMPORTANT: Do NOT update storage or fullname here, just mark mismatch state
        emit(
          state.copyWith(
            isPanDetailsLoading: false,
            fullNamePan: panName,
            panNameController: TextEditingController(text: panName),
            isPanDetailsVerified: true,
            panOverwriteMismatch: isDifferent,
            panOverwriteName: isDifferent ? panName : null,
            showOverwriteToast: false,
            isPersonalPanModifiedAfterVerification: true,
          ),
        );

        add(PersonalPanEditAttempt());
      } else {
        emit(
          state.copyWith(
            isPanDetailsLoading: false,
            isPanDetailsVerified: false,
            panOverwriteMismatch: false,
            panOverwriteName: null,
            showOverwriteToast: false,
            panDetailsErrorMessage: response.error ?? '',
            isPersonalPanModifiedAfterVerification: false,
            originalPanNumber: '',
          ),
        );
      }
    } catch (e) {
      Logger.error(e.toString());
      emit(
        state.copyWith(
          isPanDetailsLoading: false,
          isPanDetailsVerified: false,
          panOverwriteMismatch: false,
          panOverwriteName: null,
          showOverwriteToast: false,
          isPersonalPanModifiedAfterVerification: false,
        ),
      );
    }
  }

  Future<void> _onPersonalConfirmOverwrite(
    PersonalConfirmOverwrite event,
    Emitter<PersonalAccountSetupState> emit,
  ) async {
    if (state.panOverwriteMismatch && state.panOverwriteName != null) {
      state.fullNameController.text = state.panOverwriteName!;
      await Prefobj.preferences.put(Prefkeys.loggedUserName, state.panOverwriteName!);
      emit(state.copyWith(panOverwriteMismatch: false, panOverwriteName: null, showOverwriteToast: true));
    }
  }

  void _onPersonalOverwriteToastAcknowledged(
    PersonalOverwriteToastAcknowledged event,
    Emitter<PersonalAccountSetupState> emit,
  ) {
    emit(state.copyWith(showOverwriteToast: false));
  }

  void _onPersonalPanNumberChanged(PersonalPanNumberChanged event, Emitter<PersonalAccountSetupState> emit) {
    if (state.isPersonalPanEditLocked) {
      add(PersonalPanEditAttempt());
    } else if (state.isPanDetailsVerified == true) {
      // Only reset verification state if the number has actually changed
      if (state.originalPanNumber != null && event.panNumber != state.originalPanNumber) {
        emit(state.copyWith(isPanDetailsVerified: true));
      }
    } else {
      emit(
        state.copyWith(
          isPanDetailsVerified: false,
          panDetailsErrorMessage: '',
          stateNameController: TextEditingController(),
          isPersonalPanModifiedAfterVerification: false,
        ),
      );
    }
  }

  Future<void> _onPersonalPanEditAttempt(PersonalPanEditAttempt event, Emitter<PersonalAccountSetupState> emit) async {
    final result = handlePanEditAttempt(
      isLocked: state.isPersonalPanEditLocked,
      lockTime: state.personalPanEditLockTime,
      attempts: state.personalPanEditAttempts,
      panType: 'PAN',
    );

    if (result.shouldUnlock) {
      emit(
        state.copyWith(
          isPersonalPanEditLocked: false,
          personalPanEditLockTime: null,
          personalPanEditAttempts: 0,
          personalPanEditErrorMessage: '',
        ),
      );
      return;
    }

    if (result.isLocked) {
      emit(
        state.copyWith(
          personalPanEditErrorMessage: result.errorMessage,
          isPersonalPanEditLocked: result.isLocked,
          personalPanEditLockTime: result.lockTime,
          personalPanEditAttempts: result.attempts,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        personalPanEditAttempts: result.attempts,
        personalPanEditErrorMessage: result.errorMessage,
        isPersonalPanEditLocked: result.isLocked,
        personalPanEditLockTime: result.lockTime,
      ),
    );
  }

  Future<void> _onGetCityAndState(GetCityAndState event, Emitter<PersonalAccountSetupState> emit) async {
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

  void _onChangeAgreeToAddressSameAsAadhar(
    ChangeAgreeToAddressSameAsAadhar event,
    Emitter<PersonalAccountSetupState> emit,
  ) {
    emit(state.copyWith(isAgreeToAddressSameAsAadhar: event.isAgree));
  }

  void _onPersonalAppBarCollapseChanged(PersonalAppBarCollapseChanged event, Emitter<PersonalAccountSetupState> emit) {
    emit(state.copyWith(isCollapsed: event.isCollapsed));
  }

  void _onPersonalEkycAppBarCollapseChanged(
    PersonalEkycAppBarCollapseChanged event,
    Emitter<PersonalAccountSetupState> emit,
  ) {
    emit(state.copyWith(isEkycCollapsed: event.isCollapsed));
  }

  void _onUploadICECertificate(PersonalUploadICECertificate event, Emitter<PersonalAccountSetupState> emit) {
    emit(state.copyWith(isIceCertificateFileDeleted: false));
    if (event.fileData == null) {
      emit(state.copyWith(iceCertificateFile: null, isIceCertificateFileDeleted: true));
    } else {
      emit(state.copyWith(iceCertificateFile: event.fileData, isIceCertificateFileDeleted: false));
    }
  }

  Future<void> _onICEVerificationSubmitted(
    PersonalICEVerificationSubmitted event,
    Emitter<PersonalAccountSetupState> emit,
  ) async {
    // Check if data has been changed, if not, skip API call and just navigate
    if (!state.isIceVerificationDataChanged && state.iceCertificateFile != null) {
      final index = state.currentKycVerificationStep.index;
      if (index < PersonalEKycVerificationSteps.values.length - 1) {
        add(PersonalKycStepChange(PersonalEKycVerificationSteps.values[index + 1]));
      }
      return;
    }

    emit(state.copyWith(isIceVerifyingLoading: true));
    final String? userId = await Prefobj.preferences.get(Prefkeys.userId);

    try {
      final response = await _personalUserKycRepository.uploadBusinessLegalDocuments(
        userID: userId ?? '',
        userType: 'personal',
        documentType: 'IEC',
        documentNumber: event.iceNumber ?? '',
        documentFrontImage: event.fileData,
      );
      if (response.success == true) {
        final index = state.currentKycVerificationStep.index;
        if (index < PersonalEKycVerificationSteps.values.length - 1) {
          add(PersonalKycStepChange(PersonalEKycVerificationSteps.values[index + 1]));
        }
        emit(state.copyWith(isIceVerifyingLoading: false));
        // Reset the data change flag after successful save
        add(PersonalResetDataChangeFlags());
      } else {
        emit(state.copyWith(isIceVerifyingLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isIceVerifyingLoading: false));
    }
  }

  void _onPersonalAadharNumberChanged(
    PersonalAadharNumberChanged event,
    Emitter<PersonalAccountSetupState> emit,
  ) async {
    // Only reset verification state if the number has actually changed
    if (state.originalAadharNumber != null && event.newAadharNumber != state.originalAadharNumber) {
      emit(
        state.copyWith(
          isCaptchaSend: false,
          isOtpSent: false,
          captchaImage: null,
          captchaInputController: TextEditingController(),
          aadharOtpController: TextEditingController(),
          isIdVerified: false,
          // Reset any other relevant fields
        ),
      );
    }
  }

  void _onLoadPersonalKycFromLocal(LoadPersonalKycFromLocal event, Emitter<PersonalAccountSetupState> emit) async {
    add(PersonalResetData());
    await Future.delayed(Duration.zero); // Ensure the event is processed first
    emit(state.copyWith(isLocalDataLoading: true));
    final userId = await Prefobj.preferences.get(Prefkeys.userId);
    final userKycDetailResponse = await _authRepository.getKycDetails(userId: userId ?? '');
    if (userKycDetailResponse.success == true) {
      await Prefobj.preferences.put(Prefkeys.userKycDetail, jsonEncode(userKycDetailResponse.data));

      final userJson = await Prefobj.preferences.get(Prefkeys.userKycDetail);
      if (userJson != null) {
        final userData = jsonDecode(userJson);

        // Dispatch file loading event for asynchronous file downloads
        add(LoadFilesFromApi(userData));
        // Personal details
        final personalDetails = userData['personal_details'] ?? {};

        // PAN - now separate object
        final panDoc = userData['pan_details'] ?? {};
        // Address
        final address = userData['user_address_documents'] ?? {};
        // GST
        final gst = userData['user_gst_details'] ?? {};

        // Identity documents - now single object
        final identityDoc = userData['user_identity_documents'] ?? {};

        // Aadhar - check if identity doc is Aadhaar type
        final aadhaarDoc = identityDoc['document_type'] == 'Aadhaar' ? identityDoc : null;

        // VoterID - check if identity doc is VoterID type
        final voterDoc = identityDoc['document_type'] == 'VoterID' ? identityDoc : null;

        // Passport - check if identity doc is Passport type
        final passportDoc = identityDoc['document_type'] == 'Passport' ? identityDoc : null;

        // Driving Licence - check if identity doc is DrivingLicense type
        final drivingDoc = identityDoc['document_type'] == 'DrivingLicense' ? identityDoc : null;

        // ICE - now separate object
        final iceDoc = userData['iec_details'] ?? {};

        // Add bank details parsing
        final bankDetails = userData['user_bank_details'] ?? {};

        // Helper to convert string to enum
        IDVerificationDocType? docTypeFromString(String? type) {
          switch (type) {
            case 'Aadhaar':
              return IDVerificationDocType
                  .aadharCard; // If you want to map Pan to aadharCard, otherwise return null or add Pan to enum
            case 'VoterID':
              return IDVerificationDocType.voterID;
            case 'Passport':
              return IDVerificationDocType.passport;
            case 'DrivingLicense':
              return IDVerificationDocType.drivingLicense;
            default:
              return null;
          }
        }

        // Set selectedIDVerificationDocType to the first available doc type
        String? selectedDocType;
        if (aadhaarDoc != null) {
          selectedDocType = 'Aadhaar';
        } else if (voterDoc != null) {
          selectedDocType = 'VoterID';
        } else if (passportDoc != null) {
          selectedDocType = 'Passport';
        } else if (drivingDoc != null) {
          selectedDocType = 'DrivingLicense';
        }

        final selectedIDVerificationDocType = docTypeFromString(selectedDocType);

        // state.isvoterIdVerified = voterDoc != null ? true  : false;
        state.fullNameController.text = personalDetails['legal_full_name'] ?? '';
        state.productServiceDescriptionController.text = personalDetails['product_desc'] ?? '';
        // Fix: handle profession as List or String
        final profession = personalDetails['profession'];
        if (profession is List) {
          state.professionOtherController.text = profession.join(', ');
        } else if (profession is String) {
          state.professionOtherController.text = profession;
        } else {
          state.professionOtherController.text = '';
        }
        state.panNumberController.text = panDoc['document_number'] ?? '';
        state.panNameController.text = panDoc['name_on_pan'] ?? '';
        state.voterIdNumberController.text = voterDoc != null ? voterDoc['document_number'] ?? '' : '';
        state.passportNumberController.text = passportDoc != null ? passportDoc['document_number'] ?? '' : '';
        state.drivingLicenceController.text = drivingDoc != null ? drivingDoc['document_number'] ?? '' : '';
        state.iceNumberController.text = iceDoc['document_number'] ?? '';
        state.pinCodeController.text = address['pincode'] ?? '';
        state.stateNameController.text = address['state'] ?? '';
        state.cityNameController.text = address['city'] ?? '';
        state.address1NameController.text = address['address_line1'] ?? '';
        state.gstNumberController.text = gst['gst_number'] ?? '';
        state.turnOverController.text = gst['estimated_annual_income'] ?? '';
        state.aadharNumberController.text = aadhaarDoc != null ? aadhaarDoc['document_number'] ?? '' : '';
        // Set bank controllers
        state.bankAccountNumberController.text = bankDetails['account_number'] ?? '';
        state.reEnterbankAccountNumberController.text = bankDetails['account_number'] ?? '';
        state.ifscCodeController.text = bankDetails['ifsc_code'] ?? '';

        // File loading will be handled by LoadFilesFromApi event

        // Determine which eKYC step is incomplete and set currentKycVerificationStep accordingly
        PersonalEKycVerificationSteps nextKycStep = state.currentKycVerificationStep;
        // Check verification status for each step
        final bool isIdentityVerified = identityDoc['identity_verify_status'] == 'SUBMITTED';
        final bool isPanVerified = panDoc['pan_verify_status'] == 'SUBMITTED';
        final bool isAddressVerified = address['resident_verify_status'] == 'SUBMITTED';
        final bool isGstVerified = gst.isNotEmpty && gst['gst_verify_status'] == 'SUBMITTED';
        final bool isIceVerified = iceDoc.isNotEmpty && iceDoc['ice_verify_status'] == 'SUBMITTED';
        final bool isBankVerified = bankDetails.isNotEmpty && bankDetails['bank_verify_status'] == 'SUBMITTED';

        if (!isIdentityVerified) {
          nextKycStep = PersonalEKycVerificationSteps.identityVerification;
        } else if (!isPanVerified) {
          nextKycStep = PersonalEKycVerificationSteps.panDetails;
        } else if (!isAddressVerified) {
          nextKycStep = PersonalEKycVerificationSteps.residentialAddress;
        } else if (!isGstVerified) {
          nextKycStep = PersonalEKycVerificationSteps.annualTurnoverDeclaration;
        } else if (!isIceVerified) {
          nextKycStep = PersonalEKycVerificationSteps.iecVerification;
        } else if (!isBankVerified) {
          nextKycStep = PersonalEKycVerificationSteps.bankAccountLinking;
        } else {
          // All steps are completed, stay on the last step
          nextKycStep = PersonalEKycVerificationSteps.bankAccountLinking;
        }

        Logger.info('Next KYC Step: $nextKycStep');

        String selectedPurpose() {
          if (personalDetails['payment_purpose'] == 'freelancer') {
            return 'I\'m a Freelancer';
          } else if (personalDetails['payment_purpose'] == 'family_and_friends') {
            return 'It\'s for Family and Friends';
          } else {
            return '';
          }
        }

        emit(
          state.copyWith(
            fullName: personalDetails['legal_full_name'] ?? '',
            selectedPurpose: selectedPurpose(),
            productServiceDescriptionController: state.productServiceDescriptionController,
            professionOtherController: state.professionOtherController,
            panNumberController: state.panNumberController,
            panNameController: state.panNameController,
            voterIdNumberController: state.voterIdNumberController,
            passportNumberController: state.passportNumberController,
            drivingLicenceController: state.drivingLicenceController,
            iceNumberController: state.iceNumberController,
            pinCodeController: state.pinCodeController,
            stateNameController: state.stateNameController,
            cityNameController: state.cityNameController,
            address1NameController: state.address1NameController,
            gstNumberController: state.gstNumberController,
            turnOverController: state.turnOverController,
            selectedAnnualTurnover: gst['estimated_annual_income'] ?? '',
            gstLegalName: gst['legal_name'] ?? '',
            selectedIDVerificationDocType: selectedIDVerificationDocType,
            isvoterIdVerified: voterDoc != null ? true : false,
            isDrivingIdVerified: drivingDoc != null ? true : false,
            drivingLicenseNumber: drivingDoc != null ? drivingDoc['document_number'] ?? '' : '',
            ispassportIdVerified: passportDoc != null ? true : false,
            passporteNumber: passportDoc != null ? passportDoc['document_number'] ?? '' : '',
            voterIDNumber: voterDoc != null ? voterDoc['document_number'] ?? '' : '',
            isIdVerified: identityDoc['identity_verify_status'] == 'SUBMITTED',
            isPanDetailsVerified: (panDoc['name_on_pan'] ?? '').isNotEmpty ? true : false,
            isPersonalPanModifiedAfterVerification: (panDoc['name_on_pan'] ?? '').isNotEmpty ? true : false,
            selectedAddressVerificationDocType:
                address != null && address['document_type'] != null
                    ? (address['document_type']).replaceAllMapped(
                      RegExp(r'(?<!^)([A-Z])'),
                      (match) => ' ${match.group(1)}',
                    )
                    : '',
            isGstCertificateMandatory:
                gst != null && gst['estimated_annual_income'] != null
                    ? (gst['estimated_annual_income'].contains("Less than") ? false : true)
                    : false,
            isGSTNumberVerify: (gst != null && gst['gst_number'] != null && gst['gst_number'] != '') ? true : false,
            currentKycVerificationStep: nextKycStep,
            aadharNumber: aadhaarDoc != null ? aadhaarDoc['document_number'] ?? '' : '',
            aadharNumberController: state.aadharNumberController,
            // Seed originals from API so skip logic works without needing an Edit first
            originalAadharNumber:
                (aadhaarDoc != null && (aadhaarDoc['document_number'] ?? '').toString().isNotEmpty)
                    ? aadhaarDoc['document_number']
                    : state.originalAadharNumber,
            originalPanNumber:
                ((panDoc['document_number'] ?? '').toString().isNotEmpty)
                    ? panDoc['document_number']
                    : state.originalPanNumber,
            originalGstNumber:
                ((gst['gst_number'] ?? '').toString().isNotEmpty) ? gst['gst_number'] : state.originalGstNumber,
            originalBankAccountNumber:
                ((bankDetails['account_number'] ?? '').toString().isNotEmpty)
                    ? bankDetails['account_number']
                    : state.originalBankAccountNumber,

            isBankAccountVerify: bankDetails['account_holder_name'] != null ? true : false,
            selectedBankAccountVerificationDocType:
                bankDetails['document_type'] != null
                    ? (bankDetails['document_type']).replaceAllMapped(
                      RegExp(r'(?<!^)([A-Z])'),
                      (match) => ' ${match.group(1)}',
                    )
                    : '',
            bankAccountNumber: bankDetails['account_number'] ?? '',
            ifscCode: bankDetails['ifsc_code'] ?? '',
            accountHolderName: bankDetails['account_holder_name'] ?? '',
          ),
        );

        emit(state.copyWith(isLocalDataLoading: false));
        event.completer?.complete();
      }
    }
  }

  void _onLoadFilesFromApi(LoadFilesFromApi event, Emitter<PersonalAccountSetupState> emit) async {
    try {
      final userData = event.userData;

      // PAN - now separate object
      final panDoc = userData['pan_details'] ?? {};

      // Identity documents - now single object
      final identityDoc = userData['user_identity_documents'] ?? {};

      // Check document types
      final aadhaarDoc = identityDoc['document_type'] == 'Aadhaar' ? identityDoc : null;
      final voterDoc = identityDoc['document_type'] == 'VoterID' ? identityDoc : null;
      final passportDoc = identityDoc['document_type'] == 'Passport' ? identityDoc : null;
      final drivingDoc = identityDoc['document_type'] == 'DrivingLicense' ? identityDoc : null;

      // Address
      final address = userData['user_address_documents'] ?? {};

      // GST
      final gst = userData['user_gst_details'] ?? {};

      // ICE - now separate object
      final iceDoc = userData['iec_details'] ?? {};

      // Bank details
      final bankDetails = userData['user_bank_details'] ?? {};

      // Download Voter ID files
      if (voterDoc != null && voterDoc['front_doc_url'] != null) {
        final fileData = await getFileDataFromPath(voterDoc['front_doc_url'], 'VoterID');
        if (fileData != null) {
          emit(state.copyWith(voterIdFrontFile: fileData, isVoteridFrontFileUploaded: true));
        }
      }

      // Download PAN files
      if (panDoc != null && panDoc['front_doc_url'] != null) {
        final fileData = await getFileDataFromPath(panDoc['front_doc_url'], 'Pan');
        if (fileData != null) {
          emit(state.copyWith(panFileData: fileData));
        }
      }

      // Download Passport files
      if (passportDoc != null && passportDoc['front_doc_url'] != null) {
        final fileData = await getFileDataFromPath(passportDoc['front_doc_url'], 'Passport');
        if (fileData != null) {
          emit(state.copyWith(passportFrontFile: fileData, isPassportFrontFileUploaded: true));
        }
      }

      // Download Driving License files
      if (drivingDoc != null && drivingDoc['front_doc_url'] != null) {
        final fileData = await getFileDataFromPath(drivingDoc['front_doc_url'], 'DrivingLicense');
        if (fileData != null) {
          emit(state.copyWith(drivingLicenceFrontSideFile: fileData, isDrivingLicenceFrontSideFileUploaded: true));
        }
      }

      // Download Aadhaar files
      if (aadhaarDoc != null && (aadhaarDoc['front_doc_url'] != '')) {
        final fileData = await getFileDataFromPath(aadhaarDoc['front_doc_url'], 'Aadhaar');
        if (fileData != null) {
          if (aadhaarDoc['document_type'] == 'Aadhaar') {
            emit(state.copyWith(frontSideAdharFile: fileData, isFrontSideAdharFileUploaded: true));
          } else {
            emit(state.copyWith(frontSideAdharFile: fileData, isFrontSideAdharFileUploaded: false));
          }
        }
      }

      // Download Address document
      if (address != null && address['front_doc_url'] != null && address['front_doc_url'] != '') {
        final fileData = await getFileDataFromPath(address['front_doc_url'], address['document_type'] ?? 'Address');
        if (fileData != null) {
          emit(
            state.copyWith(
              addressVerificationFile: fileData,
              isFrontSideAddressAdharFileUploaded: true,
              isFrontSideAddressVerificationFileUploaded: true,
            ),
          );
        }
      }

      // Download GST Certificate
      if (gst != null && gst['gst_certificate_url'] != null && gst['gst_certificate_url'] != '') {
        final fileData = await getFileDataFromPath(gst['gst_certificate_url'], "GST");
        if (fileData != null) {
          emit(state.copyWith(gstCertificateFile: fileData));
        }
      }

      // Download ICE Certificate
      if (iceDoc != null && iceDoc['doc_url'] != null) {
        final fileData = await getFileDataFromPath(iceDoc['doc_url'], "ICE");
        if (fileData != null) {
          emit(state.copyWith(iceCertificateFile: fileData));
        }
      }

      // Download Bank proof document
      if (bankDetails != null && bankDetails['document_url'] != null && bankDetails['document_url'] != '') {
        final fileData = await getFileDataFromPath(bankDetails['document_url'], bankDetails['document_type'] ?? 'Bank');
        if (fileData != null) {
          emit(state.copyWith(bankVerificationFile: fileData));
        }
      }
      // Force a rebuild by emitting a state change
      emit(state.copyWith());
    } catch (e) {
      Logger.error('Error loading personal files from API: $e');
    }
  }

  Future<void> _refreshKycFileData() async {
    final userJson = await Prefobj.preferences.get(Prefkeys.userKycDetail);
    if (userJson != null) {
      final userData = jsonDecode(userJson);

      // PAN - now separate object
      final panDoc = userData['pan_details'] ?? {};

      // Identity documents - now single object
      final identityDoc = userData['user_identity_documents'] ?? {};

      // Check document types
      final aadhaarDoc = identityDoc['document_type'] == 'Aadhaar' ? identityDoc : null;
      final voterDoc = identityDoc['document_type'] == 'VoterID' ? identityDoc : null;
      final passportDoc = identityDoc['document_type'] == 'Passport' ? identityDoc : null;
      final drivingDoc = identityDoc['document_type'] == 'DrivingLicense' ? identityDoc : null;

      final gst = userData['user_gst_details'] ?? {};

      final address = userData['user_address_documents'] ?? {};

      // ICE - now separate object
      final iceDoc = userData['iec_details'] ?? {};

      if (voterDoc != null && voterDoc['front_doc_url'] != null) {
        final fileData = await getFileDataFromPath(voterDoc['front_doc_url'], 'VoterID');
        if (fileData != null) {
          emit(state.copyWith(voterIdFrontFile: fileData));
        }
      }
      if (panDoc != null && panDoc['front_doc_url'] != null) {
        final fileData = await getFileDataFromPath(panDoc['front_doc_url'], 'Pan');
        if (fileData != null) {
          emit(state.copyWith(panFileData: fileData));
        }
      }
      if (passportDoc != null && passportDoc['front_doc_url'] != null) {
        final fileData = await getFileDataFromPath(passportDoc['front_doc_url'], 'Passport');
        if (fileData != null) {
          emit(state.copyWith(passportFrontFile: fileData));
        }
      }
      if (drivingDoc != null && drivingDoc['front_doc_url'] != null) {
        final fileData = await getFileDataFromPath(drivingDoc['front_doc_url'], 'DrivingLicense');
        if (fileData != null) {
          emit(state.copyWith(drivingLicenceFrontSideFile: fileData));
        }
      }
      if (aadhaarDoc != null && aadhaarDoc['front_doc_url'] != '') {
        final fileData = await getFileDataFromPath(aadhaarDoc['front_doc_url'], 'Aadhaar');
        if (fileData != null) {
          emit(state.copyWith(frontSideAdharFile: fileData));
        }
      }
      if (aadhaarDoc != null && aadhaarDoc['back_doc_url'] != null) {
        final fileData = await getFileDataFromPath(aadhaarDoc['back_doc_url'], 'Aadhaar');
        if (fileData != null) {
          emit(state.copyWith(backSideAdharFile: fileData));
        }
      }
      if (address != null && address['front_doc_url'] != '') {
        final fileData = await getFileDataFromPath(address['front_doc_url'], address['document_type']);
        if (fileData != null) {
          emit(
            state.copyWith(
              addressVerificationFile: fileData,
              isFrontSideAddressAdharFileUploaded: true,
              isFrontSideAddressVerificationFileUploaded: true,
            ),
          );
        }
      }

      if (gst != null && gst['gst_certificate_url'] != '') {
        final fileData = await getFileDataFromPath(gst['gst_certificate_url'], "GST");
        if (fileData != null) {
          emit(state.copyWith(gstCertificateFile: fileData));
        }
      }

      if (iceDoc['doc_url'] != null) {
        final fileData = await getFileDataFromPath(iceDoc['doc_url'], "ICE");
        if (fileData != null) {
          emit(state.copyWith(iceCertificateFile: fileData));
        }
      }
    }
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

  void _onPersonalChangeShowDescription(
    PersonalChangeShowDescription event,
    Emitter<PersonalAccountSetupState> emit,
  ) async {
    emit(state.copyWith(isShowServiceDescriptionBox: event.isShowDescriptionbox));
  }

  // Data change tracking event handlers
  void _onPersonalMarkIdentityVerificationDataChanged(
    PersonalMarkIdentityVerificationDataChanged event,
    Emitter<PersonalAccountSetupState> emit,
  ) {
    emit(state.copyWith(isIdentityVerificationDataChanged: true));
  }

  void _onPersonalMarkPanDetailsDataChanged(
    PersonalMarkPanDetailsDataChanged event,
    Emitter<PersonalAccountSetupState> emit,
  ) {
    emit(state.copyWith(isPanDetailsDataChanged: true));
  }

  void _onPersonalMarkResidentialAddressDataChanged(
    PersonalMarkResidentialAddressDataChanged event,
    Emitter<PersonalAccountSetupState> emit,
  ) {
    emit(state.copyWith(isResidentialAddressDataChanged: true));
  }

  void _onPersonalMarkAnnualTurnoverDataChanged(
    PersonalMarkAnnualTurnoverDataChanged event,
    Emitter<PersonalAccountSetupState> emit,
  ) {
    emit(state.copyWith(isAnnualTurnoverDataChanged: true));
  }

  void _onPersonalMarkBankAccountDataChanged(
    PersonalMarkBankAccountDataChanged event,
    Emitter<PersonalAccountSetupState> emit,
  ) {
    emit(state.copyWith(isBankAccountDataChanged: true));
  }

  void _onPersonalMarkIceVerificationDataChanged(
    PersonalMarkIceVerificationDataChanged event,
    Emitter<PersonalAccountSetupState> emit,
  ) {
    emit(state.copyWith(isIceVerificationDataChanged: true));
  }

  void _onPersonalResetDataChangeFlags(PersonalResetDataChangeFlags event, Emitter<PersonalAccountSetupState> emit) {
    emit(
      state.copyWith(
        isIdentityVerificationDataChanged: false,
        isPanDetailsDataChanged: false,
        isResidentialAddressDataChanged: false,
        isAnnualTurnoverDataChanged: false,
        isBankAccountDataChanged: false,
        isIceVerificationDataChanged: false,
      ),
    );
  }

  // Original value storage event handlers
  void _onPersonalStoreOriginalAadharNumber(
    PersonalStoreOriginalAadharNumber event,
    Emitter<PersonalAccountSetupState> emit,
  ) {
    emit(state.copyWith(originalAadharNumber: event.originalNumber));
  }

  void _onPersonalStoreOriginalPanNumber(
    PersonalStoreOriginalPanNumber event,
    Emitter<PersonalAccountSetupState> emit,
  ) {
    emit(state.copyWith(originalPanNumber: event.originalNumber));
  }

  void _onPersonalStoreOriginalGstNumber(
    PersonalStoreOriginalGstNumber event,
    Emitter<PersonalAccountSetupState> emit,
  ) {
    emit(state.copyWith(originalGstNumber: event.originalNumber, isGSTNumberVerify: false));
  }

  void _onPersonalStoreOriginalBankAccountNumber(
    PersonalStoreOriginalBankAccountNumber event,
    Emitter<PersonalAccountSetupState> emit,
  ) {
    // Only store original without resetting verification; resetting caused unnecessary API calls
    emit(state.copyWith(originalBankAccountNumber: event.originalNumber, isBankAccountVerify: false));
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    _aadhartimer?.cancel();
    _cameraController?.dispose();
    state.fullNameController.dispose();
    state.websiteController.dispose();
    state.personalDbaController.dispose();
    state.mobileController.dispose();
    state.otpController.dispose();
    _resendTimer?.cancel();
    state.scrollController.dispose();
    await cron?.close();
    return super.close();
  }
}
