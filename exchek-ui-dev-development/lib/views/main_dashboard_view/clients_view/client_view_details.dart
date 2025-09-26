import 'package:exchek/viewmodels/invoice_bloc/invoice_state.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/clients_bloc/clients_bloc.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/clients_bloc/clients_event.dart';
import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/models/invoice_models/invoice_model.dart' as invoice_models;
import 'package:exchek/viewmodels/invoice_bloc/invoice_bloc.dart';
import 'package:exchek/viewmodels/invoice_bloc/invoice_event.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/dashboard_bloc/dashboard_bloc.dart';
import 'package:exchek/widgets/common_widget/responsive_data_table.dart';
import 'package:exchek/widgets/dashboard_widget/client_detail_card.dart';
import 'package:exchek/widgets/dashboard_widget/received_amount_card.dart';
import 'package:exchek/widgets/dashboard_widget/common_action_card.dart';
import 'package:exchek/views/main_dashboard_view/invoice_view/EditReceivableForm.dart';
import 'package:exchek/views/main_dashboard_view/invoice_view/share_invoice_dailoug.dart';
import 'package:exchek/views/main_dashboard_view/invoice_view/invoice_content_view.dart';
import 'package:exchek/views/main_dashboard_view/invoice_view/upload_invoice.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/clients_bloc/clients_state.dart' as clients_state;
import 'package:exchek/models/clients_models/clients_models.dart';


class ClientViewDetailsScreen extends StatelessWidget {
  const ClientViewDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final invoiceState = context.watch<InvoiceBloc>().state;
    final clientState = context.watch<ClientsBloc>().state;
    final clientDetail = clientState.clientDetail;

    if (clientDetail == null) return const SizedBox.shrink();

    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getWidgetSize(context, desktop: 35, tablet: 30, mobile: 24),
        vertical: ResponsiveHelper.getWidgetSize(context, desktop: 16, tablet: 18, mobile: 18),
      ),
      children: [
        _buildHeader(context),
        buildSizedBoxH(14),
        _buildClientDetailCard(context),
        buildSizedBoxH(24),
        _buildReceivableAndQuickActions(context),
        buildSizedBoxH(24),
        _buildTopBar(context),
        buildSizedBoxH(20),
        // if (invoiceState.showFilters) _buildFilterChips(context),
        buildSizedBoxH(20),
        _buildInvoiceTable(context),
        buildSizedBoxH(20),
        // _buildPagination(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        InkWell(
          onTap: () => context.read<ClientsBloc>().add(ClearSelectedClient()),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(shape: BoxShape.circle, color: theme.customColors.fillColor),
            alignment: Alignment.center,
            child: CustomImageView(
              imagePath: Assets.images.svgs.icons.icBack.path,
              onTap: () => context.read<ClientsBloc>().add(ClearSelectedClient()),
            ),
          ),
        ),
        buildSizedboxW(20),
        Expanded(
          child: Text(
            "Client Details",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.customColors.blackColor,
              fontSize: ResponsiveHelper.getWidgetSize(context, desktop: 22, tablet: 20, mobile: 18),
            ),
          ),
        ),
      ],
    );
  }


 Widget _buildClientDetailCard(BuildContext context ) {
     final clientState = context.watch<ClientsBloc>().state;
    final detail = clientState.clientDetail ??  ClientDetailModel()  ;
    final combinedAddress = [detail.addressLine1, detail.addressLine2 ?? '',detail.city,detail.state].where((s) => s!.isNotEmpty).join(", ");
  return ClientDetailCard(
    name: detail.name ?? '',
    isActive: false , //detail.status == 'Active' ,
    clientType: clients_state.ClientsStateHelpers(clientState).getClientTypeName(detail.clientType ?? ''),
    email: detail.email ?? '',
    dateAdded: _formatDate(detail.dateAdded ?? ''),
    country: clients_state.ClientsStateHelpers(clientState).getCountryName(detail.country ?? ''),
    address: combinedAddress,
    addressLine1:detail.addressLine1 ?? '',
    addressLine2:detail.addressLine2 ?? '',
    isLoadingEmailUpdate: false,
    isLoadingAddressUpdate: false,

    onEmailUpdate: (newEmail ) async  {
      // Call your update email API here
        Logger.info('newAddress1,newAddress2 >>>> $newEmail');
         await Future.delayed(Duration(seconds: 5));
    if(detail.clientId !=null){
      _updateClientDetails(context,detail.clientId ?? '', newEmail,"Email");
     }else{
// user id is not found
     }
    },
    onAddressUpdate: (newAddress1,newAddress2) async {
        Logger.info('newAddress1,newAddress2 >>>> $newAddress1 $newAddress2');
         await Future.delayed(Duration(seconds: 5));
      // Call your update address API here
      if(detail.clientId !=null){
      _updateClientDetails(context,detail.clientId ?? '', newAddress1,"Address");
      }else{
 // user id is not found
     }
    },
    statusUpdate:(isActive){
      Logger.info('isActive >>>> $isActive');
    }


  );
}

