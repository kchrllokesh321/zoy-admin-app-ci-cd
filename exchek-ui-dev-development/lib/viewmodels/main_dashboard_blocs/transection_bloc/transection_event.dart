import 'package:equatable/equatable.dart';
import 'package:exchek/widgets/custom_widget/custom_search_filter.dart';
import 'package:exchek/widgets/custom_widget/custom_date_range_picker.dart' show DateRange;

abstract class TransectionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTransactionsRequested extends TransectionEvent {}

class SearchQueryChanged extends TransectionEvent {
  final String query;
  SearchQueryChanged(this.query);
  @override
  List<Object?> get props => [query];
}

class ToggleSelectTransaction extends TransectionEvent {
  final int id;
  ToggleSelectTransaction(this.id);
  @override
  List<Object?> get props => [id];
}

class ToggleSelectAllOnPage extends TransectionEvent {}

class ChangePageRequested extends TransectionEvent {
  final int page;
  ChangePageRequested(this.page);
  @override
  List<Object?> get props => [page];
}

class StatusFilterChanged extends TransectionEvent {
  final Set<String> statuses; // e.g., {'Initialized', 'Processing'}; empty -> no filter
  StatusFilterChanged(this.statuses);
  @override
  List<Object?> get props => [statuses];
}

class CurrencyFilterChanged extends TransectionEvent {
  final Set<String> currencies; // e.g., {'USD', 'EUR'}; empty -> no filter
  CurrencyFilterChanged(this.currencies);
  @override
  List<Object?> get props => [currencies];
}

class StatusFilterItemsChanged extends TransectionEvent {
  final List<SelectionItem> items;
  StatusFilterItemsChanged(this.items);
  @override
  List<Object?> get props => [items];
}

class CurrencyFilterItemsChanged extends TransectionEvent {
  final List<SelectionItem> items;
  CurrencyFilterItemsChanged(this.items);
  @override
  List<Object?> get props => [items];
}

class DateFilterChanged extends TransectionEvent {
  final Set<String> ranges;
  DateFilterChanged(this.ranges);
  @override
  List<Object?> get props => [ranges];
}

class DateFilterItemsChanged extends TransectionEvent {
  final List<SelectionItem> items;
  DateFilterItemsChanged(this.items);
  @override
  List<Object?> get props => [items];
}

class DateRangeChanged extends TransectionEvent {
  final DateRange range;
  DateRangeChanged(this.range);
  @override
  List<Object?> get props => [range];
}

class ToggleFiltersVisibility extends TransectionEvent {}

class ClearAllFiltersRequested extends TransectionEvent {}


class ResetRequested extends TransectionEvent {}

class ExportSelectedTransactions extends TransectionEvent {}

