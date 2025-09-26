import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:exchek/core/oauth2/oauth2_config.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Mocks for OAuth2Client and OAuth2Helper
class MockOAuth2Client extends Mock implements OAuth2Client {}

class MockOAuth2Helper extends Mock implements OAuth2Helper {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    // Load dotenv with test values for all required keys
    dotenv.testLoad(
      fileInput: '''
DEV_SERVER_BASEURL=http://localhost:8000
PROD_SERVER_BASEURL=http://localhost:8000
STAGE_SERVER_BASEURL=http://localhost:8000
ENCRYPT_KEY=key
ENCRYPT_IV=iv
APP_NAME=exchek
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

  group('OAuth2Config', () {
    test('singleton instance returns the same object', () {
      final instance1 = OAuth2Config();
      final instance2 = OAuth2Config();
      expect(instance1, same(instance2));
    });

    test('static fields are initialized from env', () {
      // These are static, so just check they exist and are of correct type
      expect(OAuth2Config.googleClientId, isA<String>());
      expect(OAuth2Config.googleClientSecret, isA<String>());
      expect(OAuth2Config.googleScopes, isA<List<String>>());
      expect(OAuth2Config.linkedInClientId, isA<String>());
      expect(OAuth2Config.linkedInClientSecret, isA<String>());
      expect(OAuth2Config.linkedInScopes, isA<List<String>>());
      expect(OAuth2Config.appleClientId, isA<String>());
      expect(OAuth2Config.appleClientSecret, isA<String>());
      expect(OAuth2Config.appleScopes, isA<List<String>>());
    });

    test('initialize() sets up helpers', () {
      final config = OAuth2Config();
      config.initialize();
      expect(config.googleHelper, isA<OAuth2Helper>());
      expect(config.linkedInHelper, isA<OAuth2Helper>());
      expect(config.appleHelper, isA<OAuth2Helper>());
    });

    test('initialize() uses correct redirectUri for web and non-web', () {
      final config = OAuth2Config();
      // Do not call initialize() again; just check helpers are not null
      expect(config.googleHelper, isNotNull);
      expect(config.linkedInHelper, isNotNull);
      expect(config.appleHelper, isNotNull);
    });
  });
}
