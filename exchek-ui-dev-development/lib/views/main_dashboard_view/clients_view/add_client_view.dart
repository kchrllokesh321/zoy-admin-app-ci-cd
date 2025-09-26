import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/models/clients_models/clients_models.dart';
import 'package:exchek/widgets/custom_widget/custom_drop_down_field.dart';

import 'package:exchek/viewmodels/main_dashboard_blocs/clients_bloc/clients_bloc.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/clients_bloc/clients_state.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/clients_bloc/clients_event.dart';

class AddClientDialog extends StatelessWidget {
  const AddClientDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClientsBloc, ClientsState>(
      listenWhen: (p, c) => p.createClientResult != c.createClientResult && c.createClientResult != null,
      listener: (context, state) {
        final result = state.createClientResult;
        if (result == null) return;
        if (result.success == true) {
          AppToast.show(message: result.message ?? 'Client added successfully', type: ToastificationType.success);
          GoRouter.of(context).pop(true);
        } else {
          AppToast.show(message: result.message ?? 'Failed to add client', type: ToastificationType.error);
        }
      },

      builder: (context, state) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            clipBehavior: Clip.hardEdge,
            constraints: BoxConstraints(maxWidth: ResponsiveHelper.getMaxDialogWidth(context)),
            decoration: BoxDecoration(
              color: Theme.of(context).customColors.fillColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildSizedBoxH(25.0),
                _buildDialogHeader(context),
                buildSizedBoxH(10.0),
                divider(context),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: ResponsiveHelper.getMaxDialogWidth(context),
                    maxHeight:
                        MediaQuery.of(context).size.height < 600
                            ? MediaQuery.of(context).size.height * 0.52
                            : MediaQuery.of(context).size.height * 0.7,
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.getWidgetSize(context, desktop: 42, tablet: 36, mobile: 30),
                      vertical: ResponsiveHelper.getWidgetSize(context, desktop: 24, tablet: 20, mobile: 16),
                    ),
                    child: Form(
                      key: state.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildClientDetail(context, state),
                          buildSizedBoxH(16),
                          _buildAddressField(context, state),
                          buildSizedBoxH(16),
                          _buildNotesAndContract(context, state),
                          buildSizedBoxH(24),
                          _buildBottomButtons(context, state),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget divider(BuildContext context) =>
      Container(height: 1.5, width: double.maxFinite, color: Theme.of(context).customColors.lightBorderColor);

  Widget _buildDialogHeader(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: ResponsiveHelper.getMaxDialogWidth(context)),
        padding: ResponsiveHelper.getDialogPadding(context),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "Add Client",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: ResponsiveHelper.getFontSize(context, mobile: 20, tablet: 22, desktop: 24),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.24,
                ),
              ),
            ),
            buildSizedboxW(15.0),
            HoverCloseButton(
              onTap: () {
                GoRouter.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context, ClientsState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      spacing: 12,
      children:
          ResponsiveHelper.isWebAndIsNotMobile(context)
              ? [_buildCancelButton(context), _buildSaveButton(state, context)]
              : [Expanded(child: _buildCancelButton(context)), Expanded(child: _buildSaveButton(state, context))],
    );
  }

  Widget _buildSaveButton(ClientsState state, BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([state.formNameController, state.formEmailController, state.formAddress1Controller]),
      builder: (context, child) {
        final isDisabled =
            state.formName.trim().isEmpty ||
            state.formEmail.trim().isEmpty ||
            (state.formType ?? '').trim().isEmpty ||
            state.formAddress1.trim().isEmpty ||
            (state.formCountry ?? '').trim().isEmpty ||
            (state.formPostalCode).trim().isEmpty ||
            (state.formCity).trim().isEmpty;

        return CustomElevatedButton(
          height: 44,
          borderRadius: 8,
          width: 65.0,
          isLoading: state.creatingClient,
          isShowTooltip: true,
          tooltipMessage: Lang.of(context).lbl_tooltip_text,
          isDisabled: isDisabled,
          onPressed:
              isDisabled && state.creatingClient
                  ? null
                  : () {
                    context.read<ClientsBloc>().add(SubmitCreateClientRequested());
                  },
          text: 'Save',
        );
      },
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return CustomElevatedButton(
      height: 44,
      width: 100.0,
      buttonStyle: ButtonThemeHelper.textButtonStyle(context),
      borderRadius: 8,
      onPressed: () {
        GoRouter.of(context).pop(false);
      },
      text: 'Cancel',
      buttonTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).customColors.primaryColor,
        fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
      ),
    );
  }

  Widget _buildClientDetail(BuildContext context, ClientsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20.0,
      children: [
        Column(
          spacing: 8.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextFieldTitle(context, "Client name"),
            CustomTextInputField(
              context: context,
              type: InputType.text,
              hintLabel: 'Client name',
              controller: state.formNameController,
              onChanged: (v) => context.read<ClientsBloc>().add(ClientFormNameChanged(v)),
              validator: ExchekValidations.validateRequired,
            ),
          ],
        ),
        Column(
          spacing: 8.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextFieldTitle(context, "Client email"),
            CustomTextInputField(
              context: context,
              type: InputType.text,
              hintLabel: 'Client email',
              controller: state.formEmailController,
              onChanged: (v) => context.read<ClientsBloc>().add(ClientFormEmailChanged(v)),
              validator: ExchekValidations.validateEmail,
            ),
          ],
        ),
        Column(
          spacing: 8.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextFieldTitle(context, "Client type"),
             ExpandableDropdownField(
                  items: state.clientType?.map((c) => c.clientTypeyName).toList() ?? [],
                  selectedValue: state.formType != null && state.clientType != null
                      ? (state.clientType!
                          .firstWhere((c) => c.clientTypeCode == state.formType,
                              orElse: () => ClientType(clientTypeCode: '', clientTypeyName: ''))
                          .clientTypeyName)
                      : '',
                  onChanged: (selectedClientTypeyName) {
                    final selectedClientType = state.clientType?.firstWhere(
                      (c) => c.clientTypeyName == selectedClientTypeyName,
                      orElse: () => ClientType(clientTypeCode: '', clientTypeyName: ''),
                    );
                    if (selectedClientType != null && selectedClientType.clientTypeCode.isNotEmpty) {
                      context.read<ClientsBloc>().add(ClientFormClientTypeChanged(selectedClientType.clientTypeCode));
                    }
                  },
                ),
              ],
        ),
      ],
    );
  }

  Widget _buildAddressField(BuildContext context, ClientsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20.0,
      children: [
        Column(
          spacing: 8.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextFieldTitle(context, "Address Line1"),
            CustomTextInputField(
              context: context,
              type: InputType.text,
              controller: state.formAddress1Controller,
              onChanged: (v) => context.read<ClientsBloc>().add(ClientFormAddress1Changed(v)),
              validator: ExchekValidations.validateRequired,
            ),
          ],
        ),
        Column(
          spacing: 8.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextFieldTitle(context, "Address Line2"),
            CustomTextInputField(
              context: context,
              type: InputType.text,
              controller: state.formAddress2Controller,
              onChanged: (v) => context.read<ClientsBloc>().add(ClientFormAddress2Changed(v)),
            ),
          ],
        ),
        Row(
          spacing: 20.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                spacing: 8.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextFieldTitle(context, "State"),
                  CustomTextInputField(
                  context: context,
                  type: InputType.text,
                  controller: state.formStateRegionController,
                  onChanged: (v) => context.read<ClientsBloc>().add(ClientFormStateRegionChanged(v)),
                   validator: ExchekValidations.validateRequired,
                ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                spacing: 8.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextFieldTitle(context, "City"),
                  CustomTextInputField(
                  context: context,
                  type: InputType.text,
                  controller: state.formCityController,
                  onChanged: (v) => context.read<ClientsBloc>().add(ClientFormCityChanged(v)),
                ),
                ],
              ),
            ),
          ],
        ),
        Row(
          spacing: 20.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                spacing: 8.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextFieldTitle(context, "Postal Code"),
                  CustomTextInputField(
                    context: context,
                    type: InputType.text,
                    controller: state.formPostalCodeController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 6,
                    suffixIcon: state.isCityAndStateLoading ? AppLoaderWidget(size: 20.0) : SizedBox.fromSize(),
                    onChanged: (value) {
                      context.read<ClientsBloc>().add(ClientFormPostalCodeChanged(value));
                    },
                  ),
                ],
              ),
            ),
          
          Expanded(
            child: Column(
              spacing: 8.0,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextFieldTitle(context, "Country"),
                ExpandableDropdownField(
                  items: state.countries?.map((c) => c.countryName).toList() ?? [],
                  selectedValue: state.formCountryCode != null && state.countries != null
                      ? (state.countries!
                          .firstWhere((c) => c.countryCode == state.formCountryCode,
                              orElse: () => Country(countryCode: '', countryName: ''))
                          .countryName)
                      : '',
                  onChanged: (selectedCountryName) {
                    final selectedCountry = state.countries?.firstWhere(
                      (c) => c.countryName == selectedCountryName,
                      orElse: () => Country(countryCode: '', countryName: ''),
                    );
                    if (selectedCountry != null && selectedCountry.countryCode.isNotEmpty) {
                      context.read<ClientsBloc>().add(ClientFormCountryChanged(selectedCountry.countryCode));
                    }
                  },
                ),
              ],
            ),
          ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextFieldTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
      ),
    );
  }

  Widget _buildNotesAndContract(BuildContext context, ClientsState state) {
    return Column(
      spacing: 8.0,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextFieldTitle(context, "Additional Notes"),
        CustomTextInputField(
          context: context,
          type: InputType.text,
          hintLabel: 'Additional notes (optional)',
          controller: state.formNotesController,
          onChanged: (v) => context.read<ClientsBloc>().add(ClientFormNotesChanged(v)),
        ),
      ],
    );
  }

}
