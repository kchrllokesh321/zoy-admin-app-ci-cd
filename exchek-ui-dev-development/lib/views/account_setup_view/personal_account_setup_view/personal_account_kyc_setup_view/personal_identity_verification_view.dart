// ignore_for_file: use_build_context_synchronously

import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/viewmodels/account_setup_bloc/personal_account_setup_bloc/personal_account_setup_bloc.dart';
import 'package:exchek/widgets/account_setup_widgets/aadhar_upload_note.dart';
import 'package:exchek/widgets/account_setup_widgets/captcha_image.dart';
import 'package:exchek/widgets/common_widget/pdf_merge_progress_bar.dart';
import 'package:exchek/widgets/custom_widget/custom_drop_down_field.dart';

class PersonalIdentityVerificationView extends StatelessWidget {
  const PersonalIdentityVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalAccountSetupBloc, PersonalAccountSetupState>(
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
                      title: Lang.of(context).lbl_verify_government_issued_ID,
                      description: Lang.of(context).lbl_provide_upload_proof_verification,
                    ),
                    buildSizedBoxH(30.0),
                    _buildIDVerificationDocTypes(context, state),
                    buildSizedBoxH(30.0),

                    if (state.isIdVerified == false)
                      Column(
                        children: [
                          if (state.selectedIDVerificationDocType == IDVerificationDocType.aadharCard)
                            _buildIsNotAadharVerify(context, state)
                          else if (state.selectedIDVerificationDocType == IDVerificationDocType.drivingLicense)
                            _buildIsNotDrivingVerify(context, state)
                          else if (state.selectedIDVerificationDocType == IDVerificationDocType.voterID)
                            _buildIsNotVoterIdVerify(context, state)
                          else if (state.selectedIDVerificationDocType == IDVerificationDocType.passport)
                            _buildIsNotPassportVerify(context, state),
                        ],
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state.selectedIDVerificationDocType == IDVerificationDocType.aadharCard)
                            _buildIsAadharVerify(context, state)
                          else if (state.selectedIDVerificationDocType == IDVerificationDocType.drivingLicense)
                            _buildIsDrivingVerify(context, state)
                          else if (state.selectedIDVerificationDocType == IDVerificationDocType.voterID)
                            _buildIsVoterIdVerify(context, state)
                          else if (state.selectedIDVerificationDocType == IDVerificationDocType.passport)
                            _buildIsPassportVerify(context, state),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIDVerificationDocTypes(BuildContext context, PersonalAccountSetupState state) {
    final docTypes = IDVerificationDocType.values;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleWidget(context, Lang.of(context).lbl_select_verification),
        buildSizedBoxH(8.0),
        ExpandableDropdownField(
          items: docTypes.map((e) => e.displayName).toList(),
          selectedValue: state.selectedIDVerificationDocType?.displayName,
          onChanged: (value) {
            final selected = docTypes.firstWhere((e) => e.displayName == value);
            context.read<PersonalAccountSetupBloc>().add(PersonalUpdateIdVerificationDocType(selected));
          },
        ),
      ],
    );
  }

  Widget _buildIsAadharVerify(BuildContext context, PersonalAccountSetupState state) {
    return Form(
      key: state.aadharVerificationFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVerifyAadharNumber(context, state),
          buildSizedBoxH(24.0),
          _uolpadAadhaarTitle(context),
          buildSizedBoxH(24.0),
          UploadNote(notes: [Lang.of(context).lbl_note_1, Lang.of(context).lbl_note_2]),
          buildSizedBoxH(24.0),
          _buildUploadAddharCard(context),
          buildSizedBoxH(30.0),
          if (state.isMerging) ...[PdfMergeProgressBar(progress: state.mergeProgress ?? 0.0), buildSizedBoxH(16.0)],
          buildSizedBoxH(30.0),
          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _uolpadAadhaarTitle(BuildContext context) {
    return Text(
      Lang.of(context).lbl_upload_aadhar_card,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontSize: ResponsiveHelper.getFontSize(context, mobile: 28, tablet: 30, desktop: 32),
        fontWeight: FontWeight.w500,
        letterSpacing: 0.32,
      ),
    );
  }

  Widget _buildIsNotAadharVerify(BuildContext context, PersonalAccountSetupState state) {
    return Form(
      key: state.aadharVerificationFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with title and conditional Edit button
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: _buildTitleWidget(context, Lang.of(context).lbl_aadhar_number)),
              if (state.isCaptchaSend || state.isOtpSent) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: InkWell(
                    mouseCursor: SystemMouseCursors.click,
                    onTap: () {
                      // Store original Aadhar number before enabling edit
                      context.read<PersonalAccountSetupBloc>().add(
                        PersonalStoreOriginalAadharNumber(state.aadharNumberController.text),
                      );
                      TextFieldUtils.focusAndMoveCursorToEnd(
                        context: context,
                        focusNode: state.aadharNumberFocusNode,
                        controller: state.aadharNumberController,
                      );
                      // Reset captcha/OTP state but keep Aadhaar number so it becomes editable
                      context.read<PersonalAccountSetupBloc>().add(const PersonalEnableAadharEdit());
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
            ],
          ),
          buildSizedBoxH(8.0),
          _buildAadharNumberField(context, state),
          if (!state.isCaptchaSend && !state.isOtpSent) buildSizedBoxH(20),
          if (!state.isCaptchaSend && !state.isOtpSent) _buildVerifyAadharButton(context, state),
          if (state.isCaptchaSend) ...[
            buildSizedBoxH(24.0),
            Builder(
              builder: (context) {
                if (state.captchaImage != null) {
                  return Column(
                    children: [
                      Row(
                        spacing: 20.0,
                        children: [
                          Base64CaptchaField(base64Image: state.captchaImage ?? ''),
                          AbsorbPointer(
                            absorbing: state.isOtpSent,
                            child: Opacity(
                              opacity: state.isOtpSent ? 0.5 : 1.0,
                              child: CustomImageView(
                                imagePath: Assets.images.svgs.icons.icRefresh.path,
                                height: 40.0,
                                width: 40.0,
                                onTap: () async {
                                  context.read<PersonalAccountSetupBloc>().add(ReCaptchaSend());
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      buildSizedBoxH(24.0),
                      _buildCaptchaField(context),
                      if (!state.isOtpSent) ...[buildSizedBoxH(24.0), _buildSendOTPButton(context, state)],
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
          if (state.isOtpSent) ...[
            buildSizedBoxH(24.0),
            _buildOTPField(context, state),
            if (state.isAadharOTPInvalidate != null) ...[
              buildSizedBoxH(10),
              Text(
                state.isAadharOTPInvalidate ?? '',
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

  Widget _buildIsDrivingVerify(BuildContext context, PersonalAccountSetupState state) {
    return Form(
      key: state.drivingVerificationFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVerifyDrivingLicenseNumber(context, state),
          buildSizedBoxH(24.0),
          _buildTitleWidget(context, Lang.of(context).lbl_upload_driving_licence),
          buildSizedBoxH(24.0),
          UploadNote(
            notes: [Lang.of(context).lbl_please_original_driving_license, Lang.of(context).lbl_driving_note_2],
          ),
          buildSizedBoxH(24.0),
          _buildUploadFrontSideDrivingLicence(context),
          buildSizedBoxH(30.0),
          if (state.isMerging) ...[PdfMergeProgressBar(progress: state.mergeProgress ?? 0.0), buildSizedBoxH(16.0)],
          buildSizedBoxH(30.0),
          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildIsNotDrivingVerify(BuildContext context, PersonalAccountSetupState state) {
    return Form(
      key: state.drivingVerificationFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDrivingLicenseNumber(context, state),
          buildSizedBoxH(30.0),
          _buildVerifyButton(context, state),
        ],
      ),
    );
  }

  Widget _buildIsVoterIdVerify(BuildContext context, PersonalAccountSetupState state) {
    return Form(
      key: state.voterVerificationFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVerifyVoterIdNumber(context, state),
          buildSizedBoxH(24.0),
          UploadNote(
            notes: [Lang.of(context).lbl_please_voter_id_screenshots, Lang.of(context).information_damaged_voter_id],
          ),
          buildSizedBoxH(24.0),
          _buildUploadVoterId(context),
          buildSizedBoxH(30.0),
          if (state.isMerging) ...[PdfMergeProgressBar(progress: state.mergeProgress ?? 0.0), buildSizedBoxH(16.0)],
          buildSizedBoxH(30.0),
          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildIsNotVoterIdVerify(BuildContext context, PersonalAccountSetupState state) {
    return Form(
      key: state.voterVerificationFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildVoterIdNumber(context, state), buildSizedBoxH(30.0), _buildVerifyButton(context, state)],
      ),
    );
  }

  Widget _buildIsPassportVerify(BuildContext context, PersonalAccountSetupState state) {
    return Form(
      key: state.passportVerificationFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVerifiedPassportNumber(context, state),
          buildSizedBoxH(24.0),
          UploadNote(
            notes: [
              Lang.of(context).lbl_please_original_passport_accepted,
              Lang.of(context).lbl_Ensure_information_passport_accepted,
            ],
          ),
          buildSizedBoxH(24.0),
          _buildUploadPassport(context),
          buildSizedBoxH(30.0),
          if (state.isMerging) ...[PdfMergeProgressBar(progress: state.mergeProgress ?? 0.0), buildSizedBoxH(16.0)],
          buildSizedBoxH(30.0),
          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildIsNotPassportVerify(BuildContext context, PersonalAccountSetupState state) {
    return Form(
      key: state.passportVerificationFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildPassportNumberField(context, state), buildSizedBoxH(30.0), _buildVerifyButton(context, state)],
      ),
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

  Widget _buildAadharNumberField(BuildContext context, PersonalAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title moved to header row above
        AbsorbPointer(
          absorbing: state.isCaptchaSend,
          child: CustomTextInputField(
            context: context,
            type: InputType.digits,
            focusNode: state.aadharNumberFocusNode,
            controller: state.aadharNumberController,
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
              context.read<PersonalAccountSetupBloc>().add(PersonalAadharNumberChanged(value));
              // Mark data as changed for identity verification
              context.read<PersonalAccountSetupBloc>().add(PersonalMarkIdentityVerificationDataChanged());
            },
            onFieldSubmitted: (value) {
              final isValidAadhar = state.aadharNumberController.text.trim().length == 14;
              if (isValidAadhar) {
                context.read<PersonalAccountSetupBloc>().add(CaptchaSend());
              }
            },
            contextMenuBuilder: customContextMenuBuilder,
          ),
        ),
      ],
    );
  }

  Widget _buildCaptchaField(BuildContext context) {
    return BlocBuilder<PersonalAccountSetupBloc, PersonalAccountSetupState>(
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
                  absorbing: state.isOtpSent,
                  child: CustomTextInputField(
                    context: context,
                    type: InputType.text,
                    controller: state.captchaInputController,
                    textInputAction: TextInputAction.done,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
                    onFieldSubmitted:
                        state.isIdVerifiedLoading == true
                            ? null
                            : (value) async {
                              final isCaptchaValid = state.captchaInputController.text.isNotEmpty;

                              if (isCaptchaValid) {
                                final sessionId = await Prefobj.preferences.get(Prefkeys.sessionId) ?? '';
                                context.read<PersonalAccountSetupBloc>().add(
                                  PersonalSendAadharOtp(
                                    aadhar: state.aadharNumberController.text.trim(),
                                    captcha: state.captchaInputController.text.trim(),
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

  Widget _buildOTPField(BuildContext context, PersonalAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleWidget(context, Lang.of(context).lbl_one_time_password),
        buildSizedBoxH(8.0),
        CustomTextInputField(
          context: context,
          type: InputType.digits,
          controller: state.aadharOtpController,
          textInputAction: TextInputAction.done,
          validator: ExchekValidations.validateOTP,
          suffixText: true,
          suffixIcon: ValueListenableBuilder(
            valueListenable: state.aadharNumberController,
            builder: (context, _, __) {
              return GestureDetector(
                onTap:
                    state.isAadharOtpTimerRunning
                        ? null
                        : () async {
                          final sessionId = await Prefobj.preferences.get(Prefkeys.sessionId) ?? '';
                          FocusManager.instance.primaryFocus?.unfocus();
                          BlocProvider.of<PersonalAccountSetupBloc>(context).add(
                            PersonalSendAadharOtp(
                              aadhar: state.aadharNumberController.text.trim(),
                              captcha: state.captchaInputController.text.trim(),
                              sessionId: sessionId,
                            ),
                          );
                        },
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
                  child: Text(
                    state.isAadharOtpTimerRunning
                        ? '${Lang.of(context).lbl_resend_otp_in} ${formatSecondsToMMSS(state.aadharOtpRemainingTime)}sec'
                        : Lang.of(context).lbl_resend_OTP,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color:
                          state.isAadharOtpTimerRunning || (state.aadharNumberController.text.trim().length != 14)
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
            if (state.aadharVerificationFormKey.currentState?.validate() ?? false) {
              context.read<PersonalAccountSetupBloc>().add(
                PersonalAadharNumbeVerified(
                  aadharNumber: state.aadharNumberController.text.toString(),
                  otp: state.aadharOtpController.text.toString(),
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
  }

  Widget _buildSendOTPButton(BuildContext context, PersonalAccountSetupState state) {
    return Align(
      alignment: Alignment.centerRight,
      child: AnimatedBuilder(
        animation: Listenable.merge([state.aadharNumberController, state.captchaInputController]),
        builder: (context, _) {
          final isDisabled =
              state.aadharNumberController.text.trim().length != 14 || state.captchaInputController.text.trim().isEmpty;

          return CustomElevatedButton(
            text: Lang.of(context).lbl_request_OTP,
            width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 150 : double.maxFinite,
            isShowTooltip: true,
            isLoading: state.isOtpLoading,
            tooltipMessage: Lang.of(context).lbl_tooltip_text,
            isDisabled: isDisabled,
            borderRadius: 8.0,
            onPressed:
                isDisabled
                    ? null
                    : () async {
                      final sessionId = await Prefobj.preferences.get(Prefkeys.sessionId) ?? '';
                      context.read<PersonalAccountSetupBloc>().add(
                        PersonalSendAadharOtp(
                          aadhar: state.aadharNumberController.text.trim(),
                          captcha: state.captchaInputController.text.trim(),
                          sessionId: sessionId,
                        ),
                      );
                    },
          );
        },
      ),
    );
  }

  Widget _buildVerifyAadharButton(BuildContext context, PersonalAccountSetupState state) {
    return Align(
      alignment: Alignment.centerRight,
      child: AnimatedBuilder(
        animation: Listenable.merge([state.aadharNumberController]),
        builder: (context, _) {
          bool isDisabled =
              ExchekValidations.validateAadhaar(state.aadharNumberController.text.replaceAll("-", "").trim()) != null;
          return CustomElevatedButton(
            text: Lang.of(context).lbl_verify,
            width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 150 : double.maxFinite,
            isShowTooltip: true,
            isLoading: state.isCaptchaLoading ?? false,
            tooltipMessage: Lang.of(context).lbl_tooltip_text,
            isDisabled: isDisabled,
            borderRadius: 8.0,
            onPressed:
                isDisabled
                    ? null
                    : () {
                      final isValidAadhar =
                          ExchekValidations.validateAadhaar(
                            state.aadharNumberController.text.replaceAll("-", "").trim(),
                          ) ==
                          null;
                      if (isValidAadhar) {
                        context.read<PersonalAccountSetupBloc>().add(CaptchaSend());
                      }
                    },
          );
        },
      ),
    );
  }

  Widget _buildVerifyButton(BuildContext context, PersonalAccountSetupState state) {
    return Align(
      alignment: Alignment.centerRight,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          state.aadharNumberController,
          state.aadharOtpController,
          state.drivingLicenceController,
          state.voterIdNumberController,
          state.passportNumberController,
        ]),
        builder: (context, _) {
          bool isDisabled = true;

          if (state.selectedIDVerificationDocType == IDVerificationDocType.aadharCard) {
            isDisabled =
                state.aadharNumberController.text.trim().length != 14 ||
                state.aadharOtpController.text.trim().length != 6;
          } else if (state.selectedIDVerificationDocType == IDVerificationDocType.drivingLicense) {
            isDisabled =
                state.drivingLicenceController.text.trim().isEmpty ||
                ExchekValidations.validateDrivingLicence(state.drivingLicenceController.text.trim()) != null;
          } else if (state.selectedIDVerificationDocType == IDVerificationDocType.voterID) {
            isDisabled =
                state.voterIdNumberController.text.trim().isEmpty ||
                ExchekValidations.validateVoterId(state.voterIdNumberController.text.trim()) != null;
          } else if (state.selectedIDVerificationDocType == IDVerificationDocType.passport) {
            isDisabled =
                state.passportNumberController.text.trim().isEmpty ||
                ExchekValidations.validatePassport(state.passportNumberController.text.trim()) != null;
          }

          return CustomElevatedButton(
            text: Lang.of(context).lbl_confirm_and_next,
            width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 150 : double.maxFinite,
            isShowTooltip: true,
            isLoading: state.isIdVerifiedLoading ?? false,
            tooltipMessage: Lang.of(context).lbl_tooltip_text,
            isDisabled: isDisabled,
            borderRadius: 8.0,
            onPressed:
                isDisabled
                    ? null
                    : () {
                      if (state.selectedIDVerificationDocType == IDVerificationDocType.aadharCard) {
                        if (state.aadharVerificationFormKey.currentState?.validate() ?? false) {
                          context.read<PersonalAccountSetupBloc>().add(
                            PersonalAadharNumbeVerified(
                              aadharNumber: state.aadharNumberController.text,
                              otp: state.aadharOtpController.text.toString(),
                            ),
                          );
                        }
                      } else if (state.selectedIDVerificationDocType == IDVerificationDocType.drivingLicense) {
                        if (state.drivingVerificationFormKey.currentState?.validate() ?? false) {
                          context.read<PersonalAccountSetupBloc>().add(
                            PersonalDrivingLicenceVerified(state.drivingLicenceController.text.trim()),
                          );
                        }
                      } else if (state.selectedIDVerificationDocType == IDVerificationDocType.voterID) {
                        if (state.voterVerificationFormKey.currentState?.validate() ?? false) {
                          context.read<PersonalAccountSetupBloc>().add(
                            PersonalVoterIdVerified(state.voterIdNumberController.text.trim()),
                          );
                        }
                      } else if (state.selectedIDVerificationDocType == IDVerificationDocType.passport) {
                        if (state.passportVerificationFormKey.currentState?.validate() ?? false) {
                          context.read<PersonalAccountSetupBloc>().add(
                            PersonalPassportVerified(state.passportNumberController.text.trim()),
                          );
                        }
                      }
                    },
          );
        },
      ),
    );
  }

  Widget _buildVerifyAadharNumber(BuildContext context, PersonalAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleWidget(context, Lang.of(context).lbl_aadhar_number_verified),
        buildSizedBoxH(8.0),
        CommanVerifiedInfoBox(
          value: AadhaarMaskUtils.maskAadhaarNumber(state.aadharNumber ?? ''),
          showTrailingIcon: true,
        ),
      ],
    );
  }

  Widget _buildUploadAddharCard(BuildContext context) {
    return BlocBuilder<PersonalAccountSetupBloc, PersonalAccountSetupState>(
      builder: (context, state) {
        if (state.isFrontSideAdharFileUploaded) {
          return CustomFileUploadWidget(
            selectedFile: state.frontSideAdharFile,
            title: "Uploaded Aadhar Card",
            isEditMode: true,
            onEditFileSelected: (fileData) {
              context.read<PersonalAccountSetupBloc>().add(PersonalFrontSlideAadharCardUpload(null));
              context.read<PersonalAccountSetupBloc>().add(PersonalBackSlideAadharCardUpload(null));
              // Mark data as changed for identity verification
              context.read<PersonalAccountSetupBloc>().add(PersonalMarkIdentityVerificationDataChanged());
            },
            documentNumber: state.aadharNumberController.text,
            documentType: "Aadhaar",
            kycRole: "",
            screenName: "IDENTITY",
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomFileUploadWidget(
                selectedFile: state.frontSideAdharFile,
                title: Lang.of(context).lbl_front_side_of_aadhar,
                onFileSelected: (fileData) {
                  context.read<PersonalAccountSetupBloc>().add(PersonalFrontSlideAadharCardUpload(fileData));
                  // Mark data as changed for identity verification
                  context.read<PersonalAccountSetupBloc>().add(PersonalMarkIdentityVerificationDataChanged());
                },
                documentNumber: state.aadharNumberController.text,
                documentType: "Aadhaar",
                kycRole: "",
                screenName: "IDENTITY",
              ),
              buildSizedBoxH(24.0),
              CustomFileUploadWidget(
                selectedFile: state.backSideAdharFile,
                title: Lang.of(context).lbl_back_side_of_aadhar,
                onFileSelected: (fileData) {
                  context.read<PersonalAccountSetupBloc>().add(PersonalBackSlideAadharCardUpload(fileData));
                  // Mark data as changed for identity verification
                  context.read<PersonalAccountSetupBloc>().add(PersonalMarkIdentityVerificationDataChanged());
                },
                documentNumber: state.aadharNumberController.text,
                documentType: "Aadhaar",
                kycRole: "",
                screenName: "IDENTITY",
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildDrivingLicenseNumber(BuildContext context, PersonalAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleWidget(context, Lang.of(context).lbl_driving_licence_number),
        buildSizedBoxH(8.0),
        CustomTextInputField(
          context: context,
          type: InputType.text,
          controller: state.drivingLicenceController,
          textInputAction: TextInputAction.done,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
          validator: ExchekValidations.validateDrivingLicence,
          shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForDrivingLicenseValidation,
          maxLength: 17,
          inputFormatters: [
            GroupedInputFormatter(groupSizes: [4, 4, 7], separator: ' ', digitsOnly: false, toUpperCase: true),
            NoPasteFormatter(),
            UpperCaseTextFormatter(),
          ],
          onChanged: (value) {
            // Mark data as changed for identity verification
            context.read<PersonalAccountSetupBloc>().add(PersonalMarkIdentityVerificationDataChanged());
          },
          onFieldSubmitted: (value) {
            if (state.drivingVerificationFormKey.currentState?.validate() ?? false) {
              context.read<PersonalAccountSetupBloc>().add(
                PersonalDrivingLicenceVerified(state.drivingLicenceController.text.trim()),
              );
            }
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          contextMenuBuilder: customContextMenuBuilder,
        ),
      ],
    );
  }

  Widget _buildTitleWidget(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
        fontWeight: FontWeight.w400,
        height: 1.22,
      ),
    );
  }

  Widget _buildVerifyDrivingLicenseNumber(BuildContext context, PersonalAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleWidget(context, Lang.of(context).lbl_driving_licence_number),
        buildSizedBoxH(8.0),
        CommanVerifiedInfoBox(value: state.drivingLicenseNumber ?? '', showTrailingIcon: true),
      ],
    );
  }

  Widget _buildUploadFrontSideDrivingLicence(BuildContext context) {
    return BlocBuilder<PersonalAccountSetupBloc, PersonalAccountSetupState>(
      builder: (context, state) {
        if (state.isDrivingLicenceFrontSideFileUploaded) {
          return CustomFileUploadWidget(
            selectedFile: state.drivingLicenceFrontSideFile,
            title: 'Uploaded Driving License',
            isEditMode: true,
            onEditFileSelected: (fileData) {
              context.read<PersonalAccountSetupBloc>().add(PersonalFrontSlideDrivingLicenceUpload(null));
              context.read<PersonalAccountSetupBloc>().add(PersonalBackSlideDrivingLicenceUpload(null));
              // Mark data as changed for identity verification
              context.read<PersonalAccountSetupBloc>().add(PersonalMarkIdentityVerificationDataChanged());
            },
            documentNumber: state.drivingLicenceController.text,
            documentType: "DrivingLicense",
            kycRole: "",
            screenName: "IDENTITY",
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomFileUploadWidget(
                selectedFile: state.drivingLicenceFrontSideFile,
                title: 'Upload Front Side of Driving License',
                onFileSelected: (fileData) {
                  context.read<PersonalAccountSetupBloc>().add(PersonalFrontSlideDrivingLicenceUpload(fileData));
                  // Mark data as changed for identity verification
                  context.read<PersonalAccountSetupBloc>().add(PersonalMarkIdentityVerificationDataChanged());
                },
                documentNumber: state.drivingLicenceController.text,
                documentType: "DrivingLicense",
                kycRole: "",
                screenName: "IDENTITY",
              ),
              buildSizedBoxH(24.0),
              CustomFileUploadWidget(
                selectedFile: state.drivingLicenceBackSideFile,
                title: 'Upload Back Side of Driving License',
                onFileSelected: (fileData) {
                  context.read<PersonalAccountSetupBloc>().add(PersonalBackSlideDrivingLicenceUpload(fileData));
                  // Mark data as changed for identity verification
                  context.read<PersonalAccountSetupBloc>().add(PersonalMarkIdentityVerificationDataChanged());
                },
                documentNumber: state.drivingLicenceController.text,
                documentType: "DrivingLicense",
                kycRole: "",
                screenName: "IDENTITY",
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildNextButton() {
    return BlocBuilder<PersonalAccountSetupBloc, PersonalAccountSetupState>(
      builder: (context, state) {
        final selectedDocType = state.selectedIDVerificationDocType;
        final isAadhar = selectedDocType == IDVerificationDocType.aadharCard;
        final isDriving = selectedDocType == IDVerificationDocType.drivingLicense;
        final isVoterId = selectedDocType == IDVerificationDocType.voterID;
        final isPassport = selectedDocType == IDVerificationDocType.passport;

        final isAadharUploadValid = isAadhar && state.frontSideAdharFile != null && state.backSideAdharFile != null;
        final isDrivingUploadValid =
            isDriving && state.drivingLicenceFrontSideFile != null && state.drivingLicenceBackSideFile != null;

        final isVoterIdUploadValid = isVoterId && state.voterIdFrontFile != null && state.voterIdBackFile != null;

        final isPassportUploadValid = isPassport && state.passportFrontFile != null && state.passportBackFile != null;

        // Check if documents are already uploaded (edit mode)
        final isAadharAlreadyUploaded = isAadhar && state.isFrontSideAdharFileUploaded == true;
        final isDrivingAlreadyUploaded = isDriving && state.isDrivingLicenceFrontSideFileUploaded == true;
        final isVoterIdAlreadyUploaded = isVoterId && state.isVoteridFrontFileUploaded == true;
        final isPassportAlreadyUploaded = isPassport && state.isPassportFrontFileUploaded == true;

        final isButtonEnabled =
            isAadharUploadValid ||
            isDrivingUploadValid ||
            isVoterIdUploadValid ||
            isPassportUploadValid ||
            isAadharAlreadyUploaded ||
            isDrivingAlreadyUploaded ||
            isVoterIdAlreadyUploaded ||
            isPassportAlreadyUploaded;

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
            isLoading: state.isIdFileSubmittedLoading,
            onPressed:
                isButtonEnabled
                    ? () {
                      if (isAadhar) {
                        context.read<PersonalAccountSetupBloc>().add(
                          PersonalAadharFileUploadSubmitted(
                            frontAadharFileData: state.frontSideAdharFile,
                            backAadharFileData: state.backSideAdharFile,
                          ),
                        );
                      } else if (isDriving) {
                        context.read<PersonalAccountSetupBloc>().add(
                          PersonalDrivingFileUploadSubmitted(
                            frontDrivingLicenceFileData: state.drivingLicenceFrontSideFile,
                            backDrivingLicenceFileData: state.drivingLicenceBackSideFile,
                          ),
                        );
                      } else if (isVoterId) {
                        context.read<PersonalAccountSetupBloc>().add(
                          PersonalVoterIdFileUploadSubmitted(
                            voterIdFrontFileData: state.voterIdFrontFile,
                            voterIdBackFileData: state.voterIdBackFile,
                          ),
                        );
                      } else if (isPassport) {
                        context.read<PersonalAccountSetupBloc>().add(
                          PersonalPassportFileUploadSubmitted(
                            passportFrontFileData: state.passportFrontFile,
                            passportBackFileData: state.passportBackFile,
                          ),
                        );
                      }
                    }
                    : null,
          ),
        );
      },
    );
  }

  Widget _buildVoterIdNumber(BuildContext context, PersonalAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleWidget(context, Lang.of(context).lbl_voter_id_number),
        buildSizedBoxH(8.0),
        CustomTextInputField(
          context: context,
          type: InputType.text,
          controller: state.voterIdNumberController,
          textInputAction: TextInputAction.done,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
          validator: ExchekValidations.validateVoterId,
          shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForVoterIdValidation,
          maxLength: 10,
          onChanged: (value) {
            // Mark data as changed for identity verification
            context.read<PersonalAccountSetupBloc>().add(PersonalMarkIdentityVerificationDataChanged());
          },
          onFieldSubmitted: (value) {
            if (state.voterVerificationFormKey.currentState?.validate() ?? false) {
              context.read<PersonalAccountSetupBloc>().add(
                PersonalVoterIdVerified(state.voterIdNumberController.text.trim()),
              );
            }
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: [NoPasteFormatter(), UpperCaseTextFormatter()],
          contextMenuBuilder: customContextMenuBuilder,
        ),
      ],
    );
  }

  Widget _buildVerifyVoterIdNumber(BuildContext context, PersonalAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleWidget(context, Lang.of(context).lbl_voter_id_number),
        buildSizedBoxH(8.0),
        CommanVerifiedInfoBox(value: state.voterIDNumber ?? '', showTrailingIcon: true),
      ],
    );
  }

  Widget _buildUploadVoterId(BuildContext context) {
    return BlocBuilder<PersonalAccountSetupBloc, PersonalAccountSetupState>(
      builder: (context, state) {
        if (state.isVoteridFrontFileUploaded) {
          return CustomFileUploadWidget(
            selectedFile: state.voterIdFrontFile,
            title: "Uploaded Voter ID",
            isEditMode: true,
            onEditFileSelected: (fileData) {
              context.read<PersonalAccountSetupBloc>().add(PersonalVoterIdFrontFileUpload(null));
              context.read<PersonalAccountSetupBloc>().add(PersonalVoterIdBackFileUpload(null));
              // Mark data as changed for identity verification
              context.read<PersonalAccountSetupBloc>().add(PersonalMarkIdentityVerificationDataChanged());
            },
            documentNumber: state.voterIdNumberController.text,
            documentType: "VoterID",
            kycRole: "",
            screenName: "IDENTITY",
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomFileUploadWidget(
                selectedFile: state.voterIdFrontFile,
                title: "Upload Front Side of Voter ID",
                onFileSelected: (fileData) {
                  context.read<PersonalAccountSetupBloc>().add(PersonalVoterIdFrontFileUpload(fileData));
                  // Mark data as changed for identity verification
                  context.read<PersonalAccountSetupBloc>().add(PersonalMarkIdentityVerificationDataChanged());
                },
                documentNumber: state.voterIdNumberController.text,
                documentType: "VoterID",
                kycRole: "",
                screenName: "IDENTITY",
              ),
              buildSizedBoxH(24.0),
              CustomFileUploadWidget(
                selectedFile: state.voterIdBackFile,
                title: "Upload Back Side of Voter ID",
                onFileSelected: (fileData) {
                  context.read<PersonalAccountSetupBloc>().add(PersonalVoterIdBackFileUpload(fileData));
                  // Mark data as changed for identity verification
                  context.read<PersonalAccountSetupBloc>().add(PersonalMarkIdentityVerificationDataChanged());
                },
                documentNumber: state.voterIdNumberController.text,
                documentType: "VoterID",
                kycRole: "",
                screenName: "IDENTITY",
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildPassportNumberField(BuildContext context, PersonalAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleWidget(context, Lang.of(context).lbl_passport_number),
        buildSizedBoxH(8.0),
        CustomTextInputField(
          context: context,
          type: InputType.text,
          controller: state.passportNumberController,
          textInputAction: TextInputAction.done,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
          validator: ExchekValidations.validatePassport,
          shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForPassportValidation,
          maxLength: 8,
          onChanged: (value) {
            // Mark data as changed for identity verification
            context.read<PersonalAccountSetupBloc>().add(PersonalMarkIdentityVerificationDataChanged());
          },
          onFieldSubmitted: (value) {
            if (state.passportVerificationFormKey.currentState?.validate() ?? false) {
              context.read<PersonalAccountSetupBloc>().add(
                PersonalPassportVerified(state.passportNumberController.text.trim()),
              );
            }
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: [NoPasteFormatter(), UpperCaseTextFormatter()],
          contextMenuBuilder: customContextMenuBuilder,
        ),
      ],
    );
  }

  Widget _buildVerifiedPassportNumber(BuildContext context, PersonalAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleWidget(context, Lang.of(context).lbl_passport_number),
        buildSizedBoxH(8.0),
        CommanVerifiedInfoBox(value: state.passporteNumber ?? '', showTrailingIcon: true),
      ],
    );
  }

  Widget _buildUploadPassport(BuildContext context) {
    return BlocBuilder<PersonalAccountSetupBloc, PersonalAccountSetupState>(
      builder: (context, state) {
        if (state.isPassportFrontFileUploaded) {
          return CustomFileUploadWidget(
            selectedFile: state.passportFrontFile,
            title: "Uploaded Passport",
            isEditMode: true,
            onEditFileSelected: (fileData) {
              context.read<PersonalAccountSetupBloc>().add(PersonalPassportFrontFileUpload(null));
              context.read<PersonalAccountSetupBloc>().add(PersonalPassportBackFileUpload(null));
              // Mark data as changed for identity verification
              context.read<PersonalAccountSetupBloc>().add(PersonalMarkIdentityVerificationDataChanged());
            },
            documentNumber: state.passportNumberController.text,
            documentType: "Passport",
            kycRole: "",
            screenName: "IDENTITY",
          );
        } else {
          SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomFileUploadWidget(
              selectedFile: state.passportFrontFile,
              title: "Upload First Page of Passport (Photo Page)",
              onFileSelected: (fileData) {
                context.read<PersonalAccountSetupBloc>().add(PersonalPassportFrontFileUpload(fileData));
                // Mark data as changed for identity verification
                context.read<PersonalAccountSetupBloc>().add(PersonalMarkIdentityVerificationDataChanged());
              },
              documentNumber: state.passportNumberController.text,
              documentType: "Passport",
              kycRole: "",
              screenName: "IDENTITY",
            ),
            buildSizedBoxH(24.0),
            CustomFileUploadWidget(
              selectedFile: state.passportBackFile,
              title: "Upload Last Page of Passport (Address Page)",
              onFileSelected: (fileData) {
                context.read<PersonalAccountSetupBloc>().add(PersonalPassportBackFileUpload(fileData));
                // Mark data as changed for identity verification
                context.read<PersonalAccountSetupBloc>().add(PersonalMarkIdentityVerificationDataChanged());
              },
              documentNumber: state.passportNumberController.text,
              documentType: "Passport",
              kycRole: "",
              screenName: "IDENTITY",
            ),
          ],
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
