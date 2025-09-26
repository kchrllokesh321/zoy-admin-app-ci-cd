import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/clients_bloc/clients_bloc.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/clients_bloc/clients_event.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/clients_bloc/clients_state.dart';
import 'package:exchek/widgets/common_widget/fixed_pagination.dart';
import 'package:exchek/views/main_dashboard_view/clients_view/client_view_details.dart';
import 'package:exchek/views/main_dashboard_view/clients_view/add_client_view.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/clients_bloc/clients_state.dart' as clients_state;

final List<int> colorList = [0xFFC7E9F9, 0xFFCFF3AF, 0xFFFFF8C5, 0xFFFFD9D9];

class ClientsContentView extends StatelessWidget {
  const ClientsContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientsBloc, ClientsState>(
      builder: (context, state) {
        final hasSelectedClient = state.clientDetail != null && state.selectedClient != null;
        return EntranceFader(
          slideDirection: SlideDirection.bottomToTop,
          child: hasSelectedClient ? const ClientViewDetailsScreen() : _buildClientsListView(context, state),
        );
      },
    );
  }

  Widget _buildClientsListView(BuildContext context, ClientsState state) {
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getWidgetSize(context, desktop: 35, tablet: 30, mobile: 24),
        vertical: ResponsiveHelper.getWidgetSize(context, desktop: 16, tablet: 18, mobile: 18),
      ),
      children: [
        _buildHeader(context),
        buildSizedBoxH(28),
        if (state.loading)
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: ResponsiveHelper.getScreenHeight(context) * 0.3),
              child: const AppLoaderWidget(),
            ),
          )
        else ...[
          if ((state.searchQuery.isNotEmpty ? state.filteredClients : state.allClients).isEmpty)
            _buildEmptyClientView(context)
          else ...[
            _buildTable(context),
            buildSizedBoxH(20),
            _buildPagination(context),
          ],
        ],
      ],
    );
  }

  Widget _buildEmptyClientView(BuildContext context) {
    final theme = Theme.of(context);
    final height = ResponsiveHelper.getScreenHeight(context) * 0.3;
    return Center(
      child: Column(
        children: [
          buildSizedBoxH(height),
          CustomImageView(
            imagePath: Assets.images.svgs.dashboard.icClients.path,
            height: 30,
            width: 30,
            color: theme.customColors.lightGreyColor,
          ),
          buildSizedBoxH(10),
          Text(
            'No clients found',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.customColors.lightGreyColor,
              fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 16, desktop: 18),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
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
                hintLabel: 'Search by client name...',
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
                onChanged: (v) => context.read<ClientsBloc>().add(SearchQueryChanged(v)),
              ),
            ),
          ),
        ),
        buildSizedboxW(16),
        _buildAddClientButton(context),
      ],
    );
  }

  Widget _buildTable(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<ClientsBloc>().state;
    final items = state.currentPageItems;
    final bloc = context.read<ClientsBloc>();

    const double minTableWidth = 1000;

    return LayoutBuilder(
      builder: (context, constraints) {
        final tableWidth = constraints.maxWidth < minTableWidth ? minTableWidth : constraints.maxWidth;
        return Scrollbar(
          controller: bloc.horizontalController,
          thumbVisibility: true,
          trackVisibility: true,
          interactive: true,
          child: SingleChildScrollView(
            controller: bloc.horizontalController,
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: tableWidth,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 24),
                    decoration: BoxDecoration(
                      color: theme.customColors.filtercheckboxcolor,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Row(
                      children: [
                        Expanded(flex: 2, child: _buildTableHeaderLabel(context, 'Client Name')),
                        const Expanded(child: SizedBox()),
                        Expanded(flex: 2, child: _buildTableHeaderLabel(context, 'No. of Invoices')),
                        Expanded(flex: 2, child: _buildTableHeaderLabel(context, 'Receivable Amount')),
                        Expanded(flex: 2, child: _buildTableHeaderLabel(context, 'Amount Pending')),
                      ],
                    ),
                  ),
                  buildSizedBoxH(12),
                  ...items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final row = entry.value;
                    // You can get color from colorList if needed
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: theme.customColors.fillColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () => bloc.add(ClientRowTapped(row)),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 20),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      row.name ?? '',
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        color: theme.customColors.blackColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    buildSizedboxW(4),
                                    Text(
                                    clients_state.ClientsStateHelpers(state).getClientTypeName(row.clientType ?? ''),
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.customColors.drawerIconColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    height: 60,
                                    width: 1,
                                    color: const Color(0xFFE6E6E6),
                                    margin: const EdgeInsets.symmetric(horizontal: 20),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total: ${row.numberOfInvoices ?? 0}',
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.customColors.blackColor,
                                        fontSize: ResponsiveHelper.getFontSize(
                                          context,
                                          mobile: 14,
                                          tablet: 15,
                                          desktop: 16,
                                        ),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    buildSizedboxW(4),
                                    Text(
                                      'Active: ${row.activeInvoices ?? 0}',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.customColors.blackColor,
                                        fontSize: ResponsiveHelper.getFontSize(
                                          context,
                                          mobile: 14,
                                          tablet: 15,
                                          desktop: 16,
                                        ),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: _buildCurrencyTags(context, row.receivableAmount, isReceivable: true),
                              ),
                              Expanded(
                                flex: 2,
                                child: _buildCurrencyTags(context, row.pendingAmount, isReceivable: false),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTableHeaderLabel(BuildContext context, String label) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.customColors.blackColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        buildSizedboxW(4),
        CustomImageView(
          imagePath: Assets.images.svgs.icons.icSort.path,
          height: 14,
          width: 14,
          onTap: () {
            // TODO: Implement sorting logic on tapping headers if needed
          },
        ),
      ],
    );
  }

  Widget _buildCurrencyTags(BuildContext context, String? currencies, {required bool isReceivable}) {
    final theme = Theme.of(context);
    if (currencies == null || currencies.trim().isEmpty) {
      return Text('-', style: theme.textTheme.bodySmall?.copyWith(fontSize: 24, fontWeight: FontWeight.w500));
    }

    final currencyList = currencies.split(',').map((e) => e.trim()).toList();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          currencyList.map((currency) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isReceivable ? const Color(0xFFF5F5F5) : const Color(0xFFFFE6E6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                currency,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: theme.customColors.blackColor,
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildPagination(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<ClientsBloc>().state;
    final totalClients = state.searchQuery.isNotEmpty ? state.filteredClients.length : state.allClients.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Showing ${(state.page - 1) * state.pageSize + 1}-${((state.page - 1) * state.pageSize + state.currentPageItems.length)} of $totalClients clients',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.customColors.paginationTextColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        buildSizedboxW(16),
        _buildFixedPager(context, state),
      ],
    );
  }

  Widget _buildAddClientButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: CustomElevatedButton(
        width: 135,
        height: 44,
        borderRadius: 14,
        iconSpacing: 16,
        onPressed: () async {
          final saved = await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (context) => const AddClientDialog(),
          );
          if (saved == true && context.mounted) {
            context.read<ClientsBloc>().add(LoadClients());
          }
           context.read<ClientsBloc>().add(ResetCreateClientForm());
        },
        text: "Add Client",
        leftIcon: Icon(Icons.add, color: Theme.of(context).customColors.fillColor),
      ),
    );
  }

  Widget _buildFixedPager(BuildContext context, ClientsState state) {
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: FittedBox(
          child: FixedPagination(
            currentPage: state.page,
            totalPages: state.totalPages,
            onPageChanged: (p) => context.read<ClientsBloc>().add(ClientPageChanged(p)),
          ),
        ),
      ),
    );
  }
}
