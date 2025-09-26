import 'package:exchek/core/utils/exports.dart';

Future<void> main() async {
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    Logger.lOG("Error loading .env file: $e");
  }
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();

  // Log user agent information
  final platformMetaInfo = await UserAgentHelper.getPlatformMetaInfo();
  Logger.success('Platform Meta Info: $platformMetaInfo');

  // Custom error widget
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return CustomErrorWidget(errorMessage: details.exception.toString());
  };

  EnvConfig devConfig = EnvConfig(baseUrl: DEV_SERVER_BASEURL);
  // Env config
  FlavorConfig.initialize(flavor: Flavor.dev, env: devConfig);
  OAuth2Config().initialize();
  // Initialize LocalStorage
  if (kIsWeb) {
    await Prefobj.preferences.initWebPreferences();
  }

  try {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    runApp(ExchekApp());
  } catch (e, stackTrace) {
    Logger.lOG('Error initializing app: $e\n$stackTrace');
  }
}
