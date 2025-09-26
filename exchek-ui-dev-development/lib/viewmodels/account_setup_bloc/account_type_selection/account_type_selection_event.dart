part of 'account_type_selection_bloc.dart';

abstract class AccountTypeEvent extends Equatable {
  const AccountTypeEvent();

  @override
  List<Object> get props => [];
}

class SelectAccountType extends AccountTypeEvent {
  final AccountType accountType;
  const SelectAccountType(this.accountType);

  @override
  List<Object> get props => [accountType];
}

class GetDropDownOption extends AccountTypeEvent {}
