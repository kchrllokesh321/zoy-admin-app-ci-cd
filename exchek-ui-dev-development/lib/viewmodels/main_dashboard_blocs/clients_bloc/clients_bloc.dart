import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/models/clients_models/clients_models.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/clients_bloc/clients_event.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/clients_bloc/clients_state.dart';
import 'package:exchek/widgets/custom_widget/custom_date_range_picker.dart';
import 'package:exchek/repository/clients_repository.dart';
import 'package:exchek/repository/personal_user_kyc_repository.dart';
import 'package:stream_transform/stream_transform.dart';

class ClientsBloc extends Bloc<ClientsEvent, ClientsState> {
  final ScrollController horizontalController = ScrollController();
  final ClientsRepository clientsRepository;
  final PersonalUserKycRepository personalUserKycRepository;

  ClientsBloc({required this.clientsRepository, required this.personalUserKycRepository})
    : super(ClientsState.initial()) {
    on<LoadClients>(_onLoad);
    on<ClientFormCountryChanged>(_onFormCountryChanged);
    on<CountryClientTypeOptions>(_onLoadCountryClientTypeOptions);
    on<ClientFormClientTypeChanged>(_onFormClientTypeChanged);
    on<ClientPageChanged>(_onClientPageChanged);
    on<ClientRowTapped>(_onClientRowTapped);
    on<ClientCurrencyChanged>(_onCurrencyChanged);
    on<LoadClientInvoicesRequested>(_onLoadClientInvoices);
    on<ToggleSelectClientInvoice>(_onToggleSelectClientInvoice);
    on<ToggleSelectAllClientInvoicesOnPage>(_onToggleSelectAllClientInvoicesOnPage);
    on<ClientInvoicePageChanged>(_onClientInvoicePageChanged);
    // Filter-related event handlers
    on<ClientInvoiceSearchQueryChanged>(_onClientInvoiceSearchQueryChanged);
    on<ClientInvoiceStatusFilterChanged>(_onClientInvoiceStatusFilterChanged);
    on<ClientInvoiceStatusFilterItemsChanged>(_onClientInvoiceStatusFilterItemsChanged);
    on<ClientInvoiceDateRangeChanged>(_onClientInvoiceDateRangeChanged);
    on<ToggleClientInvoiceFiltersVisibility>(_onToggleClientInvoiceFiltersVisibility);
    on<ClearAllClientInvoiceFiltersRequested>(_onClearAllClientInvoiceFiltersRequested);
    // Navigation events
    on<ClearSelectedClient>(_onClearSelectedClient);
    on<SearchQueryChanged>(
      _onSearch,
      transformer: (events, mapper) => events.debounce(const Duration(milliseconds: 350)).switchMap(mapper),
    );
    // Add Client form events
    on<ClientFormNameChanged>((e, emit) => emit(state.copyWith(formName: e.value)));
    on<ClientFormEmailChanged>((e, emit) => emit(state.copyWith(formEmail: e.value)));
    on<ClientFormTypeChanged>((e, emit) => emit(state.copyWith(formType: e.value)));
    on<ClientFormAddress1Changed>((e, emit) => emit(state.copyWith(formAddress1: e.value)));
    on<ClientFormAddress2Changed>((e, emit) => emit(state.copyWith(formAddress2: e.value)));
    on<ClientFormStateRegionChanged>((e, emit) => emit(state.copyWith(formStateRegion: e.value)));
    on<ClientFormCityChanged>((e, emit) => emit(state.copyWith(formCity: e.value)));
    on<ClientFormPostalCodeChanged>((e, emit) => emit(state.copyWith(formPostalCode: e.value)));
    on<ClientFormWebsiteChanged>((e, emit) => emit(state.copyWith(formWebsite: e.value)));
    on<ClientFormNotesChanged>((e, emit) => emit(state.copyWith(formNotes: e.value)));
    on<ClientFormContractChanged>((e, emit) => emit(state.copyWith(formContractFile: e.fileData)));
    on<SubmitCreateClientRequested>(_onSubmitCreateClient);
    on<ResetCreateClientResult>((e, emit) => emit(state.copyWith(createClientResult: null)));
    on<ResetCreateClientForm>(_onResetCreateClientForm);
    on<ResetRequested>((e, emit) => emit(ClientsState.initial()));
    on<UpdateClientDetails>(_onUpdateClientDetails);
     
     
  }

