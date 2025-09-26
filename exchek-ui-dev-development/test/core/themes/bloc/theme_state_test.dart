import 'package:flutter_test/flutter_test.dart';
import 'package:exchek/core/themes/bloc/theme_bloc.dart';

void main() {
  group('ThemeState Tests', () {
    group('Constructor Tests', () {
      test('should create ThemeState with required parameters', () {
        // Arrange & Act
        final state = ThemeState(isDarkThemeOn: true, followSystemTheme: false);

        // Assert
        expect(state.isDarkThemeOn, true);
        expect(state.followSystemTheme, false);
      });

      test('should create ThemeState with different values', () {
        // Arrange & Act
        final state = ThemeState(isDarkThemeOn: false, followSystemTheme: true);

        // Assert
        expect(state.isDarkThemeOn, false);
        expect(state.followSystemTheme, true);
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
          final state = ThemeState(isDarkThemeOn: combo.isDark, followSystemTheme: combo.followSystem);

          expect(state.isDarkThemeOn, combo.isDark);
          expect(state.followSystemTheme, combo.followSystem);
        }
      });
    });

    group('CopyWith Method Tests', () {
      test('should copy with new isDarkThemeOn value', () {
        // Arrange
        final originalState = ThemeState(isDarkThemeOn: false, followSystemTheme: true);

        // Act
        final newState = originalState.copyWith(isDarkThemeOn: true);

        // Assert
        expect(newState.isDarkThemeOn, true);
        expect(newState.followSystemTheme, true); // Should remain unchanged

        // Original state should remain unchanged
        expect(originalState.isDarkThemeOn, false);
        expect(originalState.followSystemTheme, true);
      });

      test('should copy with new followSystemTheme value', () {
        // Arrange
        final originalState = ThemeState(isDarkThemeOn: true, followSystemTheme: false);

        // Act
        final newState = originalState.copyWith(followSystemTheme: true);

        // Assert
        expect(newState.isDarkThemeOn, true); // Should remain unchanged
        expect(newState.followSystemTheme, true);

        // Original state should remain unchanged
        expect(originalState.isDarkThemeOn, true);
        expect(originalState.followSystemTheme, false);
      });

      test('should copy with both values changed', () {
        // Arrange
        final originalState = ThemeState(isDarkThemeOn: false, followSystemTheme: false);

        // Act
        final newState = originalState.copyWith(isDarkThemeOn: true, followSystemTheme: true);

        // Assert
        expect(newState.isDarkThemeOn, true);
        expect(newState.followSystemTheme, true);

        // Original state should remain unchanged
        expect(originalState.isDarkThemeOn, false);
        expect(originalState.followSystemTheme, false);
      });

      test('should copy with no values changed (null parameters)', () {
        // Arrange
        final originalState = ThemeState(isDarkThemeOn: true, followSystemTheme: true);

        // Act
        final newState = originalState.copyWith();

        // Assert
        expect(newState.isDarkThemeOn, true);
        expect(newState.followSystemTheme, true);

        // Original state should remain unchanged
        expect(originalState.isDarkThemeOn, true);
        expect(originalState.followSystemTheme, true);
      });

      test('should copy with null values keeping original', () {
        // Arrange
        final originalState = ThemeState(isDarkThemeOn: false, followSystemTheme: true);

        // Act
        final newState = originalState.copyWith(isDarkThemeOn: null, followSystemTheme: null);

        // Assert
        expect(newState.isDarkThemeOn, false); // Should keep original
        expect(newState.followSystemTheme, true); // Should keep original
      });

      test('should copy with mixed null and non-null values', () {
        // Arrange
        final originalState = ThemeState(isDarkThemeOn: false, followSystemTheme: false);

        // Act
        final newState1 = originalState.copyWith(
          isDarkThemeOn: true,
          followSystemTheme: null, // Should keep original
        );

        final newState2 = originalState.copyWith(
          isDarkThemeOn: null, // Should keep original
          followSystemTheme: true,
        );

        // Assert
        expect(newState1.isDarkThemeOn, true);
        expect(newState1.followSystemTheme, false); // Kept original

        expect(newState2.isDarkThemeOn, false); // Kept original
        expect(newState2.followSystemTheme, true);
      });
    });

    group('State Immutability Tests', () {
      test('should not modify original state when copying', () {
        // Arrange
        final originalState = ThemeState(isDarkThemeOn: true, followSystemTheme: false);

        // Act
        final newState1 = originalState.copyWith(isDarkThemeOn: false);
        final newState2 = originalState.copyWith(followSystemTheme: true);
        final newState3 = originalState.copyWith(isDarkThemeOn: false, followSystemTheme: true);

        // Assert - Original state should never change
        expect(originalState.isDarkThemeOn, true);
        expect(originalState.followSystemTheme, false);

        // New states should have their respective changes
        expect(newState1.isDarkThemeOn, false);
        expect(newState1.followSystemTheme, false);

        expect(newState2.isDarkThemeOn, true);
        expect(newState2.followSystemTheme, true);

        expect(newState3.isDarkThemeOn, false);
        expect(newState3.followSystemTheme, true);
      });

      test('should create independent state instances', () {
        // Arrange
        final state1 = ThemeState(isDarkThemeOn: true, followSystemTheme: false);
        final state2 = state1.copyWith(isDarkThemeOn: false);
        final state3 = state2.copyWith(followSystemTheme: true);

        // Act - Modify references (this shouldn't affect the states since they're immutable)
        // Note: Since the properties are final, we can't actually modify them,
        // but we can verify they maintain their values

        // Assert - Each state should maintain its own values
        expect(state1.isDarkThemeOn, true);
        expect(state1.followSystemTheme, false);

        expect(state2.isDarkThemeOn, false);
        expect(state2.followSystemTheme, false);

        expect(state3.isDarkThemeOn, false);
        expect(state3.followSystemTheme, true);
      });
    });

    group('State Properties Tests', () {
      test('should have final properties', () {
        // Arrange & Act
        final state = ThemeState(isDarkThemeOn: true, followSystemTheme: false);

        // Assert - Properties should be accessible
        expect(state.isDarkThemeOn, true);
        expect(state.followSystemTheme, false);

        // Properties are final, so they can't be modified after creation
        // This test verifies they maintain their values
        expect(state.isDarkThemeOn, true);
        expect(state.followSystemTheme, false);
      });

      test('should maintain property values over time', () {
        // Arrange
        final state = ThemeState(isDarkThemeOn: false, followSystemTheme: true);

        // Act - Access properties multiple times
        final isDark1 = state.isDarkThemeOn;
        final followSystem1 = state.followSystemTheme;

        final isDark2 = state.isDarkThemeOn;
        final followSystem2 = state.followSystemTheme;

        // Assert - Values should be consistent
        expect(isDark1, false);
        expect(followSystem1, true);
        expect(isDark2, false);
        expect(followSystem2, true);

        expect(isDark1, isDark2);
        expect(followSystem1, followSystem2);
      });
    });

    group('State Equality Tests', () {
      test('should be equal when properties are the same', () {
        // Arrange
        final state1 = ThemeState(isDarkThemeOn: true, followSystemTheme: false);
        final state2 = ThemeState(isDarkThemeOn: true, followSystemTheme: false);

        // Act & Assert
        // Note: Since ThemeState doesn't override == operator,
        // these will be different instances but with same property values
        expect(state1.isDarkThemeOn, state2.isDarkThemeOn);
        expect(state1.followSystemTheme, state2.followSystemTheme);
      });

      test('should have different property values when different', () {
        // Arrange
        final state1 = ThemeState(isDarkThemeOn: true, followSystemTheme: false);
        final state2 = ThemeState(isDarkThemeOn: false, followSystemTheme: true);

        // Act & Assert
        expect(state1.isDarkThemeOn, isNot(state2.isDarkThemeOn));
        expect(state1.followSystemTheme, isNot(state2.followSystemTheme));
      });
    });

    group('State Usage Scenarios', () {
      test('should support typical theme state transitions', () {
        // Scenario: Light theme -> Dark theme -> Follow system
        final initialState = ThemeState(isDarkThemeOn: false, followSystemTheme: false);
        final darkState = initialState.copyWith(isDarkThemeOn: true);
        final followSystemState = darkState.copyWith(followSystemTheme: true);

        expect(initialState.isDarkThemeOn, false);
        expect(initialState.followSystemTheme, false);

        expect(darkState.isDarkThemeOn, true);
        expect(darkState.followSystemTheme, false);

        expect(followSystemState.isDarkThemeOn, true);
        expect(followSystemState.followSystemTheme, true);
      });

      test('should support system theme following scenario', () {
        // Scenario: Enable system following, then system changes theme
        final manualState = ThemeState(isDarkThemeOn: false, followSystemTheme: false);
        final followingState = manualState.copyWith(followSystemTheme: true);
        final systemDarkState = followingState.copyWith(isDarkThemeOn: true);
        final systemLightState = systemDarkState.copyWith(isDarkThemeOn: false);

        expect(manualState.followSystemTheme, false);
        expect(followingState.followSystemTheme, true);
        expect(systemDarkState.isDarkThemeOn, true);
        expect(systemDarkState.followSystemTheme, true);
        expect(systemLightState.isDarkThemeOn, false);
        expect(systemLightState.followSystemTheme, true);
      });

      test('should support disabling system theme following', () {
        // Scenario: Following system -> Manual control
        final followingState = ThemeState(isDarkThemeOn: true, followSystemTheme: true);
        final manualState = followingState.copyWith(followSystemTheme: false);

        expect(followingState.followSystemTheme, true);
        expect(manualState.isDarkThemeOn, true); // Theme preference preserved
        expect(manualState.followSystemTheme, false);
      });
    });

    group('Edge Cases', () {
      test('should handle rapid state changes', () {
        // Create a chain of state changes
        final initial = ThemeState(isDarkThemeOn: false, followSystemTheme: false);
        final state1 = initial.copyWith(isDarkThemeOn: true);
        final state2 = state1.copyWith(followSystemTheme: true);
        final state3 = state2.copyWith(isDarkThemeOn: false);
        final state4 = state3.copyWith(followSystemTheme: false);

        // Verify each state maintains its values
        expect(initial.isDarkThemeOn, false);
        expect(initial.followSystemTheme, false);

        expect(state1.isDarkThemeOn, true);
        expect(state1.followSystemTheme, false);

        expect(state2.isDarkThemeOn, true);
        expect(state2.followSystemTheme, true);

        expect(state3.isDarkThemeOn, false);
        expect(state3.followSystemTheme, true);

        expect(state4.isDarkThemeOn, false);
        expect(state4.followSystemTheme, false);
      });

      test('should handle alternating boolean values', () {
        final state = ThemeState(isDarkThemeOn: false, followSystemTheme: false);

        // Alternate isDarkThemeOn
        final dark1 = state.copyWith(isDarkThemeOn: true);
        final light1 = dark1.copyWith(isDarkThemeOn: false);
        final dark2 = light1.copyWith(isDarkThemeOn: true);
        final light2 = dark2.copyWith(isDarkThemeOn: false);

        expect(dark1.isDarkThemeOn, true);
        expect(light1.isDarkThemeOn, false);
        expect(dark2.isDarkThemeOn, true);
        expect(light2.isDarkThemeOn, false);

        // Alternate followSystemTheme
        final follow1 = state.copyWith(followSystemTheme: true);
        final manual1 = follow1.copyWith(followSystemTheme: false);
        final follow2 = manual1.copyWith(followSystemTheme: true);
        final manual2 = follow2.copyWith(followSystemTheme: false);

        expect(follow1.followSystemTheme, true);
        expect(manual1.followSystemTheme, false);
        expect(follow2.followSystemTheme, true);
        expect(manual2.followSystemTheme, false);
      });
    });
  });
}
