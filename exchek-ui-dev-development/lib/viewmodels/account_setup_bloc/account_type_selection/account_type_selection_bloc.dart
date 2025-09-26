import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/models/personal_user_models/get_option_model.dart';

part 'account_type_selection_event.dart';
part 'account_type_selection_state.dart';

class AccountTypeBloc extends Bloc<AccountTypeEvent, AccountTypeState> {
  final AuthRepository _authRepository;

  AccountTypeBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AccountTypeState()) {
    on<SelectAccountType>(_onSelectAccountType);
    on<GetDropDownOption>(_onGetDropDownOption);
  }

  _onSelectAccountType(SelectAccountType event, Emitter<AccountTypeState> emit) {
    emit(state.copyWith(selectedAccountType: event.accountType));
  }

  Future<void> _onGetDropDownOption(GetDropDownOption event, Emitter<AccountTypeState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      final GetDropdownOptionModel response = await _authRepository.getDropdownOptions();
      if (response.success == true) {
        await Prefobj.preferences.put(Prefkeys.exportsGood, jsonEncode(response.data?.business?.exportOfGoods));
        await Prefobj.preferences.put(Prefkeys.exportServices, jsonEncode(response.data?.business?.exportOfServices));
        await Prefobj.preferences.put(
          Prefkeys.exportGoodsServices,
          jsonEncode(response.data?.business?.exportOfGoodsServices),
        );
        await Prefobj.preferences.put(Prefkeys.freelancer, jsonEncode(response.data?.personal?.freelancer));
        emit(state.copyWith(isLoading: false));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      Logger.error(e.toString());
      emit(state.copyWith(isLoading: false));
    }
  }
}
