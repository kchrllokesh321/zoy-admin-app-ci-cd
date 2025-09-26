import 'package:exchek/core/utils/exports.dart';

class HufPanVerificationView extends StatelessWidget {
  const HufPanVerificationView({super.key});

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
                      title: Lang.of(context).lbl_hindu_undivided_family,
                      description: Lang.of(context).lbl_hindu_undivided_family_description,
                    ),
                    buildSizedBoxH(30.0),
                    Form(
                      key: state.hufPanVerificationKey,
                      child: Column(
                        children: [
                          _buildHUFPanCardNumberField(context, state),
                          if ((state.hufPanDetailsErrorMessage ?? '').isNotEmpty) ...[
                            CommanErrorMessage(errorMessage: state.hufPanDetailsErrorMessage ?? ''),
                          ],
                          if ((state.hufPanEditErrorMessage ?? '').isNotEmpty) ...[
                            buildSizedBoxH(5.0),
                            CommanErrorMessage(errorMessage: state.hufPanEditErrorMessage ?? ''),
                          ],
                          if (state.isHUFPanDetailsVerified == true) ...[
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

  Widget _buildHUFPanCardNumberField(BuildContext context, BusinessAccountSetupState state) {
    print('state.hufPanEditAttempts: ${state.hufPanEditAttempts}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                Lang.of(context).lbl_hindu_undivided_pan_number,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
                  fontWeight: FontWeight.w400,
                  height: 1.2,
                ),
              ),
            ),
            if (state.isHUFPanEditLocked || state.isHUFPanModifiedAfterVerification) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: InkWell(
                  mouseCursor: SystemMouseCursors.click,
                  onTap: () {
                    if (!state.isHUFPanEditLocked) {
                      // Store original PAN before enabling edit
                      context.read<BusinessAccountSetupBloc>().add(
                        BusinessStoreOriginalPanNumber(state.hufPanNumberController.text),
                      );
                      TextFieldUtils.focusAndMoveCursorToEnd(
                        context: context,
                        focusNode: state.hufPanNumberFocusNode,
                        controller: state.hufPanNumberController,
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
          absorbing: state.isHUFPanEditLocked || state.isHUFPanModifiedAfterVerification,
          child: CustomTextInputField(
            context: context,
            type: InputType.text,
            controller: state.hufPanNumberController,
            textInputAction: TextInputAction.done,
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
            validator: (value) {
              return ExchekValidations.validatePANByType(value, 'HUF');
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
                bloc.add(MarkHUFPanDataChanged());
              }
              if (!state.isHUFPanEditLocked) {
                bloc.add(HUFPanNumberChanged(value));
                state.hufPanVerificationKey.currentState?.validate();

                if (value.length == 10 && ExchekValidations.validatePANByType(value, 'HUF') == null) {
                  FocusScope.of(context).unfocus();
                  bloc.add(GetHUFPanDetails(value));
                }
              }
            },
            suffixIcon: state.isHUFPanDetailsLoading == true ? AppLoaderWidget(size: 20) : null,
            onFieldSubmitted: (value) {
              if (!state.isHUFPanEditLocked) {
                state.hufPanVerificationKey.currentState?.validate();

                if (ExchekValidations.validatePANByType(value, 'HUF') == null) {
                  FocusScope.of(context).unfocus();
                  context.read<BusinessAccountSetupBloc>().add(GetHUFPanDetails(value));
                }
              }
            },
            contextMenuBuilder: customContextMenuBuilder,
            focusNode: state.hufPanNumberFocusNode,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadPanCard(BuildContext context, BusinessAccountSetupState state) {
    return CustomFileUploadWidget(
      selectedFile: state.hufPanCardFile,
      title: Lang.of(context).lbl_upload_HUF_PAN_card,
      onFileSelected: (fileData) {
        context.read<BusinessAccountSetupBloc>().add(UploadHUFPanCard(fileData));
        // Mark data as changed for HUF PAN
        context.read<BusinessAccountSetupBloc>().add(MarkHUFPanDataChanged());
      },
      documentNumber: state.hufPanNumberController.text,
      documentType: "",
      kycRole: "HUF",
      screenName: "PAN",
    );
  }

  Widget _buildNextButton() {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        final isButtonEnabled =
            state.hufPanCardFile != null &&
            ExchekValidations.validatePANByType(state.hufPanNumberController.text, "HUF") == null &&
            (state.fullHUFNamePan ?? '').isNotEmpty &&
            state.isHUFPanDetailsVerified == true;

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
            isLoading: state.isHUFPanVerifyingLoading ?? false,
            isDisabled: !isButtonEnabled,
            tooltipMessage: Lang.of(context).lbl_tooltip_text,
            onPressed:
                isButtonEnabled
                    ? () {
                      if (state.hufPanVerificationKey.currentState?.validate() ?? false) {
                        context.read<BusinessAccountSetupBloc>().add(HUFPanVerificationSubmitted());
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
  //       animation: Listenable.merge([state.hufPanNumberController]),
  //       builder: (context, _) {
  //         bool isDisabled = ExchekValidations.validatePANByType(state.hufPanNumberController.text, "HUF") != null;
  //         return CustomElevatedButton(
  //           text: Lang.of(context).lbl_verify,
  //           width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 150 : double.maxFinite,
  //           isShowTooltip: true,
  //           isLoading: state.isHUFPanDetailsLoading,
  //           tooltipMessage: Lang.of(context).lbl_tooltip_text,
  //           isDisabled: isDisabled,
  //           borderRadius: 8.0,
  //           onPressed: () {
  //             // Show validation error if any
  //             state.hufPanVerificationKey.currentState?.validate();
  //             if (ExchekValidations.validatePANByType(state.hufPanNumberController.text, "HUF") == null) {
  //               context.read<BusinessAccountSetupBloc>().add(GetHUFPanDetails(state.hufPanNumberController.text));
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
        CommanVerifiedInfoBox(value: state.fullHUFNamePan ?? '', showTrailingIcon: true),
      ],
    );
  }
}
