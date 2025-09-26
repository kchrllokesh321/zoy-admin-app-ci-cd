import 'package:equatable/equatable.dart';
import 'package:exchek/models/transaction_models/transaction_model.dart';
import 'package:exchek/widgets/custom_widget/custom_search_filter.dart';
import 'package:exchek/widgets/custom_widget/custom_date_range_picker.dart' show DateRange;

class TransectionState extends Equatable {
  final List<TransactionModel> all;
  final List<TransactionModel> filtered;
  final Set<int> selectedIds;
  final String searchQuery;
  final Set<String> statusFilters;
  final Set<String> currencyFilters;
  final List<SelectionItem> statusFilterItems;
  final List<SelectionItem> currencyFilterItems;
  final DateRange selectedDateRange;
  final int page;
  final int pageSize;
  final bool loading;
  final bool showFilters;

  const TransectionState({
    required this.all,
    required this.filtered,
    required this.selectedIds,
    required this.searchQuery,
    required this.statusFilters,
    required this.currencyFilters,
    required this.statusFilterItems,
    required this.currencyFilterItems,
    required this.selectedDateRange,
    required this.page,
    required this.pageSize,
    this.loading = false,
    this.showFilters = false,
  });

  factory TransectionState.initial() {
    final statusItems = [
      SelectionItem(id: 'Initialized', title: 'Initialized'),
      SelectionItem(id: 'Processing', title: 'Processing'),
      SelectionItem(id: 'Settled', title: 'Settled'),
      SelectionItem(id: 'Hold', title: 'Hold'),
      SelectionItem(id: 'Failed', title: 'Failed'),
    ];

    final currencyItems = [
      SelectionItem(id: 'USD', title: 'USD'),
      SelectionItem(id: 'EUR', title: 'EUR'),
      SelectionItem(id: 'GBP', title: 'GBP'),
      SelectionItem(id: 'INR', title: 'INR'),
    ];

    return TransectionState(
      all: [],
      filtered: [],
      selectedIds: {},
      searchQuery: '',
      statusFilters: {},
      currencyFilters: {},
      statusFilterItems: statusItems,
      currencyFilterItems: currencyItems,
      selectedDateRange: DateRange(),
      page: 1,
      pageSize: 10,
      loading: false,
      showFilters: false,
    );
  }

  TransectionState copyWith({
    List<TransactionModel>? all,
    List<TransactionModel>? filtered,
    Set<int>? selectedIds,
    String? searchQuery,
    Set<String>? statusFilters,
    Set<String>? currencyFilters,
    List<SelectionItem>? statusFilterItems,
    List<SelectionItem>? currencyFilterItems,
    DateRange? selectedDateRange,
    int? page,
    int? pageSize,
    bool? loading,
    bool? showFilters,
  }) {
    return TransectionState(
      all: all ?? this.all,
      filtered: filtered ?? this.filtered,
      selectedIds: selectedIds ?? this.selectedIds,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilters: statusFilters ?? this.statusFilters,
      currencyFilters: currencyFilters ?? this.currencyFilters,
      statusFilterItems: statusFilterItems ?? this.statusFilterItems,
      currencyFilterItems: currencyFilterItems ?? this.currencyFilterItems,
      selectedDateRange: selectedDateRange ?? this.selectedDateRange,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      loading: loading ?? this.loading,
      showFilters: showFilters ?? this.showFilters,
    );
  }

  List<TransactionModel> get currentPageItems {
    final start = (page - 1) * pageSize;
    final end = (start + pageSize).clamp(0, filtered.length);
    if (start >= filtered.length) return const [];
    return filtered.sublist(start, end);
  }

  int get totalPages => (filtered.isEmpty) ? 1 : ((filtered.length - 1) ~/ pageSize) + 1;

  List<String> get activeFilters {
    final filters = <String>[];
    // Search query is not included in active filters - it's just a search, not a filter
    if (statusFilters.isNotEmpty) filters.add('Status: ${statusFilters.join(", ")}');
    if (currencyFilters.isNotEmpty) filters.add('Currency: ${currencyFilters.join(", ")}');
    if (!selectedDateRange.isEmpty) {
      if (selectedDateRange.presetName != null) {
        filters.add('Date: ${selectedDateRange.presetName}');
      } else if (selectedDateRange.isRange) {
        filters.add('Date: ${selectedDateRange.startDate} - ${selectedDateRange.endDate}');
      } else if (selectedDateRange.isSingleDate) {
        filters.add('Date: ${selectedDateRange.startDate}');
      }
    }
    return filters;
  }

  @override
  List<Object?> get props => [
    all,
    filtered,
    selectedIds,
    searchQuery,
    statusFilters,
    currencyFilters,
    statusFilterItems,
    currencyFilterItems,
    selectedDateRange,
    page,
    pageSize,
    loading,
    showFilters,
  ];
}
