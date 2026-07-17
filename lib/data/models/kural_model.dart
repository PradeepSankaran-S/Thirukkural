// To parse this JSON data, do
//
//     final kuralModel = kuralModelFromJson(jsonString);

import 'dart:convert';

KuralModel kuralModelFromJson(String str) => KuralModel.fromJson(json.decode(str));

String kuralModelToJson(KuralModel data) => json.encode(data.toJson());

class KuralModel {
  List<Kural>? kural;

  KuralModel({
    this.kural,
  });

  factory KuralModel.fromJson(Map<String, dynamic> json) => KuralModel(
    kural: json["kural"] == null ? [] : List<Kural>.from(json["kural"]!.map((x) => Kural.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "kural": kural == null ? [] : List<dynamic>.from(kural!.map((x) => x.toJson())),
  };
}

class Kural {
  int? number;
  String? line1;
  String? line2;
  String? translation;
  String? mv;
  String? sp;
  String? mk;
  String? explanation;
  String? couplet;
  String? transliteration1;
  String? transliteration2;

  Kural({
    this.number,
    this.line1,
    this.line2,
    this.translation,
    this.mv,
    this.sp,
    this.mk,
    this.explanation,
    this.couplet,
    this.transliteration1,
    this.transliteration2,
  });

  factory Kural.fromJson(Map<String, dynamic> json) => Kural(
    number: json["Number"],
    line1: json["Line1"],
    line2: json["Line2"],
    translation: json["Translation"],
    mv: json["mv"],
    sp: json["sp"],
    mk: json["mk"],
    explanation: json["explanation"],
    couplet: json["couplet"],
    transliteration1: json["transliteration1"],
    transliteration2: json["transliteration2"],
  );

  Map<String, dynamic> toJson() => {
    "Number": number,
    "Line1": line1,
    "Line2": line2,
    "Translation": translation,
    "mv": mv,
    "sp": sp,
    "mk": mk,
    "explanation": explanation,
    "couplet": couplet,
    "transliteration1": transliteration1,
    "transliteration2": transliteration2,
  };
}
