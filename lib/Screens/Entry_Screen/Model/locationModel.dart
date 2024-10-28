import 'dart:convert';

class GetOfficeModel {
  int? officeId;
  String? name;

  GetOfficeModel({
    this.officeId,
    this.name,
  });

  factory GetOfficeModel.fromRawJson(String str) =>
      GetOfficeModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetOfficeModel.fromJson(Map<String, dynamic> json) => GetOfficeModel(
        officeId: json["officeID"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "officeID": officeId,
        "name": name,
      };
}
