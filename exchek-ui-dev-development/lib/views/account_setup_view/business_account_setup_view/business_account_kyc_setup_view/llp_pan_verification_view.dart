import 'package:exchek/core/utils/exports.dart';

class LLPPanVerificationView extends StatelessWidget {
  const LLPPanVerificationView({super.key});

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
                      title: Lang.of(context).lbl_llp_pan_details,
                      description: Lang.of(context).lbl_llp_pan_details_description,
                    ),
                    buildSizedBoxH(30.0),
                    Form(
                      key: state.llpPanVerificationKey,
                      child: Column(
                        children: [
                          _buildLLPPanCardNumberField(context, state),
                          if ((state.llpPanDetailsErrorMessage ?? '').isNotEmpty) ...[
                            CommanErrorMessage(errorMessage: state.llpPanDetailsErrorMessage ?? ''),
                          ],
                          if ((state.llpPanEditErrorMessage ?? '').isNotEmpty) ...[
                            buildSizedBoxH(5.0),
                            CommanErrorMessage(errorMessage: state.llpPanEditErrorMessage ?? ''),
                          ],
                          if (state.isLLPPanDetailsVerified == true) ...[
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

  Widget _buildLLPPanCardNumberField(BuildContext context, BusinessAccountSetupState state) {
    print('state.llpPanEditAttempts : ${state.isLLPPanEditLocked}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                Lang.of(context).lbl_llp_pan_number,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
                  fontWeight: FontWeight.w400,
                  height: 1.2,
                ),
              ),
            ),
            if (state.isLLPPanEditLocked || state.isLLPPanModifiedAfterVerification) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: GestureDetector(
                  onTap: () {
                    if (!state.isLLPPanEditLocked) {
                      // Store original PAN before enabling edit
                      context.read<BusinessAccountSetupBloc>().add(
                        BusinessStoreOriginalPanNumber(state.llpPanNumberController.text),
                      );
                      TextFieldUtils.focusAndMoveCursorToEnd(
                        context: context,
                        focusNode: state.llpPanNumberFocusNode,
                        controller: state.llpPanNumberController,
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
          absorbing: state.isLLPPanEditLocked || state.isLLPPanModifiedAfterVerification,
          child: CustomTextInputField(
            context: context,
            type: InputType.text,
            controller: state.llpPanNumberController,
            textInputAction: TextInputAction.done,
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
            validator: (value) {
              return ExchekValidations.validatePANByType(value, 'LLP');
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
                bloc.add(MarkLLPPanDataChanged());
              }
              if (!state.isLLPPanEditLocked) {
                bloc.add(LLPPanNumberChanged(value));
                if (value.length == 10) {
                  state.llpPanVerificationKey.currentState?.validate();
                  // If valid, proceed

                  if (ExchekValidations.validatePANByType(value, 'LLP') == null) {
                    FocusScope.of(context).unfocus();
                    bloc.add(GetLLPPanDetails(value));
                  }
                }
              }
            },
            suffixIcon: state.isLLPPanDetailsLoading == true ? AppLoaderWidget(size: 20) : null,
            onFieldSubmitted: (value) {
              if (!state.isLLPPanEditLocked) {
                // Show validation error if any
                state.llpPanVerificationKey.currentState?.validate();

                // If valid, proceed
                if (ExchekValidations.validatePANByType(value, 'LLP') == null) {
                  FocusScope.of(context).unfocus();
                  context.read<BusinessAccountSetupBloc>().add(GetLLPPanDetails(value));
                }
              }
            },
            contextMenuBuilder: customContextMenuBuilder,
            focusNode: state.llpPanNumberFocusNode,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadPanCard(BuildContext context, BusinessAccountSetupState state) {
    return CustomFileUploadWidget(
      selectedFile: state.llpPanCardFile,
      title: Lang.of(context).lbl_llp_upload_LLP_pan_card,
      onFileSelected: (fileData) {
        context.read<BusinessAccountSetupBloc>().add(UploadLLPPanCard(fileData));
        // Mark data as changed for LLP PAN
        context.read<BusinessAccountSetupBloc>().add(MarkLLPPanDataChanged());
      },
      documentNumber: state.llpPanNumberController.text,
      documentType: "",
      kycRole: "LLP",
      screenName: "PAN",
    );
  }

  Widget _buildNextButton() {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        final isButtonEnabled =
            state.llpPanCardFile != null &&
            ExchekValidations.validatePANByType(state.llpPanNumberController.text, 'LLP') == null &&
            (state.fullLLPNamePan ?? '').isNotEmpty &&
            state.isLLPPanDetailsVerified == true;

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
            isLoading: state.isLLPPanVerifyingLoading ?? false,
            isDisabled: !isButtonEnabled,
            tooltipMessage: Lang.of(context).lbl_tooltip_text,
            onPressed:
                isButtonEnabled
                    ? () {
                      if (state.llpPanVerificationKey.currentState?.validate() ?? false) {
                        context.read<BusinessAccountSetupBloc>().add(LLPPanVerificationSubmitted());
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
  //       animation: Listenable.merge([state.llpPanNumberController]),
  //       builder: (context, _) {
  //         bool isDisabled = ExchekValidations.validatePANByType(state.llpPanNumberController.text, 'LLP') != null;
  //         return CustomElevatedButton(
  //           text: Lang.of(context).lbl_verify,
  //           width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 150 : double.maxFinite,
  //           isShowTooltip: true,
  //           isLoading: state.isLLPPanDetailsLoading,
  //           tooltipMessage: Lang.of(context).lbl_tooltip_text,
  //           isDisabled: isDisabled,
  //           borderRadius: 8.0,
  //           onPressed: () {
  //             // Show validation error if any
  //             state.llpPanVerificationKey.currentState?.validate();
  //             if (ExchekValidations.validatePANByType(state.llpPanNumberController.text, 'LLP') == null) {
  //               context.read<BusinessAccountSetupBloc>().add(GetLLPPanDetails(state.llpPanNumberController.text));
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
        CommanVerifiedInfoBox(value: state.fullLLPNamePan ?? '', showTrailingIcon: true),
      ],
    );
  }
}
