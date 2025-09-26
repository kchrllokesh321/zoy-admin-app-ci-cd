
import 'package:country_picker/country_picker.dart';
import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/widgets/account_setup_widgets/aadhar_upload_note.dart';
import 'package:exchek/widgets/account_setup_widgets/captcha_image.dart';
import 'package:exchek/widgets/account_setup_widgets/country_picker_field.dart';

class AuthorizedDirectorKycDialog extends StatelessWidget {
  const AuthorizedDirectorKycDialog({super.key});

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
                    title = "Authorized Partner KYC";
                  } else {
                    title = "Authorized Director KYC";
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

  Widget divider(BuildContext context) =>
      Container(height: 1.5, width: double.maxFinite, color: Theme.of(context).customColors.lightBorderColor);

  Widget _buildStepContent(BuildContext context, BusinessAccountSetupState state) {
    switch (state.directorKycStep) {
      case DirectorKycSteps.panDetails:
        return _buildPanDetailsStep(context, state);
      case DirectorKycSteps.aadharDetails:
        return _buildAadharDetailsStep(context, state);
    }
  }

  Widget _buildPanDetailsStep(BuildContext context, BusinessAccountSetupState state) {
    return Form(
      key: state.directorsPanVerificationKey,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            buildSizedBoxH(30.0),
            _buildContentTitle(context, "PAN Details"),
            buildSizedBoxH(22.0),
            _buildDirector1PanNumberField(context, state),
            if ((state.director1PanDetailsErrorMessage ?? '').isNotEmpty) ...[
              CommanErrorMessage(errorMessage: state.director1PanDetailsErrorMessage ?? ''),
            ],
            if ((state.director1PanEditErrorMessage ?? '').isNotEmpty) ...[
              buildSizedBoxH(5.0),
              CommanErrorMessage(errorMessage: state.director1PanEditErrorMessage ?? ''),
            ],
            if ((state.directorPANValidationErrorMessage ?? '').isNotEmpty) ...[
              buildSizedBoxH(5.0),
              CommanErrorMessage(errorMessage: state.directorPANValidationErrorMessage ?? ''),
            ],
            if (state.isDirector1PanDetailsVerified == true) ...[
              buildSizedBoxH(24.0),
              _buildDirector1PanName(context, state),
            ],
            buildSizedBoxH(24.0),
            _buildDirector1UploadPanCard(context, state),
            buildSizedBoxH(8.0),
            _buildDirector1IsBeneficialOwner(context, state),
            buildSizedBoxH(8.0),
            _buildDirector1BusinessRepresentative(context, state),
            buildSizedBoxH(8.0),
            buildSizedBoxH(30.0),
            _buildBusinessPanSaveButton(context, state),
            buildSizedBoxH(30.0),
          ],
        ),
      ),
    );
  }

  Widget _buildAadharDetailsStep(BuildContext context, BusinessAccountSetupState state) {
    if (state.isAadharVerified == false) {
      return _buildIsNotAadharVerify(context, state);
    } else {
      return _buildIsAadharVerify(context, state);
    }
  }

  Widget _buildBusinessPanSaveButton(BuildContext context, BusinessAccountSetupState state) {
    return AnimatedBuilder(
      animation: Listenable.merge([state.director1PanNumberController]),
      builder: (context, _) {
        final isDisable =
            !(state.director1PanCardFile != null &&
                ExchekValidations.validatePANByType(state.director1PanNumberController.text, "INDIVIDUAL") == null &&
                (state.fullDirector1NamePan ?? '').isNotEmpty &&
                state.isDirector1PanDetailsVerified == true) ||
            (state.directorPANValidationErrorMessage ?? '').isNotEmpty;
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
            isLoading: state.isDirectorPanCardSaveLoading ?? false,
            isDisabled: isDisable,
            tooltipMessage: Lang.of(context).lbl_tooltip_text,
            onPressed:
                isDisable
                    ? null
                    : () {
                      if (state.directorsPanVerificationKey.currentState?.validate() ?? false) {
                        context.read<BusinessAccountSetupBloc>().add(
                          SaveDirectorPanDetails(
                            director1fileData: state.director1PanCardFile,
                            director1panName: state.director1PanNameController.text,
                            director1panNumber: state.director1PanNumberController.text,
                          ),
                        );
                      }
                    },
          ),
        );
      },
    );
  }

  Widget _buildDirector1PanNumberField(BuildContext context, BusinessAccountSetupState state) {
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
            if (state.isDirector1PanEditLocked || state.isDirector1PanModifiedAfterVerification) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: GestureDetector(
                  onTap: () {
                    // Store original PAN number before enabling edit
                    context.read<BusinessAccountSetupBloc>().add(
                      BusinessStoreOriginalDirector1PanNumber(state.director1PanNumberController.text),
                    );
                    if (!state.isDirector1PanEditLocked) {
                      TextFieldUtils.focusAndMoveCursorToEnd(
                        context: context,
                        focusNode: state.director1PanNumberFocusNode,
                        controller: state.director1PanNumberController,
                      );
                    }
                    // Set modification flag when user clicks edit
                    context.read<BusinessAccountSetupBloc>().add(
                      Director1PanNumberChanged(state.director1PanNumberController.text),
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
          absorbing: state.isDirector1PanEditLocked || state.isDirector1PanModifiedAfterVerification,
          child: CustomTextInputField(
            context: context,
            type: InputType.text,
            controller: state.director1PanNumberController,
            textInputAction: TextInputAction.done,
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
            validator: (value) {
              return ExchekValidations.validatePANByType(value, "INDIVIDUAL");
            },
            shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForPANValidation,
            maxLength: 10,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: [UpperCaseTextFormatter(), NoPasteFormatter()],
            onChanged: (value) {
              // Mark data as changed for PAN details only if value differs from original
              if (value != state.originalDirector1PanNumber) {
                context.read<BusinessAccountSetupBloc>().add(MarkPanDetailsDataChanged());
              }
              if (!state.isDirector1PanEditLocked) {
                context.read<BusinessAccountSetupBloc>().add(Director1PanNumberChanged(value));
                if (value.length == 10) {
                  FocusScope.of(context).unfocus();
                  if (ExchekValidations.validatePANByType(state.director1PanNumberController.text, "INDIVIDUAL") ==
                          null &&
                      ExchekValidations.validateDirectorPANsAreDifferent(
                            value,
                            state.director2PanNumberController.text,
                          ) ==
                          null) {
                    context.read<BusinessAccountSetupBloc>().add(
                      GetDirector1PanDetails(state.director1PanNumberController.text),
                    );
                  }
                }
              }
            },
            suffixIcon: state.isDirector1PanDetailsLoading == true ? AppLoaderWidget(size: 20) : null,

            onFieldSubmitted: (value) {
              if (!state.isDirector1PanEditLocked) {
                final panValidation = ExchekValidations.validatePANByType(
                  state.director1PanNumberController.text,
                  "INDIVIDUAL",
                );
                final directorValidation = ExchekValidations.validateDirectorPANsAreDifferent(
                  value,
                  state.director2PanNumberController.text,
                );
                if (panValidation == null && directorValidation == null) {
                  FocusScope.of(context).unfocus();
                  context.read<BusinessAccountSetupBloc>().add(
                    GetDirector1PanDetails(state.director1PanNumberController.text),
                  );
                }
              }
            },
            contextMenuBuilder: customContextMenuBuilder,
            focusNode: state.director1PanNumberFocusNode,
          ),
        ),
      ],
    );
  }

  Widget _buildDirector1UploadPanCard(BuildContext context, BusinessAccountSetupState state) {
    return FutureBuilder<String?>(
      future: KycStepUtils.getBusinessType(),
      builder: (context, snapshot) {
        String businessType = snapshot.data ?? '';
        String title;
        if (businessType == 'limited_liability_partnership' || businessType == 'partnership') {
          title = "Upload Partner 1 PAN Card";
        } else {
          title = "Upload Director 1 PAN Card";
        }
        String authKycRole = '';
        if (businessType == 'limited_liability_partnership' || businessType == 'partnership') {
          authKycRole = "AUTH_PARTNER";
        } else {
          authKycRole = "AUTH_DIRECTOR";
        }
        return CustomFileUploadWidget(
          title: title,
          selectedFile: state.director1PanCardFile,
          onFileSelected: (fileData) {
            context.read<BusinessAccountSetupBloc>().add(Director1UploadPanCard(fileData));
            // Mark data as changed for PAN details
            context.read<BusinessAccountSetupBloc>().add(MarkPanDetailsDataChanged());
          },
          documentNumber: state.director1PanNumberController.text,
          documentType: "",
          kycRole: authKycRole,
          screenName: "PAN",
        );
      },
    );
  }

  Widget _buildDirector1IsBeneficialOwner(BuildContext context, BusinessAccountSetupState state) {
    return CustomCheckBoxLabel(
      isSelected: state.director1BeneficialOwner,
      label: Lang.of(context).lbl_this_person_beneficial_owner,
      onChanged: () {
        context.read<BusinessAccountSetupBloc>().add(
          ChangeDirector1IsBeneficialOwner(isSelected: !state.director1BeneficialOwner),
        );
      },
      isShowInfoIcon: true,
      tooltipMessage: Lang.of(context).lbl_tooltip_message_of_beneficial_owner,
    );
  }

  Widget _buildDirector1BusinessRepresentative(BuildContext context, BusinessAccountSetupState state) {
    // If director 2 is already selected as business representative, show disabled state
    if (state.ditector2BusinessRepresentative) {
      return SizedBox();
    }

    return CustomCheckBoxLabel(
      isSelected: state.ditector1BusinessRepresentative,
      label: Lang.of(context).lbl_also_business_representative,
      onChanged: () {
        context.read<BusinessAccountSetupBloc>().add(
          ChangeDirector1IsBusinessRepresentative(isSelected: !state.ditector1BusinessRepresentative),
        );
      },
      isShowInfoIcon: true,
      tooltipMessage: Lang.of(context).lbl_tooltip_message_of_owner_representative,
    );
  }

  Widget _buildContentTitle(BuildContext context, String title) {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        return Row(
          children: [
            if (state.directorKycStep == DirectorKycSteps.aadharDetails) ...[
              CustomImageView(
                imagePath: Assets.images.svgs.icons.icArrowLeft.path,
                height: 24.0,
                onTap: () {
                  context.read<BusinessAccountSetupBloc>().add(DirectorKycStepChanged(DirectorKycSteps.panDetails));
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
              "${_getCurrentStepNumber(state.directorKycStep)}/2",
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

  int _getCurrentStepNumber(DirectorKycSteps step) {
    switch (step) {
      case DirectorKycSteps.panDetails:
        return 1;
      case DirectorKycSteps.aadharDetails:
        return 2;
    }
  }

  // Widget _buildVerifyDirector1PanButton(BuildContext context, BusinessAccountSetupState state) {
  //   return Align(
  //     alignment: Alignment.centerRight,
  //     child: AnimatedBuilder(
  //       animation: Listenable.merge([state.director1PanNumberController]),
  //       builder: (context, _) {
  //         bool isDisabled =
  //             ExchekValidations.validatePANByType(state.director1PanNumberController.text, "INDIVIDUAL") != null;
  //         return CustomElevatedButton(
  //           text: Lang.of(context).lbl_verify,
  //           width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 130 : double.maxFinite,
  //           isShowTooltip: true,
  //           isLoading: state.isDirector1PanDetailsLoading,
  //           tooltipMessage: Lang.of(context).lbl_tooltip_text,
  //           isDisabled: isDisabled,
  //           borderRadius: 8.0,
  //           onPressed: () {
  //             if (ExchekValidations.validatePANByType(state.director1PanNumberController.text, "INDIVIDUAL") == null) {
  //               context.read<BusinessAccountSetupBloc>().add(
  //                 GetDirector1PanDetails(state.director1PanNumberController.text),
  //               );
  //             }
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget _buildDirector1PanName(BuildContext context, BusinessAccountSetupState state) {
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
        CommanVerifiedInfoBox(value: state.fullDirector1NamePan ?? '', showTrailingIcon: true),
      ],
    );
  }

  Widget _buildIsAadharVerify(BuildContext context, BusinessAccountSetupState state) {
    return Form(
      key: state.aadharVerificationFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSizedBoxH(30.0),
          _buildContentTitle(context, "Aadhaar Details "),
          buildSizedBoxH(22.0),
          _buildVerifyAadharNumber(context, state),
          buildSizedBoxH(24.0),
          UploadNote(notes: [Lang.of(context).lbl_note_1, Lang.of(context).lbl_note_2]),
          buildSizedBoxH(24.0),
          _buildUploadAddharCard(context),
          buildSizedBoxH(30.0),
          FutureBuilder<String?>(
            future: Prefobj.preferences.get(Prefkeys.userKycDetail),
            builder: (context, snapshot) {
              // final userDetail = jsonDecode(snapshot.data!);
              // final List multicurrency = userDetail['multicurrency'] ?? [];
              //  multicurrency.length > 1 &&

              return (state.director1BeneficialOwner == true)
                  ? Column(
                    children: [
                      _buildIsResidentialRadioButtons(context, state),
                      if (state.isAadharAddressSameAsResidentialAddress == false) ...[
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

          buildSizedBoxH(20.0),
          _buildNextButton(),
          buildSizedBoxH(30.0),
        ],
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
              state.isAadharAddressSameAsResidentialAddress == true
                  ? "yes"
                  : state.isAadharAddressSameAsResidentialAddress == false
                  ? "no"
                  : null,
          onChanged: (value) {
            context.read<BusinessAccountSetupBloc>().add(ChangeAadharAddressSameAsResidentialAddress(value == "yes"));
          },
        ),
        buildSizedBoxH(20.0),
        CustomRadioButton(
          title: Lang.of(context).lbl_no_use_my_residential_address,
          value: "no",
          groupValue:
              state.isAadharAddressSameAsResidentialAddress == true
                  ? "yes"
                  : state.isAadharAddressSameAsResidentialAddress == false
                  ? "no"
                  : null,
          onChanged: (value) {
            context.read<BusinessAccountSetupBloc>().add(ChangeAadharAddressSameAsResidentialAddress(value == "yes"));
          },
        ),
      ],
    );
  }

  Widget _buildIsNotAadharVerify(BuildContext context, BusinessAccountSetupState state) {
    return Form(
      key: state.aadharVerificationFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSizedBoxH(30.0),
          _buildContentTitle(context, "Aadhaar Details"),
          buildSizedBoxH(22.0),
          // Header with title and Edit
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
              if (state.isDirectorCaptchaSend || state.isOtpSent)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: InkWell(
                    mouseCursor: SystemMouseCursors.click,
                    onTap: () {
                      // Store original Aadhaar number before enabling edit
                      context.read<BusinessAccountSetupBloc>().add(
                        BusinessStoreOriginalDirector1AadharNumber(state.aadharNumberController.text),
                      );
                      // Reset captcha/OTP for director, keep aadhar, then focus field
                      context.read<BusinessAccountSetupBloc>().add(const DirectorEnableAadharEdit());
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        TextFieldUtils.focusAndMoveCursorToEnd(
                          context: context,
                          focusNode: state.directorAadharNumberFocusNode,
                          controller: state.aadharNumberController,
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
          if (!state.isDirectorCaptchaSend && !state.isOtpSent) buildSizedBoxH(20),
          if (!state.isDirectorCaptchaSend && !state.isOtpSent) _buildVerifyAadharButton(context, state),
          if (state.isDirectorCaptchaSend) ...[
            buildSizedBoxH(24.0),
            Builder(
              builder: (context) {
                if (state.directorCaptchaImage != null) {
                  return Column(
                    children: [
                      Row(
                        spacing: 20.0,
                        children: [
                          Base64CaptchaField(base64Image: state.directorCaptchaImage ?? ''),
                          AbsorbPointer(
                            absorbing: state.isOtpSent,
                            child: Opacity(
                              opacity: state.isOtpSent ? 0.5 : 1.0,
                              child: CustomImageView(
                                imagePath: Assets.images.svgs.icons.icRefresh.path,
                                height: 40.0,
                                width: 40.0,
                                onTap: () async {
                                  context.read<BusinessAccountSetupBloc>().add(DirectorReCaptchaSend());
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
            if (state.isAadharOTPInvalidate.isNotEmpty) ...[
              buildSizedBoxH(10),
              Text(
                state.isAadharOTPInvalidate,
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
          buildSizedBoxH(30.0),
        ],
      ),
    );
  }

  Widget _buildAadharNumberField(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AbsorbPointer(
          absorbing: state.isDirectorCaptchaSend,
          child: CustomTextInputField(
            context: context,
            type: InputType.digits,
            focusNode: state.directorAadharNumberFocusNode,
            controller: state.aadharNumberController,
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
                value,
                state.otherDirectorAadharNumberController.text,
              );
              return directorValidation;
            },
            shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForAadhaarValidation,
            onChanged: (value) {
              context.read<BusinessAccountSetupBloc>().add(DirectorAadharNumberChanged(value));
              // Mark data as changed for identity verification only if value differs from original
              if (value != state.originalDirector1AadharNumber) {
                context.read<BusinessAccountSetupBloc>().add(MarkIdentityVerificationDataChanged());
              }
            },
            onFieldSubmitted: (value) {
              final isValidAadhar = state.aadharNumberController.text.trim().length == 14;
              if (isValidAadhar) {
                final validationError = ExchekValidations.validateDirectorAadhaarsAreDifferent(
                  value,
                  state.otherDirectorAadharNumberController.text,
                );
                if (validationError == null) {
                  context.read<BusinessAccountSetupBloc>().add(DirectorCaptchaSend());
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
        animation: Listenable.merge([state.aadharNumberController, state.directorCaptchaInputController]),
        builder: (context, child) {
          final isValidAadhar =
              state.aadharNumberController.text.trim().length == 14 &&
              state.directorCaptchaInputController.text.trim().isNotEmpty;
          return CustomElevatedButton(
            text: Lang.of(context).lbl_request_OTP,
            width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 150 : double.maxFinite,
            isShowTooltip: true,
            tooltipMessage: Lang.of(context).lbl_tooltip_text,
            isLoading: state.isDirectorAadharOtpLoading,
            isDisabled: !isValidAadhar,
            borderRadius: 8.0,
            onPressed:
                isValidAadhar
                    ? () async {
                      final sessionId = await Prefobj.preferences.get(Prefkeys.sessionId) ?? '';
                      context.read<BusinessAccountSetupBloc>().add(
                        SendAadharOtp(
                          state.aadharNumberController.text.trim(),
                          state.directorCaptchaInputController.text.trim(),
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
                              FocusManager.instance.primaryFocus?.unfocus();
                              final sessionId = await Prefobj.preferences.get(Prefkeys.sessionId) ?? '';
                              BlocProvider.of<BusinessAccountSetupBloc>(context).add(
                                SendAadharOtp(
                                  state.aadharNumberController.text.trim(),
                                  state.directorCaptchaInputController.text.trim(),
                                  sessionId,
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
                  context.read<BusinessAccountSetupBloc>().add(
                    AadharNumbeVerified(state.aadharNumberController.text, state.aadharOtpController.text),
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
        animation: Listenable.merge([state.aadharOtpController, state.aadharNumberController]),
        builder: (context, child) {
          final isDisable = state.aadharOtpController.text.isEmpty || state.aadharOtpController.text.isEmpty;
          return CustomElevatedButton(
            text: Lang.of(context).lbl_confirm_and_next,
            width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 150 : double.maxFinite,
            isShowTooltip: true,
            isLoading: state.isAadharVerifiedLoading ?? false,
            tooltipMessage: Lang.of(context).lbl_tooltip_text,
            isDisabled: isDisable,
            borderRadius: 8.0,
            onPressed:
                isDisable
                    ? null
                    : () {
                      if (state.aadharVerificationFormKey.currentState?.validate() ?? false) {
                        context.read<BusinessAccountSetupBloc>().add(
                          AadharNumbeVerified(state.aadharNumberController.text, state.aadharOtpController.text),
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
                  AadhaarMaskUtils.maskAadhaarNumber(state.aadharNumber ?? ''),
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
            String authKycRole = '';
            if (businessType == 'limited_liability_partnership' || businessType == 'partnership') {
              authKycRole = "AUTH_PARTNER";
            } else {
              authKycRole = "AUTH_DIRECTOR";
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomFileUploadWidget(
                  selectedFile: state.frontSideAdharFile,
                  title: "Upload Front Side of Aadhaar Card",
                  onFileSelected: (fileData) {
                    context.read<BusinessAccountSetupBloc>().add(FrontSlideAadharCardUpload(fileData));
                    // Mark data as changed for identity verification
                    context.read<BusinessAccountSetupBloc>().add(MarkIdentityVerificationDataChanged());
                  },
                  documentNumber: state.aadharNumberController.text,
                  documentType: "Aadhaar",
                  kycRole: authKycRole,
                  screenName: "IDENTITY",
                ),
                buildSizedBoxH(24.0),
                CustomFileUploadWidget(
                  selectedFile: state.backSideAdharFile,
                  title: "Upload Back Side of Aadhaar Card",
                  onFileSelected: (fileData) {
                    context.read<BusinessAccountSetupBloc>().add(BackSlideAadharCardUpload(fileData));
                    // Mark data as changed for identity verification
                    context.read<BusinessAccountSetupBloc>().add(MarkIdentityVerificationDataChanged());
                  },
                  documentNumber: state.aadharNumberController.text,
                  documentType: "Aadhaar",
                  kycRole: authKycRole,
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
            state.authorizedPinCodeController,
            state.authorizedStateNameController,
            state.authorizedCityNameController,
            state.authorizedAddress1NameController,
            state.authorizedAddress2NameController,
          ]),
          builder: (context, _) {
            bool isButtonEnabled = false;

            final isAddressVerified =
                state.authorizedPinCodeController.text.isNotEmpty &&
                state.authorizedStateNameController.text.isNotEmpty &&
                state.authorizedCityNameController.text.isNotEmpty &&
                state.authorizedAddress1NameController.text.isNotEmpty;

            final isFileUploaded = state.frontSideAdharFile != null && state.backSideAdharFile != null;
            if (state.director1BeneficialOwner && state.isAadharAddressSameAsResidentialAddress == false) {
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
                isLoading: state.isAadharFileUploading,
                onPressed:
                    isButtonEnabled
                        ? () {
                          context.read<BusinessAccountSetupBloc>().add(
                            AadharFileUploadSubmitted(
                              frontAadharFileData: state.frontSideAdharFile!,
                              backAadharFileData: state.backSideAdharFile!,
                            ),
                          );
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
                  absorbing: state.isOtpSent && state.directorCaptchaInputController.text.isNotEmpty,
                  child: CustomTextInputField(
                    context: context,
                    type: InputType.text,
                    controller: state.directorCaptchaInputController,
                    textInputAction: TextInputAction.done,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
                    onFieldSubmitted:
                        state.isDirectorCaptchaLoading == true
                            ? null
                            : (value) async {
                              final isCaptchaValid = state.directorCaptchaInputController.text.isNotEmpty;

                              if (isCaptchaValid) {
                                final sessionId = await Prefobj.preferences.get(Prefkeys.sessionId) ?? '';
                                context.read<BusinessAccountSetupBloc>().add(
                                  SendAadharOtp(
                                    state.aadharNumberController.text.trim(),
                                    state.directorCaptchaInputController.text.trim(),
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
        animation: Listenable.merge([state.aadharNumberController]),
        builder: (context, _) {
          bool isDisabled =
              ExchekValidations.validateAadhaar(state.aadharNumberController.text.replaceAll("-", "").trim()) != null ||
              ExchekValidations.validateDirectorAadhaarsAreDifferent(
                    state.aadharNumberController.text,
                    state.otherDirectorAadharNumberController.text,
                  ) !=
                  null;
          return CustomElevatedButton(
            text: Lang.of(context).lbl_verify,
            width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 150 : double.maxFinite,
            isShowTooltip: true,
            isLoading: state.isDirectorCaptchaLoading ?? false,
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
                      final isValidDirector =
                          ExchekValidations.validateDirectorAadhaarsAreDifferent(
                            state.aadharNumberController.text,
                            state.otherDirectorAadharNumberController.text,
                          ) ==
                          null;
                      if (isValidAadhar && isValidDirector) {
                        context.read<BusinessAccountSetupBloc>().add(DirectorCaptchaSend());
                      }
                    },
          );
        },
      ),
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
            selectedCountry: state.authorizedSelectedCountry,
            countryList: CountryService().getAll(),
            onChanged: (country) {
              context.read<BusinessAccountSetupBloc>().add(UpdateAuthorizedSelectedCountry(country: country));
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
          controller: state.authorizedPinCodeController,
          textInputAction: TextInputAction.next,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
          validator: ExchekValidations.validateRequired,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          suffixIcon: state.isAuthorizedCityAndStateLoading ? AppLoaderWidget(size: 20.0) : SizedBox.fromSize(),
          onChanged: (value) {
            // Mark data as changed for residential address
            context.read<BusinessAccountSetupBloc>().add(MarkResidentialAddressDataChanged());
            if (value.length == 6 && ExchekValidations.validateRequired(value) == null) {
              context.read<BusinessAccountSetupBloc>().add(BusinessAuthorizedGetCityAndState(value.trim()));
            }
          },
          onFieldSubmitted: (value) {
            if (ExchekValidations.validateRequired(state.authorizedPinCodeController.text) == null) {
              context.read<BusinessAccountSetupBloc>().add(
                BusinessAuthorizedGetCityAndState(state.authorizedPinCodeController.text.trim()),
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
            controller: state.authorizedStateNameController,
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
            controller: state.authorizedCityNameController,
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
          controller: state.authorizedAddress1NameController,
          textInputAction: TextInputAction.next,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
          validator: ExchekValidations.validateRequired,
          shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForRequiredValidation,
          onChanged: (value) {
            // Mark data as changed for residential address
            context.read<BusinessAccountSetupBloc>().add(MarkResidentialAddressDataChanged());
          },
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
          controller: state.authorizedAddress2NameController,
          textInputAction: TextInputAction.next,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
          onChanged: (value) {
            // Mark data as changed for residential address
            context.read<BusinessAccountSetupBloc>().add(MarkResidentialAddressDataChanged());
          },
        ),
      ],
    );
  }
}
