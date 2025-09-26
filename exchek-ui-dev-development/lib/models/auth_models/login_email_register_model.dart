class LoginEmailPasswordModel {
  bool? success;
  Data? data;

  LoginEmailPasswordModel({this.success, this.data});

  LoginEmailPasswordModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  String? token;
  User? user;
  String? message;

  Data({this.token, this.user, this.message});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class User {
  String? userId;
  String? userName;
  String? email;
  String? mobileNumber;
  String? createdAt;
  String? updatedAt;
  String? finalKycStatus;

  User({
    this.userId,
    this.userName,
    this.email,
    this.mobileNumber,
    this.createdAt,
    this.updatedAt,
    this.finalKycStatus,
  });

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    email = json['email'];
    mobileNumber = json['mobile_number'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    finalKycStatus = json['final_kyc_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['email'] = email;
    data['mobile_number'] = mobileNumber;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['final_kyc_status'] = finalKycStatus;
    return data;
  }
}
