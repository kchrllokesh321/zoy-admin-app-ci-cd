import 'package:exchek/core/utils/exports.dart';

class BeneficialOwnershipVerificationView extends StatelessWidget {
  const BeneficialOwnershipVerificationView({super.key});

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
                    _buildSelectionTitleAndDescription(context: context),
                    buildSizedBoxH(30.0),
                    _buildUploadBeneficialOwnershipDeclaration(context, state),
                    buildSizedBoxH(30.0),
                    _buildNextButton(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectionTitleAndDescription({required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Beneficial Ownership Declaration",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: ResponsiveHelper.getFontSize(context, mobile: 24, tablet: 26, desktop: 28),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.32,
                ),
              ),
              TextSpan(
                text: " (Optional)",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: ResponsiveHelper.getFontSize(context, mobile: 16, tablet: 18, desktop: 20),
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).customColors.iconColor,
                ),
              ),
            ],
          ),
        ),
        buildSizedBoxH(14.0),
        Text(
          "You may upload a Beneficial Ownership Declaration to authenticate the list of Beneficial Owners associated with your business. Submitting this document is optional, but it helps strengthen compliance verification.",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
            fontWeight: FontWeight.w400,
            color: Theme.of(context).customColors.secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadBeneficialOwnershipDeclaration(BuildContext context, BusinessAccountSetupState state) {
    return CustomFileUploadWidget(
      selectedFile: state.beneficialOwnershipDeclarationFile,
      onFileSelected: (fileData) {
        context.read<BusinessAccountSetupBloc>().add(UploadBeneficialOwnershipDeclaration(fileData));
        // Mark data as changed for beneficial ownership
        context.read<BusinessAccountSetupBloc>().add(MarkBeneficialOwnershipDataChanged());
      },
      documentNumber: '',
      documentType: "BENEFICIAL_OWNERSHIP_DECLARATION",
      kycRole: "OWNER",
      screenName: "BUSINESS_LEGAL_DOC",
    );
  }

  Widget _buildNextButton() {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        // final isButtonEnabled = state.beneficialOwnershipDeclarationFile != null;

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
            isLoading: state.isBeneficialOwnershipDeclarationVerifyingLoading,
            isDisabled: false,
            tooltipMessage: Lang.of(context).lbl_tooltip_text,
            onPressed: () async {
              context.read<BusinessAccountSetupBloc>().add(
                BeneficialOwnershipDeclarationSubmitted(fileData: state.beneficialOwnershipDeclarationFile),
              );
            },
          ),
        );
      },
    );
  }
}
