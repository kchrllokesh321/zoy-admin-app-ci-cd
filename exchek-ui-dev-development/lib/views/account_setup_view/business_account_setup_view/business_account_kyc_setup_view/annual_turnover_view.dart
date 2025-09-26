import 'dart:convert';
import 'package:exchek/core/utils/exports.dart';

class AnnualTurnoverView extends StatelessWidget {
  AnnualTurnoverView({super.key, this.scrollController});

  final ScrollController? scrollController;

  // Static cache to prevent future recreation
  static final Map<String, Future<List<String>>> _turnoverCache = {};

  List<String> moreTurnOverList(BuildContext context) => [
    "Less than ₹40 lakhs",
    "₹40 lakhs or more",
  ];

  List<String> lessTurnOverList(BuildContext context) => [
    "Less than ₹20 lakhs",
    "₹20 lakhs or more",
  ];

  Future<List<String>> getTurnoverList(BuildContext context) async {
    final user = await Prefobj.preferences.get(Prefkeys.userKycDetail);
    final userDetail = jsonDecode(user!);

    final businessNature = userDetail['business_details']['business_nature'];

    if (businessNature == "Export of goods") {
      return moreTurnOverList(context);
    } else if (businessNature == "Export of services") {
      return lessTurnOverList(context);
    } else if (businessNature == "Export of goods and services") {
      return moreTurnOverList(context);
    } else {
      return lessTurnOverList(context);
    }
  }

  Future<List<String>> _getCachedTurnoverList(BuildContext context) {
    // Use a simple cache key - you could make this more sophisticated
    const cacheKey = 'turnover_list';

    if (!_turnoverCache.containsKey(cacheKey)) {
      _turnoverCache[cacheKey] = getTurnoverList(context);
    }

    return _turnoverCache[cacheKey]!;
  }

  final Future<String?> _userFuture = Prefobj.preferences.get(
    Prefkeys.userKycDetail,
  );

  static final GlobalKey businessRecivePaymentKey = GlobalKey();

  String getPanNumber(BusinessAccountSetupState state) {
   
   final controllers = [
    state.companyPanNumberController,
    state.businessPanNumberController,
    state.director1PanNameController,
    state.hufPanNumberController,
    state.llpPanNumberController,
    state.kartaPanNumberController,
    state.director2PanNumberController,
    state.partnershipFirmPanNumberController,
    state.beneficialOwnerPanNumberController,
    state.soleProprietorShipPanNumberController,
    state.businessRepresentativePanNumberController,
  ];

  for (final controller in controllers) {
    if (controller.text.isNotEmpty) {
       Logger.info("Pan number >>> ${controller.text}");
      return controller.text;
    }
  }
 
    return "" ;
  }

