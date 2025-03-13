class HomeResponseModel {
  final int streakPoints;
  final int goPoints;
  final bool isSubscribed;
  final List<LevelModel> levels;

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
}

class LevelModel {
  final int id;
  final String name;
  final int totalUserXPPoints;
  final List<TopicModel> topics;
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
}

class TopicModel {
  final int id;
  final String name;
  final String imageUrl;
  final int totalUserXPPoints;
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
}
