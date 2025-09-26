import 'package:exchek/core/utils/exports.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class PlatformTermsOfUseView extends StatelessWidget {
  const PlatformTermsOfUseView({super.key});

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<AuthBloc>();
      if (bloc.state.signupEmailIdController?.text.isEmpty ?? true) {
        context.replace(RouteUri.loginRoute);
        context.read<AuthBloc>().add(ClearLoginDataManuallyEvent());
      }

      if (bloc.state.termsHtml == null && !bloc.state.isLoadingTerms) {
        bloc.add(LoadTermsAndConditions());
      }
    });

    return LandingPageScaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).customColors.fillColor,
      appBar:
          ResponsiveHelper.isWebAndIsNotMobile(context)
              ? null
              : ExchekAppBar(
                appBarContext: context,
                title: Lang.of(context).lbl_platform_terms_of_use,
                showCloseButton: false,
                centerTitle: true,
                elevation: 0.0,
                onBackPressed: () {
                  context.read<AuthBloc>().add(ClearSignupDataManuallyEvent());
                  if (kIsWeb) {
                    GoRouter.of(context).go(RouteUri.signupRoute);
                  } else {
                    GoRouter.of(context).pop();
                  }
                },
              ),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            // Retrieve email from local storage when view loads
            if (state.signupEmailIdController?.text.isEmpty ?? true) {
              Prefobj.preferences.get(Prefkeys.emailId).then((email) {
                if (email != null && email.isNotEmpty) {
                  state.signupEmailIdController?.text = email;
                }
              });
            }

            return Center(
              child:
                  ResponsiveHelper.isWebAndIsNotMobile(context)
                      ? ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                        child: SingleChildScrollView(
                          clipBehavior: Clip.none,
                          physics: BouncingScrollPhysics(),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: ResponsiveHelper.getMaxAuthFormWidth(context)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: ResponsiveHelper.isBigScreen(context) ? 25 : 14,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (ResponsiveHelper.isWebAndIsNotMobile(context))
                                      Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            _buildAppLogo(context),
                                            buildSizedBoxH(logoAndContentPadding(context)),
                                            _buildTermsOfUserContent(context, state),
                                          ],
                                        ),
                                      )
                                    else
                                      Expanded(child: _buildTermsOfUserContent(context, state)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      : Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: ResponsiveHelper.getMaxAuthFormWidth(context)),
                          child: Column(
                            spacing: 20.0,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (ResponsiveHelper.isWebAndIsNotMobile(context))
                                Center(
                                  child: Column(
                                    spacing: 20.0,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [_buildAppLogo(context), _buildTermsOfUserContent(context, state)],
                                  ),
                                )
                              else
                                Expanded(child: _buildTermsOfUserContent(context, state)),
                            ],
                          ),
                        ),
                      ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTermsOfUserContent(BuildContext context, AuthState state) {
    return Container(
      width: double.maxFinite,
      margin: ResponsiveHelper.getScreenMargin(context),
      padding: kIsWeb ? boxPadding(context) : EdgeInsets.zero,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (ResponsiveHelper.isWebAndIsNotMobile(context)) ...[_buildTermsOfUseHeader(context), buildSizedBoxH(20)],
          ResponsiveHelper.isWebAndIsNotMobile(context)
              ? Column(
                children: [
                  SizedBox(
                    height: ResponsiveHelper.isBigScreen(context) ? 400 : 300,
                    child: _buildTermsAndConditionText(context, state),
                  ),
                  buildSizedBoxH(20),
                ],
              )
              : Expanded(child: _buildTermsAndConditionText(context, state)),
          _buildBottomButtons(context, state),
        ],
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

  Widget _buildTermsOfUseHeader(BuildContext context) {
    return Text(
      Lang.of(context).lbl_platform_terms_of_use,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontSize: headerFontSize(context),
        fontWeight: FontWeight.w600,
        letterSpacing: 0.36,
      ),
    );
  }

  Widget _buildTermsAndConditionText(BuildContext context, AuthState state) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollEndNotification) {
          final maxScroll = scrollNotification.metrics.maxScrollExtent;
          final currentScroll = scrollNotification.metrics.pixels;
          const delta = 50.0;

          if (currentScroll >= maxScroll - delta) {
            context.read<AuthBloc>().add(const HasReadTermsEvent(hasRead: true));
          }
        }
        return true;
      },
      child: Builder(
        builder: (context) {
          if (state.isLoadingTerms) {
            return const Center(child: AppLoaderWidget());
          }

          if (state.termsError != null) {
            return Center(child: Text('${Lang.of(context).lbl_error_loading_terms} ${state.termsError}'));
          }

          return ResponsiveHelper.isWebAndIsNotMobile(context)
              ? RawScrollbar(
                controller: state.termsAndConditionScrollController,
                thumbColor: Theme.of(context).customColors.primaryColor,
                trackColor: Theme.of(context).customColors.borderColor,
                thumbVisibility: true,
                trackVisibility: true,
                radius: const Radius.circular(40.0),
                thickness: 11.0,
                minThumbLength: 80.0,
                trackRadius: const Radius.circular(40.0),
                child: SingleChildScrollView(
                  controller: state.termsAndConditionScrollController,
                  child: htmlContentWidget(state, context),
                ),
              )
              : htmlContentWidget(state, context);
        },
      ),
    );
  }

  SingleChildScrollView htmlContentWidget(AuthState state, BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: HtmlWidget(
        state.termsHtml ?? '',
        textStyle: TextStyle(fontSize: ResponsiveHelper.isBigScreen(context) ? 17.0 : 14.0, height: 1.5),
        buildAsync: false,
        enableCaching: false,
        onLoadingBuilder: (context, element, loadingProgress) {
          return const Center(child: AppLoaderWidget());
        },
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context, AuthState state) {
    return Align(
      alignment: Alignment.centerRight,
      child: CustomElevatedButton(
        height: buttonHeight(context),
        margin: EdgeInsets.all(kIsWeb ? 0 : 20.0),
        text: Lang.of(context).lbl_agree,
        width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 150 : double.maxFinite,
        isDisabled: !state.hasReadTerms,
        borderRadius: ResponsiveHelper.isWebAndIsNotMobile(context) ? 50.0 : 10.0,
        isLoading: state.issignupLoading,
        buttonTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: buttonFontSize(context),
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        onPressed:
            state.hasReadTerms
                ? () {
                  context.read<AuthBloc>().add(
                    TermsAndConditionSubmitted(
                      emailId: state.signupEmailIdController?.text.trim() ?? '',
                      context: context,
                    ),
                  );
                }
                : null,
      ),
    );
  }

  static EdgeInsets boxPadding(BuildContext context) {
    if (ResponsiveHelper.isDesktop(context)) {
      return EdgeInsets.symmetric(horizontal: 36, vertical: 30);
    } else if (ResponsiveHelper.isTablet(context)) {
      return EdgeInsets.symmetric(horizontal: 30, vertical: 30);
    } else {
      return EdgeInsets.symmetric(horizontal: 20, vertical: 30);
    }
  }
}
