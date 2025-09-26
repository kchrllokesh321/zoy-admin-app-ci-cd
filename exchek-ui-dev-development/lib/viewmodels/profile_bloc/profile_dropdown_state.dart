import 'package:equatable/equatable.dart';

abstract class ProfileDropdownState extends Equatable {
  const ProfileDropdownState();

  @override
  List<Object> get props => [];
}

class ProfileDropdownInitial extends ProfileDropdownState {}

class ProfileDropdownOpen extends ProfileDropdownState {}

class ProfileDropdownClosed extends ProfileDropdownState {}

class ProfileDropdownLoggingOut extends ProfileDropdownState {}

class ProfileDropdownLogoutSuccess extends ProfileDropdownState {}

class ProfileDropdownLogoutFailure extends ProfileDropdownState {
  final String message;
  const ProfileDropdownLogoutFailure(this.message);

  @override
  List<Object> get props => [message];
}
