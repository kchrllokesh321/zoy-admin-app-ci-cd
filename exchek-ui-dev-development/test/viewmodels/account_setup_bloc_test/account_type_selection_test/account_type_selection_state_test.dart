import 'package:flutter_test/flutter_test.dart';
import 'package:exchek/viewmodels/account_setup_bloc/account_type_selection/account_type_selection_bloc.dart';
import 'package:exchek/core/enums/app_enums.dart';

void main() {
  group('AccountTypeState Tests', () {
    group('Constructor', () {
      test('should create state with default values', () {
        // Arrange & Act
        const state = AccountTypeState();

        // Assert
        expect(state.selectedAccountType, isNull);
        expect(state.isLoading, false);
      });

      test('should create state with provided values', () {
        // Arrange & Act
        const state = AccountTypeState(selectedAccountType: AccountType.personal, isLoading: true);

        // Assert
        expect(state.selectedAccountType, AccountType.personal);
        expect(state.isLoading, true);
      });

      test('should create state with only selectedAccountType', () {
        // Arrange & Act
        const state = AccountTypeState(selectedAccountType: AccountType.business);

        // Assert
        expect(state.selectedAccountType, AccountType.business);
        expect(state.isLoading, false);
      });

      test('should create state with only isLoading', () {
        // Arrange & Act
        const state = AccountTypeState(isLoading: true);

        // Assert
        expect(state.selectedAccountType, isNull);
        expect(state.isLoading, true);
      });
    });

    group('copyWith Method', () {
      test('should return new state with updated selectedAccountType', () {
        // Arrange
        const originalState = AccountTypeState(selectedAccountType: AccountType.personal, isLoading: false);

        // Act
        final newState = originalState.copyWith(selectedAccountType: AccountType.business);

        // Assert
        expect(newState.selectedAccountType, AccountType.business);
        expect(newState.isLoading, false);
        expect(originalState.selectedAccountType, AccountType.personal); // Original unchanged
      });

      test('should return new state with updated isLoading', () {
        // Arrange
        const originalState = AccountTypeState(selectedAccountType: AccountType.personal, isLoading: false);

        // Act
        final newState = originalState.copyWith(isLoading: true);

        // Assert
        expect(newState.selectedAccountType, AccountType.personal);
        expect(newState.isLoading, true);
        expect(originalState.isLoading, false); // Original unchanged
      });

      test('should return new state with both parameters updated', () {
        // Arrange
        const originalState = AccountTypeState(selectedAccountType: AccountType.personal, isLoading: false);

        // Act
        final newState = originalState.copyWith(selectedAccountType: AccountType.business, isLoading: true);

        // Assert
        expect(newState.selectedAccountType, AccountType.business);
        expect(newState.isLoading, true);
      });

      test('should return new state with no changes when no parameters provided', () {
        // Arrange
        const originalState = AccountTypeState(selectedAccountType: AccountType.personal, isLoading: true);

        // Act
        final newState = originalState.copyWith();

        // Assert
        expect(newState.selectedAccountType, AccountType.personal);
        expect(newState.isLoading, true);
        expect(newState, isNot(same(originalState))); // Different instance
      });

      test('should handle null selectedAccountType in copyWith', () {
        // Arrange
        const originalState = AccountTypeState(selectedAccountType: AccountType.personal, isLoading: false);

        // Act - copyWith doesn't accept null, so this tests the current behavior
        final newState = originalState.copyWith();

        // Assert - Should keep the original value when no parameter is provided
        expect(newState.selectedAccountType, AccountType.personal);
        expect(newState.isLoading, false);
      });
    });

    group('Equality and Props', () {
      test('should be equal when all properties are the same', () {
        // Arrange
        const state1 = AccountTypeState(selectedAccountType: AccountType.personal, isLoading: true);
        const state2 = AccountTypeState(selectedAccountType: AccountType.personal, isLoading: true);

        // Assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should not be equal when selectedAccountType differs', () {
        // Arrange
        const state1 = AccountTypeState(selectedAccountType: AccountType.personal, isLoading: false);
        const state2 = AccountTypeState(selectedAccountType: AccountType.business, isLoading: false);

        // Assert
        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when isLoading differs', () {
        // Arrange
        const state1 = AccountTypeState(selectedAccountType: AccountType.personal, isLoading: true);
        const state2 = AccountTypeState(selectedAccountType: AccountType.personal, isLoading: false);

        // Assert
        expect(state1, isNot(equals(state2)));
      });

      test('should be equal when both have null selectedAccountType', () {
        // Arrange
        const state1 = AccountTypeState(isLoading: false);
        const state2 = AccountTypeState(isLoading: false);

        // Assert
        expect(state1, equals(state2));
      });

      test('should not be equal when one has null selectedAccountType', () {
        // Arrange
        const state1 = AccountTypeState(selectedAccountType: null, isLoading: false);
        const state2 = AccountTypeState(selectedAccountType: AccountType.personal, isLoading: false);

        // Assert
        expect(state1, isNot(equals(state2)));
      });

      test('should have correct props', () {
        // Arrange
        const state = AccountTypeState(selectedAccountType: AccountType.business, isLoading: true);

        // Assert
        expect(state.props, [AccountType.business, true]);
      });

      test('should have correct props with null selectedAccountType', () {
        // Arrange
        const state = AccountTypeState(isLoading: false);

        // Assert
        expect(state.props, [null, false]);
      });
    });

    group('Immutability', () {
      test('should be immutable - copyWith creates new instance', () {
        // Arrange
        const originalState = AccountTypeState(selectedAccountType: AccountType.personal, isLoading: false);

        // Act
        final newState = originalState.copyWith(isLoading: true);

        // Assert
        expect(newState, isNot(same(originalState)));
        expect(originalState.isLoading, false);
        expect(newState.isLoading, true);
      });
    });

    group('Edge Cases', () {
      test('should handle all AccountType enum values', () {
        // Test personal
        const personalState = AccountTypeState(selectedAccountType: AccountType.personal);
        expect(personalState.selectedAccountType, AccountType.personal);

        // Test business
        const businessState = AccountTypeState(selectedAccountType: AccountType.business);
        expect(businessState.selectedAccountType, AccountType.business);
      });

      test('should handle boolean edge cases for isLoading', () {
        // Test true
        const loadingState = AccountTypeState(isLoading: true);
        expect(loadingState.isLoading, true);

        // Test false
        const notLoadingState = AccountTypeState(isLoading: false);
        expect(notLoadingState.isLoading, false);
      });
    });

    group('Usage Scenarios', () {
      test('should represent initial state correctly', () {
        // Arrange & Act
        const initialState = AccountTypeState();

        // Assert
        expect(initialState.selectedAccountType, isNull);
        expect(initialState.isLoading, false);
      });

      test('should represent loading state correctly', () {
        // Arrange & Act
        const loadingState = AccountTypeState(isLoading: true);

        // Assert
        expect(loadingState.isLoading, true);
        expect(loadingState.selectedAccountType, isNull);
      });

      test('should represent account selected state correctly', () {
        // Arrange & Act
        const selectedState = AccountTypeState(selectedAccountType: AccountType.business, isLoading: false);

        // Assert
        expect(selectedState.selectedAccountType, AccountType.business);
        expect(selectedState.isLoading, false);
      });

      test('should represent loading with selection state correctly', () {
        // Arrange & Act
        const state = AccountTypeState(selectedAccountType: AccountType.personal, isLoading: true);

        // Assert
        expect(state.selectedAccountType, AccountType.personal);
        expect(state.isLoading, true);
      });
    });
  });
}
