import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:exchek/viewmodels/auth_bloc/auth_bloc.dart';
import 'package:exchek/core/enums/app_enums.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthState', () {
    test('supports value equality with same keys', () {
      final forgotKey = GlobalKey<FormState>();
      final resetKey = GlobalKey<FormState>();
      final signupKey = GlobalKey<FormState>();
      final phoneKey = GlobalKey<FormState>();
      final emailKey = GlobalKey<FormState>();
      final controller = TextEditingController();

      final state1 = AuthState(
        forgotPasswordFormKey: forgotKey,
        resetPasswordFormKey: resetKey,
        signupFormKey: signupKey,
        phoneFormKey: phoneKey,
        emailFormKey: emailKey,
        resetNewPasswordController: controller,
      );

      final state2 = AuthState(
        forgotPasswordFormKey: forgotKey,
        resetPasswordFormKey: resetKey,
        signupFormKey: signupKey,
        phoneFormKey: phoneKey,
        emailFormKey: emailKey,
        resetNewPasswordController: controller,
      );

      expect(state1, state2);
    });

    test('copyWith returns object with updated values', () {
      final originalState = AuthState(
        isloginLoading: false,
        selectedLoginType: LoginType.email,
        isObscuredPassword: true,
        forgotPasswordFormKey: GlobalKey<FormState>(),
        resetPasswordFormKey: GlobalKey<FormState>(),
        signupFormKey: GlobalKey<FormState>(),
        phoneFormKey: GlobalKey<FormState>(),
        emailFormKey: GlobalKey<FormState>(),
        resetNewPasswordController: TextEditingController(),
      );

      final updatedState = originalState.copyWith(
        isloginLoading: true,
        selectedLoginType: LoginType.phone,
        isObscuredPassword: false,
      );

      expect(updatedState.isloginLoading, true);
      expect(updatedState.selectedLoginType, LoginType.phone);
      expect(updatedState.isObscuredPassword, false);

      // Verify other properties remain unchanged
      expect(
        updatedState.forgotPasswordFormKey,
        originalState.forgotPasswordFormKey,
      );
      expect(
        updatedState.resetPasswordFormKey,
        originalState.resetPasswordFormKey,
      );
    });

    test('copyWith with null values keeps original values', () {
      final originalState = AuthState(
        isloginLoading: true,
        selectedLoginType: LoginType.phone,
        forgotPasswordFormKey: GlobalKey<FormState>(),
        resetPasswordFormKey: GlobalKey<FormState>(),
        signupFormKey: GlobalKey<FormState>(),
        phoneFormKey: GlobalKey<FormState>(),
        emailFormKey: GlobalKey<FormState>(),
        resetNewPasswordController: TextEditingController(),
      );

      final updatedState = originalState.copyWith();

      expect(updatedState.isloginLoading, originalState.isloginLoading);
      expect(updatedState.selectedLoginType, originalState.selectedLoginType);
    });

    test('default values are correct', () {
      final state = AuthState(
        forgotPasswordFormKey: GlobalKey<FormState>(),
        resetPasswordFormKey: GlobalKey<FormState>(),
        signupFormKey: GlobalKey<FormState>(),
        phoneFormKey: GlobalKey<FormState>(),
        emailFormKey: GlobalKey<FormState>(),
        resetNewPasswordController: TextEditingController(),
      );

      expect(state.isloginLoading, false);
      expect(state.selectedLoginType, LoginType.email);
      expect(state.isObscuredPassword, true);
      expect(state.isNewPasswordObscured, true);
      expect(state.isConfirmPasswordObscured, true);
      expect(state.otpRemainingTime, 0);
      expect(state.isOtpTimerRunning, false);
      expect(state.isforgotPasswordLoading, false);
      expect(state.isforgotPasswordSuccess, false);
      expect(state.isResetPasswordLoading, false);
      expect(state.issignupLoading, false);
      expect(state.issignupSuccess, false);
      expect(state.isVerifyEmail, false);
      expect(state.isVerifyEmailLoading, false);
      expect(state.isAgreeTermsAndServiceAndPrivacyPolicy, false);
      expect(state.isLoginSuccess, false);
      expect(state.hasReadTerms, false);
      expect(state.isSocialSignInLoading, false);
      expect(state.isLoadingTerms, false);
      expect(state.isResetPasswordSuccess, false);
      expect(state.isEmailCleared, false);
      expect(state.isMobileCleared, false);
    });
  });
}
