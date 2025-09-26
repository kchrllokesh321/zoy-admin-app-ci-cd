part of 'auth_bloc.dart';

class AuthState extends Equatable {
  // ================== Login Fields ==================
  final bool isloginLoading;
  final TextEditingController? phoneController;
  final FocusNode? phonefocusnode;
  final TextEditingController? otpController;
  final TextEditingController? emailIdUserNameController;
  final TextEditingController? passwordController;
  final LoginType selectedLoginType;
  final bool isObscuredPassword;
  final TextEditingController? emailIdPhoneNumberController;
  final TextEditingController? forgotPasswordOTPController;
  final GlobalKey<FormState> forgotPasswordFormKey;
  final GlobalKey<FormState> resetPasswordFormKey;
  final TextEditingController resetNewPasswordController;
  final TextEditingController? resetConfirmPasswordController;
  final bool isNewPasswordObscured;
  final bool isConfirmPasswordObscured;
  final TextEditingController? signupEmailIdController;
  final GlobalKey<FormState> signupFormKey;
  final int otpRemainingTime;
  final bool isOtpTimerRunning;
  final GlobalKey<FormState> phoneFormKey;
  final GlobalKey<FormState> emailFormKey;
  final bool isPollingVerification;
  final bool isOtpRequestInProgress;

  // ================== Password & OTP Fields ==================
  final bool isforgotPasswordLoading;
  final bool? isforgotPasswordSuccess;
  final int otpRemainingTimeForForgotPassword;
  final int emailRemainingTimeForForgotPassword;
  final bool isOtpTimerRunningForForgotPassword;
  final bool isOtpRequestInProgressForForgotPassword;
  final bool isEmailTimerRunningForForgotPassword;
  final bool isResetPasswordLoading;
  final bool isResetPasswordSuccess;

  // ================== Signup & Terms Fields ==================
  final bool issignupLoading;
  final bool issignupSuccess;
  final bool isAgreeTermsAndServiceAndPrivacyPolicy;
  final bool hasReadTerms;
  final ScrollController? termsAndConditionScrollController;
  final String? termsHtml;
  final bool isLoadingTerms;
  final String? termsError;
  final bool shouldNavigateToSelectAccount;

  // ================== Email Verification Fields ==================
  final bool isVerifyEmail;
  final bool isVerifyEmailLoading;
  final int otpRemainingTimeForverifyEmail;
  final bool isOtpTimerRunningForverifyEmail;
  final bool isAutoResendTimerActive; // New field for auto-resend timer

  // ================== Social Auth Fields ==================
  final bool isSocialSignInLoading;
  final String? socialSignInError;
  final Map<String, dynamic>? socialUserData;

  // ================== Utility & Availability Fields ==================
  final bool isLoginSuccess;
  final bool? isEmailExists;
  final bool isEmailCleared;
  final bool? isMobileExists;
  final bool isMobileCleared;
  final String? userName;
  final String? email;
  final String? phoneNumber;

  final int forgotPasswordOtpFailedAttempts;

  // ================== KYC Flow Fields ==================
  final bool shouldNavigateToKycUpload;
  final bool shouldShowKycSubmittedMessage;
  final bool shouldNavigateToDashboard;
  final bool shouldNavigateToProceedWithKyc;

