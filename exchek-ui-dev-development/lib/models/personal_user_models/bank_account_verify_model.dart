class BankAccountVerifyModel {
  bool? success;
  Data? data;

  BankAccountVerifyModel({this.success, this.data});

  BankAccountVerifyModel.fromJson(Map<String, dynamic> json) {
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
  String? accountHolderName;
  String? message;
  String? status;

  Data({this.accountHolderName, this.message, this.status});

  Data.fromJson(Map<String, dynamic> json) {
    accountHolderName = json['account_holder_name'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['account_holder_name'] = accountHolderName;
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}
