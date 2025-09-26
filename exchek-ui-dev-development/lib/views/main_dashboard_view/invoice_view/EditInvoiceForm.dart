import 'package:exchek/core/utils/exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:exchek/models/invoice_models/invoice_model.dart';
import 'package:exchek/viewmodels/invoice_bloc/invoice_bloc.dart';
import 'package:exchek/viewmodels/invoice_bloc/invoice_event.dart';

class EditInvoiceForm extends StatefulWidget {
  final InvoiceModel invoice;

  const EditInvoiceForm({super.key, required this.invoice});

  @override
  State<EditInvoiceForm> createState() => _EditInvoiceFormState();
}

class _EditInvoiceFormState extends State<EditInvoiceForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _invoiceNumberController;
  late TextEditingController _clientEmailController;

  @override
  void initState() {
    super.initState();
    _invoiceNumberController = TextEditingController(text: widget.invoice.invoiceNumber);
    _clientEmailController = TextEditingController(text: widget.invoice.clientEmail);
  }

  @override
  void dispose() {
    _invoiceNumberController.dispose();
    _clientEmailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Raise an event for edit invoice, adapt fields accordingly
      context.read<InvoiceBloc>().add(EditInvoiceRequested(widget.invoice.id));
      Navigator.of(context).pop();
      AppToast.show(message: 'Invoice update requested', type: ToastificationType.success);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Edit Invoice', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            TextFormField(
              controller: _invoiceNumberController,
              decoration: const InputDecoration(labelText: 'Invoice Number'),
              validator: (value) => (value == null || value.isEmpty) ? 'Invoice number required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _clientEmailController,
              decoration: const InputDecoration(labelText: 'Client Email'),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Client email required';
                final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                if (!emailRegex.hasMatch(value)) return 'Enter valid email';
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _submit, child: const Text('Save Changes')),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
