import 'package:go_linguage/features/payment/domain/entites/payment_result.dart';

class PaymentResultModel extends PaymentResult {
  PaymentResultModel({
    required super.subscriptionId,
    required super.username,
    required super.startDate,
    required super.endDate,
  });

  factory PaymentResultModel.fromJson(Map<String, dynamic> map) {
    return PaymentResultModel(
      subscriptionId: map['subscriptionId'] ?? '',
      username: map['username'] ?? '',
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
    );
  }
}
