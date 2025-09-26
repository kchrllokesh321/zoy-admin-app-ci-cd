class AadharOTPSendModel {
  final int? code;
  final int? timestamp;
  final String? transactionId;
  final String? subCode;
  final String? message;

  AadharOTPSendModel({this.code, this.timestamp, this.transactionId, this.subCode, this.message});

  factory AadharOTPSendModel.fromJson(Map<String, dynamic> json) {
    return AadharOTPSendModel(
      code: json['code'],
      timestamp: json['timestamp'],
      transactionId: json['transaction_id'],
      subCode: json['sub_code'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'timestamp': timestamp,
      'transaction_id': transactionId,
      'sub_code': subCode,
      'message': message,
    };
  }
}
