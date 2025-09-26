import 'package:exchek/core/utils/exports.dart';

class EkySubmissionConfirmation extends StatelessWidget {
  const EkySubmissionConfirmation({super.key});

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
    return ResponsiveScaffold(
      body: BackgroundImage(
        imagePath: Assets.images.svgs.other.appBg.path,
        child: SafeArea(
          bottom: false,
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {},
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
                          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isBigScreen(context) ? 25 : 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _buildAppLogo(context),
                              buildSizedBoxH(logoAndContentPadding(context)),
                              _buildEKycConfirmHeader(context, state),
                              buildSizedBoxH(logoAndContentPadding(context)),
                              _buildContinueButton(context, state),
                              if (ResponsiveHelper.isWebAndIsNotMobile(context))
                                buildSizedBoxH(ResponsiveHelper.isBigScreen(context) ? 100 : 70),
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

  Widget _buildAppLogo(BuildContext context) {
    return Center(
      child: CustomImageView(
        imagePath: Assets.images.svgs.icons.icVerifyIcon.path,
        height: ResponsiveHelper.getWidgetHeight(context, mobile: 52.0, tablet: 62.0, desktop: 72.0),
        width: ResponsiveHelper.getWidgetHeight(context, mobile: 52.0, tablet: 62.0, desktop: 72.0),
      ),
    );
  }

  Widget _buildEKycConfirmHeader(BuildContext context, AuthState state) {
    return Column(
      spacing: 24,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          Lang.of(context).lbl_kyc_success_submitted, // "Your KYC has been successfully submitted"
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 18),
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.85),
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          Lang.of(context).lbl_kyc_verification_time,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 16),
            fontWeight: FontWeight.w400,
            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.65),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildContinueButton(BuildContext context, AuthState state) {
    double buttonWidth;

    if (ResponsiveHelper.isDesktop(context)) {
      buttonWidth = 460;
    } else if (ResponsiveHelper.isTablet(context)) {
      buttonWidth = 400;
    } else {
      buttonWidth = double.infinity;
    }

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Center(
            child: SizedBox(
              width: buttonWidth,
              child: CustomElevatedButton(
                height: buttonHeight(context),
                text: "Continue to Dashboard",
                onPressed: () {
                  GoRouter.of(context).push(RouteUri.dashboardRoute);
                  // context.read<DashboardBloc>().add(CurrencyStarted());
                },
                buttonStyle: ButtonThemeHelper.authElevatedButtonStyle(context),
                buttonTextStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: buttonFontSize(context),
                  color: Theme.of(context).customColors.fillColor,
                  letterSpacing: 0.18,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static EdgeInsets boxPadding(BuildContext context) {
    if (ResponsiveHelper.isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 36);
    } else if (ResponsiveHelper.isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 30);
    } else {
      return const EdgeInsets.symmetric(horizontal: 20);
    }
  }
}
