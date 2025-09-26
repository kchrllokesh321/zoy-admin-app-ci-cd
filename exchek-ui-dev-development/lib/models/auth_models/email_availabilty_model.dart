class EmailAvailabilityModel {
  bool? success;
  Data? data;

  EmailAvailabilityModel({this.success, this.data});

  EmailAvailabilityModel.fromJson(Map<String, dynamic> json) {
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
  bool? exists;
  User? user;

  Data({this.exists, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    exists = json['exists'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['exists'] = exists;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? userId;
  String? userName;
  String? email;
  String? createdAt;
  String? updatedAt;
  String? mobileNumber;

  User({this.userId, this.userName, this.email, this.createdAt, this.updatedAt, this.mobileNumber});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    email = json['email'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    mobileNumber = json['mobile_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['email'] = email;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['mobile_number'] = mobileNumber;
    return data;
  }
}
