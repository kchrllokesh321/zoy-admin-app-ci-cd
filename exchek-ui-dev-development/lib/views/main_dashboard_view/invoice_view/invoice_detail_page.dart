import 'package:exchek/models/invoice_models/invoice_model.dart';
import 'package:flutter/material.dart';
import 'package:exchek/core/utils/exports.dart';

class InvoiceDetailPage extends StatefulWidget {
  final InvoiceModel invoice;

  const InvoiceDetailPage({required this.invoice, super.key});

  @override
  State<InvoiceDetailPage> createState() => _InvoiceDetailPageState();
}

class _InvoiceDetailPageState extends State<InvoiceDetailPage> {
  String _activeTab = 'transactions';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: Text(
          'Invoice Details',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.black),
        ),
        leading: BackButton(color: Colors.black),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: _handleMenuAction,
            itemBuilder:
                (_) => [
                  const PopupMenuItem(value: 'share', child: Text('Share Invoice')),
                  const PopupMenuItem(value: 'download', child: Text('Download PDF')),
                  if (widget.invoice.status.toLowerCase() == 'pending')
                    const PopupMenuItem(value: 'remind', child: Text('Send Reminder')),
                ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInvoiceHeader(context),
            buildSizedBoxH(32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: _ReceivableSummary(
                    invoiceAmount: double.tryParse(widget.invoice.invoiceAmount) ?? 0,
                    outstandingAmount: double.tryParse(widget.invoice.outstandingAmount) ?? 0,
                    withdrawnAmount: _getWithdrawnAmountDouble(),
                    onViewBreakup: () => _showBreakupDetails(context),
                  ),
                ),
                buildSizedboxW(24),
                Expanded(
                  flex: 4,
                  child: _QuickActionsColumn(
                    onShareInvoice: () => _shareInvoiceDetails(context),
                    onSharePayment: () => _sharePaymentLink(context),
                    onWithdraw: () => _withdraw(context),
                  ),
                ),
              ],
            ),
            buildSizedBoxH(32),
            _buildTabsSection(),
          ],
        ),
      ),
    );
  }

  double _getWithdrawnAmountDouble() {
    final invoiceAmount = double.tryParse(widget.invoice.invoiceAmount) ?? 0;
    final outstanding = double.tryParse(widget.invoice.outstandingAmount) ?? 0;
    final withdrawn = invoiceAmount - outstanding;
    return withdrawn >= 0 ? withdrawn : 0;
  }

  Widget _buildInvoiceHeader(BuildContext context) {
    final theme = Theme.of(context);
    final invoice = widget.invoice;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Invoice No', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    SizedBox(width: 8),
                    Text(
                      invoice.invoiceNumber,
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: _showInvoiceDetails,
                      child: Text('View', style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
                    ),
                  ],
                ),
                buildSizedBoxH(32),
                _labelValueRow('Client Name', invoice.clientName),
                buildSizedBoxH(12),
                _labelValueRow('Due On', invoice.dueDate),
                buildSizedBoxH(12),
                _labelValueRow('Purpose Code', invoice.purposeCode),
              ],
            ),
          ),
          SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(alignment: Alignment.topRight, child: _buildStatusPill()),
                buildSizedBoxH(32),
                _labelValueRow('Invoice Date', invoice.invoiceDate),
                buildSizedBoxH(12),
                _labelValueRow('Created Date', invoice.createdAt),
                buildSizedBoxH(12),
                _labelValueRow('Description', invoice.internalNotes ?? '-'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _labelValueRow(String label, String value) {
    final theme = Theme.of(context);
    return Row(
      children: [
        SizedBox(width: 125, child: Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey))),
        Expanded(child: Text(value, style: theme.textTheme.bodyLarge)),
      ],
    );
  }

  Widget _buildStatusPill() {
    final status = widget.invoice.status.toLowerCase();
    Color bgColor;
    Color textColor;
    String text;

    switch (status) {
      case 'paid':
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        text = 'Paid';
        break;
      case 'overdue':
        bgColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        text = 'Overdue';
        break;
      default:
        bgColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        text = 'Pending';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTabsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _tabButton('transactions', 'Transactions'),
            buildSizedboxW(24),
            _tabButton('payouts', 'Associated Payouts'),
          ],
        ),
        buildSizedBoxH(24),
        if (_activeTab == 'transactions') _buildTransactionsTable(),
        if (_activeTab == 'payouts') _buildPayoutsPlaceholder(),
      ],
    );
  }

  Widget _tabButton(String tab, String label) {
    final isActive = _activeTab == tab;
    return TextButton(
      onPressed: () {
        setState(() {
          _activeTab = tab;
        });
      },
      style: TextButton.styleFrom(foregroundColor: isActive ? Colors.blue : Colors.grey),
      child: Text(label, style: TextStyle(fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
    );
  }

  Widget _buildTransactionsTable() {
    // Sample static data, replace with actual transaction data
    final transactions = [
      {'date': '2023-08-01', 'type': 'Credit', 'withdrawn': '100', 'fees': '5', 'net': '95'},
      {'date': '2023-08-05', 'type': 'Debit', 'withdrawn': '200', 'fees': '10', 'net': '190'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Table(
        border: TableBorder(horizontalInside: BorderSide(color: Colors.grey.shade300)),
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(3),
          2: FlexColumnWidth(2),
          3: FlexColumnWidth(2),
          4: FlexColumnWidth(2),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(color: Colors.blue.shade50),
            children: [
              _tableCellHeader('Date'),
              _tableCellHeader('Type'),
              _tableCellHeader('Withdrawn'),
              _tableCellHeader('Fees'),
              _tableCellHeader('Net'),
            ],
          ),
          ...transactions.map((tr) {
            return TableRow(
              children: [
                _tableCell(tr['date']!),
                _tableCell(tr['type']!),
                _tableCell(tr['withdrawn']!),
                _tableCell(tr['fees']!),
                _tableCell(tr['net']!),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _tableCellHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700])),
    );
  }

  Widget _tableCell(String text) {
    return Padding(padding: const EdgeInsets.all(12), child: Text(text));
  }

  Widget _buildPayoutsPlaceholder() {
    return Container(height: 100, alignment: Alignment.center, child: Text('Associated payouts will be listed here.'));
  }

  void _showInvoiceDetails() {
    AppToast.show(message: 'Opening detailed invoice view...', type: ToastificationType.info);
  }

  void _showBreakupDetails(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Payment Breakup'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Invoice Amount: \$${widget.invoice.invoiceAmount}'),
                Text('Receivable Amount: \$${widget.invoice.receivableAmount}'),
                Text('Outstanding Amount: \$${widget.invoice.outstandingAmount}'),
                Text('Withdrawn: \$${_getWithdrawnAmountDouble().toStringAsFixed(2)}'),
              ],
            ),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Close'))],
          ),
    );
  }

  void _shareInvoiceDetails(BuildContext context) {
    AppToast.show(message: 'Sharing invoice details...', type: ToastificationType.info);
  }

  void _sharePaymentLink(BuildContext context) {
    AppToast.show(message: 'Sharing payment link...', type: ToastificationType.info);
  }

  void _withdraw(BuildContext context) {
    AppToast.show(message: 'Initiating withdrawal...', type: ToastificationType.info);
  }

  void _downloadInvoice(BuildContext context) {
    AppToast.show(message: 'Downloading invoice...', type: ToastificationType.info);
  }

  void _handleMenuAction(String value) {
    switch (value) {
      case 'share':
        _shareInvoiceDetails(context);
        break;
      case 'download':
        _downloadInvoice(context);
        break;
      case 'remind':
        AppToast.show(message: 'Reminder sent!', type: ToastificationType.success);
        break;
    }
  }
}

