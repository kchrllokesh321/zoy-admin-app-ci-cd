import 'dart:convert';

import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/viewmodels/account_setup_bloc/personal_account_setup_bloc/personal_account_setup_bloc.dart';

class PersonalPanDetailView extends StatelessWidget {
  PersonalPanDetailView({super.key});

  final Future<String?> _userFuture = Prefobj.preferences.get(Prefkeys.userKycDetail);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _userFuture,
      builder: (context, snapshot) {
        final bool isFreelancer =
            (() {
              if (snapshot.hasData) {
                try {
                  final userDetail = jsonDecode(snapshot.data!);
                  return userDetail['personal_details']['payment_purpose'] == "freelancer";
                } catch (_) {
                  return false;
                }
              }
              return false;
            })();

        return BlocConsumer<PersonalAccountSetupBloc, PersonalAccountSetupState>(
          listenWhen:
              (previous, current) =>
                  previous.panVerificationSuccess != current.panVerificationSuccess && current.panVerificationSuccess,

          listener: (context, state) {
            if (state.panVerificationSuccess == true) {
              if (state.panOverwriteMismatch) {
                AppToast.show(
                  message: 'Legal Fullname auto-updated as per PAN records.',
                  type: ToastificationType.info,
                );
                context.read<PersonalAccountSetupBloc>().add(const PersonalConfirmOverwrite());
              } else {
                AppToast.show(message: 'PAN verification successful.', type: ToastificationType.success);
              }
            }
          },
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
                          title: Lang.of(context).lbl_upload_PAN_details_for_KYC,
                          description: Lang.of(context).lbl_provide_identity_regulatory_regulatory,
                        ),
                        buildSizedBoxH(30.0),
                        Form(
                          key: state.panVerificationKey,
                          child: Column(
                            children: [
                              _buildPanCardNumberField(context, state),
                              if ((state.panDetailsErrorMessage ?? '').isNotEmpty) ...[
                                CommanErrorMessage(errorMessage: state.panDetailsErrorMessage ?? ''),
                              ],
                              if ((state.personalPanEditErrorMessage ?? '').isNotEmpty) ...[
                                buildSizedBoxH(5.0),
                                CommanErrorMessage(errorMessage: state.personalPanEditErrorMessage ?? ''),
                              ],
                              if (state.isPanDetailsVerified == true) ...[
                                buildSizedBoxH(24.0),
                                _buildPersonalPanNameField(context, state),
                              ],
                              buildSizedBoxH(24.0),
                              _buildUploadPanCard(context, state, isFreelancer),
                              buildSizedBoxH(30.0),
                              _buildNextButton(),
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

  Widget _buildPersonalPanNameField(BuildContext context, PersonalAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_name_on_PAN,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
            fontWeight: FontWeight.w400,
            height: 1.22,
          ),
        ),
        buildSizedBoxH(8.0),
        CommanVerifiedInfoBox(value: state.panNameController.text, showTrailingIcon: true),
        // CustomTextInputField(
        //   context: context,
        //   type: InputType.text,
        //   controller: state.panNameController,
        //   textInputAction: TextInputAction.next,
        //   contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
        //   validator: ExchekValidations.validateRequired,
        // ),
      ],
    );
  }

