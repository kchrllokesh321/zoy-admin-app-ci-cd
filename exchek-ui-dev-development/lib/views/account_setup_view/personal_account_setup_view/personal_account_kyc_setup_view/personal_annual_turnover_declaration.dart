import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/viewmodels/account_setup_bloc/personal_account_setup_bloc/personal_account_setup_bloc.dart';

class PersonalAnnualTurnoverDeclaration extends StatelessWidget {
  const PersonalAnnualTurnoverDeclaration({super.key, this.scrollController});

  final ScrollController? scrollController;

  // Global key for scrolling to GST section
  static final GlobalKey personalGstSectionKey = GlobalKey();

  List<String> getTurnoverList(BuildContext context) => ["Less than ₹20 lakhs", "₹20 lakhs or more"];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalAccountSetupBloc, PersonalAccountSetupState>(
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
                child: Form(
                  key: state.annualTurnoverFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSizedBoxH(20.0),
                      _buildSelectionTitleAndDescription(
                        context: context,
                        title: Lang.of(context).lbl_turnover_previous_financial_year,
                        description: Lang.of(context).lbl_turnover_info_content,
                      ),
                      buildSizedBoxH(20.0),
                      _buildAnnualTurnOverOptions(context, state),
                      if ((state.selectedAnnualTurnover ?? '').isNotEmpty) ...[
                        if (state.isGstCertificateMandatory == true) ...[
                          buildSizedBoxH(30.0),
                          Column(
                            key: personalGstSectionKey,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildGstTitleAndDescription(context, state),
                              buildSizedBoxH(30.0),
                              _buildGSTNumberField(context, state),
                              if (state.isGSTNumberVerify) ...[
                                buildSizedBoxH(24.0),
                                _buildVerifyGSTNameField(context, state),
                              ],
                              buildSizedBoxH(24.0),
                              _buildUploadGSTCertificate(state, context),
                              buildSizedBoxH(30.0),
                              _buildNextButton(),
                            ],
                          ),
                        ] else ...[
                          buildSizedBoxH(30.0),
                          Column(
                            key: personalGstSectionKey,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildGstTitleAndDescription(context, state),
                              buildSizedBoxH(30.0),
                              _buildGSTNumberField(context, state),
                              if (state.isGSTNumberVerify) ...[
                                buildSizedBoxH(24.0),
                                _buildVerifyGSTNameField(context, state),
                              ],
                              buildSizedBoxH(24.0),
                              _buildUploadGSTCertificate(state, context),
                              buildSizedBoxH(30.0),
                              _buildNextButton(),
                            ],
                          ),
                        ],
                      ],
                    ],
                  ),
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

  Widget _buildAnnualTurnOverOptions(BuildContext context, PersonalAccountSetupState state) {
    return Column(
      children: List.generate(getTurnoverList(context).length, (index) {
        return CustomTileWidget(
          title: getTurnoverList(context)[index],
          isSelected: state.selectedAnnualTurnover == getTurnoverList(context)[index],
          onTap: () {
            final bloc = BlocProvider.of<PersonalAccountSetupBloc>(context);
            bloc.add(PersonalChangeAnnualTurnover(getTurnoverList(context)[index]));
            // Mark data as changed for annual turnover
            bloc.add(PersonalMarkAnnualTurnoverDataChanged());

            // Add scroll functionality to GST section
            if (scrollController?.hasClients == true) {
              Future.delayed(const Duration(milliseconds: 200), () {
                if (context.mounted && scrollController?.hasClients == true) {
                  // Find the GST section and scroll to it
                  final gstSection = personalGstSectionKey.currentContext;
                  if (gstSection != null) {
                    final renderObject = gstSection.findRenderObject();
                    if (renderObject != null && scrollController?.hasClients == true) {
                      // Add haptic feedback for better user experience
                      HapticFeedback.lightImpact();

                      scrollController!.position.ensureVisible(
                        renderObject,
                        alignment: 0.3,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOut,
                      );
                    } else {}
                  } else {}
                }
              });
            } else {}
          },
        );
      }),
    );
  }

  Widget _buildGstTitleAndDescription(BuildContext context, PersonalAccountSetupState state) {
    return (state.isGstCertificateMandatory ?? false)
        ? _buildSelectionTitleAndDescription(
          context: context,
          title: Lang.of(context).lbl_gst_detail_required,
          description: Lang.of(context).lbl_gst_detail_required_content,
        )
        : _buildSelectionTitleAndDescription(
          context: context,
          title: Lang.of(context).lbl_gst_detail_optional,
          description: Lang.of(context).lbl_gst_detail_optional_content,
        );
  }

  Widget _buildGSTNumberField(BuildContext context, PersonalAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 10.0,
          children: [
            Expanded(
              child: Text(
                Lang.of(context).lbl_gst_number,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
                  fontWeight: FontWeight.w400,
                  height: 1.22,
                ),
              ),
            ),
            if (state.isGSTNumberVerify)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: InkWell(
                  mouseCursor: SystemMouseCursors.click,
                  onTap: () {
                    // Store original GST number before enabling edit
                    context.read<PersonalAccountSetupBloc>().add(
                      PersonalStoreOriginalGstNumber(state.gstNumberController.text),
                    );
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
        ),
        buildSizedBoxH(8.0),
        state.isGSTNumberVerify
            ? CommanVerifiedInfoBox(value: state.gstNumberController.text, showTrailingIcon: true)
            : CustomTextInputField(
              context: context,
              type: InputType.text,
              controller: state.gstNumberController,
              maxLength: 15,
              textInputAction: TextInputAction.done,
              contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
              validator: ExchekValidations.validateGST,
              shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForGSTValidation,
              onChanged: (value) {
                // Only mark data as changed if the value is different from original
                if (state.originalGstNumber != null && value != state.originalGstNumber) {
                  context.read<PersonalAccountSetupBloc>().add(PersonalMarkAnnualTurnoverDataChanged());
                }
                if (value.length == 15) {
                  if (state.annualTurnoverFormKey.currentState!.validate()) {
                    context.read<PersonalAccountSetupBloc>().add(
                      PersonalGSTVerification(
                        gstNumber: state.gstNumberController.text,
                        turnover: state.selectedAnnualTurnover.toString(),
                      ),
                    );
                  }
                }
              },
              onFieldSubmitted: (value) {
                if (state.annualTurnoverFormKey.currentState!.validate()) {
                  context.read<PersonalAccountSetupBloc>().add(
                    PersonalGSTVerification(
                      gstNumber: state.gstNumberController.text,
                      turnover: state.selectedAnnualTurnover.toString(),
                    ),
                  );
                }
              },
              suffixIcon: state.isGstNumberVerifyingLoading ? AppLoaderWidget(size: 20.0) : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              contextMenuBuilder: customContextMenuBuilder,
              inputFormatters: [NoPasteFormatter(), UpperCaseTextFormatter()],
            ),
      ],
    );
  }

  Widget _buildVerifyGSTNameField(BuildContext context, PersonalAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Legal Entity Name",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
            fontWeight: FontWeight.w400,
            height: 1.22,
          ),
        ),
        buildSizedBoxH(8.0),
        CommanVerifiedInfoBox(value: state.gstLegalName ?? ''),
      ],
    );
  }

  Widget _buildUploadGSTCertificate(PersonalAccountSetupState state, BuildContext context) {
    return CustomFileUploadWidget(
      selectedFile: state.gstCertificateFile,
      title: Lang.of(context).lbl_upload_GST_Certificate,
      onFileSelected: (fileData) {
        context.read<PersonalAccountSetupBloc>().add(PersonalUploadGstCertificateFile(fileData: fileData));
        // Mark data as changed for annual turnover
        context.read<PersonalAccountSetupBloc>().add(PersonalMarkAnnualTurnoverDataChanged());
      },
      documentNumber: state.gstNumberController.text,
      documentType: "",
      kycRole: "",
      screenName: "GST",
    );
  }

  // Widget _buildSkipButtom(BuildContext context, PersonalAccountSetupState state) {
  //   return CustomElevatedButton(
  //     buttonStyle: ButtonThemeHelper.textButtonStyle(context),
  //     text: Lang.of(context).lbl_skip,
  //     width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 150 : double.maxFinite,
  //     buttonTextStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
  //       fontWeight: FontWeight.w500,
  //       fontSize: 16.0,
  //       color: Theme.of(context).customColors.primaryColor,
  //     ),
  //     onPressed: () {
  //       final index = state.currentKycVerificationStep.index;
  //       if (index < KycVerificationSteps.values.length - 1) {
  //         context.read<PersonalAccountSetupBloc>().add(
  //           PersonalKycStepChange(PersonalEKycVerificationSteps.values[index + 1]),
  //         );
  //       }
  //     },
  //   );
  // }

  Widget _buildNextButton() {
    return BlocBuilder<PersonalAccountSetupBloc, PersonalAccountSetupState>(
      builder: (context, state) {
        return AnimatedBuilder(
          animation: Listenable.merge([state.gstNumberController]),
          builder: (context, _) {
            final isButtonEnabled =
                state.isGstCertificateMandatory == true
                    ? state.gstCertificateFile != null &&
                        state.gstLegalName != null &&
                        ExchekValidations.validateGST(state.gstNumberController.text) == null &&
                        state.isGSTNumberVerify
                    : true;
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
                tooltipMessage: Lang.of(context).lbl_tooltip_text,
                isDisabled: !isButtonEnabled,
                isLoading: state.isGstVerificationLoading ?? false,
                onPressed:
                    isButtonEnabled
                        ? () {
                          if (state.isGstCertificateMandatory == true) {
                            if (state.annualTurnoverFormKey.currentState!.validate()) {
                              context.read<PersonalAccountSetupBloc>().add(
                                PersonalAnnualTurnOverVerificationSubmitted(
                                  gstCertificate: state.gstCertificateFile,
                                  gstNumber: state.gstNumberController.text,
                                ),
                              );
                            }
                          } else {
                            if (state.gstNumberController.text.isNotEmpty && state.gstCertificateFile != null) {
                              if (state.annualTurnoverFormKey.currentState!.validate()) {
                                context.read<PersonalAccountSetupBloc>().add(
                                  PersonalAnnualTurnOverVerificationSubmitted(
                                    gstCertificate: state.gstCertificateFile,
                                    gstNumber: state.gstNumberController.text,
                                  ),
                                );
                              }
                            } else {
                              final currentIndex = state.currentKycVerificationStep.index;
                              if (currentIndex < PersonalEKycVerificationSteps.values.length - 1) {
                                context.read<PersonalAccountSetupBloc>().add(
                                  PersonalKycStepChange(PersonalEKycVerificationSteps.values[currentIndex + 1]),
                                );
                              }
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

  // Widget _buildVerifyButton() {
  //   return BlocBuilder<PersonalAccountSetupBloc, PersonalAccountSetupState>(
  //     builder: (context, state) {
  //       return AnimatedBuilder(
  //         animation: Listenable.merge([state.gstNumberController]),
  //         builder: (context, _) {
  //           final isButtonEnabled = state.gstNumberController.text.isNotEmpty && state.selectedAnnualTurnover != null;
  //           return Align(
  //             alignment: Alignment.centerRight,
  //             child: CustomElevatedButton(
  //               isShowTooltip: true,
  //               text: Lang.of(context).lbl_verify,
  //               borderRadius: 8.0,
  //               width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 125 : double.maxFinite,
  //               buttonTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //                 fontWeight: FontWeight.w500,
  //                 fontSize: 16.0,
  //                 color: Theme.of(context).colorScheme.onPrimary,
  //               ),
  //               tooltipMessage: Lang.of(context).lbl_tooltip_text,
  //               isDisabled: !isButtonEnabled,
  //               isLoading: state.isGstVerificationLoading ?? false,
  //               onPressed:
  //                   isButtonEnabled
  //                       ? () {
  //                         if (state.annualTurnoverFormKey.currentState!.validate()) {
  //                           context.read<PersonalAccountSetupBloc>().add(
  //                             PersonalGSTVerification(
  //                               gstNumber: state.gstNumberController.text,
  //                               turnover: state.selectedAnnualTurnover.toString(),
  //                             ),
  //                           );
  //                         }
  //                       }
  //                       : null,
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
}
