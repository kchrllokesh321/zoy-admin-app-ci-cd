import 'package:exchek/core/enums/app_enums.dart';
import 'package:exchek/viewmodels/auth_bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthEvent', () {
    group('LoginSubmitted', () {
      test('supports value equality', () {
        const event1 = LoginSubmitted(phoneNumber: '1234567890', otp: '123456');
        const event2 = LoginSubmitted(phoneNumber: '1234567890', otp: '123456');
        const event3 = LoginSubmitted(phoneNumber: '0987654321', otp: '654321');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props are correct', () {
        const event = LoginSubmitted(phoneNumber: '1234567890', otp: '123456');
        expect(event.props, ['1234567890', '123456']);
      });
    });

    group('EmailLoginSubmitted', () {
      test('supports value equality', () {
        const event1 = EmailLoginSubmitted(emailIdOrUserName: 'test@example.com', password: 'password');
        const event2 = EmailLoginSubmitted(emailIdOrUserName: 'test@example.com', password: 'password');
        const event3 = EmailLoginSubmitted(emailIdOrUserName: 'other@example.com', password: 'password');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props are correct', () {
        const event = EmailLoginSubmitted(emailIdOrUserName: 'test@example.com', password: 'password');
        expect(event.props, ['test@example.com', 'password']);
      });
    });

    group('ChangeLoginType', () {
      test('supports value equality', () {
        const event1 = ChangeLoginType(selectedLoginType: LoginType.email);
        const event2 = ChangeLoginType(selectedLoginType: LoginType.email);
        const event3 = ChangeLoginType(selectedLoginType: LoginType.phone);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props include selectedLoginType', () {
        const event = ChangeLoginType(selectedLoginType: LoginType.phone);
        expect(event.props, [LoginType.phone]);
      });
    });

    group('ChanegPasswordVisibility', () {
      test('supports value equality', () {
        const event1 = ChanegPasswordVisibility(obscuredText: true);
        const event2 = ChanegPasswordVisibility(obscuredText: true);
        const event3 = ChanegPasswordVisibility(obscuredText: false);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props are correct', () {
        const event = ChanegPasswordVisibility(obscuredText: true);
        expect(event.props, [true]);
      });
    });

    group('SendOtpPressed', () {
      test('supports value equality', () {
        const event1 = SendOtpPressed(phoneNumber: '1234567890');
        const event2 = SendOtpPressed(phoneNumber: '1234567890');
        const event3 = SendOtpPressed(phoneNumber: '0987654321');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props are correct', () {
        const event = SendOtpPressed(phoneNumber: '1234567890');
        expect(event.props, ['1234567890']);
      });
    });

    group('OtpTimerTicked', () {
      test('supports value equality', () {
        const event1 = OtpTimerTicked(30);
        const event2 = OtpTimerTicked(30);
        const event3 = OtpTimerTicked(60);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props are correct', () {
        const event = OtpTimerTicked(30);
        expect(event.props, [30]);
      });
    });

    group('ForgotPasswordSubmited', () {
      test('supports value equality', () {
        final context1 = MockBuildContext();
        final context2 = MockBuildContext();
        final event1 = ForgotPasswordSubmited(
          emailIdOrPhoneNumber: 'test@example.com',
          otp: '123456',
          context: context1,
        );
        final event2 = ForgotPasswordSubmited(
          emailIdOrPhoneNumber: 'test@example.com',
          otp: '123456',
          context: context1,
        );
        final event3 = ForgotPasswordSubmited(
          emailIdOrPhoneNumber: 'other@example.com',
          otp: '123456',
          context: context2,
        );

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props are correct', () {
        final context1 = MockBuildContext();
        final event = ForgotPasswordSubmited(
          emailIdOrPhoneNumber: 'test@example.com',
          otp: '123456',
          context: context1,
        );
        expect(event.props, ['test@example.com', '123456', context1]);
      });
    });

    group('ResetPasswordSubmitted', () {
      test('supports value equality', () {
        const event1 = ResetPasswordSubmitted(password: 'newPassword', confirmpassword: 'newPassword');
        const event2 = ResetPasswordSubmitted(password: 'newPassword', confirmpassword: 'newPassword');

        expect(event1, equals(event2));
      });

      test('props are correct', () {
        const event = ResetPasswordSubmitted(password: 'newPassword', confirmpassword: 'newPassword');
        expect(event.props, ['newPassword', 'newPassword']);
      });
    });

    group('TermsAndConditionSubmitted', () {
      test('supports value equality', () {
        final context1 = MockBuildContext();
        final context2 = MockBuildContext();

        final event1 = TermsAndConditionSubmitted(emailId: 'test@example.com', context: context1);
        final event2 = TermsAndConditionSubmitted(emailId: 'test@example.com', context: context1);
        final event3 = TermsAndConditionSubmitted(emailId: 'other@example.com', context: context2);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props are correct', () {
        final context1 = MockBuildContext();
        final event = TermsAndConditionSubmitted(emailId: 'test@example.com', context: context1);
        expect(event.props, ['test@example.com', context1]);
      });
    });

    group('UpdateEmailEvent', () {
      test('supports value equality', () {
        const event1 = UpdateEmailEvent(email: 'test@example.com');
        const event2 = UpdateEmailEvent(email: 'test@example.com');
        const event3 = UpdateEmailEvent(email: 'other@example.com');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props include email', () {
        const event = UpdateEmailEvent(email: 'test@example.com');
        expect(event.props, ['test@example.com']);
      });
    });

    group('CheckEmailAvailability', () {
      test('supports value equality', () {
        final context1 = MockBuildContext();

        final event1 = CheckEmailAvailability(email: 'test@example.com', context: context1);
        final event2 = CheckEmailAvailability(email: 'test@example.com', context: context1);
        final event3 = CheckEmailAvailability(email: 'other@example.com', context: context1);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props include email', () {
        final context1 = MockBuildContext();

        final event = CheckEmailAvailability(email: 'test@example.com', context: context1);
        expect(event.props, ['test@example.com']);
      });
    });

    group('CheckMobileAvailability', () {
      test('supports value equality', () {
        const event1 = CheckMobileAvailability(mobile: '1234567890');
        const event2 = CheckMobileAvailability(mobile: '1234567890');
        const event3 = CheckMobileAvailability(mobile: '0987654321');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props include mobile', () {
        const event = CheckMobileAvailability(mobile: '1234567890');
        expect(event.props, ['1234567890']);
      });
    });

    group('Social Sign In Events', () {
      test('GoogleSignInPressed supports value equality', () {
        final event1 = GoogleSignInPressed();
        final event2 = GoogleSignInPressed();

        expect(event1, equals(event2));
      });

      test('LinkedInSignInPressed supports value equality', () {
        final event1 = LinkedInSignInPressed();
        final event2 = LinkedInSignInPressed();

        expect(event1, equals(event2));
      });

      test('AppleSignInPressed supports value equality', () {
        final event1 = AppleSignInPressed();
        final event2 = AppleSignInPressed();

        expect(event1, equals(event2));
      });
    });

    group('Timer Events', () {
      test('ForgotPasswordOtpTimerTicked supports value equality', () {
        const event1 = ForgotPasswordOtpTimerTicked(30);
        const event2 = ForgotPasswordOtpTimerTicked(30);
        const event3 = ForgotPasswordOtpTimerTicked(60);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('OtpTimerTickedResendEmail supports value equality', () {
        const event1 = OtpTimerTickedResendEmail(30);
        const event2 = OtpTimerTickedResendEmail(30);
        const event3 = OtpTimerTickedResendEmail(60);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });
    });

    group('Boolean Events', () {
      test('ChangeAgreeTermsAndServiceAndPrivacyPolicy supports value equality', () {
        const event1 = ChangeAgreeTermsAndServiceAndPrivacyPolicy(isAgree: true);
        const event2 = ChangeAgreeTermsAndServiceAndPrivacyPolicy(isAgree: true);
        const event3 = ChangeAgreeTermsAndServiceAndPrivacyPolicy(isAgree: false);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('HasReadTermsEvent supports value equality', () {
        const event1 = HasReadTermsEvent(hasRead: true);
        const event2 = HasReadTermsEvent(hasRead: true);
        const event3 = HasReadTermsEvent(hasRead: false);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });
    });

    group('Password Visibility Events', () {
      test('ResetNewPasswordChangeVisibility supports value equality', () {
        const event1 = ResetNewPasswordChangeVisibility(obscuredText: true);
        const event2 = ResetNewPasswordChangeVisibility(obscuredText: true);
        const event3 = ResetNewPasswordChangeVisibility(obscuredText: false);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('ResetNewPasswordChangeVisibility props are correct', () {
        const event = ResetNewPasswordChangeVisibility(obscuredText: true);
        expect(event.props, [true]);
      });

      test('ResetConfirmPasswordChangeVisibility supports value equality', () {
        const event1 = ResetConfirmPasswordChangeVisibility(obscuredText: true);
        const event2 = ResetConfirmPasswordChangeVisibility(obscuredText: true);
        const event3 = ResetConfirmPasswordChangeVisibility(obscuredText: false);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('ResetConfirmPasswordChangeVisibility props are correct', () {
        const event = ResetConfirmPasswordChangeVisibility(obscuredText: false);
        expect(event.props, [false]);
      });
    });

    group('Forgot Password Events', () {
      test('SendOtpForgotPasswordPressed supports value equality', () {
        const event1 = SendOtpForgotPasswordPressed(phoneNumber: '1234567890');
        const event2 = SendOtpForgotPasswordPressed(phoneNumber: '1234567890');
        const event3 = SendOtpForgotPasswordPressed(phoneNumber: '0987654321');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('SendOtpForgotPasswordPressed props are correct', () {
        const event = SendOtpForgotPasswordPressed(phoneNumber: '1234567890');
        expect(event.props, ['1234567890']);
      });

      test('ForgotPasswordEmailTimerTicked supports value equality', () {
        const event1 = ForgotPasswordEmailTimerTicked(45);
        const event2 = ForgotPasswordEmailTimerTicked(45);
        const event3 = ForgotPasswordEmailTimerTicked(30);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('ForgotPasswordEmailTimerTicked props are correct', () {
        const event = ForgotPasswordEmailTimerTicked(45);
        expect(event.props, [45]);
      });

      test('ForgotResetEmailSubmited supports value equality', () {
        const event1 = ForgotResetEmailSubmited(emailIdOrPhoneNumber: 'test@example.com');
        const event2 = ForgotResetEmailSubmited(emailIdOrPhoneNumber: 'test@example.com');
        const event3 = ForgotResetEmailSubmited(emailIdOrPhoneNumber: 'other@example.com');

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('ForgotResetEmailSubmited props are correct', () {
        const event = ForgotResetEmailSubmited(emailIdOrPhoneNumber: 'test@example.com');
        expect(event.props, ['test@example.com']);
      });

      test('ResendEmailLink supports value equality', () {
        final context1 = MockBuildContext();
        final context2 = MockBuildContext();

        final event1 = ResendEmailLink(emailId: 'test@example.com', context: context1);
        final event2 = ResendEmailLink(emailId: 'test@example.com', context: context1);
        final event3 = ResendEmailLink(emailId: 'other@example.com', context: context2);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('ResendEmailLink props are correct', () {
        final context1 = MockBuildContext();
        final event = ResendEmailLink(emailId: 'test@example.com', context: context1);
        expect(event.props, ['test@example.com', context1]);
      });
    });

    group('Manual Clear Events', () {
      test('CancelForgotPasswordTimerManuallyEvent supports value equality', () {
        const event1 = CancelForgotPasswordTimerManuallyEvent();
        const event2 = CancelForgotPasswordTimerManuallyEvent();

        expect(event1, equals(event2));
      });

      test('CancelForgotPasswordTimerManuallyEvent props are correct', () {
        const event = CancelForgotPasswordTimerManuallyEvent();
        expect(event.props, []);
      });

      test('ClearResetPasswordManuallyEvent supports value equality', () {
        const event1 = ClearResetPasswordManuallyEvent();
        const event2 = ClearResetPasswordManuallyEvent();

        expect(event1, equals(event2));
      });

      test('ClearResetPasswordManuallyEvent props are correct', () {
        const event = ClearResetPasswordManuallyEvent();
        expect(event.props, []);
      });

      test('ClearLoginDataManuallyEvent supports value equality', () {
        const event1 = ClearLoginDataManuallyEvent();
        const event2 = ClearLoginDataManuallyEvent();

        expect(event1, equals(event2));
      });

      test('ClearLoginDataManuallyEvent props are correct', () {
        const event = ClearLoginDataManuallyEvent();
        expect(event.props, []);
      });

      test('ClearSignupDataManuallyEvent supports value equality', () {
        const event1 = ClearSignupDataManuallyEvent();
        const event2 = ClearSignupDataManuallyEvent();

        expect(event1, equals(event2));
      });

      test('ClearSignupDataManuallyEvent props are correct', () {
        const event = ClearSignupDataManuallyEvent();
        expect(event.props, []);
      });
    });

    group('Simple Events', () {
      test('ResetForgetPasswordSuccess supports value equality', () {
        final event1 = ResetForgetPasswordSuccess();
        final event2 = ResetForgetPasswordSuccess();

        expect(event1, equals(event2));
      });

      test('VerifyEmailEvent supports value equality', () {
        final event1 = VerifyEmailEvent();
        final event2 = VerifyEmailEvent();

        expect(event1, equals(event2));
      });

      test('LoadTermsAndConditions supports value equality', () {
        final event1 = LoadTermsAndConditions();
        final event2 = LoadTermsAndConditions();

        expect(event1, equals(event2));
      });
    });
  });
}

class MockBuildContext extends Mock implements BuildContext {}
