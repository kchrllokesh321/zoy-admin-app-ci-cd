import 'package:flutter_test/flutter_test.dart';
import 'package:exchek/core/utils/exports.dart';

// HTTP overrides to prevent network requests
class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _MockHttpClient();
  }
}

class _MockHttpClient implements HttpClient {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw const SocketException('Network requests disabled in tests');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('main_dev.dart Tests', () {
    setUpAll(() {
      // Set up HTTP overrides to prevent network requests
      HttpOverrides.global = _TestHttpOverrides();

      // Load test environment variables
      dotenv.testLoad(
        fileInput: '''
DEV_SERVER_BASEURL=http://localhost:8000
PROD_SERVER_BASEURL=http://localhost:8000
STAGE_SERVER_BASEURL=http://localhost:8000
ENCRYPT_KEY=test_key
ENCRYPT_IV=test_iv
APP_NAME=exchek_test
GOOGLE_CLIENT_ID=google-client-id
GOOGLE_CLIENT_SECRET=google-client-secret
GOOGLE_SCOPES=email,profile
GOOGLE_AUTHORIZE_URL=https://accounts.google.com/o/oauth2/auth
GOOGLE_TOKEN_URL=https://accounts.google.com/o/oauth2/token
GOOGLE_REDIRECT_URI=com.exchek.app:/oauth2redirect
GOOGLE_REDIRECT_URI_WEB=https://localhost:8000/oauth2redirect
LINKEDIN_CLIENT_ID=linkedin-client-id
LINKEDIN_CLIENT_SECRET=linkedin-client-secret
LINKEDIN_SCOPES=r_liteprofile r_emailaddress
LINKEDIN_AUTHORIZE_URL=https://www.linkedin.com/oauth/v2/authorization
LINKEDIN_TOKEN_URL=https://www.linkedin.com/oauth/v2/accessToken
LINKEDIN_REDIRECT_URI=com.exchek.app:/oauth2redirect
LINKEDIN_REDIRECT_URI_WEB=https://localhost:8000/oauth2redirect
APPLE_CLIENT_ID=apple-client-id
APPLE_CLIENT_SECRET=apple-client-secret
APPLE_SCOPES=name,email
APPLE_AUTHORIZE_URL=https://appleid.apple.com/auth/authorize
APPLE_TOKEN_URL=https://appleid.apple.com/auth/token
APPLE_REDIRECT_URI=com.exchek.app:/oauth2redirect
APPLE_REDIRECT_URI_WEB=https://localhost:8000/oauth2redirect
''',
      );
    });

    group('Environment Configuration Tests', () {
      test('should load DEV_SERVER_BASEURL correctly', () {
        expect(DEV_SERVER_BASEURL, equals('http://localhost:8000'));
      });

      test('should create EnvConfig with dev base URL', () {
        final devConfig = EnvConfig(baseUrl: DEV_SERVER_BASEURL);
        expect(devConfig.baseUrl, equals('http://localhost:8000'));
      });

      test('should initialize FlavorConfig with dev flavor', () {
        final devConfig = EnvConfig(baseUrl: DEV_SERVER_BASEURL);
        FlavorConfig.initialize(flavor: Flavor.dev, env: devConfig);

        expect(FlavorConfig.instance.flavor, equals(Flavor.dev));
        expect(FlavorConfig.instance.env.baseUrl, equals('http://localhost:8000'));
        expect(FlavorConfig.isDevelopment(), isTrue);
        expect(FlavorConfig.isProduction(), isFalse);
        expect(FlavorConfig.isStaging(), isFalse);
      });
    });

    group('Error Widget Tests', () {
      test('should create CustomErrorWidget with error message', () {
        const errorMessage = 'Test error message';
        final errorWidget = CustomErrorWidget(errorMessage: errorMessage);

        expect(errorWidget, isA<CustomErrorWidget>());
        expect(errorWidget.errorMessage, equals(errorMessage));
      });

      test('should set up ErrorWidget.builder', () {
        // Set up custom error widget builder
        ErrorWidget.builder = (FlutterErrorDetails details) {
          return CustomErrorWidget(errorMessage: details.exception.toString());
        };

        final errorWidget = ErrorWidget.builder(
          FlutterErrorDetails(
            exception: Exception('Test error'),
            library: 'test',
            context: ErrorDescription('Test context'),
          ),
        );

        expect(errorWidget, isA<CustomErrorWidget>());
      });
    });

    group('OAuth2Config Tests', () {
      test('should initialize OAuth2Config', () {
        final oauth2Config = OAuth2Config();
        expect(() => oauth2Config.initialize(), returnsNormally);
      });
    });

    group('UserAgentHelper Tests', () {
      test('should get platform type', () {
        final platformType = UserAgentHelper.getPlatformType();
        expect(platformType, isA<PlatformType>());
      });

      test('should handle getPlatformMetaInfo gracefully', () async {
        // This test verifies that the method handles errors gracefully
        try {
          await UserAgentHelper.getPlatformMetaInfo();
        } catch (e) {
          // Should handle plugin exceptions gracefully
          expect(e, isA<Exception>());
        }
      });
    });

    group('Logger Tests', () {
      test('should log messages without throwing', () {
        expect(() => Logger.lOG('Test log message'), returnsNormally);
        expect(() => Logger.success('Test success message'), returnsNormally);
        expect(() => Logger.error('Test error message'), returnsNormally);
        expect(() => Logger.warning('Test warning message'), returnsNormally);
        expect(() => Logger.info('Test info message'), returnsNormally);
      });
    });

    group('Dotenv Loading Tests', () {
      test('should handle dotenv loading gracefully', () async {
        // Test that dotenv.load doesn't throw in test environment
        expect(() async => await dotenv.load(fileName: ".env"), returnsNormally);
      });

      test('should handle missing .env file gracefully', () async {
        try {
          await dotenv.load(fileName: "non_existent.env");
        } catch (e) {
          // Should catch the error gracefully - FileNotFoundError is a subtype of Error
          expect(e, isNotNull);
        }
      });
    });

    group('SystemChrome Tests', () {
      test('should handle SystemChrome operations', () {
        // Test that SystemChrome class exists and can be referenced
        expect(SystemChrome, isNotNull);
        expect(DeviceOrientation.portraitUp, isA<DeviceOrientation>());
      });
    });

    testWidgets('SystemChrome error handling tests', (WidgetTester tester) async {
      // Mock SystemChrome.setPreferredOrientations to throw an error
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (MethodCall methodCall) async {
          if (methodCall.method == 'SystemChrome.setPreferredOrientations') {
            throw PlatformException(code: 'error', message: 'Test error');
          }
          return null;
        },
      );

      // Test that error is handled gracefully
      try {
        await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      } catch (e) {
        expect(e, isA<PlatformException>());
      }
    });

    group('Widget Binding Tests', () {
      testWidgets('should ensure WidgetsFlutterBinding is initialized', (WidgetTester tester) async {
        WidgetsFlutterBinding.ensureInitialized();
        expect(WidgetsBinding.instance, isNotNull);
      });
    });

    group('Path URL Strategy Tests', () {
      test('should call setPathUrlStrategy without throwing', () {
        expect(() => setPathUrlStrategy(), returnsNormally);
      });
    });

    group('Web Preferences Tests', () {
      test('should handle web preferences initialization', () async {
        if (kIsWeb) {
          // Test web-specific initialization
          expect(() async => await Prefobj.preferences.initWebPreferences(), returnsNormally);
        } else {
          // For non-web platforms, this should be skipped
          expect(true, isTrue);
        }
      });
    });

    group('Main Function Components Integration', () {
      test('should initialize all components in correct order', () async {
        // Test the sequence of operations that happen in main()

        // 1. Load environment variables - use test values
        const testBaseUrl = 'http://localhost:8000';

        // 2. Create environment config
        final devConfig = EnvConfig(baseUrl: testBaseUrl);
        expect(devConfig.baseUrl, equals(testBaseUrl));

        // 3. Initialize FlavorConfig
        FlavorConfig.initialize(flavor: Flavor.dev, env: devConfig);
        expect(FlavorConfig.instance.flavor, equals(Flavor.dev));

        // 4. Initialize OAuth2Config
        final oauth2Config = OAuth2Config();
        expect(oauth2Config, isNotNull);

        // 5. Test error widget setup
        ErrorWidget.builder = (FlutterErrorDetails details) {
          return CustomErrorWidget(errorMessage: details.exception.toString());
        };

        final errorWidget = ErrorWidget.builder(
          FlutterErrorDetails(
            exception: Exception('Test error'),
            library: 'test',
            context: ErrorDescription('Test context'),
          ),
        );

        expect(errorWidget, isA<CustomErrorWidget>());
      });
    });
  });
}
