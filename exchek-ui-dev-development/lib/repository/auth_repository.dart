import 'package:dio/dio.dart';
import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/models/auth_models/common_success_model.dart';
import 'package:exchek/models/auth_models/email_availabilty_model.dart';
import 'package:exchek/models/auth_models/get_user_kyc_detail_model.dart';
import 'package:exchek/models/auth_models/login_email_register_model.dart';
import 'package:exchek/models/auth_models/mobile_availabilty_model.dart';
import 'package:exchek/models/auth_models/refresh_token_model.dart';
import 'package:exchek/models/auth_models/validate_login_otp_model.dart';
import 'package:exchek/models/auth_models/verify_email_model.dart';
import 'package:exchek/models/personal_user_models/get_currency_model.dart';
import 'package:exchek/models/personal_user_models/get_option_model.dart';

class AuthRepository {
  final ApiClient apiClient;
  final OAuth2Config oauth2Config;

  AuthRepository({required this.apiClient, required this.oauth2Config});

  // Future<Map<String, dynamic>> googleSignIn() async {
  //   try {
  //     final token = await oauth2Config.googleHelper.getToken();

  //     // Get user info from Google
  //     final userInfo = await oauth2Config.googleHelper.get(
  //       'https://www.googleapis.com/oauth2/v2/userinfo',
  //       headers: {'Authorization': 'Bearer ${token?.accessToken ?? ''}'},
  //     );

  //     // Send token to your backend
  //     final response = await apiClient.request(
  //       RequestType.POST,
  //       ApiEndPoint.socialLoginUrl,
  //       data: {'provider': 'google', 'token': token?.accessToken, 'user_info': userInfo},
  //     );

  //     return response;
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  // Future<Map<String, dynamic>> linkedInSignIn() async {
  //   try {
  //     final token = await oauth2Config.linkedInHelper.getToken();

  //     // Get user info from LinkedIn
  //     final userInfo = await oauth2Config.linkedInHelper.get(
  //       'https://api.linkedin.com/v2/me',
  //       headers: {'Authorization': 'Bearer ${token?.accessToken}', 'X-Restli-Protocol-Version': '2.0.0'},
  //     );

  //     // Get email address
  //     final emailInfo = await oauth2Config.linkedInHelper.get(
  //       'https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))',
  //       headers: {'Authorization': 'Bearer ${token?.accessToken}', 'X-Restli-Protocol-Version': '2.0.0'},
  //     );

  //     // Send token to your backend
  //     final response = await apiClient.request(
  //       RequestType.POST,
  //       ApiEndPoint.socialLoginUrl,
  //       data: {'provider': 'linkedin', 'token': token?.accessToken, 'user_info': userInfo, 'email_info': emailInfo},
  //     );

  //     return response;
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  // Future<Map<String, dynamic>> appleSignIn() async {
  //   try {
  //     final token = await oauth2Config.appleHelper.getToken();

  //     // Send token to your backend
  //     final response = await apiClient.request(
  //       RequestType.POST,
  //       ApiEndPoint.socialLoginUrl,
  //       data: {'provider': 'apple', 'token': token?.accessToken},
  //     );

