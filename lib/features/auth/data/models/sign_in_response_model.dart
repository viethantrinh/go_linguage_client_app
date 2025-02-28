class SignInResponseModel {
  final String token;

  SignInResponseModel({required this.token});

  factory SignInResponseModel.fromJson(Map<String, dynamic> json) {
    return SignInResponseModel(token: json['token'] ?? '');
  }
}
