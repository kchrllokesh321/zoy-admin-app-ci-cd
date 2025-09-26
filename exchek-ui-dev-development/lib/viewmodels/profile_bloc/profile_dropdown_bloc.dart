import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/viewmodels/profile_bloc/profile_dropdown_event.dart';
import 'package:exchek/viewmodels/profile_bloc/profile_dropdown_state.dart';

class ProfileDropdownBloc extends Bloc<ProfileDropdownEvent, ProfileDropdownState> {
  final AuthRepository authRepository;

  ProfileDropdownBloc({required this.authRepository}) : super(ProfileDropdownInitial()) {
    on<ToggleDropdownEvent>(_onToggleDropdown);
    on<CloseDropdownEvent>(_onCloseDropdown);
    on<LogoutRequestedEvent>(_onLogoutRequested);
    on<LogoutConfirmedEvent>(_onLogoutConfirmed);
    on<LogoutWithEmailRequested>(_onLogoutWithEmailRequested);
  }

  void _onToggleDropdown(ToggleDropdownEvent event, Emitter<ProfileDropdownState> emit) {
    if (state is ProfileDropdownOpen) {
      emit(ProfileDropdownClosed());
    } else {
      emit(ProfileDropdownOpen());
    }
  }

  void _onCloseDropdown(CloseDropdownEvent event, Emitter<ProfileDropdownState> emit) {
    emit(ProfileDropdownClosed());
  }

  void _onLogoutRequested(LogoutRequestedEvent event, Emitter<ProfileDropdownState> emit) {
    emit(ProfileDropdownClosed());
  }

  void _onLogoutConfirmed(LogoutConfirmedEvent event, Emitter<ProfileDropdownState> emit) {
    emit(ProfileDropdownLoggingOut());
  }

  Future<void> _onLogoutWithEmailRequested(LogoutWithEmailRequested event, Emitter<ProfileDropdownState> emit) async {
    emit(ProfileDropdownLoggingOut());
    try {
      final response = await authRepository.logout(email: event.email);

      if (response.success == true) {
        emit(ProfileDropdownLogoutSuccess());
        Prefobj.preferences.deleteAll();
        GoRouter.of(event.context).go(RouteUri.loginRoute);
      } else {
        emit(ProfileDropdownLogoutFailure(response.message ?? 'Logout failed'));
      }
    } catch (e) {
      Logger.error('Error logging out: $e');
    }
  }
}
