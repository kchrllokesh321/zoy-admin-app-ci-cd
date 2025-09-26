import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/views/main_dashboard_view/transection_view/pdf_export_service.dart';
import 'package:exchek/models/transaction_models/transaction_model.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/transection_bloc/transection_event.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/transection_bloc/transection_state.dart';
import 'package:exchek/widgets/custom_widget/custom_date_range_picker.dart' show DateRange;

class TransectionBloc extends Bloc<TransectionEvent, TransectionState> {
  final ScrollController horizontalController = ScrollController();

  TransectionBloc() : super(TransectionState.initial()) {
    on<LoadTransactionsRequested>(_onLoad);
    on<SearchQueryChanged>(_onSearch);
    on<StatusFilterChanged>(_onStatusFilterChanged);
    on<CurrencyFilterChanged>(_onCurrencyFilterChanged);
    on<StatusFilterItemsChanged>(_onStatusFilterItemsChanged);
    on<CurrencyFilterItemsChanged>(_onCurrencyFilterItemsChanged);
    on<DateRangeChanged>(_onDateRangeChanged);
    on<ToggleSelectTransaction>(_onToggleSelect);
    on<ToggleSelectAllOnPage>(_onToggleSelectAllOnPage);
    on<ChangePageRequested>(_onChangePage);
    on<ToggleFiltersVisibility>(_onToggleFiltersVisibility);
    on<ClearAllFiltersRequested>(_onClearAllFilters);
    on<ResetRequested>((e, emit) => emit(TransectionState.initial()));
    on<ExportSelectedTransactions>(_onExportSelectedTransactions);
  }

