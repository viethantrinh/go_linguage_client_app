class IntrospectTokenResponseModel {
  final bool valid;

  IntrospectTokenResponseModel({required this.valid});

  factory IntrospectTokenResponseModel.fromJson(Map<String, dynamic> json) {
    return IntrospectTokenResponseModel(valid: json['valid']);
  }
}
