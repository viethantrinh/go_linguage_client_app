import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/features/payment/domain/entites/payment_result.dart';

abstract interface class SubscriptionRepository {
  Future<Either<Failure, String>> getPaymentIntent({
    required int subscriptionId,
  });
  Future<Either<Failure, PaymentResult>> createSubscription({
    required int subscriptionId,
    required String paymentMethodId
  });
}
