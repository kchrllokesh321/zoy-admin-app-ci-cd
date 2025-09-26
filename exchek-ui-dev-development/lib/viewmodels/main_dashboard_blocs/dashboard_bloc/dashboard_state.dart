part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final String selectedDrawerOption;
  final bool isOnAddInvoicePage;

  final List<DashboardBalance> totalBalance;
  final TransferCalculatorModel transferCalculator;
  final List<CurrencyModel> availableCurrencies;
  final List<CurrencyOption> currencyOptions;
  final List<String> usedCurrencies;
  final bool isCalculating;
  final TextEditingController amountController;
  final Country? receivingSelectedCountry;
  final String? receivingSelectedCurrencyCode;
  final bool isReceivingMenuOpen;
  final BalanceResponse? balanceResponse;

  const DashboardState({
    this.selectedDrawerOption = "Dashboard",
    this.totalBalance = const [],
    this.transferCalculator = const TransferCalculatorModel(
      fromCurrency: 'USD',
      toCurrency: 'INR',
      amount: 0.0,
      exchangeRate: 89.4,
      platformFee: 542.02,
      estimatedAmount: 0.0,
    ),
    this.availableCurrencies = const [],
    this.currencyOptions = const [],
    this.isCalculating = false,
    required this.amountController,
    this.receivingSelectedCountry,
    this.receivingSelectedCurrencyCode,
    this.isReceivingMenuOpen = false,
    this.balanceResponse,
    this.isOnAddInvoicePage = false,
    this.usedCurrencies = const [],
  });

  @override
  List<Object?> get props => [
    selectedDrawerOption,
    totalBalance,
    transferCalculator,
    availableCurrencies,
    currencyOptions,
    isCalculating,
    amountController,
    receivingSelectedCountry,
    receivingSelectedCurrencyCode,
    isReceivingMenuOpen,
    isOnAddInvoicePage,
    usedCurrencies,
    balanceResponse,
  ];

  DashboardState copyWith({
    String? selectedDrawerOption,
    List<DashboardBalance>? totalBalance,
    TransferCalculatorModel? transferCalculator,
    List<CurrencyModel>? availableCurrencies,
    List<CurrencyOption>? currencyOptions,
    bool? isCalculating,
    TextEditingController? amountController,
    Country? receivingSelectedCountry,
    String? receivingSelectedCurrencyCode,
    bool? isReceivingMenuOpen,
    bool? isOnAddInvoicePage,
    List<String>? usedCurrencies,
    BalanceResponse? balanceResponse,
  }) {
    return DashboardState(
      selectedDrawerOption: selectedDrawerOption ?? this.selectedDrawerOption,
      totalBalance: totalBalance ?? this.totalBalance,
      transferCalculator: transferCalculator ?? this.transferCalculator,
      availableCurrencies: availableCurrencies ?? this.availableCurrencies,
      currencyOptions: currencyOptions ?? this.currencyOptions,
      isCalculating: isCalculating ?? this.isCalculating,
      amountController: amountController ?? this.amountController,
      receivingSelectedCountry:
          receivingSelectedCountry ?? this.receivingSelectedCountry,
      receivingSelectedCurrencyCode:
          receivingSelectedCurrencyCode ?? this.receivingSelectedCurrencyCode,
      isReceivingMenuOpen: isReceivingMenuOpen ?? this.isReceivingMenuOpen,
      isOnAddInvoicePage: isOnAddInvoicePage ?? this.isOnAddInvoicePage,
      usedCurrencies: usedCurrencies ?? this.usedCurrencies,
      balanceResponse: balanceResponse ?? this.balanceResponse,
    );
  }
}
