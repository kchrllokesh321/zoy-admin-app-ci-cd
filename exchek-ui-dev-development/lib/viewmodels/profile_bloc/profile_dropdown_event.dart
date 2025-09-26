import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

abstract class ProfileDropdownEvent extends Equatable {
  const ProfileDropdownEvent();

  @override
  List<Object> get props => [];
}

class ToggleDropdownEvent extends ProfileDropdownEvent {}

class CloseDropdownEvent extends ProfileDropdownEvent {}

class LogoutRequestedEvent extends ProfileDropdownEvent {}

class LogoutConfirmedEvent extends ProfileDropdownEvent {}

class LogoutWithEmailRequested extends ProfileDropdownEvent {
  final String email;
  final BuildContext context;
  const LogoutWithEmailRequested(this.email, this.context);

  @override
  List<Object> get props => [email];
}
