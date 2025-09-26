import 'package:exchek/models/invoice_models/invoice_model.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/clients_bloc/clients_bloc.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/clients_bloc/clients_event.dart';
import 'package:exchek/views/main_dashboard_view/clients_view/add_client_view.dart';
import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/viewmodels/invoice_bloc/invoice_bloc.dart';
import 'package:exchek/viewmodels/invoice_bloc/invoice_event.dart';
import 'package:exchek/viewmodels/invoice_bloc/invoice_state.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/dashboard_bloc/dashboard_bloc.dart';
import 'package:exchek/widgets/custom_widget/custom_drop_down_field.dart';

enum SaveDraftResult { cancel, saveDraft, discard }

class _DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final DateTime firstDate;
  final DateTime? lastDate;

  const _DatePickerField({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
    required this.firstDate,
    this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
    final displayText =
        selectedDate == null
            ? '' // visually empty
            : selectedDate!.toLocal().toString().split(' ')[0];

    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: firstDate,
          lastDate: lastDate ?? DateTime(2100),
        );
        if (picked != null) onDateSelected(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(labelText: label, suffixIcon: const Icon(Icons.calendar_today_outlined)),
        child: Text(displayText, style: TextStyle(color: selectedDate == null ? Colors.grey : Colors.black)),
      ),
    );
  }
}

class AddInvoicePage extends StatefulWidget {
  final InvoiceModel? invoiceToEdit;

  const AddInvoicePage({super.key, this.invoiceToEdit});

  @override
  _AddInvoicePageState createState() => _AddInvoicePageState();
}

