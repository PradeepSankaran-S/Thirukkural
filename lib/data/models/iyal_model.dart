// To parse this JSON data, do
//
//     final iyalModel = iyalModelFromJson(jsonString);

import 'dart:convert';

List<IyalModel> iyalModelFromJson(String str) => List<IyalModel>.from(json.decode(str).map((x) => IyalModel.fromJson(x)));

String iyalModelToJson(List<IyalModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class IyalModel {
  int? iyalNo;
  String? name;
  String? translation;
  String? transliteration;

  IyalModel({
    this.iyalNo,
    this.name,
    this.translation,
    this.transliteration,
  });

  factory IyalModel.fromJson(Map<String, dynamic> json) => IyalModel(
    iyalNo: json["iyal_no"],
    name: json["name"],
    translation: json["translation"],
    transliteration: json["transliteration"],
  );

  Map<String, dynamic> toJson() => {
    "iyal_no": iyalNo,
    "name": name,
    "translation": translation,
    "transliteration": transliteration,
  };
}
