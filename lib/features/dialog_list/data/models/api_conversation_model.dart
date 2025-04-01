// To parse this JSON data, do
//
//     final conversationListResopnseModel = conversationListResopnseModelFromJson(jsonString);

import 'dart:convert';

List<ConversationListResopnseModel> conversationListResopnseModelFromJson(
        String str) =>
    List<ConversationListResopnseModel>.from(
        json.decode(str).map((x) => ConversationListResopnseModel.fromJson(x)));

String conversationListResopnseModelToJson(
        List<ConversationListResopnseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ConversationListResopnseModel {
  int id;
  String name;
  String imageUrl;
  int displayOrder;
  bool premium;

  ConversationListResopnseModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.displayOrder,
    required this.premium,
  });

  factory ConversationListResopnseModel.fromJson(Map<String, dynamic> json) =>
      ConversationListResopnseModel(
        id: json["id"],
        name: json["name"],
        imageUrl: json["imageUrl"],
        displayOrder: json["displayOrder"],
        premium: json["premium"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imageUrl": imageUrl,
        "displayOrder": displayOrder,
        "premium": premium,
      };
}