class _AddInvoicePageState extends State<AddInvoicePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController invoiceNumberController;
  late TextEditingController clientEmailController;
  late TextEditingController invoiceAmountController;
  late TextEditingController receivableAmountController;
  late TextEditingController purposeCodeController;
  late TextEditingController internalNotesController;

  // Validation flags for custom dropdowns
  bool _showClientValidationError = false;
  bool _showCurrencyValidationError = false;
  bool _showPurposeCodeValidationError = false;

  @override
  void initState() {
    super.initState();

    invoiceNumberController = TextEditingController(text: widget.invoiceToEdit?.invoiceNumber ?? "");
    clientEmailController = TextEditingController(text: widget.invoiceToEdit?.clientEmail ?? "");
    invoiceAmountController = TextEditingController(text: widget.invoiceToEdit?.invoiceAmount.toString() ?? "");
    receivableAmountController = TextEditingController(text: widget.invoiceToEdit?.receivableAmount.toString() ?? "");
    purposeCodeController = TextEditingController(text: widget.invoiceToEdit?.purposeCode ?? "");
    internalNotesController = TextEditingController(text: widget.invoiceToEdit?.internalNotes ?? "");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<InvoiceBloc>();

      if (widget.invoiceToEdit != null) {
        final client = ClientModel(
          id: widget.invoiceToEdit!.clientId,
          name: widget.invoiceToEdit!.clientName,
          email: widget.invoiceToEdit!.clientEmail,
          currency: widget.invoiceToEdit!.currency,
        );
        bloc.add(InvoiceClientSelected(client));
        bloc.add(InvoiceFormChanged(field: "invoiceNumber", value: widget.invoiceToEdit!.invoiceNumber));
        bloc.add(InvoiceFormChanged(field: "email", value: widget.invoiceToEdit!.clientEmail));
        bloc.add(InvoiceFormChanged(field: "currency", value: widget.invoiceToEdit!.currency));
        bloc.add(InvoiceFormChanged(field: "invoiceAmount", value: widget.invoiceToEdit!.invoiceAmount.toString()));
        bloc.add(
          InvoiceFormChanged(field: "receivableAmount", value: widget.invoiceToEdit!.receivableAmount.toString()),
        );
        bloc.add(InvoiceFormChanged(field: "purposeCode", value: widget.invoiceToEdit!.purposeCode ?? ""));
        bloc.add(InvoiceFormChanged(field: "internalNotes", value: widget.invoiceToEdit!.internalNotes ?? ""));
        bloc.add(InvoiceFormChanged(field: "invoiceDate", value: widget.invoiceToEdit!.invoiceDate));
        bloc.add(InvoiceFormChanged(field: "dueDate", value: widget.invoiceToEdit!.dueDate ?? ""));

        final fileUrl = widget.invoiceToEdit!.fileUrl ?? widget.invoiceToEdit!.filePath;
        if (fileUrl != null && fileUrl.isNotEmpty) {
          final fileData = FileData(
            name: fileUrl.split('/').last,
            bytes: Uint8List(0), // No bytes because loading from URL
            sizeInMB: 0.0,
            webPath: fileUrl, // Used for preview
          );
          bloc.add(InvoiceFileSelected(fileData));
        }
      }
    });
  }

  @override
  void dispose() {
    invoiceNumberController.dispose();
    clientEmailController.dispose();
    invoiceAmountController.dispose();
    receivableAmountController.dispose();
    purposeCodeController.dispose();
    internalNotesController.dispose();
    super.dispose();
  }

  bool validateFile(FileData file) {
    final allowedExt = ['pdf', 'jpeg', 'png'];
    final sizeMB = file.bytes.length / (1024 * 1024);
    final ext = file.name.split('.').last.toLowerCase();
    return sizeMB <= 5 && allowedExt.contains(ext);
  }

  
  Future<SaveDraftResult> showSaveDraftDialog(BuildContext context) async {
    final result = await showDialog<SaveDraftResult>(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Save Changes?"),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx, SaveDraftResult.cancel),
                  tooltip: 'Close',
                ),
              ],
            ),
            content: const Text("Do you want to save your changes as a draft before exiting?"),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, SaveDraftResult.discard), child: const Text("Discard")),
              TextButton(onPressed: () => Navigator.pop(ctx, SaveDraftResult.cancel), child: const Text("Cancel")),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, SaveDraftResult.saveDraft),
                child: const Text("Save Draft", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
    return result ?? SaveDraftResult.cancel;
  }

  bool _isFormEmpty(InvoiceState state) {
    return (state.invoiceNumber.isEmpty &&
        (state.selectedClient == null || state.selectedClient!.id.isEmpty) &&
        state.invoiceAmount.isEmpty &&
        state.receivableAmount.isEmpty &&
        state.purposeCode.isEmpty &&
        state.internalNotes.isEmpty &&
        (state.invoiceDate.isEmpty || state.invoiceDate == '') &&
        (state.dueDate == null || state.dueDate!.isEmpty) &&
        state.selectedFile == null);
  }

  void _onBackPressed() async {
    final invoiceBloc = context.read<InvoiceBloc>();
    final invoiceState = invoiceBloc.state;

    if (_isFormEmpty(invoiceState)) {
      Navigator.of(context).pop();
      return;
    }
    final result = await showSaveDraftDialog(context);

    if (result == SaveDraftResult.saveDraft) {
      _saveDraft(invoiceBloc, invoiceState);
    } else if (result == SaveDraftResult.discard) {
      Navigator.of(context).pop();
    }
  }

  void _saveDraft(InvoiceBloc bloc, InvoiceState state) {
    if (state.selectedFile == null) {
      AppToast.show(message: "Please upload a valid invoice file", type: ToastificationType.error);
      return;
    }

    if (state.isEditing) {
      if (state.id.isEmpty) {
        AppToast.show(message: "Invoice ID missing. Cannot edit invoice.", type: ToastificationType.error);
        return;
      }
      bloc.add(
        EditDraftInvoiceRequested(
          id: state.id,
          clientId: state.selectedClient?.id ?? '',
          invoiceNumber: state.invoiceNumber,
          currency: state.currency,
          invoiceAmount: state.invoiceAmount,
          receivableAmount: state.receivableAmount,
          invoiceDate: state.invoiceDate.split('T').first,
          dueDate: (state.dueDate ?? '').split('T').first,
          purposeCode: state.purposeCode,
          status: 'Draft',
          internalNotes: state.internalNotes.isEmpty ? null : state.internalNotes,
          invoiceFile: state.selectedFile!,
        ),
      );
    } else {
      bloc.add(
        UploadInvoice(
          fileData: state.selectedFile!,
          clientId: state.selectedClient?.id ?? '',
          invoiceNumber: state.invoiceNumber,
          currency: state.currency,
          invoiceAmount: state.invoiceAmount,
          receivableAmount: state.receivableAmount,
          invoiceDate: state.invoiceDate,
          dueDate: state.dueDate ?? '',
          purposeCode: state.purposeCode,
          status: 'Draft',
          internalNotes: state.internalNotes.isEmpty ? null : state.internalNotes,
        ),
      );
    }
  }

  Widget _buildClientDropdown(BuildContext context, InvoiceState state, InvoiceBloc bloc) {
    final List<String> clientItems = ["Add New Client", ...state.clients.map((client) => client.name)];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Client", style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),
        ExpandableDropdownField(
          items: clientItems,
          selectedValue: state.selectedClient?.name ?? '',
          onChanged: (val) {
            setState(() {
              _showClientValidationError = false;
            });

            if (val == "Add New Client") {
              showDialog(context: context, builder: (_) => const AddClientDialog()).then((result) {
                if (result == true) {
                  context.read<InvoiceBloc>().add(FetchClientNames());
                  context.read<ClientsBloc>().add(ResetCreateClientForm());
                  
                }
              });
            } else if (val.isNotEmpty) {
              final client = state.clients.firstWhere((c) => c.name == val);
              bloc.add(InvoiceClientSelected(client));
              bloc.add(InvoiceFormChanged(field: "email", value: client.email));
              bloc.add(InvoiceFormChanged(field: "currency", value: client.currency));
            }
          },
        ),
        // Add validation text if needed
        if (_showClientValidationError && (state.selectedClient == null || state.selectedClient!.name.isEmpty))
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 12),
            child: Text(
              "Please select a client",
              style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildCurrencyDropdown(BuildContext context, InvoiceState state, InvoiceBloc bloc) {
    final List<String> currencyItems = state.currencyOptions.map((currency) => currency.currencyCode).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Currency", style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),
        ExpandableDropdownField(
          items: currencyItems,
          selectedValue: state.currency.isEmpty ? '' : state.currency,
          onChanged: (val) {
            setState(() {
              _showCurrencyValidationError = false;
            });
            bloc.add(InvoiceFormChanged(field: "currency", value: val));
          },
        ),
        // Add validation text if needed
        if (_showCurrencyValidationError && state.currency.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 12),
            child: Text(
              "Please select a currency",
              style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildPurposeCodeDropdown(BuildContext context, InvoiceState state, InvoiceBloc bloc) {
    final List<String> purposeCodeItems =
        state.purposeCodeOptions.map((code) => '${code.purposeCode} - ${code.purposeCodeDescription}').toList();

    // Find current display value
    String currentDisplayValue = '';
    if (state.purposeCode.isNotEmpty) {
      final matchingCode = state.purposeCodeOptions.where((code) => code.purposeCode == state.purposeCode).firstOrNull;
      if (matchingCode != null) {
        currentDisplayValue = '${matchingCode.purposeCode} - ${matchingCode.purposeCodeDescription}';
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Purpose Code", style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),
        ExpandableDropdownField(
          items: purposeCodeItems,
          selectedValue: currentDisplayValue,
          onChanged: (val) {
            setState(() {
              _showPurposeCodeValidationError = false;
            });

            if (val.isNotEmpty) {
              // Extract the purpose code from the selected value
              final purposeCode = val.split(' - ').first;
              bloc.add(InvoiceFormChanged(field: "purposeCode", value: purposeCode));
              purposeCodeController.text = purposeCode;
            }
          },
        ),
        // Add validation text if needed
        if (_showPurposeCodeValidationError && state.purposeCode.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 12),
            child: Text(
              "Please select a purpose code",
              style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
            ),
          ),
      ],
    );
  }

  // Update your form validation method to include custom dropdown validation
  bool _validateForm(InvoiceState state) {
    bool isValid = true;

    // Check if client is selected
    if (state.selectedClient == null || state.selectedClient!.name.isEmpty) {
      setState(() {
        _showClientValidationError = true;
      });
      isValid = false;
    }

    // Check if currency is selected
    if (state.currency.isEmpty) {
      setState(() {
        _showCurrencyValidationError = true;
      });
      isValid = false;
    }

    // Check if purpose code is selected
    if (state.purposeCode.isEmpty) {
      setState(() {
        _showPurposeCodeValidationError = true;
      });
      isValid = false;
    }

    // Also validate the form fields
    if (!_formKey.currentState!.validate()) {
      isValid = false;
    }

    return isValid;
  }

  void _submitInvoice(InvoiceState state) {
    if (_validateForm(state)) {
      if (state.selectedFile == null) {
        AppToast.show(message: "Please upload a valid invoice file", type: ToastificationType.error);
        return;
      }
      final bloc = context.read<InvoiceBloc>();
      if (state.isEditing) {
        if (state.id.isEmpty) {
          AppToast.show(message: "Invoice ID missing. Cannot edit invoice.", type: ToastificationType.error);
          return;
        }
        bloc.add(
          EditDraftInvoiceRequested(
            id: state.id,
            clientId: state.selectedClient?.id ?? '',
            invoiceNumber: state.invoiceNumber,
            currency: state.currency,
            invoiceAmount: state.invoiceAmount,
            receivableAmount: state.receivableAmount,
            invoiceDate: state.invoiceDate.split('T').first,
            dueDate: (state.dueDate ?? '').split('T').first,
            purposeCode: state.purposeCode,
            status: 'Active',
            internalNotes: state.internalNotes.isEmpty ? null : state.internalNotes,
            invoiceFile: state.selectedFile!,
          ),
        );
      } else {
        bloc.add(
          UploadInvoice(
            fileData: state.selectedFile!,
            clientId: state.selectedClient?.id ?? '',
            invoiceNumber: state.invoiceNumber,
            currency: state.currency,
            invoiceAmount: state.invoiceAmount,
            receivableAmount: state.receivableAmount,
            invoiceDate: state.invoiceDate,
            dueDate: state.dueDate ?? '',
            purposeCode: state.purposeCode,
            status: 'Active',
            internalNotes: state.internalNotes.isEmpty ? null : state.internalNotes,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: AddInvoiceAppBar(
        userName: 'Kalyani Pasupuleti',
        accountType: 'Business Account',
        onClose: () => _onBackPressed(),
      ),

      body: BackgroundImage(
        imagePath: Assets.images.svgs.other.appBg.path,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: ResponsiveHelper.getMaxDialogWidth(context)),
                      child: SingleChildScrollView(
                        child: BlocConsumer<InvoiceBloc, InvoiceState>(
                          listenWhen:
                              (prev, curr) =>
                                  prev.uploading != curr.uploading ||
                                  prev.error != curr.error ||
                                  prev.uploadSuccess != curr.uploadSuccess,
                          listener: (context, state) {
                            if (state.error != null && state.error!.isNotEmpty) {
                              AppToast.show(message: state.error!, type: ToastificationType.error);
                            }
                            if (state.uploadSuccess && !state.uploading) {
                              context.read<DashboardBloc>().add(
                                DashboardDrawerIndexChanged(selectedDrawerOption: "Invoices", isOnAddInvoicePage: false),
                              );
                            }
                          },
                          builder: (context, state) {
                            final bloc = context.read<InvoiceBloc>();
                            final selectedFile = state.selectedFile;
                
                            // Update controllers only if text differs to avoid focus issues
                            if (invoiceNumberController.text != state.invoiceNumber) {
                              invoiceNumberController.text = state.invoiceNumber;
                            }
                            if (clientEmailController.text != state.clientEmail) {
                              clientEmailController.text = state.clientEmail;
                            }
                            if (invoiceAmountController.text != state.invoiceAmount) {
                              invoiceAmountController.text = state.invoiceAmount;
                            }
                            if (receivableAmountController.text != state.receivableAmount) {
                              receivableAmountController.text = state.receivableAmount;
                            }
                            if (purposeCodeController.text != state.purposeCode) {
                              purposeCodeController.text = state.purposeCode;
                            }
                            if (internalNotesController.text != state.internalNotes) {
                              internalNotesController.text = state.internalNotes;
                            }
                
                            return Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Row(
                                  //   children: [
                                  //     IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => _onBackPressed()),
                                  //   ],
                                  // ),
                                  const SizedBox(height: 10),
                
                                  // Client Dropdown
                                  _buildClientDropdown(context, state, bloc),
                
                                  const SizedBox(height: 20),
                                  CustomFileUploadWidget(
                                    title: "Upload Invoice File",
                                    allowedExtensions: const ['pdf', 'jpeg', 'png'],
                                    maxSizeInMB: 5,
                                    selectedFile: selectedFile,
                                    onFileSelected: (fileData) {
                                      if (fileData == null) {
                                        bloc.add(const InvoiceFileRemoved());
                                      } else if (!validateFile(fileData)) {
                                        AppToast.show(
                                          message: "Invalid file. Max 5MB, allowed: pdf, jpeg, png.",
                                          type: ToastificationType.error,
                                        );
                                      } else {
                                        bloc.add(InvoiceFileSelected(fileData));
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  Text("Invoice Number", style: Theme.of(context).textTheme.bodyMedium),
                                  CustomTextInputField(
                                    context: context,
                                    controller: invoiceNumberController,
                                    type: InputType.text,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    validator: (val) => val == null || val.isEmpty ? "Invoice Number Required" : null,
                                    onChanged: (val) => bloc.add(InvoiceFormChanged(field: "invoiceNumber", value: val)),
                                  ),
                                  const SizedBox(height: 20),
                                  Text("Client Email", style: Theme.of(context).textTheme.bodyMedium),
                                  CustomTextInputField(
                                    context: context,
                                    controller: clientEmailController,
                                    type: InputType.email,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    validator: (val) {
                                      if (val == null || val.isEmpty) return "Client Email Required";
                                      final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                                      if (!emailRegex.hasMatch(val)) return "Invalid email";
                                      return null;
                                    },
                                    showInfoInsteadOfError: true,
                                    onChanged: (val) => bloc.add(InvoiceFormChanged(field: "email", value: val)),
                                  ),
                
                                  const SizedBox(height: 20),
                                  // Currency Dropdown
                                  _buildCurrencyDropdown(context, state, bloc),
                
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Invoice Amount", style: Theme.of(context).textTheme.bodyMedium),
                                            CustomTextInputField(
                                              context: context,
                                              controller: invoiceAmountController,
                                              type: InputType.decimalDigits,
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              validator:
                                                  (val) => val == null || val.isEmpty ? "Invoice Amount Required" : null,
                                              onChanged:
                                                  (val) => bloc.add(InvoiceFormChanged(field: "invoiceAmount", value: val)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Receivable Amount", style: Theme.of(context).textTheme.bodyMedium),
                                            CustomTextInputField(
                                              context: context,
                                              controller: receivableAmountController,
                                              type: InputType.decimalDigits,
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              validator: (val) {
                                                if (val == null || val.isEmpty) return "Receivable Amount Required";
                                                final invoiceVal = double.tryParse(invoiceAmountController.text) ?? 0;
                                                final receivableVal = double.tryParse(val) ?? -1;
                                                if (receivableVal > invoiceVal) return "Must be <= Invoice Amount";
                                                return null;
                                              },
                                              onChanged:
                                                  (val) =>
                                                      bloc.add(InvoiceFormChanged(field: "receivableAmount", value: val)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Invoice Date", style: Theme.of(context).textTheme.bodyMedium),
                                            _DatePickerField(
                                              label: "",
                                              selectedDate:
                                                  state.invoiceDate.isNotEmpty ? DateTime.tryParse(state.invoiceDate) : null,
                                              onDateSelected:
                                                  (date) => bloc.add(
                                                    InvoiceFormChanged(field: "invoiceDate", value: date.toIso8601String()),
                                                  ),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime.now(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Due Date", style: Theme.of(context).textTheme.bodyMedium),
                                            _DatePickerField(
                                              label: "",
                                              selectedDate:
                                                  (state.dueDate != null && state.dueDate!.isNotEmpty)
                                                      ? DateTime.tryParse(state.dueDate!)
                                                      : null,
                                              onDateSelected:
                                                  (date) => bloc.add(
                                                    InvoiceFormChanged(field: "dueDate", value: date.toIso8601String()),
                                                  ),
                                              firstDate: DateTime.now(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                
                                  const SizedBox(height: 20),
                                  // Purpose Code Dropdown
                                  _buildPurposeCodeDropdown(context, state, bloc),
                
                                  const SizedBox(height: 20),
                                  Text("Internal Notes", style: Theme.of(context).textTheme.bodyMedium),
                                  CustomTextInputField(
                                    context: context,
                                    controller: internalNotesController,
                                    type: InputType.multiline,
                                    maxLength: null,
                                    onChanged: (val) => bloc.add(InvoiceFormChanged(field: "internalNotes", value: val)),
                                  ),
                                  const SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CustomElevatedButton(text: "Cancel", onPressed: () => _onBackPressed(), width: 100),
                                      const SizedBox(width: 20),
                                      CustomElevatedButton(
                                        text: "Submit",
                                        isLoading: state.uploading,
                                        isDisabled: state.uploading,
                                        onPressed: () {
                                          _submitInvoice(state);
                                        },
                                        width: 100,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddInvoiceAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String accountType;
  final VoidCallback onClose;

  const AddInvoiceAppBar({super.key, required this.userName, required this.accountType, required this.onClose});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  Widget _buildLogo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50),
      child: CustomImageView(
        imagePath: Assets.images.svgs.other.appLogo.path,
        height: ResponsiveHelper.getWidgetHeight(context, mobile: 45.0, tablet: 48.0, desktop: 50.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1, 
      shadowColor: Colors.black54, 
      child: Container(
        height: preferredSize.height,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            // Logo section
            _buildLogo(context),
            const SizedBox(width: 32),
            // Title
            Expanded(
              child: Text(
                "Add Invoice",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
              ),
            ),
            // Profile and close icon
            Row(
              children: [
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.end,
                //   children: [
                //     Text(userName, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black)),
                //     Text(accountType, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                //   ],
                // ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  tooltip: "Close",
                  onPressed: onClose, // call passed callback here
                  splashRadius: 48,
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(16),
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
