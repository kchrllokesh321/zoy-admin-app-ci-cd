class GetUserKycDetailsModel {
  bool? success;
  KycData? data;

  GetUserKycDetailsModel({this.success, this.data});

  GetUserKycDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? KycData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class KycData {
  String? userId;
  String? userEmail;
  String? userType;
  String? mobileNumber;
  List<String>? multicurrency;
  String? estimatedMonthlyVolume;
  BusinessDetails? businessDetails;
  PersonalDetails? personalDetails;
  UserIdentityDocuments? userIdentityDocuments;
  PanDetails? panDetails;
  PanDetails? kartaPanDetails;
  UserGstDetails? userGstDetails;
  IecDetails? iecDetails;
  UserAddressDocuments? userAddressDocuments;
  UserBankDetails? userBankDetails;
  BusinessIdentity? businessIdentity;
  List<BusinessDirectorList>? businessDirectorList;
  KycStatusDetails? kycStatusDetails;

  KycData({
    this.userId,
    this.userEmail,
    this.userType,
    this.mobileNumber,
    this.multicurrency,
    this.estimatedMonthlyVolume,
    this.businessDetails,
    this.personalDetails,
    this.userIdentityDocuments,
    this.panDetails,
    this.kartaPanDetails,
    this.userGstDetails,
    this.iecDetails,
    this.userAddressDocuments,
    this.userBankDetails,
    this.businessIdentity,
    this.businessDirectorList,
    this.kycStatusDetails,
  });

  KycData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userEmail = json['user_email'];
    userType = json['user_type'];
    mobileNumber = json['mobile_number'];
    multicurrency =
        (json['multicurrency'] is List)
            ? List<String>.from((json['multicurrency'] as List).map((e) => e?.toString() ?? ''))
            : null;
    estimatedMonthlyVolume = json['estimated_monthly_volume'];
    businessDetails = json['business_details'] != null ? BusinessDetails.fromJson(json['business_details']) : null;
    personalDetails = json['personal_details'] != null ? PersonalDetails.fromJson(json['personal_details']) : null;
    userIdentityDocuments =
        json['user_identity_documents'] != null
            ? UserIdentityDocuments.fromJson(json['user_identity_documents'])
            : null;
    panDetails = json['pan_details'] != null ? PanDetails.fromJson(json['pan_details']) : null;
    kartaPanDetails = json['karta_pan_details'] != null ? PanDetails.fromJson(json['karta_pan_details']) : null;
    userGstDetails = json['user_gst_details'] != null ? UserGstDetails.fromJson(json['user_gst_details']) : null;
    iecDetails = json['iec_details'] != null ? IecDetails.fromJson(json['iec_details']) : null;
    userAddressDocuments =
        json['user_address_documents'] != null ? UserAddressDocuments.fromJson(json['user_address_documents']) : null;
    userBankDetails = json['user_bank_details'] != null ? UserBankDetails.fromJson(json['user_bank_details']) : null;
    businessIdentity = json['business_identity'] != null ? BusinessIdentity.fromJson(json['business_identity']) : null;
    if (json['business_director_list'] != null) {
      businessDirectorList = <BusinessDirectorList>[];
      json['business_director_list'].forEach((v) {
        businessDirectorList!.add(BusinessDirectorList.fromJson(v));
      });
    }
    kycStatusDetails =
        json['kyc_status_details'] != null ? KycStatusDetails.fromJson(json['kyc_status_details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_email'] = userEmail;
    data['user_type'] = userType;
    data['mobile_number'] = mobileNumber;
    data['multicurrency'] = multicurrency;
    data['estimated_monthly_volume'] = estimatedMonthlyVolume;
    if (businessDetails != null) {
      data['business_details'] = businessDetails!.toJson();
    }
    if (personalDetails != null) {
      data['personal_details'] = personalDetails!.toJson();
    }
    if (userIdentityDocuments != null) {
      data['user_identity_documents'] = userIdentityDocuments!.toJson();
    }
    if (panDetails != null) {
      data['pan_details'] = panDetails!.toJson();
    }
    if (kartaPanDetails != null) {
      data['karta_pan_details'] = kartaPanDetails!.toJson();
    }
    if (userGstDetails != null) {
      data['user_gst_details'] = userGstDetails!.toJson();
    }
    if (iecDetails != null) {
      data['iec_details'] = iecDetails!.toJson();
    }
    if (userAddressDocuments != null) {
      data['user_address_documents'] = userAddressDocuments!.toJson();
    }
    if (userBankDetails != null) {
      data['user_bank_details'] = userBankDetails!.toJson();
    }
    if (businessIdentity != null) {
      data['business_identity'] = businessIdentity!.toJson();
    }
    if (businessDirectorList != null) {
      data['business_director_list'] = businessDirectorList!.map((v) => v.toJson()).toList();
    }
    if (kycStatusDetails != null) {
      data['kyc_status_details'] = kycStatusDetails!.toJson();
    }
    return data;
  }
}

class BusinessDetails {
  String? businessType;
  String? businessNature;
  List<String>? exportsType;
  String? businessLegalName;

  BusinessDetails({this.businessType, this.businessNature, this.exportsType, this.businessLegalName});

  BusinessDetails.fromJson(Map<String, dynamic> json) {
    businessType = json['business_type'];
    businessNature = json['business_nature'];
    exportsType =
        (json['exports_type'] is List)
            ? List<String>.from((json['exports_type'] as List).map((e) => e?.toString() ?? ''))
            : null;
    businessLegalName = json['business_legal_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['business_type'] = businessType;
    data['business_nature'] = businessNature;
    data['exports_type'] = exportsType;
    data['business_legal_name'] = businessLegalName;
    return data;
  }
}

class PersonalDetails {
  String? paymentPurpose;
  List<String>? profession;
  String? productDesc;
  String? legalFullName;

  PersonalDetails({this.paymentPurpose, this.profession, this.productDesc, this.legalFullName});

  PersonalDetails.fromJson(Map<String, dynamic> json) {
    paymentPurpose = json['payment_purpose'];
    profession =
        (json['profession'] is List)
            ? List<String>.from((json['profession'] as List).map((e) => e?.toString() ?? ''))
            : null;
    productDesc = json['product_desc'];
    legalFullName = json['legal_full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payment_purpose'] = paymentPurpose;
    data['profession'] = profession;
    data['product_desc'] = productDesc;
    data['legal_full_name'] = legalFullName;
    return data;
  }
}

class UserIdentityDocuments {
  String? documentType;
  String? documentNumber;
  String? frontDocUrl;
  String? identityVerifyStatus;

  UserIdentityDocuments({this.documentType, this.documentNumber, this.frontDocUrl, this.identityVerifyStatus});

  UserIdentityDocuments.fromJson(Map<String, dynamic> json) {
    documentType = json['document_type'];
    documentNumber = json['document_number'];
    frontDocUrl = json['front_doc_url'];
    identityVerifyStatus = json['identity_verify_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['document_type'] = documentType;
    data['document_number'] = documentNumber;
    data['front_doc_url'] = frontDocUrl;
    data['identity_verify_status'] = identityVerifyStatus;
    return data;
  }
}

class PanDetails {
  String? documentType;
  String? documentNumber;
  String? frontDocUrl;
  String? nameOnPan;
  String? panVerifyStatus;

  PanDetails({this.documentType, this.documentNumber, this.frontDocUrl, this.nameOnPan, this.panVerifyStatus});

  PanDetails.fromJson(Map<String, dynamic> json) {
    documentType = json['document_type'];
    documentNumber = json['document_number'];
    frontDocUrl = json['front_doc_url'];
    nameOnPan = json['name_on_pan'];
    panVerifyStatus = json['pan_verify_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['document_type'] = documentType;
    data['document_number'] = documentNumber;
    data['front_doc_url'] = frontDocUrl;
    data['name_on_pan'] = nameOnPan;
    data['pan_verify_status'] = panVerifyStatus;
    return data;
  }
}

class UserGstDetails {
  String? gstNumber;
  String? legalName;
  String? gstCertificateUrl;
  String? estimatedAnnualIncome;
  String? gstVerifyStatus;

  UserGstDetails({
    this.gstNumber,
    this.legalName,
    this.gstCertificateUrl,
    this.estimatedAnnualIncome,
    this.gstVerifyStatus,
  });

  UserGstDetails.fromJson(Map<String, dynamic> json) {
    gstNumber = json['gst_number'];
    legalName = json['legal_name'];
    gstCertificateUrl = json['gst_certificate_url'];
    estimatedAnnualIncome = json['estimated_annual_income'];
    gstVerifyStatus = json['gst_verify_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gst_number'] = gstNumber;
    data['legal_name'] = legalName;
    data['gst_certificate_url'] = gstCertificateUrl;
    data['estimated_annual_income'] = estimatedAnnualIncome;
    data['gst_verify_status'] = gstVerifyStatus;
    return data;
  }
}

class IecDetails {
  String? documentType;
  String? documentNumber;
  String? docUrl;
  String? iecVerifyStatus;

  IecDetails({this.documentType, this.documentNumber, this.docUrl, this.iecVerifyStatus});

  IecDetails.fromJson(Map<String, dynamic> json) {
    documentType = json['document_type'];
    documentNumber = json['document_number'];
    docUrl = json['doc_url'];
    iecVerifyStatus = json['iec_verify_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['document_type'] = documentType;
    data['document_number'] = documentNumber;
    data['doc_url'] = docUrl;
    data['iec_verify_status'] = iecVerifyStatus;
    return data;
  }
}

class UserAddressDocuments {
  String? documentType;
  String? country;
  String? pincode;
  String? state;
  String? city;
  String? addressLine1;
  String? frontDocUrl;
  String? residentVerifyStatus;

  UserAddressDocuments({
    this.documentType,
    this.country,
    this.pincode,
    this.state,
    this.city,
    this.addressLine1,
    this.frontDocUrl,
    this.residentVerifyStatus,
  });

  UserAddressDocuments.fromJson(Map<String, dynamic> json) {
    documentType = json['document_type'];
    country = json['country'];
    pincode = json['pincode'];
    state = json['state'];
    city = json['city'];
    addressLine1 = json['address_line1'];
    frontDocUrl = json['front_doc_url'];
    residentVerifyStatus = json['resident_verify_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['document_type'] = documentType;
    data['country'] = country;
    data['pincode'] = pincode;
    data['state'] = state;
    data['city'] = city;
    data['address_line1'] = addressLine1;
    data['front_doc_url'] = frontDocUrl;
    data['resident_verify_status'] = residentVerifyStatus;
    return data;
  }
}

class UserBankDetails {
  String? documentType;
  String? accountNumber;
  String? ifscCode;
  String? documentUrl;
  String? bankVerifyStatus;
  String? accountHolderName;

  UserBankDetails({
    this.documentType,
    this.accountNumber,
    this.ifscCode,
    this.documentUrl,
    this.bankVerifyStatus,
    this.accountHolderName,
  });

  UserBankDetails.fromJson(Map<String, dynamic> json) {
    documentType = json['document_type'];
    accountNumber = json['account_number'];
    ifscCode = json['ifsc_code'];
    documentUrl = json['document_url'];
    bankVerifyStatus = json['bank_verify_status'];
    accountHolderName = json['account_holder_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['document_type'] = documentType;
    data['account_number'] = accountNumber;
    data['ifsc_code'] = ifscCode;
    data['document_url'] = documentUrl;
    data['bank_verify_status'] = bankVerifyStatus;
    data['account_holder_name'] = accountHolderName;
    return data;
  }
}

class BusinessIdentity {
  String? documentType;
  String? documentNumber;
  String? frontDocUrl;
  String? backDocUrl;

  BusinessIdentity({this.documentType, this.documentNumber, this.frontDocUrl, this.backDocUrl});

  BusinessIdentity.fromJson(Map<String, dynamic> json) {
    documentType = json['document_type'];
    documentNumber = json['document_number'];
    frontDocUrl = json['front_doc_url'];
    backDocUrl = json['back_doc_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['document_type'] = documentType;
    data['document_number'] = documentNumber;
    data['front_doc_url'] = frontDocUrl;
    data['back_doc_url'] = backDocUrl;
    return data;
  }
}

class BusinessDirectorList {
  String? directorType;
  String? documentType;
  String? documentNumber;
  String? nameOnPan;
  String? frontDocUrl;
  String? backDocUrl;
  bool? isBusinessOwner;
  bool? isBusinessRepresentative;
  String? verifyStatus;

  BusinessDirectorList({
    this.directorType,
    this.documentType,
    this.documentNumber,
    this.nameOnPan,
    this.frontDocUrl,
    this.backDocUrl,
    this.isBusinessOwner,
    this.isBusinessRepresentative,
    this.verifyStatus,
  });

  BusinessDirectorList.fromJson(Map<String, dynamic> json) {
    directorType = json['director_type'];
    documentType = json['document_type'];
    documentNumber = json['document_number'];
    nameOnPan = json['name_on_pan'];
    frontDocUrl = json['front_doc_url'];
    backDocUrl = json['back_doc_url'];
    isBusinessOwner = json['is_business_owner'];
    isBusinessRepresentative = json['is_business_represtive'];
    verifyStatus = json['verify_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['director_type'] = directorType;
    data['document_type'] = documentType;
    data['document_number'] = documentNumber;
    data['name_on_pan'] = nameOnPan;
    data['front_doc_url'] = frontDocUrl;
    data['back_doc_url'] = backDocUrl;
    data['is_business_owner'] = isBusinessOwner;
    data['is_business_represtive'] = isBusinessRepresentative;
    data['verify_status'] = verifyStatus;
    return data;
  }
}

class KycStatusDetails {
  String? finalStatus;
  String? finalStatusComment;
  String? kycSubmittedDate;
  String? kycUpdatedDate;
  String? kycStatus;

  KycStatusDetails({
    this.finalStatus,
    this.finalStatusComment,
    this.kycSubmittedDate,
    this.kycUpdatedDate,
    this.kycStatus,
  });

  KycStatusDetails.fromJson(Map<String, dynamic> json) {
    finalStatus = json['final_status'];
    finalStatusComment = json['final_status_comment'];
    kycSubmittedDate = json['kyc_submitted_date'];
    kycUpdatedDate = json['kyc_updated_date'];
    kycStatus = json['kyc_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['final_status'] = finalStatus;
    data['final_status_comment'] = finalStatusComment;
    data['kyc_submitted_date'] = kycSubmittedDate;
    data['kyc_updated_date'] = kycUpdatedDate;
    data['kyc_status'] = kycStatus;
    return data;
  }
}
