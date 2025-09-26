import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/viewmodels/account_setup_bloc/personal_account_setup_bloc/personal_account_setup_bloc.dart';

class PersonalLegalNameContactView extends StatelessWidget {
  const PersonalLegalNameContactView({super.key});

  bool _isTextInputFocused() {
    final focused = FocusManager.instance.primaryFocus;
    final ctx = focused?.context;
    if (ctx == null) return false;
    return ctx.widget is EditableText;
  }

  void _scrollBy(BuildContext context, double delta) {
    final controller = context.read<PersonalAccountSetupBloc>().state.scrollController;
    if (!controller.hasClients) return;
    final position = controller.position;
    final target = (position.pixels + delta).clamp(0.0, position.maxScrollExtent);
    controller.animateTo(target, duration: const Duration(milliseconds: 90), curve: Curves.easeOut);
  }

  KeyEventResult _onKeyEvent(BuildContext context, FocusNode node, KeyEvent event) {
    if (!kIsWeb) return KeyEventResult.ignored;
    if (_isTextInputFocused()) return KeyEventResult.ignored;

    const double lineDelta = 80.0;
    final bool isPressOrRepeat = event is KeyDownEvent || event is KeyRepeatEvent;

    if (isPressOrRepeat &&
        (event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.arrowUp)) {
      final delta = event.logicalKey == LogicalKeyboardKey.arrowDown ? lineDelta : -lineDelta;
      _scrollBy(context, delta);
      return KeyEventResult.handled;
    }

    if (event is KeyDownEvent &&
        (event.logicalKey == LogicalKeyboardKey.pageDown || event.logicalKey == LogicalKeyboardKey.pageUp)) {
      final controller = context.read<PersonalAccountSetupBloc>().state.scrollController;
      if (controller.hasClients) {
        final vp = controller.position.viewportDimension;
        _scrollBy(context, event.logicalKey == LogicalKeyboardKey.pageDown ? vp * 0.9 : -vp * 0.9);
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalAccountSetupBloc, PersonalAccountSetupState>(
      builder: (context, state) {
        return Focus(
          autofocus: kIsWeb,
          onKeyEvent: (node, event) => _onKeyEvent(context, node, event),
          child: ScrollConfiguration(
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
                        title: "Confirm your identity",
                        description:
                            "Official full name, phone number, and website required for verification and communication.",
                      ),
                      buildSizedBoxH(30.0),
                      Form(
                        key: state.personalInfoKey,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [__buildLegalFullNameField(context, state)],
                            ),
                            buildSizedBoxH(24.0),
                            // DBA (Doing Business As) - Optional for personal
                            _buildDBAField(context, state),
                            buildSizedBoxH(24.0),
                            _buildProfessionalWebsiteURLField(context, state),
                            buildSizedBoxH(24.0),
                            _buildPhoneTextField(context, state),
                          ],
                        ),
                      ),

                      // Show Send OTP button when OTP is not sent
                      if (state.isOTPSent != true) ...[buildSizedBoxH(30.0), _buildSendOTPButton()],
                      // Show OTP field when OTP is sent
                      if (state.isOTPSent == true && state.isVerifyPersonalRegisterdInfo == false) ...[
                        buildSizedBoxH(24.0),
                        _buildOTPField(context),
                      ],
                      if (state.isOTPSent == true) ...[buildSizedBoxH(30.0), _buildConfirmAndContinueButton()],

                      buildSizedBoxH(kIsWeb ? 80.0 : 40.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDBAField(BuildContext context, PersonalAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              Lang.of(context).lbl_dba_optional,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
                fontWeight: FontWeight.w400,
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
          controller: state.personalDbaController,
          textInputAction: TextInputAction.next,
          maxLength: 16,
          enabled: state.isOTPSent != true,
          validator: (value) => ExchekValidations.validateDBA(value, isOptional: true),
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

  Widget __buildLegalFullNameField(BuildContext context, PersonalAccountSetupState state) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main label
          Text(
            "Full Legal Name",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
              fontWeight: FontWeight.w500, // Slightly bolder to match design
            ),
          ),

          // Sh
          buildSizedBoxH(8.0), // Increased spacing
          // Text input field
          CustomTextInputField(
            context: context,
            type: InputType.name,
            controller: state.fullNameController,
            textInputAction: TextInputAction.next,
            suffixText: true,
            validator: ExchekValidations.validateRequired,
            enabled: state.isOTPSent != true,
            shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForRequiredValidation,
          ),

          buildSizedBoxH(6.0), // Spacing before helper text
          // Helper text with proper styling and color
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 14.0,
                color: Theme.of(context).customColors.greenColor, // Teal color as shown in design
              ),
              SizedBox(width: 4.0),
              Expanded(
                child: Text(
                  "This should match your PAN card name to ensure verification.",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: ResponsiveHelper.getFontSize(context, mobile: 12, tablet: 13, desktop: 14),
                    color: Colors.teal, // Teal color to match design
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalWebsiteURLField(BuildContext context, PersonalAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_professional_website_URL_optional,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
            fontWeight: FontWeight.w400,
          ),
        ),
        buildSizedBoxH(5.0),
        CustomTextInputField(
          context: context,
          type: InputType.text,
          controller: state.websiteController,
          textInputAction: TextInputAction.next,
          suffixText: true,
          validator: ExchekValidations.validateWebsite,
          enabled: state.isOTPSent != true,
        ),
      ],
    );
  }

  Widget _buildPhoneTextField(BuildContext context, PersonalAccountSetupState state) {
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
            if (state.isOTPSent == true && state.isVerifyPersonalRegisterdInfo == false)
              Align(alignment: Alignment.centerRight, child: _buildChangeMobileNumberLink(context, state)),
          ],
        ),

