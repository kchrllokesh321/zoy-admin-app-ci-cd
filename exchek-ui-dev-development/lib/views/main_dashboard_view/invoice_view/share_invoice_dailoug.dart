import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/models/invoice_models/invoice_model.dart';
import 'package:exchek/viewmodels/invoice_bloc/invoice_bloc.dart';
import 'package:exchek/viewmodels/invoice_bloc/invoice_event.dart';

class ShareInvoiceDialog extends StatefulWidget {
  final InvoiceModel invoice;
  final String initialTo;
  final String initialSubject;
  final String initialMessage;

  const ShareInvoiceDialog({
    super.key,
    required this.invoice,
    required this.initialTo,
    required this.initialSubject,
    required this.initialMessage,
  });

  @override
  _ShareInvoiceDialogState createState() => _ShareInvoiceDialogState();
}

class _ShareInvoiceDialogState extends State<ShareInvoiceDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _toController;
  late TextEditingController _ccController;
  late TextEditingController _bccController;
  late TextEditingController _subjectController;
  late TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _toController = TextEditingController(text: widget.initialTo);
    _ccController = TextEditingController();
    _bccController = TextEditingController();
    _subjectController = TextEditingController(text: widget.initialSubject);
    _messageController = TextEditingController(text: _htmlToPlainText(widget.initialMessage));
  }

  String _htmlToPlainText(String htmlString) {
    return htmlString
        .replaceAll(RegExp(r'<br\s*\/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<\/p>', caseSensitive: false), '\n\n')
        .replaceAll(RegExp(r'<.*?>'), '')
        .trim();
  }

  @override
  void dispose() {
    _toController.dispose();
    _ccController.dispose();
    _bccController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _sendEmail() {
    if (!_formKey.currentState!.validate()) return;

    final bloc = context.read<InvoiceBloc>();
    bloc.add(
      InvoiceShareRequested(
        invoiceId: widget.invoice.id,
        to: _toController.text.trim(),
        cc: _ccController.text.trim(),
        bcc: _bccController.text.trim(),
        subject: _subjectController.text.trim(),
        message: _messageController.text.trim(),
      ),
    );
    Navigator.of(context).pop();
  }

  String? _validateEmailRequired(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(value.trim()) ? null : 'Enter a valid email';
  }

  String? _validateEmailOptional(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(value.trim()) ? null : 'Enter a valid email';
  }

  Widget leftAlignedLabel(String text) {
    return Align(alignment: Alignment.centerLeft, child: Text(text, style: Theme.of(context).textTheme.bodyMedium));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Share Invoice ${widget.invoice.invoiceNumber}'),
      content: SizedBox(
        width: ResponsiveHelper.isDesktop(context) ? 500 : double.maxFinite,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                leftAlignedLabel("To *"),
                CustomTextInputField(
                  context: context,
                  controller: _toController,
                  type: InputType.email,
                  validator: _validateEmailRequired,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 12),
                leftAlignedLabel("Cc"),
                CustomTextInputField(
                  context: context,
                  controller: _ccController,
                  type: InputType.email,
                  validator: _validateEmailOptional,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 12),
                leftAlignedLabel("Bcc"),
                CustomTextInputField(
                  context: context,
                  controller: _bccController,
                  type: InputType.email,
                  validator: _validateEmailOptional,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 12),
                leftAlignedLabel("Subject *"),
                CustomTextInputField(
                  context: context,
                  controller: _subjectController,
                  type: InputType.text,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Subject is required' : null,
                  enabled: false,
                ),
                const SizedBox(height: 12),
                leftAlignedLabel("Message"),
                TextFormField(
                  controller: _messageController,
                  maxLines: null,
                  minLines: 4,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(hintText: 'Message', border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomElevatedButton(
              text: 'Cancel',
              onPressed: () => Navigator.of(context).pop(),
              isDisabled: false,
              isLoading: false,
              width: 100,
            ),
            const SizedBox(width: 12),
            CustomElevatedButton(
              text: 'Send Email',
              onPressed: _sendEmail,
              isDisabled: false,
              isLoading: false,
              width: 120,
            ),
          ],
        ),
      ],
    );
  }
}

class RemindClientDialog extends StatelessWidget {
  final InvoiceModel invoice;

  const RemindClientDialog({super.key, required this.invoice});

  void _sendReminder(BuildContext context) {
    final bloc = context.read<InvoiceBloc>();
    bloc.add(RemindInvoiceRequested(invoice.id));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Send Reminder for ${invoice.invoiceNumber}'),
      content: SizedBox(
        width: ResponsiveHelper.isDesktop(context) ? 500 : double.maxFinite,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: Text('Are you sure you want to send a payment reminder to the client?'),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        ElevatedButton(
          child: const Text('Send Reminder', style: TextStyle(color: Colors.white)),
          onPressed: () => _sendReminder(context),
        ),
      ],
    );
  }
}
