import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/widgets/account_setup_widgets/aadhar_upload_note.dart';
import 'package:exchek/widgets/account_setup_widgets/captcha_image.dart';

class ProprietorAadharVerificationView extends StatelessWidget {
  const ProprietorAadharVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        return ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: ResponsiveHelper.isWebAndIsNotMobile(context) ? 50 : 20),
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
                      title: "Sole Proprietor Aadhaar",
                      description:
                          "Enter the Proprietor’s Aadhaar number to verify identity through OTP. You will also need to upload a copy of the Aadhaar card as proof for KYC compliance.",
                    ),
                    buildSizedBoxH(30.0),
                    if (state.isProprietorAadharVerified == false)
                      _buildIsNotAadharVerify(context, state)
                    else
                      _buildIsAadharVerify(context, state),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIsAadharVerify(BuildContext context, BusinessAccountSetupState state) {
    return Form(
      key: state.proprietorAadharVerificationFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVerifyProprietorAadharNumber(context, state),
          buildSizedBoxH(24.0),
          _uolpadAadhaarTitle(context),
          buildSizedBoxH(24.0),
          UploadNote(notes: [Lang.of(context).lbl_note_1, Lang.of(context).lbl_note_2]),
          buildSizedBoxH(24.0),
          _buildUploadAddharCard(context),
          buildSizedBoxH(30.0),
          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _uolpadAadhaarTitle(BuildContext context) {
    return Text(
      Lang.of(context).lbl_upload_aadhar_card,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontSize: ResponsiveHelper.getFontSize(context, mobile: 28, tablet: 30, desktop: 32),
        fontWeight: FontWeight.w600,
        letterSpacing: 0.32,
      ),
    );
  }

  Widget _buildIsNotAadharVerify(BuildContext context, BusinessAccountSetupState state) {
    return Form(
      key: state.proprietorAadharVerificationFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  "Proprietor Aadhaar Number",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
                    fontWeight: FontWeight.w400,
                    height: 1.22,
                  ),
                ),
              ),
              if (state.isProprietorCaptchaSend || state.isProprietorOtpSent)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: InkWell(
                    mouseCursor: SystemMouseCursors.click,
                    onTap: () {
                      // Store original Aadhaar number before enabling edit
                      context.read<BusinessAccountSetupBloc>().add(
                        BusinessStoreOriginalProprietorAadharNumber(state.proprietorAadharNumberController.text),
                      );
                      TextFieldUtils.focusAndMoveCursorToEnd(
                        context: context,
                        focusNode: state.proprietorAadharNumberFocusNode,
                        controller: state.proprietorAadharNumberController,
                      );

                      // Make Aadhaar editable again and hide captcha/otp
                      context.read<BusinessAccountSetupBloc>().add(const ProprietorEnableAadharEdit());
                    },
                    child: Text(
                      Lang.of(context).lbl_edit,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
                        fontWeight: FontWeight.w400,
                        height: 1.22,
                        color: Theme.of(context).customColors.greenColor,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          buildSizedBoxH(8.0),
          _buildProprietorAadharNumberField(context, state),
          if (!state.isProprietorCaptchaSend && !state.isProprietorOtpSent) buildSizedBoxH(20),
          if (!state.isProprietorCaptchaSend && !state.isProprietorOtpSent) _buildVerifyAadharButton(context, state),
          if (state.isProprietorCaptchaSend) ...[
            buildSizedBoxH(24.0),
            Builder(
              builder: (context) {
                if (state.proprietorCaptchaImage != null) {
                  return Column(
                    children: [
                      Row(
                        spacing: 20.0,
                        children: [
                          Base64CaptchaField(base64Image: state.proprietorCaptchaImage ?? ''),
                          AbsorbPointer(
                            absorbing: state.isProprietorOtpSent,
                            child: Opacity(
                              opacity: state.isProprietorOtpSent ? 0.5 : 1.0,
                              child: CustomImageView(
                                imagePath: Assets.images.svgs.icons.icRefresh.path,
                                height: 40.0,
                                width: 40.0,
                                onTap: () async {
                                  context.read<BusinessAccountSetupBloc>().add(ProprietorReCaptchaSend());
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      buildSizedBoxH(24.0),
                      _buildCaptchaField(context),
                      if (!state.isProprietorOtpSent) ...[buildSizedBoxH(24.0), _buildSendOTPButton(context, state)],
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
          if (state.isProprietorOtpSent) ...[
            buildSizedBoxH(24.0),
            _buildOTPField(context),
            if (state.proprietorIsAadharOTPInvalidate != null) ...[
              buildSizedBoxH(10),
              Text(
                state.proprietorIsAadharOTPInvalidate ?? '',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xffFF5D5F),
                ),
              ),
            ],
            buildSizedBoxH(30.0),
            _buildVerifyButton(context, state),
          ],
        ],
      ),
    );
  }

  Widget _buildCaptchaField(BuildContext context) {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter Captcha",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
                    fontWeight: FontWeight.w400,
                    height: 1.22,
                  ),
                ),
                buildSizedBoxH(8.0),
                AbsorbPointer(
                  absorbing: state.isProprietorOtpSent,
                  child: CustomTextInputField(
                    context: context,
                    type: InputType.text,
                    controller: state.proprietorCaptchaInputController,
                    textInputAction: TextInputAction.done,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
                    onFieldSubmitted:
                        state.isProprietorAadharVerifiedLoading == true
                            ? null
                            : (value) async {
                              final isCaptchaValid = state.proprietorCaptchaInputController.text.isNotEmpty;
                              if (isCaptchaValid) {
                                final sessionId = await Prefobj.preferences.get(Prefkeys.sessionId) ?? '';
                                FocusManager.instance.primaryFocus?.unfocus();
                                context.read<BusinessAccountSetupBloc>().add(
                                  ProprietorSendAadharOtp(
                                    aadhar: state.proprietorAadharNumberController.text.trim(),
                                    captcha: state.proprietorCaptchaInputController.text.trim(),
                                    sessionId: sessionId,
                                  ),
                                );
                              }
                            },
                    validator: ExchekValidations.validateRequired,
                    shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForRequiredValidation,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // Using common validation message checker from ExchekValidations

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
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 28, tablet: 30, desktop: 32),
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

  Widget _buildProprietorAadharNumberField(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title is in header row
        AbsorbPointer(
          absorbing: state.isProprietorCaptchaSend,
          child: CustomTextInputField(
            focusNode: state.proprietorAadharNumberFocusNode,
            context: context,
            type: InputType.digits,
            controller: state.proprietorAadharNumberController,
            maxLength: 14,
            textInputAction: TextInputAction.done,
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              GroupedInputFormatter(groupSizes: [4, 4, 4], separator: '-', digitsOnly: true),
              NoPasteFormatter(),
            ],
            validator: ExchekValidations.validateAadhaar,
            shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForAadhaarValidation,
            onChanged: (value) {
              context.read<BusinessAccountSetupBloc>().add(ProprietorAadharNumberChanged(value));
              // Mark data as changed for proprietor aadhar only if value differs from original
              if (value != state.originalProprietorAadharNumber) {
                context.read<BusinessAccountSetupBloc>().add(MarkProprietorAadharDataChanged());
              }
            },
            onFieldSubmitted: (value) {
              final isValidAadhar =
                  ExchekValidations.validateAadhaar(
                    state.proprietorAadharNumberController.text.replaceAll("-", "").trim(),
                  ) ==
                  null;
              if (isValidAadhar) {
                context.read<BusinessAccountSetupBloc>().add(ProprietorCaptchaSend());
              }
            },
            contextMenuBuilder: customContextMenuBuilder,
          ),
        ),
      ],
    );
  }

  Widget _buildSendOTPButton(BuildContext context, BusinessAccountSetupState state) {
    return Align(
      alignment: Alignment.centerRight,
      child: AnimatedBuilder(
        animation: Listenable.merge([state.proprietorCaptchaInputController]),
        builder: (context, child) {
          final isValidAadhar = state.proprietorCaptchaInputController.text.isNotEmpty;
          return CustomElevatedButton(
            text: Lang.of(context).lbl_request_OTP,
            width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 150 : double.maxFinite,
            isShowTooltip: true,
            tooltipMessage: Lang.of(context).lbl_tooltip_text,
            isLoading: state.isProprietorOtpLoading,
            isDisabled: !isValidAadhar,
            borderRadius: 8.0,
            onPressed:
                isValidAadhar
                    ? () async {
                      final sessionId = await Prefobj.preferences.get(Prefkeys.sessionId) ?? '';
                      context.read<BusinessAccountSetupBloc>().add(
                        ProprietorSendAadharOtp(
                          aadhar: state.proprietorAadharNumberController.text.trim(),
                          captcha: state.proprietorCaptchaInputController.text.trim(),
                          sessionId: sessionId,
                        ),
                      );
                    }
                    : null,
          );
        },
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
            buildSizedBoxH(5.0),
            CustomTextInputField(
              context: context,
              type: InputType.digits,
              controller: state.proprietorAadharOtpController,
              textInputAction: TextInputAction.done,
              validator: ExchekValidations.validateOTP,
              suffixText: true,
              suffixIcon: ValueListenableBuilder(
                valueListenable: state.proprietorAadharNumberController,
                builder: (context, _, __) {
                  return GestureDetector(
                    onTap:
                        state.isProprietorAadharOtpTimerRunning
                            ? null
                            : () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              final sessionId = await Prefobj.preferences.get(Prefkeys.sessionId) ?? '';
                              BlocProvider.of<BusinessAccountSetupBloc>(context).add(
                                ProprietorSendAadharOtp(
                                  aadhar: state.proprietorAadharNumberController.text.trim(),
                                  captcha: state.proprietorCaptchaInputController.text.trim(),
                                  sessionId: sessionId,
                                ),
                              );
                            },
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
                      child: Text(
                        state.isProprietorAadharOtpTimerRunning
                            ? '${Lang.of(context).lbl_resend_otp_in} ${formatSecondsToMMSS(state.proprietorAadharOtpRemainingTime)}sec'
                            : Lang.of(context).lbl_resend_OTP,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              state.isProprietorAadharOtpTimerRunning ||
                                      (state.proprietorAadharNumberController.text.trim().length != 14)
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
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, NoPasteFormatter()],
              onFieldSubmitted: (value) {
                if (state.proprietorAadharVerificationFormKey.currentState?.validate() ?? false) {
                  context.read<BusinessAccountSetupBloc>().add(
                    ProprietorAadharNumbeVerified(
                      state.proprietorAadharNumberController.text,
                      state.proprietorAadharOtpController.text,
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
            ),
          ],
        );
      },
    );
  }

  Widget _buildVerifyButton(BuildContext context, BusinessAccountSetupState state) {
    return Align(
      alignment: Alignment.centerRight,
      child: AnimatedBuilder(
        animation: Listenable.merge([state.proprietorAadharOtpController, state.proprietorAadharNumberController]),
        builder: (context, child) {
          final isDisable =
              state.proprietorAadharOtpController.text.isEmpty || state.proprietorAadharOtpController.text.isEmpty;
          return CustomElevatedButton(
            text: Lang.of(context).lbl_confirm_and_next,
            width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 150 : double.maxFinite,
            isShowTooltip: true,
            isLoading: state.isProprietorAadharVerifiedLoading ?? false,
            tooltipMessage: Lang.of(context).lbl_tooltip_text,
            isDisabled: isDisable,
            borderRadius: 8.0,
            onPressed:
                isDisable
                    ? null
                    : () {
                      if (state.proprietorAadharVerificationFormKey.currentState?.validate() ?? false) {
                        context.read<BusinessAccountSetupBloc>().add(
                          ProprietorAadharNumbeVerified(
                            state.proprietorAadharNumberController.text,
                            state.proprietorAadharOtpController.text,
                          ),
                        );
                      }
                    },
          );
        },
      ),
    );
  }

  Widget _buildVerifyProprietorAadharNumber(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Proprietor Aadhaar Number",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
            fontWeight: FontWeight.w400,
            height: 1.22,
          ),
        ),
        buildSizedBoxH(8.0),
        CommanVerifiedInfoBox(
          value: AadhaarMaskUtils.maskAadhaarNumber(state.proprietorAadharNumber ?? ''),
          showTrailingIcon: true,
        ),
      ],
    );
  }

  Widget _buildUploadAddharCard(BuildContext context) {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomFileUploadWidget(
              selectedFile: state.proprietorFrontSideAdharFile,
              title: Lang.of(context).lbl_front_side_of_aadhar,
              onFileSelected: (fileData) {
                context.read<BusinessAccountSetupBloc>().add(ProprietorFrontSlideAadharCardUpload(fileData));
                // Mark data as changed for proprietor aadhar
                context.read<BusinessAccountSetupBloc>().add(MarkProprietorAadharDataChanged());
              },
              documentNumber: state.proprietorAadharNumberController.text,
              documentType: "Aadhaar",
              kycRole: "PROPRIETOR",
              screenName: "BUSINESS_LEGAL_DOC",
            ),
            buildSizedBoxH(24.0),
            CustomFileUploadWidget(
              selectedFile: state.proprietorBackSideAdharFile,
              title: Lang.of(context).lbl_back_side_of_aadhar,
              onFileSelected: (fileData) {
                context.read<BusinessAccountSetupBloc>().add(ProprietorBackSlideAadharCardUpload(fileData));
                // Mark data as changed for proprietor aadhar
                context.read<BusinessAccountSetupBloc>().add(MarkProprietorAadharDataChanged());
              },
              documentNumber: state.proprietorAadharNumberController.text,
              documentType: "Aadhaar",
              kycRole: "PROPRIETOR",
              screenName: "BUSINESS_LEGAL_DOC",
            ),
          ],
        );
      },
    );
  }

  Widget _buildNextButton() {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        final isButtonEnabled = state.proprietorFrontSideAdharFile != null && state.proprietorBackSideAdharFile != null;

        return Align(
          alignment: Alignment.centerRight,
          child: CustomElevatedButton(
            isShowTooltip: true,
            text: Lang.of(context).save_and_next,
            borderRadius: 8.0,
            width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 120 : double.maxFinite,
            buttonTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            isDisabled: !isButtonEnabled,
            isLoading: state.isProprietorAadharFileUploading,
            onPressed:
                isButtonEnabled
                    ? () {
                      context.read<BusinessAccountSetupBloc>().add(
                        ProprietorAadharFileUploadSubmitted(
                          frontAadharFileData: state.proprietorFrontSideAdharFile!,
                          backAadharFileData: state.proprietorBackSideAdharFile!,
                        ),
                      );
                    }
                    : null,
          ),
        );
      },
    );
  }

  // Widget _buildTitleWidget(BuildContext context, String title) {
  //   return Text(
  //     title,
  //     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //       fontSize: ResponsiveHelper.getFontSize(context, mobile: 14.0, tablet: 15.0, desktop: 16.0),
  //       fontWeight: FontWeight.w400,
  //       height: 1.22,
  //     ),
  //   );
  // }

  String formatSecondsToMMSS(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  Widget _buildVerifyAadharButton(BuildContext context, BusinessAccountSetupState state) {
    return Align(
      alignment: Alignment.centerRight,
      child: AnimatedBuilder(
        animation: Listenable.merge([state.proprietorAadharNumberController]),
        builder: (context, _) {
          bool isDisabled =
              ExchekValidations.validateAadhaar(
                state.proprietorAadharNumberController.text.replaceAll("-", "").trim(),
              ) !=
              null;
          return CustomElevatedButton(
            text: Lang.of(context).lbl_verify,
            width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 150 : double.maxFinite,
            isShowTooltip: true,
            isLoading: state.isProprietorCaptchaLoading ?? false,
            tooltipMessage: Lang.of(context).lbl_tooltip_text,
            isDisabled: isDisabled,
            borderRadius: 8.0,
            onPressed:
                isDisabled
                    ? null
                    : () {
                      final isValidAadhar =
                          ExchekValidations.validateAadhaar(
                            state.proprietorAadharNumberController.text.replaceAll("-", "").trim(),
                          ) ==
                          null;
                      if (isValidAadhar) {
                        context.read<BusinessAccountSetupBloc>().add(ProprietorCaptchaSend());
                      }
                    },
          );
        },
      ),
    );
  }
}
