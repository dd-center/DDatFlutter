class ResultModel {
  String key;
  dynamic data;

  ResultModel({this.key, this.data});

  ResultModel.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['data'] = this.data;
    return data;
  }
}
