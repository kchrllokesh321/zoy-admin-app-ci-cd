import 'package:exchek/core/utils/exports.dart';

class ForgotPasswordVerifyExpiredView extends StatelessWidget {
  const ForgotPasswordVerifyExpiredView({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar:
          ResponsiveHelper.isWebAndIsNotMobile(context)
              ? ExchekAppBar(appBarContext: context, isShowHelp: false)
              : null,
      backgroundColor: Theme.of(context).customColors.fillColor,
      body: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          clipBehavior: Clip.none,
          child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              exit(0);
            },
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildVerifyEmailHeader(context),
                  buildSizedBoxH(50.0),
                  _buildContentImage(context),
                  buildSizedBoxH(50.0),
                  _buildBackButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerifyEmailHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          Lang.of(context).lbl_forgot_password_request,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 32, tablet: 50, desktop: 60),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        buildSizedBoxH(14.0),
        Text(
          Lang.of(context).lbl_forgot_password_link_expired,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 20, tablet: 22, desktop: 26),
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildContentImage(BuildContext context) {
    return Center(
      child: CustomImageView(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        imagePath: Assets.images.svgs.other.validationError.path,
        height: 232.0,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Center(
      child: CustomElevatedButton(
        width: 250,
        text: Lang.of(context).lbl_back_to_forgot_password,
        borderRadius: 20.0,
        buttonTextStyle: Theme.of(
          context,
        ).textTheme.bodyMedium!.copyWith(color: Theme.of(context).customColors.fillColor, fontSize: 16),
        onPressed: () {
          context.read<AuthBloc>().add(CancelForgotPasswordTimerManuallyEvent());
          if (kIsWeb) {
            context.replace(RouteUri.forgotPasswordRoute);
          } else {
            GoRouter.of(context).pushReplacement(RouteUri.forgotPasswordRoute);
          }
        },
      ),
    );
  }

  EdgeInsets boxPadding(BuildContext context) {
    if (ResponsiveHelper.isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 36);
    } else if (ResponsiveHelper.isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 30);
    } else {
      return const EdgeInsets.symmetric(horizontal: 20);
    }
  }
}
