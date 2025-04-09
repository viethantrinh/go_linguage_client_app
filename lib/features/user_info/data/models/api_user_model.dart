// To parse this JSON data, do
//
//     final userResopnseModel = userResopnseModelFromJson(jsonString);

import 'dart:convert';

UserResopnseModel userResopnseModelFromJson(String str) =>
    UserResopnseModel.fromJson(json.decode(str));

String userResopnseModelToJson(UserResopnseModel data) =>
    json.encode(data.toJson());

class UserResopnseModel {
  int id;
  String name;
  String email;
  int totalXpPoints;
  int totalGoPoints;
  List<Achievement> achievements;

  UserResopnseModel({
    required this.id,
    required this.name,
    required this.email,
    required this.totalXpPoints,
    required this.totalGoPoints,
    required this.achievements,
  });

  factory UserResopnseModel.fromJson(Map<String, dynamic> json) =>
      UserResopnseModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        totalXpPoints: json["totalXPPoints"],
        totalGoPoints: json["totalGoPoints"],
        achievements: List<Achievement>.from(
            json["achievements"].map((x) => Achievement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "totalXPPoints": totalXpPoints,
        "totalGoPoints": totalGoPoints,
        "achievements": List<dynamic>.from(achievements.map((x) => x.toJson())),
      };
}

class Achievement {
  String name;
  String description;
  String imageUrl;
  int current;
  int target;

  Achievement({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.current,
    required this.target,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
        name: json["name"],
        description: json["description"],
        imageUrl: json["imageUrl"],
        current: json["current"],
        target: json["target"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "imageUrl": imageUrl,
        "current": current,
        "target": target,
      };
}