  const AuthState({
    // Login
    this.isloginLoading = false,
    this.phoneController,
    this.phonefocusnode,
    this.otpController,
    this.emailIdUserNameController,
    this.passwordController,
    this.selectedLoginType = LoginType.email,
    this.isObscuredPassword = true,
    this.emailIdPhoneNumberController,
    this.forgotPasswordOTPController,
    required this.forgotPasswordFormKey,
    required this.resetPasswordFormKey,
    required this.resetNewPasswordController,
    this.resetConfirmPasswordController,
    this.isNewPasswordObscured = true,
    this.isConfirmPasswordObscured = true,
    this.signupEmailIdController,
    required this.signupFormKey,
    this.otpRemainingTime = 0,
    this.isOtpTimerRunning = false,
    required this.phoneFormKey,
    required this.emailFormKey,
    // Password & OTP
    this.isforgotPasswordLoading = false,
    this.isforgotPasswordSuccess = false,
    this.otpRemainingTimeForForgotPassword = 0,
    this.emailRemainingTimeForForgotPassword = 0,
    this.isOtpTimerRunningForForgotPassword = false,
    this.isEmailTimerRunningForForgotPassword = false,
    this.isResetPasswordLoading = false,
    this.isResetPasswordSuccess = false,
    // Signup & Terms
    this.issignupLoading = false,
    this.issignupSuccess = false,
    this.isAgreeTermsAndServiceAndPrivacyPolicy = false,
    this.hasReadTerms = false,
    this.termsAndConditionScrollController,
    this.termsHtml,
    this.isLoadingTerms = false,
    this.termsError,
    this.shouldNavigateToSelectAccount = false,

    // Email Verification
    this.isVerifyEmail = false,
    this.isVerifyEmailLoading = false,
    this.otpRemainingTimeForverifyEmail = 0,
    this.isOtpTimerRunningForverifyEmail = false,
    this.isAutoResendTimerActive = false, // New field initialization
    // Social Auth
    this.isSocialSignInLoading = false,
    this.socialSignInError,
    this.socialUserData,

    // Utility & Availability
    this.isLoginSuccess = false,
    this.isEmailExists,
    this.isEmailCleared = false,
    this.isMobileExists,
    this.isMobileCleared = false,
    this.userName,
    this.email,
    this.phoneNumber,
    this.forgotPasswordOtpFailedAttempts = 0,
    this.isPollingVerification = false,
    this.isOtpRequestInProgressForForgotPassword = false,
    this.isOtpRequestInProgress = false,
    // KYC Flow
    this.shouldNavigateToKycUpload = false,
    this.shouldShowKycSubmittedMessage = false,
    this.shouldNavigateToDashboard = false,
    this.shouldNavigateToProceedWithKyc = false,
  });

  @override
  List<Object?> get props => [
    // Login
    isloginLoading,
    phoneController,
    phonefocusnode,
    otpController,
    emailIdUserNameController,
    passwordController,
    selectedLoginType,
    isObscuredPassword,
    emailIdPhoneNumberController,
    forgotPasswordOTPController,
    forgotPasswordFormKey,
    resetPasswordFormKey,
    resetNewPasswordController,
    resetConfirmPasswordController,
    isNewPasswordObscured,
    isConfirmPasswordObscured,
    signupEmailIdController,
    signupFormKey,
    otpRemainingTime,
    isOtpTimerRunning,
    phoneFormKey,
    emailFormKey,
    // Password & OTP
    isforgotPasswordLoading,
    isforgotPasswordSuccess,
    otpRemainingTimeForForgotPassword,
    emailRemainingTimeForForgotPassword,
    isOtpTimerRunningForForgotPassword,
    isEmailTimerRunningForForgotPassword,
    isResetPasswordLoading,
    isResetPasswordSuccess,
    // Signup & Terms
    issignupLoading,
    issignupSuccess,
    isAgreeTermsAndServiceAndPrivacyPolicy,
    hasReadTerms,
    termsAndConditionScrollController,
    termsHtml,
    isLoadingTerms,
    termsError,
    isPollingVerification,
    shouldNavigateToSelectAccount,

    // Email Verification
    isVerifyEmail,
    isVerifyEmailLoading,
    otpRemainingTimeForverifyEmail,
    isOtpTimerRunningForverifyEmail,
    isAutoResendTimerActive, // Added to props
    // Social Auth
    isSocialSignInLoading,
    socialSignInError,
    socialUserData,

    // Utility & Availability
    isLoginSuccess,
    isEmailExists,
    isEmailCleared,
    isMobileExists,
    isMobileCleared,
    userName,
    email,
    phoneNumber,
    forgotPasswordOtpFailedAttempts,
    isOtpRequestInProgressForForgotPassword,
    isOtpRequestInProgress,
    // KYC Flow
    shouldNavigateToKycUpload,
    shouldShowKycSubmittedMessage,
    shouldNavigateToDashboard,
    shouldNavigateToProceedWithKyc,
  ];

