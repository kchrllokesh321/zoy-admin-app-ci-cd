import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/models/invoice_models/invoice_model.dart';
import 'package:exchek/repository/invoice_repository.dart';
import 'invoice_event.dart';
import 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final ScrollController horizontalController = ScrollController();
  final InvoiceRepository invoiceRepository;
  Timer? _debounce;

  InvoiceBloc({required this.invoiceRepository}) : super(InvoiceState.initial()) {
    on<InvoiceStarted>(_onStarted);
    on<FetchClientNames>(_onFetchClientNames);
    on<SelectClient>(_onSelectClient);
    on<InvoiceRefreshRequested>(_onRefreshRequested);
    on<InvoiceSearchChanged>(_onSearchChanged);
    on<InvoiceFilterApplied>(_onFilterApplied);
    on<InvoiceSortChanged>(_onSortChanged);
    on<InvoicePageChanged>(_onPageChanged);
    on<InvoiceSelectionToggled>(_onSelectionToggled);
    on<InvoiceSelectAllToggled>(_onSelectAllToggled);
    on<InvoiceSelectionCleared>(_onSelectionCleared);
    on<InvoiceFileSelected>(_onFileSelected);
    on<InvoiceFileRemoved>(_onFileRemoved);
    on<InvoiceFormChanged>(_onFormChanged);
    on<InvoiceSubmitted>(_onSubmitted);
    on<ToggleFiltersVisibility>(_onToggleFiltersVisibility);
    on<InvoiceShareRequested>(_onShareRequested);
    on<InvoiceReminderSent>(_onReminderSent);
    on<EditReceivableRequested>(_onEditReceivableRequested);
    on<CancelDeleteInvoiceRequested>(_onCancelDeleteInvoiceRequested);
    on<EditInvoiceRequested>(_onEditInvoiceRequested);
    on<InvoiceFilterCleared>(_onFilterCleared);
    on<InvoiceFilterRemoved>(_onFilterRemoved);
    on<ClearAllFiltersRequested>(_onClearAllFiltersRequested);
    on<InvoiceClientSelected>(_onClientSelected);
    on<UploadInvoice>(_onUploadInvoice);
    on<InvoiceMultipleFiltersApplied>(_onMultipleFiltersApplied);
    on<DeleteCancelledInvoiceRequested>(_onDeleteCancelledInvoiceRequested);
    on<EditDraftInvoiceRequested>(_onEditDraftInvoiceRequested);
    on<LoadInvoiceForEditing>((event, emit) {
      final invoice = event.invoice;
      emit(
        state.copyWith(
          selectedClient: ClientModel(
            id: invoice.clientId,
            name: invoice.clientName,
            email: invoice.clientEmail,
            currency: invoice.currency,
          ),
          invoiceNumber: invoice.invoiceNumber,
          clientEmail: invoice.clientEmail,
          currency: invoice.currency,
          invoiceAmount: invoice.invoiceAmount,
          receivableAmount: invoice.receivableAmount,
          invoiceDate: invoice.invoiceDate,
          dueDate: invoice.dueDate,
          purposeCode: invoice.purposeCode,
          internalNotes: invoice.internalNotes ?? '',
          // Optionally add file info if you handle it in state
        ),
      );
    });
    on<RemindInvoiceRequested>(_onRemindInvoiceRequested);
    // on<LoadShareInvoiceContent>(_onLoadShareInvoiceContent);
    on<LoadShareContent>(_onLoadShareContent);
    on<SetInvoiceEditingMode>((event, emit) {
      emit(state.copyWith(isEditing: event.isEditing, id: event.id ?? state.id));
    });
    on<FetchCurrencyOptions>((event, emit) async {
      emit(state.copyWith(loading: true, error: null));
      try {
        final currencies = await invoiceRepository.fetchCurrencyOptions();
        emit(state.copyWith(currencyOptions: currencies, loading: false));
      } catch (e) {
        emit(state.copyWith(loading: false, error: e.toString()));
      }
    });
  }

  Map<String, String?> parseDateRangePreset(String? preset) {
    if (preset == null || preset.isEmpty || preset.toLowerCase() == 'all') {
      return {'fromDate': null, 'toDate': null};
    }

    final now = DateTime.now();
    String? toDate = now.toIso8601String().split('T').first;
    String? fromDate;

    final lower = preset.toLowerCase();

    if (lower.contains('7')) {
      fromDate = now.subtract(const Duration(days: 7)).toIso8601String().split('T').first;
    } else if (lower.contains('15')) {
      fromDate = now.subtract(const Duration(days: 15)).toIso8601String().split('T').first;
    } else if (lower.contains('30')) {
      fromDate = now.subtract(const Duration(days: 30)).toIso8601String().split('T').first;
    } else if (lower.contains('3')) {
      // covers both '3 months' and 'last 3 months'
      fromDate = DateTime(now.year, now.month - 3, now.day).toIso8601String().split('T').first;
    } else if (lower.contains('6')) {
      fromDate = DateTime(now.year, now.month - 6, now.day).toIso8601String().split('T').first;
    } else {
      fromDate = null;
      toDate = null;
    }

    return {'fromDate': fromDate, 'toDate': toDate};
  }

  void _onClientSelected(InvoiceClientSelected event, Emitter<InvoiceState> emit) {
    emit(
      state.copyWith(selectedClient: event.client, clientEmail: event.client.email, currency: event.client.currency),
    );
  }

  Future<void> _onStarted(InvoiceStarted event, Emitter<InvoiceState> emit) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final clients = await invoiceRepository.fetchClientNames();
      final currencies = await invoiceRepository.fetchCurrencyOptions();

      final clientName = state.activeFilters['clientName'];
      final currency = state.activeFilters['currency']?.split(',').map((e) => e.trim()).toList();
      final status = state.activeFilters['status']?.split(',').map((e) => e.trim()).toList();

      final dates = parseDateRangePreset(state.activeFilters['dateRange']);

      final fromDate = dates['fromDate'];
      final toDate = dates['toDate'];
      final purposeCodes = await invoiceRepository.fetchPurposeCodes();
      emit(state.copyWith(purposeCodeOptions: purposeCodes));

      final invoices = await invoiceRepository.fetchInvoices(
        clientName: clientName,
        currency: currency,
        fromDate: fromDate,
        toDate: toDate,
        status: status,
      );

      final tempState = state.copyWith(currencyOptions: currencies, clients: clients, all: invoices);
      final filtered = _applyFilters(tempState.all, '', {}, state.sortBy, state.sortAscending);
      emit(tempState.copyWith(filtered: filtered, loading: false, page: 1, selectedIds: <String>{}, error: null));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void removeFilterValue(BuildContext context, String key, String value) {
    final bloc = context.read<InvoiceBloc>();
    final currentFilters = Map<String, String>.from(bloc.state.activeFilters);
    if (currentFilters.containsKey(key)) {
      List<String> values = currentFilters[key]!.split(',').map((v) => v.trim()).toList();
      values.removeWhere((v) => v == value);
      if (values.isEmpty) {
        currentFilters.remove(key);
      } else {
        currentFilters[key] = values.join(',');
      }
      bloc.add(InvoiceMultipleFiltersApplied(currentFilters));
    }
  }

  Future<void> _onMultipleFiltersApplied(event, Emitter<InvoiceState> emit) async {
    final newFilters = Map<String, String>.from(event.filters);
    newFilters.removeWhere((k, v) => v.isEmpty || v.toLowerCase() == 'all');

    final clientName = newFilters['clientName'];
    final currency = newFilters['currency']?.split(',').map((e) => e.trim()).toList();
    final status = newFilters['status']?.split(',').map((e) => e.trim()).toList();

    String? fromDate = newFilters['from_date'];
    String? toDate = newFilters['to_date'];

    if ((fromDate == null || toDate == null) && newFilters.containsKey('dateRange')) {
      final dates = parseDateRangePreset(newFilters['dateRange']);
      fromDate = dates['fromDate'];
      toDate = dates['toDate'];
    }

    emit(state.copyWith(loading: true));
    try {
      final invoices = await invoiceRepository.fetchInvoices(
        clientName: clientName,
        currency: currency,
        fromDate: (fromDate?.isEmpty ?? true) ? null : fromDate,
        toDate: (toDate?.isEmpty ?? true) ? null : toDate,
        status: status,
      );
      final filtered = _applyFilters(invoices, state.searchQuery, newFilters, state.sortBy, state.sortAscending);
      emit(state.copyWith(activeFilters: newFilters, all: invoices, filtered: filtered, loading: false, page: 1));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onEditDraftInvoiceRequested(EditDraftInvoiceRequested event, Emitter<InvoiceState> emit) async {
    emit(state.copyWith(uploading: true, error: null, uploadSuccess: false));

    try {
      final success = await invoiceRepository.editDraftInvoice(
        id: event.id,
        clientId: event.clientId,
        invoiceNumber: event.invoiceNumber,
        currency: event.currency,
        invoiceAmount: event.invoiceAmount,
        receivableAmount: event.receivableAmount,
        invoiceDate: event.invoiceDate,
        dueDate: event.dueDate,
        purposeCode: event.purposeCode,
        status: event.status,
        invoiceFile: event.invoiceFile,
      );

      if (success.success == true) {
        emit(state.copyWith(uploading: false, uploadSuccess: true));
      } else {
        emit(
          state.copyWith(
            uploading: false,
            error: success.message ?? 'Failed to update invoice draft',
            uploadSuccess: false,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(uploading: false, error: e.toString(), uploadSuccess: false));
    }
  }

  Future<void> _onRemindInvoiceRequested(RemindInvoiceRequested event, Emitter<InvoiceState> emit) async {
    emit(state.copyWith(reminding: true, error: null));

    try {
      final success = await invoiceRepository.remindInvoiceToEmail(invoiceId: event.invoiceId);

      if (success.success == true) {
        emit(state.copyWith(reminding: false));
        AppToast.show(message: success.message ?? "Reminder sent to client", type: ToastificationType.success);
      } else {
        final errorMsg = success.message ?? "Failed to send reminder";
        emit(state.copyWith(reminding: false, error: errorMsg));
        AppToast.show(message: errorMsg, type: ToastificationType.error);
      }
    } catch (e) {
      emit(state.copyWith(reminding: false, error: e.toString()));
      AppToast.show(message: "Failed to send reminder: ${e.toString()}", type: ToastificationType.error);
    }
  }

  Future<void> _onLoadShareContent(LoadShareContent event, Emitter<InvoiceState> emit) async {
    emit(
      state.copyWith(
        loadingShareContent: true,
        shareSuccess: false,
        shareEmailSubject: '',
        shareEmailBody: '',
        shareEmailTo: '',
        error: null,
      ),
    );
    try {
      final data = await invoiceRepository.fetchShareInvoiceEmailContent(event.invoiceId);
      emit(
        state.copyWith(
          loadingShareContent: false,
          shareEmailSubject: data['subject'] ?? '',
          shareEmailBody: data['email_body'] ?? '',
          shareEmailTo: data['client_email'] ?? '',
          shareSuccess: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loadingShareContent: false, error: e.toString()));
    }
  }

  Future<void> _onDeleteCancelledInvoiceRequested(
    DeleteCancelledInvoiceRequested event,
    Emitter<InvoiceState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final result = await invoiceRepository.deleteCancelledInvoice(invoiceId: event.invoiceId);

      if (result.success == true) {
        await _onRefreshRequested(const InvoiceRefreshRequested(), emit);
      } else {
        emit(state.copyWith(error: 'Failed to delete/cancel invoice'));
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
    emit(state.copyWith(loading: false));
  }

  void _onClearAllFiltersRequested(ClearAllFiltersRequested event, Emitter<InvoiceState> emit) {
    final filteredInvoices = _applyFilters(state.all, '', {}, state.sortBy, state.sortAscending);
    emit(state.copyWith(activeFilters: {}, filtered: filteredInvoices, page: 1));
  }

  Future<void> _onFetchClientNames(FetchClientNames event, Emitter<InvoiceState> emit) async {
    emit(state.copyWith(clientLoading: true, error: null));
    try {
      final clients = await invoiceRepository.fetchClientNames(filter: event.filter);
      emit(state.copyWith(clients: clients, clientLoading: false, error: null));
    } catch (e) {
      emit(state.copyWith(clientLoading: false, error: e.toString()));
    }
  }

  Future<void> _onUploadInvoice(UploadInvoice event, Emitter<InvoiceState> emit) async {
    print("Uploading invoice with status: ${event.status}");
    emit(state.copyWith(uploading: true, error: null));
    try {
      final fileData = event.fileData;
      final response = await invoiceRepository.uploadInvoice(
        clientId: event.clientId,
        invoiceNumber: event.invoiceNumber,
        currency: event.currency,
        invoiceAmount: event.invoiceAmount,
        receivableAmount: event.receivableAmount,
        invoiceDate: event.invoiceDate,
        dueDate: event.dueDate,
        purposeCode: event.purposeCode,
        status: event.status,
        internalNotes: event.internalNotes,
        invoiceFile: fileData,
      );

      if (response.success == true) {
        AppToast.show(
          message: response.message?.isNotEmpty == true ? response.message! : 'Invoice uploaded successfully',
          type: ToastificationType.success,
        );

        add(const InvoiceRefreshRequested());
        emit(state.copyWith(uploading: false, uploadSuccess: true));
        emit(
          state.copyWith(
            uploading: false,
            uploadSuccess: true,
            selectedFile: null,
            invoiceNumber: '',
            clientEmail: '',
            currency: '',
            invoiceAmount: '',
            receivableAmount: '',
            invoiceDate: '',
            dueDate: '',
            purposeCode: '',
            internalNotes: '',
            selectedClient: null,
          ),
        );
      } else {
        final errorMsg = response.message?.isNotEmpty == true ? response.message! : 'Upload failed';
        AppToast.show(message: errorMsg, type: ToastificationType.error);

        emit(state.copyWith(uploading: false, uploadSuccess: false, error: errorMsg));
        emit(
          state.copyWith(
            uploading: false,
            uploadSuccess: false,
            selectedFile: null,
            invoiceNumber: '',
            clientEmail: '',
            currency: '',
            invoiceAmount: '',
            receivableAmount: '',
            invoiceDate: '',
            dueDate: '',
            purposeCode: '',
            internalNotes: '',
            selectedClient: null,
          ),
        );
      }
    } catch (e) {
      AppToast.show(message: e.toString(), type: ToastificationType.error);
      emit(state.copyWith(uploading: false, uploadSuccess: false, error: e.toString()));
      emit(
        state.copyWith(
          uploading: false,
          uploadSuccess: false,
          selectedFile: null,
          invoiceNumber: '',
          clientEmail: '',
          currency: '',
          invoiceAmount: "",
          receivableAmount: "",
          invoiceDate: '',
          dueDate: '',
          purposeCode: '',
          internalNotes: '',
          selectedClient: null,
        ),
      );
    }
  }

  void _onSelectClient(SelectClient event, Emitter<InvoiceState> emit) {
    emit(state.copyWith(selectedClient: event.client, clientEmail: event.client.email));
  }

  Future<void> _onRefreshRequested(InvoiceRefreshRequested event, Emitter<InvoiceState> emit) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final clientName = state.activeFilters['clientName'];
      final currency = state.activeFilters['currency']?.split(',').map((e) => e.trim()).toList();
      final status = state.activeFilters['status']?.split(',').map((e) => e.trim()).toList();

      final dates = parseDateRangePreset(state.activeFilters['dateRange']);

      final fromDate = dates['fromDate'];
      final toDate = dates['toDate'];

      final invoices = await invoiceRepository.fetchInvoices(
        clientName: clientName,
        currency: currency,
        fromDate: fromDate,
        toDate: toDate,
        status: status,
      );

      final filtered = _applyFilters(
        invoices,
        state.searchQuery,
        state.activeFilters,
        state.sortBy,
        state.sortAscending,
      );

      emit(state.copyWith(all: invoices, filtered: filtered, loading: false, selectedIds: <String>{}));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void _onSearchChanged(InvoiceSearchChanged event, Emitter<InvoiceState> emit) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final filtered = _applyFilters(state.all, event.query, state.activeFilters, state.sortBy, state.sortAscending);
      emit(state.copyWith(searchQuery: event.query, filtered: filtered, page: 1, selectedIds: <String>{}));
    });
  }

  void _onSortChanged(InvoiceSortChanged event, Emitter<InvoiceState> emit) {
    final filtered = _applyFilters(state.all, state.searchQuery, state.activeFilters, event.sortBy, event.ascending);
    emit(state.copyWith(sortBy: event.sortBy, sortAscending: event.ascending, filtered: filtered));
  }

  void _onFilterApplied(InvoiceFilterApplied event, Emitter<InvoiceState> emit) {
    final newFilters = Map<String, String>.from(state.activeFilters);
    newFilters[event.filterType] = event.filterValue;
    final filtered = _applyFilters(state.all, state.searchQuery, newFilters, state.sortBy, state.sortAscending);
    emit(state.copyWith(activeFilters: newFilters, filtered: filtered, page: 1, selectedIds: <String>{}));
  }

  void _onFilterRemoved(InvoiceFilterRemoved event, Emitter<InvoiceState> emit) {
    final newFilters = Map<String, String>.from(state.activeFilters);
    newFilters.remove(event.filterType);
    final filtered = _applyFilters(state.all, state.searchQuery, newFilters, state.sortBy, state.sortAscending);
    emit(state.copyWith(activeFilters: newFilters, filtered: filtered, page: 1, selectedIds: <String>{}));
  }

  void _onFilterCleared(InvoiceFilterCleared event, Emitter<InvoiceState> emit) {
    final filtered = _applyFilters(state.all, '', {}, state.sortBy, state.sortAscending);
    emit(
      state.copyWith(
        activeFilters: <String, String>{},
        filtered: filtered,
        page: 1,
        searchQuery: '',
        selectedIds: <String>{},
      ),
    );
  }

  void _onToggleFiltersVisibility(ToggleFiltersVisibility event, Emitter<InvoiceState> emit) {
    emit(state.copyWith(showFilters: !state.showFilters));
  }

  // void _onSortChanged(InvoiceSortChanged event, Emitter<InvoiceState> emit) {
  //   final filtered = _applyFilters(state.all, state.searchQuery, state.activeFilters, event.sortBy, event.ascending);
  //   emit(state.copyWith(sortBy: event.sortBy, sortAscending: event.ascending, filtered: filtered));
  // }

  void _onPageChanged(InvoicePageChanged event, Emitter<InvoiceState> emit) {
    final maxPage = (state.filtered.length / state.pageSize).ceil();
    final newPage = event.pageNumber.clamp(1, maxPage);
    emit(state.copyWith(page: newPage));
  }

  void _onSelectionToggled(InvoiceSelectionToggled event, Emitter<InvoiceState> emit) {
    final updatedIds = Set<String>.from(state.selectedIds);
    if (!updatedIds.remove(event.invoiceId)) {
      updatedIds.add(event.invoiceId);
    }
    emit(state.copyWith(selectedIds: updatedIds));
  }

  void _onSelectAllToggled(InvoiceSelectAllToggled event, Emitter<InvoiceState> emit) {
    final pageItems = state.filtered.skip((state.page - 1) * state.pageSize).take(state.pageSize);
    final pageIds = pageItems.map((e) => e.id).toSet();
    final updatedIds = Set<String>.from(state.selectedIds);
    if (pageIds.every(updatedIds.contains)) {
      updatedIds.removeAll(pageIds);
    } else {
      updatedIds.addAll(pageIds);
    }
    emit(state.copyWith(selectedIds: updatedIds));
  }

  void _onSelectionCleared(InvoiceSelectionCleared event, Emitter<InvoiceState> emit) {
    emit(state.copyWith(selectedIds: <String>{}));
  }

  void _onFileSelected(InvoiceFileSelected event, Emitter<InvoiceState> emit) {
    emit(state.copyWith(selectedFile: event.fileData, error: null));
  }

  void _onFileRemoved(InvoiceFileRemoved event, Emitter<InvoiceState> emit) {
    emit(state.copyWith(selectedFile: null, error: null));
  }

  void _onFormChanged(InvoiceFormChanged event, Emitter<InvoiceState> emit) {
    final field = event.field;
    final val = event.value;
    switch (field) {
      case 'invoiceNumber':
        emit(state.copyWith(invoiceNumber: val));
        break;
      case 'clientEmail':
        emit(state.copyWith(clientEmail: val));
        break;
      case 'currency':
        emit(state.copyWith(currency: val));
        break;
      case 'invoiceAmount':
        emit(state.copyWith(invoiceAmount: val));
        break;
      case 'receivableAmount':
        emit(state.copyWith(receivableAmount: val));
        break;
      case 'invoiceDate':
        emit(state.copyWith(invoiceDate: val));
        break;
      case 'dueDate':
        emit(state.copyWith(dueDate: val));
        break;
      case 'purposeCode':
        emit(state.copyWith(purposeCode: val));
        break;
      case 'internalNotes':
        emit(state.copyWith(internalNotes: val));
        break;
    }
  }

  // void _onToggleFiltersVisibility(ToggleFiltersVisibility event, Emitter<InvoiceState> emit) {
  //   emit(state.copyWith(showFilters: !state.showFilters));
  // }

  Future<void> _onSubmitted(InvoiceSubmitted event, Emitter<InvoiceState> emit) async {
    if (!state.isFormValid) {
      emit(state.copyWith(error: 'Please complete all required fields'));
      return;
    }
    emit(state.copyWith(uploading: true, error: null));
    await Future.delayed(const Duration(seconds: 2));

    final newInvoice = InvoiceModel(
      id: (state.all.isNotEmpty ? DateTime.now().millisecondsSinceEpoch.toString() : '1'),
      clientId: state.selectedClient?.id ?? '',
      invoiceNumber: state.invoiceNumber,
      clientName: state.selectedClient?.name ?? '',
      clientEmail: state.clientEmail,
      currency: state.currency,
      invoiceAmount: state.invoiceAmount,
      receivableAmount: state.receivableAmount,
      outstandingAmount: state.receivableAmount,
      invoiceDate: state.invoiceDate,
      dueDate: state.dueDate ?? '',
      purposeCode: state.purposeCode,
      description: state.purposeCode,
      internalNotes: state.internalNotes.isEmpty ? null : state.internalNotes,
      filePath: '/invoices/invoice_${state.all.length + 1}.pdf',
      createdAt: DateTime.now().toIso8601String(),
      status: 'Pending',
    );

    final updatedInvoices = [newInvoice, ...state.all];
    final filtered = _applyFilters(updatedInvoices, '', {}, state.sortBy, state.sortAscending);
    emit(
      state.copyWith(
        all: updatedInvoices,
        filtered: filtered,
        uploading: false,
        selectedIds: <String>{},
        selectedFile: null,
        invoiceNumber: '',
        clientEmail: '',
        currency: 'USD',
        invoiceAmount: '',
        receivableAmount: '',
        invoiceDate: '',
        dueDate: '',
        purposeCode: '',
        internalNotes: '',
        selectedClient: null,
      ),
    );
  }

  Future<void> _onShareRequested(InvoiceShareRequested event, Emitter<InvoiceState> emit) async {
    emit(state.copyWith(sharing: true, error: null));
    try {
      final success = await invoiceRepository.sendInvoiceEmail(
        invoiceId: event.invoiceId,
        subject: event.subject,
        emailBody: event.message,
        emailTo: event.to,
        emailCc: event.cc,
        emailBcc: event.bcc,
      );

      if (success.success == true) {
        emit(state.copyWith(sharing: false, shareSuccess: true));
        AppToast.show(message: success.message ?? 'Invoice emailed successfully', type: ToastificationType.success);
      } else {
        final errorMsg = success.message ?? 'Failed to send invoice email';
        emit(state.copyWith(sharing: false, error: errorMsg));
        AppToast.show(message: errorMsg, type: ToastificationType.error);
      }
    } catch (e) {
      emit(state.copyWith(sharing: false, error: e.toString()));
      // AppToast.show(message: 'Error sending invoice email: ${e.toString()}', type: ToastificationType.error);
    }
  }

  Future<void> _onReminderSent(InvoiceReminderSent event, Emitter<InvoiceState> emit) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: 'Failed to send reminder'));
    }
  }

  Future<void> _onEditReceivableRequested(EditReceivableRequested event, Emitter<InvoiceState> emit) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final parsedAmount = double.tryParse(event.newAmount);
      if (parsedAmount == null) {
        emit(state.copyWith(loading: false, error: 'Invalid receivable amount format'));
        return;
      }

      final result = await invoiceRepository.editReceivableAmountActiveInvoice(
        invoiceId: event.invoiceId,
        receivableAmount: parsedAmount,
      );

      if (result.success == true) {
        final updatedInvoices =
            state.all.map((inv) {
              if (inv.id == event.invoiceId) {
                return inv.copyWith(receivableAmount: event.newAmount);
              }
              return inv;
            }).toList();

        final filtered = _applyFilters(
          updatedInvoices,
          state.searchQuery,
          state.activeFilters,
          state.sortBy,
          state.sortAscending,
        );

        emit(state.copyWith(all: updatedInvoices, filtered: filtered, loading: false, error: null));
        // AppToast.show(message: 'Receivable amount updated successfully', type: ToastificationType.success);
      } else {
        emit(state.copyWith(loading: false, error: result.message ?? 'Failed to update receivable amount'));
      }
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onCancelDeleteInvoiceRequested(CancelDeleteInvoiceRequested event, Emitter<InvoiceState> emit) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final result = await invoiceRepository.deleteCancelledInvoice(invoiceId: event.invoiceId);
      if (result.success == true) {
        // Refresh invoice list after success
        add(const InvoiceRefreshRequested());
      } else {
        emit(state.copyWith(error: 'Failed to cancel/delete invoice'));
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
    emit(state.copyWith(loading: false));
  }

  Future<void> _onEditInvoiceRequested(EditInvoiceRequested event, Emitter<InvoiceState> emit) async {
    emit(state.copyWith(error: 'Edit Invoice feature not implemented.'));
  }

  List<InvoiceModel> _applyFilters(
    List<InvoiceModel> invoices,
    String searchQuery,
    Map<String, String> filters,
    String sortBy,
    bool ascending,
  ) {
    var filtered = invoices;

    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      filtered =
          filtered.where((inv) {
            return inv.invoiceNumber.toLowerCase().contains(q) ||
                inv.clientName.toLowerCase().contains(q) ||
                inv.clientEmail.toLowerCase().contains(q) ||
                inv.currency.toLowerCase().contains(q) ||
                inv.status.toLowerCase().contains(q);
          }).toList();
    }

    filters.forEach((key, value) {
      final values = value.split(',').map((s) => s.trim().toLowerCase()).toSet();
      switch (key) {
        case 'clientName':
          filtered = filtered.where((inv) => values.contains(inv.clientName.toLowerCase())).toList();
          break;
        case 'status':
          filtered = filtered.where((inv) => values.contains(inv.status.toLowerCase())).toList();
          break;
        case 'currency':
          filtered = filtered.where((inv) => values.contains(inv.currency.toLowerCase())).toList();
          break;
        case 'dateRange':
          filtered = _applyDateRangeFilter(filtered, value);
          break;
      }
    });

    filtered.sort((a, b) {
      int comp = 0;
      switch (sortBy) {
        case 'invoiceNumber':
          comp = a.invoiceNumber.compareTo(b.invoiceNumber);
          break;
        case 'clientName':
          comp = a.clientName.compareTo(b.clientName);
          break;
        case 'currency':
          comp = a.currency.compareTo(b.currency);
          break;
        case 'invoiceDate':
          comp = a.invoiceDate.compareTo(b.invoiceDate);
          break;
        case 'dueDate':
          comp = a.dueDate.compareTo(b.dueDate);
          break;
        case 'status':
          comp = a.status.compareTo(b.status);
          break;
        default:
          comp = a.invoiceDate.compareTo(b.invoiceDate);
      }
      return ascending ? comp : -comp;
    });

    return filtered;
  }

  List<InvoiceModel> _applyDateRangeFilter(List<InvoiceModel> invoices, String range) {
    final now = DateTime.now();
    late DateTime from;
    if (range.toLowerCase().contains('7')) {
      from = now.subtract(const Duration(days: 7));
    } else if (range.toLowerCase().contains('30')) {
      from = now.subtract(const Duration(days: 30));
    } else if (range.toLowerCase().contains('3')) {
      from = DateTime(now.year, now.month - 3, now.day);
    } else {
      return invoices;
    }

    return invoices.where((inv) {
      final dt = DateTime.tryParse(inv.invoiceDate);
      return dt != null && dt.isAfter(from) && dt.isBefore(now);
    }).toList();
  }
}
