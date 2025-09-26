import 'package:equatable/equatable.dart';

/// Model representing a client summary item
class ClientModel extends Equatable {
  final String? id;
  final String? userId;
  final String? name;
  final String? clientType;
  final String? email;
  final String? addressLine1;
  final String? addressLine2;
  final String? state;
  final String? city;
  final String? postalCode;
  final String? country;
  final String? currency;
  final String? notes;
  final String? createdAt;
  final String? updatedAt;

  final int? numberOfInvoices;
  final int? activeInvoices;
  final String? receivableAmount;
  final String? pendingAmount;

  const ClientModel({
    this.id,
    this.userId,
    this.name,
    this.clientType,
    this.email,
    this.addressLine1,
    this.addressLine2,
    this.state,
    this.city,
    this.postalCode,
    this.country,
    this.currency,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.numberOfInvoices,
    this.activeInvoices,
    this.receivableAmount,
    this.pendingAmount,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
    id: json["id"]?.toString(),
    userId: json["user_id"]?.toString(),
    name: json["client_name"]?.toString(),
    clientType: json["client_type"]?.toString(),
    email: json["email"]?.toString(),
    addressLine1: json["address_line1"]?.toString(),
    addressLine2: json["address_line2"]?.toString(),
    state: json["state"]?.toString(),
    city: json["city"]?.toString(),
    postalCode: json["postal_code"]?.toString(),
    country: json["country"]?.toString(),
    currency: json["currency"]?.toString(),
    notes: json["notes"]?.toString(),
    createdAt: json["created_at"]?.toString(),
    updatedAt: json["updated_at"]?.toString(),
    numberOfInvoices: _safeParseInt(json['total_invoice_count'] ?? json['number_of_invoices']),
    activeInvoices: _safeParseInt(json['active_invoice_count'] ?? json['active_invoices']),
    receivableAmount: json['receivable_amount']?.toString() ?? json['received_amount']?.toString(),
    pendingAmount: json['pending_amount']?.toString() ?? json['amount_pending']?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "client_name": name,
    "client_type": clientType,
    "email": email,
    "address_line1": addressLine1,
    "address_line2": addressLine2,
    "state": state,
    "city": city,
    "postal_code": postalCode,
    "country": country,
    "currency": currency,
    "notes": notes,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "number_of_invoices": numberOfInvoices,
    "active_invoice_count": activeInvoices,
    "receivable_amount": receivableAmount,
    "pending_amount": pendingAmount,
  };

  /// Combines address lines safely
  // String? get address {
  //   final parts = <String>[];
  //   if ((addressLine1?.isNotEmpty ?? false)) parts.add(addressLine1!);
  //   if ((addressLine2?.isNotEmpty ?? false)) parts.add(addressLine2!);
  //   return parts.isEmpty ? null : parts.join(", ");
  // }

  @override
  List<Object?> get props => [
    id,
    userId,
    name,
    clientType,
    email,
    addressLine1,
    addressLine2,
    state,
    city,
    postalCode,
    country,
    currency,
    notes,
    createdAt,
    updatedAt,
    numberOfInvoices,
    activeInvoices,
    receivableAmount,
    pendingAmount,
  ];
}

// Helper function to safely parse int
int? _safeParseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}

/// Detailed client model
class ClientDetailModel extends Equatable {
  final String? name;
  final String? email;
  final String? clientType;
  // final String? address;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? country;
  final String? currencyCode;
  final String? status;
  final String? dateAdded;
  final String? clientId;

  // Financial summary fields
  final String? totalReceivable;
  final String? withdrawn;
  final String? processing;
  final String? pending;

  const ClientDetailModel({
    this.name,
    this.email,
    this.clientType,
    // this.address,
    this.addressLine1, 
    this.addressLine2, 
    this.city,
    this.state,
    this.country,
    this.currencyCode,
    this.status,
    this.dateAdded,
    this.totalReceivable,
    this.withdrawn,
    this.processing,
    this.pending,
    this.clientId
  });

  factory ClientDetailModel.fromJson(Map<String, dynamic> json) {
    // final address1 = json['address_line1'] as String? ?? '';
    // final address2 = json['address_line2'] as String? ?? '';
    // final city = json['city'] as String? ?? '';
    // final state= json['state'] as String? ?? '';
    // final  country= json['country'] as String? ?? '';
    //  country: json['country'] as String?,
    // final combinedAddress = [address1, address2,city,].where((s) => s.isNotEmpty).join(", ");

    return ClientDetailModel(
      name: json['client_name'] as String?,
      email: json['email'] as String?,
      clientType: json['client_type'] as String?,
    //  address: combinedAddress.isEmpty ? null : combinedAddress,
      addressLine1: json["address_line1"]?.toString(),
      addressLine2: json["address_line2"]?.toString(),
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      currencyCode: json['currency'] as String? ?? "",
      status: json['status'] as String? ?? "",
      dateAdded: json['created_at'] as String?,

      totalReceivable: json['total_receivable']?.toString(),
      withdrawn: json['withdrawn']?.toString(),
      processing: json['processing']?.toString(),
      pending: json['pending']?.toString(),
      clientId: json["id"]?.toString(),
    );
  }

  @override
  List<Object?> get props => [
    name,
    email,
    clientType,
    // address,
    addressLine1,
    addressLine2,
    city,
    state,
    country,
    currencyCode,
    status,
    dateAdded,
    totalReceivable,
    withdrawn,
    processing,
    pending,
    clientId
  ];
}

