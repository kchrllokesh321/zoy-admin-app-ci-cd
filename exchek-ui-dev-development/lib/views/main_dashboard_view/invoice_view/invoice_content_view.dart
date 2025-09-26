import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/models/invoice_models/invoice_model.dart';
import 'package:exchek/viewmodels/invoice_bloc/invoice_bloc.dart';
import 'package:exchek/viewmodels/invoice_bloc/invoice_event.dart';
import 'package:exchek/viewmodels/invoice_bloc/invoice_state.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/dashboard_bloc/dashboard_bloc.dart';
import 'package:exchek/views/main_dashboard_view/invoice_view/EditReceivableForm.dart';
import 'package:exchek/views/main_dashboard_view/invoice_view/invoice_detail_page.dart';
import 'package:exchek/views/main_dashboard_view/invoice_view/share_invoice_dailoug.dart';
import 'package:exchek/views/main_dashboard_view/invoice_view/upload_invoice.dart';
import 'package:exchek/widgets/common_widget/fixed_pagination.dart';
import 'package:exchek/widgets/common_widget/responsive_data_table.dart';
import 'package:exchek/widgets/custom_widget/custom_date_range_picker.dart';
import 'package:exchek/widgets/custom_widget/custom_search_filter.dart';

enum InvoiceAction { share, remindClient, editReceivable, deleteInvoice, cancelInvoice, editInvoice }

class ActionsMenu extends StatelessWidget {
  final InvoiceModel invoice;
  final void Function(BuildContext, InvoiceAction) onAction;

  const ActionsMenu({super.key, required this.invoice, required this.onAction});

  @override
  Widget build(BuildContext context) {
    final status = invoice.invoiceStatus;
    final bool isActive = status == InvoiceStatus.active;
    final bool isDraft = status == InvoiceStatus.draft;
    final bool hasBeenShared = invoice.hasBeenSharedInvoice;
    final int remindCount = invoice.countRemind ?? 0;

    final items = <PopupMenuEntry<InvoiceAction>>[];

    // Share: only if Active & not shared
    if (isActive && !hasBeenShared) {
      items.add(
        const PopupMenuItem(
          value: InvoiceAction.share,
          child: Row(children: [Icon(Icons.share, size: 20), SizedBox(width: 8), Text("Share Invoice")]),
        ),
      );
    }

    // Remind Client: only if Active & has been shared and reminders allowed
    if (invoice.hasBeenSharedInvoice) {
      items.add(
        const PopupMenuItem(
          value: InvoiceAction.remindClient,
          child: Row(children: [Icon(Icons.notifications_active, size: 20), SizedBox(width: 8), Text("Remind Client")]),
        ),
      );
    }

    // Edit Receivable: only active invoice
    if (isActive) {
      items.add(
        const PopupMenuItem(
          value: InvoiceAction.editReceivable,
          child: Row(children: [Icon(Icons.edit, size: 20), SizedBox(width: 8), Text("Edit Receivable Amount")]),
        ),
      );

      // Cancel Invoice
      items.add(
        const PopupMenuItem(
          value: InvoiceAction.cancelInvoice,
          child: Row(
            children: [Icon(Icons.cancel, size: 20, color: Colors.orange), SizedBox(width: 8), Text("Cancel Invoice")],
          ),
        ),
      );
    }

    // Delete & Edit Invoice: only if Draft
    if (isDraft) {
      items.add(
        const PopupMenuItem(
          value: InvoiceAction.deleteInvoice,
          child: Row(
            children: [Icon(Icons.delete, size: 20, color: Colors.red), SizedBox(width: 8), Text("Delete Invoice")],
          ),
        ),
      );
      items.add(
        const PopupMenuItem(
          value: InvoiceAction.editInvoice,
          child: Row(children: [Icon(Icons.edit_document, size: 20), SizedBox(width: 8), Text("Edit Invoice")]),
        ),
      );
    }

    return PopupMenuButton<InvoiceAction>(
      icon: const Icon(Icons.more_vert),
      tooltip: "More Actions",
      onSelected: (action) => onAction(context, action),
      itemBuilder: (context) => items,
    );
  }
}

extension IterableExtensions<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

