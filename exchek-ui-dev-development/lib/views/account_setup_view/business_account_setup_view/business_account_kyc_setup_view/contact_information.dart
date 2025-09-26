import 'package:exchek/core/utils/exports.dart';

class ContactInformation extends StatelessWidget {
  const ContactInformation({super.key});

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
                    FutureBuilder<String?>(
                      future: KycStepUtils.getBusinessType(),
                      builder: (context, snapshot) {
                        String businessType = snapshot.data ?? '';
                        String title;
                        String description;
                        if (businessType == "limited_liability_partnership" || businessType == "partnership") {
                          title = "Partner Contact Details";
                          description =
                              "Provide an alternate mobile number and email ID of any Partner. These details will be used for official KYC communication.";
                        } else {
                          title = "Director Contact Details";
                          description =
                              "Provide an alternate mobile number and email ID of any Director. These details will be used for official KYC communication.";
                        }
                        return _buildSelectionTitleAndDescription(
                          context: context,
                          title: title,
                          description: description,
                        );
                      },
                    ),
                    buildSizedBoxH(24.0),
                    Form(
                      key: state.directorContactInformationKey,
                      child: Column(
                        children: [
                          _buildDirectorMobileNumberField(context, state),
                          buildSizedBoxH(24.0),
                          _buildDirectorEmailIdField(context, state),
                        ],
                      ),
                    ),
                    buildSizedBoxH(45.0),
                    _buildSaveAndNextButton(),
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

  Widget _buildDirectorMobileNumberField(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Mobile Number",
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
          controller: state.directorMobileNumberController,
          textInputAction: TextInputAction.next,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          boxConstraints: BoxConstraints(minWidth: ResponsiveHelper.isMobile(context) ? 70.0 : 70.0),
          prefixIcon: Container(
            margin: EdgeInsets.only(right: 10.0),
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: Theme.of(context).customColors.textdarkcolor!)),
            ),
            alignment: Alignment.center,
            child: Text(
              Lang.of(context).lbl_india_code,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 16),
                color: Theme.of(context).customColors.secondaryTextColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          maxLength: 10,
          validator: ExchekValidations.validateMobileNumber,
          shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForMobileNumberValidation,
          onChanged: (value) {
            // Mark data as changed for contact information
            context.read<BusinessAccountSetupBloc>().add(MarkContactInformationDataChanged());
          },
        ),
      ],
    );
  }

  Widget _buildDirectorEmailIdField(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Email ID",
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
          controller: state.directorEmailIdNumberController,
          textInputAction: TextInputAction.done,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
          validator: ExchekValidations.validateEmail,
          shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForEmailValidation,
          onChanged: (value) {
            // Mark data as changed for contact information
            context.read<BusinessAccountSetupBloc>().add(MarkContactInformationDataChanged());
          },
        ),
      ],
    );
  }

  Widget _buildSaveAndNextButton() {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        return Align(
          alignment: Alignment.centerRight,
          child: AnimatedBuilder(
            animation: Listenable.merge([state.directorMobileNumberController, state.directorEmailIdNumberController]),
            builder: (context, _) {
              final isButtonEnabled =
                  state.directorMobileNumberController.text.isNotEmpty &&
                  state.directorEmailIdNumberController.text.isNotEmpty;
              return CustomElevatedButton(
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
                isLoading: state.isContactInfoSubmitLoading,
                onPressed:
                    isButtonEnabled
                        ? () {
                          if (state.directorContactInformationKey.currentState!.validate()) {
                            context.read<BusinessAccountSetupBloc>().add(
                              ContactInformationSubmitted(
                                emailId: state.directorEmailIdNumberController.text,
                                mobileNumber: state.directorMobileNumberController.text,
                              ),
                            );
                          }
                        }
                        : null,
              );
            },
          ),
        );
      },
    );
  }
}
