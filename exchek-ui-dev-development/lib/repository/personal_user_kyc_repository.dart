import 'dart:convert';

import 'package:exchek/core/utils/exports.dart';
import 'package:dio/dio.dart';
import 'package:exchek/models/auth_models/common_success_model.dart';
import 'package:exchek/models/personal_user_models/bank_account_verify_model.dart';
import 'package:exchek/models/personal_user_models/get_city_and_state_model.dart';
import 'package:exchek/models/personal_user_models/get_gst_details_model.dart';
import 'package:exchek/models/personal_user_models/get_pan_detail_model.dart';
import 'package:exchek/models/personal_user_models/presigned_url_model.dart';
import 'package:exchek/models/personal_user_models/aadhar_otp_model.dart';
import 'package:exchek/models/personal_user_models/aadhar_verify_otp_model.dart';
import 'package:exchek/models/personal_user_models/captcha_model.dart';
import 'package:exchek/models/personal_user_models/recaptcha_model.dart';

class PersonalUserKycRepository {
  final ApiClient apiClient;

  PersonalUserKycRepository({required this.apiClient});

  Future<CommonSuccessModel> uploadPersonalKyc({
    required String userID,
    required String documentType,
    required String documentNumber,
    required String nameOnPan,
    required FileData documentFrontImage,
    required String userType,
    String? kycRole,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'user_id': userID,
        'document_type': documentType,
        'document_number': documentNumber,
        'name_on_pan': nameOnPan,
        'front_doc': documentFrontImage,
        'user_type': userType,
        'kyc_role': kycRole,
      };
      final response = await apiClient.request(
        RequestType.MULTIPART_POST,
        ApiEndPoint.uploadPersonalKycUrl,
        multipartData: data,
      );
      return await compute(CommonSuccessModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }

  // Future<CaptchaModel> generateCaptcha() async {
  //   try {
  //     final response = await apiClient.request(RequestType.GET, ApiEndPoint.generateCaptchaUrl);
  //     return await compute(CaptchaModel.fromJson, response);
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  Future<CaptchaModel> generateCaptcha({
    required String userID,
    required String aadhaarNumber,
    required String userType,
    String? kycRole,
  }) async {
    try {
      final Map<String, dynamic> data = {
        "aadhaar_number": aadhaarNumber,
        "kyc_role": kycRole,
        "user_id": userID,
        "user_type": userType,
      };
      final response = await apiClient.request(RequestType.POST, ApiEndPoint.generateCaptchaUrl, data: data);
      return await compute(CaptchaModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }

  Future<RecaptchaModel> reGenerateCaptcha({required String sessionId}) async {
    try {
      final response = await apiClient.request(
        RequestType.GET,
        "${ApiEndPoint.generateReCaptchaUrl}?session_id=$sessionId",
      );
      return await compute(RecaptchaModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }

  Future<AadharOTPSendModel> generateAadharOTP({
    required String aadhaarNumber,
    required String captcha,
    required String sessionId,
  }) async {
    try {
      final Map<String, dynamic> data = {'aadhaar_number': aadhaarNumber, 'captcha': captcha, 'session_id': sessionId};
      final response = await apiClient.request(RequestType.POST, ApiEndPoint.generateAadharOTP, data: data);
      return await compute(AadharOTPSendModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }

  Future<AadharOTPVerifyModel> validateAadharOtp({
    required bool faker,
    required String otp,
    required String sessionId,
    required String userId,
    required String userType,
    required String aadhaarNumber,
    String? kycRole,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'faker': false,
        'otp': otp,
        'session_id': sessionId,
        'user_id': userId,
        "aadhaar_number": aadhaarNumber,
        "user_type": userType,
        "kyc_role": kycRole,
      };
      final response = await apiClient.request(RequestType.POST, ApiEndPoint.validateAadharOTPUrl, data: data);
      return await compute(AadharOTPVerifyModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetPanDetailModel> getPanDetails({
    required String panNumber,
    required String userId,
    required String kycRole,
  }) async {
    try {
      final user = await Prefobj.preferences.get(Prefkeys.userKycDetail);
      final userDetail = jsonDecode(user!);

      final Map<String, dynamic> data = {
        'pan_number': panNumber,
        "user_id": userId,
        "kyc_role": kycRole,
        "user_type": userDetail['user_type'],
      };
      final response = await apiClient.request(
        RequestType.POST,
        ApiEndPoint.getPanDetailUrl,
        data: data,
        isShowToast: false,
      );
      return await compute(GetPanDetailModel.fromJson, response);
    } on DioException catch (error) {
      // Handle DioException and extract error response data
      if (error.response?.data != null) {
        return GetPanDetailModel.fromJson(error.response!.data);
      }
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  Future<GetCityAndStateModel> getCityAndState({required String pincode}) async {
    try {
      final response = await apiClient.request(RequestType.GET, "${ApiEndPoint.getCityAndStateUrl}/$pincode");
      return await compute(GetCityAndStateModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }

  Future<CommonSuccessModel> uploadResidentialAddressDetails({
    required String userID,
    required String userType,
    required String country,
    required String pinCode,
    required String state,
    required String city,
    required String addressLine1,
    String? addressLine2,
    required String documentType,
    FileData? documentFrontImage,
    FileData? documentBackImage,
    required bool isAddharCard,
    required String aadhaarUsedAsIdentity,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'user_id': userID,
        'user_type': userType,
        'country': country,
        'pincode': pinCode,
        'state': state,
        'city': city,
        'address_line1': addressLine1,
        'address_line2': addressLine2,
        'document_type': documentType,
        'front_doc': documentFrontImage,
        'back_doc': isAddharCard ? documentBackImage : null,
        'aadhaar_used_as_identity': aadhaarUsedAsIdentity,
      };
      final response = await apiClient.request(
        RequestType.MULTIPART_POST,
        ApiEndPoint.uploadResidentialAddressDetailsUrl,
        multipartData: data,
      );
      return await compute(CommonSuccessModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetGstDetailsModel> getGSTDetails({
    required String userID,
    required String estimatedAnnualIncome,
    required String gstNumber,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'estimated_annual_income': estimatedAnnualIncome,
        'gst_number': gstNumber,
        'user_id': userID,
      };
      final response = await apiClient.request(RequestType.POST, ApiEndPoint.getGSTDetailsUrl, data: data);
      return await compute(GetGstDetailsModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }

  Future<CommonSuccessModel> uploadGSTDocument({
    required String userID,
    required String gstNumber,
    required String userType,
    FileData? gstCertificate,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'user_id': userID,
        'gst_number': gstNumber,
        'user_type': userType,
        'gst_certificate': gstCertificate,
      };
      final response = await apiClient.request(
        RequestType.MULTIPART_POST,
        ApiEndPoint.gstDocumentUrl,
        multipartData: data,
      );
      return await compute(CommonSuccessModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }

  Future<CommonSuccessModel> uploadBusinessLegalDocuments({
    required String userID,
    required String userType,
    required String documentType,
    String? documentNumber,
    FileData? documentFrontImage,
    FileData? documentbackImage,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'user_id': userID,
        'user_type': userType,
        'document_type': documentType,
        'document_number': documentNumber,
        'document_1': documentFrontImage,
        'document_2': documentbackImage,
      };
      final response = await apiClient.request(
        RequestType.MULTIPART_POST,
        ApiEndPoint.businessLegalDocuments,
        multipartData: data,
      );
      return await compute(CommonSuccessModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }

  Future<BankAccountVerifyModel> verifyBankAccount({
    required String accountNumber,
    required String ifscCode,
    required String userID,
    required String userType,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'acc_number': accountNumber,
        'ifsc_code': ifscCode,
        'user_id': userID,
        'user_type': userType,
      };
      final response = await apiClient.request(RequestType.POST, ApiEndPoint.verifyBankAccountUrl, data: data);
      return await compute(BankAccountVerifyModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }

  Future<CommonSuccessModel> uploadBankDocuments({
    required String userID,
    required String userType,
    required String accountNumber,
    required String ifscCode,
    required String documentType,
    required FileData proofDocumentImage,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'user_id': userID,
        'user_type': userType,
        'acc_number': accountNumber,
        'ifsc_code': ifscCode,
        'document_type': documentType,
        'proof_doc': proofDocumentImage,
      };
      final response = await apiClient.request(
        RequestType.MULTIPART_POST,
        ApiEndPoint.uploadBankDocumentUrl,
        multipartData: data,
      );
      return await compute(CommonSuccessModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }

  Future<PresignedUrlModel> getPresignedUrl({required String urlPath}) async {
    try {
      final Map<String, dynamic> data = {'path': urlPath};
      final response = await apiClient.request(RequestType.POST, ApiEndPoint.presignedUrl, data: data);
      return await compute(PresignedUrlModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }

  Future<CommonSuccessModel> uploadPanDetails({
    required String userID,
    required String userType,
    String? kycRole,
    required String panNumber,
    required String nameOnPan,
    String? isBeneficialOwnerisBeneficialOwner,
    String? isBusinessRepresentative,
    required FileData panDoc,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'user_id': userID,
        'user_type': userType,
        'kyc_role': kycRole,
        'pan_number': panNumber,
        'name_on_pan': nameOnPan,
        'is_beneficial_owner': isBeneficialOwnerisBeneficialOwner,
        'is_business_representative': isBusinessRepresentative,
        'pan_doc': panDoc,
      };
      final response = await apiClient.request(
        RequestType.MULTIPART_POST,
        ApiEndPoint.uploadPanDetailsUrl,
        multipartData: data,
      );
      return await compute(CommonSuccessModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }
}
