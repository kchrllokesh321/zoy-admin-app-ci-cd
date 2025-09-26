import 'package:flutter_test/flutter_test.dart';
import 'package:exchek/core/themes/bloc/theme_bloc.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeBloc Tests', () {
    ThemeBloc? themeBloc;

    tearDown(() async {
      if (themeBloc != null) {
        await themeBloc!.close();
        themeBloc = null;
      }
    });

    group('Initial State', () {
      test('should have correct initial state', () async {
        // Arrange & Act
        themeBloc = ThemeBloc();

        // Wait for initialization to complete
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert - Initial state should be set to defaults
        expect(themeBloc!.state.isDarkThemeOn, false);
        expect(themeBloc!.state.followSystemTheme, false);
      });
    });

    group('InitializeTheme Event', () {
      test('should handle InitializeTheme event with dark theme', () async {
        // Arrange
        final bloc = ThemeBloc();
        await Future.delayed(const Duration(milliseconds: 100)); // Wait for initial load

        // Act
        bloc.add(InitializeTheme(isDarkThemeOn: true, followSystemTheme: true));
        await Future.delayed(const Duration(milliseconds: 100)); // Wait for event processing

        // Assert
        expect(bloc.state.isDarkThemeOn, true);
        expect(bloc.state.followSystemTheme, true);

        // Cleanup
        await bloc.close();
      });

      test('should handle InitializeTheme event with light theme', () async {
        // Arrange
        final bloc = ThemeBloc();
        await Future.delayed(const Duration(milliseconds: 100)); // Wait for initial load

        // Act
        bloc.add(InitializeTheme(isDarkThemeOn: false, followSystemTheme: false));
        await Future.delayed(const Duration(milliseconds: 100)); // Wait for event processing

        // Assert
        expect(bloc.state.isDarkThemeOn, false);
        expect(bloc.state.followSystemTheme, false);

        // Cleanup
        await bloc.close();
      });
    });

    group('ToggleTheme Event', () {
      test('should create ToggleTheme event with dark theme enabled', () {
        // Arrange & Act
        final event = ToggleTheme(isDarkThemeOn: true);

        // Assert
        expect(event.isDarkThemeOn, true);
        expect(event, isA<ThemeEvent>());
      });

      test('should create ToggleTheme event with dark theme disabled', () {
        // Arrange & Act
        final event = ToggleTheme(isDarkThemeOn: false);

        // Assert
        expect(event.isDarkThemeOn, false);
        expect(event, isA<ThemeEvent>());
      });

      test('should handle ToggleTheme event creation with different values', () {
        // Arrange & Act
        final darkEvent = ToggleTheme(isDarkThemeOn: true);
        final lightEvent = ToggleTheme(isDarkThemeOn: false);

        // Assert
        expect(darkEvent.isDarkThemeOn, true);
        expect(lightEvent.isDarkThemeOn, false);
        expect(darkEvent, isA<ToggleTheme>());
        expect(lightEvent, isA<ToggleTheme>());
      });
    });

    group('SystemThemeChanged Event', () {
      test('should update theme when following system theme', () async {
        // Arrange
        final bloc = ThemeBloc();
        await Future.delayed(const Duration(milliseconds: 100)); // Wait for initial load

        // Set up the bloc to follow system theme
        bloc.add(InitializeTheme(isDarkThemeOn: false, followSystemTheme: true));
        await Future.delayed(const Duration(milliseconds: 100));

        // Act - Simulate system theme change
        bloc.add(SystemThemeChanged(isDarkThemeOn: true));
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert - Should update theme when following system
        expect(bloc.state.followSystemTheme, true);
        expect(bloc.state.isDarkThemeOn, true); // Should have updated to dark theme

        // Cleanup
        await bloc.close();
      });

      test('should not update theme when not following system theme', () async {
        // Arrange
        final bloc = ThemeBloc();
        await Future.delayed(const Duration(milliseconds: 100)); // Wait for initial load

        // Set up the bloc to NOT follow system theme
        bloc.add(InitializeTheme(isDarkThemeOn: false, followSystemTheme: false));
        await Future.delayed(const Duration(milliseconds: 100));

        final stateBefore = bloc.state;

        // Act - Simulate system theme change
        bloc.add(SystemThemeChanged(isDarkThemeOn: true));
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert - Should NOT update theme when not following system
        expect(bloc.state.followSystemTheme, false);
        expect(bloc.state.isDarkThemeOn, stateBefore.isDarkThemeOn); // Should remain unchanged

        // Cleanup
        await bloc.close();
      });

      test('should create SystemThemeChanged event correctly', () {
        // Arrange & Act
        final darkEvent = SystemThemeChanged(isDarkThemeOn: true);
        final lightEvent = SystemThemeChanged(isDarkThemeOn: false);

        // Assert
        expect(darkEvent.isDarkThemeOn, true);
        expect(lightEvent.isDarkThemeOn, false);
        expect(darkEvent, isA<ThemeEvent>());
        expect(lightEvent, isA<ThemeEvent>());
      });
    });

    group('State Management', () {
      test('should create ThemeState with copyWith method', () {
        // Arrange
        final originalState = ThemeState(isDarkThemeOn: false, followSystemTheme: false);

        // Act
        final newState = originalState.copyWith(isDarkThemeOn: true);

        // Assert
        expect(newState.isDarkThemeOn, true);
        expect(newState.followSystemTheme, false);
      });

      test('should create ThemeState with all parameters', () {
        // Arrange & Act
        final state = ThemeState(isDarkThemeOn: true, followSystemTheme: true);

        // Assert
        expect(state.isDarkThemeOn, true);
        expect(state.followSystemTheme, true);
      });

      test('should handle copyWith with both parameters', () {
        // Arrange
        final originalState = ThemeState(isDarkThemeOn: false, followSystemTheme: false);

        // Act
        final newState = originalState.copyWith(isDarkThemeOn: true, followSystemTheme: true);

        // Assert
        expect(newState.isDarkThemeOn, true);
        expect(newState.followSystemTheme, true);
      });

      test('should handle copyWith with null parameters', () {
        // Arrange
        final originalState = ThemeState(isDarkThemeOn: true, followSystemTheme: true);

        // Act
        final newState = originalState.copyWith();

        // Assert
        expect(newState.isDarkThemeOn, true);
        expect(newState.followSystemTheme, true);
      });
    });

    group('Event Creation', () {
      test('should create InitializeTheme event', () {
        // Arrange & Act
        final event = InitializeTheme(isDarkThemeOn: true, followSystemTheme: false);

        // Assert
        expect(event.isDarkThemeOn, true);
        expect(event.followSystemTheme, false);
      });

      test('should create ToggleTheme event', () {
        // Arrange & Act
        final event = ToggleTheme(isDarkThemeOn: true);

        // Assert
        expect(event.isDarkThemeOn, true);
      });

      test('should create SystemThemeChanged event', () {
        // Arrange & Act
        final event = SystemThemeChanged(isDarkThemeOn: false);

        // Assert
        expect(event.isDarkThemeOn, false);
      });
    });

    group('Bloc Lifecycle', () {
      test('should properly initialize and dispose', () async {
        // Arrange & Act
        themeBloc = ThemeBloc();

        // Wait a bit for initialization to complete
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert - Bloc should be created without errors
        expect(themeBloc!.state, isA<ThemeState>());
        expect(themeBloc!.state.isDarkThemeOn, isA<bool>());
        expect(themeBloc!.state.followSystemTheme, isA<bool>());

        // Cleanup
        await themeBloc!.close();
        themeBloc = null; // Set to null after closing
      });

      test('should handle close properly', () async {
        // Arrange
        final bloc = ThemeBloc();
        await Future.delayed(const Duration(milliseconds: 100));

        // Act
        await bloc.close();

        // Assert
        expect(bloc.isClosed, true);
      });
    });

    group('ToggleTheme Event Logic', () {
      test('should create ToggleTheme events correctly', () {
        // Arrange & Act
        final darkToggle = ToggleTheme(isDarkThemeOn: true);
        final lightToggle = ToggleTheme(isDarkThemeOn: false);

        // Assert
        expect(darkToggle.isDarkThemeOn, true);
        expect(lightToggle.isDarkThemeOn, false);
        expect(darkToggle, isA<ThemeEvent>());
        expect(lightToggle, isA<ThemeEvent>());
      });

      test('should handle ToggleTheme event properties', () {
        // Arrange & Act
        final toggleEvent = ToggleTheme(isDarkThemeOn: true);

        // Assert
        expect(toggleEvent, isA<ToggleTheme>());
        expect(toggleEvent.isDarkThemeOn, true);
      });
    });

    group('Initialization Coverage', () {
      test('should handle initialization process', () async {
        // Arrange & Act
        final bloc = ThemeBloc();

        // Wait for initialization to complete
        await Future.delayed(const Duration(milliseconds: 200));

        // Assert - Bloc should be initialized with default values
        expect(bloc.state, isA<ThemeState>());
        expect(bloc.state.isDarkThemeOn, false); // Default value when storage fails
        expect(bloc.state.followSystemTheme, false); // Default value when storage fails

        // Cleanup
        await bloc.close();
      });

      test('should handle concurrent bloc creation', () async {
        // Arrange & Act - Create multiple blocs concurrently
        final blocs = <ThemeBloc>[];

        for (int i = 0; i < 3; i++) {
          final bloc = ThemeBloc();
          blocs.add(bloc);
        }

        // Wait for all initializations to complete
        await Future.delayed(const Duration(milliseconds: 300));

        // Assert - All blocs should be properly initialized
        for (final bloc in blocs) {
          expect(bloc.state, isA<ThemeState>());
          expect(bloc.state.isDarkThemeOn, isA<bool>());
          expect(bloc.state.followSystemTheme, isA<bool>());
        }

        // Cleanup
        for (final bloc in blocs) {
          await bloc.close();
        }
      });
    });
  });
}