class _ReceivableSummary extends StatelessWidget {
  final double invoiceAmount;
  final double outstandingAmount;
  final double withdrawnAmount;
  final VoidCallback onViewBreakup;

  const _ReceivableSummary({
    super.key,
    required this.invoiceAmount,
    required this.outstandingAmount,
    required this.withdrawnAmount,
    required this.onViewBreakup,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (invoiceAmount == 0) ? 0.0 : (withdrawnAmount / invoiceAmount);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Color(0x1A191C32), blurRadius: 20, offset: Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Receivable Summary',
                style: TextStyle(fontSize: 16, color: Color(0xFF7E8B9B), fontWeight: FontWeight.w500),
              ),
              GestureDetector(
                onTap: onViewBreakup,
                child: const Text(
                  'View Breakup',
                  style: TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '\$${withdrawnAmount.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: Colors.black),
          ),
          const SizedBox(height: 16),
          // Progress Bar
          Container(
            height: 16,
            width: double.infinity,
            decoration: BoxDecoration(color: const Color(0xFFE8E9F1), borderRadius: BorderRadius.circular(12)),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _AmountRow(label: 'Amount Pending', value: '\$${outstandingAmount.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _AmountRow(label: 'Withdrawn', value: '\$${withdrawnAmount.toStringAsFixed(2)}'),
        ],
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  final String label;
  final String value;

  const _AmountRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Color(0xFF666666), fontWeight: FontWeight.w400)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
      ],
    );
  }
}

class _QuickActionsColumn extends StatelessWidget {
  final VoidCallback onShareInvoice;
  final VoidCallback onSharePayment;
  final VoidCallback onWithdraw;

  const _QuickActionsColumn({
    super.key,
    required this.onShareInvoice,
    required this.onSharePayment,
    required this.onWithdraw,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Color(0x1A191C32), blurRadius: 20, offset: Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quick actions",
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: const Color(0xFF7A8C99), fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          _QuickActionButton(
            label: "Share Invoice details",
            iconLabel: "S",
            iconColor: Colors.white,
            iconBackgroundColor: const Color(0xFF3F8DE4),
            onTap: onShareInvoice,
          ),
          const SizedBox(height: 14),
          _QuickActionButton(
            label: "Share Payment Link",
            iconLabel: "P",
            iconColor: Colors.white,
            iconBackgroundColor: const Color(0xFF3F8DE4),
            onTap: onSharePayment,
          ),
          const SizedBox(height: 14),
          _QuickActionButton(
            label: "Withdraw",
            iconLabel: "W",
            iconColor: Colors.black,
            iconBackgroundColor: const Color(0xFFFDD835),
            onTap: onWithdraw,
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String label;
  final String iconLabel;
  final Color iconBackgroundColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _QuickActionButton({
    super.key,
    required this.label,
    required this.iconLabel,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: iconBackgroundColor, borderRadius: BorderRadius.circular(16)),
              alignment: Alignment.center,
              child: Text(iconLabel, style: TextStyle(color: iconColor, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
            ),
            const Icon(Icons.chevron_right, size: 22, color: Color(0xFF7A8C99)),
          ],
        ),
      ),
    );
  }
}
