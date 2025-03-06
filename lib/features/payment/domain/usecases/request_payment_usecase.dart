import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/core/usecase/use_case.dart';
import 'package:go_linguage/features/payment/domain/repositories/subscription_repository.dart';

class RequestPaymentUsecase implements UseCase<String, RequestPaymentParams> {
  final SubscriptionRepository subscriptionRepository;

  RequestPaymentUsecase({required this.subscriptionRepository});

  @override
  Future<Either<Failure, String>> call(RequestPaymentParams params) async {
    return subscriptionRepository.getPaymentIntent(subscriptionId: params.subscriptionId);
  }
}

class RequestPaymentParams {
  final int subscriptionId;
  RequestPaymentParams({required this.subscriptionId});
}
