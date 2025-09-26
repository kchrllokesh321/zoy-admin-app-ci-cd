import 'package:exchek/core/flavor_config/flavor_config.dart';

class ApiEndPoint {
  static String get baseUrl => FlavorConfig.instance.env.baseUrl;
  static String get ipUrl => 'https://api.ipify.org?format=json';

  static String get socialLoginUrl => '$baseUrl/auth/social-login';
  static String get emailavailability => '$baseUrl/api/v1/auth/email-availability';
  static String get mobileavailability => '$baseUrl/api/v1/auth/mobile-availability';
  static String get sendEmailVerificationLinkUrl => '$baseUrl/api/v1/email/send-email-verification-link';
  static String get sendOtpUrl => '$baseUrl/api/v1/whatsapp/send_otp';
  static String get validateLoginOtpUrl => '$baseUrl/api/v1/whatsapp/validate_login_otp';
  static String get validateRegistrationOtpUrl => '$baseUrl/api/v1/whatsapp/validate_registration_otp';
  static String get updatePasswordUrl => '$baseUrl/api/v1/auth/update-password';
  static String get getDropdownOptionUrl => '$baseUrl/api/v1/dropdown-options/get-user-service-options';
  static String get loginurl => '$baseUrl/api/v1/auth/login';
  static String get registerurl => '$baseUrl/api/v1/auth/register';
  static String get getCurrencyOptionUrl => '$baseUrl/api/v1/dropdown-options/get-currency-options';
  static String get validateForgotPasswordOtpUrl => '$baseUrl/api/v1/whatsapp/validate_forgot_otp';
  static String get logoutUrl => '$baseUrl/api/v1/auth/logout';
  static String get refreshTokenUrl => '$baseUrl/api/v1/auth/refresh-token';
  static String get uploadPersonalKycUrl => '$baseUrl/api/v1/upload/personal-kyc';
  static String get generateCaptchaUrl => '$baseUrl/api/v1/aadhar/generate-captcha';
  static String get generateReCaptchaUrl => '$baseUrl/api/v1/aadhar/re-captcha';
  static String get generateAadharOTP => '$baseUrl/api/v1/aadhar/generate-otp';
  static String get validateAadharOTPUrl => '$baseUrl/api/v1/aadhar/verify-otp';
  static String get getPanDetailUrl => '$baseUrl/api/v1/aadhar/get-pan-details';
  static String get getCityAndStateUrl => '$baseUrl/api/v1/googleapi/get-city-and-state';
  static String get uploadResidentialAddressDetailsUrl => '$baseUrl/api/v1/upload/residential-address-details';
  static String get getKycDetailsUrl => '$baseUrl/api/v1/details/get-kyc-status/';
  static String get getGSTDetailsUrl => '$baseUrl/api/v1/gst/get-details';
  static String get gstDocumentUrl => '$baseUrl/api/v1/upload/gst-document';
  static String get businessLegalDocuments => '$baseUrl/api/v1/upload/business-legal-documents';
  static String get verifyBankAccountUrl => '$baseUrl/api/v1/bank/verify';
  static String get uploadBankDocumentUrl => '$baseUrl/api/v1/upload/bank-document';
  static String get presignedUrl => '$baseUrl/api/v1/upload/presigned-url';
  static String get uploadPanDetailsUrl => '$baseUrl/api/v1/upload/pan-details';
  static String get uploadContactDetailsUrl => '$baseUrl/api/v1/upload/contact-details';
  static String get uploadBeneficialOwnerAddressUrl => '$baseUrl/api/v1/upload/beneficial-owner-address';
  static String get uploadDeleteDocumentUrl => '$baseUrl/api/v1/upload/delete-document';
  static String get uploadProofOfBusinessUrl => '$baseUrl/api/v1/upload/proof-of-business';

  // Clients
  static String get listClientsUrl => '$baseUrl/api/v1/clients/list-client';
  static String get createClientUrl => '$baseUrl/api/v1/clients/create-client';
  static String get listClientsNamesUrl => '$baseUrl/api/v1/clients/list-client-name';
  static String get getClientDetailsUrl => '$baseUrl/api/v1/clients/get-client-details';
  static String get countryCodeNameUrl  => '$baseUrl/api/v1/countries/all';
  static String get countryClientTypeOptionsUrl  => '$baseUrl/api/v1/country-clients/options';
   static String get updateClientUrl => '$baseUrl/api/v1/clients/update-client';


  // Invoices
  static String get listInvoicesUrl => '$baseUrl/api/v1/invoices/list-of-invoices';
  static String get uploadInvoiceUrl => '$baseUrl/api/v1/invoices/upload-invoices';
  static String get editDraftInvoiceUrl => '$baseUrl/api/v1/invoices/edit-draft-invoices';
  static String get editReceivableActiveInvoiceUrl => '$baseUrl/api/v1/invoices/edit-receivable-active-invoices';
  static String get deleteCancelledInvoiceUrl => '$baseUrl/api/v1/invoices/delete-cancelled-invoices';
  static String get remindInvoiceToEmailUrl => '$baseUrl/api/v1/invoices/remind-invoice-to-email';
  static String get loadEmailContentForInvoiceUrl => '$baseUrl/api/v1/invoices/get-share-invoice-email-content';
  static String get sendInvoiceToEmailUrl => '$baseUrl/api/v1/invoices/send-invoice-to-email';
  static String get getListOfCurrencies => '$baseUrl/api/v1/dropdown-options/currency-code';
  static String get getusedCurrencys => '$baseUrl/api/v1/receiving-accounts/used-currencies'; // get used currencies 
  static String get createRecevingAccount => '$baseUrl/api/v1/receiving-accounts/create'; // create receving account
  static String get getPurposeCodes => '$baseUrl/api/v1/dropdown-options/purpose-code';
  static String get getBalanceResponse => '$baseUrl/api/v1/balance/all';
}
