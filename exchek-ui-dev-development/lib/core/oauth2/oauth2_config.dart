import 'package:exchek/core/utils/env.dart';
import 'package:flutter/foundation.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';

class OAuth2Config {
  static final OAuth2Config _instance = OAuth2Config._internal();
  factory OAuth2Config() => _instance;
  OAuth2Config._internal();

  // Google OAuth2 Configuration
  static String googleClientId = GOOGLE_CLIENT_ID;
  static String googleClientSecret = GOOGLE_CLIENT_SECRET;
  static List<String> googleScopes = GOOGLE_SCOPES ?? [];

  // LinkedIn OAuth2 Configuration
  static String linkedInClientId = LINKEDIN_CLIENT_ID;
  static String linkedInClientSecret = LINKEDIN_CLIENT_SECRET;
  static List<String> linkedInScopes = LINKEDIN_SCOPES ?? [];

  // Apple OAuth2 Configuration
  static String appleClientId = APPLE_CLIENT_ID;
  static String appleClientSecret = APPLE_CLIENT_SECRET;
  static List<String> appleScopes = APPLE_SCOPES ?? [];

  late final OAuth2Helper googleHelper;
  late final OAuth2Helper linkedInHelper;
  late final OAuth2Helper appleHelper;

  void initialize() {
    final googleClient = OAuth2Client(
      authorizeUrl: GOOGLE_AUTHORIZE_URL,
      tokenUrl: GOOGLE_TOKEN_URL,
      redirectUri: kIsWeb ? GOOGLE_REDIRECT_URI_WEB : GOOGLE_REDIRECT_URI,
      customUriScheme: APP_NAME,
    );

    final linkedInClient = OAuth2Client(
      authorizeUrl: LINKEDIN_AUTHORIZE_URL,
      tokenUrl: LINKEDIN_TOKEN_URL,
      redirectUri: kIsWeb ? LINKEDIN_REDIRECT_URI_WEB : LINKEDIN_REDIRECT_URI,
      customUriScheme: APP_NAME,
    );

    final appleClient = OAuth2Client(
      authorizeUrl: APPLE_AUTHORIZE_URL,
      tokenUrl: APPLE_TOKEN_URL,
      redirectUri: kIsWeb ? APPLE_REDIRECT_URI_WEB : APPLE_REDIRECT_URI,
      customUriScheme: APP_NAME,
    );

    googleHelper = OAuth2Helper(
      googleClient,
      grantType: OAuth2Helper.authorizationCode,
      clientId: googleClientId,
      clientSecret: googleClientSecret,
      scopes: googleScopes,
    );

    linkedInHelper = OAuth2Helper(
      linkedInClient,
      grantType: OAuth2Helper.authorizationCode,
      clientId: linkedInClientId,
      clientSecret: linkedInClientSecret,
      scopes: linkedInScopes,
    );

    appleHelper = OAuth2Helper(
      appleClient,
      grantType: OAuth2Helper.authorizationCode,
      clientId: appleClientId,
      clientSecret: appleClientSecret,
      scopes: appleScopes,
    );
  }
}