/// Invoice model
class InvoiceModel extends Equatable {
  final String? id;
  final String? invoiceNumber;
  final String? currency;
  final String? totalAmount;
  final String? netAmount;
  final String? invoiceDate;
  final String? dueDate;
  final String? receivedDate;
  final String? status;

  const InvoiceModel({
    this.id,
    this.invoiceNumber,
    this.currency,
    this.totalAmount,
    this.netAmount,
    this.invoiceDate,
    this.dueDate,
    this.receivedDate,
    this.status,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id']?.toString(),
      invoiceNumber: json['invoice_no'] as String?,
      currency: json['currency']?.toString(),
      totalAmount: (json['receivable_amount'] ?? json['invoice_amount'])?.toString(),
      netAmount: json['pending_amount']?.toString(),
      invoiceDate: json['invoice_date']?.toString(),
      dueDate: json['due_date']?.toString(),
      receivedDate: json['received_date']?.toString(),
      status: json['receivable_status'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    invoiceNumber,
    currency,
    totalAmount,
    netAmount,
    invoiceDate,
    dueDate,
    receivedDate,
    status,
  ];
}

/// Invoice model for client invoice list UI
class ClientInvoiceModel extends Equatable {
  final String? id;
  final String? invoiceNumber;
  final String? invoiceDate;
  final String? receivedDate;
  final String? currency;
  final String? totalAmount;
  final String? netAmount;
  final String? status;

  const ClientInvoiceModel({
    this.id,
    this.invoiceNumber,
    this.invoiceDate,
    this.receivedDate,
    this.currency,
    this.totalAmount,
    this.netAmount,
    this.status,
  });

  factory ClientInvoiceModel.fromJson(Map<String, dynamic> json) => ClientInvoiceModel(
    id: json['id']?.toString(),
    invoiceNumber: json['invoice_number']?.toString(),
    invoiceDate: json['invoice_date']?.toString(),
    receivedDate: json['received_date']?.toString(),
    currency: json['currency']?.toString(),
    totalAmount: json['total_amount']?.toString(),
    netAmount: json['net_amount']?.toString(),
    status: json['status']?.toString(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'invoice_number': invoiceNumber,
    'invoice_date': invoiceDate,
    'received_date': receivedDate,
    'currency': currency,
    'total_amount': totalAmount,
    'net_amount': netAmount,
    'status': status,
  };

  @override
  List<Object?> get props => [id, invoiceNumber, invoiceDate, receivedDate, currency, totalAmount, netAmount, status];
}

/// Utility converter: InvoiceModel -> ClientInvoiceModel
List<ClientInvoiceModel> convertInvoicesToClientInvoices(List<InvoiceModel> invoices) {
  return invoices
      .map(
        (invoice) => ClientInvoiceModel(
          id: invoice.id,
          invoiceNumber: invoice.invoiceNumber,
          invoiceDate: invoice.invoiceDate,
          receivedDate: invoice.receivedDate,
          currency: invoice.currency,
          totalAmount: invoice.totalAmount,
          netAmount: invoice.netAmount,
          status: invoice.status,
        ),
      )
      .toList();
}

class ReceivableModel {
  final String currency;
  final double total;
  final double withdrawn;
  final double processing;
  final double pending;

  ReceivableModel({
    required this.currency,
    required this.total,
    required this.withdrawn,
    required this.processing,
    required this.pending,
  });
}

class Invoice {
  final String invoiceNo;
  final String invoiceAmount;
  final double receivableAmount;
  final double pendingAmount;
  final String invoiceDate;
  final String dueDate;
  final String receivableStatus;

  Invoice({
    required this.invoiceNo,
    required this.invoiceAmount,
    required this.receivableAmount,
    required this.pendingAmount,
    required this.invoiceDate,
    required this.dueDate,
    required this.receivableStatus,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      invoiceNo: json['invoice_no'] ?? '',
      invoiceAmount: json['invoice_amount'] ?? '',
      receivableAmount: (json['receivable_amount'] ?? 0).toDouble(),
      pendingAmount: (json['pending_amount'] ?? 0).toDouble(),
      invoiceDate: json['invoice_date'] ?? '',
      dueDate: json['due_date'] ?? '',
      receivableStatus: json['receivable_status'] ?? '',
    );
  }
}

class Country {
  final String countryCode;
  final String countryName;
  Country({required this.countryCode, required this.countryName});

   factory Country.fromJson(Map<String, dynamic> json) => Country(
        countryCode: json['code'] ?? '',
        countryName: json['name'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'countryCode': countryCode,
        'countryName': countryName,
      };
}

class ClientType {
  final String clientTypeCode;
  final String clientTypeyName;
  ClientType({required this.clientTypeCode, required this.clientTypeyName});

   factory ClientType.fromJson(Map<String, dynamic> json) => ClientType(
        clientTypeCode: json['code'] ?? '',
        clientTypeyName: json['name'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'clientTypeCode': clientTypeCode,
        'clientTypeyName': clientTypeyName,
      };
}

class CountryClientTypeOptionsResponse {
  final List<Country> countries;
  final List<ClientType> clientTypes;

  CountryClientTypeOptionsResponse({required this.countries, required this.clientTypes});
}