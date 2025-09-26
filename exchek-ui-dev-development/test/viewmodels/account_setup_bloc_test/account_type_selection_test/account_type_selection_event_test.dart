import 'package:flutter_test/flutter_test.dart';
import 'package:exchek/viewmodels/account_setup_bloc/account_type_selection/account_type_selection_bloc.dart';
import 'package:exchek/core/enums/app_enums.dart';

void main() {
  group('AccountTypeEvent Tests', () {
    group('AccountTypeEvent Base Class', () {
      test('should extend Equatable', () {
        // Arrange & Act
        const event = SelectAccountType(AccountType.personal);

        // Assert
        expect(event, isA<AccountTypeEvent>());
      });

      test('should have empty props by default', () {
        // Arrange
        final event = GetDropDownOption();

        // Act & Assert
        expect(event.props, isEmpty);
      });
    });

    group('SelectAccountType Event', () {
      test('should create event with personal account type', () {
        // Arrange & Act
        const event = SelectAccountType(AccountType.personal);

        // Assert
        expect(event.accountType, AccountType.personal);
        expect(event, isA<AccountTypeEvent>());
      });

      test('should create event with business account type', () {
        // Arrange & Act
        const event = SelectAccountType(AccountType.business);

        // Assert
        expect(event.accountType, AccountType.business);
        expect(event, isA<AccountTypeEvent>());
      });

      test('should be equal when account types are the same', () {
        // Arrange
        const event1 = SelectAccountType(AccountType.personal);
        const event2 = SelectAccountType(AccountType.personal);

        // Assert
        expect(event1, equals(event2));
        expect(event1.hashCode, equals(event2.hashCode));
      });

      test('should not be equal when account types differ', () {
        // Arrange
        const event1 = SelectAccountType(AccountType.personal);
        const event2 = SelectAccountType(AccountType.business);

        // Assert
        expect(event1, isNot(equals(event2)));
      });

      test('should have correct props', () {
        // Arrange
        const event = SelectAccountType(AccountType.business);

        // Assert
        expect(event.props, [AccountType.business]);
      });

      test('should be immutable', () {
        // Arrange
        const event = SelectAccountType(AccountType.personal);

        // Assert - Should not be able to modify accountType
        expect(event.accountType, AccountType.personal);
        // The accountType field is final, so it's immutable by design
      });

      test('should handle all AccountType enum values', () {
        // Test personal
        const personalEvent = SelectAccountType(AccountType.personal);
        expect(personalEvent.accountType, AccountType.personal);

        // Test business
        const businessEvent = SelectAccountType(AccountType.business);
        expect(businessEvent.accountType, AccountType.business);
      });

      test('should maintain type safety', () {
        // Arrange & Act
        const event = SelectAccountType(AccountType.personal);

        // Assert
        expect(event.accountType, isA<AccountType>());
        expect(event.accountType.toString(), 'AccountType.personal');
      });
    });

    group('GetDropDownOption Event', () {
      test('should create event successfully', () {
        // Arrange & Act
        final event = GetDropDownOption();

        // Assert
        expect(event, isA<AccountTypeEvent>());
        expect(event, isA<GetDropDownOption>());
      });

      test('should be equal to other GetDropDownOption instances', () {
        // Arrange
        final event1 = GetDropDownOption();
        final event2 = GetDropDownOption();

        // Assert
        expect(event1, equals(event2));
        expect(event1.hashCode, equals(event2.hashCode));
      });

      test('should have empty props', () {
        // Arrange
        final event = GetDropDownOption();

        // Assert
        expect(event.props, isEmpty);
      });

      test('should be immutable', () {
        // Arrange & Act
        final event = GetDropDownOption();

        // Assert - Event has no mutable fields
        expect(event, isA<GetDropDownOption>());
      });

      test('should be singleton-like in behavior', () {
        // Arrange
        final event1 = GetDropDownOption();
        final event2 = GetDropDownOption();

        // Assert - All instances should be equal
        expect(event1, equals(event2));
        expect(event1.runtimeType, equals(event2.runtimeType));
      });
    });

    group('Event Inheritance', () {
      test('SelectAccountType should extend AccountTypeEvent', () {
        // Arrange & Act
        const event = SelectAccountType(AccountType.personal);

        // Assert
        expect(event, isA<AccountTypeEvent>());
      });

      test('GetDropDownOption should extend AccountTypeEvent', () {
        // Arrange & Act
        final event = GetDropDownOption();

        // Assert
        expect(event, isA<AccountTypeEvent>());
      });

      test('should not be equal across different event types', () {
        // Arrange
        final selectEvent = SelectAccountType(AccountType.personal);
        final dropdownEvent = GetDropDownOption();

        // Assert
        expect(selectEvent, isNot(equals(dropdownEvent)));
      });
    });

    group('Event Creation Patterns', () {
      test('should support const constructor for SelectAccountType', () {
        // Arrange & Act
        const event = SelectAccountType(AccountType.personal);

        // Assert
        expect(event, isNotNull);
        expect(event.accountType, AccountType.personal);
      });

      test('should support const constructor for GetDropDownOption', () {
        // Arrange & Act
        final event = GetDropDownOption();

        // Assert
        expect(event, isNotNull);
      });

      test('should create multiple SelectAccountType events with different types', () {
        // Arrange & Act
        const personalEvent = SelectAccountType(AccountType.personal);
        const businessEvent = SelectAccountType(AccountType.business);

        // Assert
        expect(personalEvent.accountType, AccountType.personal);
        expect(businessEvent.accountType, AccountType.business);
        expect(personalEvent, isNot(equals(businessEvent)));
      });
    });

    group('Usage Scenarios', () {
      test('should represent user selecting personal account', () {
        // Arrange & Act
        const event = SelectAccountType(AccountType.personal);

        // Assert
        expect(event.accountType, AccountType.personal);
        expect(event, isA<SelectAccountType>());
      });

      test('should represent user selecting business account', () {
        // Arrange & Act
        const event = SelectAccountType(AccountType.business);

        // Assert
        expect(event.accountType, AccountType.business);
        expect(event, isA<SelectAccountType>());
      });

      test('should represent fetching dropdown options', () {
        // Arrange & Act
        final event = GetDropDownOption();

        // Assert
        expect(event, isA<GetDropDownOption>());
      });

      test('should handle typical user flow events', () {
        // Arrange - Simulate user flow
        const selectPersonal = SelectAccountType(AccountType.personal);
        final fetchOptions = GetDropDownOption();
        const selectBusiness = SelectAccountType(AccountType.business);

        // Assert
        expect(selectPersonal.accountType, AccountType.personal);
        expect(fetchOptions, isA<GetDropDownOption>());
        expect(selectBusiness.accountType, AccountType.business);

        // Events should be different
        expect(selectPersonal, isNot(equals(selectBusiness)));
        expect(selectPersonal, isNot(equals(fetchOptions)));
      });
    });

    group('Edge Cases and Error Handling', () {
      test('should handle enum boundary values', () {
        // Test all enum values
        for (final accountType in AccountType.values) {
          final event = SelectAccountType(accountType);
          expect(event.accountType, accountType);
          expect(event, isA<SelectAccountType>());
        }
      });

      test('should maintain consistency across multiple instantiations', () {
        // Arrange & Act
        final events = List.generate(5, (_) => const SelectAccountType(AccountType.personal));

        // Assert
        for (int i = 0; i < events.length - 1; i++) {
          expect(events[i], equals(events[i + 1]));
          expect(events[i].accountType, events[i + 1].accountType);
        }
      });

      test('should maintain consistency for GetDropDownOption', () {
        // Arrange & Act
        final events = List.generate(5, (_) => GetDropDownOption());

        // Assert
        for (int i = 0; i < events.length - 1; i++) {
          expect(events[i], equals(events[i + 1]));
        }
      });
    });

    group('Type Safety and Runtime Checks', () {
      test('should maintain type information at runtime', () {
        // Arrange
        const selectEvent = SelectAccountType(AccountType.personal);
        final dropdownEvent = GetDropDownOption();

        // Assert
        expect(selectEvent.runtimeType.toString(), 'SelectAccountType');
        expect(dropdownEvent.runtimeType.toString(), 'GetDropDownOption');
      });

      test('should be distinguishable by type', () {
        // Arrange
        const selectEvent = SelectAccountType(AccountType.personal);
        final dropdownEvent = GetDropDownOption();

        // Assert
        expect(selectEvent is SelectAccountType, true);
        expect(selectEvent is GetDropDownOption, false);
        expect(dropdownEvent is GetDropDownOption, true);
        expect(dropdownEvent is SelectAccountType, false);
      });
    });
  });
}
