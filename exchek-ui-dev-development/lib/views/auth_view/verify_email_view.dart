import 'package:exchek/core/utils/exports.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key});

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

  double boxVerticalPadding(BuildContext context) {
    return ResponsiveHelper.isBigScreen(context) ? 90 : 50;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.shouldNavigateToSelectAccount) {
          // Logger.success('Navigation triggered!');

          // Reset navigation flag immediately to prevent multiple triggers
          context.read<AuthBloc>().add(ResetNavigationFlagEvent());

          // Navigate
          if (kIsWeb) {
            GoRouter.of(context).replace(RouteUri.verifyemailRoute);
          } else {
            GoRouter.of(context).pushReplacement(RouteUri.verifyemailRoute);
          }
          return; // Exit early to prevent other logic
        }
        // Handle auto-resend timer initialization when widget first loads
        if (!state.isAutoResendTimerActive) {
          context.read<AuthBloc>().add(StartAutoResendTimerEvent());
        }

        // Load email from preferences if not available
        if (state.signupEmailIdController?.text.isEmpty ?? true) {
          context.read<AuthBloc>().add(LoadEmailFromPreferencesEvent());
        }
      },
      child: LandingPageScaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).customColors.fillColor,
        appBar:
            ResponsiveHelper.isWebAndIsNotMobile(context)
                ? null
                : ExchekAppBar(
                  appBarContext: context,
                  onBackPressed: () {
                    // Stop auto-resend timer when leaving
                    context.read<AuthBloc>().add(StopAutoResendTimerEvent());
                    context.read<AuthBloc>().add(CancelForgotPasswordTimerManuallyEvent());
                    if (kIsWeb) {
                      GoRouter.of(context).go(RouteUri.forgotPasswordRoute);
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
                    physics: const BouncingScrollPhysics(),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: ResponsiveHelper.getMaxAuthFormWidth(context)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _buildAppLogo(context),
                              buildSizedBoxH(logoAndContentPadding(context)),
                              _buildVerifyEmailContent(context, state),
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
      ),
    );
  }

  Widget _buildVerifyEmailContent(BuildContext context, AuthState state) {
    return Container(
      width: double.maxFinite,
      padding: _boxPadding(context),
      margin: ResponsiveHelper.getScreenMargin(context),
      decoration:
          ResponsiveHelper.isWebAndIsNotMobile(context)
              ? BoxDecoration(
                borderRadius: BorderRadius.circular(ResponsiveHelper.getAuthBoxRadius(context)),
                color: Theme.of(context).customColors.fillColor,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).customColors.darkShadowColor!.withValues(alpha: 0.12),
                    blurRadius: 200.0,
                    offset: const Offset(0, 89.77),
                  ),
                ],
              )
              : null,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isWebAndIsNotMobile(context) ? 20 : 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (ResponsiveHelper.isWebAndIsNotMobile(context)) buildSizedBoxH(boxVerticalPadding(context)),
            _buildVerifyEmailHeader(context, state),
            buildSizedBoxH(ResponsiveHelper.isBigScreen(context) ? 50 : 30),
            _buildResendEmailButton(context, state),
            if (ResponsiveHelper.isWebAndIsNotMobile(context)) buildSizedBoxH(boxVerticalPadding(context)),
            buildSizedBoxH(kIsWeb ? 0 : kToolbarHeight),
          ],
        ),
      ),
    );
  }

  EdgeInsets _boxPadding(BuildContext context) {
    if (ResponsiveHelper.isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 36);
    } else if (ResponsiveHelper.isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 30);
    } else {
      return const EdgeInsets.symmetric(horizontal: 20);
    }
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

  Widget _buildVerifyEmailHeader(BuildContext context, AuthState state) {
    return FutureBuilder<String?>(
      future: Prefobj.preferences.get(Prefkeys.emailId),
      builder: (context, snapshot) {
        final emailId = snapshot.data ?? '';
        return Column(
          spacing: 34,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              Lang.of(context).lbl_check_your_email,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: headerFontSize(context),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.36,
              ),
              textAlign: TextAlign.center,
            ),
            Builder(
              builder: (context) {
                return Text(
                  "${Lang.of(context).lbl_verify_email_send} $emailId - ${Lang.of(context).lbl_follow_link}",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize:
                        ResponsiveHelper.isBigScreen(context)
                            ? ResponsiveHelper.getFontSize(context, mobile: 18, tablet: 18, desktop: 18)
                            : ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 16, desktop: 16),
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).customColors.secondaryTextColor,
                    height: 1.2,
                    letterSpacing: 0.22,
                  ),
                  textAlign: TextAlign.center,
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildResendEmailButton(BuildContext context, AuthState state) {
    return FutureBuilder<String?>(
      future: Prefobj.preferences.get(Prefkeys.emailId),
      builder: (context, snapshot) {
        final emailId = snapshot.data ?? '';

        return SizedBox(
          width: ResponsiveHelper.isMobile(context) ? double.infinity : 450,
          child: CustomElevatedButton(
            isLoading: state.isVerifyEmailLoading,
            isDisabled: state.isVerifyEmailLoading || state.isOtpTimerRunningForverifyEmail,
            text:
                state.isOtpTimerRunningForverifyEmail
                    ? '${Lang.of(context).lbl_resend_email_in} ${state.otpRemainingTimeForverifyEmail} ${Lang.of(context).lbl_seconds}'
                    : Lang.of(context).lbl_resend_email,
            onPressed: () {
              context.read<AuthBloc>().add(ResendEmailLink(emailId: emailId, context: context));
            },
            buttonTextStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: buttonFontSize(context),
              color: Theme.of(context).customColors.fillColor,
              letterSpacing: 0.18,
            ),
            buttonStyle: ButtonThemeHelper.authElevatedButtonStyle(context),
            height: buttonHeight(context),
          ),
        );
      },
    );
  }
}
