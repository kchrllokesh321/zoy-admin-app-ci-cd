class TransferCalculatorModel {
  final String fromCurrency;
  final String toCurrency;
  final double amount;
  final double exchangeRate;
  final double platformFee;
  final double estimatedAmount;

  const TransferCalculatorModel({
    required this.fromCurrency,
    required this.toCurrency,
    required this.amount,
    required this.exchangeRate,
    required this.platformFee,
    required this.estimatedAmount,
  });

  factory TransferCalculatorModel.initial() {
    return TransferCalculatorModel(
      fromCurrency: 'USD',
      toCurrency: 'INR',
      amount: 0.0,
      exchangeRate: 89.4,
      platformFee: 542.02,
      estimatedAmount: 0.0,
    );
  }

  TransferCalculatorModel copyWith({
    String? fromCurrency,
    String? toCurrency,
    double? amount,
    double? exchangeRate,
    double? platformFee,
    double? estimatedAmount,
  }) {
    return TransferCalculatorModel(
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      amount: amount ?? this.amount,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      platformFee: platformFee ?? this.platformFee,
      estimatedAmount: estimatedAmount ?? this.estimatedAmount,
    );
  }
}

class CurrencyModel {
  final String code;
  final String name;
  final String symbol;

  const CurrencyModel({required this.code, required this.name, required this.symbol});
}
