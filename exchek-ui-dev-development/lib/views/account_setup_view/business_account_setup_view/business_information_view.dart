import 'package:exchek/core/utils/exports.dart';

class BusinessInformationView extends StatelessWidget {
  const BusinessInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
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
                      title: Lang.of(context).lbl_verify_business_information,
                      description: Lang.of(context).lbl_verification_otp_information,
                    ),
                    buildSizedBoxH(20.0),
                    Form(
                      key: state.formKey,
                      child: Column(
                        children: [
                          _buildBusinessLegalNameField(context, state),
                          buildSizedBoxH(24.0),
                          _buildDBAField(context, state),
                          buildSizedBoxH(24.0),
                          _buildProfessionalWebsiteURLField(context, state),
                          buildSizedBoxH(24.0),
                          _buildPhoneTextField(context, state),
                        ],
                      ),
                    ),

                    if (state.isBusinessInfoOtpSent == false) ...[buildSizedBoxH(30.0), _buildSendOTPButton()],
                    if (state.isBusinessInfoOtpSent == true && state.isVerifyBusinessRegisterdInfo == false) ...[
                      buildSizedBoxH(24.0),
                      _buildOTPField(context),
                    ],
                    if (state.isBusinessInfoOtpSent) ...[buildSizedBoxH(30.0), _buildConfirmAndContinueButton()],
                    buildSizedBoxH(30.0),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDBAField(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              Lang.of(context).lbl_dba_title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
                fontWeight: FontWeight.w400,
                height: 1.22,
              ),
            ),
            const SizedBox(width: 6),
            Tooltip(
              constraints: BoxConstraints(maxWidth: 300.0),
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Theme.of(context).customColors.blackColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
              textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: ResponsiveHelper.getFontSize(context, mobile: 12.0, tablet: 14.0, desktop: 14.0),
                fontWeight: FontWeight.w400,
                color: Theme.of(context).customColors.fillColor,
              ),
              message:
                  '''DBA (Doing Business As) is a short, customer-facing business name (max 16 characters). This name will appear on your customer's payment statement when we process payments on your behalf. Use letters, numbers and normal characters only — special characters like <, >, ' or " are not allowed.''',
              child: CustomImageView(imagePath: Assets.images.svgs.icons.icInfoCircle.path, height: 12.0, width: 12.0),
            ),
          ],
        ),
        buildSizedBoxH(8.0),
        CustomTextInputField(
          context: context,
          type: InputType.text,
          controller: state.dbaController,
          // hintLabel: 'Enter DBA (Doing Business As)',
          textInputAction: TextInputAction.next,
          maxLength: 16,
          enabled: state.isBusinessInfoOtpSent != true,
          validator: (value) => ExchekValidations.validateDBA(value, isOptional: false),
        ),
      ],
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
        buildSizedBoxH(14.0),
        Text(
          description,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
            fontWeight: FontWeight.w400,
            color: Theme.of(context).customColors.secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildBusinessLegalNameField(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_business_legal_name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
            fontWeight: FontWeight.w400,
            height: 1.22,
          ),
        ),
        buildSizedBoxH(8.0),
        CustomTextInputField(
          context: context,
          type: InputType.name,
          controller: state.businessLegalNameController,
          textInputAction: TextInputAction.next,
          enabled: state.isBusinessInfoOtpSent != true,
          suffixText: true,
          validator: ExchekValidations.validateBusinessName,
        ),
      ],
    );
  }

  Widget _buildProfessionalWebsiteURLField(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_professional_website_URL_optional,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
            fontWeight: FontWeight.w400,
            height: 1.22,
          ),
        ),
        buildSizedBoxH(8.0),
        CustomTextInputField(
          context: context,
          type: InputType.text,
          controller: state.professionalWebsiteUrl,
          enabled: state.isBusinessInfoOtpSent != true,
          textInputAction: TextInputAction.next,
          suffixText: true,
          validator: (value) => ExchekValidations.validateWebsite(value, isOptional: true),
        ),
      ],
    );
  }

  Widget _buildPhoneTextField(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              Lang.of(context).lbl_mobile_number,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
                fontWeight: FontWeight.w400,
              ),
            ),
            Spacer(),
            if (state.isBusinessInfoOtpSent == true && state.isVerifyBusinessRegisterdInfo == false)
              Align(alignment: Alignment.centerRight, child: _buildChangeMobileNumberLink(context, state)),
          ],
        ),
        buildSizedBoxH(8.0),
        state.isVerifyBusinessRegisterdInfo == true
            ? CommanVerifiedInfoBox(value: "${Lang.of(context).lbl_india_code} ${state.phoneController.text}")
            : CustomTextInputField(
              context: context,
              type: InputType.digits,
              hintLabel: Lang.of(context).lbl_enter_mobile_number,
              controller: state.phoneController,
              focusNode: state.phoneFocusNode,
              textInputAction: TextInputAction.next,
              boxConstraints: BoxConstraints(minWidth: ResponsiveHelper.isMobile(context) ? 70.0 : 70.0),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              enabled: state.isBusinessInfoOtpSent != true,
              prefixIcon: Container(
                margin: EdgeInsets.only(right: 10.0),
                decoration: BoxDecoration(
                  border: Border(right: BorderSide(color: Theme.of(context).customColors.textdarkcolor!)),
                ),
                alignment: Alignment.center,
                child: Text(
                  Lang.of(context).lbl_india_code,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 16),
                    color: Theme.of(context).customColors.secondaryTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              maxLength: 10,
              validator: ExchekValidations.validateMobileNumber,
              shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForMobileNumberValidation,
              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
              onFieldSubmitted: (value) {
                FocusManager.instance.primaryFocus?.unfocus();
                if (state.formKey.currentState!.validate()) {
                  BlocProvider.of<BusinessAccountSetupBloc>(context).add(BusinessSendOtpPressed());
                }
              },
            ),
      ],
    );
  }

  // NEW: Change Mobile Number Link Widget
  Widget _buildChangeMobileNumberLink(BuildContext context, BusinessAccountSetupState state) {
    return Align(
      alignment: Alignment.centerRight,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            // Clear the OTP field
            state.otpController.clear();

            // Trigger event to reset OTP state and stop timer
            BlocProvider.of<BusinessAccountSetupBloc>(context).add((ChangeMobileNumberPressed()));

            // Focus and position cursor at the end with multiple attempts
            void setCursorToEnd() {
              if (context.mounted) {
                FocusScope.of(context).requestFocus(state.phoneFocusNode);
                // Move cursor to the end of the text
                final textLength = state.phoneController.text.length;
                state.phoneController.selection = TextSelection.fromPosition(TextPosition(offset: textLength));
              }
            }

            // Try multiple times to ensure cursor positioning works
            WidgetsBinding.instance.addPostFrameCallback((_) => setCursorToEnd());
            Future.delayed(Duration(milliseconds: 50), setCursorToEnd);
            Future.delayed(Duration(milliseconds: 100), setCursorToEnd);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              "Edit Number",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
                color: Theme.of(context).customColors.greenColor,
                fontWeight: FontWeight.w500,
                // decoration: TextDecoration.underline,
                decorationColor: Theme.of(context).customColors.greenColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOTPField(BuildContext context) {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Lang.of(context).lbl_one_time_password,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
                fontWeight: FontWeight.w400,
                height: 1.22,
              ),
            ),
            buildSizedBoxH(8.0),
            CustomTextInputField(
              context: context,
              type: InputType.digits,
              controller: state.otpController,
              textInputAction: TextInputAction.done,
              validator: ExchekValidations.validateOTP,
              // enabled: state.isBusinessInfoOtpSent != true,
              suffixText: true,
              suffixIcon: ValueListenableBuilder(
                valueListenable: state.phoneController,
                builder: (context, _, __) {
                  return GestureDetector(
                    onTap:
                        state.otpRemainingTime > 0 || (state.phoneController.text.length != 10)
                            ? null
                            : () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              BlocProvider.of<BusinessAccountSetupBloc>(context).add(BusinessSendOtpPressed());
                            },
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
                      child: Text(
                        state.isOtpTimerRunning
                            ? '${Lang.of(context).lbl_resend_otp_in} ${formatSecondsToMMSS(state.otpRemainingTime)}sec'
                            : Lang.of(context).lbl_resend_OTP,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              state.isOtpTimerRunning || (state.phoneController.text.length != 10)
                                  ? Theme.of(context).customColors.textdarkcolor?.withValues(alpha: 0.5)
                                  : Theme.of(context).customColors.greenColor,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
              maxLength: 6,
              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
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
                FocusManager.instance.primaryFocus?.unfocus();
                if (state.formKey.currentState?.validate() ?? false) {
                  final bloc = context.read<BusinessAccountSetupBloc>();
                  bloc.add(ValidateBusinessOtp(phoneNumber: state.phoneController.text, otp: state.otpController.text));
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildConfirmAndContinueButton() {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        return Align(
          alignment: Alignment.centerRight,
          child: AnimatedBuilder(
            animation: Listenable.merge([
              state.businessLegalNameController,
              state.professionalWebsiteUrl,
              state.phoneController,
              state.otpController,
            ]),
            builder: (context, _) {
              final isFormValid =
                  state.businessLegalNameController.text.isNotEmpty &&
                  state.phoneController.text.isNotEmpty &&
                  state.otpController.text.isNotEmpty;

              return CustomElevatedButton(
                isLoading: state.isBusinessOtpValidating,
                isShowTooltip: true,
                tooltipMessage: Lang.of(context).lbl_tooltip_text,
                text: Lang.of(context).lbl_confirm_and_continue,
                buttonTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16.0,
                  color: Theme.of(context).customColors.fillColor,
                  fontWeight: FontWeight.w500,
                ),
                borderRadius: 8.0,
                width: ResponsiveHelper.isMobile(context) ? double.maxFinite : 250,
                isDisabled: !isFormValid && state.isVerifyBusinessRegisterdInfo == false,
                onPressed:
                    state.isVerifyBusinessRegisterdInfo == true
                        ? () {
                          final index = state.currentStep.index;
                          if (index < BusinessAccountSetupSteps.values.length - 1) {
                            final index = state.currentStep.index;
                            context.read<BusinessAccountSetupBloc>().add(
                              StepChanged(BusinessAccountSetupSteps.values[index + 1]),
                            );
                          }
                        }
                        : isFormValid
                        ? () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (state.formKey.currentState!.validate()) {
                            final bloc = context.read<BusinessAccountSetupBloc>();
                            bloc.add(
                              ValidateBusinessOtp(
                                phoneNumber: state.phoneController.text,
                                otp: state.otpController.text,
                              ),
                            );
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

  Widget _buildSendOTPButton() {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        return Align(
          alignment: Alignment.centerRight,
          child: AnimatedBuilder(
            animation: Listenable.merge([state.phoneController]),
            builder: (context, _) {
              final isDisable =
                  state.phoneController.text.length != 10 ||
                  ExchekValidations.validateMobileNumber(state.phoneController.text) != null;
              return CustomElevatedButton(
                isShowTooltip: true,
                tooltipMessage: Lang.of(context).lbl_tooltip_text,
                text: Lang.of(context).lbl_send_otp,
                buttonTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16.0,
                  color: Theme.of(context).customColors.fillColor,
                  fontWeight: FontWeight.w500,
                ),
                borderRadius: 8.0,
                width: ResponsiveHelper.isMobile(context) ? double.maxFinite : 140,
                isDisabled: isDisable,
                isLoading: state.isSendOtpLoading,
                onPressed:
                    isDisable
                        ? null
                        : () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (state.formKey.currentState!.validate()) {
                            BlocProvider.of<BusinessAccountSetupBloc>(context).add(BusinessSendOtpPressed());
                          }
                        },
              );
            },
          ),
        );
      },
    );
  }

  String formatSecondsToMMSS(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }
}
