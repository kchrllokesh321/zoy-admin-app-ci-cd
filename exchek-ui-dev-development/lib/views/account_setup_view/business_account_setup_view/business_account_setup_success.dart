import 'package:exchek/core/utils/exports.dart';

class BusinessAccountSetupSuccessView extends StatelessWidget {
  const BusinessAccountSetupSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          exit(0);
        }
      },
      child: ResponsiveScaffold(
        appBar:
            !ResponsiveHelper.isWebAndIsNotMobile(context)
                ? null
                : ExchekAppBar(
                  appBarContext: context,
                  showCloseButton: false,
                  onBackPressed: () {
                    if (ResponsiveHelper.isWebAndIsNotMobile(context)) {
                      GoRouter.of(context).pop();
                    } else {
                      GoRouter.of(context).go(RouteUri.businessAccountSetupViewRoute);
                    }
                  },
                ),
        body: BackgroundImage(
          imagePath: Assets.images.svgs.other.appBg.path,
          child: BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
            builder: (context, state) {
              return Column(
                children: [
                  Expanded(
                    child: Center(
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: ResponsiveHelper.getMaxFormWidth(context)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _buildVerifyLogo(context),
                                  buildSizedBoxH(
                                    ResponsiveHelper.getWidgetHeight(context, mobile: 20, tablet: 24, desktop: 24),
                                  ),
                                  _buildSuccessContentText(context),
                                  buildSizedBoxH(
                                    ResponsiveHelper.getWidgetHeight(context, mobile: 30, tablet: 32, desktop: 32),
                                  ),
                                  _buildLoginButton(context),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // GetHelpTextButton(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: ResponsiveHelper.isMobile(context) ? 20.0 : 0),
        child: CustomElevatedButton(
          width: 508,
          buttonStyle: ButtonThemeHelper.borderElevatedButtonStyle(context),
          text: Lang.of(context).lbl_login_text,
          borderRadius: 50.0,
          buttonTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Theme.of(context).customColors.fillColor,
            letterSpacing: 0.32,
          ),
          onPressed: () {
            context.read<AuthBloc>().add(ClearLoginDataManuallyEvent());
            if (kIsWeb) {
              Prefobj.preferences.delete(Prefkeys.authToken);
              GoRouter.of(context).go(RouteUri.loginRoute);
            } else {
              Prefobj.preferences.delete(Prefkeys.authToken);
              GoRouter.of(context).pushReplacement(RouteUri.loginRoute);
            }
          },
        ),
      ),
    );
  }

  Widget _buildSuccessContentText(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: ResponsiveHelper.isMobile(context) ? 10.0 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            Lang.of(context).lbl_business_account_basic_setup,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: ResponsiveHelper.getFontSize(context, mobile: 28, tablet: 30, desktop: 32),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.32,
            ),
            textAlign: TextAlign.center,
          ),
          buildSizedBoxH(ResponsiveHelper.getWidgetHeight(context, mobile: 12, tablet: 12, desktop: 12)),
          Text(
            Lang.of(context).lbl_please_login_to_continue,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
              fontWeight: FontWeight.w400,
              color: Theme.of(context).customColors.secondaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyLogo(BuildContext context) {
    return CustomImageView(
      imagePath: Assets.images.svgs.icons.icVerifyIcon.path,
      height: ResponsiveHelper.getWidgetHeight(context, mobile: 52.0, tablet: 62.0, desktop: 72.0),
      width: ResponsiveHelper.getWidgetHeight(context, mobile: 52.0, tablet: 62.0, desktop: 72.0),
    );
  }
}
