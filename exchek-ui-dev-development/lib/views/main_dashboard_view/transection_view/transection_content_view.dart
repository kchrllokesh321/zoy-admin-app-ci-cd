import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/transection_bloc/transection_bloc.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/transection_bloc/transection_event.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/transection_bloc/transection_state.dart';
import 'package:exchek/widgets/custom_widget/custom_search_filter.dart';
import 'package:exchek/widgets/custom_widget/custom_date_range_picker.dart';
import 'package:exchek/widgets/common_widget/fixed_pagination.dart';
import 'package:exchek/widgets/custom_widget/custom_checkbox.dart';
import 'package:exchek/widgets/common_widget/responsive_data_table.dart';

class TransectionContentView extends StatelessWidget {
  const TransectionContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransectionBloc()..add(LoadTransactionsRequested()),
      child: BlocBuilder<TransectionBloc, TransectionState>(
        builder: (context, state) {
          return EntranceFader(
            slideDirection: SlideDirection.bottomToTop,
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getWidgetSize(context, desktop: 42, tablet: 36, mobile: 30),
                vertical: ResponsiveHelper.getWidgetSize(context, desktop: 36, tablet: 30, mobile: 24),
              ),
              children: [
                _buildTopBar(context, state),
                buildSizedBoxH(20),
                if (state.showFilters) _buildFilterChips(context, state),
                buildSizedBoxH(20),
                _buildTable(context, state),
                buildSizedBoxH(20),
                _buildPagination(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, TransectionState state) {
    final theme = Theme.of(context);
    final hasActiveFilters = state.activeFilters.isNotEmpty;

    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 455),
              child: CustomTextInputField(
                context: context,
                type: InputType.text,
                hintLabel: Lang.of(context).lbl_global_search,
                borderRadius: 71,
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                filled: true,
                fillColor: theme.customColors.fillColor,
                hintStyle: theme.textTheme.displayMedium?.copyWith(
                  color: theme.customColors.tableBorderColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: CustomImageView(
                    imagePath: Assets.images.svgs.icons.icSearch.path,
                    alignment: Alignment.center,
                    onTap: () {},
                  ),
                ),
                controller: TextEditingController(text: state.searchQuery),
                onChanged: (v) {
                  context.read<TransectionBloc>().add(SearchQueryChanged(v));
                },
              ),
            ),
          ),
        ),
        buildSizedboxW(12),
        // Show applied filters indicator if filters are applied, otherwise show filter icon button
        hasActiveFilters ? _buildAppliedFiltersIndicator(context, state) : _buildFilterIconButton(context),
        buildSizedboxW(24),
        _buildExportButton(context, state),
      ],
    );
  }

  Widget _buildFilterChips(BuildContext context, TransectionState state) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        CustomSearchFilter(
          searchHint: 'Search here',
          popupWidth: 200,
          title: 'Status',
          optionTitle: 'Select Status',
          items: state.statusFilterItems,
          onSelectionChanged: (selectedItems) {
            final selectedStatuses = selectedItems.where((item) => item.isSelected).map((item) => item.title).toSet();
            context.read<TransectionBloc>().add(StatusFilterChanged(selectedStatuses));
            context.read<TransectionBloc>().add(StatusFilterItemsChanged(selectedItems));
          },
          multiSelect: true,
          searchBarShow: true,
        ),
        CustomSearchFilter(
          searchHint: 'Search here',
          popupWidth: 200,
          title: 'Currency',
          optionTitle: 'Select Currency',
          items: state.currencyFilterItems,
          onSelectionChanged: (selectedItems) {
            final selectedCurrencies = selectedItems.where((item) => item.isSelected).map((item) => item.title).toSet();
            context.read<TransectionBloc>().add(CurrencyFilterChanged(selectedCurrencies));
            context.read<TransectionBloc>().add(CurrencyFilterItemsChanged(selectedItems));
          },
          multiSelect: true,
          searchBarShow: true,
        ),
        // Date range picker dropdown
        CustomDatePicker(
          title: 'Date',
          hintText: 'Select Date Range',
          initialDateRange: state.selectedDateRange,
          allowSingleDate: false,
          popupWidth: ResponsiveHelper.getWidgetSize(context, desktop: 700, tablet: 600, mobile: 500),
          onDateRangeChanged: (range) {
            context.read<TransectionBloc>().add(DateRangeChanged(range));
          },
        ),
        InkWell(
          onTap: () {
            context.read<TransectionBloc>().add(ClearAllFiltersRequested());
          },
          child: Text(
            'Clear all',
            textAlign: TextAlign.center,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.customColors.greentextColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTable(BuildContext context, TransectionState state) {
    final theme = Theme.of(context);
    final items = state.currentPageItems;
    final bloc = context.read<TransectionBloc>();

    final columns = <DataColumn>[
      DataColumn(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomCheckbox(
              value:
                  state.currentPageItems.isNotEmpty &&
                  state.currentPageItems.every((r) => state.selectedIds.contains(r.id)),
              onChanged: (_) => context.read<TransectionBloc>().add(ToggleSelectAllOnPage()),
            ),
            buildSizedboxW(12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Client Name',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.customColors.blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
                buildSizedboxW(4),
                CustomImageView(imagePath: Assets.images.svgs.icons.icSort.path, height: 14, width: 14, onTap: () {}),
              ],
            ),
          ],
        ),
        onSort: (columnIndex, ascending) {},
      ),
      DataColumn(
        label: Text(
          'Invoice Number',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.customColors.blackColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        onSort: (i, a) {},
      ),
      DataColumn(
        label: Text(
          'Initiated Date',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.customColors.blackColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        onSort: (i, a) {},
      ),
      DataColumn(
        label: Text(
          'Completed Date',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.customColors.blackColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        onSort: (i, a) {},
      ),
      DataColumn(
        label: Text(
          'Status',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.customColors.blackColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        onSort: (i, a) {},
      ),
      DataColumn(
        label: Text(
          'Currency',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.customColors.blackColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        onSort: (i, a) {},
      ),
      DataColumn(
        label: Text(
          'Gross Amount',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.customColors.blackColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        onSort: (i, a) {},
      ),
      DataColumn(
        label: Text(
          'Settled Amount',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.customColors.blackColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        onSort: (i, a) {},
      ),
    ];

    final dataRows =
        items.map((row) {
          final isSelected = state.selectedIds.contains(row.id);
          return DataRow(
            selected: isSelected,
            onSelectChanged: (selected) {
              context.read<TransectionBloc>().add(ToggleSelectTransaction(row.id));
            },
            cells: [
              DataCell(
                Row(
                  children: [
                    CustomCheckbox(
                      value: isSelected,
                      onChanged: (_) => context.read<TransectionBloc>().add(ToggleSelectTransaction(row.id)),
                    ),
                    buildSizedboxW(12),
                    Text(
                      row.clientName,
                      style: theme.textTheme.displayMedium?.copyWith(
                        color: theme.customColors.blackColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              DataCell(
                Text(
                  row.invoiceNumber,
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: theme.customColors.blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              DataCell(
                Text(
                  row.initiatedDate,
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: theme.customColors.blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              DataCell(
                Text(
                  row.completedDate.isEmpty ? '-' : row.completedDate,
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: theme.customColors.blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              DataCell(_buildStatusPill(row.status, theme, context)),
              DataCell(
                Text(
                  row.receivingCurrency,
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: theme.customColors.blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              DataCell(
                Text(
                  row.grossAmount,
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: theme.customColors.blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              DataCell(
                Text(
                  row.settledAmount,
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: theme.customColors.blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        }).toList();

    return ResponsiveDataTable(
      columns: columns,
      rows: dataRows,
      minTableWidth: 1200,
      horizontalController: bloc.horizontalController,
    );
  }

  Widget _buildStatusPill(String status, ThemeData theme, BuildContext context) {
    Color bg;
    Color fg;

    switch (status.toLowerCase()) {
      case 'initialized':
        bg = theme.customColors.blueColor?.withValues(alpha: 0.1) ?? Colors.blue.withValues(alpha: 0.1);
        fg = theme.customColors.blueColor ?? Colors.blue;
        break;
      case 'processing':
        bg = theme.customColors.purpleColor?.withValues(alpha: 0.1) ?? Colors.purple.withValues(alpha: 0.1);
        fg = theme.customColors.purpleColor ?? Colors.purple;
        break;
      case 'settled':
        bg = theme.customColors.greenColor?.withValues(alpha: 0.1) ?? Colors.green.withValues(alpha: 0.1);
        fg = theme.customColors.greentextColor ?? Colors.green;
        break;
      case 'hold':
        bg = theme.customColors.darkGreyColor?.withValues(alpha: 0.1) ?? Colors.grey.withValues(alpha: 0.1);
        fg = theme.customColors.darkGreyColor ?? Colors.grey;
        break;
      case 'failed':
        bg = theme.customColors.redColor?.withValues(alpha: 0.1) ?? Colors.red.withValues(alpha: 0.1);
        fg = theme.customColors.redtextColor ?? Colors.red;
        break;
      default:
        bg = theme.customColors.greyTextColor?.withValues(alpha: 0.1) ?? Colors.grey.withValues(alpha: 0.1);
        fg = theme.customColors.greyTextColor ?? Colors.grey;
    }

    return Container(
      height: 32,
      width: 88,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(5)),
      child: Center(
        child: Text(
          status,
          style: theme.textTheme.labelLarge?.copyWith(
            color: fg,
            fontSize: ResponsiveHelper.getFontSize(context, desktop: 16, mobile: 14, tablet: 15),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildPagination(BuildContext context, TransectionState state) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Showing ${(state.page - 1) * state.pageSize + 1}-${((state.page - 1) * state.pageSize + state.currentPageItems.length)} of ${state.filtered.length}',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.customColors.paginationTextColor),
        ),
        buildSizedboxW(16),
        _buildFixedPager(context, state),
      ],
    );
  }

  Widget _buildFilterIconButton(BuildContext context) {
    return CustomImageView(
      imagePath: Assets.images.svgs.icons.icFilter.path,
      height: 44,
      onTap: () => context.read<TransectionBloc>().add(ToggleFiltersVisibility()),
    );
  }

  Widget _buildExportButton(BuildContext context, TransectionState state) {
    final hasSelectedItems = state.selectedIds.isNotEmpty;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 118),
      child: CustomElevatedButton(
        height: 42,
        borderRadius: 14,
        iconSpacing: 16,
        leftIcon: CustomImageView(
          imagePath: Assets.images.svgs.icons.icExport.path,
          height: 22,
          width: 22,
          onTap: () {},
        ),
        onPressed:
            hasSelectedItems
                ? () {
                  _showExportDialog(context, state.selectedIds.length);
                }
                : null,
        text: Lang.of(context).lbl_export,
      ),
    );
  }

  void _showExportDialog(BuildContext context, int selectedCount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            padding: EdgeInsets.all(24.0),
            clipBehavior: Clip.hardEdge,
            constraints: BoxConstraints(maxWidth: ResponsiveHelper.getMaxDialogWidth(context)),
            decoration: BoxDecoration(
              color: Theme.of(context).customColors.fillColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Export Transaction",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 22.0),
                ),
                buildSizedBoxH(10),
                Text(
                  "Are you sure you want to export $selectedCount transaction${selectedCount == 1 ? '' : 's'}?",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16.0),
                ),
                buildSizedBoxH(16),
                Row(
                  spacing: 10.0,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(overlayColor: Colors.transparent),
                      onPressed: () {
                        GoRouter.of(context).pop();
                      },
                      child: Text(
                        "Close",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(fontSize: 14.0, fontWeight: FontWeight.w600),
                      ),
                    ),
                    CustomElevatedButton(
                      borderRadius: 5.0,
                      width: 120.0,
                      height: 35.0,
                      onPressed: () {
                        GoRouter.of(context).pop();
                        context.read<TransectionBloc>().add(ExportSelectedTransactions());
                      },
                      text: "Yes, export",
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppliedFiltersIndicator(BuildContext context, TransectionState state) {
    final theme = Theme.of(context);
    final activeFilters = state.activeFilters;

    if (activeFilters.isEmpty) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: () => context.read<TransectionBloc>().add(ToggleFiltersVisibility()),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.customColors.fillColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.customColors.darkGreyColor!.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.filter_list_rounded, size: 20, color: theme.customColors.blackColor),
            buildSizedboxW(8),
            Text(
              '${activeFilters.length} filter${activeFilters.length == 1 ? '' : 's'} applied',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.customColors.greentextColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            buildSizedboxW(8),
            Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: theme.customColors.blackColor),
          ],
        ),
      ),
    );
  }

  Widget _buildFixedPager(BuildContext context, TransectionState state) {
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: FittedBox(
          child: FixedPagination(
            currentPage: state.page,
            totalPages: state.totalPages,
            onPageChanged: (p) => context.read<TransectionBloc>().add(ChangePageRequested(p)),
          ),
        ),
      ),
    );
  }
}
