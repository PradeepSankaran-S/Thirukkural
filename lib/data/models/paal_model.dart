// To parse this JSON data, do
//
//     final paalModel = paalModelFromJson(jsonString);

import 'dart:convert';

List<PaalModel> paalModelFromJson(String str) => List<PaalModel>.from(json.decode(str).map((x) => PaalModel.fromJson(x)));

String paalModelToJson(List<PaalModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaalModel {
  int? id;
  String? nameTamil;
  String? nameEnglish;

  PaalModel({
    this.id,
    this.nameTamil,
    this.nameEnglish,
  });

  factory PaalModel.fromJson(Map<String, dynamic> json) => PaalModel(
    id: json["id"],
    nameTamil: json["nameTamil"],
    nameEnglish: json["nameEnglish"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nameTamil": nameTamil,
    "nameEnglish": nameEnglish,
  };
}
