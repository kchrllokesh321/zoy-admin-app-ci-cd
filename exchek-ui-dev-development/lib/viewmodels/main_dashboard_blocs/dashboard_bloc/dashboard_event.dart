part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
  @override
  List<Object?> get props => [];
}

class DashboardDrawerIndexChanged extends DashboardEvent {
  final String selectedDrawerOption;
  final bool isOnAddInvoicePage;

  const DashboardDrawerIndexChanged({
    required this.selectedDrawerOption,
    this.isOnAddInvoicePage = false,
  });

  @override
  List<Object?> get props => [selectedDrawerOption, isOnAddInvoicePage];
}


class TransferCalculatorAmountChanged extends DashboardEvent {
  final double amount;
  const TransferCalculatorAmountChanged({required this.amount});
  @override
  List<Object?> get props => [amount];
}

class TransferCalculatorFromCurrencyChanged extends DashboardEvent {
  final String currency;
  const TransferCalculatorFromCurrencyChanged({required this.currency});
  @override
  List<Object?> get props => [currency];
}

class TransferCalculatorToCurrencyChanged extends DashboardEvent {
  final String currency;
  const TransferCalculatorToCurrencyChanged({required this.currency});
  @override
  List<Object?> get props => [currency];
}

class TransferCalculatorConvertRequested extends DashboardEvent {
  const TransferCalculatorConvertRequested();
  @override
  List<Object?> get props => [];
}

class CurrencyStarted extends DashboardEvent {
  const CurrencyStarted();
}

class GetCurrency extends DashboardEvent {
  const GetCurrency();
  @override
  List<Object?> get props => [];
}

class GetBalanceResponse extends DashboardEvent {
  const GetBalanceResponse();
  @override
  List<Object?> get props => [];
}

class GetUsedCurrency extends DashboardEvent {
  const GetUsedCurrency();
  @override
  List<Object?> get props => [];
}

class GetCreateCurrency extends DashboardEvent {
  final String currency;
  const GetCreateCurrency({required this.currency});
  @override
  List<Object?> get props => [currency];
}

class TransferCalculatorLoadCurrencies extends DashboardEvent {
  const TransferCalculatorLoadCurrencies();
  @override
  List<Object?> get props => [];
}

// Receiving account popup events
class ReceivingCountryChanged extends DashboardEvent {
  final Country country;
  const ReceivingCountryChanged({required this.country});
  @override
  List<Object?> get props => [country];
}

class ReceivingCurrencyChanged extends DashboardEvent {
  final String currency; // currency code
  const ReceivingCurrencyChanged({required this.currency});
  @override
  List<Object?> get props => [currency];
}

class ReceivingAccountConfirm extends DashboardEvent {
  const ReceivingAccountConfirm();
}

class ReceivingMenuToggled extends DashboardEvent {
  const ReceivingMenuToggled();
}

class ReceivingMenuClosed extends DashboardEvent {
  const ReceivingMenuClosed();
}

class ReceivingMenuOpened extends DashboardEvent {
  const ReceivingMenuOpened();
}

class ResetRequested extends DashboardEvent {
  const ResetRequested();
}
