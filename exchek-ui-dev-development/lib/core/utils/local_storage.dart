import 'package:exchek/core/utils/env.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:exchek/core/utils/logger.dart';
import 'package:exchek/core/utils/web_kv_store.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  late final FlutterSecureStorage _storage;
  SharedPreferences? _webPreferences;

  // Encryption setup (for web only)
  static final _key = encrypt.Key.fromUtf8(ENCRYPT_KEY);
  static final _iv = encrypt.IV.fromUtf8(ENCRYPT_IV);
  static final _encrypter = encrypt.Encrypter(encrypt.AES(_key));

  factory LocalStorage() {
    return _instance;
  }

  LocalStorage._internal() {
    if (!kIsWeb) {
      _storage = const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
        iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
      );
    }
  }

  // Initialize web preferences (kept for backward compatibility; no-op for sessionStorage path)
  Future<void> initWebPreferences() async {
    if (kIsWeb && _webPreferences == null) {
      try {
        _webPreferences = await SharedPreferences.getInstance();
      } catch (_) {}
    }
  }

  // Store a value
  Future<void> put(String key, String value) async {
    try {
      if (kIsWeb) {
        final encrypted = _encrypter.encrypt(value, iv: _iv).base64;
        await webKvSetItem(key, encrypted);
      } else {
        await _storage.write(key: key, value: value);
      }
    } catch (e) {
      Logger.lOG('Error storing value: $e');
      rethrow;
    }
  }

  // Read a value
  Future<String?> get(String key) async {
    try {
      if (kIsWeb) {
        final encrypted = await webKvGetItem(key);
        if (encrypted == null) return null;
        try {
          return _encrypter.decrypt64(encrypted, iv: _iv);
        } catch (_) {
          return null;
        }
      } else {
        return await _storage.read(key: key);
      }
    } catch (e) {
      Logger.lOG('Error reading value: $e');
      return null;
    }
  }

  // Delete a value
  Future<void> delete(String key) async {
    try {
      if (kIsWeb) {
        await webKvRemoveItem(key);
      } else {
        await _storage.delete(key: key);
      }
    } catch (e) {
      Logger.lOG('Error deleting value: $e');
      rethrow;
    }
  }

  // Delete all values
  Future<void> deleteAll() async {
    try {
      if (kIsWeb) {
        await webKvClear();
      } else {
        await _storage.deleteAll();
      }
    } catch (e) {
      Logger.lOG('Error deleting all values: $e');
      rethrow;
    }
  }

  // Check if a key exists
  Future<bool> containsKey(String key) async {
    try {
      if (kIsWeb) {
        final keys = await webKvKeys();
        return keys.contains(key);
      } else {
        return await _storage.containsKey(key: key);
      }
    } catch (e) {
      Logger.lOG('Error checking key: $e');
      return false;
    }
  }

  // Read all values
  Future<Map<String, String>> readAll() async {
    try {
      if (kIsWeb) {
        final keys = await webKvKeys();
        final Map<String, String> result = {};
        for (final key in keys) {
          final encrypted = await webKvGetItem(key);
          if (encrypted != null) {
            try {
              final decrypted = _encrypter.decrypt64(encrypted, iv: _iv);
              result[key] = decrypted;
            } catch (_) {
              // Skip invalid entries
            }
          }
        }
        return result;
      } else {
        return await _storage.readAll();
      }
    } catch (e) {
      Logger.lOG('Error reading all values: $e');
      return {};
    }
  }
}

class Prefkeys {
  static const String lightDark = 'light_dark';
  static const String followSystem = 'follow_system';

  static const String authToken = 'auth_token';
  static const String businessEntityType = 'business_entity_type';
  static const String emailId = 'email_id';
  static const String mobileNumber = 'mobile_number';
  static const String exportsGood = 'exports_good';
  static const String exportServices = 'export_service';
  static const String exportGoodsServices = 'export_goods_services';
  static const String freelancer = 'freelancer';
  static const String user = 'user';
  static const String resetPasswordToken = 'reset_password_token';
  static const String verifyemailToken = 'verify_email_token';
  static const String userId = 'user_id';
  static const String loggedPhoneNumber = 'logged_phone_number';
  static const String loggedUserName = 'logged_user_name';
  static const String loggedEmail = 'logged_email';
  static const String sessionId = 'session_id';
  static const String userKycDetail = 'user_kyc_detail';
  static const String finalKycStatus = 'final_kyc_status';
  static const String currentPath ='';
}

class Prefobj {
  static final LocalStorage preferences = LocalStorage();
}
