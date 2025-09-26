import 'package:equatable/equatable.dart';
import 'package:exchek/models/clients_models/clients_models.dart';
import 'package:exchek/widgets/custom_widget/custom_date_range_picker.dart' show DateRange;
import 'package:exchek/widgets/custom_widget/custom_search_filter.dart';
import 'package:exchek/widgets/common_widget/app_file_upload_widget.dart';
import 'package:exchek/models/auth_models/common_success_model.dart';
import 'package:flutter/widgets.dart';

class ClientsState extends Equatable {
  final List<ClientModel> allClients;
  final int page;
  final int pageSize;
  final bool loading;

  final ClientModel? selectedClient;
  final ClientDetailModel? clientDetail; // assume exists in models
  final bool detailLoading;
  final String? detailError;
  final List<ReceivableModel> allReceivables;
  final String selectedCurrencyCode;

  // Detail table (client invoices)
  final List<ClientInvoiceModel> allInvoices;
  final Set<int> selectedInvoiceIds;
  final int invoicePage;
  final int invoicePageSize;

  final int clientPage;
  final int clientPageSize;
  final bool clientLoading;

  // Filter-related properties for client invoices
  final List<ClientInvoiceModel> filteredInvoices;
  final String clientInvoiceSearchQuery;
  final Set<String> clientInvoiceStatusFilters;
  final bool showClientInvoiceFilters;
  final DateRange clientInvoiceDateRange;
  final List<SelectionItem> clientInvoiceStatusFilterItems;

  // Search functionality for clients list
  final String searchQuery;
  final List<ClientModel> filteredClients;
  // Add Client form fields
  final String formName;
  final String formEmail;
  final String? formType;
  final String formAddress1;
  final String formAddress2;
  final String formStateRegion;
  final String formCity;
  final String formPostalCode;
  final String? formCountry;
  final String? formCurrency;
  final String formWebsite;
  final String formNotes;
  final FileData? formContractFile;
  final bool creatingClient;
  final CommonSuccessModel? createClientResult;
  final bool isCityAndStateLoading;
  // Controllers for Add Client form (for views to bind like login)
  final TextEditingController? formNameController;
  final TextEditingController? formEmailController;
  final TextEditingController? formAddress1Controller;
  final TextEditingController? formAddress2Controller;
  final TextEditingController? formStateRegionController;
  final TextEditingController? formCityController;
  final TextEditingController? formPostalCodeController;
  final TextEditingController? formWebsiteController;
  final TextEditingController? formNotesController;
  final GlobalKey<FormState>? formKey;
  final List<Country>? countries ;
  final List<ClientType>? clientType ;
  final String? formCountryCode ;
  final String? formClientType;

  const ClientsState({
    required this.allClients,
    required this.page,
    required this.pageSize,
    this.loading = false,
    this.selectedClient,
    this.clientDetail,
    this.detailLoading = false,
    this.detailError,
    this.allReceivables = const [],
    this.selectedCurrencyCode = '',
    this.allInvoices = const [],
    this.selectedInvoiceIds = const {},
    this.invoicePage = 1,
    this.invoicePageSize = 10,
    this.clientPage = 1,
    this.clientPageSize = 10,
    this.clientLoading = false,
    this.filteredInvoices = const [],
    this.clientInvoiceSearchQuery = '',
    this.clientInvoiceStatusFilters = const {},
    this.showClientInvoiceFilters = false,
    required this.clientInvoiceDateRange,
    this.clientInvoiceStatusFilterItems = const [],
    this.searchQuery = '',
    this.filteredClients = const [],
    this.formName = '',
    this.formEmail = '',
    this.formType,
    this.formAddress1 = '',
    this.formAddress2 = '',
    this.formStateRegion = '',
    this.formCity = '',
    this.formPostalCode = '',
    this.formCountry,
    this.formCurrency,
    this.formWebsite = '',
    this.formNotes = '',
    this.formContractFile,
    this.creatingClient = false,
    this.createClientResult,
    this.isCityAndStateLoading = false,
    this.formNameController,
    this.formEmailController,
    this.formAddress1Controller,
    this.formAddress2Controller,
    this.formStateRegionController,
    this.formCityController,
    this.formPostalCodeController,
    this.formWebsiteController,
    this.formNotesController,
    this.formKey,
    this.countries = const [],
    this.formCountryCode,
    this.clientType = const [],
    this.formClientType,
  });

