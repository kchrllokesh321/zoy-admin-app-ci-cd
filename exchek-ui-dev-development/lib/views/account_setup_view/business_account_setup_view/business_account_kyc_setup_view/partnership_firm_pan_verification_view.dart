import 'package:exchek/core/utils/exports.dart';

class PartnershipFirmPanVerificationView extends StatelessWidget {
  const PartnershipFirmPanVerificationView({super.key});

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
                      title: Lang.of(context).lbl_partnership_firm_PAN_details,
                      description: Lang.of(context).lbl_partnership_firm_PAN_details_description,
                    ),
                    buildSizedBoxH(30.0),
                    Form(
                      key: state.partnershipFirmPanVerificationKey,
                      child: Column(
                        children: [
                          _buildPartnershipFirmPanCardNumberField(context, state),
                          if ((state.partnershipFirmPanDetailsErrorMessage ?? '').isNotEmpty) ...[
                            CommanErrorMessage(errorMessage: state.partnershipFirmPanDetailsErrorMessage ?? ''),
                          ],
                          if ((state.partnershipFirmPanEditErrorMessage ?? '').isNotEmpty) ...[
                            buildSizedBoxH(5.0),
                            CommanErrorMessage(errorMessage: state.partnershipFirmPanEditErrorMessage ?? ''),
                          ],
                          if (state.isPartnershipFirmPanDetailsVerified == true) ...[
                            buildSizedBoxH(24.0),
                            _buildPersonalPanNameField(context, state),
                          ],
                          buildSizedBoxH(24.0),
                          _buildUploadPanCard(context, state),
                          buildSizedBoxH(30.0),
                          _buildNextButton(),
                        ],
                      ),
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

  Widget _buildPartnershipFirmPanCardNumberField(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                Lang.of(context).lbl_partnership_firm_PAN_number,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
                  fontWeight: FontWeight.w400,
                  height: 1.2,
                ),
              ),
            ),
            if (state.isPartnershipFirmPanEditLocked || state.isPartnershipFirmPanModifiedAfterVerification) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: InkWell(
                  mouseCursor: SystemMouseCursors.click,
                  onTap: () {
                    if (!state.isPartnershipFirmPanEditLocked) {
                      // Store original PAN before enabling edit
                      context.read<BusinessAccountSetupBloc>().add(
                        BusinessStoreOriginalPanNumber(state.partnershipFirmPanNumberController.text),
                      );
                      TextFieldUtils.focusAndMoveCursorToEnd(
                        context: context,
                        focusNode: state.partnershipFirmPanNumberFocusNode,
                        controller: state.partnershipFirmPanNumberController,
                      );
                    }
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
          absorbing: state.isPartnershipFirmPanEditLocked || state.isPartnershipFirmPanModifiedAfterVerification,
          child: CustomTextInputField(
            context: context,
            type: InputType.text,
            controller: state.partnershipFirmPanNumberController,
            textInputAction: TextInputAction.done,
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
            validator: (value) {
              return ExchekValidations.validatePANByType(value, 'PARTNERSHIP');
            },
            shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForPANValidation,
            maxLength: 10,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: [UpperCaseTextFormatter(), NoPasteFormatter()],
            onChanged: (value) {
              // Only mark changed if different from original
              final bloc = context.read<BusinessAccountSetupBloc>();
              final original = bloc.state.originalBusinessPanNumber;
              if (original != null && value != original) {
                bloc.add(MarkPartnershipFirmPanDataChanged());
              }
              if (!state.isPartnershipFirmPanEditLocked) {
                bloc.add(PartnershipFirmPanNumberChanged(value));

                if (value.length == 10) {
                  FocusScope.of(context).unfocus();
                  state.partnershipFirmPanVerificationKey.currentState?.validate();
                  if (ExchekValidations.validatePANByType(value, 'PARTNERSHIP') == null) {
                    bloc.add(GetPartnershipFirmPanDetails(value));
                  }
                }
              }
            },
            suffixIcon: state.isPartnershipFirmPanDetailsLoading == true ? AppLoaderWidget(size: 20) : null,
            onFieldSubmitted: (value) {
              // Show validation error if any
              if (!state.isPartnershipFirmPanEditLocked) {
                FocusScope.of(context).unfocus();
                state.partnershipFirmPanVerificationKey.currentState?.validate();

                // If valid, proceed
                if (ExchekValidations.validatePANByType(value, 'PARTNERSHIP') == null) {
                  context.read<BusinessAccountSetupBloc>().add(GetPartnershipFirmPanDetails(value));
                }
              }
            },
            contextMenuBuilder: customContextMenuBuilder,
            focusNode: state.partnershipFirmPanNumberFocusNode,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadPanCard(BuildContext context, BusinessAccountSetupState state) {
    return CustomFileUploadWidget(
      selectedFile: state.partnershipFirmPanCardFile,
      title: Lang.of(context).lbl_upload_partnership_firm_PAN_card,
      onFileSelected: (fileData) {
        context.read<BusinessAccountSetupBloc>().add(UploadPartnershipFirmPanCard(fileData));
        // Mark data as changed for partnership firm PAN
        context.read<BusinessAccountSetupBloc>().add(MarkPartnershipFirmPanDataChanged());
      },
      documentNumber: state.partnershipFirmPanNumberController.text,
      documentType: "",
      kycRole: "PARTNERSHIP",
      screenName: "PAN",
    );
  }

  Widget _buildNextButton() {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        final isButtonEnabled =
            state.partnershipFirmPanCardFile != null &&
            ExchekValidations.validatePANByType(state.partnershipFirmPanNumberController.text, 'PARTNERSHIP') == null &&
            (state.fullPartnershipFirmNamePan ?? '').isNotEmpty &&
            state.isPartnershipFirmPanDetailsVerified == true;

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
            isLoading: state.isPartnershipFirmPanVerifyingLoading ?? false,
            isDisabled: !isButtonEnabled,
            tooltipMessage: Lang.of(context).lbl_tooltip_text,
            onPressed:
                isButtonEnabled
                    ? () {
                      if (state.partnershipFirmPanVerificationKey.currentState?.validate() ?? false) {
                        context.read<BusinessAccountSetupBloc>().add(PartnershipFirmPanVerificationSubmitted());
                      }
                    }
                    : null,
          ),
        );
      },
    );
  }

  // Widget _buildVerifyPanButton(BuildContext context, BusinessAccountSetupState state) {
  //   return Align(
  //     alignment: Alignment.centerRight,
  //     child: AnimatedBuilder(
  //       animation: Listenable.merge([state.partnershipFirmPanNumberController]),
  //       builder: (context, _) {
  //         bool isDisabled =
  //             ExchekValidations.validatePANByType(state.partnershipFirmPanNumberController.text, 'PARTNERSHIP') != null;
  //         return CustomElevatedButton(
  //           text: Lang.of(context).lbl_verify,
  //           width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 150 : double.maxFinite,
  //           isShowTooltip: true,
  //           isLoading: state.isPartnershipFirmPanDetailsLoading,
  //           tooltipMessage: Lang.of(context).lbl_tooltip_text,
  //           isDisabled: isDisabled,
  //           borderRadius: 8.0,
  //           onPressed: () {
  //             // Show validation error if any
  //             state.partnershipFirmPanVerificationKey.currentState?.validate();
  //             if (ExchekValidations.validatePANByType(state.partnershipFirmPanNumberController.text, 'PARTNERSHIP') ==
  //                 null) {
  //               context.read<BusinessAccountSetupBloc>().add(
  //                 GetPartnershipFirmPanDetails(state.partnershipFirmPanNumberController.text),
  //               );
  //             }
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget _buildPersonalPanNameField(BuildContext context, BusinessAccountSetupState state) {
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
        CommanVerifiedInfoBox(value: state.fullPartnershipFirmNamePan ?? '', showTrailingIcon: true),
      ],
    );
  }
}
