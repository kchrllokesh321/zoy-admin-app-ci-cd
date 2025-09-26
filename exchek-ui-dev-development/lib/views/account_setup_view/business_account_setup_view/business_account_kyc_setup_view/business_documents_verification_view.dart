import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/widgets/account_setup_widgets/aadhar_upload_note.dart';

class BusinessDocumentsVerificationView extends StatelessWidget {
  const BusinessDocumentsVerificationView({super.key});

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
                      title:
                          "Do you have at least 3 of the following 4 documents (Shop Licence, Udyam, Tax Registration, Utility Bill)?",
                      description:
                          "If you don’t have GSTIN or IEC, you can verify your Sole Proprietorship by uploading 3 of the following 4 documents: Shop & Establishment Certificate, Udyam Certificate, Tax Registration, or a recent Utility Bill.",
                    ),
                    buildSizedBoxH(14.0),
                    _buildYesNoOptionForSamaAadhaarAddress(context, state),
                    if (state.isGSTINOrIECHasUploaded == 0) ...[
                      buildSizedBoxH(30.0),
                      _buildUploadShopEstablishmentCertificate(context, state),
                      buildSizedBoxH(30.0),
                      _buildUploadUdyamCertificate(context, state),
                      buildSizedBoxH(30.0),
                      _buildUploadTaxProfessionalTaxRegistration(context, state),
                      buildSizedBoxH(30.0),
                      _buildUploadUtilityBill(context, state),
                    ] else ...[
                      buildSizedBoxH(30.0),
                      UploadNote(
                        title: "Account Updated to Freelancer",
                        notes: [
                          "Since you don't have GSTIN, IEC, or the required business documents, your account will be set up as a Freelancer account. You can continue using the platform with full access as a freelancer.",
                        ],
                      ),
                    ],
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
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 24, tablet: 26, desktop: 28),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.32,
          ),
        ),
        buildSizedBoxH(14.0),
        Text(
          description,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 12, tablet: 14, desktop: 14),
            fontWeight: FontWeight.w400,
            color: Theme.of(context).customColors.secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadShopEstablishmentCertificate(BuildContext context, BusinessAccountSetupState state) {
    return CustomFileUploadWidget(
      showInfoIcon: true,
      selectedFile: state.shopEstablishmentCertificateFile,
      title: "Upload Shop & Establishment Certificate",
      onFileSelected: (fileData) {
        context.read<BusinessAccountSetupBloc>().add(UploadShopEstablishmentCertificate(fileData));
        // Mark data as changed for business documents
        context.read<BusinessAccountSetupBloc>().add(MarkBusinessDocumentsDataChanged());
      },
      documentNumber: '',
      documentType: "",
      kycRole: "",
      screenName: "BUSINESS_LEGAL_DOC",
    );
  }

  Widget _buildUploadUdyamCertificate(BuildContext context, BusinessAccountSetupState state) {
    return CustomFileUploadWidget(
      showInfoIcon: true,
      selectedFile: state.udyamCertificateFile,
      title: "Upload Udyam Certificate",
      onFileSelected: (fileData) {
        context.read<BusinessAccountSetupBloc>().add(UploadUdyamCertificate(fileData));
        // Mark data as changed for business documents
        context.read<BusinessAccountSetupBloc>().add(MarkBusinessDocumentsDataChanged());
      },
      documentNumber: '',
      documentType: "",
      kycRole: "",
      screenName: "BUSINESS_LEGAL_DOC",
    );
  }

  Widget _buildUploadTaxProfessionalTaxRegistration(BuildContext context, BusinessAccountSetupState state) {
    return CustomFileUploadWidget(
      showInfoIcon: true,
      selectedFile: state.taxProfessionalTaxRegistrationFile,
      title: "Upload Tax/Professional Tax Registration",
      onFileSelected: (fileData) {
        context.read<BusinessAccountSetupBloc>().add(UploadTaxProfessionalTaxRegistration(fileData));
        // Mark data as changed for business documents
        context.read<BusinessAccountSetupBloc>().add(MarkBusinessDocumentsDataChanged());
      },
      documentNumber: '',
      documentType: "",
      kycRole: "",
      screenName: "BUSINESS_LEGAL_DOC",
    );
  }

  Widget _buildUploadUtilityBill(BuildContext context, BusinessAccountSetupState state) {
    return CustomFileUploadWidget(
      showInfoIcon: true,
      selectedFile: state.utilityBillFile,
      title: " Upload Utility Bill (Last 3 Months)",
      onFileSelected: (fileData) {
        context.read<BusinessAccountSetupBloc>().add(UploadUtilityBill(fileData));
        // Mark data as changed for business documents
        context.read<BusinessAccountSetupBloc>().add(MarkBusinessDocumentsDataChanged());
      },
      documentNumber: '',
      documentType: "",
      kycRole: "",
      screenName: "BUSINESS_LEGAL_DOC",
    );
  }

  Widget _buildYesNoOptionForSamaAadhaarAddress(BuildContext context, BusinessAccountSetupState state) {
    return Row(
      spacing: 20.0,
      children: List.generate(2, (index) {
        return Expanded(
          child: CustomTileWidget(
            title: index == 0 ? Lang.of(context).lbl_yes : Lang.of(context).lbl_no,
            isSelected: state.isGSTINOrIECHasUploaded == index,
            onTap: () {
              final bloc = BlocProvider.of<BusinessAccountSetupBloc>(context);
              bloc.add(GSTINOrIECHasUploaded(index));
              // Mark data as changed for business documents
              bloc.add(MarkBusinessDocumentsDataChanged());
            },
          ),
        );
      }),
    );
  }

  Widget _buildNextButton() {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        bool isButtonEnabled = false;

        if (state.isGSTINOrIECHasUploaded == 0) {
          // Count how many documents are uploaded
          int uploadedDocumentsCount = 0;
          if (state.shopEstablishmentCertificateFile != null) uploadedDocumentsCount++;
          if (state.udyamCertificateFile != null) uploadedDocumentsCount++;
          if (state.taxProfessionalTaxRegistrationFile != null) uploadedDocumentsCount++;
          if (state.utilityBillFile != null) uploadedDocumentsCount++;

          // Enable button if at least 3 documents are uploaded
          isButtonEnabled = uploadedDocumentsCount >= 3;
        } else {
          isButtonEnabled = true;
        }

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
            isDisabled: !isButtonEnabled,
            isLoading: state.isBusinessDocumentsVerificationLoading,
            onPressed:
                isButtonEnabled
                    ? () {
                      context.read<BusinessAccountSetupBloc>().add(BusinessDocumentsVerificationSubmitted(context));
                    }
                    : null,
          ),
        );
      },
    );
  }
}