        buildSizedBoxH(5.0),
        state.isVerifyPersonalRegisterdInfo == true
            ? CommanVerifiedInfoBox(value: "${Lang.of(context).lbl_india_code} ${state.mobileController.text}")
            : CustomTextInputField(
              context: context,
              type: InputType.digits,
              focusNode: state.mobileNumberFocusNode,
              hintLabel: Lang.of(context).lbl_enter_mobile_number,
              controller: state.mobileController,
              textInputAction: TextInputAction.next,
              boxConstraints: BoxConstraints(minWidth: ResponsiveHelper.isMobile(context) ? 70.0 : 70.0),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              enabled: state.isOTPSent != true,
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
              onFieldSubmitted: (value) {
                FocusManager.instance.primaryFocus?.unfocus();
                if (state.personalInfoKey.currentState!.validate()) {
                  state.otpController.clear();
                  context.read<PersonalAccountSetupBloc>().add(SendOTP());
                }
              },
            ),
      ],
    );
  }

  Widget _buildChangeMobileNumberLink(BuildContext context, PersonalAccountSetupState state) {
    return Align(
      alignment: Alignment.centerRight,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            // Clear the OTP field
            state.otpController.clear();

            // Trigger event to reset OTP state and stop timer
            BlocProvider.of<PersonalAccountSetupBloc>(context).add(ChangePersonalMobileNumberPressed());

            // Focus and position cursor at the end with multiple attempts
            void setCursorToEnd() {
              if (context.mounted) {
                FocusScope.of(context).requestFocus(state.mobileNumberFocusNode);
                // Move cursor to the end of the text
                final textLength = state.mobileController.text.length;
                state.mobileController.selection = TextSelection.fromPosition(TextPosition(offset: textLength));
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
    return BlocBuilder<PersonalAccountSetupBloc, PersonalAccountSetupState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Lang.of(context).lbl_one_time_password,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
                fontWeight: FontWeight.w400,
              ),
            ),
            buildSizedBoxH(5.0),
            CustomTextInputField(
              context: context,
              type: InputType.digits,
              controller: state.otpController,
              textInputAction: TextInputAction.done,
              validator: ExchekValidations.validateOTP,
              suffixText: true,
              suffixIcon: ValueListenableBuilder(
                valueListenable: state.mobileController,
                builder: (context, _, __) {
                  final bool canResend = (state.timeLeft == 0) && state.mobileController.text.length == 10;
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: canResend ? () => BlocProvider.of<PersonalAccountSetupBloc>(context).add(SendOTP()) : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                        child: Text(
                          _getResendOTPText(context, state, canResend),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                canResend
                                    ? Theme.of(context).customColors.greenColor
                                    : Theme.of(context).customColors.textdarkcolor?.withValues(alpha: 0.5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              maxLength: 6,
              onFieldSubmitted: (value) {
                FocusManager.instance.primaryFocus?.unfocus();
                if (state.fullNameController.text.isNotEmpty &&
                    state.mobileController.text.length == 10 &&
                    state.otpController.text.length == 6) {
                  context.read<PersonalAccountSetupBloc>().add(ConfirmAndContinue());
                }
              },
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, NoPasteFormatter()],
              contextMenuBuilder: (BuildContext context, EditableTextState editableTextState) {
                return AdaptiveTextSelectionToolbar.buttonItems(
                  anchors: editableTextState.contextMenuAnchors,
                  buttonItems:
                      editableTextState.contextMenuButtonItems
                          .where((item) => item.type != ContextMenuButtonType.paste)
                          .toList(),
                );
              },
            ),
          ],
        );
      },
    );
  }

  String _getResendOTPText(BuildContext context, PersonalAccountSetupState state, bool canResend) {
    if (canResend) {
      return Lang.of(context).lbl_resend_OTP;
    } else if (state.timeLeft > 0) {
      return '${Lang.of(context).lbl_resend_otp_in} ${formatSecondsToMMSS(state.timeLeft)}sec';
    } else {
      return Lang.of(context).lbl_resend_OTP;
    }
  }

  Widget _buildConfirmAndContinueButton() {
    return BlocBuilder<PersonalAccountSetupBloc, PersonalAccountSetupState>(
      builder: (context, state) {
        return Align(
          alignment: Alignment.centerRight,
          child: AnimatedBuilder(
            animation: Listenable.merge([state.fullNameController, state.mobileController, state.otpController]),
            builder: (context, _) {
              final isFormValid =
                  state.fullNameController.text.isNotEmpty &&
                  state.mobileController.text.length == 10 &&
                  state.otpController.text.length == 6;

              return CustomElevatedButton(
                isShowTooltip: true,
                tooltipMessage: Lang.of(context).lbl_tooltip_text,
                text: Lang.of(context).lbl_confirm_and_continue,
                buttonTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16.0,
                  color: Theme.of(context).customColors.fillColor,
                  fontWeight: FontWeight.w500,
                ),
                isLoading: state.isLoading,
                borderRadius: 8.0,
                width: ResponsiveHelper.isMobile(context) ? double.maxFinite : 250,
                isDisabled: !isFormValid && state.isVerifyPersonalRegisterdInfo == false,
                onPressed:
                    state.isVerifyPersonalRegisterdInfo == true
                        ? () {
                          final index = state.currentStep.index;
                          if (index < PersonalAccountSetupSteps.values.length - 1) {
                            context.read<PersonalAccountSetupBloc>().add(
                              PersonalInfoStepChanged(PersonalAccountSetupSteps.values[index + 1]),
                            );
                          }
                        }
                        : isFormValid
                        ? () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (state.personalInfoKey.currentState?.validate() ?? false) {
                            final bloc = context.read<PersonalAccountSetupBloc>();
                            bloc.add(ConfirmAndContinue());
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
    return BlocBuilder<PersonalAccountSetupBloc, PersonalAccountSetupState>(
      builder: (context, state) {
        return Align(
          alignment: Alignment.centerRight,
          child: AnimatedBuilder(
            animation: Listenable.merge([state.mobileController]),
            builder: (context, _) {
              final bool isDisabled =
                  state.mobileController.text.length != 10 ||
                  ExchekValidations.validateMobileNumber(state.mobileController.text) != null;

              return CustomElevatedButton(
                isShowTooltip: true,
                tooltipMessage: Lang.of(context).lbl_tooltip_text,
                text: Lang.of(context).lbl_request_OTP,
                buttonTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16.0,
                  color: Theme.of(context).customColors.fillColor,
                  fontWeight: FontWeight.w500,
                ),
                isLoading: state.isLoading,
                borderRadius: 8.0,
                width: ResponsiveHelper.isMobile(context) ? double.maxFinite : 140,
                isDisabled: isDisabled,
                onPressed:
                    isDisabled
                        ? null
                        : () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          state.otpController.clear();
                          if (state.personalInfoKey.currentState!.validate()) {
                            context.read<PersonalAccountSetupBloc>().add(SendOTP());
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
