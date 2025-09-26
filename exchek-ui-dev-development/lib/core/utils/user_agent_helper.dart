import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:exchek/core/api_config/endpoints/api_endpoint.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:dio/dio.dart';

class UserAgentHelper {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// Get the current platform type
  static PlatformType getPlatformType() {
    if (kIsWeb) {
      return PlatformType.web;
    } else if (Platform.isAndroid) {
      return PlatformType.android;
    } else if (Platform.isIOS) {
      return PlatformType.ios;
    }
    return PlatformType.unknown;
  }

  /// Get detailed platform information
  static Future<Map<String, dynamic>> getPlatformInfo() async {
    final platformType = getPlatformType();
    final packageInfo = await PackageInfo.fromPlatform();

    Map<String, dynamic> info = {
      'platform': platformType.toString(),
      'appName': packageInfo.appName,
      'packageName': packageInfo.packageName,
      'version': packageInfo.version,
      'buildNumber': packageInfo.buildNumber,
    };

    switch (platformType) {
      case PlatformType.android:
        final androidInfo = await _deviceInfo.androidInfo;
        info.addAll({
          'androidVersion': androidInfo.version.release,
          'androidSdkInt': androidInfo.version.sdkInt,
          'deviceModel': androidInfo.model,
          'deviceManufacturer': androidInfo.manufacturer,
        });
        break;
      case PlatformType.ios:
        final iosInfo = await _deviceInfo.iosInfo;
        info.addAll({
          'iosVersion': iosInfo.systemVersion,
          'deviceModel': iosInfo.model,
          'deviceName': iosInfo.name,
          'deviceLocalizedModel': iosInfo.localizedModel,
        });
        break;
      case PlatformType.web:
        final webInfo = await _deviceInfo.webBrowserInfo;
        info.addAll({
          'browserName': webInfo.browserName,
          'browserVersion': webInfo.appVersion,
          'userAgent': webInfo.userAgent,
        });
        break;
      default:
        break;
    }

    return info;
  }

  /// Get a formatted user agent string
  static getUserAgentOnly() async {
    String userAgent = '';
    if (kIsWeb) {
      final webInfo = await _deviceInfo.webBrowserInfo;
      userAgent = webInfo.userAgent ?? 'unknown';
    } else {
      final packageInfo = await PackageInfo.fromPlatform();
      final platformType = getPlatformType();
      switch (platformType) {
        case PlatformType.android:
          final androidInfo = await _deviceInfo.androidInfo;
          userAgent =
              '${packageInfo.appName}/${packageInfo.version} (Android ${androidInfo.version.release}; ${androidInfo.model}; ${androidInfo.manufacturer})';
          break;
        case PlatformType.ios:
          final iosInfo = await _deviceInfo.iosInfo;
          userAgent =
              '${packageInfo.appName}/${packageInfo.version} (iOS ${iosInfo.systemVersion}; ${iosInfo.model}; ${iosInfo.name})';
          break;
        default:
          userAgent = '${packageInfo.appName}/${packageInfo.version}';
      }
    }
    return userAgent;
  }

  /// Get IP, timestamp, and user agent combined
  static Future<Map<String, dynamic>> getPlatformMetaInfo() async {
    String ip = 'Unknown';
    try {
      final res = await Dio().get(ApiEndPoint.ipUrl);
      if (res.statusCode == 200 && res.data != null) {
        if (res.data is String) {
          ip = json.decode(res.data)['ip'];
        } else if (res.data is Map) {
          ip = res.data['ip'] ?? 'Unknown';
        }
      }
    } catch (_) {
      ip = 'Unavailable';
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final userAgent = await getUserAgentOnly();

    return {'ip': ip, 'time': timestamp, 'user_agent': userAgent};
  }
}

enum PlatformType { android, ios, web, unknown }