  AuthState copyWith({
    // Login
    bool? isloginLoading,
    TextEditingController? phoneController,
    FocusNode? phonefocusnode,
    TextEditingController? otpController,
    TextEditingController? emailIdUserNameController,
    TextEditingController? passwordController,
    LoginType? selectedLoginType,
    bool? isObscuredPassword,
    TextEditingController? emailIdPhoneNumberController,
    TextEditingController? forgotPasswordOTPController,
    GlobalKey<FormState>? forgotPasswordFormKey,
    GlobalKey<FormState>? resetPasswordFormKey,
    TextEditingController? resetNewPasswordController,
    TextEditingController? resetConfirmPasswordController,
    bool? isNewPasswordObscured,
    bool? isConfirmPasswordObscured,
    TextEditingController? signupEmailIdController,
    GlobalKey<FormState>? signupFormKey,
    int? otpRemainingTime,
    bool? isOtpTimerRunning,
    GlobalKey<FormState>? phoneFormKey,
    GlobalKey<FormState>? emailFormKey,
    // Password & OTP
    bool? isforgotPasswordLoading,
    bool? isforgotPasswordSuccess,
    int? otpRemainingTimeForForgotPassword,
    int? emailRemainingTimeForForgotPassword,
    bool? isOtpTimerRunningForForgotPassword,
    bool? isEmailTimerRunningForForgotPassword,
    bool? isResetPasswordLoading,
    bool? isResetPasswordSuccess,
    // Signup & Terms
    bool? issignupLoading,
    bool? issignupSuccess,
    bool? isAgreeTermsAndServiceAndPrivacyPolicy,
    bool? hasReadTerms,
    ScrollController? termsAndConditionScrollController,
    String? termsHtml,
    bool? isLoadingTerms,
    String? termsError,
    bool? shouldNavigateToSelectAccount,

    // Email Verification
    bool? isVerifyEmail,
    bool? isVerifyEmailLoading,
    int? otpRemainingTimeForverifyEmail,
    bool? isOtpTimerRunningForverifyEmail,
    bool? isAutoResendTimerActive, // Added to copyWith parameters
    bool? isPollingVerification,

    // Social Auth
    bool? isSocialSignInLoading,
    String? socialSignInError,
    Map<String, dynamic>? socialUserData,

    // Utility & Availability
    bool? isLoginSuccess,
    bool? isEmailExists,
    bool? isEmailCleared,
    bool? isMobileExists,
    bool? isMobileCleared,
    String? userName,
    String? email,
    String? phoneNumber,
    int? forgotPasswordOtpFailedAttempts,
    bool? isOtpRequestInProgress,
    bool? isOtpRequestInProgressForForgotPassword,
    // KYC Flow
    bool? shouldNavigateToKycUpload,
    bool? shouldShowKycSubmittedMessage,
    bool? shouldNavigateToDashboard,
    bool? shouldNavigateToProceedWithKyc,
  }) {
    return AuthState(
      // Login
      isloginLoading: isloginLoading ?? this.isloginLoading,
      phoneController: phoneController ?? this.phoneController,
      phonefocusnode: phonefocusnode ?? this.phonefocusnode,
      otpController: otpController ?? this.otpController,
      emailIdUserNameController: emailIdUserNameController ?? this.emailIdUserNameController,
      passwordController: passwordController ?? this.passwordController,
      selectedLoginType: selectedLoginType ?? this.selectedLoginType,
      isObscuredPassword: isObscuredPassword ?? this.isObscuredPassword,
      emailIdPhoneNumberController: emailIdPhoneNumberController ?? this.emailIdPhoneNumberController,
      forgotPasswordOTPController: forgotPasswordOTPController ?? this.forgotPasswordOTPController,
      forgotPasswordFormKey: forgotPasswordFormKey ?? this.forgotPasswordFormKey,
      resetPasswordFormKey: resetPasswordFormKey ?? this.resetPasswordFormKey,
      resetNewPasswordController: resetNewPasswordController ?? this.resetNewPasswordController,
      resetConfirmPasswordController: resetConfirmPasswordController ?? this.resetConfirmPasswordController,
      isNewPasswordObscured: isNewPasswordObscured ?? this.isNewPasswordObscured,
      isConfirmPasswordObscured: isConfirmPasswordObscured ?? this.isConfirmPasswordObscured,
      signupEmailIdController: signupEmailIdController ?? this.signupEmailIdController,
      signupFormKey: signupFormKey ?? this.signupFormKey,
      otpRemainingTime: otpRemainingTime ?? this.otpRemainingTime,
      isOtpTimerRunning: isOtpTimerRunning ?? this.isOtpTimerRunning,
      phoneFormKey: phoneFormKey ?? this.phoneFormKey,
      emailFormKey: emailFormKey ?? this.emailFormKey,
      // Password & OTP
      isforgotPasswordLoading: isforgotPasswordLoading ?? this.isforgotPasswordLoading,
      isforgotPasswordSuccess: isforgotPasswordSuccess ?? this.isforgotPasswordSuccess,
      otpRemainingTimeForForgotPassword: otpRemainingTimeForForgotPassword ?? this.otpRemainingTimeForForgotPassword,
      emailRemainingTimeForForgotPassword:
          emailRemainingTimeForForgotPassword ?? this.emailRemainingTimeForForgotPassword,
      isOtpTimerRunningForForgotPassword: isOtpTimerRunningForForgotPassword ?? this.isOtpTimerRunningForForgotPassword,
      isEmailTimerRunningForForgotPassword:
          isEmailTimerRunningForForgotPassword ?? this.isEmailTimerRunningForForgotPassword,
      isResetPasswordLoading: isResetPasswordLoading ?? this.isResetPasswordLoading,
      isResetPasswordSuccess: isResetPasswordSuccess ?? this.isResetPasswordSuccess,
      // Signup & Terms
      issignupLoading: issignupLoading ?? this.issignupLoading,
      issignupSuccess: issignupSuccess ?? this.issignupSuccess,
      isAgreeTermsAndServiceAndPrivacyPolicy:
          isAgreeTermsAndServiceAndPrivacyPolicy ?? this.isAgreeTermsAndServiceAndPrivacyPolicy,
      hasReadTerms: hasReadTerms ?? this.hasReadTerms,
      termsAndConditionScrollController: termsAndConditionScrollController ?? this.termsAndConditionScrollController,
      termsHtml: termsHtml ?? this.termsHtml,
      isLoadingTerms: isLoadingTerms ?? this.isLoadingTerms,
      termsError: termsError ?? this.termsError,
      isPollingVerification: isPollingVerification ?? this.isPollingVerification,
      shouldNavigateToSelectAccount: shouldNavigateToSelectAccount ?? this.shouldNavigateToSelectAccount,

      // Email Verification
      isVerifyEmail: isVerifyEmail ?? this.isVerifyEmail,
      isVerifyEmailLoading: isVerifyEmailLoading ?? this.isVerifyEmailLoading,
      otpRemainingTimeForverifyEmail: otpRemainingTimeForverifyEmail ?? this.otpRemainingTimeForverifyEmail,
      isOtpTimerRunningForverifyEmail: isOtpTimerRunningForverifyEmail ?? this.isOtpTimerRunningForverifyEmail,
      isAutoResendTimerActive:
          isAutoResendTimerActive ?? this.isAutoResendTimerActive, // Added to copyWith implementation
      // Social Auth
      isSocialSignInLoading: isSocialSignInLoading ?? this.isSocialSignInLoading,
      socialSignInError: socialSignInError ?? this.socialSignInError,
      socialUserData: socialUserData ?? this.socialUserData,

      // Utility & Availability
      isLoginSuccess: isLoginSuccess ?? this.isLoginSuccess,
      isEmailExists: isEmailExists ?? this.isEmailExists,
      isEmailCleared: isEmailCleared ?? this.isEmailCleared,
      isMobileExists: isMobileExists ?? this.isMobileExists,
      isMobileCleared: isMobileCleared ?? this.isMobileCleared,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      forgotPasswordOtpFailedAttempts: forgotPasswordOtpFailedAttempts ?? this.forgotPasswordOtpFailedAttempts,
      isOtpRequestInProgressForForgotPassword:
          isOtpRequestInProgressForForgotPassword ?? this.isOtpRequestInProgressForForgotPassword,
      isOtpRequestInProgress: isOtpRequestInProgress ?? this.isOtpRequestInProgress,
      // KYC Flow
      shouldNavigateToKycUpload: shouldNavigateToKycUpload ?? this.shouldNavigateToKycUpload,
      shouldShowKycSubmittedMessage: shouldShowKycSubmittedMessage ?? this.shouldShowKycSubmittedMessage,
      shouldNavigateToDashboard: shouldNavigateToDashboard ?? this.shouldNavigateToDashboard,
      shouldNavigateToProceedWithKyc: shouldNavigateToProceedWithKyc ?? this.shouldNavigateToProceedWithKyc,
    );
  }
}
