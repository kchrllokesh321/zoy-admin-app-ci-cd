part of 'account_type_selection_bloc.dart';

class AccountTypeState extends Equatable {
  final AccountType? selectedAccountType;
  final bool isLoading;

  const AccountTypeState({this.selectedAccountType, this.isLoading = false});

  @override
  List<Object?> get props => [selectedAccountType, isLoading];

  AccountTypeState copyWith({AccountType? selectedAccountType, bool? isLoading}) {
    return AccountTypeState(
      selectedAccountType: selectedAccountType ?? this.selectedAccountType,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