  Future<void> _onLoad(LoadTransactionsRequested event, Emitter<TransectionState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      // Mock data for now; replace with repository call later
      final List<TransactionModel> all = List.generate(78, (index) {
        final id = index + 1;
        final statuses = ['Initialized', 'Processing', 'Settled', 'Hold', 'Failed'];
        final currencies = ['USD', 'EUR', 'GBP', 'INR'];
        final paymentMethods = ['Bank Transfer', 'Credit Card', 'PayPal', 'Wire Transfer'];
        final purposes = ['Business Payment', 'Personal Transfer', 'Invoice Payment', 'Refund'];

        return TransactionModel(
          id: id,
          referenceId: '', // Will be blank for now
          clientName: 'Client $id',
          invoiceNumber: 'INV-${1000 + id}',
          purpose: purposes[id % purposes.length],
          paymentMethod: paymentMethods[id % paymentMethods.length],
          fees: '\$${(id * 0.5).toStringAsFixed(2)}',
          additionalNotes: id % 3 == 0 ? 'Additional notes for transaction $id' : '',
          initiatedDate: DateTime.now().subtract(Duration(days: id)).toString().split(' ')[0],
          completedDate: id % 2 == 0 ? DateTime.now().subtract(Duration(days: id - 1)).toString().split(' ')[0] : '',
          status: statuses[id % statuses.length],
          receivingCurrency: currencies[id % currencies.length],
          grossAmount: '\$${(1000 + id * 50).toStringAsFixed(2)}',
          settledAmount: '\$${(950 + id * 45).toStringAsFixed(2)}',
        );
      });
      emit(state.copyWith(all: all, filtered: all, loading: false, page: 1, selectedIds: {}));
    } catch (e) {
      emit(state.copyWith(loading: false));
      Logger.error('Error loading transactions: $e');
    }
  }

  void _onSearch(SearchQueryChanged event, Emitter<TransectionState> emit) {
    final next = state.copyWith(searchQuery: event.query, page: 1, selectedIds: {});
    emit(next.copyWith(filtered: _applyFilters(next)));
  }

  void _onStatusFilterChanged(StatusFilterChanged event, Emitter<TransectionState> emit) {
    final next = state.copyWith(statusFilters: event.statuses, page: 1, selectedIds: {});
    emit(next.copyWith(filtered: _applyFilters(next)));
  }

  void _onCurrencyFilterChanged(CurrencyFilterChanged event, Emitter<TransectionState> emit) {
    final next = state.copyWith(currencyFilters: event.currencies, page: 1, selectedIds: {});
    emit(next.copyWith(filtered: _applyFilters(next)));
  }

  void _onStatusFilterItemsChanged(StatusFilterItemsChanged event, Emitter<TransectionState> emit) {
    emit(state.copyWith(statusFilterItems: event.items));
  }

  void _onCurrencyFilterItemsChanged(CurrencyFilterItemsChanged event, Emitter<TransectionState> emit) {
    emit(state.copyWith(currencyFilterItems: event.items));
  }

  void _onDateRangeChanged(DateRangeChanged event, Emitter<TransectionState> emit) {
    final next = state.copyWith(selectedDateRange: event.range, page: 1, selectedIds: {});
    emit(next.copyWith(filtered: _applyFilters(next)));
  }

  List<TransactionModel> _applyFilters(TransectionState s) {
    final query = s.searchQuery.toLowerCase();
    final Set<String> activeStatuses = s.statusFilters.map((e) => e.toLowerCase()).toSet();
    final Set<String> activeCurrencies = s.currencyFilters.map((e) => e.toLowerCase()).toSet();
    return s.all.where((t) {
      // Global search only searches by Client Name
      final matchesText = query.isEmpty ? true : t.clientName.toLowerCase().contains(query);
      final matchesStatus = activeStatuses.isEmpty ? true : activeStatuses.contains(t.status.toLowerCase());
      final matchesCurrency =
          activeCurrencies.isEmpty ? true : activeCurrencies.contains(t.receivingCurrency.toLowerCase());
      DateTime? initiatedDate;
      try {
        initiatedDate = DateTime.tryParse(t.initiatedDate);
      } catch (_) {
        initiatedDate = null;
      }

      bool matchesDate = true;
      if (!s.selectedDateRange.isEmpty && initiatedDate != null) {
        final start = s.selectedDateRange.startDate;
        final end = s.selectedDateRange.endDate;
        if (start != null && end != null) {
          matchesDate =
              (initiatedDate.isAtSameMomentAs(start) || initiatedDate.isAfter(start)) &&
              (initiatedDate.isAtSameMomentAs(end) || initiatedDate.isBefore(end));
        } else if (start != null) {
          matchesDate = initiatedDate.isAtSameMomentAs(start) || initiatedDate.isAfter(start);
        }
      }
      return matchesText && matchesStatus && matchesCurrency && matchesDate;
    }).toList();
  }

  void _onToggleSelect(ToggleSelectTransaction event, Emitter<TransectionState> emit) {
    final next = Set<int>.from(state.selectedIds);
    if (next.contains(event.id)) {
      next.remove(event.id);
    } else {
      next.add(event.id);
    }
    emit(state.copyWith(selectedIds: next));
  }

  void _onToggleSelectAllOnPage(ToggleSelectAllOnPage event, Emitter<TransectionState> emit) {
    final pageItems = state.currentPageItems;
    final allSelected = pageItems.every((t) => state.selectedIds.contains(t.id));
    final next = Set<int>.from(state.selectedIds);
    if (allSelected) {
      for (final t in pageItems) {
        next.remove(t.id);
      }
    } else {
      for (final t in pageItems) {
        next.add(t.id);
      }
    }
    emit(state.copyWith(selectedIds: next));
  }

  void _onChangePage(ChangePageRequested event, Emitter<TransectionState> emit) {
    final page = event.page.clamp(1, state.totalPages);
    emit(state.copyWith(page: page));
  }

  void _onToggleFiltersVisibility(ToggleFiltersVisibility event, Emitter<TransectionState> emit) {
    emit(state.copyWith(showFilters: !state.showFilters));
  }

  void _onClearAllFilters(ClearAllFiltersRequested event, Emitter<TransectionState> emit) {
    // Reset filter items to initial state (no selections)
    final resetStatusItems = state.statusFilterItems.map((item) => item.copyWith(isSelected: false)).toList();
    final resetCurrencyItems = state.currencyFilterItems.map((item) => item.copyWith(isSelected: false)).toList();

    final next = state.copyWith(
      searchQuery: '',
      statusFilters: {},
      currencyFilters: {},
      statusFilterItems: resetStatusItems,
      currencyFilterItems: resetCurrencyItems,
      selectedDateRange: DateRange(),
      page: 1,
      selectedIds: {},
    );
    emit(next.copyWith(filtered: next.all));
  }

  Future<void> _onExportSelectedTransactions(ExportSelectedTransactions event, Emitter<TransectionState> emit) async {
    try {
      final selectedTransactions = state.all.where((t) => state.selectedIds.contains(t.id)).toList();

      if (selectedTransactions.isEmpty) {
        // TODO: Show error message to user
        Logger.warning('No transactions selected for export');
        return;
      }

      final pdfFile = await PdfExportService.exportTransactionsToPdf(selectedTransactions);

      if (pdfFile != null) {
        // Trigger automatic download
        await _downloadPdfFile(pdfFile);
        Logger.info('PDF exported and downloaded successfully: ${pdfFile.path}');
        Logger.info('Exported ${selectedTransactions.length} transactions');
      } else {
        // TODO: Show error message to user
        Logger.error('Failed to export PDF');
      }
    } catch (e) {
      // TODO: Show error message to user
      Logger.error('Error during export: $e');
    }
  }

  Future<void> _downloadPdfFile(File? pdfFile) async {
    try {
      if (pdfFile != null) {
        // For mobile platforms, open the file
        // You can implement platform-specific file opening here
        Logger.info('PDF ready for download: ${pdfFile.path}');
      }
      // For web platform, download is handled directly in PdfExportService
    } catch (e) {
      Logger.error('Error downloading PDF: $e');
    }
  }

  @override
  Future<void> close() {
    horizontalController.dispose();
    return super.close();
  }
}
