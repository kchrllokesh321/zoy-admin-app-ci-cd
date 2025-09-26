import 'package:country_picker/country_picker.dart';
import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/viewmodels/account_setup_bloc/personal_account_setup_bloc/personal_account_setup_bloc.dart';
import 'package:exchek/widgets/account_setup_widgets/country_picker_field.dart';
import 'package:exchek/widgets/common_widget/pdf_merge_progress_bar.dart';
import 'package:exchek/widgets/custom_widget/custom_drop_down_field.dart';

class PersonalResidentialAddress extends StatelessWidget {
  const PersonalResidentialAddress({super.key});

  List<String> getAddressVerificationDocTypes(BuildContext context) => [
    Lang.of(context).lbl_bank_statement,
    Lang.of(context).lbl_internet_bill,
    Lang.of(context).lbl_aadhar_card,
  ];

  List<String> getAddressVerificationWithoutAadharDocTypes(BuildContext context) => [
    Lang.of(context).lbl_bank_statement,
    Lang.of(context).lbl_internet_bill,
  ];

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSizedBoxH(20.0),
                    if (state.selectedIDVerificationDocType == IDVerificationDocType.aadharCard) ...[
                      _buildSelectionTitleAndDescription(
                        context: context,
                        title: Lang.of(context).lbl_residential_address_same_aadhaar_card,
                        description: Lang.of(context).lbl_residential_address_verification,
                      ),
                      buildSizedBoxH(14.0),
                      _buildYesNoOptionForSamaAadhaarAddress(context, state),
                      if (state.isResidenceAddressSameAsAadhar == 0) ...[
                        buildSizedBoxH(4.0),
                        _buildAgreeCheckbox(context, state),
                      ],
                      buildSizedBoxH(14.0),
                    ],
                    if (state.isResidenceAddressSameAsAadhar == 1 ||
                        state.selectedIDVerificationDocType != IDVerificationDocType.aadharCard) ...[
                      _buildSelectionTitleAndDescription(
                        context: context,
                        title: Lang.of(context).lbl_enter_your_address_upload_proof,
                        description: Lang.of(context).lbl_provide_residential_upload_document_residence,
                      ),
                      buildSizedBoxH(30.0),
                      Form(
                        key: state.registerAddressFormKey,
                        child: Column(
                          children: [
                            _buildCountryField(context, state),
                            buildSizedBoxH(24.0),
                            _buildPinCodeField(context, state),
                            buildSizedBoxH(24.0),
                            _buildStateCodeField(context, state),
                            buildSizedBoxH(24.0),
                            _buildCityField(context, state),
                            buildSizedBoxH(24.0),
                            _buildAddress1CodeField(context, state),
                            buildSizedBoxH(24.0),
                            _buildAddress2CodeField(context, state),
                            buildSizedBoxH(24.0),
                            _buildAddressVerificationDocTypes(context, state),
                            if ((state.selectedAddressVerificationDocType ?? '').isNotEmpty) ...[
                              buildSizedBoxH(24.0),
                              _buildUploadAddressVerificationFile(context),
                              if (state.isMerging) ...[
                                buildSizedBoxH(30.0),
                                PdfMergeProgressBar(progress: state.mergeProgress ?? 0.0),
                              ],
                            ],
                          ],
                        ),
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

  Widget _buildAgreeCheckbox(BuildContext context, PersonalAccountSetupState state) {
    return GestureDetector(
      onTap: () {
        context.read<PersonalAccountSetupBloc>().add(
          ChangeAgreeToAddressSameAsAadhar(!state.isAgreeToAddressSameAsAadhar),
        );
      },
      child: Row(
        children: [
          CustomImageView(
            imagePath:
                state.isAgreeToAddressSameAsAadhar
                    ? Assets.images.svgs.icons.icCheckboxTick.path
                    : Assets.images.svgs.icons.icUncheckbox.path,
            height: 18.0,
            width: 18.0,
            fit: BoxFit.fill,
          ),
          buildSizedboxW(10.0),
          Expanded(
            child: Text(
              Lang.of(context).lbl_agree_aadhaar_residential_address_verification,
              style: TextStyle(
                fontSize: ResponsiveHelper.getFontSize(context, mobile: 14.0, tablet: 15.0, desktop: 15.0),
                fontWeight: FontWeight.w500,
                letterSpacing: 0.16,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYesNoOptionForSamaAadhaarAddress(BuildContext context, PersonalAccountSetupState state) {
    return Row(
      spacing: 20.0,
      children: List.generate(2, (index) {
        return Expanded(
          child: CustomTileWidget(
            title: index == 0 ? Lang.of(context).lbl_yes : Lang.of(context).lbl_no,
            isSelected: state.isResidenceAddressSameAsAadhar == index,
            onTap: () {
              final bloc = BlocProvider.of<PersonalAccountSetupBloc>(context);
              bloc.add(ResidenceAddressSameAsAadhar(index));
            },
          ),
        );
      }),
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

  Widget _buildCountryField(BuildContext context, PersonalAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_country,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
            fontWeight: FontWeight.w400,
            height: 1.22,
          ),
        ),
        buildSizedBoxH(8.0),
        AbsorbPointer(
          absorbing: true,
          child: ExpandableCountryDropdownField(
            selectedCountry: state.selectedCountry,
            countryList: CountryService().getAll(),
            onChanged: (country) {
              context.read<PersonalAccountSetupBloc>().add(PersonalUpdateSelectedCountry(country: country));
            },
            isDisable: true,
          ),
        ),
      ],
    );
  }

  Widget _buildPinCodeField(BuildContext context, PersonalAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_pin_code,
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
          controller: state.pinCodeController,
          textInputAction: TextInputAction.next,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
          validator: ExchekValidations.validateRequired,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          suffixIcon: state.isCityAndStateLoading ? AppLoaderWidget(size: 20.0) : SizedBox.fromSize(),
          onChanged: (value) {
            // Mark data as changed for residential address
            context.read<PersonalAccountSetupBloc>().add(PersonalMarkResidentialAddressDataChanged());
            if (value.length == 6 && ExchekValidations.validateRequired(value) == null) {
              context.read<PersonalAccountSetupBloc>().add(GetCityAndState(value.trim()));
            }
          },
          onFieldSubmitted: (value) {
            if (ExchekValidations.validateRequired(state.pinCodeController.text) == null) {
              context.read<PersonalAccountSetupBloc>().add(GetCityAndState(state.pinCodeController.text.trim()));
            }
          },
          maxLength: 6,
          shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForRequiredValidation,
        ),
      ],
    );
  }

  Widget _buildStateCodeField(BuildContext context, PersonalAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_state,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
            fontWeight: FontWeight.w400,
            height: 1.22,
          ),
        ),
        buildSizedBoxH(8.0),
        AbsorbPointer(
          absorbing: true,
          child: CustomTextInputField(
            context: context,
            type: InputType.text,
            controller: state.stateNameController,
            textInputAction: TextInputAction.next,
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
            validator: ExchekValidations.validateRequired,
            shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForRequiredValidation,
          ),
        ),
      ],
    );
  }

