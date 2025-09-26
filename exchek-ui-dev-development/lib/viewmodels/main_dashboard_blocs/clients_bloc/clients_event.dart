import 'package:equatable/equatable.dart';
import 'package:exchek/models/clients_models/clients_models.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/clients_bloc/clients_state.dart';
import 'package:exchek/widgets/custom_widget/custom_date_range_picker.dart' show DateRange;
import 'package:exchek/widgets/custom_widget/custom_search_filter.dart';
import 'package:exchek/widgets/common_widget/app_file_upload_widget.dart';

abstract class ClientsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadClients extends ClientsEvent {}

class SearchQueryChanged extends ClientsEvent {
  final String query;
  SearchQueryChanged(this.query);
  @override
  List<Object?> get props => [query];
}

class ToggleSelectTransaction extends ClientsEvent {
  final int id;
  ToggleSelectTransaction(this.id);
  @override
  List<Object?> get props => [id];
}

class ToggleSelectAllOnPage extends ClientsEvent {}

class ClientPageChanged extends ClientsEvent {
  final int page;
  ClientPageChanged(this.page);
  @override
  List<Object?> get props => [page];
}

class ClientRowTapped extends ClientsEvent {
  final ClientModel client;
  ClientRowTapped(this.client);
  @override
  List<Object?> get props => [client];
}

class ClientCurrencyChanged extends ClientsEvent {
  final String currencyCode;
  ClientCurrencyChanged(this.currencyCode);
  @override
  List<Object?> get props => [currencyCode];
}

class LoadClientInvoicesRequested extends ClientsEvent {
  final String clientId;
  LoadClientInvoicesRequested(this.clientId);
  @override
  List<Object?> get props => [clientId];
}

class ToggleSelectClientInvoice extends ClientsEvent {
  final int invoiceId;
  ToggleSelectClientInvoice(this.invoiceId);
  @override
  List<Object?> get props => [invoiceId];
}

class ToggleSelectAllClientInvoicesOnPage extends ClientsEvent {}

class ClientInvoicePageChanged extends ClientsEvent {
  final int page;
  ClientInvoicePageChanged(this.page);
  @override
  List<Object?> get props => [page];
}

// Filter-related events
class ClientInvoiceSearchQueryChanged extends ClientsEvent {
  final String query;
  ClientInvoiceSearchQueryChanged(this.query);
  @override
  List<Object?> get props => [query];
}

class ClientInvoiceStatusFilterChanged extends ClientsEvent {
  final Set<String> statuses; // e.g., {'Received', 'Failed'}; empty -> no filter
  ClientInvoiceStatusFilterChanged(this.statuses);
  @override
  List<Object?> get props => [statuses];
}

class ClientInvoiceStatusFilterItemsChanged extends ClientsEvent {
  final List<SelectionItem> items;
  ClientInvoiceStatusFilterItemsChanged(this.items);
  @override
  List<Object?> get props => [items];
}

class ClientInvoiceDateRangeChanged extends ClientsEvent {
  final DateRange range; // empty range clears date filter
  ClientInvoiceDateRangeChanged(this.range);
  @override
  List<Object?> get props => [range];
}

class ToggleClientInvoiceFiltersVisibility extends ClientsEvent {}

class ClearAllClientInvoiceFiltersRequested extends ClientsEvent {}

// Navigation events
class ClearSelectedClient extends ClientsEvent {}

// Add Client form events
class ClientFormNameChanged extends ClientsEvent {
  final String value;
  ClientFormNameChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class ClientFormEmailChanged extends ClientsEvent {
  final String value;
  ClientFormEmailChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class ClientFormTypeChanged extends ClientsEvent {
  final String value;
  ClientFormTypeChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class ClientFormAddress1Changed extends ClientsEvent {
  final String value;
  ClientFormAddress1Changed(this.value);
  @override
  List<Object?> get props => [value];
}

class ClientFormAddress2Changed extends ClientsEvent {
  final String value;
  ClientFormAddress2Changed(this.value);
  @override
  List<Object?> get props => [value];
}

class ClientFormStateRegionChanged extends ClientsEvent {
  final String value;
  ClientFormStateRegionChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class ClientFormCityChanged extends ClientsEvent {
  final String value;
  ClientFormCityChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class ClientFormPostalCodeChanged extends ClientsEvent {
  final String value;
  ClientFormPostalCodeChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class ClientFormWebsiteChanged extends ClientsEvent {
  final String value;
  ClientFormWebsiteChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class ClientFormNotesChanged extends ClientsEvent {
  final String value;
  ClientFormNotesChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class ClientFormContractChanged extends ClientsEvent {
  final FileData? fileData;
  ClientFormContractChanged({required this.fileData});
  @override
  List<Object?> get props => [fileData];
}

class SubmitCreateClientRequested extends ClientsEvent {}

class ResetCreateClientResult extends ClientsEvent {}

class ResetCreateClientForm extends ClientsEvent {}

class GetClientCityAndState extends ClientsEvent {
  final String pinCode;
  GetClientCityAndState(this.pinCode);
  @override
  List<Object> get props => [pinCode];
}

class ResetRequested extends ClientsEvent {}

class CountryClientTypeOptions extends ClientsEvent {}

class ClientFormCountryChanged extends ClientsEvent {
  final String value;
  ClientFormCountryChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class UpdateClientDetails extends ClientsEvent {
  final Map<String, dynamic> data;
  UpdateClientDetails(this.data);
}

class ClientFormClientTypeChanged extends ClientsEvent {
  final String value;
  ClientFormClientTypeChanged(this.value);
  @override
  List<Object?> get props => [value];
}

extension ClientsStateHelpers on ClientsState {
  String getCountryName(String code) {
    if (countries == null) return code;
    return countries!
            .firstWhere(
              (c) => c.countryCode == code,
              orElse: () => Country(countryCode: code, countryName: code),
            )
            .countryName ??
        code;
  }

  String getClientTypeName(String code) {
    if (clientType == null) return code;
    return clientType!
            .firstWhere(
              (c) => c.clientTypeCode == code,
              orElse: () => ClientType(clientTypeCode: code, clientTypeyName: code),
            )
            .clientTypeyName ??
        code;
  }
}

