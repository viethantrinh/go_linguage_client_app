// To parse this JSON data, do
//
//     final submitResopnseModel = submitResopnseModelFromJson(jsonString);

import 'dart:convert';

SubmitResopnseModel submitResopnseModelFromJson(String str) =>
    SubmitResopnseModel.fromJson(json.decode(str));

String submitResopnseModelToJson(SubmitResopnseModel data) =>
    json.encode(data.toJson());

class SubmitResopnseModel {
  List<Achievement> achievements;

  SubmitResopnseModel({
    required this.achievements,
  });

  factory SubmitResopnseModel.fromJson(Map<String, dynamic> json) =>
      SubmitResopnseModel(
        achievements: List<Achievement>.from(
            json["achievements"].map((x) => Achievement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "achievements": List<dynamic>.from(achievements.map((x) => x.toJson())),
      };
}

class Achievement {
  String name;
  String description;
  String imageUrl;

  Achievement({
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
        name: json["name"],
        description: json["description"],
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "imageUrl": imageUrl,
      };
}
