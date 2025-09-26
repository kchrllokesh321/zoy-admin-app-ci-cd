import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Replace the imports below with your actual project structure
import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/viewmodels/invoice_bloc/invoice_bloc.dart';
import 'package:exchek/viewmodels/invoice_bloc/invoice_event.dart';

class EditReceivableForm extends StatefulWidget {
  final String invoiceAmount; // e.g., "500"
  final String currentReceivable; // e.g., "200"
  final String amountWithdrawn; // e.g., "100"
  final String initialAmount; // e.g., "200"
  final String currency; // e.g., "USD"
  final String invoiceId;

  const EditReceivableForm({
    super.key,
    required this.invoiceAmount,
    required this.currentReceivable,
    required this.amountWithdrawn,
    required this.initialAmount,
    required this.currency,
    required this.invoiceId,
  });

  @override
  State<EditReceivableForm> createState() => _EditReceivableFormState();
}

class _EditReceivableFormState extends State<EditReceivableForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.initialAmount);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      context.read<InvoiceBloc>().add(
        EditReceivableRequested(
          invoiceId: widget.invoiceId,
          newAmount: _amountController.text.trim(),
        ),
      );
      Navigator.of(context).pop();
      AppToast.show(
        message: 'Receivable amount updated',
        type: ToastificationType.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        // width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 520),
        padding: EdgeInsets.all(0.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header with title and close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      "Edit Receivable amount",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(
                          255,
                          245,
                          245,
                          245,
                        ), // light gray background
                        shape: BoxShape.circle, // makes it circular
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 24,
                        color: Color.fromARGB(255, 131, 131, 131),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Divider(color: Colors.grey[200], thickness: 2),

              const SizedBox(height: 20),

              // Info rows with more spacing
              _buildInfoRow(
                "Invoice Amount",
                "${widget.currency} ${widget.invoiceAmount}",
              ),
              const SizedBox(height: 5),
              _buildInfoRow(
                "Current receivable amount",
                "${widget.currency} ${widget.currentReceivable}",
              ),
              const SizedBox(height: 5),
              _buildInfoRow(
                "Amount withdrawn",
                "${widget.currency} ${widget.amountWithdrawn}",
              ),

              const SizedBox(height: 32),

              const Text(
                "Enter the new receivable amount",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 16),

              // Input field with better styling
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FA),
                  hintText: "0.00",
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF4F46E5),
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red, width: 1),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                  errorStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Amount is required';
                  }

                  final inputAmount = double.tryParse(value);
                  if (inputAmount == null) return 'Enter a valid number';

                  final invoiceAmount = double.tryParse(widget.invoiceAmount);
                  if (invoiceAmount != null && inputAmount > invoiceAmount) {
                    return 'Receivable amount cannot exceed invoice amount (${widget.currency} ${widget.invoiceAmount})';
                  }

                  if (inputAmount < 0) return 'Amount cannot be negative';

                  return null;
                },
              ),

              const SizedBox(height: 20),

              /// Button Row with proper styling
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 80,
                    child: TextButton(
                      onPressed:
                          _isLoading ? null : () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(12),
                        //   side: BorderSide(color: Colors.grey[300]!, width: 1),
                        // ),
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color:
                              _isLoading
                                  ? Colors.grey[400]
                                  : const Color(0xFF4F46E5),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 80,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        disabledBackgroundColor: Colors.grey[300],
                        disabledForegroundColor: Colors.grey[500],
                      ),
                      onPressed: _isLoading ? null : _submit,
                      child:
                          _isLoading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                              : const Text(
                                'Update',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

// Usage example:
// showDialog(
//   context: context,
//   builder: (context) => EditReceivableForm(
//     invoiceAmount: "500",
//     currentReceivable: "200", 
//     amountWithdrawn: "100",
//     initialAmount: "200",
//     currency: "USD",
//     invoiceId: "INV123",
//   ),
// );