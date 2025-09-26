import 'package:flutter_test/flutter_test.dart';
import 'package:exchek/core/themes/bloc/theme_bloc.dart';

void main() {
  group('ThemeEvent Tests', () {
    group('InitializeTheme Event', () {
      test('should create InitializeTheme with correct properties', () {
        // Arrange & Act
        final event = InitializeTheme(isDarkThemeOn: true, followSystemTheme: false);

        // Assert
        expect(event.isDarkThemeOn, true);
        expect(event.followSystemTheme, false);
      });

      test('should create InitializeTheme with different values', () {
        // Arrange & Act
        final event = InitializeTheme(isDarkThemeOn: false, followSystemTheme: true);

        // Assert
        expect(event.isDarkThemeOn, false);
        expect(event.followSystemTheme, true);
      });

      test('should be instance of ThemeEvent', () {
        // Arrange & Act
        final event = InitializeTheme(isDarkThemeOn: true, followSystemTheme: true);

        // Assert
        expect(event, isA<ThemeEvent>());
        expect(event, isA<InitializeTheme>());
      });

      test('should handle all boolean combinations', () {
        // Test all possible boolean combinations
        const combinations = [
          (isDark: true, followSystem: true),
          (isDark: true, followSystem: false),
          (isDark: false, followSystem: true),
          (isDark: false, followSystem: false),
        ];

        for (final combo in combinations) {
          final event = InitializeTheme(isDarkThemeOn: combo.isDark, followSystemTheme: combo.followSystem);

          expect(event.isDarkThemeOn, combo.isDark);
          expect(event.followSystemTheme, combo.followSystem);
        }
      });
    });

    group('ToggleTheme Event', () {
      test('should create ToggleTheme with dark theme enabled', () {
        // Arrange & Act
        final event = ToggleTheme(isDarkThemeOn: true);

        // Assert
        expect(event.isDarkThemeOn, true);
      });

      test('should create ToggleTheme with dark theme disabled', () {
        // Arrange & Act
        final event = ToggleTheme(isDarkThemeOn: false);

        // Assert
        expect(event.isDarkThemeOn, false);
      });

      test('should be instance of ThemeEvent', () {
        // Arrange & Act
        final event = ToggleTheme(isDarkThemeOn: true);

        // Assert
        expect(event, isA<ThemeEvent>());
        expect(event, isA<ToggleTheme>());
      });

      test('should handle boolean values correctly', () {
        // Test true value
        final eventTrue = ToggleTheme(isDarkThemeOn: true);
        expect(eventTrue.isDarkThemeOn, true);

        // Test false value
        final eventFalse = ToggleTheme(isDarkThemeOn: false);
        expect(eventFalse.isDarkThemeOn, false);
      });
    });

    group('SystemThemeChanged Event', () {
      test('should create SystemThemeChanged with dark theme enabled', () {
        // Arrange & Act
        final event = SystemThemeChanged(isDarkThemeOn: true);

        // Assert
        expect(event.isDarkThemeOn, true);
      });

      test('should create SystemThemeChanged with dark theme disabled', () {
        // Arrange & Act
        final event = SystemThemeChanged(isDarkThemeOn: false);

        // Assert
        expect(event.isDarkThemeOn, false);
      });

      test('should be instance of ThemeEvent', () {
        // Arrange & Act
        final event = SystemThemeChanged(isDarkThemeOn: true);

        // Assert
        expect(event, isA<ThemeEvent>());
        expect(event, isA<SystemThemeChanged>());
      });

      test('should handle boolean values correctly', () {
        // Test true value
        final eventTrue = SystemThemeChanged(isDarkThemeOn: true);
        expect(eventTrue.isDarkThemeOn, true);

        // Test false value
        final eventFalse = SystemThemeChanged(isDarkThemeOn: false);
        expect(eventFalse.isDarkThemeOn, false);
      });
    });

    group('Event Type Verification', () {
      test('should distinguish between different event types', () {
        // Arrange
        final initializeEvent = InitializeTheme(isDarkThemeOn: true, followSystemTheme: false);
        final toggleEvent = ToggleTheme(isDarkThemeOn: true);
        final systemEvent = SystemThemeChanged(isDarkThemeOn: true);

        // Assert - All should be ThemeEvent but different specific types
        expect(initializeEvent, isA<ThemeEvent>());
        expect(toggleEvent, isA<ThemeEvent>());
        expect(systemEvent, isA<ThemeEvent>());

        expect(initializeEvent, isA<InitializeTheme>());
        expect(initializeEvent, isNot(isA<ToggleTheme>()));
        expect(initializeEvent, isNot(isA<SystemThemeChanged>()));

        expect(toggleEvent, isA<ToggleTheme>());
        expect(toggleEvent, isNot(isA<InitializeTheme>()));
        expect(toggleEvent, isNot(isA<SystemThemeChanged>()));

        expect(systemEvent, isA<SystemThemeChanged>());
        expect(systemEvent, isNot(isA<InitializeTheme>()));
        expect(systemEvent, isNot(isA<ToggleTheme>()));
      });
    });

    group('Event Properties Immutability', () {
      test('InitializeTheme properties should be final', () {
        // Arrange & Act
        final event = InitializeTheme(isDarkThemeOn: true, followSystemTheme: false);

        // Assert - Properties should be accessible but not modifiable
        expect(event.isDarkThemeOn, true);
        expect(event.followSystemTheme, false);

        // The properties are final, so they can't be changed after creation
        // This test verifies they maintain their values
        expect(event.isDarkThemeOn, true);
        expect(event.followSystemTheme, false);
      });

      test('ToggleTheme properties should be final', () {
        // Arrange & Act
        final event = ToggleTheme(isDarkThemeOn: true);

        // Assert - Property should be accessible but not modifiable
        expect(event.isDarkThemeOn, true);

        // The property is final, so it can't be changed after creation
        expect(event.isDarkThemeOn, true);
      });

      test('SystemThemeChanged properties should be final', () {
        // Arrange & Act
        final event = SystemThemeChanged(isDarkThemeOn: true);

        // Assert - Property should be accessible but not modifiable
        expect(event.isDarkThemeOn, true);

        // The property is final, so it can't be changed after creation
        expect(event.isDarkThemeOn, true);
      });
    });

    group('Event Creation Edge Cases', () {
      test('should handle repeated event creation with same values', () {
        // Create multiple events with same values
        final event1 = InitializeTheme(isDarkThemeOn: true, followSystemTheme: true);
        final event2 = InitializeTheme(isDarkThemeOn: true, followSystemTheme: true);
        final event3 = ToggleTheme(isDarkThemeOn: false);
        final event4 = ToggleTheme(isDarkThemeOn: false);
        final event5 = SystemThemeChanged(isDarkThemeOn: true);
        final event6 = SystemThemeChanged(isDarkThemeOn: true);

        // Each event should maintain its own values
        expect(event1.isDarkThemeOn, true);
        expect(event1.followSystemTheme, true);
        expect(event2.isDarkThemeOn, true);
        expect(event2.followSystemTheme, true);

        expect(event3.isDarkThemeOn, false);
        expect(event4.isDarkThemeOn, false);

        expect(event5.isDarkThemeOn, true);
        expect(event6.isDarkThemeOn, true);
      });

      test('should handle alternating boolean values', () {
        // Create events with alternating values
        final events = [
          ToggleTheme(isDarkThemeOn: true),
          ToggleTheme(isDarkThemeOn: false),
          ToggleTheme(isDarkThemeOn: true),
          ToggleTheme(isDarkThemeOn: false),
        ];

        // Verify alternating pattern
        expect(events[0].isDarkThemeOn, true);
        expect(events[1].isDarkThemeOn, false);
        expect(events[2].isDarkThemeOn, true);
        expect(events[3].isDarkThemeOn, false);
      });
    });

    group('Event Usage Scenarios', () {
      test('should support typical app initialization scenario', () {
        // Scenario: App starts, loads preferences, then user toggles theme
        final initEvent = InitializeTheme(isDarkThemeOn: false, followSystemTheme: true);
        final systemEvent = SystemThemeChanged(isDarkThemeOn: true);
        final toggleEvent = ToggleTheme(isDarkThemeOn: false);

        expect(initEvent.isDarkThemeOn, false);
        expect(initEvent.followSystemTheme, true);
        expect(systemEvent.isDarkThemeOn, true);
        expect(toggleEvent.isDarkThemeOn, false);
      });

      test('should support system theme following scenario', () {
        // Scenario: User enables system theme following, system changes theme
        final initEvent = InitializeTheme(isDarkThemeOn: false, followSystemTheme: true);
        final systemDarkEvent = SystemThemeChanged(isDarkThemeOn: true);
        final systemLightEvent = SystemThemeChanged(isDarkThemeOn: false);

        expect(initEvent.followSystemTheme, true);
        expect(systemDarkEvent.isDarkThemeOn, true);
        expect(systemLightEvent.isDarkThemeOn, false);
      });

      test('should support manual theme control scenario', () {
        // Scenario: User manually controls theme without following system
        final initEvent = InitializeTheme(isDarkThemeOn: false, followSystemTheme: false);
        final toggleDarkEvent = ToggleTheme(isDarkThemeOn: true);
        final toggleLightEvent = ToggleTheme(isDarkThemeOn: false);

        expect(initEvent.followSystemTheme, false);
        expect(toggleDarkEvent.isDarkThemeOn, true);
        expect(toggleLightEvent.isDarkThemeOn, false);
      });
    });
  });
}
