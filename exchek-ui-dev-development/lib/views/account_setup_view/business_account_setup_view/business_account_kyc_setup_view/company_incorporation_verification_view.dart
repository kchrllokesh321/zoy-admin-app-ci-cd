import 'dart:convert';
import 'package:exchek/core/utils/exports.dart';

class CompanyIncorporationVerificationView extends StatelessWidget {
  CompanyIncorporationVerificationView({super.key});

  final Future<String?> _userFuture = Prefobj.preferences.get(Prefkeys.userKycDetail);

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
                child: FutureBuilder(
                  future: _userFuture,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data == null) {
                      return const SizedBox.shrink();
                    }
                    final userDetail = jsonDecode(snapshot.data!);
                    final businessDetails = userDetail['business_details'];
                    final businessType = businessDetails != null ? businessDetails['business_type'] : null;
                    return _buildCertificateOfBusiness(context, state, businessType);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCertificateOfBusiness(BuildContext context, BusinessAccountSetupState state, String businessType) {
    if (businessType == 'limited_liability_partnership') {
      return Form(
        key: state.cinVerificationKey,
        child: Column(
          children: [
            buildSizedBoxH(20.0),
            _buildSelectionTitleAndDescription(
              context: context,
              title: Lang.of(context).lbl_LLPIN_number_certificate,
              description: Lang.of(context).lbl_LLPIN_number_certificate_content,
            ),
            buildSizedBoxH(30.0),
            _buildLLPINNumberField(context, state),
            buildSizedBoxH(24.0),
            _buildUploadCOICertificate(context, state.llpinNumberController.text, state),
            buildSizedBoxH(24.0),
            _buildUploadLLPAgreement(context, state),
            buildSizedBoxH(30.0),
            _buildNextButton(businessType),
          ],
        ),
      );
    } else if (businessType == "partnership") {
      return Form(
        key: state.cinVerificationKey,
        child: Column(
          children: [
            buildSizedBoxH(20.0),
            _buildSelectionTitleAndDescription(
              context: context,
              title: Lang.of(context).lbl_upload_partnership_deed,
              description: Lang.of(context).lbl_upload_partners_rights_responsibilities,
            ),
            buildSizedBoxH(30.0),
            _buildUploadPartnerShipDeed(context, state),
            buildSizedBoxH(30.0),
            _buildNextButton(businessType),
          ],
        ),
      );
    } else if (businessType == "company") {
      return Form(
        key: state.cinVerificationKey,
        child: Column(
          children: [
            buildSizedBoxH(20.0),
            _buildSelectionTitleAndDescription(
              context: context,
              title: Lang.of(context).lbl_CIN_number_and_certificate_of_incorporation,
              description: Lang.of(context).lbl_verify_company_registration_incorporation_details,
            ),
            buildSizedBoxH(30.0),
            _buildCINNumberField(context, state),
            buildSizedBoxH(24.0),
            _buildUploadCOICertificate(context, state.cinNumberController.text, state),
            buildSizedBoxH(30.0),
            _buildNextButton(businessType),
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
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

  Widget _buildCINNumberField(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_cin_number,
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
          controller: state.cinNumberController,
          textInputAction: TextInputAction.done,
          maxLength: 21,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
          validator: ExchekValidations.validateCIN,
          shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForCINNumberValidation,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: [UpperCaseTextFormatter(), NoPasteFormatter()],
          contextMenuBuilder: customContextMenuBuilder,
          onChanged: (value) {
            // Mark data as changed for company incorporation
            context.read<BusinessAccountSetupBloc>().add(MarkCompanyIncorporationDataChanged());
          },
        ),
      ],
    );
  }

  Widget _buildUploadCOICertificate(BuildContext context, String documentNumber, BusinessAccountSetupState state) {
    return CustomFileUploadWidget(
      selectedFile: state.coiCertificateFile,
      title: Lang.of(context).lbl_upload_COI_certificate,
      onFileSelected: (fileData) {
        context.read<BusinessAccountSetupBloc>().add(UploadCOICertificate(fileData));
        // Mark data as changed for company incorporation
        context.read<BusinessAccountSetupBloc>().add(MarkCompanyIncorporationDataChanged());
      },
      documentNumber: documentNumber,
      documentType: "CIN",
      kycRole: "",
      screenName: "BUSINESS_LEGAL_DOC",
    );
  }

  Widget _buildUploadLLPAgreement(BuildContext context, BusinessAccountSetupState state) {
    return CustomFileUploadWidget(
      selectedFile: state.uploadLLPAgreementFile,
      title: Lang.of(context).lbl_upload_llp_agreement,
      onFileSelected: (fileData) {
        context.read<BusinessAccountSetupBloc>().add(UploadLLPAgreement(fileData));
        // Mark data as changed for company incorporation
        context.read<BusinessAccountSetupBloc>().add(MarkCompanyIncorporationDataChanged());
      },
      documentNumber: state.llpinNumberController.text,
      documentType: "LLPIN",
      kycRole: "",
      screenName: "BUSINESS_LEGAL_DOC",
    );
  }

  Widget _buildUploadPartnerShipDeed(BuildContext context, BusinessAccountSetupState state) {
    return CustomFileUploadWidget(
      allowZipFiles: true,
      allowedExtensions: const ['jpeg', 'png', 'pdf', 'zip'],
      selectedFile: state.uploadPartnershipDeed,
      onFileSelected: (fileData) {
        context.read<BusinessAccountSetupBloc>().add(UploadPartnershipDeed(fileData));
        // Mark data as changed for company incorporation
        context.read<BusinessAccountSetupBloc>().add(MarkCompanyIncorporationDataChanged());
      },
      documentNumber: '',
      documentType: "PARTNERSHIP_DEED",
      kycRole: "",
      screenName: "BUSINESS_LEGAL_DOC",
    );
  }

  Widget _buildLLPINNumberField(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).llpin_number,
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
          controller: state.llpinNumberController,
          textInputAction: TextInputAction.done,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
          validator: ExchekValidations.validateLLPIN,
          shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForLLPINNumberValidation,
          maxLength: 7,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: [UpperCaseTextFormatter(), NoPasteFormatter()],
          contextMenuBuilder: customContextMenuBuilder,
          onChanged: (value) {
            // Mark data as changed for company incorporation
            context.read<BusinessAccountSetupBloc>().add(MarkCompanyIncorporationDataChanged());
          },
        ),
      ],
    );
  }

  Widget _buildNextButton(String businessType) {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        bool isButtonEnabled = false;

        // Check conditions based on selected business entity type
        if (businessType == "company") {
          // For Company: CIN number and COI certificate required
          isButtonEnabled = state.coiCertificateFile != null && state.cinNumberController.text.isNotEmpty;
        } else if (businessType == "limited_liability_partnership") {
          // For LLP: LLPIN number, COI certificate, and LLP Agreement required
          isButtonEnabled =
              state.llpinNumberController.text.isNotEmpty &&
              state.coiCertificateFile != null &&
              state.uploadLLPAgreementFile != null;
        } else if (businessType == "partnership") {
          // For Partnership Firm: Only Partnership Deed required
          isButtonEnabled = state.uploadPartnershipDeed != null;
        } else {
          isButtonEnabled = false;
        }

        return AnimatedBuilder(
          animation: Listenable.merge([state.cinNumberController, state.llpinNumberController]),
          builder: (context, _) {
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
                isLoading: state.isCINVerifyingLoading ?? false,
                isDisabled: !isButtonEnabled,
                tooltipMessage: Lang.of(context).lbl_tooltip_text,
                onPressed:
                    isButtonEnabled
                        ? () {
                          if (state.cinVerificationKey.currentState?.validate() ?? false) {
                            if (businessType == "company") {
                              context.read<BusinessAccountSetupBloc>().add(
                                CINVerificationSubmitted(
                                  cinNumber: state.cinNumberController.text,
                                  fileData: state.coiCertificateFile,
                                ),
                              );
                            } else if (businessType == "limited_liability_partnership") {
                              context.read<BusinessAccountSetupBloc>().add(
                                LLPINVerificationSubmitted(
                                  llpinNumber: state.llpinNumberController.text,
                                  coifile: state.coiCertificateFile,
                                  llpfile: state.uploadLLPAgreementFile,
                                ),
                              );
                            } else if (businessType == "partnership") {
                              context.read<BusinessAccountSetupBloc>().add(
                                PartnerShipDeedVerificationSubmitted(partnerShipDeedDoc: state.uploadPartnershipDeed),
                              );
                            }
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
}
