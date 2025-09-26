
import 'package:country_picker/country_picker.dart';
import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/widgets/account_setup_widgets/aadhar_upload_note.dart';
import 'package:exchek/widgets/account_setup_widgets/business_representative_selection_dialog.dart';
import 'package:exchek/widgets/account_setup_widgets/captcha_image.dart';
import 'package:exchek/widgets/account_setup_widgets/country_picker_field.dart';

class OtherDirectorKycDialog extends StatelessWidget {
  const OtherDirectorKycDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            clipBehavior: Clip.hardEdge,
            constraints: BoxConstraints(maxWidth: ResponsiveHelper.getMaxDialogWidth(context)),
            decoration: BoxDecoration(
              color: Theme.of(context).customColors.fillColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildSizedBoxH(25.0),
                _buildDialogHeader(context, state),
                buildSizedBoxH(10.0),
                divider(context),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: ResponsiveHelper.getMaxDialogWidth(context),
                    maxHeight:
                        MediaQuery.of(context).size.height < 600
                            ? MediaQuery.of(context).size.height * 0.52
                            : MediaQuery.of(context).size.height * 0.7,
                  ),
                  child: SingleChildScrollView(
                    padding: ResponsiveHelper.getDialogPadding(context),
                    child: _buildStepContent(context, state),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStepContent(BuildContext context, BusinessAccountSetupState state) {
    switch (state.otherDirectorKycStep) {
      case OtherDirectorKycSteps.panDetails:
        return _buildPanDetailsStep(context, state);
      case OtherDirectorKycSteps.aadharDetails:
        return _buildAadharDetailsStep(context, state);
    }
  }

  Widget _buildPanDetailsStep(BuildContext context, BusinessAccountSetupState state) {
    return Form(
      key: state.otherDirectorsPanVerificationKey,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            buildSizedBoxH(36.0),
            _buildContentTitle(context, "PAN Details"),
            buildSizedBoxH(22.0),
            _buildDirector2PanNumberField(context, state),
            if ((state.director2PanDetailsErrorMessage ?? '').isNotEmpty) ...[
              CommanErrorMessage(errorMessage: state.director2PanDetailsErrorMessage ?? ''),
            ],
            if ((state.director2PanEditErrorMessage ?? '').isNotEmpty) ...[
              buildSizedBoxH(5.0),
              CommanErrorMessage(errorMessage: state.director2PanEditErrorMessage ?? ''),
            ],
            if ((state.directorPANValidationErrorMessage ?? '').isNotEmpty) ...[
              buildSizedBoxH(5.0),
              CommanErrorMessage(errorMessage: state.directorPANValidationErrorMessage ?? ''),
            ],
            if (state.isDirector2PanDetailsVerified == true) ...[
              buildSizedBoxH(24.0),
              _buildDirector2PanName(context, state),
            ],
            buildSizedBoxH(24.0),
            _buildDirector2UploadPanCard(context, state),
            buildSizedBoxH(8.0),
            _buildDirector2IsBeneficialOwner(context, state),
            buildSizedBoxH(8.0),
            _buildDirector2BusinessRepresentative(context, state),
            buildSizedBoxH(8.0),
            buildSizedBoxH(20.0),
            _buildBusinessPanSaveButton(),
            buildSizedBoxH(36.0),
          ],
        ),
      ),
    );
  }

  Widget _buildAadharDetailsStep(BuildContext context, BusinessAccountSetupState state) {
    return (state.isOtherDirectorAadharVerified == false)
        ? _buildIsNotAadharVerify(context, state)
        : _buildIsAadharVerify(context, state);
  }

  Widget _buildDialogHeader(BuildContext context, BusinessAccountSetupState state) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: ResponsiveHelper.getMaxDialogWidth(context)),
        padding: ResponsiveHelper.getDialogPadding(context),
        child: Row(
          children: [
            Expanded(
              child: FutureBuilder<String?>(
                future: KycStepUtils.getBusinessType(),
                builder: (context, snapshot) {
                  String businessType = snapshot.data ?? '';
                  String title;
                  if (businessType == 'limited_liability_partnership' || businessType == 'partnership') {
                    title = "Other Partner KYC";
                  } else {
                    title = "Other Director KYC";
                  }
                  return Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: ResponsiveHelper.getFontSize(context, mobile: 20, tablet: 22, desktop: 24),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.24,
                    ),
                  );
                },
              ),
            ),
            buildSizedboxW(15.0),
            HoverCloseButton(
              onTap: () {
                GoRouter.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDirector2PanNumberField(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                Lang.of(context).lbl_PAN_number,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
                  fontWeight: FontWeight.w400,
                  height: 1.22,
                ),
              ),
            ),
            if (state.isDirector2PanEditLocked || state.isDirector2PanModifiedAfterVerification) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: GestureDetector(
                  onTap: () {
                    // Store original PAN number before enabling edit
                    context.read<BusinessAccountSetupBloc>().add(
                      BusinessStoreOriginalDirector2PanNumber(state.director2PanNumberController.text),
                    );
                    if (!state.isDirector2PanEditLocked) {
                      TextFieldUtils.focusAndMoveCursorToEnd(
                        context: context,
                        focusNode: state.director2PanNumberFocusNode,
                        controller: state.director2PanNumberController,
                      );
                    }
                    // Set modification flag when user clicks edit
                    context.read<BusinessAccountSetupBloc>().add(
                      Director2PanNumberChanged(state.director2PanNumberController.text),
                    );
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
        AbsorbPointer(
          absorbing: state.isDirector2PanEditLocked || state.isDirector2PanModifiedAfterVerification,
          child: CustomTextInputField(
            context: context,
            type: InputType.text,
            controller: state.director2PanNumberController,
            textInputAction: TextInputAction.done,
            validator: (value) {
              return ExchekValidations.validatePANByType(value, "INDIVIDUAL");
            },
            shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForPANValidation,
            maxLength: 10,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: [UpperCaseTextFormatter(), NoPasteFormatter()],
            onChanged: (value) {
              // Mark data as changed for PAN details only if value differs from original
              if (value != state.originalDirector2PanNumber) {
                context.read<BusinessAccountSetupBloc>().add(MarkPanDetailsDataChanged());
              }
              if (!state.isDirector2PanEditLocked) {
                context.read<BusinessAccountSetupBloc>().add(Director2PanNumberChanged(value));
                if (value.length == 10) {
                  FocusScope.of(context).unfocus();
                  if (ExchekValidations.validatePANByType(state.director2PanNumberController.text, "INDIVIDUAL") ==
                          null &&
                      ExchekValidations.validateDirectorPANsAreDifferent(
                            state.director1PanNumberController.text,
                            value,
                          ) ==
                          null) {
                    context.read<BusinessAccountSetupBloc>().add(
                      GetDirector2PanDetails(state.director2PanNumberController.text),
                    );
                  }
                }
              }
            },
            suffixIcon: state.isDirector2PanDetailsLoading == true ? AppLoaderWidget(size: 20) : null,
            onFieldSubmitted: (value) {
              if (!state.isDirector2PanEditLocked) {
                final panValidation = ExchekValidations.validatePANByType(
                  state.director2PanNumberController.text,
                  "INDIVIDUAL",
                );
                final directorValidation = ExchekValidations.validateDirectorPANsAreDifferent(
                  state.director1PanNumberController.text,
                  value,
                );
                if (panValidation == null && directorValidation == null) {
                  FocusScope.of(context).unfocus();
                  context.read<BusinessAccountSetupBloc>().add(
                    GetDirector2PanDetails(state.director2PanNumberController.text),
                  );
                }
              }
            },
            contextMenuBuilder: customContextMenuBuilder,
            focusNode: state.director2PanNumberFocusNode,
          ),
        ),
      ],
    );
  }

  Widget _buildDirector2UploadPanCard(BuildContext context, BusinessAccountSetupState state) {
    return FutureBuilder<String?>(
      future: KycStepUtils.getBusinessType(),
      builder: (context, snapshot) {
        String businessType = snapshot.data ?? '';
        String title;
        if (businessType == 'limited_liability_partnership' || businessType == 'partnership') {
          title = "Upload Partner 2 PAN Card";
        } else {
          title = "Upload Director 2 PAN Card";
        }
        String otherDirectorKycRole = '';
        if (businessType == 'limited_liability_partnership' || businessType == 'partnership') {
          otherDirectorKycRole = "OTHER_PARTNER";
        } else {
          otherDirectorKycRole = "OTHER_DIRECTOR";
        }
        return CustomFileUploadWidget(
          title: title,
          selectedFile: state.director2PanCardFile,
          onFileSelected: (fileData) {
            context.read<BusinessAccountSetupBloc>().add(Director2UploadPanCard(fileData));
          },
          documentNumber: state.director2PanNumberController.text,
          documentType: "",
          kycRole: otherDirectorKycRole,
          screenName: "PAN",
        );
      },
    );
  }

  Widget _buildDirector2BusinessRepresentative(BuildContext context, BusinessAccountSetupState state) {
    // If director 1 is already selected as business representative, show disabled state
    if (state.ditector1BusinessRepresentative) {
      return SizedBox();
    }

    return CustomCheckBoxLabel(
      isSelected: state.ditector2BusinessRepresentative,
      label: Lang.of(context).lbl_business_Representative,
      onChanged: () {
        context.read<BusinessAccountSetupBloc>().add(
          ChangeDirector2IsBusinessRepresentative(isSelected: !state.ditector2BusinessRepresentative),
        );
      },
      isShowInfoIcon: true,
      tooltipMessage: Lang.of(context).lbl_tooltip_message_of_owner_representative,
    );
  }

  Widget _buildDirector2IsBeneficialOwner(BuildContext context, BusinessAccountSetupState state) {
    return CustomCheckBoxLabel(
      isSelected: state.director2BeneficialOwner,
      label: Lang.of(context).lbl_this_person_beneficial_owner,
      onChanged: () {
        context.read<BusinessAccountSetupBloc>().add(
          ChangeDirector2IsBeneficialOwner(isSelected: !state.director2BeneficialOwner),
        );
      },
      isShowInfoIcon: true,
      tooltipMessage: Lang.of(context).lbl_tooltip_message_of_beneficial_owner,
    );
  }

  // Widget _buildVerifyDirector2PanButton(BuildContext context, BusinessAccountSetupState state) {
  //   return Align(
  //     alignment: Alignment.centerRight,
  //     child: AnimatedBuilder(
  //       animation: Listenable.merge([state.director2PanNumberController]),
  //       builder: (context, _) {
  //         bool isDisabled =
  //             ExchekValidations.validatePANByType(state.director2PanNumberController.text, "INDIVIDUAL") != null;
  //         return CustomElevatedButton(
  //           text: Lang.of(context).lbl_verify,
  //           width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 130 : double.maxFinite,
  //           isShowTooltip: true,
  //           isLoading: state.isDirector2PanDetailsLoading,
  //           tooltipMessage: Lang.of(context).lbl_tooltip_text,
  //           isDisabled: isDisabled,
  //           borderRadius: 8.0,
  //           onPressed: () {
  //             if (ExchekValidations.validatePANByType(state.director2PanNumberController.text, "INDIVIDUAL") == null) {
  //               context.read<BusinessAccountSetupBloc>().add(
  //                 GetDirector2PanDetails(state.director2PanNumberController.text),
  //               );
  //             }
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget _buildDirector2PanName(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_name_on_PAN,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
            fontWeight: FontWeight.w400,
            height: 1.22,
          ),
        ),
        buildSizedBoxH(8.0),
        CommanVerifiedInfoBox(value: state.fullDirector2NamePan ?? '', showTrailingIcon: true),
      ],
    );
  }

  Widget divider(BuildContext context) =>
      Container(height: 1.5, width: double.maxFinite, color: Theme.of(context).customColors.lightBorderColor);

  Widget _buildBusinessPanSaveButton() {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        final isDisable =
            !(state.director2PanCardFile != null &&
                ExchekValidations.validatePANByType(state.director2PanNumberController.text, "INDIVIDUAL") == null &&
                (state.fullDirector2NamePan ?? '').isNotEmpty &&
                state.isDirector2PanDetailsVerified) ||
            (state.directorPANValidationErrorMessage ?? '').isNotEmpty;
        return AnimatedBuilder(
          animation: Listenable.merge([state.director2PanNumberController]),
          builder: (context, _) {
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
                isLoading: state.isOtherDirectorPanCardSaveLoading ?? false,
                isDisabled: isDisable,
                tooltipMessage: Lang.of(context).lbl_tooltip_text,
                onPressed:
                    isDisable
                        ? null
                        : () {
                          if (state.otherDirectorsPanVerificationKey.currentState?.validate() ?? false) {
                            context.read<BusinessAccountSetupBloc>().add(
                              SaveOtherDirectorPanDetails(
                                director2fileData: state.director2PanCardFile,
                                directorpanName: state.director2PanNameController.text,
                                director2panNumber: state.director2PanNumberController.text,
                              ),
                            );
                          }
                        },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildContentTitle(BuildContext context, String title, {bool isOptional = false}) {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        return Row(
          children: [
            if (state.otherDirectorKycStep == OtherDirectorKycSteps.aadharDetails) ...[
              CustomImageView(
                imagePath: Assets.images.svgs.icons.icArrowLeft.path,
                height: 24.0,
                onTap: () {
                  context.read<BusinessAccountSetupBloc>().add(
                    OtherDirectorKycStepChanged(OtherDirectorKycSteps.panDetails),
                  );
                },
              ),
              buildSizedboxW(15.0),
            ],
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: ResponsiveHelper.getFontSize(context, mobile: 18, tablet: 20, desktop: 20),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            buildSizedboxW(10.0),
            Text(
              "${_getCurrentStepNumber(state.otherDirectorKycStep)}/2",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 20, desktop: 20),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildIsAadharVerify(BuildContext context, BusinessAccountSetupState state) {
    return Form(
      key: state.otherDirectorVerificationFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSizedBoxH(36.0),
          _buildContentTitle(context, "Aadhaar Details", isOptional: true),
          buildSizedBoxH(22.0),
          _buildVerifyAadharNumber(context, state),
          buildSizedBoxH(24.0),
          UploadNote(notes: [Lang.of(context).lbl_note_1, Lang.of(context).lbl_note_2]),
          buildSizedBoxH(24.0),
          _buildUploadAddharCard(context),
          FutureBuilder<String?>(
            future: Prefobj.preferences.get(Prefkeys.userKycDetail),
            builder: (context, snapshot) {
              // final userDetail = jsonDecode(snapshot.data!);
              // final List multicurrency = userDetail['multicurrency'] ?? [];
              // multicurrency.length > 1
              return (state.director2BeneficialOwner == true)
                  ? Column(
                    children: [
                      buildSizedBoxH(30.0),
                      _buildIsResidentialRadioButtons(context, state),
                      if (state.isOtherDirectorAadharAddressSameAsResidentialAddress == false) ...[
                        buildSizedBoxH(20.0),
                        _buildCountryField(context, state),
                        buildSizedBoxH(24.0),
                        _buildPinCodeField(context, state),
                        buildSizedBoxH(24.0),
                        _buildStateCodeField(context, state),
                        buildSizedBoxH(24.0),
                        _buildCityField(context, state),
                        buildSizedBoxH(24.0),
                        _buildAddress1CodeField(context, state),
                        buildSizedBoxH(24.0),
                        _buildAddress2CodeField(context, state),
                      ],
                    ],
                  )
                  : SizedBox();
            },
          ),
          buildSizedBoxH(30.0),
          _buildNextButton(),
          buildSizedBoxH(36.0),
        ],
      ),
    );
  }

  Widget _buildIsNotAadharVerify(BuildContext context, BusinessAccountSetupState state) {
    return Form(
      key: state.otherDirectorVerificationFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSizedBoxH(36.0),
          _buildContentTitle(context, "Aadhaar Details", isOptional: true),
          buildSizedBoxH(22.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  Lang.of(context).lbl_aadhar_number,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
                    fontWeight: FontWeight.w400,
                    height: 1.22,
                  ),
                ),
              ),
              if (state.isOtherDirectorCaptchaSend || state.isOtherDirectorOtpSent)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: InkWell(
                    mouseCursor: SystemMouseCursors.click,
                    onTap: () {
                      // Store original Aadhaar number before enabling edit
                      context.read<BusinessAccountSetupBloc>().add(
                        BusinessStoreOriginalDirector2AadharNumber(state.otherDirectorAadharNumberController.text),
                      );
                      context.read<BusinessAccountSetupBloc>().add(const OtherDirectorEnableAadharEdit());
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        TextFieldUtils.focusAndMoveCursorToEnd(
                          context: context,
                          focusNode: state.otherDirectorAadharNumberFocusNode,
                          controller: state.otherDirectorAadharNumberController,
                        );
                      });
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
          _buildAadharNumberField(context, state),
          if ((state.directorAadhaarValidationErrorMessage ?? '').isNotEmpty) ...[
            buildSizedBoxH(5.0),
            CommanErrorMessage(errorMessage: state.directorAadhaarValidationErrorMessage ?? ''),
          ],

          // Show verify button only when Aadhaar number is entered
          if (state.otherDirectorAadharNumberController.text.trim().isNotEmpty) ...[
            if (!state.isOtherDirectorCaptchaSend && !state.isOtherDitectorOtpSent) ...[
              buildSizedBoxH(20),
              _buildVerifyAadharButton(context, state),
            ],
          ],

          // Show captcha and OTP flow only when verification is in progress
          if (state.isOtherDirectorCaptchaSend) ...[
            buildSizedBoxH(24.0),
            Builder(
              builder: (context) {
                if (state.otherDirectorCaptchaImage != null) {
                  return Column(
                    children: [
                      Row(
                        spacing: 20.0,
                        children: [
                          Base64CaptchaField(base64Image: state.otherDirectorCaptchaImage ?? ''),
                          AbsorbPointer(
                            absorbing: state.isOtherDirectorOtpSent,
                            child: Opacity(
                              opacity: state.isOtherDirectorOtpSent ? 0.5 : 1.0,
                              child: CustomImageView(
                                imagePath: Assets.images.svgs.icons.icRefresh.path,
                                height: 40.0,
                                width: 40.0,
                                onTap: () async {
                                  context.read<BusinessAccountSetupBloc>().add(OtherDirectorReCaptchaSend());
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      buildSizedBoxH(24.0),
                      _buildCaptchaField(context),
                      if (!state.isOtherDirectorOtpSent) ...[buildSizedBoxH(24.0), _buildSendOTPButton(context, state)],
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],

          // Show OTP field when OTP is sent
          if (state.isOtherDirectorOtpSent) ...[
            buildSizedBoxH(24.0),
            _buildOTPField(context, state),
            if (state.isOtherAadharOTPInvalidate.isNotEmpty) ...[
              buildSizedBoxH(10),
              Text(
                state.isOtherAadharOTPInvalidate,
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
          // // Show upload section and save button only when Aadhaar number is empty
          // if (state.otherDirectorAadharNumberController.text.trim().isEmpty) ...[
          //   buildSizedBoxH(36.0),
          //   UploadNote(notes: [Lang.of(context).lbl_note_1, Lang.of(context).lbl_note_2]),
          //   buildSizedBoxH(24.0),
          //   _buildUploadAddharCard(context),
          //   buildSizedBoxH(30.0),
          //   _buildNextButton(),
          // ],
          buildSizedBoxH(36.0),
        ],
      ),
    );
  }

  Widget _buildAadharNumberField(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AbsorbPointer(
          absorbing: state.isOtherDirectorCaptchaSend,
          child: CustomTextInputField(
            context: context,
            type: InputType.digits,
            focusNode: state.otherDirectorAadharNumberFocusNode,
            controller: state.otherDirectorAadharNumberController,
            maxLength: 14,
            textInputAction: TextInputAction.done,
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              GroupedInputFormatter(groupSizes: [4, 4, 4], separator: '-', digitsOnly: true),
              NoPasteFormatter(),
            ],
            validator: (value) {
              final aadhaarValidation = ExchekValidations.validateAadhaar(value);
              if (aadhaarValidation != null) return aadhaarValidation;

              final directorValidation = ExchekValidations.validateDirectorAadhaarsAreDifferent(
                state.aadharNumberController.text,
                value,
              );
              return directorValidation;
            },
            shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForAadhaarValidation,
            onChanged: (value) {
              context.read<BusinessAccountSetupBloc>().add(OtherDirectorAadharNumberChanged(value));
              // Mark data as changed for identity verification only if value differs from original
              if (value != state.originalDirector2AadharNumber) {
                context.read<BusinessAccountSetupBloc>().add(MarkIdentityVerificationDataChanged());
              }
            },
            onFieldSubmitted: (value) {
              final isValidAadhar = state.otherDirectorAadharNumberController.text.trim().length == 14;
              if (isValidAadhar) {
                final validationError = ExchekValidations.validateDirectorAadhaarsAreDifferent(
                  state.aadharNumberController.text,
                  value,
                );
                if (validationError == null) {
                  context.read<BusinessAccountSetupBloc>().add(OtherDirectorCaptchaSend());
                }
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
        animation: Listenable.merge([
          state.otherDirectorAadharNumberController,
          state.otherDirectorCaptchaInputController,
        ]),
        builder: (context, child) {
          final isValidAadhar =
              state.otherDirectorAadharNumberController.text.trim().length == 14 &&
              state.otherDirectorCaptchaInputController.text.trim().isNotEmpty;
          return CustomElevatedButton(
            text: Lang.of(context).lbl_request_OTP,
            width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 150 : double.maxFinite,
            isShowTooltip: true,
            tooltipMessage: Lang.of(context).lbl_tooltip_text,
            isLoading: state.isOtherDirectorAadharOtpLoading ?? false,
            isDisabled: !isValidAadhar,
            borderRadius: 8.0,
            onPressed:
                isValidAadhar
                    ? () async {
                      final sessionId = await Prefobj.preferences.get(Prefkeys.sessionId) ?? '';
                      context.read<BusinessAccountSetupBloc>().add(
                        OtherDirectorSendAadharOtp(
                          state.otherDirectorAadharNumberController.text.trim(),
                          state.otherDirectorCaptchaInputController.text.trim(),
                          sessionId,
                        ),
                      );
                    }
                    : null,
          );
        },
      ),
    );
  }

  Widget _buildOTPField(BuildContext context, BusinessAccountSetupState state) {
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
              controller: state.otherDirectoraadharOtpController,
              textInputAction: TextInputAction.done,
              validator: ExchekValidations.validateOTP,
              suffixText: true,
              suffixIcon: ValueListenableBuilder(
                valueListenable: state.otherDirectorAadharNumberController,
                builder: (context, _, __) {
                  return GestureDetector(
                    onTap:
                        state.isOtherDirectorAadharOtpTimerRunning
                            ? null
                            : () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              final sessionId = await Prefobj.preferences.get(Prefkeys.sessionId) ?? '';
                              BlocProvider.of<BusinessAccountSetupBloc>(context).add(
                                OtherDirectorSendAadharOtp(
                                  state.otherDirectorAadharNumberController.text.trim(),
                                  state.otherDirectorCaptchaInputController.text.trim(),
                                  sessionId,
                                ),
                              );
                            },
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
                      child: Text(
                        state.isOtherDirectorAadharOtpTimerRunning
                            ? '${Lang.of(context).lbl_resend_otp_in} ${formatSecondsToMMSS(state.otherDirectorAadharOtpRemainingTime)}sec'
                            : Lang.of(context).lbl_resend_OTP,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              state.isOtherDirectorAadharOtpTimerRunning ||
                                      (state.otherDirectorAadharNumberController.text.trim().length != 14)
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
                if (state.otherDirectorVerificationFormKey.currentState?.validate() ?? false) {
                  context.read<BusinessAccountSetupBloc>().add(
                    OtherDirectorAadharNumbeVerified(
                      state.otherDirectorAadharNumberController.text,
                      state.otherDirectoraadharOtpController.text,
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
        animation: Listenable.merge([
          state.otherDirectoraadharOtpController,
          state.otherDirectorAadharNumberController,
        ]),
        builder: (context, child) {
          final isDisable =
              state.otherDirectoraadharOtpController.text.isEmpty ||
              state.otherDirectoraadharOtpController.text.isEmpty;
          return CustomElevatedButton(
            text: Lang.of(context).lbl_confirm_and_next,
            width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 150 : double.maxFinite,
            isShowTooltip: true,
            isLoading: state.isOtherDirectorAadharVerifiedLoading ?? false,
            tooltipMessage: Lang.of(context).lbl_tooltip_text,
            isDisabled: isDisable,
            borderRadius: 8.0,
            onPressed:
                isDisable
                    ? null
                    : () {
                      if (state.otherDirectorVerificationFormKey.currentState?.validate() ?? false) {
                        context.read<BusinessAccountSetupBloc>().add(
                          OtherDirectorAadharNumbeVerified(
                            state.otherDirectorAadharNumberController.text,
                            state.otherDirectoraadharOtpController.text,
                          ),
                        );
                      }
                    },
          );
        },
      ),
    );
  }

  Widget _buildVerifyAadharNumber(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_aadhar_number_verified,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
            fontWeight: FontWeight.w400,
          ),
        ),
        buildSizedBoxH(8.0),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
          decoration: BoxDecoration(
            color: Theme.of(context).customColors.fillColor,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Theme.of(context).customColors.greenColor!),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  AadhaarMaskUtils.maskAadhaarNumber(state.otherDirectorAadharNumber ?? ''),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 14, desktop: 14),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              CustomImageView(imagePath: Assets.images.svgs.icons.icShieldTick.path, height: 20.0),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUploadAddharCard(BuildContext context) {
    return FutureBuilder<String?>(
      future: KycStepUtils.getBusinessType(),
      builder: (context, snapshot) {
        return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
          builder: (context, state) {
            String businessType = snapshot.data ?? '';
            String otherDirectorKycRole = '';
            if (businessType == 'limited_liability_partnership' || businessType == 'partnership') {
              otherDirectorKycRole = "OTHER_PARTNER";
            } else {
              otherDirectorKycRole = "OTHER_DIRECTOR";
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomFileUploadWidget(
                  selectedFile: state.otherDirectorAadharfrontSideAdharFile,
                  title: "Upload Front Side of Aadhaar Card",
                  onFileSelected: (fileData) {
                    context.read<BusinessAccountSetupBloc>().add(OtherDirectorFrontSlideAadharCardUpload(fileData!));
                  },
                  documentNumber: state.otherDirectorAadharNumberController.text,
                  documentType: "Aadhaar",
                  kycRole: otherDirectorKycRole,
                  screenName: "IDENTITY",
                ),
                buildSizedBoxH(24.0),
                CustomFileUploadWidget(
                  selectedFile: state.otherDirectorAadharBackSideAdharFile,
                  title: "Upload Back Side of Aadhaar Card",
                  onFileSelected: (fileData) {
                    context.read<BusinessAccountSetupBloc>().add(OtherDirectorBackSlideAadharCardUpload(fileData!));
                  },
                  documentNumber: state.otherDirectorAadharNumberController.text,
                  documentType: "Aadhaar",
                  kycRole: otherDirectorKycRole,
                  screenName: "IDENTITY",
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildNextButton() {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        return AnimatedBuilder(
          animation: Listenable.merge([
            state.otherDirectorPinCodeController,
            state.otherDirectorStateNameController,
            state.otherDirectorCityNameController,
            state.otherDirectorAddress1NameController,
            state.otherDirectorAadharNumberController,
          ]),
          builder: (context, child) {
            bool isButtonEnabled = false;

            final isAddressVerified =
                state.otherDirectorPinCodeController.text.isNotEmpty &&
                state.otherDirectorStateNameController.text.isNotEmpty &&
                state.otherDirectorCityNameController.text.isNotEmpty &&
                state.otherDirectorAddress1NameController.text.isNotEmpty;

            final isFileUploaded =
                state.otherDirectorAadharfrontSideAdharFile != null &&
                state.otherDirectorAadharBackSideAdharFile != null;

            // If Aadhaar number is entered and verified, enable button with file upload

            if (state.director2BeneficialOwner && state.isOtherDirectorAadharAddressSameAsResidentialAddress == false) {
              isButtonEnabled = isAddressVerified && isFileUploaded;
            } else {
              isButtonEnabled = isFileUploaded;
            }

            // Disable button if there are validation errors
            if ((state.directorAadhaarValidationErrorMessage ?? '').isNotEmpty) {
              isButtonEnabled = false;
            }

            return Align(
              alignment: Alignment.centerRight,
              child: CustomElevatedButton(
                isShowTooltip: true,
                text: Lang.of(context).lbl_save,
                borderRadius: 8.0,
                width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 120 : double.maxFinite,
                buttonTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                isDisabled: !isButtonEnabled,
                isLoading: state.isOtherDirectorAadharFileUploading,
                onPressed:
                    isButtonEnabled
                        ? () {
                          context.read<BusinessAccountSetupBloc>().add(OtherDirectorAadharFileUploadSubmitted());

                          if (!state.ditector1BusinessRepresentative && !state.ditector2BusinessRepresentative) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const BusinessRepresentativeSelectionDialog(),
                            );
                          } else {
                            GoRouter.of(context).pop();
                          }
                          // } else {
                          //   context.read<BusinessAccountSetupBloc>().add(OtherDirectorShowDialogWidthoutAadharUpload());
                          //   if (!state.ditector1BusinessRepresentative && !state.ditector2BusinessRepresentative) {
                          //     showDialog(
                          //       context: context,
                          //       barrierDismissible: false,
                          //       builder: (context) => const BusinessRepresentativeSelectionDialog(),
                          //     );
                          //   } else {
                          //     GoRouter.of(context).pop();
                          //   }
                          // }
                        }
                        : null,
                tooltipMessage: Lang.of(context).lbl_tooltip_text,
              ),
            );
          },
        );
      },
    );
  }

  String formatSecondsToMMSS(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  int _getCurrentStepNumber(OtherDirectorKycSteps step) {
    switch (step) {
      case OtherDirectorKycSteps.panDetails:
        return 1;
      case OtherDirectorKycSteps.aadharDetails:
        return 2;
    }
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
                  absorbing: state.isOtherDirectorOtpSent && state.otherDirectorCaptchaInputController.text.isNotEmpty,
                  child: CustomTextInputField(
                    context: context,
                    type: InputType.text,
                    controller: state.otherDirectorCaptchaInputController,
                    textInputAction: TextInputAction.done,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
                    onFieldSubmitted:
                        state.isOtherDirectorDirectorCaptchaLoading == true
                            ? null
                            : (value) async {
                              final isCaptchaValid = state.otherDirectorCaptchaInputController.text.isNotEmpty;

                              if (isCaptchaValid) {
                                final sessionId = await Prefobj.preferences.get(Prefkeys.sessionId) ?? '';
                                context.read<BusinessAccountSetupBloc>().add(
                                  OtherDirectorSendAadharOtp(
                                    state.otherDirectorAadharNumberController.text.trim(),
                                    state.otherDirectorCaptchaInputController.text.trim(),
                                    sessionId,
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

  Widget _buildVerifyAadharButton(BuildContext context, BusinessAccountSetupState state) {
    return Align(
      alignment: Alignment.centerRight,
      child: AnimatedBuilder(
        animation: Listenable.merge([state.otherDirectorAadharNumberController]),
        builder: (context, _) {
          bool isDisabled =
              ExchekValidations.validateAadhaar(
                    state.otherDirectorAadharNumberController.text.replaceAll("-", "").trim(),
                  ) !=
                  null ||
              ExchekValidations.validateDirectorAadhaarsAreDifferent(
                    state.aadharNumberController.text,
                    state.otherDirectorAadharNumberController.text,
                  ) !=
                  null;
          return CustomElevatedButton(
            text: Lang.of(context).lbl_verify,
            width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 150 : double.maxFinite,
            isShowTooltip: true,
            isLoading: state.isOtherDirectorDirectorCaptchaLoading ?? false,
            tooltipMessage: Lang.of(context).lbl_tooltip_text,
            isDisabled: isDisabled,
            borderRadius: 8.0,
            onPressed:
                isDisabled
                    ? null
                    : () {
                      final isValidAadhar =
                          ExchekValidations.validateAadhaar(
                            state.otherDirectorAadharNumberController.text.replaceAll("-", "").trim(),
                          ) ==
                          null;
                      final isValidDirector =
                          ExchekValidations.validateDirectorAadhaarsAreDifferent(
                            state.aadharNumberController.text,
                            state.otherDirectorAadharNumberController.text,
                          ) ==
                          null;
                      if (isValidAadhar && isValidDirector) {
                        context.read<BusinessAccountSetupBloc>().add(OtherDirectorCaptchaSend());
                      }
                    },
          );
        },
      ),
    );
  }

  Widget _buildIsResidentialRadioButtons(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_aadhar_address_residential_address,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 16),
            fontWeight: FontWeight.w400,
            height: 1.22,
          ),
        ),
        buildSizedBoxH(26.0),
        CustomRadioButton(
          title: Lang.of(context).lbl_yes_use_aadhaar_address,
          value: "yes",
          groupValue:
              state.isOtherDirectorAadharAddressSameAsResidentialAddress == true
                  ? "yes"
                  : state.isOtherDirectorAadharAddressSameAsResidentialAddress == false
                  ? "no"
                  : null,
          onChanged: (value) {
            context.read<BusinessAccountSetupBloc>().add(
              ChangeOtherDirectorAadharAddressSameAsResidentialAddress(value == "yes"),
            );
          },
        ),
        buildSizedBoxH(20.0),
        CustomRadioButton(
          title: Lang.of(context).lbl_no_use_my_residential_address,
          value: "no",
          groupValue:
              state.isOtherDirectorAadharAddressSameAsResidentialAddress == true
                  ? "yes"
                  : state.isOtherDirectorAadharAddressSameAsResidentialAddress == false
                  ? "no"
                  : null,
          onChanged: (value) {
            context.read<BusinessAccountSetupBloc>().add(
              ChangeOtherDirectorAadharAddressSameAsResidentialAddress(value == "yes"),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCountryField(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_country,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
            fontWeight: FontWeight.w400,
            height: 1.22,
          ),
        ),
        buildSizedBoxH(8.0),
        AbsorbPointer(
          absorbing: true,
          child: ExpandableCountryDropdownField(
            isDisable: true,
            selectedCountry: state.otherDirectorSelectedCountry,
            countryList: CountryService().getAll(),
            onChanged: (country) {
              context.read<BusinessAccountSetupBloc>().add(UpdateOtherDirectorSelectedCountry(country: country));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPinCodeField(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_pin_code,
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
          controller: state.otherDirectorPinCodeController,
          textInputAction: TextInputAction.next,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
          validator: ExchekValidations.validateRequired,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          suffixIcon: state.isAuthorizedCityAndStateLoading ? AppLoaderWidget(size: 20.0) : SizedBox.fromSize(),
          onChanged: (value) {
            if (value.length == 6 && ExchekValidations.validateRequired(value) == null) {
              context.read<BusinessAccountSetupBloc>().add(BusinessOtherDirectorGetCityAndState(value.trim()));
            }
          },
          onFieldSubmitted: (value) {
            if (ExchekValidations.validateRequired(state.otherDirectorPinCodeController.text) == null) {
              context.read<BusinessAccountSetupBloc>().add(
                BusinessOtherDirectorGetCityAndState(state.otherDirectorPinCodeController.text.trim()),
              );
            }
          },
          maxLength: 6,
          shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForRequiredValidation,
        ),
      ],
    );
  }

  Widget _buildStateCodeField(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_state,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
            fontWeight: FontWeight.w400,
            height: 1.22,
          ),
        ),
        buildSizedBoxH(8.0),
        AbsorbPointer(
          absorbing: true,
          child: CustomTextInputField(
            context: context,
            type: InputType.text,
            controller: state.otherDirectorStateNameController,
            textInputAction: TextInputAction.next,
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
            validator: ExchekValidations.validateRequired,
            shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForRequiredValidation,
          ),
        ),
      ],
    );
  }

  Widget _buildCityField(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_city,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
            fontWeight: FontWeight.w400,
            height: 1.22,
          ),
        ),
        buildSizedBoxH(8.0),
        AbsorbPointer(
          absorbing: true,
          child: CustomTextInputField(
            context: context,
            type: InputType.text,
            controller: state.otherDirectorCityNameController,
            textInputAction: TextInputAction.next,
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
            validator: ExchekValidations.validateRequired,
            shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForRequiredValidation,
          ),
        ),
      ],
    );
  }

  Widget _buildAddress1CodeField(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_address_line_1,
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
          controller: state.otherDirectorAddress1NameController,
          textInputAction: TextInputAction.next,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
          validator: ExchekValidations.validateRequired,
          shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForRequiredValidation,
        ),
      ],
    );
  }

  Widget _buildAddress2CodeField(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_address_line_2,
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
          controller: state.otherDirectorAddress2NameController,
          textInputAction: TextInputAction.next,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
        ),
      ],
    );
  }
}
