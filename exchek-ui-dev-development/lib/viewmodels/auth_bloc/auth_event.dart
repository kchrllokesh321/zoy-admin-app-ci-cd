part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

// ================== Login Events ==================
class LoginSubmitted extends AuthEvent {
  final String phoneNumber;
  final String otp;
  const LoginSubmitted({required this.phoneNumber, required this.otp});
  @override
  List<Object?> get props => [phoneNumber, otp];
}

class EmailLoginSubmitted extends AuthEvent {
  final String emailIdOrUserName;
  final String password;
  const EmailLoginSubmitted({required this.emailIdOrUserName, required this.password});
  @override
  List<Object?> get props => [emailIdOrUserName, password];
}

class ChangeLoginType extends AuthEvent {
  final LoginType selectedLoginType;
  const ChangeLoginType({required this.selectedLoginType});
  @override
  List<Object?> get props => [selectedLoginType];
}

class ChanegPasswordVisibility extends AuthEvent {
  final bool obscuredText;
  const ChanegPasswordVisibility({required this.obscuredText});
  @override
  List<Object?> get props => [obscuredText];
}

class ResetNewPasswordChangeVisibility extends AuthEvent {
  final bool obscuredText;
  const ResetNewPasswordChangeVisibility({required this.obscuredText});
  @override
  List<Object?> get props => [obscuredText];
}

class ResetConfirmPasswordChangeVisibility extends AuthEvent {
  final bool obscuredText;
  const ResetConfirmPasswordChangeVisibility({required this.obscuredText});
  @override
  List<Object?> get props => [obscuredText];
}

// ================== OTP & Password Events ==================
class SendOtpPressed extends AuthEvent {
  final String phoneNumber;
  const SendOtpPressed({required this.phoneNumber});
  @override
  List<Object?> get props => [phoneNumber];
}

class OtpTimerTicked extends AuthEvent {
  final int remainingTime;
  const OtpTimerTicked(this.remainingTime);
  @override
  List<Object?> get props => [remainingTime];
}

class SendOtpForgotPasswordPressed extends AuthEvent {
  final String phoneNumber;
  const SendOtpForgotPasswordPressed({required this.phoneNumber});
  @override
  List<Object?> get props => [phoneNumber];
}

class ForgotPasswordOtpTimerTicked extends AuthEvent {
  final int remainingTime;
  const ForgotPasswordOtpTimerTicked(this.remainingTime);
  @override
  List<Object?> get props => [remainingTime];
}

class ForgotPasswordEmailTimerTicked extends AuthEvent {
  final int remainingTime;
  const ForgotPasswordEmailTimerTicked(this.remainingTime);
  @override
  List<Object?> get props => [remainingTime];
}

class ForgotPasswordSubmited extends AuthEvent {
  final String emailIdOrPhoneNumber;
  final String otp;
  final BuildContext context;
  const ForgotPasswordSubmited({required this.emailIdOrPhoneNumber, required this.otp, required this.context});
  @override
  List<Object?> get props => [emailIdOrPhoneNumber, otp, context];
}

class ForgotResetEmailSubmited extends AuthEvent {
  final String emailIdOrPhoneNumber;
  const ForgotResetEmailSubmited({required this.emailIdOrPhoneNumber});
  @override
  List<Object?> get props => [emailIdOrPhoneNumber];
}

class ResetPasswordSubmitted extends AuthEvent {
  final String password;
  final String confirmpassword;
  const ResetPasswordSubmitted({required this.password, required this.confirmpassword});
  @override
  List<Object?> get props => [password, confirmpassword];
}

class ResendEmailLink extends AuthEvent {
  final String emailId;
  final BuildContext context;
  const ResendEmailLink({required this.emailId, required this.context});
  @override
  List<Object?> get props => [emailId, context];
}

class AutoResendEmailLink extends AuthEvent {
  final String emailId;
  final BuildContext context;
  
  const AutoResendEmailLink({required this.emailId, required this.context});
  
  @override
  List<Object> get props => [emailId, context];
}

class StartVerifyEmailPollingEvent extends AuthEvent {
  final String email;
  final BuildContext context;
  const StartVerifyEmailPollingEvent({required this.email, required this.context});
  @override
  List<Object> get props => [email, context];
}

class StopVerifyEmailPollingEvent extends AuthEvent {
  const StopVerifyEmailPollingEvent();
  @override
  List<Object?> get props => [];
}

class OtpTimerTickedResendEmail extends AuthEvent {
  final int remainingTime;
  const OtpTimerTickedResendEmail(this.remainingTime);
  @override
  List<Object?> get props => [remainingTime];
}

class ResetForgetPasswordSuccess extends AuthEvent {}

// ================== Auto-Resend Timer Events ==================
class StartAutoResendTimerEvent extends AuthEvent {
  final BuildContext? context;
  const StartAutoResendTimerEvent({this.context});
  @override
  List<Object?> get props => [context];
}

class StopAutoResendTimerEvent extends AuthEvent {
  const StopAutoResendTimerEvent();
  @override
  List<Object?> get props => [];
}

class LoadEmailFromPreferencesEvent extends AuthEvent {
  const LoadEmailFromPreferencesEvent();
  @override
  List<Object?> get props => [];
}

// ================== Terms & Policy Events ==================
class TermsAndConditionSubmitted extends AuthEvent {
  final String emailId;
  final BuildContext context;
  const TermsAndConditionSubmitted({required this.emailId, required this.context});
  @override
  List<Object?> get props => [emailId, context];
}

class ChangeAgreeTermsAndServiceAndPrivacyPolicy extends AuthEvent {
  final bool isAgree;
  const ChangeAgreeTermsAndServiceAndPrivacyPolicy({required this.isAgree});
  @override
  List<Object?> get props => [isAgree];
}

class HasReadTermsEvent extends AuthEvent {
  final bool hasRead;
  const HasReadTermsEvent({required this.hasRead});
  @override
  List<Object?> get props => [hasRead];
}

// ================== Social Auth Events ==================
class GoogleSignInPressed extends AuthEvent {}

class LinkedInSignInPressed extends AuthEvent {}

class AppleSignInPressed extends AuthEvent {}

// ================== Utility & Availability Events ==================
class UpdateEmailEvent extends AuthEvent {
  final String email;
  const UpdateEmailEvent({required this.email});
  @override
  List<Object?> get props => [email];
}

class VerifyEmailEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class LoadTermsAndConditions extends AuthEvent {}

class CheckEmailAvailability extends AuthEvent {
  final String email;
  final BuildContext context;
  const CheckEmailAvailability({required this.email, required this.context});
  @override
  List<Object?> get props => [email];
}

class CheckMobileAvailability extends AuthEvent {
  final String mobile;
  const CheckMobileAvailability({required this.mobile});
  @override
  List<Object?> get props => [mobile];
}

class CancelForgotPasswordTimerManuallyEvent extends AuthEvent {
  const CancelForgotPasswordTimerManuallyEvent();
  @override
  List<Object?> get props => [];
}

class ClearResetPasswordManuallyEvent extends AuthEvent {
  const ClearResetPasswordManuallyEvent();
  @override
  List<Object?> get props => [];
}

class ClearLoginDataManuallyEvent extends AuthEvent {
  const ClearLoginDataManuallyEvent();
  @override
  List<Object?> get props => [];
}

class ResetNavigationFlagEvent extends AuthEvent {
  const ResetNavigationFlagEvent();
  @override
  List<Object?> get props => [];
}


class ClearSignupDataManuallyEvent extends AuthEvent {
  const ClearSignupDataManuallyEvent();
  @override
  List<Object?> get props => [];
}
