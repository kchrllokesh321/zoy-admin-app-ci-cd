class GetDropdownOptionModel {
  bool? success;
  Data? data;

  GetDropdownOptionModel({this.success, this.data});

  GetDropdownOptionModel.fromJson(Map<String, dynamic> json) {
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
  Personal? personal;
  Business? business;

  Data({this.personal, this.business});

  Data.fromJson(Map<String, dynamic> json) {
    personal = json['Personal'] != null ? Personal.fromJson(json['Personal']) : null;
    business = json['Business'] != null ? Business.fromJson(json['Business']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (personal != null) {
      data['Personal'] = personal!.toJson();
    }
    if (business != null) {
      data['Business'] = business!.toJson();
    }
    return data;
  }
}

class Personal {
  List<String>? freelancer;

  Personal({this.freelancer});

  Personal.fromJson(Map<String, dynamic> json) {
    freelancer = json['Freelancer'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Freelancer'] = freelancer;
    return data;
  }
}

class Business {
  List<String>? exportOfGoods;
  List<String>? exportOfGoodsServices;
  List<String>? exportOfServices;

  Business({this.exportOfGoods, this.exportOfGoodsServices, this.exportOfServices});

  Business.fromJson(Map<String, dynamic> json) {
    exportOfGoods = json['Export of Goods'].cast<String>();
    exportOfGoodsServices = json['Export of Goods & Services'].cast<String>();
    exportOfServices = json['Export of Services'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Export of Goods'] = exportOfGoods;
    data['Export of Goods & Services'] = exportOfGoodsServices;
    data['Export of Services'] = exportOfServices;
    return data;
  }
}
