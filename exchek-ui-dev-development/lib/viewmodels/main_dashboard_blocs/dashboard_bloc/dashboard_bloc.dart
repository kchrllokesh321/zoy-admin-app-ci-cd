import 'package:equatable/equatable.dart';
import 'package:country_picker/country_picker.dart';
import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/models/invoice_models/invoice_model.dart';
import 'package:exchek/models/personal_user_models/get_currency_model.dart';
import 'package:exchek/repository/dashboard_repository.dart';
import 'package:exchek/views/main_dashboard_view/dashboard_view.dart';
import 'package:exchek/models/transfer_calculator_model.dart';
part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository dashboardRepository;
  DashboardBloc({required this.dashboardRepository})
    : super(
        DashboardState(
          availableCurrencies: [
            CurrencyModel(code: 'USD', name: 'US Dollar', symbol: '\$'),
            CurrencyModel(code: 'EUR', name: 'Euro', symbol: '€'),
            CurrencyModel(code: 'GBP', name: 'British Pound', symbol: '£'),
            CurrencyModel(code: 'INR', name: 'Indian Rupee', symbol: '₹'),
            CurrencyModel(code: 'AED', name: 'UAE Dirham', symbol: 'د.إ'),
            CurrencyModel(code: 'CAD', name: 'Canadian Dollar', symbol: 'C\$'),
            CurrencyModel(code: 'AUD', name: 'Australian Dollar', symbol: 'A\$'),
            CurrencyModel(code: 'JPY', name: 'Japanese Yen', symbol: '¥'),
          ],
          amountController: TextEditingController(),
        ),
      ) {
    // on<DashboardDrawerIndexChanged>(_onDashboardDrawerIndexChanged);
    on<TransferCalculatorAmountChanged>(_onTransferCalculatorAmountChanged);
    on<TransferCalculatorFromCurrencyChanged>(_onTransferCalculatorFromCurrencyChanged);
    on<TransferCalculatorToCurrencyChanged>(_onTransferCalculatorToCurrencyChanged);
    on<TransferCalculatorConvertRequested>(_onTransferCalculatorConvertRequested);
    on<TransferCalculatorLoadCurrencies>(_onTransferCalculatorLoadCurrencies);
    on<ReceivingCountryChanged>(_onReceivingCountryChanged);
    on<ReceivingCurrencyChanged>(_onReceivingCurrencyChanged);
    on<ReceivingAccountConfirm>(_onReceivingAccountConfirm);
    on<ReceivingMenuToggled>(_onReceivingMenuToggled);
    on<ReceivingMenuClosed>(_onReceivingMenuClosed);
    on<ReceivingMenuOpened>(_onReceivingMenuOpened);
    on<DashboardDrawerIndexChanged>((event, emit) {
      emit(
        state.copyWith(selectedDrawerOption: event.selectedDrawerOption, isOnAddInvoicePage: event.isOnAddInvoicePage),
      );
    });
    on<GetCurrency>(_onGetCurrencylist);
    on<GetUsedCurrency>(_onGetUsedCurrencys);
    on<GetCreateCurrency>(_onCreateCurrency);
    on<GetBalanceResponse>(_onGetBalanceResponse);
    on<CurrencyStarted>(_onCurrencyStarted);
    on<ResetRequested>((event, emit) {
      emit(
        state.copyWith(
          selectedDrawerOption: "Dashboard",
          isOnAddInvoicePage: false,
          // reset any other needed fields...
        ),
      );
    });
  }

  // void _onDashboardDrawerIndexChanged(DashboardDrawerIndexChanged event, Emitter<DashboardState> emit) {
  //   emit(state.copyWith(selectedDrawerOption: event.selectedDrawerOption));
  // }

  void _onTransferCalculatorAmountChanged(TransferCalculatorAmountChanged event, Emitter<DashboardState> emit) {
    final updatedCalculator = state.transferCalculator.copyWith(amount: event.amount);
    emit(state.copyWith(transferCalculator: updatedCalculator));
  }

  void _onTransferCalculatorFromCurrencyChanged(
    TransferCalculatorFromCurrencyChanged event,
    Emitter<DashboardState> emit,
  ) {
    final updatedCalculator = state.transferCalculator.copyWith(fromCurrency: event.currency);
    emit(state.copyWith(transferCalculator: updatedCalculator));
  }

  void _onTransferCalculatorToCurrencyChanged(TransferCalculatorToCurrencyChanged event, Emitter<DashboardState> emit) {
    final updatedCalculator = state.transferCalculator.copyWith(toCurrency: event.currency);
    emit(state.copyWith(transferCalculator: updatedCalculator));
  }

  void _onReceivingCountryChanged(ReceivingCountryChanged event, Emitter<DashboardState> emit) {
    emit(state.copyWith(receivingSelectedCountry: event.country));
  }

  void _onReceivingCurrencyChanged(ReceivingCurrencyChanged event, Emitter<DashboardState> emit) {
    emit(state.copyWith(receivingSelectedCurrencyCode: event.currency));
  }

  void _onReceivingAccountConfirm(ReceivingAccountConfirm event, Emitter<DashboardState> emit) {
    // Close menu after confirmation; in real app, dispatch API call or navigation
    emit(state.copyWith(isReceivingMenuOpen: false));
  }

  void _onReceivingMenuToggled(ReceivingMenuToggled event, Emitter<DashboardState> emit) {
    if (!state.isReceivingMenuOpen) {
      // Menu is opening, clear data
      emit(
        state.copyWith(receivingSelectedCountry: null, receivingSelectedCurrencyCode: null, isReceivingMenuOpen: true),
      );
    } else {
      // Menu is closing
      emit(state.copyWith(isReceivingMenuOpen: false));
    }
  }

  void _onReceivingMenuClosed(ReceivingMenuClosed event, Emitter<DashboardState> emit) {
    if (state.isReceivingMenuOpen) {
      emit(state.copyWith(isReceivingMenuOpen: false));
    }
  }

  void _onReceivingMenuOpened(ReceivingMenuOpened event, Emitter<DashboardState> emit) {
    // Clear selected data when menu opens
    emit(
      state.copyWith(receivingSelectedCountry: null, receivingSelectedCurrencyCode: null, isReceivingMenuOpen: true),
    );
  }

  Future<void> _onTransferCalculatorConvertRequested(
    TransferCalculatorConvertRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isCalculating: true));

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Calculate estimated amount (this would come from API in real implementation)
    final amount = state.transferCalculator.amount;
    final exchangeRate = state.transferCalculator.exchangeRate;
    final platformFee = state.transferCalculator.platformFee;
    final estimatedAmount = (amount * exchangeRate) - platformFee;

    final updatedCalculator = state.transferCalculator.copyWith(
      estimatedAmount: estimatedAmount > 0 ? estimatedAmount : 0.0,
    );

    emit(state.copyWith(transferCalculator: updatedCalculator, isCalculating: false));
  }

  void _onTransferCalculatorLoadCurrencies(TransferCalculatorLoadCurrencies event, Emitter<DashboardState> emit) {
    // Currencies are already loaded in constructor, but this could be used for API calls
  }

  Future<void> _onGetCurrencylist(GetCurrency event, Emitter<DashboardState> emit) async {
    try {
      final response = await dashboardRepository.getNewCurrencyOptions();
      emit(state.copyWith(currencyOptions: response));
    } catch (e) {
      Logger.error(e.toString());
    }
  }

  Future<void> _onCreateCurrency(GetCreateCurrency event, Emitter<DashboardState> emit) async {
    try {
      final selectedCurrency = state.receivingSelectedCurrencyCode;
      final response = await dashboardRepository.createReceivingAccount(currency: selectedCurrency.toString());
      if (response['success'] == true) {
        AppToast.show(message: response['message'], type: ToastificationType.success);
      }
    } catch (e) {
      Logger.error(e.toString());
    }
  }

  Future<void> _onGetUsedCurrencys(GetUsedCurrency event, Emitter<DashboardState> emit) async {
    try {
      final response = await dashboardRepository.getusedCurrencys();
      emit(state.copyWith(usedCurrencies: response.currencies));
    } catch (e) {
      Logger.error(e.toString());
    }
  }

  Future<void> _onGetBalanceResponse(GetBalanceResponse event, Emitter<DashboardState> emit) async {
    try {
      final response = await dashboardRepository.getBalanceResponse();
      emit(state.copyWith(balanceResponse: response));
    } catch (e) {
      Logger.error(e.toString());
    }
  }

  Future<void> _onCurrencyStarted(CurrencyStarted event, Emitter<DashboardState> emit) async {
    try {
      final balResponse = await dashboardRepository.getBalanceResponse();
      final usedCurrencysRsp = await dashboardRepository.getusedCurrencys();
      final responseNewCurrencyOptions = await dashboardRepository.getNewCurrencyOptions();

      // Logger.error(balResponse);
      // Logger.error(usedCurrencysRsp);
      // Logger.error(responseNewCurrencyOptions);

      emit(state.copyWith(currencyOptions: responseNewCurrencyOptions));
      emit(state.copyWith(usedCurrencies: usedCurrencysRsp.currencies));
      emit(state.copyWith(balanceResponse: balResponse));
    } catch (e) {
      Logger.error(e.toString());
    }
  }
}
