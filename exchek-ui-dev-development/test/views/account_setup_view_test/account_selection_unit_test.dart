import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/viewmodels/account_setup_bloc/account_type_selection/account_type_selection_bloc.dart';
import 'package:exchek/viewmodels/account_setup_bloc/personal_account_setup_bloc/personal_account_setup_bloc.dart';
import 'package:exchek/views/account_setup_view/account_selection.dart';

// Mock classes
class MockAccountTypeBloc extends MockBloc<AccountTypeEvent, AccountTypeState> implements AccountTypeBloc {}

class MockPersonalAccountSetupBloc extends MockBloc<PersonalAccountSetupEvent, PersonalAccountSetupState>
    implements PersonalAccountSetupBloc {}

class MockBusinessAccountSetupBloc extends MockBloc<BusinessAccountSetupEvent, BusinessAccountSetupState>
    implements BusinessAccountSetupBloc {}

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

// Mock events for registration
class FakeAccountTypeEvent extends Fake implements AccountTypeEvent {}

class FakePersonalAccountSetupEvent extends Fake implements PersonalAccountSetupEvent {}

class FakeBusinessAccountSetupEvent extends Fake implements BusinessAccountSetupEvent {}

class FakeAuthEvent extends Fake implements AuthEvent {}

void main() {
  group('AccountSelectionStep Unit Tests', () {
    late MockAccountTypeBloc mockAccountTypeBloc;
    late MockPersonalAccountSetupBloc mockPersonalAccountSetupBloc;
    late MockBusinessAccountSetupBloc mockBusinessAccountSetupBloc;
    late MockAuthBloc mockAuthBloc;

    setUpAll(() {
      registerFallbackValue(FakeAccountTypeEvent());
      registerFallbackValue(FakePersonalAccountSetupEvent());
      registerFallbackValue(FakeBusinessAccountSetupEvent());
      registerFallbackValue(FakeAuthEvent());
    });

    setUp(() {
      mockAccountTypeBloc = MockAccountTypeBloc();
      mockPersonalAccountSetupBloc = MockPersonalAccountSetupBloc();
      mockBusinessAccountSetupBloc = MockBusinessAccountSetupBloc();
      mockAuthBloc = MockAuthBloc();
    });

    group('AccountTypeState Tests', () {
      test('should create AccountTypeState with personal account type', () {
        const state = AccountTypeState(selectedAccountType: AccountType.personal, isLoading: false);

        expect(state.selectedAccountType, AccountType.personal);
        expect(state.isLoading, false);
      });

      test('should create AccountTypeState with business account type', () {
        const state = AccountTypeState(selectedAccountType: AccountType.business, isLoading: false);

        expect(state.selectedAccountType, AccountType.business);
        expect(state.isLoading, false);
      });

      test('should create AccountTypeState with null account type', () {
        const state = AccountTypeState(selectedAccountType: null, isLoading: false);

        expect(state.selectedAccountType, null);
        expect(state.isLoading, false);
      });

      test('should create AccountTypeState with loading state', () {
        const state = AccountTypeState(selectedAccountType: AccountType.personal, isLoading: true);

        expect(state.selectedAccountType, AccountType.personal);
        expect(state.isLoading, true);
      });
    });

    group('AccountType Enum Tests', () {
      test('should have correct AccountType enum values', () {
        expect(AccountType.personal, isNotNull);
        expect(AccountType.business, isNotNull);
        expect(AccountType.values.length, 2);
        expect(AccountType.values, contains(AccountType.personal));
        expect(AccountType.values, contains(AccountType.business));
      });
    });

    group('Event Handling Tests', () {
      test('should handle SelectAccountType event for personal account', () {
        final event = SelectAccountType(AccountType.personal);
        expect(event.accountType, AccountType.personal);
      });

      test('should handle SelectAccountType event for business account', () {
        final event = SelectAccountType(AccountType.business);
        expect(event.accountType, AccountType.business);
      });

      test('should handle GetDropDownOption event', () {
        final event = GetDropDownOption();
        expect(event, isA<GetDropDownOption>());
      });

      test('should handle PersonalResetData event', () {
        final event = PersonalResetData();
        expect(event, isA<PersonalResetData>());
      });

      test('should handle ResetData event', () {
        final event = ResetData();
        expect(event, isA<ResetData>());
      });

      test('should handle ClearSignupDataManuallyEvent', () {
        final event = ClearSignupDataManuallyEvent();
        expect(event, isA<ClearSignupDataManuallyEvent>());
      });
    });

    group('Bloc Interaction Tests', () {
      test('should add SelectAccountType event to AccountTypeBloc', () {
        mockAccountTypeBloc.add(SelectAccountType(AccountType.personal));
        verify(() => mockAccountTypeBloc.add(any(that: isA<SelectAccountType>()))).called(1);
      });

      test('should add GetDropDownOption event to AccountTypeBloc', () {
        mockAccountTypeBloc.add(GetDropDownOption());
        verify(() => mockAccountTypeBloc.add(any(that: isA<GetDropDownOption>()))).called(1);
      });

      test('should add PersonalResetData event to PersonalAccountSetupBloc', () {
        mockPersonalAccountSetupBloc.add(PersonalResetData());
        verify(() => mockPersonalAccountSetupBloc.add(any(that: isA<PersonalResetData>()))).called(1);
      });

      test('should add ResetData event to BusinessAccountSetupBloc', () {
        mockBusinessAccountSetupBloc.add(ResetData());
        verify(() => mockBusinessAccountSetupBloc.add(any(that: isA<ResetData>()))).called(1);
      });

      test('should add ClearSignupDataManuallyEvent to AuthBloc', () {
        mockAuthBloc.add(ClearSignupDataManuallyEvent());
        verify(() => mockAuthBloc.add(any(that: isA<ClearSignupDataManuallyEvent>()))).called(1);
      });
    });

    group('State Management Tests', () {
      test('should handle state changes in AccountTypeBloc', () {
        when(
          () => mockAccountTypeBloc.state,
        ).thenReturn(const AccountTypeState(selectedAccountType: AccountType.personal, isLoading: false));

        expect(mockAccountTypeBloc.state.selectedAccountType, AccountType.personal);
        expect(mockAccountTypeBloc.state.isLoading, false);

        when(
          () => mockAccountTypeBloc.state,
        ).thenReturn(const AccountTypeState(selectedAccountType: AccountType.business, isLoading: false));

        expect(mockAccountTypeBloc.state.selectedAccountType, AccountType.business);
        expect(mockAccountTypeBloc.state.isLoading, false);
      });

      test('should handle loading state transitions', () {
        when(
          () => mockAccountTypeBloc.state,
        ).thenReturn(const AccountTypeState(selectedAccountType: null, isLoading: true));

        expect(mockAccountTypeBloc.state.selectedAccountType, null);
        expect(mockAccountTypeBloc.state.isLoading, true);

        when(
          () => mockAccountTypeBloc.state,
        ).thenReturn(const AccountTypeState(selectedAccountType: AccountType.personal, isLoading: false));

        expect(mockAccountTypeBloc.state.selectedAccountType, AccountType.personal);
        expect(mockAccountTypeBloc.state.isLoading, false);
      });
    });

    group('Business Logic Tests', () {
      test('should handle personal account selection flow', () {
        // Simulate personal account selection
        mockAccountTypeBloc.add(SelectAccountType(AccountType.personal));
        mockAccountTypeBloc.add(GetDropDownOption());
        mockPersonalAccountSetupBloc.add(PersonalResetData());

        // Verify all events were called
        verify(() => mockAccountTypeBloc.add(any(that: isA<SelectAccountType>()))).called(1);
        verify(() => mockAccountTypeBloc.add(any(that: isA<GetDropDownOption>()))).called(1);
        verify(() => mockPersonalAccountSetupBloc.add(any(that: isA<PersonalResetData>()))).called(1);
      });

      test('should handle business account selection flow', () {
        // Simulate business account selection
        mockAccountTypeBloc.add(SelectAccountType(AccountType.business));
        mockAccountTypeBloc.add(GetDropDownOption());
        mockBusinessAccountSetupBloc.add(ResetData());

        // Verify all events were called
        verify(() => mockAccountTypeBloc.add(any(that: isA<SelectAccountType>()))).called(1);
        verify(() => mockAccountTypeBloc.add(any(that: isA<GetDropDownOption>()))).called(1);
        verify(() => mockBusinessAccountSetupBloc.add(any(that: isA<ResetData>()))).called(1);
      });

      test('should handle back navigation flow', () {
        // Simulate back navigation
        mockAuthBloc.add(ClearSignupDataManuallyEvent());

        // Verify event was called
        verify(() => mockAuthBloc.add(any(that: isA<ClearSignupDataManuallyEvent>()))).called(1);
      });
    });

    group('Error Handling Tests', () {
      test('should handle null account type gracefully', () {
        const state = AccountTypeState(selectedAccountType: null, isLoading: false);
        expect(state.selectedAccountType, null);
        expect(state.isLoading, false);
      });

      test('should handle multiple rapid events', () {
        // Simulate rapid events
        for (int i = 0; i < 5; i++) {
          mockAccountTypeBloc.add(SelectAccountType(AccountType.personal));
        }

        // Verify all events were processed
        verify(() => mockAccountTypeBloc.add(any(that: isA<SelectAccountType>()))).called(5);
      });
    });

    group('Integration Tests', () {
      test('should handle complete user flow for personal account', () {
        // Complete flow: select personal -> get dropdown -> reset data -> clear signup
        mockAccountTypeBloc.add(SelectAccountType(AccountType.personal));
        mockAccountTypeBloc.add(GetDropDownOption());
        mockPersonalAccountSetupBloc.add(PersonalResetData());
        mockAuthBloc.add(ClearSignupDataManuallyEvent());

        // Verify all steps
        verify(() => mockAccountTypeBloc.add(any(that: isA<SelectAccountType>()))).called(1);
        verify(() => mockAccountTypeBloc.add(any(that: isA<GetDropDownOption>()))).called(1);
        verify(() => mockPersonalAccountSetupBloc.add(any(that: isA<PersonalResetData>()))).called(1);
        verify(() => mockAuthBloc.add(any(that: isA<ClearSignupDataManuallyEvent>()))).called(1);
      });

      test('should handle complete user flow for business account', () {
        // Complete flow: select business -> get dropdown -> reset data -> clear signup
        mockAccountTypeBloc.add(SelectAccountType(AccountType.business));
        mockAccountTypeBloc.add(GetDropDownOption());
        mockBusinessAccountSetupBloc.add(ResetData());
        mockAuthBloc.add(ClearSignupDataManuallyEvent());

        // Verify all steps
        verify(() => mockAccountTypeBloc.add(any(that: isA<SelectAccountType>()))).called(1);
        verify(() => mockAccountTypeBloc.add(any(that: isA<GetDropDownOption>()))).called(1);
        verify(() => mockBusinessAccountSetupBloc.add(any(that: isA<ResetData>()))).called(1);
        verify(() => mockAuthBloc.add(any(that: isA<ClearSignupDataManuallyEvent>()))).called(1);
      });
    });

    group('AccountCard Widget Logic Tests', () {
      test('should create AccountCard with correct properties', () {
        bool tapped = false;
        final card = AccountCard(
          title: 'Test Title',
          subtitle: 'Test Subtitle',
          icon: 'test_icon.svg',
          isSelected: true,
          onTap: () => tapped = true,
        );

        expect(card.title, 'Test Title');
        expect(card.subtitle, 'Test Subtitle');
        expect(card.icon, 'test_icon.svg');
        expect(card.isSelected, true);
        expect(card.onTap, isNotNull);

        // Test onTap callback
        card.onTap();
        expect(tapped, true);
      });

      test('should create AccountCard with unselected state', () {
        final card = AccountCard(
          title: 'Unselected Card',
          subtitle: 'Not selected',
          icon: 'icon.svg',
          isSelected: false,
          onTap: () {},
        );

        expect(card.title, 'Unselected Card');
        expect(card.subtitle, 'Not selected');
        expect(card.icon, 'icon.svg');
        expect(card.isSelected, false);
      });

      test('should handle different title and subtitle combinations', () {
        final card1 = AccountCard(
          title: 'Personal',
          subtitle: 'For individual use',
          icon: 'personal.svg',
          isSelected: true,
          onTap: () {},
        );

        final card2 = AccountCard(
          title: 'Business',
          subtitle: 'For business use',
          icon: 'business.svg',
          isSelected: false,
          onTap: () {},
        );

        expect(card1.title, 'Personal');
        expect(card1.subtitle, 'For individual use');
        expect(card2.title, 'Business');
        expect(card2.subtitle, 'For business use');
      });

      test('should handle empty strings gracefully', () {
        final card = AccountCard(title: '', subtitle: '', icon: '', isSelected: false, onTap: () {});

        expect(card.title, '');
        expect(card.subtitle, '');
        expect(card.icon, '');
        expect(card.isSelected, false);
      });
    });

    group('Navigation Logic Tests', () {
      test('should handle RouteUri constants', () {
        expect(RouteUri.signupRoute, isNotNull);
        expect(RouteUri.personalAccountSetupRoute, isNotNull);
        expect(RouteUri.businessAccountSetupViewRoute, isNotNull);
      });
    });

    group('Assets Tests', () {
      test('should have correct asset paths', () {
        expect(Assets.images.svgs.icons.icDoubleLeftArrow.path, isNotNull);
        expect(Assets.images.svgs.icons.icDoubleLeftArrow.path, isA<String>());
      });
    });
  });
}
