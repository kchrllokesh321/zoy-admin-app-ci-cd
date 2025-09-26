import 'dart:convert';
import 'package:exchek/core/utils/exports.dart';
import 'package:equatable/equatable.dart';
import 'package:exchek/models/auth_models/common_success_model.dart';
import 'package:exchek/models/auth_models/email_availabilty_model.dart';
import 'package:exchek/models/auth_models/login_email_register_model.dart';
import 'package:exchek/models/auth_models/mobile_availabilty_model.dart';
import 'package:exchek/models/auth_models/validate_login_otp_model.dart';
import 'package:exchek/models/auth_models/verify_email_model.dart';
import 'package:dio/dio.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  //Constants & Private Fields
  static const int initialTime = 120;
  static const int initialTimerForgetPassword = 120;
  static const int initialTimerForVerifyEmail = 120;

  Timer? _timer;
  Timer? _timerForgetPassword;
  Timer? _timerVerifyEmail;
  Timer? _timerEmailForgetPassword;
  Timer? _autoResendTimer;

  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(
        AuthState(
          phoneController: TextEditingController(),
          phonefocusnode: FocusNode(),
          forgotPasswordFormKey: GlobalKey<FormState>(),
          emailIdUserNameController: TextEditingController(),
          passwordController: TextEditingController(),
          otpController: TextEditingController(),
          resetNewPasswordController: TextEditingController(),
          emailIdPhoneNumberController: TextEditingController(),
          forgotPasswordOTPController: TextEditingController(),
          resetConfirmPasswordController: TextEditingController(),
          signupEmailIdController: TextEditingController(),
          resetPasswordFormKey: GlobalKey<FormState>(),
          signupFormKey: GlobalKey<FormState>(),
          phoneFormKey: GlobalKey<FormState>(),
          emailFormKey: GlobalKey<FormState>(),
          termsAndConditionScrollController: ScrollController(),
        ),
      ) {
    //Login Events
    on<ChangeLoginType>(_onChangeLoginType);
    on<ChanegPasswordVisibility>(_onChangePasswordVisibility);
    on<ResetNewPasswordChangeVisibility>(_onChangeResetNewPasswordVisibility);
    on<ResetConfirmPasswordChangeVisibility>(_onChangeResetConfirmPasswordVisibility);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<EmailLoginSubmitted>(_onEmailLoginSubmitted);

    //OTP & Password Events
    on<SendOtpPressed>(_onSendOtpPressed);
    on<OtpTimerTicked>(_onOtpTimerTicked);
    on<SendOtpForgotPasswordPressed>(_onSendOtpForgotPasswordPressed);
    on<ForgotPasswordOtpTimerTicked>(_onForgotPasswordOtpTimerTicked);
    on<ForgotPasswordEmailTimerTicked>(_onForgotPasswordEmailTimerTicked);
    on<ForgotPasswordSubmited>(_onForgotPasswordSubmitted);
    on<ForgotResetEmailSubmited>(_onForgotResetEmailSubmited);
    on<ResetPasswordSubmitted>(_onResetPasswordSubmit);
    on<ResetForgetPasswordSuccess>(_onResetForgetPasswordSuccess);

    //Terms & Email Verification
    on<TermsAndConditionSubmitted>(_onTermsAndConditionSubmittedSubmitted);
    on<OtpTimerTickedResendEmail>(_onVerifyEmailTimerTicked);
    on<ResendEmailLink>(_onResendEmailLink);
    on<ChangeAgreeTermsAndServiceAndPrivacyPolicy>(_onChangeAgreeTermsAndServiceAndPrivacyPolicy);
    on<HasReadTermsEvent>(_onHasReadTerms);

    //Social Auth
    on<GoogleSignInPressed>(_onGoogleSignInPressed);
    on<LinkedInSignInPressed>(_onLinkedInSignInPressed);
    on<AppleSignInPressed>(_onAppleSignInPressed);

    //Utility & Availability
    on<UpdateEmailEvent>(_onUpdateEmail);
    on<VerifyEmailEvent>(_onVerifyEmail);
    on<AutoResendEmailLink>(_onAutoResendEmailLink);

    on<LoadTermsAndConditions>(_onLoadTermsAndConditions);
    on<CheckEmailAvailability>(_onCheckEmailAvailability);
    on<CheckMobileAvailability>(_onCheckMobileAvailability);
    on<CancelForgotPasswordTimerManuallyEvent>(_onCancelForgotPasswordTimerManually);
    on<ClearResetPasswordManuallyEvent>(_onClearResetPasswordManuallyEvent);
    on<ClearLoginDataManuallyEvent>(_onClearLoginDataManuallyEvent);
    on<ClearSignupDataManuallyEvent>(_onClearSignupDataManuallyEvent);

    // New events for auto-resend timer management
    on<StartAutoResendTimerEvent>(_onStartAutoResendTimer);
    on<StopAutoResendTimerEvent>(_onStopAutoResendTimer);
    on<LoadEmailFromPreferencesEvent>(_onLoadEmailFromPreferences);
    on<ResetNavigationFlagEvent>(_onResetNavigationFlag);
  }

  // New event handlers
  void _onStartAutoResendTimer(StartAutoResendTimerEvent event, Emitter<AuthState> emit) {
    // Only start if not already active and email is available
    if (!state.isAutoResendTimerActive && (state.signupEmailIdController?.text.isNotEmpty ?? false)) {
      _autoResendTimer?.cancel();

      emit(state.copyWith(isAutoResendTimerActive: true));

      _autoResendTimer = Timer.periodic(const Duration(seconds: 10), (_) {
        final currentState = state;

        // Only trigger if not currently loading and email is available
        if (!currentState.isVerifyEmailLoading && (currentState.signupEmailIdController?.text.isNotEmpty ?? false)) {
          // Use the context from the event, or skip if not available
          if (event.context != null) {
            add(
              AutoResendEmailLink(emailId: currentState.signupEmailIdController?.text ?? '', context: event.context!),
            );
          }
        }
      });
    }
  }

  void _onResetNavigationFlag(ResetNavigationFlagEvent event, Emitter<AuthState> emit) {
    emit(state.copyWith(shouldNavigateToSelectAccount: false));
  }

  void _onStopAutoResendTimer(StopAutoResendTimerEvent event, Emitter<AuthState> emit) {
    _autoResendTimer?.cancel();
    _autoResendTimer = null;
    emit(state.copyWith(isAutoResendTimerActive: false));
  }

  void _onLoadEmailFromPreferences(LoadEmailFromPreferencesEvent event, Emitter<AuthState> emit) async {
    try {
      final email = await Prefobj.preferences.get(Prefkeys.emailId);
      if (email != null && email.isNotEmpty && (state.signupEmailIdController?.text.isEmpty ?? true)) {
        state.signupEmailIdController?.text = email;
        emit(state.copyWith()); // Trigger rebuild
      }
    } catch (e) {
      Logger.error('Failed to load email from preferences: $e');
    }
  }

  void _onCancelForgotPasswordTimerManually(CancelForgotPasswordTimerManuallyEvent event, Emitter<AuthState> emit) {
    _timerForgetPassword?.cancel();
    _autoResendTimer?.cancel(); // Also stop auto-resend timer
    emit(
      state.copyWith(
        isOtpTimerRunningForForgotPassword: false,
        isAutoResendTimerActive: false,
        forgotPasswordOTPController: TextEditingController(),
        emailIdPhoneNumberController: TextEditingController(),
        forgotPasswordFormKey: GlobalKey<FormState>(),
      ),
    );
    _timerForgetPassword = null;
    _autoResendTimer = null;
  }

  void _onClearResetPasswordManuallyEvent(ClearResetPasswordManuallyEvent event, Emitter<AuthState> emit) {
    emit(
      state.copyWith(
        resetNewPasswordController: TextEditingController(),
        resetConfirmPasswordController: TextEditingController(),
        resetPasswordFormKey: GlobalKey<FormState>(),
      ),
    );
  }

  void _onClearLoginDataManuallyEvent(ClearLoginDataManuallyEvent event, Emitter<AuthState> emit) async {
    // Clear controllers without recreating GlobalKeys to avoid conflicts
    state.emailIdUserNameController?.clear();
    state.passwordController?.clear();
    state.phoneController?.clear();
    state.otpController?.clear();
    emit(
      state.copyWith(
        emailIdUserNameController: TextEditingController(),
        passwordController: TextEditingController(),
        phoneController: TextEditingController(),
        otpController: TextEditingController(),
        isLoginSuccess: false,
        isOtpTimerRunning: false,
        isOtpRequestInProgress: false,
        otpRemainingTime: 0,
      ),
    );
  }

  void _onClearSignupDataManuallyEvent(ClearSignupDataManuallyEvent event, Emitter<AuthState> emit) async {
    // Clear controller without recreating GlobalKey to avoid conflicts
    state.signupEmailIdController?.clear();
    _autoResendTimer?.cancel(); // Stop auto-resend timer when clearing signup data
    emit(state.copyWith(signupEmailIdController: TextEditingController(), isAutoResendTimerActive: false));
    _autoResendTimer = null;
  }

  void _onChangeLoginType(ChangeLoginType event, Emitter<AuthState> emit) {
    emit(
      state.copyWith(
        selectedLoginType: event.selectedLoginType,
        isEmailCleared: true,
        isMobileCleared: true,
        isOtpTimerRunning: false,
      ),
    );
    _timer?.cancel();
    state.phoneController?.clear();
    state.otpController?.clear();
    state.emailIdUserNameController?.clear();
    state.passwordController?.clear();
  }

  void _onChangePasswordVisibility(ChanegPasswordVisibility event, Emitter<AuthState> emit) {
    emit(state.copyWith(isObscuredPassword: event.obscuredText));
  }

  void _onChangeResetNewPasswordVisibility(ResetNewPasswordChangeVisibility event, Emitter<AuthState> emit) {
    emit(state.copyWith(isNewPasswordObscured: event.obscuredText));
  }

  void _onChangeResetConfirmPasswordVisibility(ResetConfirmPasswordChangeVisibility event, Emitter<AuthState> emit) {
    emit(state.copyWith(isConfirmPasswordObscured: event.obscuredText));
  }

  void _onLoginSubmitted(LoginSubmitted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isloginLoading: true));
    // Reset navigation flags to avoid stale navigation after re-login
    emit(
      state.copyWith(
        shouldNavigateToDashboard: false,
        shouldNavigateToProceedWithKyc: false,
        shouldNavigateToKycUpload: false,
        shouldShowKycSubmittedMessage: false,
      ),
    );
    try {
      _timer?.cancel();
      final ValidateLoginOtpModel response = await _authRepository.validateLoginOtp(
        mobile: event.phoneNumber,
        otp: event.otp,
      );
      if (response.success == true) {
        final loggedUserName = response.data?.user?.userName ?? '';
        final loggedEmail = response.data?.user?.email ?? '';
        final loggedPhoneNumber = response.data?.user?.mobileNumber ?? '';
        Prefobj.preferences.put(Prefkeys.loggedUserName, loggedUserName);
        Prefobj.preferences.put(Prefkeys.loggedEmail, loggedEmail);
        Prefobj.preferences.put(Prefkeys.loggedPhoneNumber, loggedPhoneNumber);
        // state.phoneController?.clear();
        // state.otpController?.clear();
        Prefobj.preferences.put(Prefkeys.authToken, response.data?.token ?? '');
        Prefobj.preferences.put(Prefkeys.userId, response.data?.user?.userId ?? '');
        Prefobj.preferences.put(Prefkeys.finalKycStatus, response.data?.user?.finalKycStatus ?? '');
        final kycStatus = await Prefobj.preferences.get(Prefkeys.finalKycStatus);
        Logger.success('finalKycStatus: $kycStatus');

        // Handle KYC flow based on status
        await _handleKycFlow(kycStatus ?? '', emit);

        // TODO: USER  DETAILS API - BACKEND CODE NOT PROMOTED YET

        // Refresh headers so Authorization is included
      } else {
        emit(state.copyWith(isloginLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isloginLoading: false));
    }
  }

  void _onEmailLoginSubmitted(EmailLoginSubmitted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isloginLoading: true));
    // Reset navigation flags to avoid stale navigation after re-login
    emit(
      state.copyWith(
        shouldNavigateToDashboard: false,
        shouldNavigateToProceedWithKyc: false,
        shouldNavigateToKycUpload: false,
        shouldShowKycSubmittedMessage: false,
      ),
    );
    try {
      final LoginEmailPasswordModel response = await _authRepository.loginuser(
        email: event.emailIdOrUserName,
        password: event.password,
      );
      if (response.success == true) {
        final loggedUserName = response.data?.user?.userName ?? '';
        final loggedEmail = response.data?.user?.email ?? '';
        final loggedPhoneNumber = response.data?.user?.mobileNumber ?? '';
        Prefobj.preferences.put(Prefkeys.loggedPhoneNumber, loggedPhoneNumber);
        Prefobj.preferences.put(Prefkeys.loggedUserName, loggedUserName);
        Prefobj.preferences.put(Prefkeys.loggedEmail, loggedEmail);
        // state.emailIdPhoneNumberController?.clear();
        // state.passwordController?.clear();
        Prefobj.preferences.put(Prefkeys.authToken, response.data?.token ?? '');
        Prefobj.preferences.put(Prefkeys.userId, response.data?.user?.userId ?? '');
        Prefobj.preferences.put(Prefkeys.finalKycStatus, response.data?.user?.finalKycStatus ?? '');
        final kycStatus = await Prefobj.preferences.get(Prefkeys.finalKycStatus);
        Logger.success('finalKycStatus: $kycStatus');

        // Handle KYC flow based on status
        await _handleKycFlow(kycStatus ?? '', emit);

        // TODO: USER  DETAILS API - BACKEND CODE NOT PROMOTED YET

        // Refresh headers so Authorization is included
      } else {
        emit(state.copyWith(isloginLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isloginLoading: false));
    }
  }

  //OTP & Password Handlers
  Future<void> _onSendOtpPressed(SendOtpPressed event, Emitter<AuthState> emit) async {
    // Prevent multiple OTP requests if one is already in progress
    emit(state.copyWith(isOtpRequestInProgress: true));

    final MobileAvailabilityModel mobileAvailability = await _authRepository.mobileAvailability(
      mobileNumber: event.phoneNumber,
    );
    if (mobileAvailability.data?.exists == true) {
      try {
        // Set the flag to prevent multiple requests

        _timer?.cancel();
        emit(state.copyWith(isOtpTimerRunning: true, otpRemainingTime: initialTime));
        CommonSuccessModel response = await _authRepository.sendOtp(mobile: event.phoneNumber, type: "registration");
        if (response.success == true) {
          AppToast.show(message: response.message ?? '', type: ToastificationType.success);
        }
        _startOtpTimer();
        emit(state.copyWith(isOtpRequestInProgress: false));
      } catch (e) {
        emit(state.copyWith(isOtpTimerRunning: false, isOtpRequestInProgress: false));
        Logger.error(e.toString());
      } finally {
        // Reset the flag after the request is complete (success or failure)
        emit(state.copyWith(isOtpRequestInProgress: false));
      }
    } else {
      AppToast.show(
        message: 'This mobile number is not existing with us. Please try with registered mobile number',
        type: ToastificationType.error,
      );
      emit(state.copyWith(isOtpRequestInProgress: false));
    }
  }

  void _onOtpTimerTicked(OtpTimerTicked event, Emitter<AuthState> emit) {
    emit(state.copyWith(otpRemainingTime: event.remainingTime, isOtpTimerRunning: event.remainingTime > 0));
  }

  Future<void> _onSendOtpForgotPasswordPressed(SendOtpForgotPasswordPressed event, Emitter<AuthState> emit) async {
    // Prevent multiple OTP requests if one is already in progress
    emit(state.copyWith(isOtpRequestInProgressForForgotPassword: true));
    final MobileAvailabilityModel mobileAvailability = await _authRepository.mobileAvailability(
      mobileNumber: event.phoneNumber,
    );
    if (mobileAvailability.data?.exists == true) {
      try {
        // Set the flag to prevent multiple requests

        _timerForgetPassword?.cancel();
        CommonSuccessModel response = await _authRepository.sendOtp(mobile: event.phoneNumber, type: "forgot");
        AppToast.show(message: response.message ?? '', type: ToastificationType.success);
        if (response.success == true) {
          _startForgotPasswordOtpTimer();
          emit(
            state.copyWith(
              isOtpTimerRunningForForgotPassword: true,
              otpRemainingTimeForForgotPassword: initialTimerForgetPassword,
              isOtpRequestInProgressForForgotPassword: false,
            ),
          );
        }
      } catch (e) {
        Logger.error(e.toString());
      } finally {
        // Reset the flag after the request is complete (success or failure)
        emit(state.copyWith(isOtpRequestInProgressForForgotPassword: false));
      }
    } else {
      AppToast.show(
        message: 'This mobile number is not existing with us. Please try with registered mobile number',
        type: ToastificationType.error,
      );
      emit(state.copyWith(isOtpRequestInProgress: false));
    }
  }

  void _onForgotPasswordOtpTimerTicked(ForgotPasswordOtpTimerTicked event, Emitter<AuthState> emit) {
    emit(
      state.copyWith(
        otpRemainingTimeForForgotPassword: event.remainingTime,
        isOtpTimerRunningForForgotPassword: event.remainingTime > 0,
      ),
    );
  }

  void _onForgotPasswordEmailTimerTicked(ForgotPasswordEmailTimerTicked event, Emitter<AuthState> emit) {
    emit(
      state.copyWith(
        emailRemainingTimeForForgotPassword: event.remainingTime,
        isEmailTimerRunningForForgotPassword: event.remainingTime > 0,
      ),
    );
  }

  void _onForgotPasswordSubmitted(ForgotPasswordSubmited event, Emitter<AuthState> emit) async {
    int attempts = state.forgotPasswordOtpFailedAttempts;
    if (attempts >= 3) {
      AppToast.show(message: 'You can try with Email', type: ToastificationType.warning);
      return;
    }
    try {
      attempts++;
      emit(state.copyWith(isforgotPasswordLoading: true));
      Logger.error('attempts: $attempts');
      CommonSuccessModel response = await _authRepository.validateForgotPasswordOtp(
        mobile: event.emailIdOrPhoneNumber,
        otp: event.otp,
      );
      if (response.success == true) {
        _timerForgetPassword?.cancel();
        // AppToast.show(message: response.message ?? '', type: ToastificationType.success);
        emit(
          state.copyWith(
            isforgotPasswordLoading: false,
            isOtpTimerRunningForForgotPassword: false,
            isforgotPasswordSuccess: true,
            forgotPasswordOtpFailedAttempts: attempts,
          ),
        );
        if (kIsWeb) {
          event.context.go(RouteUri.resetPasswordRoute);
        } else {
          event.context.push(RouteUri.resetPasswordRoute);
        }
      } else {
        emit(state.copyWith(isforgotPasswordLoading: false, forgotPasswordOtpFailedAttempts: attempts));
      }
    } catch (e) {
      emit(state.copyWith(isforgotPasswordLoading: false, forgotPasswordOtpFailedAttempts: attempts));
    }
  }

  Future<void> _onForgotResetEmailSubmited(ForgotResetEmailSubmited event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isforgotPasswordLoading: true));
    final EmailAvailabilityModel emailAvailability = await _authRepository.emailAvailability(
      email: event.emailIdOrPhoneNumber,
    );
    if (emailAvailability.data?.exists == true) {
      try {
        CommonSuccessModel response = await _authRepository.resetPasswordVerificationLink(
          email: event.emailIdOrPhoneNumber,
          type: 'forgot_password',
        );
        if (response.success == true) {
          _startForgotPasswordEmailTimer();
          emit(state.copyWith(isforgotPasswordLoading: false, isOtpTimerRunningForForgotPassword: false));
          Prefobj.preferences.put(Prefkeys.emailId, event.emailIdOrPhoneNumber);
          _timerForgetPassword?.cancel();
          AppToast.show(message: response.message ?? '', type: ToastificationType.success);
        } else {
          emit(state.copyWith(isforgotPasswordLoading: false));
        }
      } catch (e) {
        emit(state.copyWith(isforgotPasswordLoading: false));
      }
    } else {
      emit(state.copyWith(isforgotPasswordLoading: false));
      AppToast.show(
        message: 'This email is not existing with us. Please try with registered email',
        type: ToastificationType.error,
      );
    }
  }

  void _onResetPasswordSubmit(ResetPasswordSubmitted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isResetPasswordLoading: true, isResetPasswordSuccess: false));
    try {
      final token = await Prefobj.preferences.get(Prefkeys.resetPasswordToken);
      CommonSuccessModel response = await _authRepository.updatePassword(
        confirmpassword: event.confirmpassword,
        email: token ?? '',
        mobilenumber: state.emailIdPhoneNumberController?.text ?? '',
        newpassword: event.password,
      );
      if (response.success == true) {
        await Prefobj.preferences.delete(Prefkeys.resetPasswordToken);
        emit(state.copyWith(isResetPasswordLoading: false, isResetPasswordSuccess: true));
        AppToast.show(message: response.message ?? '', type: ToastificationType.success);
        add(ClearLoginDataManuallyEvent());
      } else {
        emit(state.copyWith(isResetPasswordLoading: false));
        AppToast.show(message: response.message ?? '', type: ToastificationType.error);
      }
    } catch (e) {
      Logger.error(e.toString());
      emit(state.copyWith(isResetPasswordLoading: false));
    }
  }

  //Terms & Email Verification Handlers
  void _onTermsAndConditionSubmittedSubmitted(TermsAndConditionSubmitted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(issignupLoading: true));
    try {
      VerifyEmailModel response = await _authRepository.sendEmailVerificationLink(
        email: event.emailId,
        type: "email_verification",
      );
    if (response.data?.email == null){
       emit(state.copyWith(issignupLoading: false));
        Prefobj.preferences.deleteAll();
        _timerVerifyEmail?.cancel();
        _autoResendTimer?.cancel();
     if (kIsWeb) {
        event.context.replace(RouteUri.signupRoute);
      } else {
        event.context.pushReplacement(RouteUri.signupRoute);
       }
        AppToast.show(message: 'Account not found. Please check your email and try again', type: ToastificationType.error);
    }else if (response.success == true) {
        _timerVerifyEmail?.cancel();
        _startVerifyEmailTimer();

        // Start auto-resend timer after successful email verification link sent
        emit(
          state.copyWith(
            issignupLoading: false,
            issignupSuccess: true,
            otpRemainingTimeForverifyEmail: initialTimerForVerifyEmail,
            isAutoResendTimerActive: true,
          ),
        );

        // Start auto-resend timer
        _startAutoResendTimer(event.emailId, event.context);

        if (kIsWeb) {
          event.context.go(RouteUri.resendemailRoute);
        } else {
          event.context.push(RouteUri.resendemailRoute);
        }
        AppToast.show(message: response.data?.message ?? '', type: ToastificationType.success);
      } else {
        emit(state.copyWith(issignupLoading: false));
        if (response.data?.status == true) {
          AppToast.show(message: response.data?.message ?? '', type: ToastificationType.warning);
          Prefobj.preferences.put(Prefkeys.emailId, response.data?.email ?? '');
          Prefobj.preferences.put(Prefkeys.verifyemailToken, response.data?.token ?? '');
        } else {
          AppToast.show(message: response.data?.message ?? '', type: ToastificationType.info);
          Prefobj.preferences.put(Prefkeys.emailId, response.data?.email ?? '');
          Prefobj.preferences.put(Prefkeys.verifyemailToken, response.data?.token ?? '');
          if (kIsWeb) {
            event.context.replace(RouteUri.selectAccountTypeRoute);
          } else {
            event.context.pushReplacement(RouteUri.selectAccountTypeRoute);
          }
        }
      }
    } catch (e) {
      emit(state.copyWith(issignupLoading: false));
    }
  }

  void _onVerifyEmailTimerTicked(OtpTimerTickedResendEmail event, Emitter<AuthState> emit) {
    emit(
      state.copyWith(
        otpRemainingTimeForverifyEmail: event.remainingTime,
        isOtpTimerRunningForverifyEmail: event.remainingTime > 0,
      ),
    );
  }

  _onResendEmailLink(ResendEmailLink event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(isVerifyEmailLoading: true));
      final dio = Dio(
        BaseOptions(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) {
            return status != null && (status == 200 || status == 409 || status == 400);
          },
        ),
      );
      final response = await dio.post(
        ApiEndPoint.sendEmailVerificationLinkUrl,
        data: {'email': event.emailId, 'type': 'email_verification'},
      );
      if (response.statusCode == 200) {
        final verifyEmailModel = VerifyEmailModel.fromJson(response.data);
        if (verifyEmailModel.success == true) {
          _timerVerifyEmail?.cancel();
          _startVerifyEmailTimer();
          AppToast.show(message: verifyEmailModel.data?.message ?? '', type: ToastificationType.success);
          emit(
            state.copyWith(
              isVerifyEmailLoading: false,
              isVerifyEmail: true,
              otpRemainingTimeForverifyEmail: initialTimerForVerifyEmail,
            ),
          );
        }
      } else if (response.statusCode == 409) {
        final verifyEmailModel = VerifyEmailModel.fromJson(response.data);
        if (verifyEmailModel.data?.status == true) {
          emit(state.copyWith(isVerifyEmailLoading: false));
          AppToast.show(message: verifyEmailModel.data?.message ?? '', type: ToastificationType.warning);
        } else {
          final verifyEmailModel = VerifyEmailModel.fromJson(response.data);
          emit(state.copyWith(isVerifyEmailLoading: false));
          AppToast.show(message: verifyEmailModel.data?.message ?? '', type: ToastificationType.info);
          if (kIsWeb) {
            Prefobj.preferences.put(Prefkeys.emailId, verifyEmailModel.data?.email ?? '');
            Prefobj.preferences.put(Prefkeys.verifyemailToken, verifyEmailModel.data?.token ?? '');
            event.context.replace(RouteUri.selectAccountTypeRoute);
          } else {
            event.context.pushReplacement(RouteUri.selectAccountTypeRoute);
          }
        }
      } else {
        final verifyEmailModel = VerifyEmailModel.fromJson(response.data);
        AppToast.show(message: verifyEmailModel.data?.message ?? '', type: ToastificationType.error);
        emit(state.copyWith(isVerifyEmailLoading: false));
      }
    } catch (e) {
      Logger.error(e.toString());
      emit(state.copyWith(isVerifyEmailLoading: false));
    }
  }

  void _onResetForgetPasswordSuccess(ResetForgetPasswordSuccess event, Emitter<AuthState> emit) {
    emit(state.copyWith(isforgotPasswordSuccess: false));
  }

  void _onChangeAgreeTermsAndServiceAndPrivacyPolicy(
    ChangeAgreeTermsAndServiceAndPrivacyPolicy event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(isAgreeTermsAndServiceAndPrivacyPolicy: event.isAgree));
  }

  void _onHasReadTerms(HasReadTermsEvent event, Emitter<AuthState> emit) {
    emit(state.copyWith(hasReadTerms: event.hasRead));
  }

  //Social Auth Handlers
  Future<void> _onGoogleSignInPressed(GoogleSignInPressed event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(isSocialSignInLoading: true, socialSignInError: null));
      // final userData = await _authRepository.googleSignIn();
      // emit(
      //   state.copyWith(
      //     isSocialSignInLoading: false,
      //     socialUserData: userData,
      //     isLoginSuccess: true,
      //     userName: userData['userName'] ?? '',
      //     email: userData['email'] ?? '',
      //   ),
      // );
    } catch (error) {
      emit(state.copyWith(isSocialSignInLoading: false, socialSignInError: error.toString()));
    }
  }

  Future<void> _onLinkedInSignInPressed(LinkedInSignInPressed event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(isSocialSignInLoading: true, socialSignInError: null));
      // final userData = await _authRepository.linkedInSignIn();
      // emit(
      //   state.copyWith(
      //     isSocialSignInLoading: false,
      //     socialUserData: userData,
      //     isLoginSuccess: true,
      //     userName: userData['userName'] ?? '',
      //     email: userData['email'] ?? '',
      //   ),
      // );
    } catch (error) {
      emit(state.copyWith(isSocialSignInLoading: false, socialSignInError: error.toString()));
    }
  }

  Future<void> _onAppleSignInPressed(AppleSignInPressed event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(isSocialSignInLoading: true, socialSignInError: null));
      // final userData = await _authRepository.appleSignIn();
      // emit(
      //   state.copyWith(
      //     isSocialSignInLoading: false,
      //     socialUserData: userData,
      //     isLoginSuccess: true,
      //     userName: userData['userName'] ?? '',
      //     email: userData['email'] ?? '',
      //   ),
      // );
    } catch (error) {
      emit(state.copyWith(isSocialSignInLoading: false, socialSignInError: error.toString()));
    }
  }

  //Utility & Availability Handlers
  void _onUpdateEmail(UpdateEmailEvent event, Emitter<AuthState> emit) {
    if (state.signupEmailIdController != null) {
      state.signupEmailIdController?.text = event.email;
      emit(state.copyWith()); // Trigger a rebuild
    }
  }

  Future<void> _onVerifyEmail(VerifyEmailEvent event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(isVerifyEmailLoading: true));
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(isVerifyEmailLoading: false, isVerifyEmail: true));
    } catch (error) {
      emit(state.copyWith(isVerifyEmailLoading: false));
      rethrow;
    }
  }

  Future<void> _onAutoResendEmailLink(AutoResendEmailLink event, Emitter<AuthState> emit) async {
    try {
      // Use Dio with validateStatus for 200, 400, 409 as per your API design
      final dio = Dio(
        BaseOptions(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status != null && (status == 200 || status == 409 || status == 400),
        ),
      );

      final response = await dio.post(
        ApiEndPoint.sendEmailVerificationLinkUrl,
        data: {'email': event.emailId, 'type': 'email_verification'},
      );

      if (response.statusCode == 200) {
        final verifyEmailModel = VerifyEmailModel.fromJson(response.data);
        if (verifyEmailModel.success == true) {
          // Reset and start your verify email timer
          _timerVerifyEmail?.cancel();
          _startVerifyEmailTimer();

          emit(
            state.copyWith(
              isVerifyEmail: true,
              otpRemainingTimeForverifyEmail: initialTimerForVerifyEmail,
              // You may update other state if needed
            ),
          );
        }
      } else if (response.statusCode == 409) {
        final verifyEmailModel = VerifyEmailModel.fromJson(response.data);

        if (verifyEmailModel.data?.message?.contains("already been verified") == true &&
            verifyEmailModel.data?.status == false) {
          print(
            'Email already verified, stopping timers.${verifyEmailModel.data?.message} ${verifyEmailModel.data?.status}',
          );
          // Stop timers as user already verified
          _timerVerifyEmail?.cancel();
          _autoResendTimer?.cancel();

          // Store email and token in preferences
          await Prefobj.preferences.put(Prefkeys.emailId, verifyEmailModel.data?.email ?? event.emailId);
          await Prefobj.preferences.put(Prefkeys.verifyemailToken, verifyEmailModel.data?.token ?? '');

          // Update state to reflect timer stopped
          // emit(state.copyWith(isAutoResendTimerActive: false));
          emit(
            state.copyWith(
              isAutoResendTimerActive: false,
              shouldNavigateToSelectAccount: true, // This should trigger BlocListener
              isVerifyEmailLoading: false,
            ),
          );

          // Navigate accordingly
          if (kIsWeb) {
            event.context.replace(RouteUri.selectAccountTypeRoute);
          } else {
            event.context.pushReplacement(RouteUri.selectAccountTypeRoute);
          }

          return; // Exit early since navigation happened
        }

        // For other cases with 409 status, handle as per your logic
        if (verifyEmailModel.data?.status == true) {
          // Continue auto resend silently or handle warnings if needed
          // No state change required here unless you want to notify user
        } else {
          // Possibly already processed, navigate directly
          await Prefobj.preferences.put(Prefkeys.emailId, verifyEmailModel.data?.email ?? '');
          await Prefobj.preferences.put(Prefkeys.verifyemailToken, verifyEmailModel.data?.token ?? '');

          // Stop timer and update state
          _autoResendTimer?.cancel();
          emit(state.copyWith(isAutoResendTimerActive: false));

          if (kIsWeb) {
            event.context.replace(RouteUri.selectAccountTypeRoute);
          } else {
            event.context.pushReplacement(RouteUri.selectAccountTypeRoute);
          }

          return;
        }
      }
      // For 400/other codes or errors, just silently continue auto-resend, or optionally log
    } catch (e) {
      Logger.error('Auto-resend error: ${e.toString()}');
      // Swallow errors so auto-resend continues
    }
  }

  // Helper method for starting auto-resend timer (private)
  void _startAutoResendTimer(String email, BuildContext context) {
    _autoResendTimer?.cancel();

    // Immediately trigger once
    add(AutoResendEmailLink(emailId: email, context: context));

    _autoResendTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      // Check if timer should continue
      if (state.isAutoResendTimerActive) {
        add(AutoResendEmailLink(emailId: email, context: context));
      }
    });
  }

  Future<void> _onLoadTermsAndConditions(LoadTermsAndConditions event, Emitter<AuthState> emit) async {
    if (state.termsHtml != null) return; // Already loaded
    emit(state.copyWith(isLoadingTerms: true, termsError: null));
    try {
      final data = await rootBundle.loadString(Assets.termsAndCondition.termsAndConditions);
      emit(state.copyWith(termsHtml: data, isLoadingTerms: false));
    } catch (e) {
      emit(state.copyWith(termsError: e.toString(), isLoadingTerms: false));
    }
  }

  Future<void> _onCheckEmailAvailability(CheckEmailAvailability event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(issignupLoading: true, isEmailExists: false));
      final EmailAvailabilityModel emailAvailability = await _authRepository.emailAvailability(email: event.email);
      if (emailAvailability.data?.exists == true) {
        emit(state.copyWith(isEmailExists: true, issignupLoading: false));
        await Prefobj.preferences.put(Prefkeys.emailId, emailAvailability.data?.user?.email ?? '');
        await Prefobj.preferences.put(Prefkeys.mobileNumber, emailAvailability.data?.user?.mobileNumber ?? '');
        await Prefobj.preferences.put(Prefkeys.user, jsonEncode(emailAvailability.data?.user));
        AppToast.show(
          message: 'This email is already existing with us. Please try with different one',
          type: ToastificationType.error,
        );
      } else {
        emit(state.copyWith(isEmailExists: false, issignupLoading: false, hasReadTerms: false));
        final email = state.signupEmailIdController?.text ?? '';
        await Prefobj.preferences.put(Prefkeys.emailId, email);
        if (kIsWeb) {
          event.context.go(RouteUri.platformTermsOfUseView);
        } else {
          event.context.push(RouteUri.platformTermsOfUseView);
        }
      }
    } catch (e) {
      emit(state.copyWith(isEmailExists: false, issignupLoading: false));
      Logger.error(e.toString());
    }
  }

  Future<void> _onCheckMobileAvailability(CheckMobileAvailability event, Emitter<AuthState> emit) async {
    try {
      if (event.mobile.isNotEmpty) {
        final MobileAvailabilityModel mobileAvailability = await _authRepository.mobileAvailability(
          mobileNumber: event.mobile,
        );
        if (mobileAvailability.data?.exists == true) {
          emit(state.copyWith(isMobileExists: true, isMobileCleared: false));
          AppToast.show(
            message: 'This mobile number is already existing with us. Please try with different one',
            type: ToastificationType.error,
          );
        } else {
          emit(state.copyWith(isMobileExists: false, isMobileCleared: false));
        }
      } else {
        emit(state.copyWith(isMobileExists: false, isMobileCleared: true));
      }
    } catch (e) {
      emit(state.copyWith(isMobileExists: false));
    }
  }

  /// Handle KYC flow based on the user's KYC status
  Future<void> _handleKycFlow(String kycStatus, Emitter<AuthState> emit) async {
    try {
      switch (kycStatus.toUpperCase()) {
        case 'PENDING':
          // Call appropriate API and redirect to incomplete sections
          // For now, redirect to proceed with KYC view
          await _authRepository.apiClient.buildHeaders();
          final userId = await Prefobj.preferences.get(Prefkeys.userId);
          final userKycDetailResponse = await _authRepository.getKycDetails(userId: userId ?? '');
          if (userKycDetailResponse.success == true) {
            await Prefobj.preferences.put(Prefkeys.userKycDetail, jsonEncode(userKycDetailResponse.data));
            emit(
              state.copyWith(
                isloginLoading: false,
                isOtpTimerRunning: false,
                isLoginSuccess: true,
                shouldNavigateToProceedWithKyc: true,
              ),
            );
          }

          break;
        case 'INITIATED':
        case 'REJECTED':
        case 'PARTIAL_APPROVED':
          // Call appropriate API and redirect to incomplete sections
          // For now, redirect to proceed with KYC view
          await _authRepository.apiClient.buildHeaders();
          final userId = await Prefobj.preferences.get(Prefkeys.userId);
          final userKycDetailResponse = await _authRepository.getKycDetails(userId: userId ?? '');
          if (userKycDetailResponse.success == true) {
            await Prefobj.preferences.put(Prefkeys.userKycDetail, jsonEncode(userKycDetailResponse.data));
            emit(
              state.copyWith(
                isloginLoading: false,
                isOtpTimerRunning: false,
                isLoginSuccess: true,
                shouldNavigateToKycUpload: true,
              ),
            );
          }

          break;

        case 'SUBMITTED':
          // Display pop-up message or screen
          // "KYC will be verified within 24 hours"
          await _authRepository.apiClient.buildHeaders();
          final userId = await Prefobj.preferences.get(Prefkeys.userId);
          final userKycDetailResponse = await _authRepository.getKycDetails(userId: userId ?? '');
          if (userKycDetailResponse.success == true) {
            await Prefobj.preferences.put(Prefkeys.userKycDetail, jsonEncode(userKycDetailResponse.data));
            emit(
              state.copyWith(
                isloginLoading: false,
                isOtpTimerRunning: false,
                isLoginSuccess: true,
                shouldShowKycSubmittedMessage: true,
              ),
            );
          }
          break;

        case 'ACTIVE':
          // Redirect to dashboard screen
          // User can start other activities
          await _authRepository.apiClient.buildHeaders();
          final userId = await Prefobj.preferences.get(Prefkeys.userId);
          final userKycDetailResponse = await _authRepository.getKycDetails(userId: userId ?? '');
          if (userKycDetailResponse.success == true) {
            await Prefobj.preferences.put(Prefkeys.userKycDetail, jsonEncode(userKycDetailResponse.data));
            emit(
              state.copyWith(
                isloginLoading: false,
                isOtpTimerRunning: false,
                isLoginSuccess: true,
                shouldNavigateToDashboard: true,
              ),
            );
          }
          break;

        default:
          // Default case - redirect to proceed with KYC
          emit(
            state.copyWith(
              isloginLoading: false,
              isOtpTimerRunning: false,
              isLoginSuccess: true,
              shouldNavigateToKycUpload: true,
            ),
          );
          break;
      }
    } catch (e) {
      Logger.error('Error handling KYC flow: $e');
      // Fallback to default behavior
      emit(
        state.copyWith(
          isloginLoading: false,
          isOtpTimerRunning: false,
          isLoginSuccess: true,
          shouldNavigateToKycUpload: true,
        ),
      );
    }
  }

  //Timer Helpers
  void _startOtpTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final newTime = state.otpRemainingTime - 1;
      if (newTime <= 0) {
        timer.cancel();
        add(OtpTimerTicked(0));
      } else {
        add(OtpTimerTicked(newTime));
      }
    });
  }

  void _startForgotPasswordOtpTimer() {
    _timerForgetPassword = Timer.periodic(const Duration(seconds: 1), (timer) {
      final newTime = state.otpRemainingTimeForForgotPassword - 1;
      if (newTime <= 0) {
        timer.cancel();
        add(ForgotPasswordOtpTimerTicked(0));
      } else {
        add(ForgotPasswordOtpTimerTicked(newTime));
      }
    });
  }

  void _startForgotPasswordEmailTimer() {
    int remainingTime = initialTimerForgetPassword;
    _timerEmailForgetPassword?.cancel(); // clear any previous timer
    _timerEmailForgetPassword = Timer.periodic(const Duration(seconds: 1), (timer) {
      remainingTime -= 1;
      if (remainingTime <= 0) {
        timer.cancel();
        add(ForgotPasswordEmailTimerTicked(0));
      } else {
        add(ForgotPasswordEmailTimerTicked(remainingTime));
      }
    });
  }

  void _startVerifyEmailTimer() {
    _timerVerifyEmail = Timer.periodic(const Duration(seconds: 1), (timer) {
      final newTime = state.otpRemainingTimeForverifyEmail - 1;
      if (newTime <= 0) {
        _timerVerifyEmail?.cancel();
        add(OtpTimerTickedResendEmail(0));
      } else {
        add(OtpTimerTickedResendEmail(newTime));
      }
    });
  }

  //Bloc Close
  @override
  Future<void> close() {
    _timer?.cancel();
    _timerForgetPassword?.cancel();
    _timerVerifyEmail?.cancel();
    _autoResendTimer?.cancel();
    return super.close();
  }
}
