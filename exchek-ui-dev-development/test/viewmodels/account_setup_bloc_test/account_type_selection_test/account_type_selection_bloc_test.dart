import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:exchek/viewmodels/account_setup_bloc/account_type_selection/account_type_selection_bloc.dart';
import 'package:exchek/repository/auth_repository.dart';
import 'package:exchek/models/personal_user_models/get_option_model.dart';
import 'package:exchek/core/enums/app_enums.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Generate mocks
@GenerateMocks([AuthRepository])
import 'account_type_selection_bloc_test.mocks.dart';

void main() {
  // In-memory storage for testing LocalStorage
  final Map<String, String> mockStorage = {};

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Mock flutter_secure_storage plugin
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'write':
            final String key = methodCall.arguments['key'];
            final String value = methodCall.arguments['value'];
            mockStorage[key] = value;
            return null;
          case 'read':
            final String key = methodCall.arguments['key'];
            return mockStorage[key];
          case 'delete':
            final String key = methodCall.arguments['key'];
            mockStorage.remove(key);
            return null;
          case 'deleteAll':
            mockStorage.clear();
            return null;
          case 'readAll':
            return Map<String, String>.from(mockStorage);
          case 'containsKey':
            final String key = methodCall.arguments['key'];
            return mockStorage.containsKey(key);
          default:
            return null;
        }
      },
    );

    // Load test environment variables
    dotenv.testLoad(
      fileInput: '''
ENCRYPT_KEY=1234567890123456
ENCRYPT_IV=1234567890123456
''',
    );
  });

  tearDownAll(() {
    // Clean up the mock method channel handler
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
      null,
    );
  });

  group('AccountTypeBloc Tests', () {
    late AccountTypeBloc accountTypeBloc;
    late MockAuthRepository mockAuthRepository;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      accountTypeBloc = AccountTypeBloc(authRepository: mockAuthRepository);
      // Clear mock storage between tests
      mockStorage.clear();
    });

    tearDown(() {
      accountTypeBloc.close();
    });

    group('Initial State', () {
      test('should have correct initial state', () {
        // Assert
        expect(accountTypeBloc.state.selectedAccountType, isNull);
        expect(accountTypeBloc.state.isLoading, false);
      });
    });

    group('SelectAccountType Event', () {
      blocTest<AccountTypeBloc, AccountTypeState>(
        'should emit state with selected personal account type',
        build: () => accountTypeBloc,
        act: (bloc) => bloc.add(const SelectAccountType(AccountType.personal)),
        expect: () => [const AccountTypeState(selectedAccountType: AccountType.personal, isLoading: false)],
      );

      blocTest<AccountTypeBloc, AccountTypeState>(
        'should emit state with selected business account type',
        build: () => accountTypeBloc,
        act: (bloc) => bloc.add(const SelectAccountType(AccountType.business)),
        expect: () => [const AccountTypeState(selectedAccountType: AccountType.business, isLoading: false)],
      );

      blocTest<AccountTypeBloc, AccountTypeState>(
        'should update selected account type when called multiple times',
        build: () => accountTypeBloc,
        act: (bloc) {
          bloc.add(const SelectAccountType(AccountType.personal));
          bloc.add(const SelectAccountType(AccountType.business));
        },
        expect:
            () => [
              const AccountTypeState(selectedAccountType: AccountType.personal, isLoading: false),
              const AccountTypeState(selectedAccountType: AccountType.business, isLoading: false),
            ],
      );
    });

    group('GetDropDownOption Event', () {
      test('should handle successful dropdown fetch with complete data and successful storage', () async {
        // Arrange
        final mockResponse = GetDropdownOptionModel(
          success: true,
          data: Data(
            personal: Personal(freelancer: ['Freelancer Option 1', 'Freelancer Option 2']),
            business: Business(
              exportOfGoods: ['Goods Option 1', 'Goods Option 2'],
              exportOfServices: ['Service Option 1', 'Service Option 2'],
              exportOfGoodsServices: ['Combined Option 1', 'Combined Option 2'],
            ),
          ),
        );
        when(mockAuthRepository.getDropdownOptions()).thenAnswer((_) async => mockResponse);

        // Act
        accountTypeBloc.add(GetDropDownOption());
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert - All storage operations should succeed with mocked LocalStorage
        expect(accountTypeBloc.state.isLoading, false);
        verify(mockAuthRepository.getDropdownOptions()).called(1);

        // Verify that data was stored in mock storage
        expect(mockStorage.containsKey('exports_good'), true);
        expect(mockStorage.containsKey('export_service'), true);
        expect(mockStorage.containsKey('export_goods_services'), true);
        expect(mockStorage.containsKey('freelancer'), true);
      });

      test('should handle successful dropdown fetch', () async {
        // Arrange
        final mockResponse = GetDropdownOptionModel(
          success: true,
          data: Data(
            personal: Personal(freelancer: ['Freelancer Option 1']),
            business: Business(exportOfGoods: ['Goods Option 1']),
          ),
        );
        when(mockAuthRepository.getDropdownOptions()).thenAnswer((_) async => mockResponse);

        // Act
        accountTypeBloc.add(GetDropDownOption());
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(accountTypeBloc.state.isLoading, false);
        verify(mockAuthRepository.getDropdownOptions()).called(1);
      });

      test('should handle failed dropdown fetch', () async {
        // Arrange
        when(mockAuthRepository.getDropdownOptions()).thenThrow(Exception('Network error'));

        // Act
        accountTypeBloc.add(GetDropDownOption());
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(accountTypeBloc.state.isLoading, false);
        verify(mockAuthRepository.getDropdownOptions()).called(1);
      });

      test('should handle unsuccessful response', () async {
        // Arrange
        final mockResponse = GetDropdownOptionModel(success: false);
        when(mockAuthRepository.getDropdownOptions()).thenAnswer((_) async => mockResponse);

        // Act
        accountTypeBloc.add(GetDropDownOption());
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(accountTypeBloc.state.isLoading, false);
        verify(mockAuthRepository.getDropdownOptions()).called(1);
      });

      test('should handle null response success', () async {
        // Arrange
        final mockResponse = GetDropdownOptionModel(success: null);
        when(mockAuthRepository.getDropdownOptions()).thenAnswer((_) async => mockResponse);

        // Act
        accountTypeBloc.add(GetDropDownOption());
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(accountTypeBloc.state.isLoading, false);
        verify(mockAuthRepository.getDropdownOptions()).called(1);
      });

      test('should handle successful response with null data fields', () async {
        // Arrange
        final mockResponse = GetDropdownOptionModel(success: true, data: Data(personal: null, business: null));
        when(mockAuthRepository.getDropdownOptions()).thenAnswer((_) async => mockResponse);

        // Act
        accountTypeBloc.add(GetDropDownOption());
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert - Storage operations will be attempted with null data
        expect(accountTypeBloc.state.isLoading, false);
        verify(mockAuthRepository.getDropdownOptions()).called(1);
      });

      test('should handle successful response with partial null data', () async {
        // Arrange
        final mockResponse = GetDropdownOptionModel(
          success: true,
          data: Data(
            personal: Personal(freelancer: ['Test Freelancer']),
            business: Business(exportOfGoods: null, exportOfGoodsServices: ['Test Service']),
          ),
        );
        when(mockAuthRepository.getDropdownOptions()).thenAnswer((_) async => mockResponse);

        // Act
        accountTypeBloc.add(GetDropDownOption());
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert - Storage operations will be attempted with mixed null/non-null data
        expect(accountTypeBloc.state.isLoading, false);
        verify(mockAuthRepository.getDropdownOptions()).called(1);
      });

      test('should handle successful response with exportOfServices data', () async {
        // Arrange - This test specifically covers the exportOfServices storage line
        final mockResponse = GetDropdownOptionModel(
          success: true,
          data: Data(
            personal: Personal(freelancer: ['Test Freelancer']),
            business: Business(
              exportOfGoods: ['Test Goods'],
              exportOfServices: ['Service 1', 'Service 2'], // This covers line 29
              exportOfGoodsServices: ['Combined Service'],
            ),
          ),
        );
        when(mockAuthRepository.getDropdownOptions()).thenAnswer((_) async => mockResponse);

        // Act
        accountTypeBloc.add(GetDropDownOption());
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert - All storage operations should complete successfully
        expect(accountTypeBloc.state.isLoading, false);
        verify(mockAuthRepository.getDropdownOptions()).called(1);

        // Verify specific storage operations
        expect(mockStorage.containsKey('export_service'), true);
        expect(mockStorage['export_service'], contains('Service 1'));
        expect(mockStorage['export_service'], contains('Service 2'));
      });
    });

    group('Bloc Integration', () {
      test('should handle account selection followed by dropdown fetch', () async {
        // Arrange
        final mockResponse = GetDropdownOptionModel(success: true);
        when(mockAuthRepository.getDropdownOptions()).thenAnswer((_) async => mockResponse);

        // Act
        accountTypeBloc.add(const SelectAccountType(AccountType.personal));
        accountTypeBloc.add(GetDropDownOption());
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(accountTypeBloc.state.selectedAccountType, AccountType.personal);
        expect(accountTypeBloc.state.isLoading, false);
        verify(mockAuthRepository.getDropdownOptions()).called(1);
      });

      test('should maintain selected account type during dropdown fetch', () async {
        // Arrange
        final mockResponse = GetDropdownOptionModel(success: true);
        when(mockAuthRepository.getDropdownOptions()).thenAnswer((_) async => mockResponse);

        // Act
        accountTypeBloc.add(const SelectAccountType(AccountType.business));
        await Future.delayed(const Duration(milliseconds: 10)); // Wait for state update
        expect(accountTypeBloc.state.selectedAccountType, AccountType.business);

        accountTypeBloc.add(GetDropDownOption());
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(accountTypeBloc.state.selectedAccountType, AccountType.business);
        expect(accountTypeBloc.state.isLoading, false);
      });
    });

    group('Event Creation', () {
      test('should create SelectAccountType events correctly', () {
        // Arrange & Act
        const personalEvent = SelectAccountType(AccountType.personal);
        const businessEvent = SelectAccountType(AccountType.business);

        // Assert
        expect(personalEvent.accountType, AccountType.personal);
        expect(businessEvent.accountType, AccountType.business);
        expect(personalEvent, isA<AccountTypeEvent>());
        expect(businessEvent, isA<AccountTypeEvent>());
      });

      test('should create GetDropDownOption event correctly', () {
        // Arrange & Act
        final event = GetDropDownOption();

        // Assert
        expect(event, isA<AccountTypeEvent>());
        expect(event, isA<GetDropDownOption>());
      });
    });

    group('State Management', () {
      test('should handle state transitions correctly', () async {
        // Initial state
        expect(accountTypeBloc.state.selectedAccountType, isNull);
        expect(accountTypeBloc.state.isLoading, false);

        // Select account type
        accountTypeBloc.add(const SelectAccountType(AccountType.personal));
        await Future.delayed(const Duration(milliseconds: 10));
        expect(accountTypeBloc.state.selectedAccountType, AccountType.personal);
        expect(accountTypeBloc.state.isLoading, false);

        // Change account type
        accountTypeBloc.add(const SelectAccountType(AccountType.business));
        await Future.delayed(const Duration(milliseconds: 10));
        expect(accountTypeBloc.state.selectedAccountType, AccountType.business);
        expect(accountTypeBloc.state.isLoading, false);
      });
    });

    group('Error Handling', () {
      test('should handle repository errors gracefully', () async {
        // Arrange
        when(mockAuthRepository.getDropdownOptions()).thenThrow(Exception('Network error'));

        // Act
        accountTypeBloc.add(GetDropDownOption());
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert - Should not crash and should set loading to false
        expect(accountTypeBloc.state.isLoading, false);
        verify(mockAuthRepository.getDropdownOptions()).called(1);
      });
    });
  });
}
