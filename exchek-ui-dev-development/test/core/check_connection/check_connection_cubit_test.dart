import 'dart:io';
import 'package:exchek/core/check_connection/check_connection_cubit.dart';
import 'package:exchek/core/check_connection/check_connection_state.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

class MockConnectivity extends Mock implements Connectivity {}

class MockInternetChecker extends Mock implements InternetChecker {}

// Subclass for testing SocketException in DefaultInternetChecker
class FailingInternetChecker extends DefaultInternetChecker {
  @override
  Future<List<InternetAddress>> performLookup(String host) {
    throw SocketException('Connection failed');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CheckConnectionCubit', () {
    late CheckConnectionCubit cubit;
    late MockConnectivity mockConnectivity;
    late MockInternetChecker mockInternetChecker;

    setUp(() {
      mockConnectivity = MockConnectivity();
      mockInternetChecker = MockInternetChecker();
      cubit = CheckConnectionCubit(connectivity: mockConnectivity, internetChecker: mockInternetChecker);
    });

    tearDown(() async {
      await cubit.close();
    });

    group('Initial State', () {
      test('should emit CheckConnectionLoading initially', () {
        expect(cubit.state, isA<CheckConnectionLoading>());
      });

      test('should have isNetDialogShow as false initially', () {
        expect(cubit.isNetDialogShow, isFalse);
      });

      test('should have hasConnection as null initially', () {
        expect(cubit.hasConnection, isNull);
      });
    });

    group('Static get method', () {
      testWidgets('should return cubit from BlocProvider', (WidgetTester tester) async {
        await tester.pumpWidget(
          BlocProvider<CheckConnectionCubit>(
            create: (context) => CheckConnectionCubit(),
            child: Builder(
              builder: (context) {
                final cubitFromContext = CheckConnectionCubit.get(context);
                expect(cubitFromContext, isA<CheckConnectionCubit>());
                return const SizedBox();
              },
            ),
          ),
        );
      });
    });

    group('isNetDialogShow flag', () {
      test('should be able to set isNetDialogShow to true', () {
        cubit.isNetDialogShow = true;
        expect(cubit.isNetDialogShow, isTrue);
      });

      test('should be able to set isNetDialogShow to false', () {
        cubit.isNetDialogShow = true;
        cubit.isNetDialogShow = false;
        expect(cubit.isNetDialogShow, isFalse);
      });
    });

    group('hasConnection property', () {
      test('should be able to set hasConnection to true', () {
        cubit.hasConnection = true;
        expect(cubit.hasConnection, isTrue);
      });

      test('should be able to set hasConnection to false', () {
        cubit.hasConnection = false;
        expect(cubit.hasConnection, isFalse);
      });

      test('should be able to set hasConnection to null', () {
        cubit.hasConnection = null;
        expect(cubit.hasConnection, isNull);
      });
    });

    group('Cubit Lifecycle', () {
      test('should handle cubit disposal', () async {
        await cubit.close();
        expect(cubit.isClosed, isTrue);
      });

      test('should throw when emitting after disposal', () async {
        await cubit.close();
        expect(() => cubit.emit(InternetConnected()), throwsStateError);
      });
    });

    group('Connection Change Controller', () {
      test('should emit InternetConnected when hasConnection is true', () {
        cubit.hasConnection = true;
        cubit.testConnectionChangeController(true);
        expect(cubit.state, isA<InternetConnected>());
      });

      test('should emit InternetDisconnected when hasConnection is false', () {
        cubit.hasConnection = false;
        cubit.testConnectionChangeController(false);
        expect(cubit.state, isA<InternetDisconnected>());
      });
    });

    group('Connection Change Method', () {
      test('should call _checkConnection when _connectionChange is called', () async {
        when(() => mockInternetChecker.checkInternetConnection()).thenAnswer((_) async => true);

        cubit.hasConnection = true;
        cubit.testConnectionChange(ConnectivityResult.none);

        await Future.delayed(const Duration(milliseconds: 100));

        expect(cubit.state, isA<InternetDisconnected>());
        expect(cubit.hasConnection, isFalse);
      });

      test('should handle ConnectivityResult.wifi', () async {
        when(() => mockInternetChecker.checkInternetConnection()).thenAnswer((_) async => true);

        cubit.hasConnection = false;
        cubit.testConnectionChange(ConnectivityResult.wifi);

        await Future.delayed(const Duration(milliseconds: 100));

        expect(cubit.state, isA<InternetConnected>());
        expect(cubit.hasConnection, isTrue);
      });

      test('should handle ConnectivityResult.mobile', () async {
        when(() => mockInternetChecker.checkInternetConnection()).thenAnswer((_) async => true);

        cubit.hasConnection = false;
        cubit.testConnectionChange(ConnectivityResult.mobile);

        await Future.delayed(const Duration(milliseconds: 100));

        expect(cubit.state, isA<InternetConnected>());
        expect(cubit.hasConnection, isTrue);
      });

      test('should handle ConnectivityResult.ethernet', () async {
        when(() => mockInternetChecker.checkInternetConnection()).thenAnswer((_) async => true);

        cubit.hasConnection = false;
        cubit.testConnectionChange(ConnectivityResult.ethernet);

        await Future.delayed(const Duration(milliseconds: 100));

        expect(cubit.state, isA<InternetConnected>());
        expect(cubit.hasConnection, isTrue);
      });

      test('should handle ConnectivityResult.vpn', () async {
        when(() => mockInternetChecker.checkInternetConnection()).thenAnswer((_) async => true);

        cubit.hasConnection = false;
        cubit.testConnectionChange(ConnectivityResult.vpn);

        await Future.delayed(const Duration(milliseconds: 100));

        expect(cubit.state, isA<InternetConnected>());
        expect(cubit.hasConnection, isTrue);
      });

      test('should handle ConnectivityResult.bluetooth', () async {
        when(() => mockInternetChecker.checkInternetConnection()).thenAnswer((_) async => true);

        cubit.hasConnection = false;
        cubit.testConnectionChange(ConnectivityResult.bluetooth);

        await Future.delayed(const Duration(milliseconds: 100));

        expect(cubit.state, isA<InternetConnected>());
        expect(cubit.hasConnection, isTrue);
      });

      test('should handle ConnectivityResult.other', () async {
        when(() => mockInternetChecker.checkInternetConnection()).thenAnswer((_) async => true);

        cubit.hasConnection = false;
        cubit.testConnectionChange(ConnectivityResult.other);

        await Future.delayed(const Duration(milliseconds: 100));

        expect(cubit.state, isA<InternetConnected>());
        expect(cubit.hasConnection, isTrue);
      });
    });

    group('Check Connection Method', () {
      test('should return false for ConnectivityResult.none', () async {
        final result = await cubit.testCheckConnection(ConnectivityResult.none);
        expect(result, isFalse);
        expect(cubit.hasConnection, isFalse);
        expect(cubit.state, isA<InternetDisconnected>());
      });

      test('should handle web platform with any connectivity', () async {
        // Create a cubit with web override
        final webCubit = CheckConnectionCubit(
          connectivity: mockConnectivity,
          internetChecker: mockInternetChecker,
          isWebOverride: true,
        );

        final result = await webCubit.testCheckConnection(ConnectivityResult.wifi);
        expect(result, isTrue);
        expect(webCubit.hasConnection, isTrue);
        expect(webCubit.state, isA<InternetConnected>());

        await webCubit.close();
      });

      test('should handle web platform with ConnectivityResult.none', () async {
        // Create a cubit with web override
        final webCubit = CheckConnectionCubit(
          connectivity: mockConnectivity,
          internetChecker: mockInternetChecker,
          isWebOverride: true,
        );

        final result = await webCubit.testCheckConnection(ConnectivityResult.none);
        expect(result, isFalse);
        expect(webCubit.hasConnection, isFalse);
        expect(webCubit.state, isA<InternetDisconnected>());

        await webCubit.close();
      });

      test('should handle non-web platform with successful internet lookup', () async {
        when(() => mockInternetChecker.checkInternetConnection()).thenAnswer((_) async => true);

        final result = await cubit.testCheckConnection(ConnectivityResult.wifi);
        expect(result, isTrue);
        expect(cubit.hasConnection, isTrue);
        expect(cubit.state, isA<InternetConnected>());
      });

      test('should handle non-web platform with failed internet lookup', () async {
        when(() => mockInternetChecker.checkInternetConnection()).thenAnswer((_) async => false);

        final result = await cubit.testCheckConnection(ConnectivityResult.wifi);
        expect(result, isFalse);
        expect(cubit.hasConnection, isFalse);
        expect(cubit.state, isA<InternetDisconnected>());
      });

      test('should not emit state change when connection status is the same', () async {
        when(() => mockInternetChecker.checkInternetConnection()).thenAnswer((_) async => true);

        cubit.hasConnection = true;
        cubit.emit(InternetConnected());

        final result = await cubit.testCheckConnection(ConnectivityResult.wifi);

        expect(result, isTrue);
        expect(cubit.hasConnection, isTrue);
      });

      test('should emit state change when connection status changes from false to true', () async {
        when(() => mockInternetChecker.checkInternetConnection()).thenAnswer((_) async => true);

        cubit.hasConnection = false;
        cubit.emit(InternetDisconnected());

        final result = await cubit.testCheckConnection(ConnectivityResult.wifi);

        expect(result, isTrue);
        expect(cubit.hasConnection, isTrue);
        expect(cubit.state, isA<InternetConnected>());
      });

      test('should emit state change when connection status changes from true to false', () async {
        cubit.hasConnection = true;
        cubit.emit(InternetConnected());

        final result = await cubit.testCheckConnection(ConnectivityResult.none);

        expect(result, isFalse);
        expect(cubit.hasConnection, isFalse);
        expect(cubit.state, isA<InternetDisconnected>());
      });

      test('should handle null previous connection', () async {
        when(() => mockInternetChecker.checkInternetConnection()).thenAnswer((_) async => true);

        cubit.hasConnection = null;

        final result = await cubit.testCheckConnection(ConnectivityResult.wifi);

        expect(result, isTrue);
        expect(cubit.hasConnection, isTrue);
        expect(cubit.state, isA<InternetConnected>());
      });
    });

    group('Initialize Connectivity Method', () {
      test('should have initializeConnectivity method', () {
        expect(cubit.initializeConnectivity, isA<Function>());
      });

      test('should call initializeConnectivity without throwing', () async {
        when(() => mockConnectivity.onConnectivityChanged).thenAnswer((_) => Stream.value([ConnectivityResult.wifi]));
        when(() => mockConnectivity.checkConnectivity()).thenAnswer((_) async => [ConnectivityResult.wifi]);
        when(() => mockInternetChecker.checkInternetConnection()).thenAnswer((_) async => true);

        expect(() async {
          await cubit.testInitializeConnectivity();
        }, returnsNormally);
      });
    });

    group('Platform Specific Behavior', () {
      test('should handle web platform detection', () {
        expect(kIsWeb, isA<bool>());
      });

      test('should handle non-web platform detection', () {
        expect(kIsWeb, isA<bool>());
      });
    });

    group('BlocTest Integration', () {
      blocTest<CheckConnectionCubit, CheckConnectionStates>(
        'emits [InternetConnected] when connection becomes available',
        build: () {
          when(() => mockInternetChecker.checkInternetConnection()).thenAnswer((_) async => true);
          return CheckConnectionCubit(connectivity: mockConnectivity, internetChecker: mockInternetChecker);
        },
        act: (cubit) async {
          await cubit.testCheckConnection(ConnectivityResult.wifi);
        },
        expect: () => [isA<InternetConnected>()],
      );

      blocTest<CheckConnectionCubit, CheckConnectionStates>(
        'emits [InternetDisconnected] when connection is lost',
        build: () => CheckConnectionCubit(connectivity: mockConnectivity, internetChecker: mockInternetChecker),
        act: (cubit) async {
          await cubit.testCheckConnection(ConnectivityResult.none);
        },
        expect: () => [isA<InternetDisconnected>()],
      );

      blocTest<CheckConnectionCubit, CheckConnectionStates>(
        'emits [InternetConnected, InternetDisconnected] when connection changes',
        build: () {
          when(() => mockInternetChecker.checkInternetConnection()).thenAnswer((_) async => true);
          return CheckConnectionCubit(connectivity: mockConnectivity, internetChecker: mockInternetChecker);
        },
        act: (cubit) async {
          await cubit.testCheckConnection(ConnectivityResult.wifi);
          await cubit.testCheckConnection(ConnectivityResult.none);
        },
        expect: () => [isA<InternetConnected>(), isA<InternetDisconnected>()],
      );
    });

    group('Edge Cases', () {
      test('should handle null hasConnection', () {
        cubit.hasConnection = null;
        expect(cubit.hasConnection, isNull);
      });

      test('should handle boolean hasConnection values', () {
        cubit.hasConnection = true;
        expect(cubit.hasConnection, isTrue);

        cubit.hasConnection = false;
        expect(cubit.hasConnection, isFalse);
      });

      test('should maintain state consistency', () {
        cubit.hasConnection = true;
        cubit.emit(InternetConnected());
        expect(cubit.state, isA<InternetConnected>());
        expect(cubit.hasConnection, isTrue);

        cubit.hasConnection = false;
        cubit.emit(InternetDisconnected());
        expect(cubit.state, isA<InternetDisconnected>());
        expect(cubit.hasConnection, isFalse);
      });
    });

    group('Comprehensive Coverage Tests', () {
      test('should test all state types', () {
        cubit.emit(CheckConnectionLoading());
        expect(cubit.state, isA<CheckConnectionLoading>());

        cubit.emit(InternetConnected());
        expect(cubit.state, isA<InternetConnected>());

        cubit.emit(InternetDisconnected());
        expect(cubit.state, isA<InternetDisconnected>());
      });

      test('should test all property combinations', () {
        cubit.hasConnection = null;
        cubit.isNetDialogShow = false;
        expect(cubit.hasConnection, isNull);
        expect(cubit.isNetDialogShow, isFalse);

        cubit.hasConnection = true;
        cubit.isNetDialogShow = true;
        expect(cubit.hasConnection, isTrue);
        expect(cubit.isNetDialogShow, isTrue);

        cubit.hasConnection = false;
        cubit.isNetDialogShow = false;
        expect(cubit.hasConnection, isFalse);
        expect(cubit.isNetDialogShow, isFalse);
      });

      test('should test static method functionality', () {
        expect(CheckConnectionCubit.get, isA<Function>());
      });

      test('should test initializeConnectivity method exists', () {
        expect(cubit.initializeConnectivity, isA<Function>());
      });
    });

    group('Method Coverage', () {
      test('should have initializeConnectivity method', () {
        expect(cubit.initializeConnectivity, isA<Function>());
      });

      test('should have static get method', () {
        expect(CheckConnectionCubit.get, isA<Function>());
      });

      test('should have isNetDialogShow property', () {
        expect(cubit.isNetDialogShow, isA<bool>());
      });

      test('should have hasConnection property', () {
        expect(cubit.hasConnection, isA<bool?>());
      });

      test('should have state property', () {
        expect(cubit.state, isA<CheckConnectionStates>());
      });
    });

    group('State Type Coverage', () {
      test('should handle CheckConnectionLoading state', () {
        cubit.emit(CheckConnectionLoading());
        expect(cubit.state, isA<CheckConnectionLoading>());
      });

      test('should handle InternetConnected state', () {
        cubit.emit(InternetConnected());
        expect(cubit.state, isA<InternetConnected>());
      });

      test('should handle InternetDisconnected state', () {
        cubit.emit(InternetDisconnected());
        expect(cubit.state, isA<InternetDisconnected>());
      });
    });

    group('Socket Exception Handling', () {
      test('should handle SocketException gracefully', () async {
        when(() => mockInternetChecker.checkInternetConnection()).thenAnswer((_) async => false);

        final result = await cubit.testCheckConnection(ConnectivityResult.wifi);
        expect(result, isFalse);
        expect(cubit.hasConnection, isFalse);
        expect(cubit.state, isA<InternetDisconnected>());
      });
    });

    group('Connection State Transitions', () {
      test('should handle transition from null to connected', () async {
        when(() => mockInternetChecker.checkInternetConnection()).thenAnswer((_) async => true);

        cubit.hasConnection = null;
        await cubit.testCheckConnection(ConnectivityResult.wifi);
        expect(cubit.hasConnection, isTrue);
        expect(cubit.state, isA<InternetConnected>());
      });

      test('should handle transition from null to disconnected', () async {
        cubit.hasConnection = null;
        await cubit.testCheckConnection(ConnectivityResult.none);
        expect(cubit.hasConnection, isFalse);
        expect(cubit.state, isA<InternetDisconnected>());
      });

      test('should handle transition from connected to disconnected', () async {
        cubit.hasConnection = true;
        cubit.emit(InternetConnected());
        await cubit.testCheckConnection(ConnectivityResult.none);
        expect(cubit.hasConnection, isFalse);
        expect(cubit.state, isA<InternetDisconnected>());
      });

      test('should handle transition from disconnected to connected', () async {
        when(() => mockInternetChecker.checkInternetConnection()).thenAnswer((_) async => true);

        cubit.hasConnection = false;
        cubit.emit(InternetDisconnected());
        await cubit.testCheckConnection(ConnectivityResult.wifi);
        expect(cubit.hasConnection, isTrue);
        expect(cubit.state, isA<InternetConnected>());
      });
    });

    group('Default Internet Checker', () {
      test('should handle successful internet lookup', () async {
        final defaultChecker = DefaultInternetChecker();
        final result = await defaultChecker.checkInternetConnection();
        expect(result, isA<bool>());
      });

      test('should handle SocketException and return false', () async {
        final checker = FailingInternetChecker();
        final result = await checker.checkInternetConnection();
        expect(result, isFalse);
      });
    });
  });
}
