// invoice_model.dart
// invoice_model.dart
enum InvoiceStatus { active, completed, cancelled, draft, unknown }

extension InvoiceStatusExtension on String {
  InvoiceStatus toInvoiceStatus() {
    switch (toLowerCase()) {
      case 'active':
        return InvoiceStatus.active;
      case 'completed':
        return InvoiceStatus.completed;
      case 'cancelled':
        return InvoiceStatus.cancelled;
      case 'draft':
        return InvoiceStatus.draft;
      default:
        return InvoiceStatus.unknown;
    }
  }
}

class InvoiceModel {
  final String id;
  final String clientId;
  final String clientName;
  final String invoiceNumber;
  final String clientEmail;
  final String currency;
  final String invoiceAmount;
  final String receivableAmount;
  final String outstandingAmount;
  final String invoiceDate;
  final String dueDate;
  final String status;
  final String purposeCode;
  final String? internalNotes;
  final String? filePath;
  final String createdAt;
  final String description;
  final int reminderCount;
  final String? paymentReceivedDate;
  final String? fileUrl;
  final int reminders;
  final bool hasBeenShared;
  final bool? isSharedInvoice;
  final int? countRemind;

  InvoiceModel({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.invoiceNumber,
    required this.clientEmail,
    required this.currency,
    required this.invoiceAmount,
    required this.receivableAmount,
    required this.outstandingAmount,
    required this.invoiceDate,
    required this.dueDate,
    required this.status,
    required this.purposeCode,
    this.internalNotes,
    this.filePath,
    required this.createdAt,
    required this.description,
    this.reminderCount = 0,
    this.paymentReceivedDate,
    this.fileUrl,
    this.reminders = 0,
    this.hasBeenShared = false,
    this.isSharedInvoice,
    this.countRemind,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'] as String,
      clientId: json['client_id'] as String? ?? '',
      clientName: json['client_name'] as String? ?? '',
      invoiceNumber: json['invoice_number'] as String? ?? '',
      clientEmail: json['client_email'] as String? ?? '',
      currency: json['currency'] as String? ?? '',
      invoiceAmount: json['invoice_amount'] != null ? json['invoice_amount'].toString() : '',
      receivableAmount: json['receivable_amount'] != null ? json['receivable_amount'].toString() : '',
      outstandingAmount: json['outstanding_amount'] != null ? json['outstanding_amount'].toString() : '',
      invoiceDate: json['invoice_date'] as String? ?? '',
      dueDate: json['due_date'] as String? ?? '',
      status: json['status'] as String? ?? '',
      purposeCode: json['purpose_code'] as String? ?? '',
      internalNotes: json['internal_notes'] as String?,
      filePath: json['file_path'] as String?,
      createdAt: json['created_at'] as String? ?? '',
      description: json['description'] as String? ?? '',
      reminderCount: json['reminder_count'] as int? ?? 0,
      paymentReceivedDate: json['payment_received_date'] as String?,
      fileUrl: json['file_url'] as String?,
      reminders: json['reminders'] as int? ?? 0,
      hasBeenShared: json['has_been_shared'] as bool? ?? false,
      isSharedInvoice: json['is_shared_invoice'] as bool?,
      countRemind: json['count_remind'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'client_name': clientName,
      'invoice_number': invoiceNumber,
      'client_email': clientEmail,
      'currency': currency,
      'invoice_amount': invoiceAmount,
      'receivable_amount': receivableAmount,
      'outstanding_amount': outstandingAmount,
      'invoice_date': invoiceDate,
      'due_date': dueDate,
      'status': status,
      'purpose_code': purposeCode,
      'internal_notes': internalNotes,
      'file_path': filePath,
      'created_at': createdAt,
      'description': description,
      'reminder_count': reminderCount,
      'payment_received_date': paymentReceivedDate,
      'file_url': fileUrl,
      'reminders': reminders,
      'has_been_shared': hasBeenShared,
      'is_shared_invoice': isSharedInvoice,
      'count_remind': countRemind,
    };
  }

  InvoiceStatus get invoiceStatus => status.toInvoiceStatus();

  bool get canSendReminder => invoiceStatus == InvoiceStatus.active && (countRemind ?? 0) > 0;
  bool get hasBeenSharedInvoice => hasBeenShared || (isSharedInvoice ?? false);

  InvoiceModel copyWith({
    String? id,
    String? clientId,
    String? clientName,
    String? invoiceNumber,
    String? clientEmail,
    String? currency,
    String? invoiceAmount,
    String? receivableAmount,
    String? outstandingAmount,
    String? invoiceDate,
    String? dueDate,
    String? status,
    String? purposeCode,
    String? internalNotes,
    String? filePath,
    String? createdAt,
    String? description,
    int? reminderCount,
    String? paymentReceivedDate,
    String? fileUrl,
    int? reminders,
    bool? hasBeenShared,
    bool? isSharedInvoice,
    int? countRemind,
  }) {
    return InvoiceModel(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      clientEmail: clientEmail ?? this.clientEmail,
      currency: currency ?? this.currency,
      invoiceAmount: invoiceAmount ?? this.invoiceAmount,
      receivableAmount: receivableAmount ?? this.receivableAmount,
      outstandingAmount: outstandingAmount ?? this.outstandingAmount,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      purposeCode: purposeCode ?? this.purposeCode,
      internalNotes: internalNotes ?? this.internalNotes,
      filePath: filePath ?? this.filePath,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      reminderCount: reminderCount ?? this.reminderCount,
      paymentReceivedDate: paymentReceivedDate ?? this.paymentReceivedDate,
      fileUrl: fileUrl ?? this.fileUrl,
      reminders: reminders ?? this.reminders,
      hasBeenShared: hasBeenShared ?? this.hasBeenShared,
      isSharedInvoice: isSharedInvoice ?? this.isSharedInvoice,
      countRemind: countRemind ?? this.countRemind,
    );
  }
}

class ClientModel {
  final String id;
  final String name;
  final String email;
  // final String clientType;
  final String currency;

  ClientModel({
    required this.id,
    required this.name,
    required this.email,
    // required this.clientType,
    required this.currency,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'] as String,
      name: json['client_name'] as String, // from 'client_name'
      email: json['email'] as String,
      // clientType: json['client_type'] as String,
      currency: json['currency'] as String,
    );
  }
}

class CurrencyOption {
  final String currencyCode;
  final String currencyDescription;

  CurrencyOption({required this.currencyCode, required this.currencyDescription});

  factory CurrencyOption.fromJson(Map<String, dynamic> json) {
    return CurrencyOption(currencyCode: json['currency_code'], currencyDescription: json['currency_description']);
  }
}

class PurposeCodeOption {
  final String purposeCode;
  final String purposeCodeDescription;

  PurposeCodeOption({required this.purposeCode, required this.purposeCodeDescription});

  factory PurposeCodeOption.fromJson(Map<String, dynamic> json) {
    return PurposeCodeOption(
      purposeCode: json['purpose_code'],
      purposeCodeDescription: json['purpose_code_description'],
    );
  }
}
