class PaymentIntentResponse {
  final String clientSecret;

  PaymentIntentResponse({required this.clientSecret});

  factory PaymentIntentResponse.fromJson(Map<String, dynamic> map) {
    return PaymentIntentResponse(clientSecret: map['clientSecret'] ?? '');
  }
}
