class GetPanDetailModel {
  bool? success;
  Data? data;
  String? error;

  GetPanDetailModel({this.success, this.data, this.error});

  factory GetPanDetailModel.fromJson(Map<String, dynamic> json) {
    Data? data;
    if (json["data"] != null) {
      data = Data.fromJson(json["data"]);
    }
    return GetPanDetailModel(success: json["success"], data: data, error: json["error"]);
  }

  Map<String, dynamic> toJson() => {"success": success, "data": data?.toJson(), "error": error};
}

class Data {
  String? entity;
  String? pan;
  String? fullName;
  String? status;
  String? category;
  NameInformation? nameInformation;

  Data({this.entity, this.pan, this.fullName, this.status, this.category, this.nameInformation});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    entity: json["@entity"],
    pan: json["pan"],
    fullName: json["full_name"],
    status: json["status"],
    category: json["category"],
    nameInformation: NameInformation.fromJson(json["name_information"]),
  );

  Map<String, dynamic> toJson() => {
    "@entity": entity,
    "pan": pan,
    "full_name": fullName,
    "status": status,
    "category": category,
    "name_information": nameInformation?.toJson(),
  };
}

class NameInformation {
  String? panNameCleaned;

  NameInformation({this.panNameCleaned});

  factory NameInformation.fromJson(Map<String, dynamic> json) =>
      NameInformation(panNameCleaned: json["pan_name_cleaned"] ?? '');

  Map<String, dynamic> toJson() => {"pan_name_cleaned": panNameCleaned};
}
