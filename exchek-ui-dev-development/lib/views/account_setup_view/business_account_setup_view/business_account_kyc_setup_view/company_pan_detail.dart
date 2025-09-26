import 'package:exchek/core/utils/exports.dart';

class CompanyPanDetail extends StatelessWidget {
  const CompanyPanDetail({super.key});

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
                      title: Lang.of(context).lbl_company_PAN_details,
                      description: Lang.of(context).lbl_company_pan_details_description,
                    ),
                    buildSizedBoxH(30.0),
                    Form(
                      key: state.companyPanVerificationKey,
                      child: Column(
                        children: [
                          _buildCompanyPanCardNumberField(context, state),
                          if ((state.companyPanDetailsErrorMessage ?? '').isNotEmpty) ...[
                            CommanErrorMessage(errorMessage: state.companyPanDetailsErrorMessage ?? ''),
                          ],
                          buildSizedBoxH(5.0),
                          if ((state.companyPanEditErrorMessage ?? '').isNotEmpty) ...[
                            CommanErrorMessage(errorMessage: state.companyPanEditErrorMessage ?? ''),
                          ],
                          if (state.isCompanyPanDetailsVerified == true) ...[
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

  Widget _buildCompanyPanCardNumberField(BuildContext context, BusinessAccountSetupState state) {
    return AnimatedBuilder(
      animation: Listenable.merge([state.companyPanNumberFocusNode]),
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    Lang.of(context).lbl_company_pan_number,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                    ),
                  ),
                ),
                if (state.isCompanyPanEditLocked || state.isCompanyPanModifiedAfterVerification) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: InkWell(
                      mouseCursor: SystemMouseCursors.click,
                      onTap: () {
                        if (!state.isCompanyPanEditLocked) {
                          // Store original PAN before enabling edit (skip same number)
                          context.read<BusinessAccountSetupBloc>().add(
                            BusinessStoreOriginalPanNumber(state.companyPanNumberController.text),
                          );
                          TextFieldUtils.focusAndMoveCursorToEnd(
                            context: context,
                            focusNode: state.companyPanNumberFocusNode,
                            controller: state.companyPanNumberController,
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
              absorbing: state.isCompanyPanEditLocked || state.isCompanyPanModifiedAfterVerification,
              child: CustomTextInputField(
                context: context,
                type: InputType.text,
                controller: state.companyPanNumberController,
                textInputAction: TextInputAction.done,
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
                validator: (value) {
                  return ExchekValidations.validatePANByType(value, 'COMPANY');
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
                    bloc.add(MarkCompanyPanDataChanged());
                  }
                  if (!state.isCompanyPanEditLocked) {
                    if (value.length == 10) {
                      FocusScope.of(context).unfocus();
                      state.companyPanVerificationKey.currentState?.validate();

                      // If valid, proceed
                      if (ExchekValidations.validatePANByType(value, 'COMPANY') == null) {
                        bloc.add(GetCompanyPanDetails(value));
                      }
                    }
                  }
                },
                suffixIcon: state.isCompanyPanDetailsLoading == true ? AppLoaderWidget(size: 20) : null,
                onFieldSubmitted: (value) {
                  if (!state.isCompanyPanEditLocked) {
                    FocusScope.of(context).unfocus();
                    // Show validation error if any
                    state.companyPanVerificationKey.currentState?.validate();

                    // If valid, proceed
                    if (ExchekValidations.validatePANByType(value, 'COMPANY') == null) {
                      context.read<BusinessAccountSetupBloc>().add(GetCompanyPanDetails(value));
                    }
                  }
                },
                contextMenuBuilder: customContextMenuBuilder,
                focusNode: state.companyPanNumberFocusNode,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUploadPanCard(BuildContext context, BusinessAccountSetupState state) {
    return CustomFileUploadWidget(
      selectedFile: state.companyPanCardFile,
      title: Lang.of(context).lbl_upload_company_PAN_card,
      onFileSelected: (fileData) {
        context.read<BusinessAccountSetupBloc>().add(UploadCompanyPanCard(fileData));
        // Mark data as changed for company PAN
        context.read<BusinessAccountSetupBloc>().add(MarkCompanyPanDataChanged());
      },
      documentNumber: state.companyPanNumberController.text,
      documentType: "",
      kycRole: "COMPANY",
      screenName: "PAN",
    );
  }

  Widget _buildNextButton() {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        return AnimatedBuilder(
          animation: Listenable.merge([state.companyPanNumberController]),
          builder: (context, _) {
            final isButtonEnabled =
                state.companyPanCardFile != null &&
                ExchekValidations.validatePANByType(state.companyPanNumberController.text, "COMPANY") == null &&
                (state.fullCompanyNamePan ?? '').isNotEmpty &&
                state.isCompanyPanDetailsVerified == true;
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
                isLoading: state.isCompanyPanVerifyingLoading,
                isDisabled: !isButtonEnabled,
                tooltipMessage: Lang.of(context).lbl_tooltip_text,
                onPressed:
                    isButtonEnabled
                        ? () {
                          if (state.companyPanVerificationKey.currentState?.validate() ?? false) {
                            context.read<BusinessAccountSetupBloc>().add(CompanyPanVerificationSubmitted());
                          }
                        }
                        : null,
              ),
            );
          },
        );
      },
    );
  }

  // Widget _buildVerifyPanButton(BuildContext context, BusinessAccountSetupState state) {
  //   return Align(
  //     alignment: Alignment.centerRight,
  //     child: AnimatedBuilder(
  //       animation: Listenable.merge([state.companyPanNumberController]),
  //       builder: (context, _) {
  //         bool isDisabled =
  //             ExchekValidations.validatePANByType(state.companyPanNumberController.text, "COMPANY") != null;
  //         return CustomElevatedButton(
  //           text: Lang.of(context).lbl_verify,
  //           width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 150 : double.maxFinite,
  //           isShowTooltip: true,
  //           isLoading: state.isCompanyPanDetailsLoading,
  //           tooltipMessage: Lang.of(context).lbl_tooltip_text,
  //           isDisabled: isDisabled,
  //           borderRadius: 8.0,
  //           onPressed: () {
  //             // Show validation error if any
  //             state.companyPanVerificationKey.currentState?.validate();
  //             if (ExchekValidations.validatePANByType(state.companyPanNumberController.text, "COMPANY") == null) {
  //               context.read<BusinessAccountSetupBloc>().add(
  //                 GetCompanyPanDetails(state.companyPanNumberController.text),
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
        CommanVerifiedInfoBox(value: state.fullCompanyNamePan ?? '', showTrailingIcon: true),
      ],
    );
  }
}