class InvoiceContentView extends StatelessWidget {
  const InvoiceContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<InvoiceBloc, InvoiceState>(
      listener: (context, state) {
        if (state.hasError) {
          AppToast.show(message: state.error!, type: ToastificationType.error);
        } else if (!state.uploading && state.error == null && state.selectedFile == null && state.all.isNotEmpty) {
          // Optionally show upload success toast
          // AppToast.show(message: "Invoice uploaded successfully!", type: ToastificationType.success);
        }
      },
      child: EntranceFader(
        slideDirection: SlideDirection.bottomToTop,
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getWidgetSize(context, desktop: 42, tablet: 36, mobile: 30),
            vertical: ResponsiveHelper.getWidgetSize(context, desktop: 36, tablet: 30, mobile: 24),
          ),
          children: [
            _buildTopBar(context),
            buildSizedBoxH(20),
            if (context.watch<InvoiceBloc>().state.showFilters) _buildFilterChips(context),
            buildSizedBoxH(20),
            _buildInvoiceTable(context),
            buildSizedBoxH(20),
            _buildPagination(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPagination(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<InvoiceBloc>().state;

    final int startCount = (state.page - 1) * state.pageSize + 1;
    final int endCount = startCount + state.currentPageItems.length - 1;
    final int totalCount = state.filtered.length;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing $startCount - $endCount of $totalCount',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
          ),
          FixedPagination(
            currentPage: state.page,
            totalPages: state.totalPages,
            onPageChanged: (newPage) {
              context.read<InvoiceBloc>().add(InvoicePageChanged(newPage));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<InvoiceBloc>().state;
    final hasActiveFilters = state.activeFilters.isNotEmpty;

    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 455,
              child: Text('Invoices', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600)),
              // TextField(
              //   decoration: InputDecoration(
              //     hintText: Lang.of(context).lbl_global_search,
              //     hintStyle: theme.textTheme.bodyMedium?.copyWith(color: theme.customColors.greyTextColor),
              //     prefixIcon: Icon(Icons.search, color: theme.customColors.greyTextColor),
              //     filled: true,
              //     fillColor: theme.customColors.fillColor,
              //     contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(22),
              //       borderSide: BorderSide(color: theme.customColors.greyTextColor!.withAlpha(80)),
              //     ),
              //   ),
              //   onChanged: (value) => context.read<InvoiceBloc>().add(InvoiceSearchChanged(value)),
              // ),
            ),
          ),
        ),
        buildSizedboxW(12),
        hasActiveFilters ? _buildAppliedFiltersIndicator(context, state) : _buildFilterButton(context),
        buildSizedboxW(24),
        _buildReceivableButton(context),
      ],
    );
  }

  Widget _buildFilterButton(BuildContext context) => GestureDetector(
    onTap: () => context.read<InvoiceBloc>().add(ToggleFiltersVisibility()),
    child: CustomImageView(imagePath: Assets.images.svgs.icons.icFilter.path, height: 44),
  );

  Widget _buildReceivableButton(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 118),
    child: CustomElevatedButton(
      height: 44,
      borderRadius: 14,
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddInvoicePage()));
      },

      text: "Add Invoice",
    ),
  );

  Widget _buildFilterChips(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<InvoiceBloc>().state;

    // Parse active filters with case-insensitive trimming
    final activeClientFilters =
        state.activeFilters['clientName']?.toLowerCase().split(',').map((e) => e.trim()).toList() ?? [];
    final activeStatusFilters =
        state.activeFilters['status']?.toLowerCase().split(',').map((e) => e.trim()).toList() ?? [];
    final activeCurrencyFilters =
        state.activeFilters['currency']?.toLowerCase().split(',').map((e) => e.trim()).toList() ?? [];

    // Date range preset list with lowercase ids for consistent matching
    final dateRanges = [
      SelectionItem(id: 'all', title: 'All'),
      SelectionItem(id: 'last 7 days', title: 'Last 7 days'),
      SelectionItem(id: 'last 30 days', title: 'Last 30 days'),
      SelectionItem(id: 'last 3 months', title: 'Last 3 months'),
      SelectionItem(id: 'last 6 months', title: 'Last 6 months'),
    ];

    // Get the preset name from active filters, normalized to lowercase
    final activeDateRangeFilter = state.activeFilters['dateRange']?.toLowerCase();

    // Determine if dateRange preset selection matches any preset item
    final presetSelected = dateRanges.any((item) => item.id == activeDateRangeFilter);

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        CustomSearchFilter(
          searchHint: 'Search clients',
          popupWidth: 220,
          title: 'Client',
          optionTitle: 'Select Client',
          multiSelect: false,
          items:
              state.clients.map((c) {
                final isSelected = activeClientFilters.contains(c.name.toLowerCase());
                return SelectionItem(id: c.name, title: c.name, isSelected: isSelected);
              }).toList(),
          onSelectionChanged: (selected) {
            final filters = Map<String, String>.from(state.activeFilters);

            // Since single-select, find the one selected item
            final selectedItem = selected.firstWhereOrNull((item) => item.isSelected);

            if (selectedItem == null) {
              filters.remove('clientName');
            } else {
              filters['clientName'] = selectedItem.id;
            }

            context.read<InvoiceBloc>().add(InvoiceMultipleFiltersApplied(filters));
          },
        ),
        CustomSearchFilter(
          searchHint: 'Search status',
          popupWidth: 150,
          title: 'Status',
          optionTitle: 'Select Status',
          multiSelect: true,
          items: [
            SelectionItem(id: 'pending', title: 'Pending', isSelected: activeStatusFilters.contains('pending')),
            SelectionItem(id: 'paid', title: 'Paid', isSelected: activeStatusFilters.contains('paid')),
            SelectionItem(id: 'overdue', title: 'Overdue', isSelected: activeStatusFilters.contains('overdue')),
            SelectionItem(id: 'draft', title: 'Draft', isSelected: activeStatusFilters.contains('draft')),
            SelectionItem(id: 'active', title: 'Active', isSelected: activeStatusFilters.contains('active')),
            SelectionItem(id: 'failed', title: 'Failed', isSelected: activeStatusFilters.contains('failed')),
          ],
          onSelectionChanged: (selected) {
            final filters = Map<String, String>.from(state.activeFilters);
            final selectedValues = selected.where((e) => e.isSelected).map((e) => e.id).toList();

            if (selectedValues.isEmpty) {
              filters.remove('status');
            } else {
              filters['status'] = selectedValues.join(',');
            }

            context.read<InvoiceBloc>().add(InvoiceMultipleFiltersApplied(filters));
          },
        ),
        CustomSearchFilter(
          searchHint: 'Search currency',
          popupWidth: 150,
          title: 'Currency',
          optionTitle: 'Select Currency',
          items:
              state.currencyOptions.map((c) {
                final isSelected = activeCurrencyFilters.contains(c.currencyCode.toLowerCase());
                return SelectionItem(
                  id: c.currencyCode.toLowerCase(),
                  title: c.currencyCode,
                  isSelected: isSelected,
                );
              }).toList(),
          multiSelect: true,
          onSelectionChanged: (selected) {
            final filters = Map<String, String>.from(state.activeFilters);
            final selectedValues = selected.where((e) => e.isSelected).map((e) => e.id).toList();

            if (selectedValues.isEmpty) {
              filters.remove('currency');
            } else {
              filters['currency'] = selectedValues.join(',');
            }

            context.read<InvoiceBloc>().add(InvoiceMultipleFiltersApplied(filters));
          },
        ),

        // Date range picker with initial preset normalized, showing no preset if using custom dates
        CustomDatePicker(
          title: 'Select Date Range',
          hintText: 'Select Date Range',
          initialDateRange:
              presetSelected ? DateRange(presetName: state.activeFilters['dateRange']!.toLowerCase()) : null,
          allowSingleDate: false,
          onDateRangeChanged: (range) {
            final filters = Map<String, String>.from(state.activeFilters);
            final isCustomRange = range.presetName == null && range.startDate != null && range.endDate != null;

            if (isCustomRange) {
              filters['from_date'] = range.startDate!.toIso8601String().split('T').first;
              filters['to_date'] = range.endDate!.toIso8601String().split('T').first;
              filters.remove('dateRange');
            } else {
              if (range.presetName == null || range.presetName!.toLowerCase() == 'all') {
                filters.remove('dateRange');
                filters.remove('from_date');
                filters.remove('to_date');
              } else {
                filters['dateRange'] = range.presetName!.toLowerCase();
                filters.remove('from_date');
                filters.remove('to_date');
              }
            }

            context.read<InvoiceBloc>().add(InvoiceMultipleFiltersApplied(filters));
          },
        ),

        InkWell(
          onTap: () {
            final bloc = context.read<InvoiceBloc>();
            bloc.add(ClearAllFiltersRequested());
            bloc.add(InvoiceRefreshRequested());
          },
          child: Text(
            'Clear all',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.customColors.greentextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInvoiceTable(BuildContext context) {
    final state = context.watch<InvoiceBloc>().state;
    final theme = Theme.of(context);

    // Helper to build sortable columns
    DataColumn sortableColumn(String label, String sortKey) {
      final state = context.watch<InvoiceBloc>().state;
      final theme = Theme.of(context);

      final isSortedColumn = state.sortBy == sortKey;
      final sortAscending = state.sortAscending;

      return DataColumn(
        label: InkWell(
          onTap: () {
            final newAscending = isSortedColumn ? !sortAscending : true;
            context.read<InvoiceBloc>().add(InvoiceSortChanged(sortBy: sortKey, ascending: newAscending));
          },
          child: Row(
            children: [
              Text(label, style: theme.textTheme.bodyLarge),
              const SizedBox(width: 4),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: CustomImageView(
                      imagePath: Assets.images.svgs.icons.icSort.path,
                      height: 14,
                      width: 14,
                      // color: isSortedColumn && sortAscending ? theme.primaryColor : Colors.black45,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    // Non-sortable column helper
    DataColumn nonSortableColumn(String label) {
      return DataColumn(label: Text(label, style: theme.textTheme.bodyLarge));
    }

    final columns = [
      sortableColumn('Invoice date', 'invoiceDate'),
      nonSortableColumn('Invoice No.'),
      sortableColumn('Client Name', 'clientName'),

      sortableColumn('Receivable Amount', "receivableAmount"),
      sortableColumn('Pending Amount', "outstandingAmount"),

      nonSortableColumn('Status'),

      nonSortableColumn('Actions'),
    ];

    final rows =
        state.currentPageItems.map((invoice) {
          return DataRow(
            // onSelectChanged: (selected) {
            //   if (selected ?? false) {
            //     Navigator.of(context).push(MaterialPageRoute(builder: (_) => InvoiceDetailPage(invoice: invoice)));
            //   }
            // },
            cells: [
              DataCell(Text(invoice.invoiceDate.substring(0, 10))),
              DataCell(Text(invoice.invoiceNumber)),
              DataCell(Text(invoice.clientName)),
              DataCell(
                Text(
                  '${invoice.currency} ${double.tryParse(invoice.receivableAmount)?.toStringAsFixed(2) ?? invoice.receivableAmount}',
                ),
              ),
              DataCell(
                Text(
                  '${invoice.currency} ${double.tryParse(invoice.outstandingAmount)?.toStringAsFixed(2) ?? invoice.outstandingAmount}',
                ),
              ),

              DataCell(_buildStatusPill(context, invoice.status)),
              DataCell(
                ActionsMenu(invoice: invoice, onAction: (ctx, action) => _handleInvoiceAction(ctx, invoice, action)),
              ),
            ],
          );
        }).toList();

    if (state.loading) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Center(child: Padding(padding: const EdgeInsets.all(24), child: AppLoaderWidget())),
      );
    }

    if (state.all.isEmpty) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'No invoices yet. Upload your first invoice to start receiving payments',
              style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return DataTableTheme(
      data: DataTableThemeData(headingRowAlignment: MainAxisAlignment.spaceBetween),
      child: ResponsiveDataTable(
        columns: columns,
        rows: rows,
        minTableWidth: 1000,
        horizontalController: context.read<InvoiceBloc>().horizontalController,
      ),
    );
  }

  // Helper to build sortable DataColumn widget

  Widget _buildStatusPill(BuildContext context, String status) {
    final theme = Theme.of(context);
    Color bgColor;
    Color fgColor;

    switch (status.toLowerCase()) {
      case "active":
        bgColor = Colors.blue.withOpacity(0.15);
        fgColor = Colors.blue.shade700;
        break;
      case "cancelled":
        bgColor = Colors.grey.withOpacity(0.15);
        fgColor = Colors.grey.shade700;
        break;
      case "completed":
        bgColor = Colors.green.withOpacity(0.15);
        fgColor = Colors.green.shade700;
        break;
      case "draft":
        bgColor = Colors.blueGrey.withOpacity(0.15);
        fgColor = Colors.blueGrey.shade700;
        break;
      case "hold":
        bgColor = Colors.amber.withOpacity(0.15);
        fgColor = Colors.amber.shade700;
        break;
      case "input required":
        bgColor = Colors.orange.withOpacity(0.15);
        fgColor = Colors.orange.shade800;
        break;
      case "verified":
        bgColor = Colors.teal.withOpacity(0.15);
        fgColor = Colors.teal.shade700;
        break;
      case "paid":
        bgColor = Colors.green.withOpacity(0.1);
        fgColor = Colors.green.shade700;
        break;
      case "pending":
        bgColor = Colors.orange.withOpacity(0.1);
        fgColor = Colors.orange.shade700;
        break;
      case "overdue":
        bgColor = Colors.red.withOpacity(0.1);
        fgColor = Colors.red.shade700;
        break;
      case "failed":
        bgColor = Colors.deepOrange.withOpacity(0.1);
        fgColor = Colors.deepOrange.shade700;
        break;
      default:
        bgColor = Colors.grey.withOpacity(0.1);
        fgColor = Colors.grey.shade700;
    }

    return Container(
      height: 32,
      width: 110,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(5)),
      child: Center(
        child: Text(
          status,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelLarge?.copyWith(
            color: fgColor,
            fontSize: ResponsiveHelper.getFontSize(context, desktop: 16, mobile: 14, tablet: 15),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildAppliedFiltersIndicator(BuildContext context, InvoiceState state) {
    final theme = Theme.of(context);
    final activeFilters = state.activeFilters;

    if (activeFilters.isEmpty) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: () => context.read<InvoiceBloc>().add(ToggleFiltersVisibility()),
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

  void _handleShareInvoice(BuildContext context, InvoiceModel invoice) {
    final bloc = context.read<InvoiceBloc>();
    bloc.add(LoadShareContent(invoice.id));

    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<InvoiceBloc, InvoiceState>(
          builder: (context, state) {
            if (state.loadingShareContent) {
              return Center(child: CircularProgressIndicator());
            }
            // Only show dialog once data is loaded
            return ShareInvoiceDialog(
              invoice: invoice,
              initialTo: state.shareEmailTo,
              initialSubject: state.shareEmailSubject,
              initialMessage: state.shareEmailBody,
            );
          },
        );
      },
    );
  }

  void _handleInvoiceAction(BuildContext context, InvoiceModel invoice, InvoiceAction action) {
    final bloc = context.read<InvoiceBloc>();

    switch (action) {
      case InvoiceAction.share:
        _handleShareInvoice(context, invoice);

        break;
      case InvoiceAction.remindClient:
        showDialog(context: context, builder: (_) => RemindClientDialog(invoice: invoice));
        break;
      case InvoiceAction.editReceivable:
        showDialog(
          context: context,
          barrierDismissible: true,
          builder:
              (context) => Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                  child: EditReceivableForm(
                    initialAmount: invoice.receivableAmount.toString(),
                    invoiceId: invoice.id,
                    invoiceAmount: invoice.invoiceAmount.toString(),
                    currentReceivable: invoice.receivableAmount.toString(),
                    // amountWithdrawn: invoice.withdrawnAmount.toString() ?? "0",
                    amountWithdrawn: "0",

                    currency: invoice.currency,
                  ),
                ),
              ),
        );

        break;
      case InvoiceAction.cancelInvoice:
        // Dispatch CancelInvoiceRequested event
        bloc.add(CancelDeleteInvoiceRequested(invoice.id));
        break;
      case InvoiceAction.deleteInvoice:
        bloc.add(CancelDeleteInvoiceRequested(invoice.id));
        break;
      case InvoiceAction.editInvoice:
        context.read<InvoiceBloc>().add(SetInvoiceEditingMode(isEditing: true));
        context.read<InvoiceBloc>().add(SetInvoiceEditingMode(id: invoice.id, isEditing: true));
        context.read<InvoiceBloc>().add(LoadInvoiceForEditing(invoice));
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddInvoicePage()));
        // context.read<DashboardBloc>().add(
        //   DashboardDrawerIndexChanged(selectedDrawerOption: "Invoices", isOnAddInvoicePage: true),
        // );

        break;
    }
  }
}
