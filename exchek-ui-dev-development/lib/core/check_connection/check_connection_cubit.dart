import 'dart:io';
import 'package:exchek/core/check_connection/check_connection_state.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:meta/meta.dart';

// Interface for internet checking to allow mocking in tests
abstract class InternetChecker {
  Future<bool> checkInternetConnection();
}

// Default implementation using InternetAddress.lookup
class DefaultInternetChecker implements InternetChecker {
  @protected
  Future<List<InternetAddress>> performLookup(String host) {
    return InternetAddress.lookup(host);
  }

  @override
  Future<bool> checkInternetConnection() async {
    try {
      final result = await performLookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}

class CheckConnectionCubit extends Cubit<CheckConnectionStates> {
  CheckConnectionCubit({Connectivity? connectivity, InternetChecker? internetChecker, bool? isWebOverride})
    : super(CheckConnectionLoading()) {
    _connectivity = connectivity ?? Connectivity();
    _internetChecker = internetChecker ?? DefaultInternetChecker();
    _isWeb = isWebOverride ?? kIsWeb;
  }

  static CheckConnectionCubit get(context) => BlocProvider.of(context);

  late final Connectivity _connectivity;
  late final InternetChecker _internetChecker;
  late final bool _isWeb;
  bool? hasConnection;

  Future<void> initializeConnectivity() async {
    _connectivity.onConnectivityChanged.listen((results) {
      for (var result in results) {
        _connectionChange(result);
      }
    });
    for (var result in await _connectivity.checkConnectivity()) {
      _checkConnection(result);
    }
  }

  void _connectionChange(ConnectivityResult result) {
    _checkConnection(result);
  }

  Future<bool?> _checkConnection(ConnectivityResult result) async {
    bool? previousConnection;
    if (hasConnection != null) {
      previousConnection = hasConnection!;
    }

    if (result == ConnectivityResult.none) {
      hasConnection = false;
      if (previousConnection != hasConnection) {
        _connectionChangeController(hasConnection!);
      }
      return hasConnection;
    }

    if (_isWeb) {
      // For web platform, we'll consider the connection as available if we have any connectivity
      hasConnection = result != ConnectivityResult.none;
    } else {
      hasConnection = await _internetChecker.checkInternetConnection();
    }

    if (previousConnection != hasConnection) {
      _connectionChangeController(hasConnection!);
    }

    return hasConnection;
  }

  bool isNetDialogShow = false;

  void _connectionChangeController(bool hasConnection) {
    if (hasConnection) {
      emit(InternetConnected());
    } else {
      emit(InternetDisconnected());
    }
  }

  // Test-specific methods for better testability
  @visibleForTesting
  Future<bool?> testCheckConnection(ConnectivityResult result) async {
    return _checkConnection(result);
  }

  @visibleForTesting
  void testConnectionChange(ConnectivityResult result) {
    _connectionChange(result);
  }

  @visibleForTesting
  void testConnectionChangeController(bool hasConnection) {
    _connectionChangeController(hasConnection);
  }

  @visibleForTesting
  Future<void> testInitializeConnectivity() async {
    return initializeConnectivity();
  }
}