  //     return response;
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  Future<VerifyEmailModel> sendEmailVerificationLink({required String email, required String type}) async {
    try {
      final Map<String, dynamic> data = {'email': email, 'type': type};
      var response = await apiClient.request(
        RequestType.POST,
        ApiEndPoint.sendEmailVerificationLinkUrl,
        data: data,
        isShowToast: false,
      );
      return await compute(VerifyEmailModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }

  Future<CommonSuccessModel> resetPasswordVerificationLink({required String email, required String type}) async {
    try {
      final Map<String, dynamic> data = {'email': email, 'type': type};
      var response = await apiClient.request(
        RequestType.POST,
        ApiEndPoint.sendEmailVerificationLinkUrl,
        data: data,
        isShowToast: false,
      );
      return await compute(CommonSuccessModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }

  Future<CommonSuccessModel> sendOtp({required String mobile, required String type}) async {
    try {
      final Map<String, dynamic> data = {'mobile': mobile, 'type': type};
      final response = await apiClient.request(RequestType.POST, ApiEndPoint.sendOtpUrl, data: data);
      return await compute(CommonSuccessModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }

  Future<ValidateLoginOtpModel> validateLoginOtp({required String mobile, required String otp}) async {
    try {
      final Map<String, dynamic> data = {'mobile': mobile, 'otp': otp};
      final response = await apiClient.request(RequestType.POST, ApiEndPoint.validateLoginOtpUrl, data: data);
      return await compute(ValidateLoginOtpModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }

  Future<CommonSuccessModel> validateregistrationOtp({required String mobile, required String otp}) async {
    try {
      final Map<String, dynamic> data = {'mobile': mobile, 'otp': otp};
      final response = await apiClient.request(RequestType.POST, ApiEndPoint.validateRegistrationOtpUrl, data: data);
      return await compute(CommonSuccessModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }

  Future<CommonSuccessModel> validateForgotPasswordOtp({required String mobile, required String otp}) async {
    try {
      final Map<String, dynamic> data = {'mobile': mobile, 'otp': otp};
      final response = await apiClient.request(RequestType.POST, ApiEndPoint.validateForgotPasswordOtpUrl, data: data);
      return await compute(CommonSuccessModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }

  Future<CommonSuccessModel> updatePassword({
    required String confirmpassword,
    required String email,
    required String mobilenumber,
    required String newpassword,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'confirm_password': confirmpassword,
        'email_token': email,
        'mobile_number': mobilenumber,
        'new_password': newpassword,
      };
      final response = await apiClient.request(RequestType.POST, ApiEndPoint.updatePasswordUrl, data: data);
      return await compute(CommonSuccessModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }

  Future<EmailAvailabilityModel> emailAvailability({required String email}) async {
    try {
      final Map<String, dynamic> data = {'email': email};
      final response = await apiClient.request(RequestType.POST, ApiEndPoint.emailavailability, data: data);
      return await compute(EmailAvailabilityModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }

  Future<MobileAvailabilityModel> mobileAvailability({required String mobileNumber}) async {
    try {
      final Map<String, dynamic> data = {'mobile_number': mobileNumber};
      final response = await apiClient.request(RequestType.POST, ApiEndPoint.mobileavailability, data: data);
      return await compute(MobileAvailabilityModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetDropdownOptionModel> getDropdownOptions() async {
    try {
      final response = await apiClient.request(RequestType.GET, ApiEndPoint.getDropdownOptionUrl);
      return await compute(GetDropdownOptionModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }

  Future<LoginEmailPasswordModel> loginuser({required String email, required String password}) async {
    try {
      final Map<String, dynamic> data = {'email': email, 'password': password};
      final response = await apiClient.request(RequestType.POST, ApiEndPoint.loginurl, data: data);
      return await compute(LoginEmailPasswordModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }

  Future<LoginEmailPasswordModel> registerPersonalUser({
    required String email,
    required String estimatedMonthlyVolume,
    required String mobileNumber,
    // required List<String> multicurrency,
    required String receivingreason,
    required List<String> profession,
    required String productDescription,
    required String legalFullName,
    required String password,
    required Map tosacceptance,
    required String usertype,
    required String website,
    String? doingBusinessAs,
  }) async {
    try {
      final Map<String, dynamic> data = {
        "email_token": email,
        "estimated_monthly_volume": estimatedMonthlyVolume,
        "mobile_number": mobileNumber,
        // "multicurrency": multicurrency,
        "nested": {
          "payment_purpose": receivingreason,
          "profession": profession,
          "product_desc": productDescription,
          "legal_full_name": legalFullName,
        },
        "password": password,
        "tos_acceptance": tosacceptance,
        "user_type": usertype,
        "website": website,
        "doing_business_as": doingBusinessAs,
      };
      final response = await apiClient.request(RequestType.POST, ApiEndPoint.registerurl, data: data);
      return await compute(LoginEmailPasswordModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }

  Future<LoginEmailPasswordModel> registerBusinessUser({
    required String email,
    required String estimatedMonthlyVolume,
    required String mobileNumber,
    // required List<String> multicurrency,
    required String businesstype,
    required String businessnature,
    required List<String> exportstype,
    required String businesslegalname,
    required String password,
    required Map tosacceptance,
    required String usertype,
    required String username,
    required String website,
    required String doingBusinessAs,
  }) async {
    try {
      final Map<String, dynamic> data = {
        "email_token": email,
        "estimated_monthly_volume": estimatedMonthlyVolume,
        "mobile_number": mobileNumber,
        // "multicurrency": multicurrency,
        "nested": {
          "business_type": businesstype,
          "business_nature": businessnature,
          "exports_type": exportstype,
          "business_legal_name": businesslegalname,
        },
        "password": password,
        "tos_acceptance": tosacceptance,
        "user_type": usertype,
        "username": username,
        "website": website,
        "doing_business_as": doingBusinessAs,
      };
      final response = await apiClient.request(RequestType.POST, ApiEndPoint.registerurl, data: data);
      return await compute(LoginEmailPasswordModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetCurrencyOptionModel> getCurrencyOptions() async {
    try {
      final response = await apiClient.request(RequestType.GET, ApiEndPoint.getCurrencyOptionUrl);
      return await compute(GetCurrencyOptionModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }

  Future<CommonSuccessModel> logout({required String email}) async {
    try {
      final Map<String, dynamic> data = {'email': email};

      // Use a direct request without auth token for logout
      // This prevents issues when token is already invalidated
      final response = await apiClient.request(RequestType.POST, ApiEndPoint.logoutUrl, data: data, isShowToast: false);

      return await compute(CommonSuccessModel.fromJson, response);
    } catch (error) {
      Logger.error('Logout error: $error');

      // If any network/HTTP error occurs, allow local logout
      if (error is DioException) {
        Logger.warning('Allowing local logout despite DioException');
        return CommonSuccessModel(success: true, message: 'Logged out locally');
      }

      // Fallback: still allow local logout on unexpected errors
      return CommonSuccessModel(success: true, message: 'Logged out locally');
    }
  }

  Future<GetUserKycDetailsModel> getKycDetails({required String userId}) async {
    try {
      final response = await apiClient.request(RequestType.GET, ApiEndPoint.getKycDetailsUrl + userId);
      return await compute(GetUserKycDetailsModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }

  Future<RefreshTokenModel> refreshToken() async {
    try {
      final response = await apiClient.request(RequestType.POST, ApiEndPoint.refreshTokenUrl);
      return await compute(RefreshTokenModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }
}
