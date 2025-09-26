import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/clients_bloc/clients_bloc.dart';
import 'package:exchek/models/clients_models/clients_models.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/clients_bloc/clients_event.dart';
import 'package:exchek/widgets/common_widget/custom_dropdown.dart';
import 'package:intl/intl.dart'; // Added for formatting

class ReceivableCard extends StatelessWidget {
  const ReceivableCard({super.key});

  String _formatAmount(String currencyCode, double amount) {
    if (amount == 0) return "0.00";
    final formatter = NumberFormat.currency(symbol: '', decimalDigits: 2);
    return "$currencyCode ${formatter.format(amount)}";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final clientsState = context.watch<ClientsBloc>().state;
    final selectedCurrency = clientsState.selectedCurrencyCode;

    final currencies = clientsState.allReceivables.map((r) => r.currency).toList();

    // Handle empty allReceivables list gracefully
    final receivable = clientsState.allReceivables.firstWhere(
      (r) => r.currency == selectedCurrency,
      orElse: () => ReceivableModel(currency: selectedCurrency, total: 0, withdrawn: 0, processing: 0, pending: 0),
    );

    final totalReceivable = receivable.total;
    final withdrawn = receivable.withdrawn;
    final processing = receivable.processing;
    final pending = receivable.pending;

    final progress =
        (totalReceivable > 0) ? ((withdrawn + processing + pending) / totalReceivable).clamp(0.0, 1.0) : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: theme.customColors.darkGreyColor!.withAlpha(15), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      padding: EdgeInsets.all(ResponsiveHelper.getWidgetSize(context, mobile: 20, tablet: 22, desktop: 24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$selectedCurrency Receivable amount',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.customColors.lightGreyColor,
                        fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 14, desktop: 15),
                      ),
                    ),
                    buildSizedBoxH(8),
                    Text(
                      _formatAmount(selectedCurrency, totalReceivable),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.customColors.blackColor,
                        fontWeight: FontWeight.w400,
                        fontSize: ResponsiveHelper.getFontSize(context, mobile: 20, tablet: 32, desktop: 34),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
                decoration: BoxDecoration(
                  color: theme.customColors.lightBoxBGColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFDFDFDF)),
                ),
                child: Row(
                  children: [
                    Text(
                      'Currency: ',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.customColors.blackColor,
                        fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
                      ),
                    ),
                    buildSizedboxW(12.0),
                    CustomDropdown<String>(
                      items: currencies,
                      selectedItem: selectedCurrency,
                      onChanged: (value) {
                        context.read<ClientsBloc>().add(ClientCurrencyChanged(value));
                                            },
                      itemTextBuilder: (currency) => currency,
                      fontSize: ResponsiveHelper.getFontSize(context, mobile: 14.0, tablet: 15.0, desktop: 16.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
          buildSizedBoxH(30),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildSegmentedBar(context, withdrawn, processing, pending, totalReceivable),
          ),

          buildSizedBoxH(12),
          _kv(context, theme, 'Pending', _formatAmount(selectedCurrency, pending)),
          buildSizedBoxH(10),
          _kv(context, theme, 'Processing', _formatAmount(selectedCurrency, processing)),
          buildSizedBoxH(10),

          _kv(context, theme, 'Withdrawn', _formatAmount(selectedCurrency, withdrawn)),
          buildSizedBoxH(15),
        ],
      ),
    );
  }

  Widget _buildSegmentedBar(
    BuildContext context,
    double withdrawn,
    double processing,
    double pending,
    double totalReceivable,
  ) {
    final withdrawnFraction = totalReceivable > 0 ? withdrawn / totalReceivable : 0;
    final processingFraction = totalReceivable > 0 ? processing / totalReceivable : 0;
    final pendingFraction = totalReceivable > 0 ? pending / totalReceivable : 0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final barWidth = constraints.maxWidth;
        return Row(
          children: [
            Container(width: barWidth * pendingFraction, height: 24, color: const Color(0xFF33D68F)),
            Container(width: barWidth * processingFraction, height: 24, color: const Color(0xFF00CC73)),
            Container(width: barWidth * withdrawnFraction, height: 24, color: const Color(0xFF009957)),
          ],
        );
      },
    );
  }

  Widget _kv(BuildContext context, ThemeData theme, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w400,
            color: theme.customColors.lightGreyColor,
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 14, desktop: 15),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 18, tablet: 18, desktop: 20),
          ),
        ),
      ],
    );
  }
}
