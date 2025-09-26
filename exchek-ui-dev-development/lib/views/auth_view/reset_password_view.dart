import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/widgets/common_widget/password_checklist_item.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

  double fieldTitleSize(BuildContext context) {
    return ResponsiveHelper.isBigScreen(context) ? 16.0 : (ResponsiveHelper.isWebAndIsNotMobile(context) ? 13.0 : 16.0);
  }

  double linkFontSize(BuildContext context) {
    return ResponsiveHelper.isBigScreen(context)
        ? ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 15)
        : ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 12, desktop: 12);
  }

  double getSpacing(BuildContext context) {
    return ResponsiveHelper.isBigScreen(context) ? 24.0 : 18.0;
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

  double validationStyle(BuildContext context) {
    return ResponsiveHelper.isBigScreen(context) ? 14.0 : 12.0;
  }

  double validationIconSize(BuildContext context) {
    return ResponsiveHelper.isBigScreen(context) ? 20.0 : 16.0;
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
                      child: Container(
                        margin: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
                        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isBigScreen(context) ? 25 : 14),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildAppLogo(context),
                            buildSizedBoxH(logoAndContentPadding(context)),
                            _buildResetPasswordContent(context, state),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          listener: (context, state) {
            if (state.isResetPasswordSuccess) {
              if (kIsWeb) {
                GoRouter.of(context).replace(RouteUri.loginRoute);
              } else {
                GoRouter.of(context).pushReplacement(RouteUri.loginRoute);
              }
            }
          },
        ),
      ),
    );
  }

  Widget _buildResetPasswordContent(BuildContext context, AuthState state) {
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
              : null,
      child: Form(
        key: state.resetPasswordFormKey,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isWebAndIsNotMobile(context) ? 20 : 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (ResponsiveHelper.isWebAndIsNotMobile(context)) buildSizedBoxH(20),
              _buildResetPasswordHeader(context, state),
              buildSizedBoxH(20.0),
              _buildNewPasswordField(context, state),
              AnimatedBuilder(
                animation: state.resetNewPasswordController,
                builder: (context, _) {
                  final currentPassword = state.resetNewPasswordController.text;
                  return currentPassword.isNotEmpty
                      ? Column(
                        children: [
                          buildSizedBoxH(20.0),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: EdgeInsets.all(ResponsiveHelper.isBigScreen(context) ? 16 : 8),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final checklistItems = [
                                  PasswordChecklistItem(
                                    'One lowercase character',
                                    currentPassword.contains(RegExp(r'[a-z]')),
                                    fontsize: validationStyle(context),
                                    iconSize: validationIconSize(context),
                                  ),
                                  PasswordChecklistItem(
                                    'One number',
                                    currentPassword.contains(RegExp(r'\d')),
                                    fontsize: validationStyle(context),
                                    iconSize: validationIconSize(context),
                                  ),
                                  PasswordChecklistItem(
                                    'One uppercase character',
                                    currentPassword.contains(RegExp(r'[A-Z]')),
                                    fontsize: validationStyle(context),
                                    iconSize: validationIconSize(context),
                                  ),
                                  PasswordChecklistItem(
                                    'One special character',
                                    currentPassword.contains(RegExp(r'[^A-Za-z0-9]')),
                                    fontsize: validationStyle(context),
                                    iconSize: validationIconSize(context),
                                  ),
                                  PasswordChecklistItem(
                                    '8 characters minimum',
                                    currentPassword.length >= 8,
                                    fontsize: validationStyle(context),
                                    iconSize: validationIconSize(context),
                                  ),
                                ];
                                if (!kIsWeb) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:
                                        checklistItems
                                            .map(
                                              (item) => Padding(padding: const EdgeInsets.only(bottom: 5), child: item),
                                            )
                                            .toList(),
                                  );
                                } else {
                                  return Wrap(
                                    spacing: ResponsiveHelper.isBigScreen(context) ? 16 : 8,
                                    runSpacing: 10,
                                    children:
                                        checklistItems
                                            .map(
                                              (item) => SizedBox(width: (constraints.maxWidth - 16) / 2, child: item),
                                            )
                                            .toList(),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      )
                      : SizedBox.shrink();
                },
              ),

              buildSizedBoxH(getSpacing(context)),
              _buildConfirmPasswordField(context, state),
              buildSizedBoxH(getSpacing(context)),
              _buildBackToLoginLink(context),
              buildSizedBoxH(getSpacing(context)),
              _buildResetPasswordButton(context),
              if (ResponsiveHelper.isWebAndIsNotMobile(context)) buildSizedBoxH(30),
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

  Widget _buildResetPasswordHeader(BuildContext context, AuthState state) {
    return Column(
      spacing: 16.0,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          Lang.of(context).lbl_reset_password,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: headerFontSize(context),
            fontWeight: FontWeight.w600,
            height: 1.0,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          Lang.of(context).lbl_create_password_content,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize:
                ResponsiveHelper.isBigScreen(context)
                    ? ResponsiveHelper.getFontSize(context, mobile: 18, tablet: 18, desktop: 18)
                    : ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 16, desktop: 16),
            color: Theme.of(context).customColors.secondaryTextColor,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.18,
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildNewPasswordField(BuildContext context, AuthState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_new_password,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontSize: fieldTitleSize(context), fontWeight: FontWeight.w400),
        ),
        buildSizedBoxH(8.0),
        CustomTextInputField(
          context: context,
          type: InputType.password,
          obscuredText: state.isNewPasswordObscured,
          controller: state.resetNewPasswordController,
          textInputAction: TextInputAction.next,
          // validator: ExchekValidations.validatePassword,
          contentPadding: EdgeInsets.symmetric(vertical: getFieldVerticalPadidng(context), horizontal: 20.0),
          suffixIcon: Container(
            padding: EdgeInsets.only(right: 14.0),
            color: Colors.transparent,
            alignment: Alignment.center,
            child: CustomImageView(
              imagePath:
                  state.isNewPasswordObscured
                      ? Assets.images.svgs.icons.icEyeSlash.path
                      : Assets.images.svgs.icons.icEye.path,
              height: 15.0,
              width: 20.0,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                BlocProvider.of<AuthBloc>(
                  context,
                ).add(ResetNewPasswordChangeVisibility(obscuredText: !(state.isNewPasswordObscured)));
              },
            ),
          ),
          contextMenuBuilder: (BuildContext context, EditableTextState editableTextState) {
            return AdaptiveTextSelectionToolbar.buttonItems(
              anchors: editableTextState.contextMenuAnchors,
              buttonItems:
                  editableTextState.contextMenuButtonItems
                      .where((item) => item.type != ContextMenuButtonType.paste)
                      .toList(),
            );
          },
          inputFormatters: [NoPasteFormatter()],
          isDense: true,
          textStyleFontSize: fieldTextFontSize(context),
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField(BuildContext context, AuthState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_confirm_password,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontSize: fieldTitleSize(context), fontWeight: FontWeight.w400),
        ),
        buildSizedBoxH(8.0),
        CustomTextInputField(
          context: context,
          type: InputType.password,
          obscuredText: state.isConfirmPasswordObscured,
          controller: state.resetConfirmPasswordController,
          textInputAction: TextInputAction.done,
          validator:
              (value) => ExchekValidations.validateConfirmPassword(
                state.resetNewPasswordController.text,
                state.resetConfirmPasswordController?.text,
              ),
          shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForConfirmPasswordValidation,
          contentPadding: EdgeInsets.symmetric(vertical: getFieldVerticalPadidng(context), horizontal: 14.0),
          suffixIcon: Container(
            padding: EdgeInsets.only(right: 14.0),
            color: Colors.transparent,
            alignment: Alignment.center,
            child: CustomImageView(
              imagePath:
                  state.isConfirmPasswordObscured
                      ? Assets.images.svgs.icons.icEyeSlash.path
                      : Assets.images.svgs.icons.icEye.path,
              height: 15.0,
              width: 20.0,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                BlocProvider.of<AuthBloc>(
                  context,
                ).add(ResetConfirmPasswordChangeVisibility(obscuredText: !(state.isConfirmPasswordObscured)));
              },
            ),
          ),
          onFieldSubmitted: (value) {
            FocusManager.instance.primaryFocus?.unfocus();
            if (state.resetPasswordFormKey.currentState!.validate()) {
              context.read<AuthBloc>().add(
                ResetPasswordSubmitted(
                  password: state.resetNewPasswordController.text,
                  confirmpassword: state.resetConfirmPasswordController?.text ?? '',
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
          inputFormatters: [NoPasteFormatter()],
          autovalidateMode: AutovalidateMode.onUserInteraction,
          isDense: true,
          textStyleFontSize: fieldTextFontSize(context),
        ),
      ],
    );
  }

  Widget _buildBackToLoginLink(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        mouseCursor: SystemMouseCursors.click,
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
    );
  }

  Widget _buildResetPasswordButton(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return AnimatedBuilder(
          animation: Listenable.merge([state.resetNewPasswordController, state.resetConfirmPasswordController]),
          builder: (context, _) {
            final isDisabled =
                state.isResetPasswordLoading ||
                ((state.resetNewPasswordController.text.isEmpty) ||
                    ExchekValidations.validateConfirmPassword(
                          state.resetNewPasswordController.text,
                          state.resetConfirmPasswordController?.text.toString(),
                        ) !=
                        null);
            return SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                isDisabled: isDisabled,
                isLoading: state.isResetPasswordLoading,
                text: Lang.of(context).lbl_reset_password,
                onPressed: () async {
                  if (state.resetPasswordFormKey.currentState!.validate()) {
                    context.read<AuthBloc>().add(
                      ResetPasswordSubmitted(
                        password: state.resetNewPasswordController.text,
                        confirmpassword: state.resetConfirmPasswordController?.text ?? '',
                      ),
                    );
                  }
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
      },
    );
  }
}

// class NoPasteFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
//     // If the new value is longer by more than 1 character in a single step, assume paste and block it
//     if ((newValue.text.length - oldValue.text.length) > 1) {
//       return oldValue;
//     }
//     return newValue;
//   }
// }

class NoPasteFormatter extends TextInputFormatter {
  final String separator;

  NoPasteFormatter({this.separator = ' '});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    int allowedStep = separator.length + 1;
    if ((newValue.text.length - oldValue.text.length) > allowedStep) {
      return oldValue;
    }
    return newValue;
  }
}
