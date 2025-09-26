import 'dart:convert';

import 'package:exchek/core/utils/exports.dart';

class IceVerificationView extends StatelessWidget {
  IceVerificationView({super.key});

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

                    final businessNature = userDetail['business_details']['business_nature'];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildSizedBoxH(20.0),
                        _buildSelectionTitleAndDescription(
                          context: context,
                          title: Lang.of(context).lbl_ice_number_certificate_upload,
                          description: Lang.of(context).lbl_provide_import_export_international_regulation,
                        ),
                        buildSizedBoxH(30.0),
                        Form(
                          key: state.iceVerificationKey,
                          child: Column(
                            children: [
                              _buildIceNumberField(context, state),
                              buildSizedBoxH(24.0),
                              _buildUploadIecCertificate(context, state),
                              buildSizedBoxH(30.0),
                              if (businessNature == "Export of goods") ...[
                                buildSizedBoxH(30.0),
                                _buildNextButton(),
                              ] else ...[
                                if (ResponsiveHelper.isWebAndIsNotMobile(context))
                                  Row(
                                    spacing: 10.0,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [_buildSkipButton(), _buildNextButton()],
                                  )
                                else
                                  Row(
                                    spacing: 10.0,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Expanded(child: _buildSkipButton()),
                                      Expanded(child: _buildNextButton()),
                                    ],
                                  ),
                              ],

                              // _buildNextButton(),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
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

  Widget _buildIceNumberField(BuildContext context, BusinessAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_ice_number,
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
          controller: state.iceNumberController,
          textInputAction: TextInputAction.done,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
          validator: ExchekValidations.validateIceCertificateNumber,
          shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForIECValidation,
          maxLength: 10,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: [UpperCaseTextFormatter(), NoPasteFormatter()],
          onChanged: (input) {
            // Tell BLoC about input change to handle uppercase conversion
            context.read<BusinessAccountSetupBloc>().add(IceNumberChanged(input));
            // Mark data as changed for ICE verification
            context.read<BusinessAccountSetupBloc>().add(MarkIceVerificationDataChanged());
          },
          contextMenuBuilder: customContextMenuBuilder,
        ),
      ],
    );
  }

  Widget _buildUploadIecCertificate(BuildContext context, BusinessAccountSetupState state) {
    return CustomFileUploadWidget(
      title: Lang.of(context).lbl_upload_ice_certificate,
      selectedFile: state.iceCertificateFile,
      onFileSelected: (fileData) {
        context.read<BusinessAccountSetupBloc>().add(UploadICECertificate(fileData));
        // Mark data as changed for ICE verification
        context.read<BusinessAccountSetupBloc>().add(MarkIceVerificationDataChanged());
      },
      documentNumber: state.iceNumberController.text,
      documentType: "IEC",
      kycRole: "",
      screenName: "BUSINESS_LEGAL_DOC",
    );
  }

  Widget _buildNextButton() {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        final isButtonEnabled = state.iceCertificateFile != null && state.iceNumberController.text.isNotEmpty;

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
            isLoading: state.isIceVerifyingLoading ?? false,
            isDisabled: !isButtonEnabled,
            tooltipMessage: Lang.of(context).lbl_tooltip_text,
            onPressed:
                isButtonEnabled
                    ? () {
                      if (state.iceVerificationKey.currentState?.validate() ?? false) {
                        context.read<BusinessAccountSetupBloc>().add(
                          ICEVerificationSubmitted(
                            fileData: state.iceCertificateFile,
                            iceNumber: state.iceNumberController.text,
                          ),
                        );
                      }
                    }
                    : null,
          ),
        );
      },
    );
  }

  Widget _buildSkipButton() {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        return Align(
          alignment: Alignment.centerRight,
          child: AnimatedBuilder(
            animation: Listenable.merge([state.iceNumberController]),
            builder: (context, child) {
              return CustomElevatedButton(
                isShowTooltip: true,
                text: Lang.of(context).lbl_skip,
                borderRadius: 8.0,
                width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 125 : double.maxFinite,
                buttonTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                  color: Theme.of(context).customColors.primaryColor,
                ),
                tooltipMessage: Lang.of(context).lbl_tooltip_text,
                buttonStyle: ButtonThemeHelper.textButtonStyle(context),
                onPressed: () async {
                  // state.iceCertificateFile = null;
                  // state.iceNumberController.clear();
                  // final nextStep = await KycStepUtils.getNextStep(state.currentKycVerificationStep, state);
                  // if (nextStep != null) {
                  //   context.read<BusinessAccountSetupBloc>().add(KycStepChanged(nextStep));
                  // }
                  context.read<BusinessAccountSetupBloc>().add(ICEVerificationSkipped());
                },
              );
            },
          ),
        );
      },
    );
  }
}