  factory ClientsState.initial() => ClientsState(
    allClients: [],
    page: 1,
    pageSize: 10,
    loading: false,
    selectedClient: null,
    clientDetail: null,
    detailLoading: false,
    detailError: null,
    selectedCurrencyCode: 'USD',
    allInvoices: [],
    selectedInvoiceIds: {},
    invoicePage: 1,
    invoicePageSize: 10,
    clientPage: 1,
    clientPageSize: 10,
    clientLoading: false,
    filteredInvoices: [],
    clientInvoiceSearchQuery: '',
    clientInvoiceStatusFilters: {},
    showClientInvoiceFilters: false,
    clientInvoiceDateRange: DateRange(),
    clientInvoiceStatusFilterItems: [
      SelectionItem(id: 'received', title: 'Received'),
      SelectionItem(id: 'failed', title: 'Failed'),
    ],
    searchQuery: '',
    filteredClients: const [],
    formName: '',
    formEmail: '',
    formType: null,
    formClientType:'',
    formAddress1: '',
    formAddress2: '',
    formStateRegion: '',
    formCity: '',
    formPostalCode: '',
    formCountry: null,
    formCurrency: null,
    formWebsite: '',
    formNotes: '',
    formContractFile: null,
    creatingClient: false,
    createClientResult: null,
    isCityAndStateLoading: false,
    formNameController: TextEditingController(),
    formEmailController: TextEditingController(),
    formAddress1Controller: TextEditingController(),
    formAddress2Controller: TextEditingController(),
    formStateRegionController: TextEditingController(),
    formCityController: TextEditingController(),
    formPostalCodeController: TextEditingController(),
    formWebsiteController: TextEditingController(),
    formNotesController: TextEditingController(),
    formKey: GlobalKey<FormState>(),
  );

