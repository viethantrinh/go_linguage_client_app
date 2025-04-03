// To parse this JSON data, do
//
//     final dIalogListResopnseModel = dIalogListResopnseModelFromJson(jsonString);

import 'dart:convert';

List<DialogListResopnseModel> dIalogListResopnseModelFromJson(String str) =>
    List<DialogListResopnseModel>.from(
        json.decode(str).map((x) => DialogListResopnseModel.fromJson(x)));

String dIalogListResopnseModelToJson(List<DialogListResopnseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DialogListResopnseModel {
  int id;
  bool isChangeSpeaker;
  String? systemEnglishText;
  String? systemVietnameseText;
  String? systemAudioUrl;
  int displayOrder;
  List<Option>? options;

  DialogListResopnseModel({
    required this.id,
    required this.isChangeSpeaker,
    this.systemEnglishText,
    this.systemVietnameseText,
    this.systemAudioUrl,
    required this.displayOrder,
    this.options,
  });

  factory DialogListResopnseModel.fromJson(Map<String, dynamic> json) =>
      DialogListResopnseModel(
        id: json["id"],
        isChangeSpeaker: json["isChangeSpeaker"],
        systemEnglishText: json["systemEnglishText"],
        systemVietnameseText: json["systemVietnameseText"],
        systemAudioUrl: json["systemAudioUrl"],
        displayOrder: json["displayOrder"],
        options: json["options"] == null
            ? []
            : List<Option>.from(
                json["options"]!.map((x) => Option.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "isChangeSpeaker": isChangeSpeaker,
        "systemEnglishText": systemEnglishText,
        "systemVietnameseText": systemVietnameseText,
        "systemAudioUrl": systemAudioUrl,
        "displayOrder": displayOrder,
        "options": options == null
            ? []
            : List<dynamic>.from(options!.map((x) => x.toJson())),
      };
}

class Option {
  String englishText;
  String vietnameseText;
  String audioUrl;
  Gender gender;

  Option({
    required this.englishText,
    required this.vietnameseText,
    required this.audioUrl,
    required this.gender,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        englishText: json["englishText"],
        vietnameseText: json["vietnameseText"],
        audioUrl: json["audioUrl"],
        gender: genderValues.map[json["gender"]]!,
      );

  Map<String, dynamic> toJson() => {
        "englishText": englishText,
        "vietnameseText": vietnameseText,
        "audioUrl": audioUrl,
        "gender": genderValues.reverse[gender],
      };
}

enum Gender { N, NAM }

final genderValues = EnumValues({"nữ": Gender.N, "nam": Gender.NAM});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
