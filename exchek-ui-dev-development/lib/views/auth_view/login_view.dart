import 'dart:convert';

import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/dashboard_bloc/dashboard_bloc.dart';
import 'package:exchek/widgets/common_widget/app_exit_dialog.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  double fieldTitleSize(BuildContext context) {
    return ResponsiveHelper.isBigScreen(context) ? 16.0 : (ResponsiveHelper.isWebAndIsNotMobile(context) ? 13.0 : 16.0);
  }

  double linkFontSize(BuildContext context) {
    return ResponsiveHelper.isBigScreen(context)
        ? ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 15)
        : ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 12, desktop: 12);
  }

  double getSpacing(BuildContext context) {
    return ResponsiveHelper.isBigScreen(context) ? 22.0 : 18.0;
  }

  double getDividerPadding(BuildContext context) {
    return ResponsiveHelper.isBigScreen(context) ? 24.0 : 15.0;
  }

  double getFieldVerticalPadidng(BuildContext context) {
    return ResponsiveHelper.isBigScreen(context) ? 17.0 : (ResponsiveHelper.isWebAndIsNotMobile(context) ? 14.0 : 16.0);
  }

  double fieldTextFontSize(BuildContext context) {
    return ResponsiveHelper.isBigScreen(context)
        ? ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 16, desktop: 16)
        : ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 14, desktop: 14);
  }

  double buttonHeight(BuildContext context) {
    return ResponsiveHelper.isBigScreen(context) ? 45.0 : (ResponsiveHelper.isWebAndIsNotMobile(context) ? 38.0 : 45.0);
  }

  double headerFontSize(BuildContext context) {
    return ResponsiveHelper.isBigScreen(context)
        ? ResponsiveHelper.getFontSize(context, mobile: 23, tablet: 34, desktop: 34)
        : ResponsiveHelper.getFontSize(context, mobile: 23, tablet: 24, desktop: 24);
  }

  double logoAndContentPadding(BuildContext context) {
    return ResponsiveHelper.isBigScreen(context) ? 40.0 : 20.0;
  }

  double buttonFontSize(BuildContext context) {
    return ResponsiveHelper.isBigScreen(context)
        ? ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 16, desktop: 16)
        : ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 15, desktop: 15);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (!didPop) {
            showExitConfirmationDialog(context);
          }
        }
      },
      child: LandingPageScaffold(
        backgroundColor: Theme.of(context).customColors.fillColor,
        body: SafeArea(
          bottom: false,
          child: BlocConsumer<AuthBloc, AuthState>(
            builder: (context, state) {
              return Center(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    clipBehavior: Clip.none,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: ResponsiveHelper.getMaxAuthFormWidth(context)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isBigScreen(context) ? 25 : 14),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _buildAppLogo(context),
                              buildSizedBoxH(ResponsiveHelper.isBigScreen(context) ? 18.0 : 30.0),
                              _buildLoginContent(context, state),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            listener: (context, state) async {
              if (state.isLoginSuccess == true) {
                context.read<DashboardBloc>().add(ResetRequested());

                // Trigger dashboard data load event
                context.read<DashboardBloc>().add(CurrencyStarted());
                // Start periodic refresh after login
                TokenManager.startScheduler();
                // Handle KYC flow based on status
                if (state.shouldNavigateToDashboard) {
                  // KYC is ACTIVE - go to dashboard
                  if (kIsWeb) {
                    context.replace(RouteUri.dashboardRoute);
                  } else {
                    GoRouter.of(context).pushReplacement(RouteUri.dashboardRoute);
                  }
                } else if (state.shouldShowKycSubmittedMessage) {
                  // KYC is SUBMITTED - show message
                  // AppToast.show(message: 'KYC will be verified within 24 hours', type: ToastificationType.info);
                  if (kIsWeb) {
                    context.replace(RouteUri.ekycconfirmationroute);
                  } else {
                    GoRouter.of(context).pushReplacement(RouteUri.ekycconfirmationroute);
                  }
                } else if (state.shouldNavigateToProceedWithKyc) {
                  // KYC is PENDING,
                  if (kIsWeb) {
                    context.replace(RouteUri.proceedWithKycViewRoute);
                  } else {
                    GoRouter.of(context).pushReplacement(RouteUri.proceedWithKycViewRoute);
                  }
                } else if (state.shouldNavigateToKycUpload) {
                  // // KYC is  INITIATED, REJECTED, or PARTIAL_APPROVED
                  final user = await Prefobj.preferences.get(Prefkeys.userKycDetail);
                  final userDetail = jsonDecode(user!);
                  if (userDetail['user_type'] == "personal") {
                    if (kIsWeb) {
                      GoRouter.of(context).go(RouteUri.personalAccountKycSetupView);
                    } else {
                      GoRouter.of(context).push(RouteUri.personalAccountKycSetupView);
                    }
                  } else {
                    if (kIsWeb) {
                      GoRouter.of(context).go(RouteUri.businessAccountKycSetupView);
                    } else {
                      GoRouter.of(context).push(RouteUri.businessAccountKycSetupView);
                    }
                  }
                } else {
                  // Default fallback
                  if (kIsWeb) {
                    context.replace(RouteUri.proceedWithKycViewRoute);
                  } else {
                    GoRouter.of(context).pushReplacement(RouteUri.proceedWithKycViewRoute);
                  }
                }
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoginContent(BuildContext context, AuthState state) {
    return Container(
      width: double.maxFinite,
      margin: ResponsiveHelper.getScreenMargin(context),
      padding: ResponsiveHelper.getScreenPadding(context),
      decoration:
          ResponsiveHelper.isWebAndIsNotMobile(context)
              ? BoxDecoration(
                borderRadius: BorderRadius.circular(ResponsiveHelper.getAuthBoxRadius(context)),
                color: Theme.of(context).customColors.fillColor,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).customColors.darkShadowColor!.withValues(alpha: 0.12),
                    blurRadius: 199.0,
                    offset: Offset(0, 89.77),
                  ),
                ],
              )
              : BoxDecoration(),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isWebAndIsNotMobile(context) ? 30 : 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLoginHeader(context, state),
              buildSizedBoxH(20.0),
              state.selectedLoginType == LoginType.phone
                  ? Form(
                    key: state.phoneFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AbsorbPointer(
                          absorbing: state.isOtpTimerRunning || state.isOtpRequestInProgress,
                          child: _buildPhoneTextField(context, state),
                        ),
                        buildSizedBoxH(getSpacing(context)),
                        _buildOTPField(context),
                      ],
                    ),
                  )
                  : Form(
                    key: state.emailFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildEmailIdUserNameField(context, state),
                        buildSizedBoxH(getSpacing(context)),
                        _buildPasswordField(context, state),
                      ],
                    ),
                  ),
              buildSizedBoxH(getSpacing(context)),
              _buildLoginButton(context),
              buildSizedBoxH(getSpacing(context)),
              _buildChangeLoginTypeButton(context),
              buildSizedBoxH(getDividerPadding(context)),
              _buildDivider(context),
              buildSizedBoxH(getDividerPadding(context)),
              _buildSocialLoginButtons(context),
              buildSizedBoxH(getSpacing(context)),
              _buildSignUpLink(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppLogo(BuildContext context) {
    return Center(
      child: CustomImageView(
        imagePath: Assets.images.svgs.other.appLogo.path,
        height: ResponsiveHelper.getLogoHeight(context),
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildLoginHeader(BuildContext context, AuthState state) {
    return Center(
      child: Text(
        Lang.of(context).lbl_login_title,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontSize: headerFontSize(context),
          fontWeight: FontWeight.w600,
          letterSpacing: 0.36,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildEmailIdUserNameField(BuildContext context, AuthState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_email_userid,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontSize: fieldTitleSize(context), fontWeight: FontWeight.w400),
        ),
        buildSizedBoxH(8.0),
        CustomTextInputField(
          context: context,
          type: InputType.text,
          controller: state.emailIdUserNameController,
          textInputAction: TextInputAction.next,
          validator: ExchekValidations.validateEmail,
          isDense: true,
          autofillHints: const [AutofillHints.username],
          contentPadding: EdgeInsets.symmetric(vertical: getFieldVerticalPadidng(context), horizontal: 18.0),
          textStyleFontSize: fieldTextFontSize(context),
          shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForEmailValidation,
        ),
      ],
    );
  }

  Widget _buildPasswordField(BuildContext context, AuthState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Lang.of(context).lbl_password,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontSize: fieldTitleSize(context), fontWeight: FontWeight.w400),
            ),
            _buildForgotPasswordLink(context),
          ],
        ),
        buildSizedBoxH(5.0),
        CustomTextInputField(
          context: context,
          type: InputType.password,
          obscuredText: state.isObscuredPassword,
          controller: state.passwordController,
          textInputAction: TextInputAction.done,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: getFieldVerticalPadidng(context), horizontal: 20.0),
          suffixIcon: Container(
            padding: EdgeInsets.only(right: 20.0),
            color: Colors.transparent,
            alignment: Alignment.center,
            child: CustomImageView(
              imagePath:
                  state.isObscuredPassword
                      ? Assets.images.svgs.icons.icEyeSlash.path
                      : Assets.images.svgs.icons.icEye.path,
              height: 15.0,
              width: 20.0,
              onTap: () {
                BlocProvider.of<AuthBloc>(
                  context,
                ).add(ChanegPasswordVisibility(obscuredText: !(state.isObscuredPassword)));
              },
            ),
          ),
          onFieldSubmitted: (value) {
            if (kIsWeb && state.selectedLoginType == LoginType.email) {
              if (state.emailFormKey.currentState?.validate() ?? false) {
                context.read<AuthBloc>().add(
                  EmailLoginSubmitted(
                    emailIdOrUserName: state.emailIdUserNameController?.text ?? '',
                    password: state.passwordController?.text ?? '',
                  ),
                );
              }
            }
          },
          contextMenuBuilder: (BuildContext context, EditableTextState editableTextState) {
            return AdaptiveTextSelectionToolbar.buttonItems(
              anchors: editableTextState.contextMenuAnchors,
              buttonItems:
                  editableTextState.contextMenuButtonItems
                      .where((item) => item.type != ContextMenuButtonType.paste)
                      .toList(),
            );
          },
          // inputFormatters: [NoPasteFormatter()],
          textStyleFontSize: fieldTextFontSize(context),
        ),
      ],
    );
  }

  Widget _buildPhoneTextField(BuildContext context, AuthState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_mobile_number,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: fieldTitleSize(context),
            fontWeight: FontWeight.w400,
            height: 1.1,
          ),
        ),
        buildSizedBoxH(8.0),
        CustomTextInputField(
          context: context,
          type: InputType.digits,
          controller: state.phoneController,
          textInputAction: TextInputAction.next,
          boxConstraints: BoxConstraints(minWidth: ResponsiveHelper.isMobile(context) ? 70.0 : 70.0),
          prefixIcon: Container(
            margin: EdgeInsets.only(right: 10.0),
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: Theme.of(context).customColors.secondaryTextColor!)),
            ),
            alignment: Alignment.center,
            child: Text(
              Lang.of(context).lbl_india_code,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: fieldTextFontSize(context),
                color: Theme.of(context).customColors.secondaryTextColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          maxLength: 10,
          validator: ExchekValidations.validateMobileNumber,
          shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForMobileNumberValidation,
          contentPadding: EdgeInsets.symmetric(vertical: getFieldVerticalPadidng(context), horizontal: 20.0),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onFieldSubmitted: (value) {
            if (value.length == 10 && (ExchekValidations.validateMobileNumber(value) == null)) {
              FocusManager.instance.primaryFocus?.unfocus();
              BlocProvider.of<AuthBloc>(context).add(SendOtpPressed(phoneNumber: value));
            }
          },
          isDense: true,
          textStyleFontSize: fieldTextFontSize(context),
        ),
      ],
    );
  }

  Widget _buildOTPField(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Lang.of(context).lbl_one_time_password,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontSize: fieldTitleSize(context), fontWeight: FontWeight.w400),
            ),
            buildSizedBoxH(8.0),
            CustomTextInputField(
              context: context,
              type: InputType.digits,
              controller: state.otpController,
              textInputAction: TextInputAction.done,
              validator: ExchekValidations.validateOTP,
              suffixText: true,
              suffixIcon: ValueListenableBuilder(
                valueListenable: state.phoneController!,
                builder: (context, _, __) {
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap:
                          state.isOtpTimerRunning || state.isOtpRequestInProgress
                              ? null
                              : state.otpRemainingTime > 0 || (state.phoneController?.text.length != 10)
                              ? null
                              : () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                BlocProvider.of<AuthBloc>(
                                  context,
                                ).add(SendOtpPressed(phoneNumber: state.phoneController?.text ?? ''));
                              },
                      child: Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.symmetric(
                          vertical:
                              ResponsiveHelper.isBigScreen(context)
                                  ? 17.0
                                  : (ResponsiveHelper.isWebAndIsNotMobile(context) ? 10.0 : 16.0),
                          horizontal: 18.0,
                        ),
                        child: Text(
                          state.isOtpTimerRunning
                              ? '${Lang.of(context).lbl_resend_in} ${state.otpRemainingTime}s'
                              : Lang.of(context).lbl_send_otp,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                state.isOtpTimerRunning || (state.phoneController?.text.length != 10)
                                    ? Theme.of(context).customColors.textdarkcolor?.withValues(alpha: 0.5)
                                    : Theme.of(context).customColors.greenColor,
                            fontWeight: FontWeight.w600,
                            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 14, desktop: 14),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
              maxLength: 6,
              contentPadding: EdgeInsets.symmetric(vertical: getFieldVerticalPadidng(context), horizontal: 18.0),
              onFieldSubmitted: (value) {
                if (state.phoneFormKey.currentState?.validate() ?? false) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  context.read<AuthBloc>().add(
                    LoginSubmitted(
                      phoneNumber: state.phoneController?.text ?? '',
                      otp: state.otpController?.text ?? '',
                    ),
                  );
                }
              },
              contextMenuBuilder: (BuildContext context, EditableTextState editableTextState) {
                return AdaptiveTextSelectionToolbar.buttonItems(
                  anchors: editableTextState.contextMenuAnchors,
                  buttonItems:
                      editableTextState.contextMenuButtonItems
                          .where((item) => item.type != ContextMenuButtonType.paste)
                          .toList(),
                );
              },
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, NoPasteFormatter()],
              isDense: true,
              boxConstraints: BoxConstraints(maxHeight: 20.0),
              textStyleFontSize: fieldTextFontSize(context),
            ),
          ],
        );
      },
    );
  }

  Widget _buildForgotPasswordLink(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                context.read<AuthBloc>().add(CancelForgotPasswordTimerManuallyEvent());
                if (kIsWeb) {
                  GoRouter.of(context).go(RouteUri.forgotPasswordRoute);
                } else {
                  GoRouter.of(context).push(RouteUri.forgotPasswordRoute);
                }
              },
              child: Text(
                Lang.of(context).lbl_forgot_password,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: linkFontSize(context),
                  color: Theme.of(context).customColors.greenColor,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                  letterSpacing: 0.16,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChangeLoginTypeButton(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return AnimatedBuilder(
          animation: Listenable.merge([]),
          builder: (context, _) {
            return CustomElevatedButton(
              width: double.infinity,
              height: buttonHeight(context),
              isDisabled: false,
              isLoading: false,
              text:
                  "${Lang.of(context).lbl_log_in_with} ${state.selectedLoginType == LoginType.phone ? Lang.of(context).lbl_email_userid : Lang.of(context).lbl_mobile_number}",
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(
                  ChangeLoginType(
                    selectedLoginType: state.selectedLoginType == LoginType.phone ? LoginType.email : LoginType.phone,
                  ),
                );
              },
              buttonStyle: ButtonThemeHelper.outlineBorderElevatedButtonStyle(context),
              buttonTextStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: buttonFontSize(context),
                color: Theme.of(context).customColors.primaryColor,
                letterSpacing: 0.18,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isPhoneLogin = state.selectedLoginType == LoginType.phone;
        final useridcontroller = isPhoneLogin ? state.phoneController : state.emailIdUserNameController;
        final passwordcontroller = isPhoneLogin ? state.otpController : state.passwordController;
        return AnimatedBuilder(
          animation: Listenable.merge([useridcontroller, passwordcontroller]),
          builder: (context, _) {
            final isDisabled =
                state.isloginLoading ||
                (isPhoneLogin
                    ? ((state.phoneController?.text.isEmpty ?? true) || (state.otpController?.text.isEmpty ?? true))
                    : ((state.emailIdUserNameController?.text.isEmpty ?? true) ||
                        (state.passwordController?.text.isEmpty ?? true)));

            return CustomElevatedButton(
              width: double.infinity,
              isDisabled: isDisabled,
              height: buttonHeight(context),
              isLoading: state.isloginLoading,
              text: Lang.of(context).lbl_login,
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                if (isPhoneLogin) {
                  if (state.phoneFormKey.currentState?.validate() ?? false) {
                    context.read<AuthBloc>().add(
                      LoginSubmitted(
                        phoneNumber: state.phoneController?.text ?? '',
                        otp: state.otpController?.text ?? '',
                      ),
                    );
                  }
                } else {
                  if (state.emailFormKey.currentState?.validate() ?? false) {
                    context.read<AuthBloc>().add(
                      EmailLoginSubmitted(
                        emailIdOrUserName: state.emailIdUserNameController?.text ?? '',
                        password: state.passwordController?.text ?? '',
                      ),
                    );
                  }
                }
              },
              buttonTextStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: buttonFontSize(context),
                color: Theme.of(context).customColors.fillColor,
                letterSpacing: 0.18,
              ),
              buttonStyle: ButtonThemeHelper.authElevatedButtonStyle(context),
            );
          },
        );
      },
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 15.0 : 0),
      child: Row(
        children: [
          Expanded(child: Divider(color: Theme.of(context).customColors.dividerColor!, thickness: 1)),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getWidgetSize(context, mobile: 12, tablet: 14, desktop: 14),
            ),
            child: Text(
              Lang.of(context).lbl_or_continue_with,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize:
                    ResponsiveHelper.isBigScreen(context)
                        ? ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 16)
                        : ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 14, desktop: 14),
                color: Theme.of(context).customColors.secondaryTextColor,
                letterSpacing: 0.16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(child: Divider(color: Theme.of(context).customColors.dividerColor!, thickness: 1)),
        ],
      ),
    );
  }

  Widget _buildSocialLoginButtons(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 35,
              child: CustomImageView(
                imagePath: Assets.images.pngs.authentication.pngGoogle.path,
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  context.read<AuthBloc>().add(GoogleSignInPressed());
                },
              ),
            ),

            SizedBox(
              height: 35,
              child: CustomImageView(
                imagePath: Assets.images.pngs.authentication.pngApple.path,
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  context.read<AuthBloc>().add(AppleSignInPressed());
                },
              ),
            ),

            SizedBox(
              height: 35,
              child: CustomImageView(
                imagePath: Assets.images.pngs.authentication.pngLinkedIn.path,
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  context.read<AuthBloc>().add(LinkedInSignInPressed());
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSignUpLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          Lang.of(context).lbl_new_to_exchek,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: linkFontSize(context),
            fontWeight: FontWeight.w400,
            letterSpacing: 0.16,
          ),
        ),
        InkWell(
          onTap: () {
            context.read<AuthBloc>().add(ClearSignupDataManuallyEvent());
            FocusManager.instance.primaryFocus?.unfocus();
            if (kIsWeb) {
              GoRouter.of(context).go(RouteUri.signupRoute);
            } else {
              GoRouter.of(context).push(RouteUri.signupRoute);
            }
          },
          child: Text(
            Lang.of(context).lbl_sign_up,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: linkFontSize(context),
              color: Theme.of(context).customColors.greenColor,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.16,
            ),
          ),
        ),
      ],
    );
  }
}
