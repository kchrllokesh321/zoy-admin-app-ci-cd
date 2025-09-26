// ignore_for_file: non_constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

String get DEV_SERVER_BASEURL => dotenv.env['DEV_SERVER_BASEURL']!;
String get PROD_SERVER_BASEURL => dotenv.env['PROD_SERVER_BASEURL']!;
String get STAGE_SERVER_BASEURL => dotenv.env['STAGE_SERVER_BASEURL']!;
String get ENCRYPT_KEY => dotenv.env['ENCRYPT_KEY']!;
String get ENCRYPT_IV => dotenv.env['ENCRYPT_IV']!;
String get APP_NAME => dotenv.env['APP_NAME']!;

String get GOOGLE_CLIENT_ID => dotenv.env['GOOGLE_CLIENT_ID']!;
String get GOOGLE_CLIENT_SECRET => dotenv.env['GOOGLE_CLIENT_SECRET']!;
List<String>? get GOOGLE_SCOPES => dotenv.env['GOOGLE_SCOPES']?.split(',');
String get GOOGLE_AUTHORIZE_URL => dotenv.env['GOOGLE_AUTHORIZE_URL']!;
String get GOOGLE_TOKEN_URL => dotenv.env['GOOGLE_TOKEN_URL']!;
String get GOOGLE_REDIRECT_URI => dotenv.env['GOOGLE_REDIRECT_URI']!;
String get GOOGLE_REDIRECT_URI_WEB => dotenv.env['GOOGLE_REDIRECT_URI_WEB']!;

String get LINKEDIN_CLIENT_ID => dotenv.env['LINKEDIN_CLIENT_ID']!;
String get LINKEDIN_CLIENT_SECRET => dotenv.env['LINKEDIN_CLIENT_SECRET']!;
List<String>? get LINKEDIN_SCOPES => dotenv.env['LINKEDIN_SCOPES']?.split(' ');
String get LINKEDIN_AUTHORIZE_URL => dotenv.env['LINKEDIN_AUTHORIZE_URL']!;
String get LINKEDIN_TOKEN_URL => dotenv.env['LINKEDIN_TOKEN_URL']!;
String get LINKEDIN_REDIRECT_URI => dotenv.env['LINKEDIN_REDIRECT_URI']!;
String get LINKEDIN_REDIRECT_URI_WEB => dotenv.env['LINKEDIN_REDIRECT_URI_WEB']!;

String get APPLE_CLIENT_ID => dotenv.env['APPLE_CLIENT_ID']!;
String get APPLE_CLIENT_SECRET => dotenv.env['APPLE_CLIENT_SECRET']!;
List<String>? get APPLE_SCOPES => dotenv.env['APPLE_SCOPES']?.split(',');
String get APPLE_AUTHORIZE_URL => dotenv.env['APPLE_AUTHORIZE_URL']!;
String get APPLE_TOKEN_URL => dotenv.env['APPLE_TOKEN_URL']!;
String get APPLE_REDIRECT_URI => dotenv.env['APPLE_REDIRECT_URI']!;
String get APPLE_REDIRECT_URI_WEB => dotenv.env['APPLE_REDIRECT_URI_WEB']!;
