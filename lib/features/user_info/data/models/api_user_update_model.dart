// To parse this JSON data, do
//
//     final userUpdateResopnseModel = userUpdateResopnseModelFromJson(jsonString);

import 'dart:convert';

UserUpdateResopnseModel userUpdateResopnseModelFromJson(String str) =>
    UserUpdateResopnseModel.fromJson(json.decode(str));

String userUpdateResopnseModelToJson(UserUpdateResopnseModel data) =>
    json.encode(data.toJson());

class UserUpdateResopnseModel {
  int id;
  String name;
  String email;

  UserUpdateResopnseModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserUpdateResopnseModel.fromJson(Map<String, dynamic> json) =>
      UserUpdateResopnseModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
      };
}
