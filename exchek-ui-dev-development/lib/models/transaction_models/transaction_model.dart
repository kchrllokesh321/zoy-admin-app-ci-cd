class TransactionModel {
  final int id;
  final String referenceId; // Will be blank for now
  final String clientName;
  final String invoiceNumber;
  final String purpose;
  final String paymentMethod;
  final String fees;
  final String additionalNotes;
  final String initiatedDate;
  final String completedDate;
  final String status;
  final String receivingCurrency;
  final String grossAmount;
  final String settledAmount;

  const TransactionModel({
    required this.id,
    required this.referenceId,
    required this.clientName,
    required this.invoiceNumber,
    required this.purpose,
    required this.paymentMethod,
    required this.fees,
    required this.additionalNotes,
    required this.initiatedDate,
    required this.completedDate,
    required this.status,
    required this.receivingCurrency,
    required this.grossAmount,
    required this.settledAmount,
  });

  TransactionModel copyWith({
    int? id,
    String? referenceId,
    String? clientName,
    String? invoiceNumber,
    String? purpose,
    String? paymentMethod,
    String? fees,
    String? additionalNotes,
    String? initiatedDate,
    String? completedDate,
    String? status,
    String? receivingCurrency,
    String? grossAmount,
    String? settledAmount,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      referenceId: referenceId ?? this.referenceId,
      clientName: clientName ?? this.clientName,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      purpose: purpose ?? this.purpose,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      fees: fees ?? this.fees,
      additionalNotes: additionalNotes ?? this.additionalNotes,
      initiatedDate: initiatedDate ?? this.initiatedDate,
      completedDate: completedDate ?? this.completedDate,
      status: status ?? this.status,
      receivingCurrency: receivingCurrency ?? this.receivingCurrency,
      grossAmount: grossAmount ?? this.grossAmount,
      settledAmount: settledAmount ?? this.settledAmount,
    );
  }
}
