import 'package:exchek/core/utils/exports.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  double fieldTitleSize(BuildContext context) {
    return ResponsiveHelper.isBigScreen(context) ? 16.0 : (ResponsiveHelper.isWebAndIsNotMobile(context) ? 13.0 : 16.0);
  }

  double linkFontSize(BuildContext context) {
    return ResponsiveHelper.isBigScreen(context)
        ? ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 15)
        : ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 12, desktop: 12);
  }

  double getSpacing(BuildContext context) {
    return ResponsiveHelper.isBigScreen(context) ? 26.0 : 20.0;
  }

  double getFieldVerticalPadidng(BuildContext context) {
    return ResponsiveHelper.isBigScreen(context) ? 17.0 : (ResponsiveHelper.isWebAndIsNotMobile(context) ? 14.0 : 16.0);
  }

  double fieldTextFontSize(BuildContext context) {
    return ResponsiveHelper.isBigScreen(context)
        ? ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 16, desktop: 16)
        : ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 14, desktop: 14);
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
    return LandingPageScaffold(
      backgroundColor: Theme.of(context).customColors.fillColor,
      appBar:
          ResponsiveHelper.isWebAndIsNotMobile(context)
              ? null
              : ExchekAppBar(
                appBarContext: context,
                onBackPressed: () {
                  context.read<AuthBloc>().add(ClearLoginDataManuallyEvent());
                  if (kIsWeb) {
                    GoRouter.of(context).go(RouteUri.loginRoute);
                  } else {
                    GoRouter.of(context).pop();
                  }
                },
                showCloseButton: false,
              ),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<AuthBloc, AuthState>(
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
                            buildSizedBoxH(ResponsiveHelper.isBigScreen(context) ? 30.0 : 18.0),
                            _buildForgotPasswordContent(context, state),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildForgotPasswordContent(BuildContext context, AuthState state) {
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
                    blurRadius: 200.0,
                    offset: Offset(0, 89.77),
                  ),
                ],
              )
              : BoxDecoration(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isWebAndIsNotMobile(context) ? 30 : 0),
        child: Form(
          key: state.forgotPasswordFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (ResponsiveHelper.isWebAndIsNotMobile(context)) buildSizedBoxH(20),
              _buildForgotPasswordHeader(context, state),
              buildSizedBoxH(getSpacing(context)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isWebAndIsNotMobile(context) ? 10.0 : 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildEmailIdPhoneNumberField(context, state),
                    buildSizedBoxH(getSpacing(context)),
                    ValueListenableBuilder(
                      valueListenable: state.emailIdPhoneNumberController!,
                      builder: (context, value, _) {
                        final input = value.text;
                        if (ExchekValidations.validateEmail(input) != null) {
                          return Column(children: [_buildOTPField(context, state)]);
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    buildSizedBoxH(getSpacing(context)),
                    _buildBackToLoginLink(context),
                    buildSizedBoxH(getSpacing(context)),
                    _buildSubmitButton(context),
                    if (ResponsiveHelper.isWebAndIsNotMobile(context)) buildSizedBoxH(30),
                    if (!kIsWeb) buildSizedBoxH(kToolbarHeight),
                  ],
                ),
              ),
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

  Widget _buildForgotPasswordHeader(BuildContext context, AuthState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          Lang.of(context).lbl_forgot_password_title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: headerFontSize(context),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.36,
          ),
          textAlign: TextAlign.center,
        ),
        buildSizedBoxH(20),
        Text(
          Lang.of(context).lbl_forgot_password_content,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize:
                ResponsiveHelper.isBigScreen(context)
                    ? ResponsiveHelper.getFontSize(context, mobile: 18, tablet: 18, desktop: 18)
                    : ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 16, desktop: 16),
            color: Theme.of(context).customColors.secondaryTextColor,
            fontWeight: FontWeight.w400,
            wordSpacing: 1.2,
            letterSpacing: 0.18,
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmailIdPhoneNumberField(BuildContext context, AuthState state) {
    return AbsorbPointer(
      absorbing: state.isOtpTimerRunningForForgotPassword,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Lang.of(context).lbl_email_mobilenumber,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontSize: fieldTitleSize(context), fontWeight: FontWeight.w400),
          ),
          buildSizedBoxH(8.0),
          CustomTextInputField(
            context: context,
            type: InputType.text,
            controller: state.emailIdPhoneNumberController,
            textInputAction: TextInputAction.next,
            validator: ExchekValidations.validateEmailOrMobileNumber,
            shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForEmailOrMobileNumberValidation,
            // contentPadding: EdgeInsets.symmetric(
            //   vertical: ResponsiveHelper.getScreenHeight(context) * 0.017,
            //   horizontal: 20.0,
            // ),
            contentPadding: EdgeInsets.symmetric(vertical: getFieldVerticalPadidng(context), horizontal: 18.0),
            onFieldSubmitted: (value) {
              FocusManager.instance.primaryFocus?.unfocus();
              if (ExchekValidations.validateEmail(state.emailIdPhoneNumberController?.text ?? '') == null) {
                context.read<AuthBloc>().add(
                  ForgotResetEmailSubmited(emailIdOrPhoneNumber: state.emailIdPhoneNumberController?.text ?? ''),
                );
              } else {
                if (value.length == 10 && (ExchekValidations.validateMobileNumber(value) == null)) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  BlocProvider.of<AuthBloc>(
                    context,
                  ).add(SendOtpForgotPasswordPressed(phoneNumber: state.emailIdPhoneNumberController?.text ?? ''));
                }
              }
            },
            isDense: true,
            boxConstraints: const BoxConstraints(maxHeight: 20.0),
            textStyleFontSize: fieldTextFontSize(context),
          ),
        ],
      ),
    );
  }

  Widget _buildOTPField(BuildContext context, AuthState state) {
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
          controller: state.forgotPasswordOTPController,
          textInputAction: TextInputAction.done,
          validator: ExchekValidations.validateOTP,
          suffixText: true,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, NoPasteFormatter()],
          suffixIcon: ValueListenableBuilder(
            valueListenable: state.emailIdPhoneNumberController!,
            builder: (context, value, child) {
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap:
                      state.isOtpTimerRunningForForgotPassword ||
                              ExchekValidations.validateEmailOrMobileNumber(state.emailIdPhoneNumberController?.text) !=
                                  null
                          ? null
                          : () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            BlocProvider.of<AuthBloc>(context).add(
                              SendOtpForgotPasswordPressed(phoneNumber: state.emailIdPhoneNumberController?.text ?? ''),
                            );
                          },
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: getFieldVerticalPadidng(context), horizontal: 20.0),
                    child: Text(
                      state.isOtpTimerRunningForForgotPassword
                          ? '${Lang.of(context).lbl_resend_in} (${state.otpRemainingTimeForForgotPassword}s)'
                          : Lang.of(context).lbl_send_otp,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color:
                            state.isOtpTimerRunningForForgotPassword ||
                                    ExchekValidations.validateEmailOrMobileNumber(
                                          state.emailIdPhoneNumberController?.text,
                                        ) !=
                                        null
                                ? Theme.of(context).customColors.textdarkcolor?.withValues(alpha: 0.5)
                                : Theme.of(context).customColors.greenColor,
                        fontWeight: FontWeight.w500,
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
          contentPadding: EdgeInsets.symmetric(vertical: getFieldVerticalPadidng(context), horizontal: 20.0),
          onFieldSubmitted: (value) {
            FocusManager.instance.primaryFocus?.unfocus();
            BlocProvider.of<AuthBloc>(context).add(
              ForgotPasswordSubmited(
                emailIdOrPhoneNumber: state.emailIdPhoneNumberController?.text ?? '',
                otp: state.forgotPasswordOTPController?.text ?? '',
                context: context,
              ),
            );
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
          isDense: true,
          boxConstraints: BoxConstraints(maxHeight: 20.0),
          textStyleFontSize: fieldTextFontSize(context),
        ),
      ],
    );
  }

  Widget _buildBackToLoginLink(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            context.read<AuthBloc>().add(ClearLoginDataManuallyEvent());
            if (kIsWeb) {
              GoRouter.of(context).pushReplacement(RouteUri.loginRoute);
            } else {
              GoRouter.of(context).go(RouteUri.loginRoute);
            }
          },
          child: Text(
            Lang.of(context).lbl_back_to_login,
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
  }

  Widget _buildSubmitButton(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return AnimatedBuilder(
          animation: Listenable.merge([state.emailIdPhoneNumberController, state.forgotPasswordOTPController]),
          builder: (context, _) {
            final input = state.emailIdPhoneNumberController?.text ?? '';
            final isEmail = ExchekValidations.validateEmail(input) == null;

            final isButtonDisabled =
                isEmail
                    ? state.isforgotPasswordLoading || input.isEmpty || state.emailRemainingTimeForForgotPassword > 0
                    : state.isforgotPasswordLoading ||
                        input.isEmpty ||
                        (state.forgotPasswordOTPController?.text.isEmpty ?? true);

            final buttonText =
                isEmail && state.emailRemainingTimeForForgotPassword > 0
                    ? '${Lang.of(context).lbl_resend_in} (${formatSecondsToMMSS(state.emailRemainingTimeForForgotPassword)})'
                    : Lang.of(context).lbl_confirm;

            return SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                isDisabled: isButtonDisabled,
                isLoading: state.isforgotPasswordLoading,
                text: buttonText,
                height: buttonHeight(context),
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (state.forgotPasswordFormKey.currentState?.validate() ?? false) {
                    if (isEmail) {
                      context.read<AuthBloc>().add(ForgotResetEmailSubmited(emailIdOrPhoneNumber: input));
                    } else {
                      context.read<AuthBloc>().add(
                        ForgotPasswordSubmited(
                          emailIdOrPhoneNumber: input,
                          otp: state.forgotPasswordOTPController?.text ?? '',
                          context: context,
                        ),
                      );
                    }
                  }
                },
                buttonStyle: ButtonThemeHelper.authElevatedButtonStyle(context),
                buttonTextStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: buttonFontSize(context),
                  color: Theme.of(context).customColors.fillColor,
                  letterSpacing: 0.18,
                ),
              ),
            );
          },
        );
      },
    );
  }

  String formatSecondsToMMSS(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }
}
