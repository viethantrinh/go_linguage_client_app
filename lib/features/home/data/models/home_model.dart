import 'package:flutter/material.dart';
import 'package:go_linguage/core/common/global/global_variable.dart';

class HomeResponseModel {
  final int streakPoints;
  final int goPoints;
  final bool isSubscribed;
  List<LevelModel> levels;

  HomeResponseModel({
    required this.streakPoints,
    required this.goPoints,
    required this.isSubscribed,
    required this.levels,
  });

  factory HomeResponseModel.fromJson(Map<String, dynamic> json) {
    return HomeResponseModel(
      streakPoints: json['streakPoints'] ?? 0,
      goPoints: json['goPoints'] ?? 0,
      isSubscribed: json['isSubscribed'] ?? false,
      levels: (json['levels'] as List<dynamic>?)
              ?.map((level) => LevelModel.fromJson(level))
              .toList() ??
          [],
    );
  }

  HomeResponseModel copyWith({
    int? streakPoints,
    int? goPoints,
    bool? isSubscribed,
    List<LevelModel>? levels,
  }) {
    return HomeResponseModel(
      streakPoints: streakPoints ?? this.streakPoints,
      goPoints: goPoints ?? this.goPoints,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      levels: levels ?? this.levels,
    );
  }
}

class LevelModel {
  final int id;
  final String name;
  int totalUserXPPoints;
  List<TopicModel> topics;
  final int displayOrder;

  LevelModel({
    required this.id,
    required this.name,
    required this.totalUserXPPoints,
    required this.topics,
    required this.displayOrder,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      totalUserXPPoints: json['totalUserXPPoints'] ?? 0,
      topics: (json['topics'] as List<dynamic>?)
              ?.map((topic) => TopicModel.fromJson(topic))
              .toList() ??
          [],
      displayOrder: json['displayOrder'] ?? 0,
    );
  }

  LevelModel copyWith({
    int? totalUserXPPoints,
    List<TopicModel>? topics,
  }) {
    return LevelModel(
      id: id,
      name: name,
      totalUserXPPoints: totalUserXPPoints ?? this.totalUserXPPoints,
      topics: topics ?? this.topics,
      displayOrder: displayOrder,
    );
  }
}

class TopicModel {
  final int id;
  final String name;
  final String imageUrl;
  int totalUserXPPoints;
  final int displayOrder;
  final bool premium;

  TopicModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.totalUserXPPoints,
    required this.displayOrder,
    required this.premium,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      totalUserXPPoints: json['totalUserXPPoints'] ?? 0,
      displayOrder: json['displayOrder'] ?? 0,
      premium: json['premium'] ?? false,
    );
  }

  TopicModel copyWith({
    int? totalUserXPPoints,
  }) {
    return TopicModel(
      id: id,
      name: name,
      imageUrl: imageUrl,
      totalUserXPPoints: totalUserXPPoints ?? this.totalUserXPPoints,
      displayOrder: displayOrder,
      premium: premium,
    );
  }
}

// /// 🔁 Gọi hàm này mỗi khi bạn cập nhật dữ liệu bên trong để ép rebuild lại
// void triggerHomeDataUpdate() {
//   final current = homeDataGlobal.value!;
//   homeDataGlobal.value = current.copyWith(
//     levels: current.levels.map((level) {
//       return level.copyWith(
//         topics: level.topics.map((topic) => topic.copyWith()).toList(),
//       );
//     }).toList(),
//   );
// }
