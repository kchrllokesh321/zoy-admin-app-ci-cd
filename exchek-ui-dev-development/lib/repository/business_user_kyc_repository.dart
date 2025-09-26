import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/models/auth_models/common_success_model.dart';
import 'package:exchek/models/personal_user_models/get_gst_details_model.dart';
import 'package:exchek/models/personal_user_models/aadhar_otp_model.dart';
import 'package:exchek/models/personal_user_models/aadhar_verify_otp_model.dart';
import 'package:exchek/models/personal_user_models/captcha_model.dart';
import 'package:exchek/models/personal_user_models/recaptcha_model.dart';
import 'package:dio/dio.dart';

class BusinessUserKycRepository {
  final ApiClient apiClient;
  BusinessUserKycRepository({required this.apiClient});
  Future<CommonSuccessModel> uploadbusinessKyc({
    required String userID,
    required String documentType,
    required String documentNumber,
    required String nameOnPan,
    required FileData documentFrontImage,
    FileData? documentBackImage,
    required bool isAddharCard,
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
        'back_doc': isAddharCard ? documentBackImage : null,
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
    String? kycRole,
    required String userType,
    required String aadhaarNumber,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'faker': false,
        'otp': otp,
        'session_id': sessionId,
        'user_id': userId,
        'kyc_role': kycRole,
        "user_type": userType,
        "aadhaar_number": aadhaarNumber,
      };
      final response = await apiClient.request(RequestType.POST, ApiEndPoint.validateAadharOTPUrl, data: data);
      return await compute(AadharOTPVerifyModel.fromJson, response);
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

  Future<CommonSuccessModel> uploadContactDetails({
    required String userID,
    required String mobileNumber,
    required String emailId,
  }) async {
    try {
      final Map<String, dynamic> data = {'email': emailId, 'mobile': mobileNumber, 'user_id': userID};
      final response = await apiClient.request(RequestType.POST, ApiEndPoint.uploadContactDetailsUrl, data: data);
      return await compute(CommonSuccessModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }

  Future<CommonSuccessModel> uploadBeneficialOwnerAddress({
    required String userID,
    required String useAadhaar,
    required String kycRole,
    String? country,
    String? state,
    String? city,
    String? pincode,
    String? addressLine1,
    String? addressLine2,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'user_id': userID,
        'use_aadhaar': useAadhaar,
        'kyc_role': kycRole,
        'country': country,
        'state': state,
        'city': city,
        'pincode': pincode,
        'address_line1': addressLine1,
        'address_line2': addressLine2,
      };
        FormData formData = FormData.fromMap(data);
      final response = await apiClient.request(
        RequestType.POST,
        ApiEndPoint.uploadBeneficialOwnerAddressUrl,
        data: formData,
      );
      return await compute(CommonSuccessModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }

  Future<CommonSuccessModel> deleteDocument({
    String? documentNumber,
    String? documentType,
    String? kycRole,
    String? path,
    String? screenName,
    String? userId,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'document_number': documentNumber,
        'document_type': documentType,
        'kyc_role': kycRole,
        'path': path,
        'screen_name': screenName,
        'user_id': userId,
      };
      final response = await apiClient.request(
        RequestType.POST,
        ApiEndPoint.uploadDeleteDocumentUrl,
        data: data,
        isShowToast: false,
      );
      return await compute(CommonSuccessModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }

  Future<CommonSuccessModel> uploadProofOfBusiness({
    required String userID,
    required String hasProofOfBusiness,
    FileData? udyam,
    FileData? shopLicense,
    FileData? proftaxReg,
    FileData? utilityBill,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'user_id': userID,
        'has_proof_of_business': hasProofOfBusiness,
        'udyam': udyam,
        'shop_license': shopLicense,
        'proftax_reg': proftaxReg,
        'utility_bill': utilityBill,
      };
      final response = await apiClient.request(
        RequestType.MULTIPART_POST,
        ApiEndPoint.uploadProofOfBusinessUrl,
        multipartData: data,
      );
      return await compute(CommonSuccessModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }
}