  Future<void> _onLoad(LoadClients event, Emitter<ClientsState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      final all = await clientsRepository.getAllClients();
      emit(state.copyWith(allClients: all, filteredClients: all, loading: false, page: 1));
    } catch (e) {
      emit(state.copyWith(loading: false));
    }
  }

  Future<void> _onLoadCountryClientTypeOptions(
    CountryClientTypeOptions event,
    Emitter<ClientsState> emit,
  ) async {
    final countryClientTypeOptions =
        await clientsRepository.countryClientTypeOptions();
    emit(
      state.copyWith(
        countries: countryClientTypeOptions.countries,
        clientType: countryClientTypeOptions.clientTypes,
      ),
    );
  }

  void _onFormCountryChanged(
    ClientFormCountryChanged event,
    Emitter<ClientsState> emit,
  ) {
    final selectedCountry = state.countries?.firstWhere(
      (c) => c.countryName == event.value || c.countryCode == event.value,
      orElse: () => Country(countryCode: '', countryName: ''),
    );
    if (selectedCountry != null && selectedCountry.countryCode.isNotEmpty) {
      emit(
        state.copyWith(
          formCountry: selectedCountry.countryName,
          formCountryCode: selectedCountry.countryCode,
        ),
      );
    }
  }

  void _onFormClientTypeChanged(
    ClientFormClientTypeChanged event,
    Emitter<ClientsState> emit,
  ) {
    final selectedClientType = state.clientType?.firstWhere(
      (c) =>
          c.clientTypeyName == event.value || c.clientTypeCode == event.value,
      orElse: () => ClientType(clientTypeCode: '', clientTypeyName: ''),
    );
    if (selectedClientType != null &&
        selectedClientType.clientTypeCode.isNotEmpty) {
      emit(
        state.copyWith(
          formClientType: selectedClientType.clientTypeyName,
          formType: selectedClientType.clientTypeCode,
        ),
      );
    }
  }

  Future<void> _onSubmitCreateClient(SubmitCreateClientRequested event, Emitter<ClientsState> emit) async {
    emit(state.copyWith(creatingClient: true, createClientResult: null));
    try {
      final result = await clientsRepository.createClient(
        clientName: state.formName.trim(),
        email: state.formEmail.trim(),
        clientType: state.formType ?? '',
        addressLine1: state.formAddress1.trim(),
        addressLine2: state.formAddress2.trim().isEmpty ? null : state.formAddress2.trim(),
        state: state.formStateRegion.trim().isEmpty ? null : state.formStateRegion.trim(),
        city: state.formCity.trim().isEmpty ? null : state.formCity.trim(),
        postalCode: state.formPostalCode.trim().isEmpty ? null : state.formPostalCode.trim(),
        country: state.formCountryCode ?? '',
        currency: state.formCurrency ?? '',
        notes: state.formNotes.trim().isEmpty ? null : state.formNotes.trim(),
      );
      emit(state.copyWith(creatingClient: false, createClientResult: result));
    } catch (e) {
      emit(state.copyWith(creatingClient: false));
    }
  }

  Future<void> _onUpdateClientDetails(
    UpdateClientDetails event,
    Emitter<ClientsState> emit
  ) async {
  
   try {
    final result = await clientsRepository.updateClient(event.data);
    // emit success state or handle result
  } catch (e) {
    // handle error
  }
  }

  void _onClientPageChanged(ClientPageChanged event, Emitter<ClientsState> emit) {
    final page = event.page.clamp(1, state.totalPages);
    emit(state.copyWith(page: page));
  }

  Future<void> _onClientRowTapped(ClientRowTapped event, Emitter<ClientsState> emit) async {
    final clientId = event.client.id;
    if (clientId == null || clientId.isEmpty) {
      emit(state.copyWith(detailError: 'Invalid client ID'));
      return;
    }

    emit(state.copyWith(selectedClient: event.client, detailLoading: true, clearDetailError: true));

    try {
      final clientDetailResponse = await clientsRepository.getClientDetailsWithInvoices(clientId);

      final allInvoices =
          clientDetailResponse.invoices
              .map(
                (invoice) => ClientInvoiceModel(
                  id: invoice.id,
                  invoiceDate: invoice.invoiceDate,
                  invoiceNumber: invoice.invoiceNumber,
                  receivedDate: invoice.receivedDate,
                  currency: invoice.currency,
                  totalAmount: invoice.totalAmount,
                  netAmount: invoice.netAmount,
                  status: invoice.status,
                ),
              )
              .toList();

      final selectedCurrency =
          state.selectedCurrencyCode.isNotEmpty
              ? state.selectedCurrencyCode
              : (clientDetailResponse.receivables.isNotEmpty ? clientDetailResponse.receivables.first.currency : '');

      emit(
        state.copyWith(
          clientDetail: clientDetailResponse.clientDetail,
          allInvoices: allInvoices,
          allReceivables: clientDetailResponse.receivables,
          selectedCurrencyCode: selectedCurrency,
          detailLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(detailLoading: false, detailError: e.toString()));
    }
  }

  void _onCurrencyChanged(ClientCurrencyChanged event, Emitter<ClientsState> emit) {
    emit(state.copyWith(selectedCurrencyCode: event.currencyCode));
    final sel = state.selectedClient;
    if (sel != null) add(ClientRowTapped(sel));
  }

  Future<void> _onLoadClientInvoices(LoadClientInvoicesRequested event, Emitter<ClientsState> emit) async {
    // Replace with repository: await repo.fetchClientInvoices(event.clientId)
    await Future.delayed(const Duration(milliseconds: 200));
    final invoices = List.generate(15, (i) {
      return ClientInvoiceModel(
        id: "${i + 1}",
        invoiceDate: '2024-05-${(i % 28) + 1}'.padLeft(2, '0'),
        invoiceNumber: 'INV-${1000 + i}',
        receivedDate: '2024-06-${(i % 28) + 1}'.padLeft(2, '0'),
        currency: state.selectedCurrencyCode,
        totalAmount: '\$${(200 + i * 10)}',
        netAmount: '\$${(180 + i * 10)}',
        status: i % 3 == 0 ? 'Received' : 'Failed',
      );
    });
    emit(
      state.copyWith(
        allInvoices: invoices,
        filteredInvoices: invoices,
        invoicePage: 1,
        selectedInvoiceIds: {},
        clientPage: 1,
        clientInvoiceSearchQuery: '',
        clientInvoiceStatusFilters: {},
        showClientInvoiceFilters: false,
      ),
    );
  }

  void _onToggleSelectClientInvoice(ToggleSelectClientInvoice event, Emitter<ClientsState> emit) {
    final set = Set<int>.from(state.selectedInvoiceIds);
    if (set.contains(event.invoiceId)) {
      set.remove(event.invoiceId);
    } else {
      set.add(event.invoiceId);
    }
    emit(state.copyWith(selectedInvoiceIds: set));
  }

  void _onToggleSelectAllClientInvoicesOnPage(ToggleSelectAllClientInvoicesOnPage event, Emitter<ClientsState> emit) {
    final set = Set<int>.from(state.selectedInvoiceIds);
    final pageItems = state.currentClientInvoicePageItems;
    final allSelected = pageItems.isNotEmpty && pageItems.every((e) => set.contains(int.parse(e.id ?? '0')));
    if (allSelected) {
      for (final r in pageItems) {
        set.remove(int.parse(r.id ?? '0'));
      }
    } else {
      for (final r in pageItems) {
        set.add(int.parse(r.id ?? '0'));
      }
    }
    emit(state.copyWith(selectedInvoiceIds: set));
  }

  void _onClientInvoicePageChanged(ClientInvoicePageChanged event, Emitter<ClientsState> emit) {
    final page = event.page.clamp(1, state.totalClientInvoicePages);
    emit(state.copyWith(clientPage: page));
  }

  // Filter-related event handlers
  void _onClientInvoiceSearchQueryChanged(ClientInvoiceSearchQueryChanged event, Emitter<ClientsState> emit) {
    final next = state.copyWith(clientInvoiceSearchQuery: event.query, clientPage: 1, selectedInvoiceIds: {});
    emit(next.copyWith(filteredInvoices: _applyClientInvoiceFilters(next)));
  }

  void _onClientInvoiceStatusFilterChanged(ClientInvoiceStatusFilterChanged event, Emitter<ClientsState> emit) {
    final next = state.copyWith(clientInvoiceStatusFilters: event.statuses, clientPage: 1, selectedInvoiceIds: {});
    emit(next.copyWith(filteredInvoices: _applyClientInvoiceFilters(next)));
  }

  void _onClientInvoiceStatusFilterItemsChanged(
    ClientInvoiceStatusFilterItemsChanged event,
    Emitter<ClientsState> emit,
  ) {
    emit(state.copyWith(clientInvoiceStatusFilterItems: event.items));
  }

  void _onClientInvoiceDateRangeChanged(ClientInvoiceDateRangeChanged event, Emitter<ClientsState> emit) {
    final next = state.copyWith(clientInvoiceDateRange: event.range, clientPage: 1, selectedInvoiceIds: {});
    emit(next.copyWith(filteredInvoices: _applyClientInvoiceFilters(next)));
  }

  void _onToggleClientInvoiceFiltersVisibility(ToggleClientInvoiceFiltersVisibility event, Emitter<ClientsState> emit) {
    emit(state.copyWith(showClientInvoiceFilters: !state.showClientInvoiceFilters));
  }

  void _onClearAllClientInvoiceFiltersRequested(
    ClearAllClientInvoiceFiltersRequested event,
    Emitter<ClientsState> emit,
  ) {
    // reset status items selections
    final resetStatusItems =
        state.clientInvoiceStatusFilterItems.map((item) => item.copyWith(isSelected: false)).toList();

    final next = state.copyWith(
      clientInvoiceSearchQuery: '',
      clientInvoiceStatusFilters: {},
      clientInvoiceStatusFilterItems: resetStatusItems,
      clientInvoiceDateRange: DateRange(),
      clientPage: 1,
      selectedInvoiceIds: {},
      showClientInvoiceFilters: false,
    );
    emit(next.copyWith(filteredInvoices: next.allInvoices));
  }

  void _onClearSelectedClient(ClearSelectedClient event, Emitter<ClientsState> emit) {
    Logger.error("state.clientType>>> ${state.clientType}");
    final newState = ClientsState(
      allClients: state.allClients,
      page: state.page,
      pageSize: state.pageSize,
      loading: state.loading,
      selectedClient: null,
      clientDetail: null,
      detailLoading: false,
      detailError: null,
      selectedCurrencyCode: state.selectedCurrencyCode,
      allInvoices: const [],
      selectedInvoiceIds: const {},
      invoicePage: 1,
      invoicePageSize: 10,
      clientPage: 1,
      clientPageSize: 10,
      clientLoading: false,
      filteredInvoices: const [],
      clientInvoiceSearchQuery: '',
      clientInvoiceStatusFilters: const {},
      showClientInvoiceFilters: false,
      clientInvoiceDateRange: state.clientInvoiceDateRange,
      clientInvoiceStatusFilterItems: state.clientInvoiceStatusFilterItems,
      countries: state.countries,
      clientType: state.clientType,
    );

    emit(newState);
  }

  void _onResetCreateClientForm(ResetCreateClientForm event, Emitter<ClientsState> emit) {
    // Reset all form fields and controllers
    state.formNameController?.clear();
    state.formEmailController?.clear();
    state.formAddress1Controller?.clear();
    state.formAddress2Controller?.clear();
    state.formStateRegionController?.clear();
    state.formCityController?.clear();
    state.formPostalCodeController?.clear();
    state.formWebsiteController?.clear();
    state.formNotesController?.clear();

    emit(
      state.copyWith(
        formName: '',
        formEmail: '',
        formType: '',
        formAddress1: '',
        formAddress2: '',
        formStateRegion: '',
        formCity: '',
        formPostalCode: '',
        formCountry: '',
        formCurrency: null,
        formWebsite: '',
        formNotes: '',
        formContractFile: null,
        creatingClient: false,
        createClientResult: null,
        formClientType: '',
        formCountryCode: '',

      ),
    );
  }

  Future<void> _onSearch(SearchQueryChanged event, Emitter<ClientsState> emit) async {
    final query = event.query.trim();
    emit(state.copyWith(searchQuery: query, loading: true));
    try {
      final all = await clientsRepository.getAllClients(filter: query.isEmpty ? null : query);
      emit(state.copyWith(allClients: all, filteredClients: all, page: 1, loading: false));
    } catch (e) {
      Logger.error("error::: $e");
      emit(state.copyWith(loading: false));
    }
  }

  List<ClientInvoiceModel> _applyClientInvoiceFilters(ClientsState s) {
    final query = s.clientInvoiceSearchQuery.toLowerCase();
    final Set<String> activeStatuses = s.clientInvoiceStatusFilters.map((e) => e.toLowerCase()).toSet();
    final range = s.clientInvoiceDateRange;

    bool withinRange(String dateStr) {
      if (range.isEmpty) return true;
      try {
        // expecting yyyy-MM-dd in mock data
        final date = DateTime.tryParse(dateStr.replaceAll('/', '-'));
        if (date == null) return true;
        if (range.isSingleDate) {
          final d = DateTime(date.year, date.month, date.day);
          final sday = DateTime(range.startDate!.year, range.startDate!.month, range.startDate!.day);
          return d.isAtSameMomentAs(sday);
        }
        if (range.isRange) {
          final start = DateTime(range.startDate!.year, range.startDate!.month, range.startDate!.day);
          final end = DateTime(range.endDate!.year, range.endDate!.month, range.endDate!.day);
          return !date.isBefore(start) && !date.isAfter(end);
        }
        return true;
      } catch (_) {
        return true;
      }
    }

    return s.allInvoices.where((invoice) {
      final matchesText =
          query.isEmpty
              ? true
              : (invoice.invoiceDate?.toLowerCase().contains(query) ??
                  false ||
                      (invoice.invoiceNumber ?? '').toLowerCase().contains(query) ||
                      (invoice.totalAmount ?? '').toLowerCase().contains(query) ||
                      (invoice.netAmount ?? '').toLowerCase().contains(query) ||
                      (invoice.status ?? '').toLowerCase().contains(query));
      final matchesStatus =
          activeStatuses.isEmpty ? true : activeStatuses.contains(invoice.status?.toLowerCase() ?? '');
      final matchesDate = withinRange(invoice.invoiceDate ?? '');
      return matchesText && matchesStatus && matchesDate;
    }).toList();
  }

  @override
  Future<void> close() {
    horizontalController.dispose();
    return super.close();
  }
}
