part of 'theme_bloc.dart';

class ThemeState {
  final bool isDarkThemeOn;
  final bool followSystemTheme;

  ThemeState({required this.isDarkThemeOn, required this.followSystemTheme});

  ThemeState copyWith({
    bool? isDarkThemeOn,
    bool? followSystemTheme,
  }) {
    return ThemeState(
      isDarkThemeOn: isDarkThemeOn ?? this.isDarkThemeOn,
      followSystemTheme: followSystemTheme ?? this.followSystemTheme,
    );
  }
}
