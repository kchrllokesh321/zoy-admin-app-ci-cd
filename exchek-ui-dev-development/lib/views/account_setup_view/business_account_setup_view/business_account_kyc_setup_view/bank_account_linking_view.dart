import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/widgets/custom_widget/custom_drop_down_field.dart';

class BankAccountLinkingView extends StatelessWidget {
  const BankAccountLinkingView({super.key});

  List<String> getBankVerificationDocTypes(BuildContext context) => [
    Lang.of(context).lbl_cancelled_cheque,
    Lang.of(context).lbl_bank_statement,
  ];

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
                      title: Lang.of(context).lbl_link_your_bank_account,
                      description: Lang.of(context).lbl_securely_connect_account,
                    ),
                    buildSizedBoxH(30.0),
                    if (state.isBankAccountVerify == true)
                      Form(
                        key: state.bankAccountVerificationFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildVerifiedBankAccountNumber(context, state),
                            buildSizedBoxH(30.0),
                            _buildVerifiedIFSCNumber(context, state),
                            buildSizedBoxH(30.0),
                            _buildVerifiedAccountHolderName(context, state),
                            buildSizedBoxH(30.0),
                            _buildBankAccountVerificationDocTypes(context, state),
                            buildSizedBoxH(30.0),
                            _buildUploadBankAccountVerificationFile(context),
                            buildSizedBoxH(30.0),
                            _buildSubmiteButton(),
                          ],
                        ),
                      )
                    else
                      Form(
                        key: state.bankAccountVerificationFormKey,
                        child: Column(
                          children: [
                            _buildBankNumberField(context, state),
                            buildSizedBoxH(24.0),
                            _buildReEnterBankNumberField(context, state),
                            buildSizedBoxH(30.0),
                            _buildIFSCCode(context),
                            buildSizedBoxH(30.0),
                            _buildVerifyButton(context, state),
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

  Widget _buildBankNumberField(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_bank_account_number,
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
          controller: state.bankAccountNumberController,
          textInputAction: TextInputAction.next,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, NoPasteFormatter()],
          validator: ExchekValidations.validateBankAccount,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForBankAccountNumberValidation,
          onChanged: (value) {
            // Mark data as changed for bank account
            context.read<BusinessAccountSetupBloc>().add(MarkBankAccountDataChanged());
          },
          contextMenuBuilder: customContextMenuBuilder,
        ),
      ],
    );
  }

  Widget _buildReEnterBankNumberField(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_Reenter_bank_account_number,
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
          controller: state.reEnterbankAccountNumberController,
          textInputAction: TextInputAction.next,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, NoPasteFormatter()],
          validator: (value) {
            return ExchekValidations.validateAccountConfirmation(state.bankAccountNumberController.text, value);
          },
          shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForBankAccountConfirmationValidation,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          contextMenuBuilder: customContextMenuBuilder,
          onChanged: (value) {
            // Mark data as changed for bank account
            context.read<BusinessAccountSetupBloc>().add(MarkBankAccountDataChanged());
          },
        ),
      ],
    );
  }

  Widget _buildIFSCCode(BuildContext context) {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Lang.of(context).lbl_IFSC_code,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
                fontWeight: FontWeight.w400,
                height: 1.22,
              ),
            ),
            buildSizedBoxH(5.0),
            CustomTextInputField(
              context: context,
              type: InputType.text,
              controller: state.ifscCodeController,
              textInputAction: TextInputAction.done,
              validator: ExchekValidations.validateIFSC,
              shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForIFSCodeValidation,
              suffixText: true,
              maxLength: 11,
              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
              onChanged: (value) {
                // Mark data as changed for bank account
                context.read<BusinessAccountSetupBloc>().add(MarkBankAccountDataChanged());
              },
              onFieldSubmitted: (value) {
                if (state.bankAccountVerificationFormKey.currentState?.validate() ?? false) {
                  context.read<BusinessAccountSetupBloc>().add(
                    BankAccountNumberVerify(
                      accountNumber: state.bankAccountNumberController.text,
                      ifscCode: state.ifscCodeController.text,
                    ),
                  );
                }
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              inputFormatters: [UpperCaseTextFormatter(), NoPasteFormatter()],
              contextMenuBuilder: customContextMenuBuilder,
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
          state.bankAccountNumberController,
          state.reEnterbankAccountNumberController,
          state.ifscCodeController,
        ]),
        builder: (context, child) {
          final isDisable =
              state.bankAccountNumberController.text.isEmpty ||
              state.reEnterbankAccountNumberController.text.isEmpty ||
              state.ifscCodeController.text.isEmpty;
          return CustomElevatedButton(
            text: Lang.of(context).lbl_verify,
            width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 150 : double.maxFinite,
            isShowTooltip: true,
            isLoading: state.isBankAccountNumberVerifiedLoading ?? false,
            tooltipMessage: Lang.of(context).lbl_tooltip_text,
            isDisabled: isDisable,
            borderRadius: 8.0,
            onPressed:
                isDisable
                    ? null
                    : () {
                      if (state.bankAccountVerificationFormKey.currentState?.validate() ?? false) {
                        context.read<BusinessAccountSetupBloc>().add(
                          BankAccountNumberVerify(
                            accountNumber: state.bankAccountNumberController.text,
                            ifscCode: state.ifscCodeController.text,
                          ),
                        );
                      }
                    },
          );
        },
      ),
    );
  }

  Widget _buildVerifiedBankAccountNumber(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_bank_account_number,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
            fontWeight: FontWeight.w400,
            height: 1.22,
          ),
        ),
        buildSizedBoxH(8.0),
        CommanVerifiedInfoBox(value: state.bankAccountNumber ?? ''),
      ],
    );
  }

  Widget _buildVerifiedIFSCNumber(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_IFSC_code,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
            fontWeight: FontWeight.w400,
            height: 1.22,
          ),
        ),
        buildSizedBoxH(8.0),
        CommanVerifiedInfoBox(value: state.ifscCode ?? '', showTrailingIcon: false),
      ],
    );
  }

  Widget _buildVerifiedAccountHolderName(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_account_holder_name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
            fontWeight: FontWeight.w400,
            height: 1.22,
          ),
        ),
        buildSizedBoxH(8.0),
        CommanVerifiedInfoBox(value: state.accountHolderName ?? '', showTrailingIcon: false),
      ],
    );
  }

  Widget _buildBankAccountVerificationDocTypes(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_document_bank_account,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
            fontWeight: FontWeight.w400,
            height: 1.22,
          ),
        ),
        buildSizedBoxH(8.0),
        ExpandableDropdownField(
          items: getBankVerificationDocTypes(context),
          selectedValue: state.selectedBankAccountVerificationDocType,
          onChanged: (value) {
            context.read<BusinessAccountSetupBloc>().add(UpdateBankAccountVerificationDocType(value));
          },
        ),
      ],
    );
  }

  Widget _buildUploadBankAccountVerificationFile(BuildContext context) {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      buildWhen:
          (previous, current) =>
              previous.selectedBankAccountVerificationDocType != current.selectedBankAccountVerificationDocType ||
              previous.bankVerificationFile != current.bankVerificationFile,
      builder: (context, state) {
        final docType = _mapDocType(state.selectedBankAccountVerificationDocType, context);
        if (state.selectedBankAccountVerificationDocType == null) return const SizedBox.shrink();

        return CustomFileUploadWidget(
          selectedFile: state.bankVerificationFile,
          title: "${Lang.of(context).lbl_upload} ${state.selectedBankAccountVerificationDocType}",
          onFileSelected: (fileData) {
            context.read<BusinessAccountSetupBloc>().add(UploadBankAccountVerificationFile(fileData: fileData));
            // Mark data as changed for bank account
            context.read<BusinessAccountSetupBloc>().add(MarkBankAccountDataChanged());
          },
          documentNumber: state.bankAccountNumber ?? '',
          documentType: docType,
          kycRole: "",
          screenName: "BANK",
        );
      },
    );
  }

  Widget _buildSubmiteButton() {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        final isButtonEnabled = state.bankVerificationFile != null;
        return Align(
          alignment: Alignment.centerRight,
          child: CustomElevatedButton(
            isShowTooltip: true,
            text: Lang.of(context).lbl_submit,
            borderRadius: 8.0,
            width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 125 : double.maxFinite,
            buttonTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            isDisabled: !isButtonEnabled,
            isLoading: state.isBankAccountNumberVerifiedLoading ?? false,
            onPressed:
                isButtonEnabled
                    ? () {
                      final docType = _mapDocType(state.selectedBankAccountVerificationDocType, context);
                      context.read<BusinessAccountSetupBloc>().add(
                        BankAccountDetailSubmitted(
                          bankAccountVerifyFile: state.bankVerificationFile!,
                          docType: docType,
                          context: context,
                        ),
                      );
                    }
                    : null,
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

  String _mapDocType(String? selectedDocType, BuildContext context) {
    final lang = Lang.of(context);
    if (selectedDocType == lang.lbl_cancelled_cheque) return 'CancelledCheque';
    if (selectedDocType == lang.lbl_bank_statement) return 'BankStatement';
    return '';
  }
}
