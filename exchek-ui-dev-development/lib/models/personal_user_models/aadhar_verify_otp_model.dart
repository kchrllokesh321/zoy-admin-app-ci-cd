class AadharOTPVerifyModel {
  final int? code;
  final int? timestamp;
  final String? transactionId;
  final String? subCode;
  final String? message;
  final AadharData? data; // Make nullable

  AadharOTPVerifyModel({
    this.code,
    this.timestamp,
    this.transactionId,
    this.subCode,
    this.message,
    this.data, // Nullable
  });

  factory AadharOTPVerifyModel.fromJson(Map<String, dynamic> json) {
    return AadharOTPVerifyModel(
      code: json['code'],
      timestamp: json['timestamp'],
      transactionId: json['transaction_id'],
      subCode: json['sub_code'],
      message: json['message'],
      data: json['data'] != null ? AadharData.fromJson(json['data']) : null,
    );
  }
}

class AadharData {
  final AadharAddress? address;
  final String? dateOfBirth;
  final String? email;
  final String? gender;
  final String? generatedAt;
  final String? maskedNumber;
  final String? name;
  final String? phone;
  final String? photo;

  AadharData({
    this.address,
    this.dateOfBirth,
    this.email,
    this.gender,
    this.generatedAt,
    this.maskedNumber,
    this.name,
    this.phone,
    this.photo,
  });

  factory AadharData.fromJson(Map<String, dynamic> json) {
    return AadharData(
      address: json['address'] != null ? AadharAddress.fromJson(json['address']) : AadharAddress(),
      dateOfBirth: json['date_of_birth'],
      email: json['email'],
      gender: json['gender'],
      generatedAt: json['generated_at']?.toString(),
      maskedNumber: json['masked_number'],
      name: json['name'],
      phone: json['phone'],
      photo: json['photo'],
    );
  }
}

class AadharAddress {
  final String? careOf;
  final String? country;
  final String? district;
  final String? house;
  final String? landmark;
  final String? locality;
  final String? pin;
  final String? postOffice;
  final String? state;
  final String? street;
  final String? subDistrict;
  final String? vtc;

  AadharAddress({
    this.careOf,
    this.country,
    this.district,
    this.house,
    this.landmark,
    this.locality,
    this.pin,
    this.postOffice,
    this.state,
    this.street,
    this.subDistrict,
    this.vtc,
  });

  factory AadharAddress.fromJson(Map<String, dynamic> json) {
    return AadharAddress(
      careOf: json['care_of'],
      country: json['country'],
      district: json['district'],
      house: json['house'],
      landmark: json['landmark'],
      locality: json['locality'],
      pin: json['pin'],
      postOffice: json['post_office'],
      state: json['state'],
      street: json['street'],
      subDistrict: json['sub_district'],
      vtc: json['vtc'],
    );
  }
}
