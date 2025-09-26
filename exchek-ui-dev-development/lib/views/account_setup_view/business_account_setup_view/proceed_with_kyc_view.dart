import 'dart:convert';

import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/viewmodels/account_setup_bloc/personal_account_setup_bloc/personal_account_setup_bloc.dart';

class ProceedWithKycView extends StatelessWidget {
  const ProceedWithKycView({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    return ResponsiveScaffold(
      appBar: ExchekAppBar(
        appBarContext: context,
        showBackButton: false,
        showProfile: true,
        userName: authState.userName ?? '',
        email: authState.email ?? '',
        isBusinessUser: false,
        leading:
            ResponsiveHelper.isWebAndIsNotMobile(context)
                ? null
                : Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: CustomImageView(imagePath: Assets.images.svgs.other.appLogo.path, height: 70.0),
                ),
      ),

      body: BackgroundImage(
        imagePath: Assets.images.svgs.other.appBg.path,
        child: BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: getWidgetWidth(context)),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _buildSuccessContentText(context),
                                buildSizedBoxH(
                                  ResponsiveHelper.getWidgetHeight(context, mobile: 40, tablet: 45, desktop: 45),
                                ),
                                _buildProceedWithKycButton(context),
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
    );
  }

  Widget _buildSuccessContentText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          Lang.of(context).lbl_kyc_onboarding_title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 26, tablet: 30, desktop: 32),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        buildSizedBoxH(ResponsiveHelper.getWidgetHeight(context, mobile: 40, tablet: 45, desktop: 45)),
        Text(
          Lang.of(context).lbl_kyc_onboarding_subtitle,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
            fontWeight: FontWeight.w500,
            color: Theme.of(context).customColors.secondaryTextColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProceedWithKycButton(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsetsGeometry.symmetric(
          horizontal:
              ResponsiveHelper.isMobile(context)
                  ? kIsWeb
                      ? 10.0
                      : 0.0
                  : 0.0,
        ),
        child: BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
          builder: (context, businessState) {
            return BlocBuilder<PersonalAccountSetupBloc, PersonalAccountSetupState>(
              builder: (context, personalState) {
                return CustomElevatedButton(
                  text: Lang.of(context).lbl_proceed_with_kyc,
                  width: ResponsiveHelper.getWidgetSize(
                    context,
                    mobile: double.maxFinite,
                    tablet: 450.0,
                    desktop: 450.0,
                  ),
                  buttonStyle: ButtonThemeHelper.borderElevatedButtonStyle(context),
                  buttonTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                    color: Theme.of(context).customColors.fillColor,
                  ),
                  onPressed: () async {
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
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  static double getWidgetWidth(BuildContext context) {
    if (ResponsiveHelper.isDesktop(context)) {
      return 800;
    } else if (ResponsiveHelper.isTablet(context)) {
      return 650;
    } else {
      return double.infinity;
    }
  }
}