// Helper method to format date
String _formatDate(String dateString) {
  if (dateString.isEmpty) return '';
  try {
    final date = DateTime.parse(dateString);
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  } catch (e) {
    return dateString; // Return original if parsing fails
  }
}

// API call methods
void _updateClientDetails(BuildContext context,String clientId, String newValue,String updateType) {
  // Add your email update event to bloc
  Logger.info("clientId, newValue ,updateType $clientId  :::: $newValue :::: $updateType");
   final Map<String, dynamic> data = {
        // 'client_name': emit.clientDetail.clientName,
        // 'email': email,
        // 'client_type': clientType,
        // 'address_line1': addressLine1,
        // if (addressLine2 != null && addressLine2.isNotEmpty) 'address_line2': addressLine2,
        // if (state != null && state.isNotEmpty) 'state': state,
        // if (city != null && city.isNotEmpty) 'city': city,
        // if (postalCode != null && postalCode.isNotEmpty) 'postal_code': postalCode,
        // 'country': country,
        // 'currency': currency,
        // if (notes != null && notes.isNotEmpty) 'notes': notes,
      };
  context.read<ClientsBloc>().add(
    UpdateClientDetails(data),
  );
}


  // Added Receivable Card + Quick Actions Card
  Widget _buildReceivableAndQuickActions(BuildContext context) {
    final isWideScreen = ResponsiveHelper.getScreenWidth(context) > 950;
    final receivableCard = const ReceivableCard();
    final quickActionsCard = _buildQuickActionsCard(context);

    if (isWideScreen) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: receivableCard),
          buildSizedboxW(16),
          Expanded(flex: 2, child: quickActionsCard),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [receivableCard, buildSizedBoxH(16), quickActionsCard],
      );
    }
  }

  Widget _buildQuickActionsCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.all(ResponsiveHelper.getWidgetSize(context, mobile: 20, tablet: 22, desktop: 24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick actions',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 14, desktop: 15),
            ),
          ),
          buildSizedBoxH(10),
          CommonActionCard(
            bgColor: const Color(0xFFFFF8C5),
            iconBgColor: const Color(0xFFFFE100),
            iconSize: 16,
            horizontalPadding: ResponsiveHelper.getWidgetSize(context, desktop: 24, tablet: 22, mobile: 20),
            verticalPadding: ResponsiveHelper.getWidgetSize(context, desktop: 16, tablet: 14, mobile: 12),
            iconBGSize: ResponsiveHelper.getWidgetHeight(context, desktop: 40, tablet: 35, mobile: 30),
            text: "Add invoice",
            iconPath: Assets.images.svgs.dashboard.icS.path,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddInvoicePage()));
            },
          ),
          buildSizedBoxH(10),
          CommonActionCard(
            bgColor: const Color(0xFFC7E9F9),
            iconBgColor: Theme.of(context).customColors.blackColor!.withAlpha(50),
            iconSize: 16,
            horizontalPadding: ResponsiveHelper.getWidgetSize(context, desktop: 24, tablet: 22, mobile: 20),
            verticalPadding: ResponsiveHelper.getWidgetSize(context, desktop: 16, tablet: 14, mobile: 12),
            iconBGSize: ResponsiveHelper.getWidgetHeight(context, desktop: 40, tablet: 35, mobile: 30),
            text: "Withdraw",
            iconPath: Assets.images.svgs.dashboard.icS.path,
            onTap: () {
              // Implement withdraw action
            },
          ),
          buildSizedBoxH(10),
          CommonActionCard(
            bgColor: const Color(0xFFC7E9F9),
            iconBgColor: Theme.of(context).customColors.blackColor!.withAlpha(50),
            iconSize: 16,
            horizontalPadding: ResponsiveHelper.getWidgetSize(context, desktop: 24, tablet: 22, mobile: 20),
            verticalPadding: ResponsiveHelper.getWidgetSize(context, desktop: 16, tablet: 14, mobile: 12),
            iconBGSize: ResponsiveHelper.getWidgetHeight(context, desktop: 40, tablet: 35, mobile: 30),
            text: "Share bank details",
            iconPath: Assets.images.svgs.dashboard.icS.path,
            onTap: () {
              // Implement share bank details action
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final theme = Theme.of(context);
    // final invoiceState = context.watch<InvoiceBloc>().state;
    // final hasActiveFilters = invoiceState.activeFilters.isNotEmpty;
    return Row(
      children: [
        Expanded(
          child: Text(
            "Invoices",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.customColors.blackColor,
              fontSize: ResponsiveHelper.getFontSize(context, desktop: 26, mobile: 24, tablet: 22),
            ),
          ),
        ),
        buildSizedboxW(12),
        // hasActiveFilters ? _buildAppliedFiltersIndicator(context) : _buildFilterIconButton(context),
        _showAllButton(context),
      ],
    );
  }

  Widget _showAllButton(BuildContext context) {
    final clientState = context.watch<ClientsBloc>().state;
    final clientDetail = clientState.clientDetail;
    if (clientDetail == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: CustomImageView(
        imagePath: Assets.images.svgs.icons.icView.path,
        height: 44,
        onTap: () {
          context.read<InvoiceBloc>().add(InvoiceMultipleFiltersApplied({'clientName': clientDetail.name ?? ''}));
          context.read<DashboardBloc>().add(DashboardDrawerIndexChanged(selectedDrawerOption: "Invoices"));
        },
      ),
    );
  }

  Widget _buildInvoiceTable(BuildContext context) {
  final invoiceState = context.watch<InvoiceBloc>().state;
  final clientState = context.watch<ClientsBloc>().state;
  final theme = Theme.of(context);

  final clientDetail = clientState.clientDetail;

  // Filter invoices based on the selected client's clientId
  final filteredInvoices = invoiceState.currentPageItems
      .where((invoice) => invoice.clientName == clientDetail?.name)
      .toList();

  final columns = [
    DataColumn(label: Text('Invoice date', style: theme.textTheme.bodyLarge)),
    DataColumn(label: Text('Invoice No.', style: theme.textTheme.bodyLarge)),
    DataColumn(label: Text('Client Name', style: theme.textTheme.bodyLarge)),
    DataColumn(label: Text('Receivable Amount', style: theme.textTheme.bodyLarge)),
    DataColumn(label: Text('Pending Amount', style: theme.textTheme.bodyLarge)),
    DataColumn(label: Text('Status', style: theme.textTheme.bodyLarge)),
    DataColumn(label: Text('Actions', style: theme.textTheme.bodyLarge)),
  ];

  final rows = filteredInvoices.take(5).map((invoice) {
    return DataRow(
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
          ActionsMenu(
            invoice: invoice,
            onAction: (ctx, action) => _handleInvoiceAction(ctx, invoice, action),
          ),
        ),
      ],
    );
  }).toList();

  if (invoiceState.loading) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Center(child: Padding(padding: const EdgeInsets.all(24), child: AppLoaderWidget())),
    );
  }

  if (filteredInvoices.isEmpty) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'No invoices yet for this client.',
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

  void _handleInvoiceAction(BuildContext context, invoice_models.InvoiceModel invoice, InvoiceAction action) {
    final bloc = context.read<InvoiceBloc>();

    switch (action) {
      case InvoiceAction.share:
        bloc.add(LoadShareContent(invoice.id));
        showDialog(
          context: context,
          builder: (context) {
            return BlocBuilder<InvoiceBloc, InvoiceState>(
              builder: (context, state) {
                if (state.loadingShareContent) {
                  return const Center(child: CircularProgressIndicator());
                }
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
                    amountWithdrawn: "0",
                    currency: invoice.currency,
                  ),
                ),
              ),
        );
        break;

      case InvoiceAction.cancelInvoice:
        bloc.add(CancelDeleteInvoiceRequested(invoice.id));
        break;

      case InvoiceAction.deleteInvoice:
        bloc.add(CancelDeleteInvoiceRequested(invoice.id));
        break;

      case InvoiceAction.editInvoice:
        bloc.add(SetInvoiceEditingMode(isEditing: true));
        bloc.add(SetInvoiceEditingMode(id: invoice.id, isEditing: true));
        bloc.add(LoadInvoiceForEditing(invoice));
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddInvoicePage()));
        break;
    }
  }
}
