class SignUpResponseModel {
  final String token;

  SignUpResponseModel({required this.token});

  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) {
    return SignUpResponseModel(token: json['token'] ?? '');
  }
}
