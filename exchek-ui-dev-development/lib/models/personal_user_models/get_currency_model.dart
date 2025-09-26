class GetCurrencyOptionModel {
  bool? success;
  Data? data;

  GetCurrencyOptionModel({this.success, this.data});

  GetCurrencyOptionModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class CurrencyListModel {
  final List<String> currencies;

  CurrencyListModel({required this.currencies});

  factory CurrencyListModel.fromJson(Map<String, dynamic> json) {
    return CurrencyListModel(currencies: List<String>.from(json['data'] ?? []));
  }

  Map<String, dynamic> toJson() {
    return {"data": currencies};
  }
}

class BalanceResponse {
  final List<BalanceItem> available;
  final List<BalanceItem> feeAdvance;
  final List<BalanceItem> payoutProcessing;
  final List<BalanceItem> pending;
  final List<BalanceItem> processing;

  BalanceResponse({
    required this.available,
    required this.feeAdvance,
    required this.payoutProcessing,
    required this.pending,
    required this.processing,
  });

  factory BalanceResponse.fromJson(Map<String, dynamic> json) {
    return BalanceResponse(
      available: _parseBalanceItems(json['available']),
      feeAdvance: _parseBalanceItems(json['fee_advance']),
      payoutProcessing: _parseBalanceItems(json['payout_processing']),
      pending: _parseBalanceItems(json['pending']),
      processing: _parseBalanceItems(json['processing']),
    );
  }

  // Helper method to safely parse balance items
  static List<BalanceItem> _parseBalanceItems(dynamic data) {
    if (data == null) return [];

    if (data is! List) {
      print('Warning: Expected List but got ${data.runtimeType}');
      return [];
    }

    return (data)
        .where((item) => item != null)
        .map((item) {
          try {
            return BalanceItem.fromJson(item as Map<String, dynamic>);
          } catch (e) {
            print('Error parsing balance item: $e');
            return null;
          }
        })
        .whereType<BalanceItem>()
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'available': available.map((e) => e.toJson()).toList(),
      'fee_advance': feeAdvance.map((e) => e.toJson()).toList(),
      'payout_processing': payoutProcessing.map((e) => e.toJson()).toList(),
      'pending': pending.map((e) => e.toJson()).toList(),
      'processing': processing.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'BalanceResponse(available: $available, feeAdvance: $feeAdvance, payoutProcessing: $payoutProcessing, pending: $pending, processing: $processing)';
  }

  void operator [](String other) {}
}

class BalanceItem {
  final String amount;
  final String currency;

  BalanceItem({required this.amount, required this.currency});

  factory BalanceItem.fromJson(Map<String, dynamic> json) {
    return BalanceItem(
      amount: (json['amount'] ?? "0.00").toString(),
      currency: (json['currency'] ?? "").toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'amount': amount, 'currency': currency};
  }

  @override
  String toString() {
    return 'BalanceItem(amount: $amount, currency: $currency)';
  }
}

class Data {
  int? id;
  List<String>? estimatedMonthlyVolume;
  List<String>? multicurrency;
  String? createdAt;
  String? updatedAt;

  Data({
    this.id,
    this.estimatedMonthlyVolume,
    this.multicurrency,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    estimatedMonthlyVolume = json['estimated_monthly_volume'].cast<String>();
    multicurrency = json['multicurrency'].cast<String>();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['estimated_monthly_volume'] = estimatedMonthlyVolume;
    data['multicurrency'] = multicurrency;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
