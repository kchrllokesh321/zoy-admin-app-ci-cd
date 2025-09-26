class GetGstDetailsModel {
  bool? success;
  Data? data;

  GetGstDetailsModel({this.success, this.data});

  factory GetGstDetailsModel.fromJson(Map<String, dynamic> json) =>
      GetGstDetailsModel(success: json["success"], data: Data.fromJson(json["data"]));

  Map<String, dynamic> toJson() => {"success": success, "data": data?.toJson()};
}

class Data {
  String? legalName;
  String? message;
  String? status;

  Data({this.legalName, this.message, this.status});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(legalName: json["legal_name"], message: json["message"], status: json["status"]);

  Map<String, dynamic> toJson() => {"legal_name": legalName, "message": message, "status": status};
}
