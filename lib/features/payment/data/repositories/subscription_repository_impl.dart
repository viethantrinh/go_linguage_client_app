import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/features/payment/data/datasources/subscription_remote_data_source.dart';
import 'package:go_linguage/features/payment/domain/entites/payment_result.dart';
import 'package:go_linguage/features/payment/domain/repositories/subscription_repository.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionRemoteDataSource subscriptionRemoteDataSource;

  SubscriptionRepositoryImpl({required this.subscriptionRemoteDataSource});

  @override
  Future<Either<Failure, String>> getPaymentIntent({
    required int subscriptionId,
  }) async {
    try {
      final result = await subscriptionRemoteDataSource.requestPaymentIntent(
        subscriptionId: subscriptionId,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaymentResult>> createSubscription({
    required int subscriptionId,
    required String paymentMethodId
  }) async {
    try {
      final result = await subscriptionRemoteDataSource.createSubscription(
        subscriptionId: subscriptionId,
        paymentMethodId: paymentMethodId
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
