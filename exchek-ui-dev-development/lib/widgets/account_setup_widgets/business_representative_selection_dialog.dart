import 'package:exchek/core/utils/exports.dart';

class BusinessRepresentativeSelectionDialog extends StatelessWidget {
  const BusinessRepresentativeSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            padding: EdgeInsets.all(24.0),
            clipBehavior: Clip.hardEdge,
            constraints: BoxConstraints(maxWidth: ResponsiveHelper.getMaxDialogWidth(context)),
            decoration: BoxDecoration(
              color: Theme.of(context).customColors.fillColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMessage(context),
                buildSizedBoxH(24.0),
                _buildRadioOptions(context, state),
                buildSizedBoxH(30.0),
                _buildCancelAndContinueButton(context, state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessage(BuildContext context) {
    return FutureBuilder<String?>(
      future: KycStepUtils.getBusinessType(),
      builder: (context, snapshot) {
        String businessType = snapshot.data ?? '';
        String title;
        String description;
        if (businessType == 'limited_liability_partnership' || businessType == 'partnership') {
          title = "Business Representative Required";
          description =
              "One Partner must be marked as a Business Representative to continue. Please select from below:";
        } else {
          title = "Business Representative Required";
          description =
              "One Director must be marked as a Business Representative to continue. Please select from below:";
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomImageView(imagePath: Assets.images.svgs.icons.icInformation.path, height: 40.0, width: 40.0),
            buildSizedBoxH(16.0),
            LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: constraints.maxWidth - 40.0),
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: ResponsiveHelper.getFontSize(context, mobile: 18, tablet: 20, desktop: 20),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    buildSizedboxW(8.0),
                    Tooltip(
                      constraints: BoxConstraints(maxWidth: 300.0),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).customColors.blackColor,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: ResponsiveHelper.getFontSize(context, mobile: 12.0, tablet: 14.0, desktop: 14.0),
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).customColors.fillColor,
                      ),
                      message: Lang.of(context).lbl_tooltip_message_of_owner_representative,
                      child: CustomImageView(
                        imagePath: Assets.images.svgs.icons.icInfoCircle.path,
                        height: 18.0,
                        width: 18.0,
                      ),
                    ),
                  ],
                );
              },
            ),
            buildSizedBoxH(12.0),
            Text(
              description,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).customColors.blackColor,
                letterSpacing: 0.16,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRadioOptions(BuildContext context, BusinessAccountSetupState state) {
    return FutureBuilder<String?>(
      future: KycStepUtils.getBusinessType(),
      builder: (context, snapshot) {
        String businessType = snapshot.data ?? '';
        String roleType;
        if (businessType == 'limited_liability_partnership' || businessType == 'partnership') {
          roleType = "Partner";
        } else {
          roleType = "Director";
        }

        return Column(
          children: [
            _buildRadioOption(
              context,
              title: "Authorized $roleType - ${state.fullDirector1NamePan}",
              value: "Authorized Director",
              groupValue: state.selectedBusinessRepresentativeOption,
              onChanged: (value) {
                context.read<BusinessAccountSetupBloc>().add(SelectBusinessRepresentative(value!));
              },
            ),
            buildSizedBoxH(20.0),
            _buildRadioOption(
              context,
              title: "Other $roleType - ${state.fullDirector2NamePan}",
              value: "Other Director",
              groupValue: state.selectedBusinessRepresentativeOption,
              onChanged: (value) {
                context.read<BusinessAccountSetupBloc>().add(SelectBusinessRepresentative(value!));
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildRadioOption(
    BuildContext context, {
    required String title,
    required String value,
    required String? groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            groupValue == value
                ? Container(
                  height: 17.0,
                  width: 17.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Theme.of(context).customColors.blueColor!, width: 1.5),
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    height: 10.0,
                    width: 10.0,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).customColors.blueColor!),
                  ),
                )
                : Container(
                  height: 17.0,
                  width: 17.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xFF343A3E), width: 1.5),
                  ),
                ),
            buildSizedboxW(12.0),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 16),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelAndContinueButton(BuildContext context, BusinessAccountSetupState state) {
    return Row(
      spacing: 10.0,
      mainAxisAlignment: MainAxisAlignment.end,
      children:
          ResponsiveHelper.isWebAndIsNotMobile(context)
              ? [_buildCancelButton(context), _buildConfirmAndNextButton(context, state)]
              : [
                Expanded(child: _buildCancelButton(context)),
                Expanded(child: _buildConfirmAndNextButton(context, state)),
              ],
    );
  }

  Widget _buildConfirmAndNextButton(BuildContext context, BusinessAccountSetupState state) {
    return CustomElevatedButton(
      isShowTooltip: true,
      text: "Confirm & Next",
      borderRadius: 8.0,
      width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 170 : double.maxFinite,
      buttonTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      isDisabled: state.selectedBusinessRepresentativeOption == null || state.isBusinessRepresentativeConfirmLoading,
      isLoading: state.isBusinessRepresentativeConfirmLoading,
      onPressed:
          state.selectedBusinessRepresentativeOption != null && !state.isBusinessRepresentativeConfirmLoading
              ? () {
                context.read<BusinessAccountSetupBloc>().add(ConfirmBusinessRepresentativeAndNextStep());
              }
              : null,
      tooltipMessage: Lang.of(context).lbl_tooltip_text,
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return CustomElevatedButton(
      isShowTooltip: true,
      text: Lang.of(context).lbl_Cancel,
      borderRadius: 8.0,
      width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 130 : double.maxFinite,
      buttonTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
        color: Theme.of(context).customColors.blueColor!,
      ),
      onPressed: () {
        GoRouter.of(context).pop();
      },
      tooltipMessage: Lang.of(context).lbl_tooltip_text,
      buttonStyle: ButtonThemeHelper.textButtonStyle(context),
    );
  }
}
