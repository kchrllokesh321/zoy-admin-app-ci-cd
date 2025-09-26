import 'dart:typed_data';

import 'package:exchek/core/enums/app_enums.dart';
import 'package:exchek/core/flavor_config/env_config.dart';
import 'package:exchek/core/flavor_config/flavor_config.dart';
import 'package:exchek/core/api_config/client/api_client.dart';
import 'package:exchek/models/auth_models/common_success_model.dart';
import 'package:exchek/models/personal_user_models/get_gst_details_model.dart';
import 'package:exchek/models/personal_user_models/aadhar_otp_model.dart';
import 'package:exchek/models/personal_user_models/aadhar_verify_otp_model.dart';
import 'package:exchek/models/personal_user_models/captcha_model.dart';
import 'package:exchek/models/personal_user_models/recaptcha_model.dart';
import 'package:exchek/repository/business_user_kyc_repository.dart';
import 'package:exchek/widgets/common_widget/app_file_upload_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  late _MockApiClient mockApiClient;
  late BusinessUserKycRepository repo;

  setUpAll(() {
    registerFallbackValue(RequestType.POST);
    FlavorConfig.initialize(flavor: Flavor.dev, env: EnvConfig(baseUrl: 'https://test.local'));
  });

  setUp(() {
    mockApiClient = _MockApiClient();
    repo = BusinessUserKycRepository(apiClient: mockApiClient);
  });

  test('uploadbusinessKyc includes back_doc when isAddharCard true and returns CommonSuccessModel', () async {
    Map<String, dynamic>? capturedMultipart;

    when(
      () => mockApiClient.request(
        RequestType.MULTIPART_POST,
        any(),
        multipartData: any(named: 'multipartData'),
        data: any(named: 'data'),
        isShowToast: any(named: 'isShowToast'),
      ),
    ).thenAnswer((invocation) async {
      capturedMultipart = invocation.namedArguments[#multipartData] as Map<String, dynamic>?;
      return {'success': true, 'message': 'ok'};
    });

    final fileFront = FileData(name: 'front.png', bytes: Uint8List.fromList([1, 2]), sizeInMB: 0.1);
    final fileBack = FileData(name: 'back.png', bytes: Uint8List.fromList([3, 4]), sizeInMB: 0.1);

    final result = await repo.uploadbusinessKyc(
      userID: 'u',
      documentType: 'Aadhaar',
      documentNumber: '1234',
      nameOnPan: 'JOHN',
      documentFrontImage: fileFront,
      documentBackImage: fileBack,
      isAddharCard: true,
      userType: 'business',
      kycRole: 'AUTH_DIRECTOR',
    );

    expect(result, isA<CommonSuccessModel>());
    expect(capturedMultipart, isNotNull);
    expect(capturedMultipart!['front_doc'], equals(fileFront));
    expect(capturedMultipart!['back_doc'], equals(fileBack));
  });

  test('uploadbusinessKyc sets back_doc null when isAddharCard false', () async {
    Map<String, dynamic>? capturedMultipart;

    when(
      () => mockApiClient.request(
        RequestType.MULTIPART_POST,
        any(),
        multipartData: any(named: 'multipartData'),
        data: any(named: 'data'),
        isShowToast: any(named: 'isShowToast'),
      ),
    ).thenAnswer((invocation) async {
      capturedMultipart = invocation.namedArguments[#multipartData] as Map<String, dynamic>?;
      return {'success': true, 'message': 'ok'};
    });

    final fileFront = FileData(name: 'front.png', bytes: Uint8List.fromList([1, 2]), sizeInMB: 0.1);

    await repo.uploadbusinessKyc(
      userID: 'u',
      documentType: 'PAN',
      documentNumber: 'ABCDE1234F',
      nameOnPan: 'JOHN',
      documentFrontImage: fileFront,
      documentBackImage: null,
      isAddharCard: false,
      userType: 'business',
      kycRole: null,
    );

    expect(capturedMultipart, isNotNull);
    expect(capturedMultipart!['back_doc'], isNull);
  });

  test('generateCaptcha returns CaptchaModel', () async {
    when(
      () => mockApiClient.request(
        RequestType.GET,
        any(),
        data: any(named: 'data'),
        isShowToast: any(named: 'isShowToast'),
      ),
    ).thenAnswer(
      (_) async => {
        'code': 200,
        'timestamp': 111,
        'transaction_id': 't1',
        'data': {'captcha': 'img', 'session_id': 's1'},
      },
    );

    final res = await repo.generateCaptcha(
      userID: 'u',
      aadhaarNumber: '1234',
      userType: 'business',
      kycRole: 'AUTH_DIRECTOR',
    );
    expect(res, isA<CaptchaModel>());
    expect(res.code, 200);
    expect(res.data?.captcha, 'img');
    expect(res.data?.sessionId, 's1');
  });

  test('reGenerateCaptcha returns RecaptchaModel', () async {
    when(
      () => mockApiClient.request(
        RequestType.GET,
        any(),
        data: any(named: 'data'),
        isShowToast: any(named: 'isShowToast'),
      ),
    ).thenAnswer(
      (_) async => {
        'timestamp': 222,
        'transaction_id': 't2',
        'code': 200,
        'data': {'captcha': 'img2'},
      },
    );
    final res = await repo.reGenerateCaptcha(sessionId: 's2');
    expect(res, isA<RecaptchaModel>());
    expect(res.data?.captcha, 'img2');
  });

  test('generateAadharOTP returns AadharOTPSendModel and passes correct data', () async {
    Map<String, dynamic>? capturedData;
    when(
      () => mockApiClient.request(
        RequestType.POST,
        any(),
        data: any(named: 'data'),
        isShowToast: any(named: 'isShowToast'),
      ),
    ).thenAnswer((invocation) async {
      capturedData = invocation.namedArguments[#data] as Map<String, dynamic>?;
      return {'success': true, 'otp_status': 'SENT'};
    });

    final res = await repo.generateAadharOTP(aadhaarNumber: '1234', captcha: 'c', sessionId: 's');
    expect(res, isA<AadharOTPSendModel>());
    expect(capturedData, containsPair('aadhaar_number', '1234'));
    expect(capturedData, containsPair('captcha', 'c'));
    expect(capturedData, containsPair('session_id', 's'));
  });

  test('validateAadharOtp forces faker=false and returns AadharOTPVerifyModel', () async {
    Map<String, dynamic>? capturedData;
    when(
      () => mockApiClient.request(
        RequestType.POST,
        any(),
        data: any(named: 'data'),
        isShowToast: any(named: 'isShowToast'),
      ),
    ).thenAnswer((invocation) async {
      capturedData = invocation.namedArguments[#data] as Map<String, dynamic>?;
      return {'success': true, 'verification_status': 'VERIFIED'};
    });

    final res = await repo.validateAadharOtp(
      faker: true,
      otp: '000000',
      sessionId: 's',
      userId: 'u',
      kycRole: 'AUTH',
      userType: 'business',
      aadhaarNumber: '1234',
    );
    expect(res, isA<AadharOTPVerifyModel>());
    expect(capturedData, isNotNull);
    expect(capturedData!['faker'], isFalse);
    expect(capturedData!['otp'], equals('000000'));
    expect(capturedData!['session_id'], equals('s'));
    expect(capturedData!['user_id'], equals('u'));
    expect(capturedData!['kyc_role'], equals('AUTH'));
  });

  test('getGSTDetails returns GetGstDetailsModel and includes payload', () async {
    Map<String, dynamic>? capturedData;
    when(
      () => mockApiClient.request(
        RequestType.POST,
        any(),
        data: any(named: 'data'),
        isShowToast: any(named: 'isShowToast'),
      ),
    ).thenAnswer((invocation) async {
      capturedData = invocation.namedArguments[#data] as Map<String, dynamic>?;
      return {
        'success': true,
        'data': {'legal_name': 'Exchek', 'message': 'ok', 'status': 'ACTIVE'},
      };
    });

    final res = await repo.getGSTDetails(userID: 'u', estimatedAnnualIncome: 'Less than 20L', gstNumber: 'GST123');
    expect(res, isA<GetGstDetailsModel>());
    expect(capturedData, containsPair('user_id', 'u'));
    expect(capturedData, containsPair('estimated_annual_income', 'Less than 20L'));
    expect(capturedData, containsPair('gst_number', 'GST123'));
  });

  test('uploadGSTDocument uses MULTIPART_POST and returns CommonSuccessModel', () async {
    Map<String, dynamic>? capturedMultipart;
    when(
      () => mockApiClient.request(
        RequestType.MULTIPART_POST,
        any(),
        multipartData: any(named: 'multipartData'),
        data: any(named: 'data'),
        isShowToast: any(named: 'isShowToast'),
      ),
    ).thenAnswer((invocation) async {
      capturedMultipart = invocation.namedArguments[#multipartData] as Map<String, dynamic>?;
      return {'success': true, 'message': 'uploaded'};
    });

    final file = FileData(name: 'gst.pdf', bytes: Uint8List.fromList([1]), sizeInMB: 0.1);
    final res = await repo.uploadGSTDocument(userID: 'u', gstNumber: 'GST', userType: 'business', gstCertificate: file);
    expect(res, isA<CommonSuccessModel>());
    expect(capturedMultipart, containsPair('user_id', 'u'));
    expect(capturedMultipart, containsPair('gst_number', 'GST'));
    expect(capturedMultipart, containsPair('user_type', 'business'));
    expect(capturedMultipart!['gst_certificate'], equals(file));
  });

  test('uploadContactDetails posts correct payload and returns CommonSuccessModel', () async {
    Map<String, dynamic>? capturedData;
    when(
      () => mockApiClient.request(
        RequestType.POST,
        any(),
        data: any(named: 'data'),
        isShowToast: any(named: 'isShowToast'),
      ),
    ).thenAnswer((invocation) async {
      capturedData = invocation.namedArguments[#data] as Map<String, dynamic>?;
      return {'success': true, 'message': 'ok'};
    });

    final res = await repo.uploadContactDetails(userID: 'u', mobileNumber: '9999999999', emailId: 'a@b.com');
    expect(res, isA<CommonSuccessModel>());
    expect(capturedData, containsPair('user_id', 'u'));
    expect(capturedData, containsPair('mobile', '9999999999'));
    expect(capturedData, containsPair('email', 'a@b.com'));
  });

  test('uploadBeneficialOwnerAddress allows nulls and returns CommonSuccessModel', () async {
    Map<String, dynamic>? capturedData;
    when(
      () => mockApiClient.request(
        RequestType.POST,
        any(),
        data: any(named: 'data'),
        isShowToast: any(named: 'isShowToast'),
      ),
    ).thenAnswer((invocation) async {
      capturedData = invocation.namedArguments[#data] as Map<String, dynamic>?;
      return {'success': true, 'message': 'ok'};
    });

    final res = await repo.uploadBeneficialOwnerAddress(
      userID: 'u',
      useAadhaar: 'yes',
      kycRole: 'AUTH',
      country: null,
      state: null,
      city: null,
      pincode: null,
      addressLine1: null,
      addressLine2: null,
    );
    expect(res, isA<CommonSuccessModel>());
    expect(capturedData, containsPair('user_id', 'u'));
    expect(capturedData, containsPair('use_aadhaar', 'yes'));
    expect(capturedData, containsPair('kyc_role', 'AUTH'));
    // null fields are present with null values
    expect(capturedData!.keys, containsAll(['country', 'state', 'city', 'pincode', 'address_line1', 'address_line2']));
  });

  test('deleteDocument posts provided optional fields and returns CommonSuccessModel', () async {
    Map<String, dynamic>? capturedData;
    when(
      () => mockApiClient.request(
        RequestType.POST,
        any(),
        data: any(named: 'data'),
        isShowToast: any(named: 'isShowToast'),
      ),
    ).thenAnswer((invocation) async {
      capturedData = invocation.namedArguments[#data] as Map<String, dynamic>?;
      return {'success': true, 'message': 'deleted'};
    });

    final res = await repo.deleteDocument(
      documentNumber: 'DN',
      documentType: 'PAN',
      kycRole: 'AUTH',
      path: 'uploads/path/file.pdf',
      screenName: 'SCREEN',
      userId: 'u',
    );
    expect(res, isA<CommonSuccessModel>());
    expect(capturedData, containsPair('document_number', 'DN'));
    expect(capturedData, containsPair('document_type', 'PAN'));
    expect(capturedData, containsPair('kyc_role', 'AUTH'));
    expect(capturedData, containsPair('path', 'uploads/path/file.pdf'));
    expect(capturedData, containsPair('screen_name', 'SCREEN'));
    expect(capturedData, containsPair('user_id', 'u'));
  });

  test('uploadProofOfBusiness uses MULTIPART_POST and includes all files', () async {
    Map<String, dynamic>? capturedMultipart;
    when(
      () => mockApiClient.request(
        RequestType.MULTIPART_POST,
        any(),
        multipartData: any(named: 'multipartData'),
        data: any(named: 'data'),
        isShowToast: any(named: 'isShowToast'),
      ),
    ).thenAnswer((invocation) async {
      capturedMultipart = invocation.namedArguments[#multipartData] as Map<String, dynamic>?;
      return {'success': true, 'message': 'ok'};
    });

    f(String name) => FileData(name: name, bytes: Uint8List.fromList([1]), sizeInMB: 0.1);

    final res = await repo.uploadProofOfBusiness(
      userID: 'u',
      hasProofOfBusiness: 'yes',
      udyam: f('udyam.pdf'),
      shopLicense: f('shop.pdf'),
      proftaxReg: f('proftax.pdf'),
      utilityBill: f('bill.pdf'),
    );
    expect(res, isA<CommonSuccessModel>());
    expect(capturedMultipart, containsPair('user_id', 'u'));
    expect(capturedMultipart, containsPair('has_proof_of_business', 'yes'));
    expect(capturedMultipart!['udyam'], isA<FileData>());
    expect(capturedMultipart!['shop_license'], isA<FileData>());
    expect(capturedMultipart!['proftax_reg'], isA<FileData>());
    expect(capturedMultipart!['utility_bill'], isA<FileData>());
  });
}
