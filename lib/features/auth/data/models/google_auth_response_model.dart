class GoogleAuthResponseModel {
  final String token;

  GoogleAuthResponseModel({required this.token});

  factory GoogleAuthResponseModel.fromJson(Map<String, dynamic> json) {
    return GoogleAuthResponseModel(token: json['token'] ?? '');
  }
}
