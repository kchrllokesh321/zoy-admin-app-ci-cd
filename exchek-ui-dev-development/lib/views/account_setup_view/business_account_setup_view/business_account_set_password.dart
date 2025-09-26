import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/widgets/common_widget/password_checklist_item.dart';

class BusinessAccountSetPassword extends StatelessWidget {
  const BusinessAccountSetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      listener: (context, state) {
        if (state.isSignupSuccess == true) {
          if (kIsWeb) {
            context.replace(RouteUri.businessAccountSuccessViewRoute);
          } else {
            GoRouter.of(context).pushReplacement(RouteUri.businessAccountSuccessViewRoute);
          }

          BlocProvider.of<BusinessAccountSetupBloc>(context).add(ResetSignupSuccess());
        }
      },
      builder: (context, state) {
        return ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: ResponsiveHelper.getMaxTileWidth(context)),
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: ResponsiveHelper.isMobile(context) ? (kIsWeb ? 30.0 : 20) : 0.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSizedBoxH(20.0),
                    _buildSelectionTitleAndDescription(
                      context: context,
                      title: Lang.of(context).lbl_create_strong_password,
                      description: Lang.of(context).lbl_ensure_secure_account_access,
                    ),
                    buildSizedBoxH(30.0),
                    Form(
                      key: state.sePasswordFormKey,
                      child: Column(
                        children: [
                          _buildCreatePasswordField(context, state),
                          AnimatedBuilder(
                            animation: state.createPasswordController,
                            builder: (context, _) {
                              final currentPassword = state.createPasswordController.text;
                              return currentPassword.isNotEmpty
                                  ? Column(
                                    children: [
                                      buildSizedBoxH(24.0),
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        padding: const EdgeInsets.all(16),
                                        child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            final checklistItems = [
                                              PasswordChecklistItem(
                                                'One lowercase character',
                                                currentPassword.contains(RegExp(r'[a-z]')),
                                              ),
                                              PasswordChecklistItem(
                                                'One number',
                                                currentPassword.contains(RegExp(r'\d')),
                                              ),
                                              PasswordChecklistItem(
                                                'One uppercase character',
                                                currentPassword.contains(RegExp(r'[A-Z]')),
                                              ),
                                              PasswordChecklistItem(
                                                'One special character',
                                                currentPassword.contains(RegExp(r'[^A-Za-z0-9]')),
                                              ),
                                              PasswordChecklistItem(
                                                '8 characters minimum',
                                                currentPassword.length >= 8,
                                              ),
                                            ];
                                            if (!kIsWeb) {
                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children:
                                                    checklistItems
                                                        .map(
                                                          (item) => Padding(
                                                            padding: const EdgeInsets.only(bottom: 12),
                                                            child: item,
                                                          ),
                                                        )
                                                        .toList(),
                                              );
                                            } else {
                                              return Wrap(
                                                spacing: 16,
                                                runSpacing: 16,
                                                children:
                                                    checklistItems
                                                        .map(
                                                          (item) => SizedBox(
                                                            width: (constraints.maxWidth - 16) / 2,
                                                            child: item,
                                                          ),
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
                          buildSizedBoxH(24.0),

                          _buildConfirmPasswordField(context, state),
                        ],
                      ),
                    ),
                    buildSizedBoxH(30.0),
                    _buildSingupButton(),
                    buildSizedBoxH(kIsWeb ? 80.0 : 40.0),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectionTitleAndDescription({
    required BuildContext context,
    required String title,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 24, tablet: 30, desktop: 32),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.32,
          ),
        ),
        buildSizedBoxH(10.0),
        Text(
          description,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
            fontWeight: FontWeight.w500,
            color: Theme.of(context).customColors.secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildCreatePasswordField(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_create_password,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
            fontWeight: FontWeight.w400,
            height: 1.22,
          ),
        ),
        buildSizedBoxH(8.0),
        CustomTextInputField(
          context: context,
          type: InputType.password,
          obscuredText: state.isCreatePasswordObscure,
          controller: state.createPasswordController,
          textInputAction: TextInputAction.next,
          validator: ExchekValidations.validatePassword,
          shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForPasswordValidation,
          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
          suffixIcon: Container(
            padding: EdgeInsets.only(right: 14.0),
            color: Colors.transparent,
            alignment: Alignment.center,
            child: CustomImageView(
              imagePath:
                  state.isCreatePasswordObscure
                      ? Assets.images.svgs.icons.icEyeSlash.path
                      : Assets.images.svgs.icons.icEye.path,
              height: 17.0,
              width: 20.0,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                BlocProvider.of<BusinessAccountSetupBloc>(
                  context,
                ).add(ChangeCreatePasswordVisibility(obscuredText: !(state.isCreatePasswordObscure)));
              },
            ),
          ),
          contextMenuBuilder: customContextMenuBuilder,
          inputFormatters: [NoPasteFormatter()],
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_confirm_password,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
            fontWeight: FontWeight.w400,
          ),
        ),
        buildSizedBoxH(8.0),
        CustomTextInputField(
          context: context,
          type: InputType.password,
          obscuredText: state.isConfirmPasswordObscure,
          controller: state.confirmPasswordController,
          textInputAction: TextInputAction.next,
          validator: (value) {
            return ExchekValidations.validateConfirmPassword(state.createPasswordController.text, value);
          },
          shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForConfirmPasswordValidation,
          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
          suffixIcon: Container(
            padding: EdgeInsets.only(right: 14.0),
            color: Colors.transparent,
            alignment: Alignment.center,
            child: CustomImageView(
              imagePath:
                  state.isConfirmPasswordObscure
                      ? Assets.images.svgs.icons.icEyeSlash.path
                      : Assets.images.svgs.icons.icEye.path,
              height: 17.0,
              width: 20.0,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                BlocProvider.of<BusinessAccountSetupBloc>(
                  context,
                ).add(ChangeConfirmPasswordVisibility(obscuredText: !(state.isConfirmPasswordObscure)));
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
          onFieldSubmitted: (value) {
            final isFormValid =
                state.createPasswordController.text.isNotEmpty && state.confirmPasswordController.text.isNotEmpty;

            if (isFormValid) {
              if (state.sePasswordFormKey.currentState!.validate()) {
                BlocProvider.of<BusinessAccountSetupBloc>(context).add(BusinessAccountSignUpSubmitted());
              }
            }
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }

  Widget _buildSingupButton() {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        return Align(
          alignment: Alignment.centerRight,
          child: AnimatedBuilder(
            animation: Listenable.merge([state.createPasswordController, state.confirmPasswordController]),
            builder: (context, _) {
              final isFormValid =
                  state.createPasswordController.text.isNotEmpty &&
                  ExchekValidations.validateConfirmPassword(
                        state.createPasswordController.text,
                        state.confirmPasswordController.text,
                      ) ==
                      null;

              return CustomElevatedButton(
                isLoading: state.isSignupLoading ?? false,
                isShowTooltip: true,
                tooltipMessage: Lang.of(context).lbl_tooltip_text,
                text: Lang.of(context).lbl_sign_up,
                buttonTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: ResponsiveHelper.getFontSize(context, mobile: 16.0, tablet: 16.0, desktop: 18.0),
                  color: Theme.of(context).customColors.fillColor,
                  fontWeight: FontWeight.w500,
                ),
                borderRadius: 8.0,
                width: ResponsiveHelper.isMobile(context) ? double.maxFinite : 150,
                isDisabled: !isFormValid,
                onPressed:
                    isFormValid
                        ? () {
                          if (state.sePasswordFormKey.currentState!.validate()) {
                            BlocProvider.of<BusinessAccountSetupBloc>(context).add(BusinessAccountSignUpSubmitted());
                          }
                        }
                        : null,
              );
            },
          ),
        );
      },
    );
  }
}
