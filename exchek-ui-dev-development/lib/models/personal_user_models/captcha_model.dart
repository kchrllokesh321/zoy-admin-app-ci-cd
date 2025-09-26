class CaptchaModel {
  int? code;
  Data? data;
  int? timestamp;
  String? transactionId;

  CaptchaModel({this.code, this.data, this.timestamp, this.transactionId});

  factory CaptchaModel.fromJson(Map<String, dynamic> json) => CaptchaModel(
    code: json["code"] is int ? json["code"] : int.tryParse(json["code"].toString()) ?? 0,
    data: json["data"] != null ? Data.fromJson(json["data"]) : null,
    timestamp: json["timestamp"] is int ? json["timestamp"] : int.tryParse(json["timestamp"].toString()) ?? 0,
    transactionId: json["transaction_id"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": data?.toJson(),
    "timestamp": timestamp,
    "transaction_id": transactionId,
  };
}

class Data {
  String? captcha;
  String? sessionId;

  Data({this.captcha, this.sessionId});

  factory Data.fromJson(Map<String, dynamic> json) => Data(captcha: json["captcha"], sessionId: json["session_id"]);

  Map<String, dynamic> toJson() => {"captcha": captcha, "session_id": sessionId};
}
