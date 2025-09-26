import 'package:exchek/core/utils/exports.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> with WidgetsBindingObserver {
  ThemeBloc() : super(ThemeState(isDarkThemeOn: false, followSystemTheme: false)) {
    on<InitializeTheme>(_onInitializeTheme);
    on<ToggleTheme>(_onToggleTheme);
    on<SystemThemeChanged>(_onSystemThemeChanged);
    WidgetsBinding.instance.addObserver(this);
    _initializeTheme(); // Load initial theme asynchronously
  }

  Future<void> _initializeTheme() async {
    // Retrieve stored preferences asynchronously
    final isDarkThemeOn = await Prefobj.preferences.get(Prefkeys.lightDark) == 'true';
    final followSystemTheme = await Prefobj.preferences.get(Prefkeys.followSystem) == 'true';

    add(InitializeTheme(isDarkThemeOn: isDarkThemeOn, followSystemTheme: followSystemTheme));

    // If following system theme, set the initial system theme
    if (followSystemTheme) {
      final isSystemDark = WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
      add(SystemThemeChanged(isDarkThemeOn: isSystemDark));
    }
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }

  void _onInitializeTheme(InitializeTheme event, Emitter<ThemeState> emit) {
    emit(state.copyWith(isDarkThemeOn: event.isDarkThemeOn, followSystemTheme: event.followSystemTheme));
  }

  void _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) {
    Prefobj.preferences.put(Prefkeys.lightDark, event.isDarkThemeOn.toString());
    Prefobj.preferences.put(Prefkeys.followSystem, 'false');

    emit(state.copyWith(isDarkThemeOn: event.isDarkThemeOn, followSystemTheme: false));
  }

  void _onSystemThemeChanged(SystemThemeChanged event, Emitter<ThemeState> emit) {
    if (state.followSystemTheme) {
      emit(state.copyWith(isDarkThemeOn: event.isDarkThemeOn));
    }
  }
}
