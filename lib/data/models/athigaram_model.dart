// To parse this JSON data, do
//
//     final athigaramModel = athigaramModelFromJson(jsonString);

import 'dart:convert';

List<AthigaramModel> athigaramModelFromJson(String str) => List<AthigaramModel>.from(json.decode(str).map((x) => AthigaramModel.fromJson(x)));

String athigaramModelToJson(List<AthigaramModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AthigaramModel {
  dynamic athigaramNo;
  String? name;
  String? translation;
  String? transliteration;

  AthigaramModel({
    this.athigaramNo,
    this.name,
    this.translation,
    this.transliteration,
  });

  factory AthigaramModel.fromJson(Map<String, dynamic> json) => AthigaramModel(
    athigaramNo: json["athigaram_no"],
    name: json["name"],
    translation: json["translation"],
    transliteration: json["transliteration"],
  );

  Map<String, dynamic> toJson() => {
    "athigaram_no": athigaramNo,
    "name": name,
    "translation": translation,
    "transliteration": transliteration,
  };
}