  ClientsState copyWith({
    List<ClientModel>? allClients,
    int? page,
    int? pageSize,
    bool? loading,
    ClientModel? selectedClient,
    ClientDetailModel? clientDetail,
    bool? detailLoading,
    String? detailError,
    bool clearDetailError = false,
    String? selectedCurrencyCode,
    List<ClientInvoiceModel>? allInvoices,
    Set<int>? selectedInvoiceIds,
    int? invoicePage,
    int? invoicePageSize,
    int? clientPage,
    int? clientPageSize,
    bool? clientLoading,
    List<ClientInvoiceModel>? filteredInvoices,
    String? clientInvoiceSearchQuery,
    Set<String>? clientInvoiceStatusFilters,
    bool? showClientInvoiceFilters,
    DateRange? clientInvoiceDateRange,
    List<SelectionItem>? clientInvoiceStatusFilterItems,
    String? searchQuery,
    List<ClientModel>? filteredClients,
    String? formName,
    String? formEmail,
    String? formType,
    String? formAddress1,
    String? formAddress2,
    String? formStateRegion,
    String? formCity,
    String? formPostalCode,
    String? formCountry,
    String? formCurrency,
    String? formWebsite,
    String? formNotes,
    FileData? formContractFile,
    bool? creatingClient,
    CommonSuccessModel? createClientResult,
    bool? isCityAndStateLoading,
    TextEditingController? formNameController,
    TextEditingController? formEmailController,
    TextEditingController? formAddress1Controller,
    TextEditingController? formAddress2Controller,
    TextEditingController? formStateRegionController,
    TextEditingController? formCityController,
    TextEditingController? formPostalCodeController,
    TextEditingController? formWebsiteController,
    TextEditingController? formNotesController,
    GlobalKey<FormState>? formKey,
    List<ReceivableModel>? allReceivables,
    List<Country>? countries,
    List<ClientType>?clientType,
    String? formCountryCode,
    String? formClientType,
  }) {
    return ClientsState(
      allClients: allClients ?? this.allClients,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      loading: loading ?? this.loading,
      selectedClient: selectedClient ?? this.selectedClient,
      clientDetail: clientDetail ?? this.clientDetail,
      detailLoading: detailLoading ?? this.detailLoading,
      detailError: clearDetailError ? null : (detailError ?? this.detailError),
      allReceivables: allReceivables ?? this.allReceivables,
      selectedCurrencyCode: selectedCurrencyCode ?? this.selectedCurrencyCode,
      allInvoices: allInvoices ?? this.allInvoices,
      selectedInvoiceIds: selectedInvoiceIds ?? this.selectedInvoiceIds,
      invoicePage: invoicePage ?? this.invoicePage,
      invoicePageSize: invoicePageSize ?? this.invoicePageSize,
      clientPage: clientPage ?? this.clientPage,
      clientPageSize: clientPageSize ?? this.clientPageSize,
      clientLoading: clientLoading ?? this.clientLoading,
      filteredInvoices: filteredInvoices ?? this.filteredInvoices,
      clientInvoiceSearchQuery: clientInvoiceSearchQuery ?? this.clientInvoiceSearchQuery,
      clientInvoiceStatusFilters: clientInvoiceStatusFilters ?? this.clientInvoiceStatusFilters,
      showClientInvoiceFilters: showClientInvoiceFilters ?? this.showClientInvoiceFilters,
      clientInvoiceDateRange: clientInvoiceDateRange ?? this.clientInvoiceDateRange,
      clientInvoiceStatusFilterItems: clientInvoiceStatusFilterItems ?? this.clientInvoiceStatusFilterItems,
      searchQuery: searchQuery ?? this.searchQuery,
      filteredClients: filteredClients ?? this.filteredClients,
      formName: formName ?? this.formName,
      formEmail: formEmail ?? this.formEmail,
      formType: formType ?? this.formType,
      formAddress1: formAddress1 ?? this.formAddress1,
      formAddress2: formAddress2 ?? this.formAddress2,
      formStateRegion: formStateRegion ?? this.formStateRegion,
      formCity: formCity ?? this.formCity,
      formPostalCode: formPostalCode ?? this.formPostalCode,
      formCountry: formCountry ?? this.formCountry,
      formCurrency: formCurrency ?? this.formCurrency,
      formWebsite: formWebsite ?? this.formWebsite,
      formNotes: formNotes ?? this.formNotes,
      formContractFile: formContractFile ?? this.formContractFile,
      creatingClient: creatingClient ?? this.creatingClient,
      createClientResult: createClientResult ?? this.createClientResult,
      isCityAndStateLoading: isCityAndStateLoading ?? this.isCityAndStateLoading,
      formNameController: formNameController ?? this.formNameController,
      formEmailController: formEmailController ?? this.formEmailController,
      formAddress1Controller: formAddress1Controller ?? this.formAddress1Controller,
      formAddress2Controller: formAddress2Controller ?? this.formAddress2Controller,
      formStateRegionController: formStateRegionController ?? this.formStateRegionController,
      formCityController: formCityController ?? this.formCityController,
      formPostalCodeController: formPostalCodeController ?? this.formPostalCodeController,
      formWebsiteController: formWebsiteController ?? this.formWebsiteController,
      formNotesController: formNotesController ?? this.formNotesController,
      formKey: formKey ?? this.formKey,
      countries: countries ?? this.countries,
      formCountryCode: formCountryCode ?? this.formCountryCode,
      clientType: clientType ?? this.clientType,
      formClientType:formClientType ?? formClientType,
    );
  }

