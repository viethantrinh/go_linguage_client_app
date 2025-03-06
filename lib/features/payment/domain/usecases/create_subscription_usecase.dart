import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/core/usecase/use_case.dart';
import 'package:go_linguage/features/payment/domain/entites/payment_result.dart';
import 'package:go_linguage/features/payment/domain/repositories/subscription_repository.dart';

class CreateSubscriptionUsecase
    implements UseCase<PaymentResult, CreateSubscriptionParams> {
  final SubscriptionRepository subscriptionRepository;

  CreateSubscriptionUsecase({required this.subscriptionRepository});
  @override
  Future<Either<Failure, PaymentResult>> call(
    CreateSubscriptionParams params,
  ) async {
    return await subscriptionRepository.createSubscription(
      subscriptionId: params.subscriptionId,
      paymentMethodId: params.paymentMethodId,
    );
  }
}

class CreateSubscriptionParams {
  final int subscriptionId;
  final String paymentMethodId;

  CreateSubscriptionParams({
    required this.paymentMethodId,
    required this.subscriptionId,
  });
}
