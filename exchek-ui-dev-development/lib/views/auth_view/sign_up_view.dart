import 'package:exchek/core/utils/exports.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

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
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).customColors.fillColor,
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
                            buildSizedBoxH(logoAndContentPadding(context)),
                            _buildSignUpContent(context, state),
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

  Widget _buildAppLogo(BuildContext context) {
    return Center(
      child: CustomImageView(
        imagePath: Assets.images.svgs.other.appLogo.path,
        height: ResponsiveHelper.getLogoHeight(context),
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildSignUpContent(BuildContext context, AuthState state) {
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
      child: Form(
        key: state.signupFormKey,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isWebAndIsNotMobile(context) ? 20 : 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (ResponsiveHelper.isWebAndIsNotMobile(context)) buildSizedBoxH(getSpacing(context)),
              _buildSignupHeader(context, state),
              buildSizedBoxH(getSpacing(context)),
              _buildEmailIdField(context, state),
              buildSizedBoxH(ResponsiveHelper.isBigScreen(context) ? 40.0 : 25.0),
              _buildNextButton(context),
              buildSizedBoxH(getSpacing(context)),
              _buildDivider(context),
              buildSizedBoxH(getSpacing(context)),
              _buildSocialLoginButtons(context),
              buildSizedBoxH(getSpacing(context)),
              _buildLoginLink(context),
              if (ResponsiveHelper.isWebAndIsNotMobile(context)) buildSizedBoxH(getSpacing(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignupHeader(BuildContext context, AuthState state) {
    return Text(
      Lang.of(context).lbl_create_account_title,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontSize: headerFontSize(context),
        fontWeight: FontWeight.w600,
        letterSpacing: 1.0,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildEmailIdField(BuildContext context, AuthState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_email_address,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontSize: fieldTitleSize(context), fontWeight: FontWeight.w400),
        ),
        buildSizedBoxH(8.0),
        CustomTextInputField(
          context: context,
          type: InputType.email,
          controller: state.signupEmailIdController,
          textInputAction: TextInputAction.done,
          validator: ExchekValidations.validateEmail,
          contentPadding: EdgeInsets.symmetric(vertical: getFieldVerticalPadidng(context), horizontal: 20.0),
          onFieldSubmitted: (value) {
            FocusManager.instance.primaryFocus?.unfocus();
            if (state.signupFormKey.currentState?.validate() ?? false) {
              BlocProvider.of<AuthBloc>(
                context,
              ).add(CheckEmailAvailability(email: state.signupEmailIdController?.text ?? '', context: context));
            }
          },
          isDense: true,
          textStyleFontSize: fieldTextFontSize(context),
          shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForEmailValidation,
        ),
      ],
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return AnimatedBuilder(
          animation: state.signupEmailIdController ?? TextEditingController(),
          builder: (context, _) {
            final isDisabled = state.issignupLoading || (state.signupEmailIdController?.text.isEmpty ?? true);
            return SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                isDisabled: isDisabled,
                isLoading: state.issignupLoading,
                text: Lang.of(context).lbl_next,
                onPressed: () async {
                  if (state.signupFormKey.currentState?.validate() ?? false) {
                    BlocProvider.of<AuthBloc>(
                      context,
                    ).add(CheckEmailAvailability(email: state.signupEmailIdController?.text ?? '', context: context));
                  }
                },
                buttonStyle: ButtonThemeHelper.authElevatedButtonStyle(context),
                height: buttonHeight(context),
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

  Widget _buildDivider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: Theme.of(context).customColors.secondaryTextColor?.withValues(alpha: 0.5),
              thickness: 1,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getWidgetSize(context, mobile: 12, tablet: 16, desktop: 20),
            ),
            child: Text(
              Lang.of(context).lbl_or_continue_with,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 16),
                color: Theme.of(context).customColors.secondaryTextColor,
                letterSpacing: 0.8,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Divider(
              color: Theme.of(context).customColors.secondaryTextColor?.withValues(alpha: 0.5),
              thickness: 1,
            ),
          ),
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
            // SocialIconWidget(
            //   iconImage: Assets.images.pngs.authentication.pngGoogle.path,
            //   title: Lang.of(context).lbl_google,
            //   onTap: () {
            //     FocusManager.instance.primaryFocus?.unfocus();
            //     context.read<AuthBloc>().add(GoogleSignInPressed());
            //   },
            // ),
            // buildSizedboxW(5.0),
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
            // buildSizedboxW(5.0),
            // SocialIconWidget(
            //   iconImage: Assets.images.pngs.authentication.pngApple.path,
            //   title: Lang.of(context).lbl_apple,
            //   onTap: () {
            //     FocusManager.instance.primaryFocus?.unfocus();
            //     context.read<AuthBloc>().add(AppleSignInPressed());
            //   },
            // ),
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
            // SocialIconWidget(
            //   iconImage: Assets.images.pngs.authentication.pngLinkedIn.path,
            //   title: Lang.of(context).lbl_linkdin,
            //   onTap: () {
            //     FocusManager.instance.primaryFocus?.unfocus();
            //     context.read<AuthBloc>().add(LinkedInSignInPressed());
            //   },
            // ),
          ],
        );
      },
    );
  }

  // Widget _buildSocialLoginButtons(BuildContext context) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //     children: [
  //       SocialIconWidget(
  //         iconImage: Assets.images.pngs.authentication.pngGoogle.path,
  //         title: Lang.of(context).lbl_google,
  //         onTap: () {
  //           FocusManager.instance.primaryFocus?.unfocus();
  //           // Handle Google login
  //         },
  //       ),
  //       SocialIconWidget(
  //         iconImage: Assets.images.pngs.authentication.pngApple.path,
  //         title: Lang.of(context).lbl_apple,
  //         onTap: () {
  //           FocusManager.instance.primaryFocus?.unfocus();
  //           // Handle Apple login
  //         },
  //       ),
  //       SocialIconWidget(
  //         iconImage: Assets.images.pngs.authentication.pngLinkedIn.path,
  //         title: Lang.of(context).lbl_linkdin,
  //         onTap: () {
  //           FocusManager.instance.primaryFocus?.unfocus();
  //           // Handle LinkedIn login
  //         },
  //       ),
  //     ],
  //   );
  // }

  Widget _buildLoginLink(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: Lang.of(context).lbl_already_have_account,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: linkFontSize(context),
          fontWeight: FontWeight.w500,
          letterSpacing: 0.8,
        ),
        children: [
          const TextSpan(text: " "),
          TextSpan(
            text: Lang.of(context).lbl_login,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: linkFontSize(context),
              color: Theme.of(context).customColors.greenColor,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.8,
            ),
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (kIsWeb) {
                      GoRouter.of(context).go(RouteUri.loginRoute);
                    } else {
                      context.read<AuthBloc>().add(ClearLoginDataManuallyEvent());
                      GoRouter.of(context).go(RouteUri.loginRoute);
                    }
                  },
          ),
        ],
      ),
    );
  }
}