  List<ClientModel> get currentPageItems {
    final clientsToUse = searchQuery.isNotEmpty ? filteredClients : allClients;
    final start = (page - 1) * pageSize;
    final end = (start + pageSize).clamp(0, clientsToUse.length);
    if (start >= clientsToUse.length) return const [];
    return clientsToUse.sublist(start, end);
  }

  int get totalPages {
    final clientsToUse = searchQuery.isNotEmpty ? filteredClients : allClients;
    return (clientsToUse.isEmpty) ? 1 : ((clientsToUse.length - 1) ~/ pageSize) + 1;
  }

  List<ClientInvoiceModel> get currentInvoicePageItems {
    final start = (invoicePage - 1) * invoicePageSize;
    final end = (start + invoicePageSize).clamp(0, allInvoices.length);
    if (start >= allInvoices.length) return const [];
    return allInvoices.sublist(start, end);
  }

  int get totalInvoicePages => (allInvoices.isEmpty) ? 1 : ((allInvoices.length - 1) ~/ invoicePageSize) + 1;

  List<ClientInvoiceModel> get currentClientInvoicePageItems {
    final start = (clientPage - 1) * clientPageSize;
    final end = (start + clientPageSize).clamp(0, filteredInvoices.length);
    if (start >= filteredInvoices.length) return const [];
    return filteredInvoices.sublist(start, end);
  }

  int get totalClientInvoicePages =>
      (filteredInvoices.isEmpty) ? 1 : ((filteredInvoices.length - 1) ~/ clientPageSize) + 1;

  List<String> get activeClientInvoiceFilters {
    final filters = <String>[];
    if (clientInvoiceSearchQuery.isNotEmpty) filters.add('Search: "$clientInvoiceSearchQuery"');
    if (clientInvoiceStatusFilters.isNotEmpty) filters.add('Status: ${clientInvoiceStatusFilters.join(", ")}');
    if (!clientInvoiceDateRange.isEmpty) {
      if (clientInvoiceDateRange.presetName != null) {
        filters.add('Date: ${clientInvoiceDateRange.presetName}');
      } else if (clientInvoiceDateRange.isRange) {
        filters.add('Date: ${clientInvoiceDateRange.startDate} - ${clientInvoiceDateRange.endDate}');
      } else if (clientInvoiceDateRange.isSingleDate) {
        filters.add('Date: ${clientInvoiceDateRange.startDate}');
      }
    }
    return filters;
  }

  @override
  List<Object?> get props => [
    allClients,
    page,
    pageSize,
    loading,
    selectedClient,
    clientDetail,
    detailLoading,
    detailError,
    selectedCurrencyCode,
    allInvoices,
    selectedInvoiceIds,
    invoicePage,
    invoicePageSize,
    clientPage,
    clientPageSize,
    clientLoading,
    filteredInvoices,
    clientInvoiceSearchQuery,
    clientInvoiceStatusFilters,
    showClientInvoiceFilters,
    clientInvoiceDateRange,
    clientInvoiceStatusFilterItems,
    searchQuery,
    filteredClients,
    formName,
    formEmail,
    formType,
    formAddress1,
    formAddress2,
    formStateRegion,
    formCity,
    formPostalCode,
    formCountry,
    formCurrency,
    formWebsite,
    formNotes,
    formContractFile,
    creatingClient,
    createClientResult,
    isCityAndStateLoading,
    formNameController,
    formEmailController,
    formAddress1Controller,
    formAddress2Controller,
    formStateRegionController,
    formCityController,
    formPostalCodeController,
    formWebsiteController,
    formNotesController,
    formKey,
     allReceivables,
    selectedCurrencyCode,
    countries,
    formCountryCode,
    clientType,
    formClientType,
  ];
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