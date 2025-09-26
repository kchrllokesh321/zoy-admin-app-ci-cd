class RecaptchaModel {
  final int? timestamp;
  final String? transactionId;
  final RecaptchaData? data;
  final int? code;

  RecaptchaModel({this.timestamp, this.transactionId, this.data, this.code});

  factory RecaptchaModel.fromJson(Map<String, dynamic> json) {
    return RecaptchaModel(
      timestamp: json['timestamp'],
      transactionId: json['transaction_id'],
      data: RecaptchaData.fromJson(json['data']),
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'timestamp': timestamp, 'transaction_id': transactionId, 'data': data?.toJson(), 'code': code};
  }
}

class RecaptchaData {
  final String? captcha;

  RecaptchaData({this.captcha});

  factory RecaptchaData.fromJson(Map<String, dynamic> json) {
    return RecaptchaData(captcha: json['captcha'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'captcha': captcha};
  }
}
