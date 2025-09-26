part of 'theme_bloc.dart';


abstract class ThemeEvent {}

class InitializeTheme extends ThemeEvent {
  final bool isDarkThemeOn;
  final bool followSystemTheme;

  InitializeTheme({
    required this.isDarkThemeOn,
    required this.followSystemTheme,
  });
}
class ToggleTheme extends ThemeEvent {
  final bool isDarkThemeOn;
  ToggleTheme({required this.isDarkThemeOn});
}

class SystemThemeChanged extends ThemeEvent {
  final bool isDarkThemeOn;
  SystemThemeChanged({required this.isDarkThemeOn});
}
