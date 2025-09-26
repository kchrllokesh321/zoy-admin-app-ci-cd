import 'package:exchek/core/utils/exports.dart';

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final EnvConfig env;

  static FlavorConfig? _instance;

  FlavorConfig._internal({required this.flavor, required this.name, required this.env});

  static FlavorConfig get instance {
    if (_instance == null) {
      throw Exception('FlavorConfig not initialized. Call FlavorConfig.initialize() before using it.');
    }
    return _instance!;
  }

  static void initialize({required Flavor flavor, required EnvConfig env}) {
    _instance ??= FlavorConfig._internal(flavor: flavor, name: flavor.name, env: env);
  }

  static bool isProduction() => instance.flavor == Flavor.prod;
  static bool isStaging() => instance.flavor == Flavor.stage;
  static bool isDevelopment() => instance.flavor == Flavor.dev;
}
