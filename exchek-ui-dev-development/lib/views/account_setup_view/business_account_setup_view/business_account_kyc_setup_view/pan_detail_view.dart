// ignore_for_file: use_build_context_synchronously

import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/widgets/account_setup_widgets/beneficial_owner_pan_upload_dialog.dart';
import 'package:exchek/widgets/account_setup_widgets/directors_pan_upload_dialog.dart';
import 'package:exchek/widgets/account_setup_widgets/other_director_kyc_dialog.dart';

class PanDetailView extends StatelessWidget {
  const PanDetailView({super.key});

  Future<List<String>> getUploadPanOptionsWithBeneficialOwner(BuildContext context) async {
    final businessType = await KycStepUtils.getBusinessType();

    if (businessType == 'limited_liability_partnership') {
      return ["Authorized Partner KYC", "Other Partner KYC", "Beneficial Owner's PAN"];
    } else if (businessType == 'partnership') {
      return ["Authorized Partner KYC", "Other Partner KYC", "Beneficial Owner's PAN"];
    } else {
      return ["Authorized Director KYC", "Other Director KYC", "Beneficial Owner's PAN"];
    }
  }

  Future<List<String>> getUploadPanOptionsWithoutBeneficialOwner(BuildContext context) async {
    final businessType = await KycStepUtils.getBusinessType();
    if (businessType == 'limited_liability_partnership') {
      return ["Authorized Partner KYC", "Other Partner KYC"];
    } else if (businessType == 'partnership') {
      return ["Authorized Partner KYC", "Other Partner KYC"];
    } else {
      return ["Authorized Director KYC", "Other Director KYC"];
    }
  }

  Future<List<String>> getUploadPanOptions(BuildContext context, BusinessAccountSetupState state) async {
    if ((state.isOtherDirectorPanCardSave == true && state.director2BeneficialOwner == true) ||
        (state.isDirectorPanCardSave == true && state.director1BeneficialOwner == true)) {
      return await getUploadPanOptionsWithoutBeneficialOwner(context);
    } else {
      return await getUploadPanOptionsWithBeneficialOwner(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      listenWhen:
          (previous, current) =>
              previous.isAuthorizedDirectorKycVerify != current.isAuthorizedDirectorKycVerify ||
              previous.isOtherDirectorKycVerify != current.isOtherDirectorKycVerify ||
              previous.isBeneficialOwnerPanCardSave != current.isBeneficialOwnerPanCardSave,
      listener: (context, state) async {
        if (state.isAuthorizedDirectorKycVerify == true &&
            state.selectedUploadPanOption == (await getUploadPanOptions(context, state))[0]) {
          GoRouter.of(context).pop();
        }

        if (state.isOtherDirectorKycVerify == true &&
            state.selectedUploadPanOption == (await getUploadPanOptions(context, state))[1]) {
          GoRouter.of(context).pop();
          GoRouter.of(context).pop();
        }

        if (state.isBeneficialOwnerPanCardSave == true &&
            state.selectedUploadPanOption == (await getUploadPanOptions(context, state))[2]) {
          GoRouter.of(context).pop();
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
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
                    title: Lang.of(context).lbl_director_identity_details,
                    description: Lang.of(context).lbl_director_identity_details_description,
                  ),
                  buildSizedBoxH(30.0),
                  FutureBuilder<List<String>>(
                    future: getUploadPanOptions(context, state),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }
                      final options = snapshot.data!;
                      return Column(
                        children: List.generate(options.length, (index) {
                          return CustomTileWidget(
                            title: options[index].toString(),
                            isSelected: state.selectedUploadPanOption == options[index],
                            onTap: () async {
                              // Mark data as changed for pan detail view
                              context.read<BusinessAccountSetupBloc>().add(MarkPanDetailViewDataChanged());
                              context.read<BusinessAccountSetupBloc>().add(
                                ChangeSelectedPanUploadOption(panUploadOption: options[index]),
                              );
                              await showUploadPanDialog(options[index], context);
                            },
                            isShowTrailing: true,
                          );
                        }),
                      );
                    },
                  ),
                  buildSizedBoxH(14.0),
                  _buildNextButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<bool> isShowDoneIcon(BusinessAccountSetupState state) {
    return [
      state.isBusinessPanCardSave ?? false,
      state.isDirectorPanCardSave ?? false,
      state.isBeneficialOwnerPanCardSave ?? false,
      state.isbusinessRepresentativePanCardSave ?? false,
    ];
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

  Widget _buildNextButton() {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        final isDisable =
            (state.isAuthorizedDirectorKycVerify) &&
            (state.isOtherDirectorKycVerify) &&
            ((state.isBeneficialOwnerPanCardSave ?? false) ||
                ((state.isOtherDirectorPanCardSave == true && state.director2BeneficialOwner == true) ||
                    (state.isDirectorPanCardSave == true && state.director1BeneficialOwner == true)));

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
            isLoading: state.isPanDetailVerifyLoading ?? false,
            isDisabled: !isDisable,
            tooltipMessage: Lang.of(context).lbl_tooltip_text,
            onPressed:
                isDisable
                    ? () async {
                      context.read<BusinessAccountSetupBloc>().add(VerifyPanSubmitted());
                    }
                    : null,
          ),
        );
      },
    );
  }

  Future<void> showUploadPanDialog(String option, BuildContext context) async {
    final businessType = await KycStepUtils.getBusinessType();
    Widget? dialog;
    if (businessType == 'limited_liability_partnership' || businessType == 'partnership') {
      switch (option) {
        case "Authorized Partner KYC":
          // Reset to first step when opening dialog
          context.read<BusinessAccountSetupBloc>().add(DirectorKycStepChanged(DirectorKycSteps.panDetails));
          dialog = AuthorizedDirectorKycDialog();
          break;
        case "Other Partner KYC":
          // Reset to first step when opening dialog
          context.read<BusinessAccountSetupBloc>().add(OtherDirectorKycStepChanged(OtherDirectorKycSteps.panDetails));
          dialog = OtherDirectorKycDialog();
          break;
        case "Beneficial Owner's PAN":
          // Reset to first step when opening dialog
          context.read<BusinessAccountSetupBloc>().add(
            BeneficialOwnerKycStepChanged(BeneficialOwnerKycSteps.panDetails),
          );
          dialog = BeneficialOwnerPanUploadDialog();
          break;
      }
    } else {
      switch (option) {
        case "Authorized Director KYC":
          // Reset to first step when opening dialog
          context.read<BusinessAccountSetupBloc>().add(DirectorKycStepChanged(DirectorKycSteps.panDetails));
          dialog = AuthorizedDirectorKycDialog();
          break;
        case "Other Director KYC":
          // Reset to first step when opening dialog
          context.read<BusinessAccountSetupBloc>().add(OtherDirectorKycStepChanged(OtherDirectorKycSteps.panDetails));
          dialog = OtherDirectorKycDialog();
          break;
        case "Beneficial Owner's PAN":
          // Reset to first step when opening dialog
          context.read<BusinessAccountSetupBloc>().add(
            BeneficialOwnerKycStepChanged(BeneficialOwnerKycSteps.panDetails),
          );
          dialog = BeneficialOwnerPanUploadDialog();
          break;
      }
    }
    if (dialog != null) {
      showDialog(context: context, builder: (context) => dialog!);
    }
  }
}
