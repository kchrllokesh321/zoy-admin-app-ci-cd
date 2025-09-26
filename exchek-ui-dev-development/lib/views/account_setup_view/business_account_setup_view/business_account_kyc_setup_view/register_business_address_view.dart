import 'package:country_picker/country_picker.dart';
import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/widgets/account_setup_widgets/country_picker_field.dart';
import 'package:exchek/widgets/custom_widget/custom_drop_down_field.dart';

class RegisterBusinessAddressView extends StatelessWidget {
  const RegisterBusinessAddressView({super.key});

  List<String> getAddressVerificationDocTypes(BuildContext context) => [
    Lang.of(context).lbl_internet_bill,
    Lang.of(context).lbl_electricity_bill,
    Lang.of(context).lbl_recent_bank_statement,
    Lang.of(context).lbl_rental_agreement,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
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
                    title: Lang.of(context).lbl_official_registered_address_of_your_business,
                    description: Lang.of(context).lbl_address_business_registration_documents,
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
                        if (state.selectedAddressVerificationDocType!.isNotEmpty) ...[
                          buildSizedBoxH(24.0),
                          _buildUploadAddressVerificationFile(context),
                        ],
                        buildSizedBoxH(30.0),
                        _buildNextButton(),
                      ],
                    ),
                  ),
                ],
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

  Widget _buildCountryField(BuildContext context, BusinessAccountSetupState state) {
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
            isDisable: true,
            selectedCountry: state.selectedCountry,
            countryList: CountryService().getAll(),
            onChanged: (country) {
              context.read<BusinessAccountSetupBloc>().add(UpdateSelectedCountry(country: country));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPinCodeField(BuildContext context, BusinessAccountSetupState state) {
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
            context.read<BusinessAccountSetupBloc>().add(MarkResidentialAddressDataChanged());
            if (value.length == 6 && ExchekValidations.validateRequired(value) == null) {
              context.read<BusinessAccountSetupBloc>().add(BusinessGetCityAndState(value.trim()));
            }
          },
          onFieldSubmitted: (value) {
            if (ExchekValidations.validateRequired(state.pinCodeController.text) == null) {
              context.read<BusinessAccountSetupBloc>().add(
                BusinessGetCityAndState(state.pinCodeController.text.trim()),
              );
            }
          },
          maxLength: 6,
          shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForRequiredValidation,
        ),
      ],
    );
  }

  Widget _buildStateCodeField(BuildContext context, BusinessAccountSetupState state) {
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

  Widget _buildCityField(BuildContext context, BusinessAccountSetupState state) {
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

  Widget _buildAddress1CodeField(BuildContext context, BusinessAccountSetupState state) {
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
            context.read<BusinessAccountSetupBloc>().add(MarkResidentialAddressDataChanged());
          },
        ),
      ],
    );
  }

  Widget _buildAddress2CodeField(BuildContext context, BusinessAccountSetupState state) {
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
            context.read<BusinessAccountSetupBloc>().add(MarkResidentialAddressDataChanged());
          },
        ),
      ],
    );
  }

  Widget _buildAddressVerificationDocTypes(BuildContext context, BusinessAccountSetupState state) {
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
          items: getAddressVerificationDocTypes(context),
          selectedValue: state.selectedAddressVerificationDocType,
          onChanged: (value) {
            context.read<BusinessAccountSetupBloc>().add(UpdateAddressVerificationDocType(value));
          },
        ),
      ],
    );
  }

  Widget _buildUploadAddressVerificationFile(BuildContext context) {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      buildWhen:
          (previous, current) =>
              previous.selectedAddressVerificationDocType != current.selectedAddressVerificationDocType ||
              previous.addressVerificationFile != current.addressVerificationFile,
      builder: (context, state) {
        if (state.selectedAddressVerificationDocType == null) return const SizedBox.shrink();

        final docType = _mapDocType(state.selectedAddressVerificationDocType, context);

        return CustomFileUploadWidget(
          selectedFile: state.addressVerificationFile,
          title: "${Lang.of(context).lbl_upload} ${state.selectedAddressVerificationDocType}",
          onFileSelected: (fileData) {
            context.read<BusinessAccountSetupBloc>().add(UploadAddressVerificationFile(fileData: fileData));
            // Mark data as changed for residential address
            context.read<BusinessAccountSetupBloc>().add(MarkResidentialAddressDataChanged());
          },
          documentNumber: '',
          documentType: docType,
          kycRole: "",
          screenName: "ADDRESS",
        );
      },
    );
  }

  Widget _buildNextButton() {
    return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
      builder: (context, state) {
        return AnimatedBuilder(
          animation: Listenable.merge([
            state.pinCodeController,
            state.stateNameController,
            state.cityNameController,
            state.address1NameController,
          ]),
          builder: (context, _) {
            final isButtonEnabled =
                state.addressVerificationFile != null &&
                state.pinCodeController.text.isNotEmpty &&
                state.stateNameController.text.isNotEmpty &&
                state.cityNameController.text.isNotEmpty &&
                state.address1NameController.text.isNotEmpty &&
                state.selectedAddressVerificationDocType != null;

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
                          if (state.registerAddressFormKey.currentState!.validate()) {
                            final docType = _mapDocType(state.selectedAddressVerificationDocType, context);
                            context.read<BusinessAccountSetupBloc>().add(
                              RegisterAddressSubmitted(
                                addressValidateFileData: state.addressVerificationFile,
                                docType: docType,
                              ),
                            );
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

    if (selectedDocType == lang.lbl_internet_bill) return 'InternetBill';
    if (selectedDocType == lang.lbl_electricity_bill) return 'ElectricityBill';
    if (selectedDocType == lang.lbl_recent_bank_statement) return 'RecentBankStatement';
    if (selectedDocType == lang.lbl_rental_agreement) return 'RentalAgreement';
    return '';
  }
}