  Widget _buildCityField(BuildContext context, PersonalAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_city,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
            fontWeight: FontWeight.w400,
            height: 1.22,
          ),
        ),
        buildSizedBoxH(8.0),
        AbsorbPointer(
          absorbing: true,
          child: CustomTextInputField(
            context: context,
            type: InputType.text,
            controller: state.cityNameController,
            textInputAction: TextInputAction.next,
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
            validator: ExchekValidations.validateRequired,
            shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForRequiredValidation,
          ),
        ),
      ],
    );
  }

  Widget _buildAddress1CodeField(BuildContext context, PersonalAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_address_line_1,
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
          controller: state.address1NameController,
          textInputAction: TextInputAction.next,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
          validator: ExchekValidations.validateRequired,
          shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForRequiredValidation,
          onChanged: (value) {
            // Mark data as changed for residential address
            context.read<PersonalAccountSetupBloc>().add(PersonalMarkResidentialAddressDataChanged());
          },
        ),
      ],
    );
  }

  Widget _buildAddress2CodeField(BuildContext context, PersonalAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_address_line_2,
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
          controller: state.address2NameController,
          textInputAction: TextInputAction.next,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
          onChanged: (value) {
            // Mark data as changed for residential address
            context.read<PersonalAccountSetupBloc>().add(PersonalMarkResidentialAddressDataChanged());
          },
        ),
      ],
    );
  }

  Widget _buildAddressVerificationDocTypes(BuildContext context, PersonalAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_choose_document_upload_address_verification,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
            fontWeight: FontWeight.w400,
            height: 1.22,
          ),
        ),
        buildSizedBoxH(8.0),
        ExpandableDropdownField(
          items:
              (state.selectedIDVerificationDocType == IDVerificationDocType.aadharCard &&
                      state.isResidenceAddressSameAsAadhar == 1)
                  ? getAddressVerificationWithoutAadharDocTypes(context)
                  : getAddressVerificationDocTypes(context),
          selectedValue: state.selectedAddressVerificationDocType,
          onChanged: (value) {
            context.read<PersonalAccountSetupBloc>().add(PersonalUpdateAddressVerificationDocType(value));
            // Mark data as changed for residential address
            context.read<PersonalAccountSetupBloc>().add(PersonalMarkResidentialAddressDataChanged());
            //    context.read<PersonalAccountSetupBloc>().add(
            // PersonalUpdateAddressVerificationDocType(value.replaceAll(" ", '')),
            // );
          },
        ),
      ],
    );
  }

  Widget _buildUploadAddressVerificationFile(BuildContext context) {
    return BlocBuilder<PersonalAccountSetupBloc, PersonalAccountSetupState>(
      buildWhen:
          (previous, current) =>
              previous.selectedAddressVerificationDocType != current.selectedAddressVerificationDocType ||
              previous.addressVerificationFile != current.addressVerificationFile,
      builder: (context, state) {
        if (state.selectedAddressVerificationDocType == null) return const SizedBox.shrink();

        final isAadhar =
            state.selectedAddressVerificationDocType == Lang.of(context).lbl_aadhar_card ||
            state.selectedAddressVerificationDocType == 'Aadhaar';

        final docType = _mapDocType(state.selectedAddressVerificationDocType, context);

        //  final isAadhar =
        // state.selectedAddressVerificationDocType == Lang.of(context).lbl_aadhar_card.replaceAll(" ", "");

        if (isAadhar) {
          if (state.isFrontSideAddressAdharFileUploaded) {
            return CustomFileUploadWidget(
              selectedFile: state.addressVerificationFile,
              title:
                  "${Lang.of(context).lbl_upload} ${isAadhar ? "Front Side ${Lang.of(context).lbl_aadhar_card}" : state.selectedAddressVerificationDocType!}",
              isEditMode: true,
              onEditFileSelected: (fileData) {
                context.read<PersonalAccountSetupBloc>().add(PersonalUploadAddressVerificationFile(fileData: null));
                context.read<PersonalAccountSetupBloc>().add(PersonalUploadBackAddressVerificationFile(fileData: null));
                // Mark data as changed for residential address
                context.read<PersonalAccountSetupBloc>().add(PersonalMarkResidentialAddressDataChanged());
              },
              documentNumber: state.aadharNumberController.text,
              documentType: docType,
              kycRole: "",
              screenName: "ADDRESS",
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomFileUploadWidget(
                  selectedFile: state.addressVerificationFile,
                  title:
                      "${Lang.of(context).lbl_upload} ${isAadhar ? "Front Side ${Lang.of(context).lbl_aadhar_card}" : state.selectedAddressVerificationDocType!}",
                  onFileSelected: (fileData) {
                    context.read<PersonalAccountSetupBloc>().add(
                      PersonalUploadAddressVerificationFile(fileData: fileData),
                    );
                    // Mark data as changed for residential address
                    context.read<PersonalAccountSetupBloc>().add(PersonalMarkResidentialAddressDataChanged());
                  },
                  documentNumber: '',
                  documentType: docType,
                  kycRole: "",
                  screenName: "ADDRESS",
                ),
                buildSizedBoxH(24.0),
                CustomFileUploadWidget(
                  selectedFile: state.backAddressVerificationFile,
                  title: "${Lang.of(context).lbl_upload} Back Side ${Lang.of(context).lbl_aadhar_card}",
                  onFileSelected: (fileData) {
                    context.read<PersonalAccountSetupBloc>().add(
                      PersonalUploadBackAddressVerificationFile(fileData: fileData),
                    );
                    // Mark data as changed for residential address
                    context.read<PersonalAccountSetupBloc>().add(PersonalMarkResidentialAddressDataChanged());
                  },
                  documentNumber: '',
                  documentType: docType,
                  kycRole: "",
                  screenName: "ADDRESS",
                ),
              ],
            );
          }
        } else {
          return CustomFileUploadWidget(
            selectedFile: state.addressVerificationFile,
            title:
                "${Lang.of(context).lbl_upload} ${isAadhar ? "Front Side ${Lang.of(context).lbl_aadhar_card}" : state.selectedAddressVerificationDocType!}",
            onFileSelected: (fileData) {
              context.read<PersonalAccountSetupBloc>().add(PersonalUploadAddressVerificationFile(fileData: fileData));
              // Mark data as changed for residential address
              context.read<PersonalAccountSetupBloc>().add(PersonalMarkResidentialAddressDataChanged());
            },
            documentNumber: '',
            documentType: docType,
            kycRole: "",
            screenName: "ADDRESS",
          );
        }

        // return Column(
        //   children: [
        //     if (isAadhar) ...[
        //       buildSizedBoxH(24.0),
        //       CustomFileUploadWidget(
        //         selectedFile: state.backAddressVerificationFile,
        //         title: "${Lang.of(context).lbl_upload} Back Side ${Lang.of(context).lbl_aadhar_card}",
        //         onFileSelected: (fileData) {
        //           context.read<PersonalAccountSetupBloc>().add(
        //             PersonalUploadBackAddressVerificationFile(fileData: fileData),
        //           );
        //         },
        //         documentNumber: '',
        //         documentType: docType,
        //         kycRole: "",
        //         screenName: "ADDRESS",
        //       ),
        //     ],
        //   ],
        // );
      },
    );
  }

  Widget _buildNextButton() {
    return BlocBuilder<PersonalAccountSetupBloc, PersonalAccountSetupState>(
      builder: (context, state) {
        return AnimatedBuilder(
          animation: Listenable.merge([
            state.pinCodeController,
            state.stateNameController,
            state.cityNameController,
            state.address1NameController,
          ]),
          builder: (context, _) {
            final isAadharSelected =
                state.selectedAddressVerificationDocType == Lang.of(context).lbl_aadhar_card ||
                state.selectedAddressVerificationDocType == 'Aadhaar';

            final isAddressSectionEnabled =
                (state.isResidenceAddressSameAsAadhar == 0 && state.isAgreeToAddressSameAsAadhar == true);

            final isFormValid =
                state.pinCodeController.text.isNotEmpty &&
                state.stateNameController.text.isNotEmpty &&
                state.cityNameController.text.isNotEmpty &&
                state.address1NameController.text.isNotEmpty &&
                state.selectedAddressVerificationDocType != null &&
                state.addressVerificationFile != null &&
                (!isAadharSelected ||
                    state.backAddressVerificationFile != null ||
                    state.isFrontSideAddressAdharFileUploaded == true);

            //  final isAadharAlreadyUploaded = isAadhar && state.isFrontSideAdharFileUploaded == true;

            final isButtonEnabled = state.isResidenceAddressSameAsAadhar == 0 ? isAddressSectionEnabled : isFormValid;

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
                isLoading: state.isAddressVerificationLoading ?? false,
                onPressed:
                    isButtonEnabled
                        ? () {
                          final docType = _mapDocType(state.selectedAddressVerificationDocType, context);
                          if (state.isResidenceAddressSameAsAadhar == 0) {
                            context.read<PersonalAccountSetupBloc>().add(
                              PersonalRegisterAddressSubmitted(
                                addressValidateFileData: state.addressVerificationFile,
                                isAddharCard: docType == 'Aadhaar',
                                //  isAddharCard: true,
                                docType: "Aadhaar",
                                backValiateFileData: state.backAddressVerificationFile,
                              ),
                            );
                          } else {
                            if (state.registerAddressFormKey.currentState!.validate()) {
                              final docType = _mapDocType(state.selectedAddressVerificationDocType, context);

                              context.read<PersonalAccountSetupBloc>().add(
                                PersonalRegisterAddressSubmitted(
                                  addressValidateFileData: state.addressVerificationFile,
                                  isAddharCard: docType == 'Aadhaar',
                                  //  isAddharCard: docType == 'AadhaarCard',
                                  docType: docType,
                                  backValiateFileData: state.backAddressVerificationFile,
                                ),
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

  String _mapDocType(String? selectedDocType, BuildContext context) {
    final lang = Lang.of(context);
    if (selectedDocType == lang.lbl_aadhar_card || selectedDocType == 'Aadhaar') return 'Aadhaar';
    if (selectedDocType == lang.lbl_bank_statement) return 'BankStatement';
    if (selectedDocType == lang.lbl_internet_bill) return 'InternetBill';
    //     if (selectedDocType == lang.lbl_aadhar_card.replaceAll(" ", '')) return 'Aadhaar';
    // if (selectedDocType == (lang.lbl_bank_statement.replaceAll(" ", ''))) return 'BankStatement';
    // if (selectedDocType == lang.lbl_internet_bill.replaceAll(" ", '')) return 'InternetBill';
    return '';
  }
}
