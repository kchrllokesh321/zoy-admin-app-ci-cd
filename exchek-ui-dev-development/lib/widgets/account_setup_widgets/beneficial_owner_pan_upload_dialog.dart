
import 'package:country_picker/country_picker.dart';
import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/widgets/account_setup_widgets/country_picker_field.dart';

class BeneficialOwnerPanUploadDialog extends StatelessWidget {
  const BeneficialOwnerPanUploadDialog({super.key});

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
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildSizedBoxH(25.0),
                _buildDialogHeader(context),
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

  Widget _buildDialogHeader(BuildContext context) {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        return Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: ResponsiveHelper.getMaxDialogWidth(context)),
            padding: ResponsiveHelper.getDialogPadding(context),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Beneficial Owner KYC",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: ResponsiveHelper.getFontSize(context, mobile: 20, tablet: 22, desktop: 24),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.24,
                    ),
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
      },
    );
  }

  Widget _buildStepContent(BuildContext context, BusinessAccountSetupState state) {
    switch (state.beneficialOwnerKycStep) {
      case BeneficialOwnerKycSteps.panDetails:
        return _buildPanDetailsStep(context, state);
      case BeneficialOwnerKycSteps.addressDetails:
        return _buildAddressDetailsStep(context, state);
    }
  }

  Widget _buildPanDetailsStep(BuildContext context, BusinessAccountSetupState state) {
    return Form(
      key: state.beneficialOwnerPanVerificationKey,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            buildSizedBoxH(20.0),
            _buildContentTitle(context, "PAN Details"),
            buildSizedBoxH(22.0),
            _buildBeneficialPanNumberField(context, state),
            if ((state.beneficialOwnerPanDetailsErrorMessage ?? '').isNotEmpty) ...[
              CommanErrorMessage(errorMessage: state.beneficialOwnerPanDetailsErrorMessage ?? ''),
            ],
            if ((state.beneficialOwnerPanEditErrorMessage ?? '').isNotEmpty) ...[
              buildSizedBoxH(5.0),
              CommanErrorMessage(errorMessage: state.beneficialOwnerPanEditErrorMessage ?? ''),
            ],
            if (state.isBeneficialOwnerPanDetailsVerified == true) ...[
              buildSizedBoxH(24.0),
              _buildBaneficialOwnerPanNameField(context, state),
            ],
            buildSizedBoxH(24.0),
            _buildBeneficialUploadPanCard(context, state),
            buildSizedBoxH(44.0),
            _buildBusinessPanSaveButton(),
            buildSizedBoxH(ResponsiveHelper.isWebAndIsNotMobile(context) ? 60.0 : 20.0),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressDetailsStep(BuildContext context, BusinessAccountSetupState state) {
    return Form(
      key: state.beneficialOwnerPanVerificationKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSizedBoxH(20.0),
          _buildContentTitle(context, "Residential Address"),
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
          buildSizedBoxH(30.0),
          _buildNextButton(),
          buildSizedBoxH(36.0),
        ],
      ),
    );
  }

  Widget divider(BuildContext context) =>
      Container(height: 1.5, width: double.maxFinite, color: Theme.of(context).customColors.borderColor);

  Widget _buildBeneficialPanNumberField(BuildContext context, BusinessAccountSetupState state) {
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
            if (state.isBeneficialOwnerPanEditLocked || state.isBeneficialOwnerPanModifiedAfterVerification) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: GestureDetector(
                  onTap: () {
                    if (!state.isBeneficialOwnerPanEditLocked) {
                      TextFieldUtils.focusAndMoveCursorToEnd(
                        context: context,
                        focusNode: state.beneficialOwnerPanNumberFocusNode,
                        controller: state.beneficialOwnerPanNumberController,
                      );
                    }
                    // Set modification flag when user clicks edit
                    context.read<BusinessAccountSetupBloc>().add(
                      BeneficialOwnerPanNumberChanged(state.beneficialOwnerPanNumberController.text),
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
          absorbing: state.isBeneficialOwnerPanEditLocked || state.isBeneficialOwnerPanModifiedAfterVerification,
          child: CustomTextInputField(
            context: context,
            type: InputType.text,
            controller: state.beneficialOwnerPanNumberController,
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
              if (!state.isBeneficialOwnerPanEditLocked) {
                context.read<BusinessAccountSetupBloc>().add(BeneficialOwnerPanNumberChanged(value));
                if (value.length == 10) {
                  FocusScope.of(context).unfocus();
                  state.beneficialOwnerPanVerificationKey.currentState?.validate();
                  if (ExchekValidations.validatePANByType(value, "INDIVIDUAL") == null) {
                    context.read<BusinessAccountSetupBloc>().add(GetBeneficialOwnerPanDetails(value));
                  }
                }
              }
            },
            suffixIcon: state.isBeneficialOwnerPanDetailsLoading == true ? AppLoaderWidget(size: 20) : null,
            onFieldSubmitted: (value) {
              if (!state.isBeneficialOwnerPanEditLocked) {
                state.beneficialOwnerPanVerificationKey.currentState?.validate();
                if (ExchekValidations.validatePANByType(state.beneficialOwnerPanNumberController.text, "INDIVIDUAL") ==
                    null) {
                  FocusScope.of(context).unfocus();
                  context.read<BusinessAccountSetupBloc>().add(
                    GetBeneficialOwnerPanDetails(state.beneficialOwnerPanNumberController.text),
                  );
                }
              }
            },
            contextMenuBuilder: customContextMenuBuilder,
            focusNode: state.beneficialOwnerPanNumberFocusNode,
          ),
        ),
      ],
    );
  }

  Widget _buildBeneficialUploadPanCard(BuildContext context, BusinessAccountSetupState state) {
    return CustomFileUploadWidget(
      title: "Upload Beneficial Owner PAN Card",
      selectedFile: state.beneficialOwnerPanCardFile,
      onFileSelected: (fileData) {
        context.read<BusinessAccountSetupBloc>().add(BeneficialOwnerUploadPanCard(fileData));
      },
      documentNumber: state.beneficialOwnerPanNumberController.text,
      documentType: "",
      kycRole: "OWNER",
      screenName: "PAN",
    );
  }

  // Widget _buildBeneficialOwnerIsDirector(BuildContext context, BusinessAccountSetupState state) {
  //   return CustomCheckBoxLabel(
  //     isSelected: state.beneficialOwnerIsDirector,
  //     label: Lang.of(context).lbl_director_person,
  //     onChanged: () {
  //       context.read<BusinessAccountSetupBloc>().add(
  //         ChangeBeneficialOwnerIsDirector(isSelected: !state.beneficialOwnerIsDirector),
  //       );
  //     },
  //   );
  // }

  // Widget _buildBeneficialOwnerBusinessRepresentative(BuildContext context, BusinessAccountSetupState state) {
  //   return CustomCheckBoxLabel(
  //     isSelected: state.benificialOwnerBusinessRepresentative,
  //     label: Lang.of(context).lbl_business_Representative,
  //     onChanged: () {
  //       context.read<BusinessAccountSetupBloc>().add(
  //         ChangeBeneficialOwnerIsBusinessRepresentative(isSelected: !state.benificialOwnerBusinessRepresentative),
  //       );
  //     },
  //   );
  // }

  Widget _buildBusinessPanSaveButton() {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        final isDisable =
            !(state.beneficialOwnerPanCardFile != null &&
                ExchekValidations.validatePANByType(state.beneficialOwnerPanNumberController.text, "INDIVIDUAL") ==
                    null &&
                (state.fullBeneficialOwnerNamePan ?? '').isNotEmpty &&
                state.isBeneficialOwnerPanDetailsVerified == true);
        return Align(
          alignment: Alignment.centerRight,
          child: CustomElevatedButton(
            isShowTooltip: true,
            text: Lang.of(context).save_and_next,
            borderRadius: 8.0,
            width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 125 : double.maxFinite,
            buttonTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            isLoading: state.isBeneficialOwnerPanCardSaveLoading ?? false,
            isDisabled: isDisable,
            tooltipMessage: Lang.of(context).lbl_tooltip_text,
            onPressed:
                isDisable
                    ? null
                    : () {
                      if (state.beneficialOwnerPanVerificationKey.currentState?.validate() ?? false) {
                        context.read<BusinessAccountSetupBloc>().add(
                          SaveBeneficialOwnerPanDetails(
                            fileData: state.beneficialOwnerPanCardFile,
                            panName: state.beneficialOwnerPanNameController.text,
                            panNumber: state.beneficialOwnerPanNumberController.text,
                          ),
                        );
                        // Navigate to next step
                      }
                    },
          ),
        );
      },
    );
  }

  // Widget _buildVerifyPanButton(BuildContext context, BusinessAccountSetupState state) {
  //   return Align(
  //     alignment: Alignment.centerRight,
  //     child: AnimatedBuilder(
  //       animation: Listenable.merge([state.beneficialOwnerPanNumberController]),
  //       builder: (context, _) {
  //         bool isDisabled =
  //             ExchekValidations.validatePANByType(state.beneficialOwnerPanNumberController.text, "INDIVIDUAL") != null;
  //         return CustomElevatedButton(
  //           text: Lang.of(context).lbl_verify,
  //           width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 125 : double.maxFinite,
  //           isShowTooltip: true,
  //           isLoading: state.isBeneficialOwnerPanDetailsLoading,
  //           tooltipMessage: Lang.of(context).lbl_tooltip_text,
  //           isDisabled: isDisabled,
  //           borderRadius: 8.0,
  //           onPressed: () {
  //             // Show validation error if any
  //             state.beneficialOwnerPanVerificationKey.currentState?.validate();
  //             if (ExchekValidations.validatePANByType(state.beneficialOwnerPanNumberController.text, "INDIVIDUAL") ==
  //                 null) {
  //               context.read<BusinessAccountSetupBloc>().add(
  //                 GetBeneficialOwnerPanDetails(state.beneficialOwnerPanNumberController.text),
  //               );
  //             }
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget _buildBaneficialOwnerPanNameField(BuildContext context, BusinessAccountSetupState state) {
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
        CommanVerifiedInfoBox(value: state.fullBeneficialOwnerNamePan ?? '', showTrailingIcon: true),
      ],
    );
  }

  Widget _buildContentTitle(BuildContext context, String title) {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        return Row(
          children: [
            if (state.beneficialOwnerKycStep == BeneficialOwnerKycSteps.addressDetails) ...[
              CustomImageView(
                imagePath: Assets.images.svgs.icons.icArrowLeft.path,
                height: 24.0,
                onTap: () {
                  context.read<BusinessAccountSetupBloc>().add(
                    BeneficialOwnerKycStepChanged(BeneficialOwnerKycSteps.panDetails),
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
              "${_getCurrentStepNumber(state.beneficialOwnerKycStep)}/2",
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

  int _getCurrentStepNumber(BeneficialOwnerKycSteps step) {
    switch (step) {
      case BeneficialOwnerKycSteps.panDetails:
        return 1;
      case BeneficialOwnerKycSteps.addressDetails:
        return 2;
    }
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
            selectedCountry: state.beneficialOwnerSelectedCountry,
            countryList: CountryService().getAll(),
            onChanged: (country) {
              context.read<BusinessAccountSetupBloc>().add(UpdateBeneficialOwnerSelectedCountry(country: country));
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
          controller: state.beneficialOwnerPinCodeController,
          textInputAction: TextInputAction.next,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
          validator: ExchekValidations.validateRequired,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          suffixIcon: state.isBeneficialOwnerCityAndStateLoading ? AppLoaderWidget(size: 20.0) : SizedBox.fromSize(),
          onChanged: (value) {
            if (value.length == 6 && ExchekValidations.validateRequired(value) == null) {
              context.read<BusinessAccountSetupBloc>().add(BusinessBeneficialOwnerGetCityAndState(value.trim()));
            }
          },
          onFieldSubmitted: (value) {
            if (ExchekValidations.validateRequired(state.beneficialOwnerPinCodeController.text) == null) {
              context.read<BusinessAccountSetupBloc>().add(
                BusinessBeneficialOwnerGetCityAndState(state.beneficialOwnerPinCodeController.text.trim()),
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
            controller: state.beneficialOwnerStateNameController,
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
            controller: state.beneficialOwnerCityNameController,
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
          controller: state.beneficialOwnerAddress1NameController,
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
          controller: state.beneficialOwnerAddress2NameController,
          textInputAction: TextInputAction.next,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
        ),
      ],
    );
  }

  Widget _buildNextButton() {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        return FutureBuilder<String?>(
          future: Prefobj.preferences.get(Prefkeys.userKycDetail),
          builder: (context, snapshot) {
            return AnimatedBuilder(
              animation: Listenable.merge([
                state.beneficialOwnerPinCodeController,
                state.beneficialOwnerStateNameController,
                state.beneficialOwnerCityNameController,
                state.beneficialOwnerAddress1NameController,
              ]),
              builder: (context, child) {
                bool isButtonEnabled = false;
                if (snapshot.hasData && snapshot.data != null) {
                  // final userDetail = jsonDecode(snapshot.data!);
                  // final List multicurrency = userDetail['multicurrency'] ?? [];

                  // if (multicurrency.length > 1) {
                  isButtonEnabled =
                      state.beneficialOwnerPinCodeController.text.isNotEmpty &&
                      state.beneficialOwnerStateNameController.text.isNotEmpty &&
                      state.beneficialOwnerCityNameController.text.isNotEmpty &&
                      state.beneficialOwnerAddress1NameController.text.isNotEmpty;
                  // } else {
                  //   isButtonEnabled = true;
                  // }
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
                    onPressed:
                        isButtonEnabled
                            ? () {
                              context.read<BusinessAccountSetupBloc>().add(
                                BusinessBeneficialOwnerAddressDetailsSubmitted(),
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
      },
    );
  }
}