  // Using common validation message checker from ExchekValidations

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        return Center(
          child: Container(
            margin: EdgeInsets.only(
              bottom: ResponsiveHelper.isWebAndIsNotMobile(context) ? 50 : 20,
            ),
            constraints: BoxConstraints(
              maxWidth: ResponsiveHelper.getMaxTileWidth(context),
            ),
            padding: EdgeInsetsGeometry.symmetric(
              horizontal:
                  ResponsiveHelper.isMobile(context)
                      ? (kIsWeb ? 30.0 : 20)
                      : 0.0,
            ),
            child: FutureBuilder(
              future: _userFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return const SizedBox.shrink();
                }
                final userDetail = jsonDecode(snapshot.data!);
                final businessDetails = userDetail['business_details'];
                final businessType =
                    businessDetails != null
                        ? businessDetails['business_type']
                        : null;
                final isPartnershipFirm = businessType == 'partnership';

                return isPartnershipFirm
                    ? Form(
                      key: state.annualTurnoverFormKey,
                      child: Column(
                        children: [
                          buildSizedBoxH(20.0),
                          _buildSelectionTitleAndDescription(
                            context: context,
                            title: "GST Details",
                            description:
                                "GST registration is not required based on your turnover. If you still have a GST number, you may enter it and upload the certificate.",
                          ),
                          buildSizedBoxH(30.0),
                          _buildGSTNumberField(context, state),
                          if (state.isGSTNumberVerify) ...[
                            buildSizedBoxH(24.0),
                            _buildVerifyGSTNameField(context, state),
                          ],
                          buildSizedBoxH(24.0),
                          _buildUploadGSTCertificate(state, context),
                          buildSizedBoxH(30.0),
                          _buildNextButton(isPartnershipFirm),
                        ],
                      ),
                    )
                    : Form(
                      key: state.annualTurnoverFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildSizedBoxH(20.0),
                          _buildSelectionTitleAndDescription(
                            context: context,
                            title:
                                Lang.of(
                                  context,
                                ).lbl_turnover_previous_financial_year,
                            description:
                                Lang.of(context).lbl_turnover_info_content,
                          ),
                          buildSizedBoxH(20.0),
                          _buildAnnualTurnOverOptions(context, state),
                          if ((state.selectedAnnualTurnover ?? '')
                              .isNotEmpty) ...[
                            if (state.isGstCertificateMandatory == true) ...[
                              buildSizedBoxH(30.0),
                              Column(
                                key: businessRecivePaymentKey,
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
                                  _buildNextButton(isPartnershipFirm),
                                ],
                              ),
                            ] else ...[
                              buildSizedBoxH(30.0),
                              Column(
                                key: businessRecivePaymentKey,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildGstTitleAndDescription(context, state),
                                  buildSizedBoxH(30.0),
                                  _buildGSTNumberField(context, state),
                                  AnimatedBuilder(
                                    animation: Listenable.merge([
                                      state.gstNumberController,
                                    ]),
                                    builder: (context, _) {
                                      return Column(
                                        children: [
                                          if (state.isGSTNumberVerify) ...[
                                            buildSizedBoxH(24.0),
                                            _buildVerifyGSTNameField(
                                              context,
                                              state,
                                            ),
                                          ],
                                          buildSizedBoxH(24.0),
                                          _buildUploadGSTCertificate(
                                            state,
                                            context,
                                          ),
                                          buildSizedBoxH(30.0),
                                          _buildNextButton(isPartnershipFirm),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ],
                      ),
                    );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnnualTurnOverOptions(
    BuildContext context,
    BusinessAccountSetupState state,
  ) {
    return FutureBuilder<List<String>>(
      future: _getCachedTurnoverList(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const SizedBox.shrink();
        }
        final turnoverList = snapshot.data!;
        return Column(
          children: List.generate(turnoverList.length, (index) {
            return CustomTileWidget(
              title: turnoverList[index],
              isSelected: state.selectedAnnualTurnover == turnoverList[index],
              onTap: () {
                final bloc = BlocProvider.of<BusinessAccountSetupBloc>(context);
                bloc.add(ChangeAnnualTurnover(turnoverList[index]));

                // Use a more direct approach for scrolling
                if (scrollController?.hasClients == true) {
                  print('ScrollController is available and has clients');
                  // Scroll to the GST section after a short delay to ensure UI updates
                  Future.delayed(const Duration(milliseconds: 200), () {
                    if (context.mounted &&
                        scrollController?.hasClients == true) {
                      // Find the GST section and scroll to it
                      final gstSection =
                          businessRecivePaymentKey.currentContext;
                      if (gstSection != null) {
                        print(
                          'GST section context found, attempting to scroll',
                        );
                        final renderObject = gstSection.findRenderObject();
                        if (renderObject != null &&
                            scrollController?.hasClients == true) {
                          print(
                            'Render object found, scrolling to GST section',
                          );
                          // Add haptic feedback for better user experience
                          HapticFeedback.lightImpact();

                          scrollController!.position.ensureVisible(
                            renderObject,
                            alignment: 0.3,
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          print(
                            'Render object not found or scroll controller lost clients',
                          );
                        }
                      } else {
                        print('GST section context not found');
                      }
                    }
                  });
                } else {
                  print(
                    'ScrollController not available or has no clients, using fallback',
                  );
                  // Fallback to bloc event if direct scroll doesn't work
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (context.mounted) {
                      context.read<BusinessAccountSetupBloc>().add(
                        AnnualTurnoverScrollToSection(
                          businessRecivePaymentKey,
                          scrollController: scrollController,
                        ),
                      );
                    }
                  });
                }
              },
            );
          }),
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
            fontSize: ResponsiveHelper.getFontSize(
              context,
              mobile: 28,
              tablet: 30,
              desktop: 32,
            ),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.32,
          ),
        ),
        buildSizedBoxH(14.0),
        Text(
          description,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(
              context,
              mobile: 14,
              tablet: 15,
              desktop: 16,
            ),
            fontWeight: FontWeight.w400,
            color: Theme.of(context).customColors.secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildGstTitleAndDescription(
    BuildContext context,
    BusinessAccountSetupState state,
  ) {
    return state.isGstCertificateMandatory
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

  Widget _buildGSTNumberField(
    BuildContext context,
    BusinessAccountSetupState state,
  ) {
        final panNumber = getPanNumber(state);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                Lang.of(context).lbl_gst_number,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: ResponsiveHelper.getFontSize(
                    context,
                    mobile: 14,
                    tablet: 15,
                    desktop: 16,
                  ),
                  fontWeight: FontWeight.w400,
                  height: 1.22,
                ),
              ),
            ),
            if (state.isGSTNumberVerify) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: InkWell(
                  mouseCursor: SystemMouseCursors.click,
                  onTap: () {
                    // Store original GST number before enabling edit to support skip-on-unchanged
                    context.read<BusinessAccountSetupBloc>().add(
                      BusinessStoreOriginalGstNumber(
                        state.gstNumberController.text,
                      ),
                    );
                    TextFieldUtils.focusAndMoveCursorToEnd(
                      context: context,
                      controller: state.gstNumberController,
                    );
                  },
                  child: Text(
                    Lang.of(context).lbl_edit,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: ResponsiveHelper.getFontSize(
                        context,
                        mobile: 14,
                        tablet: 15,
                        desktop: 16,
                      ),
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
        state.isGSTNumberVerify
            ? CommanVerifiedInfoBox(
              value: state.gstNumberController.text,
              showTrailingIcon: true,
            )
            : CustomTextInputField(
              context: context,
              type: InputType.text,
              controller: state.gstNumberController,
              maxLength: 15,
              textInputAction: TextInputAction.done,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 14.0,
              ),
              // validator: ExchekValidations.validateGST,
              validator:
                  (value) => ExchekValidations.validatePersonalGST(
                    value,
                    panNumber,
                    isOptional: false,
                  ),
              shouldShowInfoForMessage:
                  ExchekValidations.shouldShowInfoForGSTValidation,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onFieldSubmitted: (value) {
                // Change the validation check to:
                if (ExchekValidations.validatePersonalGST(
                      value,
                      panNumber,
                      isOptional: false,
                    ) ==
                    null) {
                  context.read<BusinessAccountSetupBloc>().add(
                    BusinessGSTVerification(
                      gstNumber: state.gstNumberController.text,
                      turnover: state.selectedAnnualTurnover.toString(),
                    ),
                  );
                }
              },
              suffixIcon:
                  state.isGstNumberVerifyingLoading
                      ? AppLoaderWidget(size: 20.0)
                      : null,
              onChanged: (value) {
                // Only mark changed if actually different from original
                final bloc = context.read<BusinessAccountSetupBloc>();
                final original = bloc.state.originalBusinessGstNumber;
                if (original != null && value != original) {
                  bloc.add(MarkAnnualTurnoverDataChanged());
                }
                if (value.length == 15) {
                  if (ExchekValidations.validatePersonalGST(
                        value,
                        panNumber,
                        isOptional: false,
                      ) ==
                      null) {
                    print(
                      'pan data for gst ${state.companyPanNumberController.text}',
                    );
                    print(
                      'pan data for gst ${state.companyPanNumberController.text}',
                    );
                    bloc.add(
                      BusinessGSTVerification(
                        gstNumber: state.gstNumberController.text,
                        turnover: state.selectedAnnualTurnover.toString(),
                      ),
                    );
                  }
                }
              },
              contextMenuBuilder: customContextMenuBuilder,
              inputFormatters: [NoPasteFormatter(), UpperCaseTextFormatter()],
            ),
      ],
    );
  }

  Widget _buildUploadGSTCertificate(
    BusinessAccountSetupState state,
    BuildContext context,
  ) {
    return CustomFileUploadWidget(
      selectedFile: state.gstCertificateFile,
      title: Lang.of(context).lbl_upload_GST_Certificate,
      onFileSelected: (fileData) {
        context.read<BusinessAccountSetupBloc>().add(
          UploadGstCertificateFile(fileData: fileData),
        );
        // Mark data as changed for annual turnover
        context.read<BusinessAccountSetupBloc>().add(
          MarkAnnualTurnoverDataChanged(),
        );
      },
      documentNumber: state.gstNumberController.text,
      documentType: "GST",
      kycRole: "",
      screenName: "GST",
    );
  }

  Widget _buildNextButton(bool isPartnershipFirm) {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        final panNumber = getPanNumber(state);
        return AnimatedBuilder(
          animation: Listenable.merge([
            state.turnOverController,
            state.gstNumberController,
          ]),
          builder: (context, _) {
            final isButtonEnabled =
                isPartnershipFirm
                    ? state.gstCertificateFile != null &&
                        state.gstLegalName != null &&
                        ExchekValidations.validatePersonalGST(
                              state.gstNumberController.text,
                              panNumber,
                              isOptional: false,
                            ) ==
                            null
                    : (state.isGstCertificateMandatory == true
                        ? state.gstCertificateFile != null &&
                            state.gstLegalName != null &&
                            ExchekValidations.validatePersonalGST(
                                  state.gstNumberController.text,
                                  panNumber,
                                  isOptional: false,
                                ) ==
                                null
                        : true);

            return Align(
              alignment: Alignment.centerRight,
              child: CustomElevatedButton(
                isShowTooltip: true,
                text: Lang.of(context).save_and_next,
                borderRadius: 8.0,
                width:
                    ResponsiveHelper.isWebAndIsNotMobile(context)
                        ? 120
                        : double.maxFinite,
                buttonTextStyle: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(
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
                          if (isPartnershipFirm) {
                            if (state.annualTurnoverFormKey.currentState!
                                .validate()) {
                              context.read<BusinessAccountSetupBloc>().add(
                                AnnualTurnOverVerificationSubmitted(
                                  gstCertificate: state.gstCertificateFile,
                                  gstNumber: state.gstNumberController.text,
                                ),
                              );
                            }
                          } else {
                            if (state.isGstCertificateMandatory == true) {
                              if (state.annualTurnoverFormKey.currentState!
                                  .validate()) {
                                context.read<BusinessAccountSetupBloc>().add(
                                  AnnualTurnOverVerificationSubmitted(
                                    gstCertificate: state.gstCertificateFile,
                                    gstNumber: state.gstNumberController.text,
                                  ),
                                );
                              }
                            } else {
                              if (state.gstNumberController.text.isNotEmpty &&
                                  state.gstCertificateFile != null) {
                                if (state.annualTurnoverFormKey.currentState!
                                    .validate()) {
                                  context.read<BusinessAccountSetupBloc>().add(
                                    AnnualTurnOverVerificationSubmitted(
                                      gstCertificate: state.gstCertificateFile,
                                      gstNumber: state.gstNumberController.text,
                                    ),
                                  );
                                }
                              } else {
                                final currentIndex =
                                    state.currentKycVerificationStep.index;
                                if (currentIndex <
                                    PersonalEKycVerificationSteps
                                            .values
                                            .length -
                                        1) {
                                  context.read<BusinessAccountSetupBloc>().add(
                                    KycStepChanged(
                                      KycVerificationSteps.values[currentIndex +
                                          1],
                                    ),
                                  );
                                }
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

  Widget _buildVerifyGSTNameField(
    BuildContext context,
    BusinessAccountSetupState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Legal Entity Name",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(
              context,
              mobile: 14,
              tablet: 15,
              desktop: 16,
            ),
            fontWeight: FontWeight.w400,
            height: 1.22,
          ),
        ),
        buildSizedBoxH(8.0),
        CommanVerifiedInfoBox(value: state.gstLegalName ?? ''),
      ],
    );
  }

  // Widget _buildVerifyButton() {
  //   return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
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
  //                           context.read<BusinessAccountSetupBloc>().add(
  //                             BusinessGSTVerification(
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
