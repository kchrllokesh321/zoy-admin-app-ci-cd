class VerifyEmailModel {
  bool? success;
  VerifyEmailData? data;

  VerifyEmailModel({this.success, this.data});

  VerifyEmailModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data =
        json['data'] != null ? VerifyEmailData.fromJson(json['data']) : VerifyEmailData(message: json['error'] ?? '');
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

class VerifyEmailData {
  bool? status;
  String? message;
  String? email;
  String? token;

  VerifyEmailData({this.status, this.message, this.email, this.token});

  VerifyEmailData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    email = json['email'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['email'] = email;
    data['token'] = token;
    return data;
  }
}
