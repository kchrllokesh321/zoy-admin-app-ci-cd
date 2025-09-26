class GetCityAndStateModel {
  bool? success;
  Data? data;

  GetCityAndStateModel({this.success, this.data});

  factory GetCityAndStateModel.fromJson(Map<String, dynamic> json) =>
      GetCityAndStateModel(success: json["success"], data: Data.fromJson(json["data"]));

  Map<String, dynamic> toJson() => {"success": success, "data": data?.toJson()};
}

class Data {
  String? city;
  String? state;

  Data({this.city, this.state});

  factory Data.fromJson(Map<String, dynamic> json) => Data(city: json["city"], state: json["state"]);

  Map<String, dynamic> toJson() => {"city": city, "state": state};
}