  Widget _buildPanCardNumberField(BuildContext context, PersonalAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                Lang.of(context).lbl_pan_number,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
                  fontWeight: FontWeight.w400,
                  height: 1.22,
                ),
              ),
            ),

            if (state.isPersonalPanEditLocked || state.isPersonalPanModifiedAfterVerification) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: InkWell(
                  mouseCursor: SystemMouseCursors.click,
                  onTap: () {
                    if (!state.isPersonalPanEditLocked) {
                      // Store original PAN number before enabling edit
                      context.read<PersonalAccountSetupBloc>().add(
                        PersonalStoreOriginalPanNumber(state.panNumberController.text),
                      );
                      TextFieldUtils.focusAndMoveCursorToEnd(
                        context: context,
                        focusNode: state.panNumberFocusNode,
                        controller: state.panNumberController,
                      );
                    }
                    // Set modification flag when user clicks edit
                    context.read<PersonalAccountSetupBloc>().add(
                      PersonalPanNumberChanged(state.panNumberController.text),
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
          ],
        ),
        buildSizedBoxH(8.0),
        AbsorbPointer(
          absorbing: state.isPersonalPanEditLocked || state.isPersonalPanModifiedAfterVerification,
          child: CustomTextInputField(
            context: context,
            type: InputType.text,
            controller: state.panNumberController,
            textInputAction: TextInputAction.done,
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
            validator: ExchekValidations.validatePAN,
            shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForPANValidation,
            maxLength: 10,
            onChanged: (value) {
              if (!state.isPersonalPanEditLocked) {
                context.read<PersonalAccountSetupBloc>().add(PersonalPanNumberChanged(value));
                // Only mark data as changed if the value is different from original
                if (state.originalPanNumber != null && value != state.originalPanNumber) {
                  context.read<PersonalAccountSetupBloc>().add(PersonalMarkPanDetailsDataChanged());
                }
                if (value.length == 10) {
                  FocusScope.of(context).unfocus();
                  state.panVerificationKey.currentState?.validate();

                  if (ExchekValidations.validatePAN(value) == null) {
                    context.read<PersonalAccountSetupBloc>().add(GetPanDetails(value));
                  }
                }
              }
            },
            suffixIcon: state.isPanDetailsLoading == true ? AppLoaderWidget(size: 20) : null,
            onFieldSubmitted: (value) {
              if (!state.isPersonalPanEditLocked) {
                state.panVerificationKey.currentState?.validate();
                FocusScope.of(context).unfocus();
                if (ExchekValidations.validatePAN(value) == null) {
                  context.read<PersonalAccountSetupBloc>().add(GetPanDetails(value));
                }
              }
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: [UpperCaseTextFormatter(), NoPasteFormatter()],
            contextMenuBuilder: customContextMenuBuilder,
            focusNode: state.panNumberFocusNode,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadPanCard(BuildContext context, PersonalAccountSetupState state, bool isFreelancer) {
    return CustomFileUploadWidget(
      title: Lang.of(context).lbl_upload_pan_card,
      selectedFile: state.panFileData,
      onFileSelected: (fileData) {
        context.read<PersonalAccountSetupBloc>().add(PersonalUploadPanCard(fileData));
        // Mark data as changed for PAN details
        context.read<PersonalAccountSetupBloc>().add(PersonalMarkPanDetailsDataChanged());
      },
      documentNumber: state.panNumberController.text,
      documentType: "",
      kycRole: isFreelancer ? "FREELANCER" : "FAMILY_&_FRIENDS",
      screenName: "PAN",
    );
  }

  Widget _buildNextButton() {
    return BlocBuilder<PersonalAccountSetupBloc, PersonalAccountSetupState>(
      builder: (context, state) {
        final bloc = context.read<PersonalAccountSetupBloc>();
        final isEnabled =
            state.panFileData != null &&
            ExchekValidations.validatePAN(state.panNumberController.text) == null &&
            state.panNameController.text.isNotEmpty &&
            state.isPanDetailsVerified == true;

        return Align(
          alignment: Alignment.centerRight,
          child: CustomElevatedButton(
            text: Lang.of(context).save_and_next,
            borderRadius: 8.0,
            width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 120 : double.maxFinite,
            isLoading: state.isPanVerifyingLoading ?? false,
            isDisabled: !isEnabled,
            onPressed:
                !isEnabled
                    ? null
                    : () async {
                      if (!(state.panVerificationKey.currentState?.validate() ?? false)) return;

                      if (state.panOverwriteMismatch) {
                        // 🔹 Directly call API to override
                        bloc.add(
                          PersonalPanVerificationSubmitted(
                            fileData: state.panFileData,
                            panName: state.panNameController.text,
                            panNumber: state.panNumberController.text,
                            // override: true, // pass an extra flag if needed
                          ),
                        );

                        // AppToast.show(
                        //   message: "Legal Fullname auto-updated as per PAN records.",
                        //   type: ToastificationType.info,
                        // );

                        // bloc.add(const PersonalConfirmOverwrite());
                        // override after API success
                      } else {
                        // Normal PAN verification flow
                        bloc.add(
                          PersonalPanVerificationSubmitted(
                            fileData: state.panFileData,
                            panName: state.panNameController.text,
                            panNumber: state.panNumberController.text,
                          ),
                        );
                      }
                    },
          ),
        );
      },
    );
  }

  // Widget _buildVerifyPanButton(BuildContext context, PersonalAccountSetupState state) {
  //   return Align(
  //     alignment: Alignment.centerRight,
  //     child: AnimatedBuilder(
  //       animation: Listenable.merge([state.panNumberController]),
  //       builder: (context, _) {
  //         bool isDisabled = ExchekValidations.validatePAN(state.panNumberController.text) != null;
  //         return CustomElevatedButton(
  //           text: Lang.of(context).lbl_verify,
  //           width: ResponsiveHelper.isWebAndIsNotMobile(context) ? 150 : double.maxFinite,
  //           isShowTooltip: true,
  //           isLoading: state.isPanDetailsLoading,
  //           tooltipMessage: Lang.of(context).lbl_tooltip_text,
  //           isDisabled: isDisabled,
  //           borderRadius: 8.0,
  //           onPressed:
  //               isDisabled
  //                   ? null
  //                   : () {
  //                     // Show validation error if any
  //                     state.panVerificationKey.currentState?.validate();

  //                     // If valid, proceed
  //                     if (ExchekValidations.validatePAN(state.panNumberController.text) == null) {
  //                       context.read<PersonalAccountSetupBloc>().add(GetPanDetails(state.panNumberController.text));
  //                     }
  //                   },
  //         );
  //       },
  //     ),
  //   );
  // }
}
