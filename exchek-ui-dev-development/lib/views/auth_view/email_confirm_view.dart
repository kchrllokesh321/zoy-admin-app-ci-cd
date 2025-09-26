import 'package:exchek/core/utils/exports.dart';

class EmailConfirmView extends StatelessWidget {
  const EmailConfirmView({super.key});

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
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.isVerifyEmail) {
              if (kIsWeb) {
                GoRouter.of(context).go(RouteUri.selectAccountTypeRoute);
              } else {
                GoRouter.of(context).push(RouteUri.selectAccountTypeRoute);
              }
            }
          },
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildAppLogo(context),
                            buildSizedBoxH(logoAndContentPadding(context)),
                            _buildEmailConfirmContent(context, state),
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

  Widget _buildEmailConfirmContent(BuildContext context, AuthState state) {
    return Container(
      width: double.maxFinite,
      margin: ResponsiveHelper.getScreenMargin(context),
      padding: boxPadding(context),
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
              : null,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isWebAndIsNotMobile(context) ? 20 : 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (ResponsiveHelper.isWebAndIsNotMobile(context))
              buildSizedBoxH(ResponsiveHelper.isBigScreen(context) ? 100 : 70),
            _buildEmailConfirmHeader(context, state),
            buildSizedBoxH(ResponsiveHelper.isBigScreen(context) ? 50 : 30),
            _buildContinueButton(context, state),
            if (ResponsiveHelper.isWebAndIsNotMobile(context))
              buildSizedBoxH(ResponsiveHelper.isBigScreen(context) ? 100 : 70),
          ],
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

  Widget _buildEmailConfirmHeader(BuildContext context, AuthState state) {
    return Column(
      spacing: 34,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          Lang.of(context).lbl_email_confirm,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontSize: headerFontSize(context), fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        Text(
          Lang.of(context).lbl_continue_with_account,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize:
                ResponsiveHelper.isBigScreen(context)
                    ? ResponsiveHelper.getFontSize(context, mobile: 18, tablet: 18, desktop: 18)
                    : ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 16, desktop: 16),
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.headlineMedium?.color?.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildContinueButton(BuildContext context, AuthState state) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return SizedBox(
          width: ResponsiveHelper.isMobile(context) ? double.infinity : 450,
          child: CustomElevatedButton(
            height: buttonHeight(context),
            text: Lang.of(context).lbl_continue,
            onPressed: () {
              context.read<AuthBloc>().add(VerifyEmailEvent());
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
