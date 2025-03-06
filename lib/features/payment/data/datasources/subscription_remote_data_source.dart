import 'package:go_linguage/core/constants/api_constants.dart';
import 'package:go_linguage/core/network/dio_client.dart';
import 'package:go_linguage/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:go_linguage/features/payment/data/models/payment_intent_response.dart';
import 'package:go_linguage/features/payment/data/models/payment_result_model.dart';

abstract interface class SubscriptionRemoteDataSource {
  Future<String> requestPaymentIntent({required int subscriptionId});
  Future<PaymentResultModel> createSubscription({
    required int subscriptionId,
    required String paymentMethodId,
  });
}

class SubscriptionRemoteDataSourceImpl implements SubscriptionRemoteDataSource {
  final DioClient dioClient;
  final AuthLocalDataSource authLocalDataSource;

  SubscriptionRemoteDataSourceImpl({
    required this.dioClient,
    required this.authLocalDataSource,
  });

  @override
  Future<String> requestPaymentIntent({required int subscriptionId}) async {
    try {
      final response = await dioClient.post(
        url: ApiConstants.requestPaymentIntent,
        resultFromJson: (json) => PaymentIntentResponse.fromJson(json),
        jsonBody: {'subscriptionId': subscriptionId},
        token: await authLocalDataSource.getToken(),
      );

      if (response.isSuccess && response.result != null) {
        return response.result!.clientSecret;
      } else {
        String apiPath = response.errorResponse!.apiPath;
        List<String> errorMessages = response.errorResponse!.errors;
        final errorMessage =
            errorMessages.isEmpty ? errorMessages.first : response.message;
        throw Exception('$errorMessage occured on $apiPath');
      }
    } catch (e) {
      throw Exception('Request payment intent failed: ${e.toString()}');
    }
  }

  @override
  Future<PaymentResultModel> createSubscription({
    required int subscriptionId,
    required String paymentMethodId,
  }) async {
    try {
      final response = await dioClient.post(
        url: ApiConstants.createSubscription,
        resultFromJson: (json) => PaymentResultModel.fromJson(json),
        jsonBody: {
          'subscriptionId': subscriptionId,
          'paymentMethodId': paymentMethodId,
        },
        token: await authLocalDataSource.getToken(),
      );

      if (response.isSuccess && response.result != null) {
        final data = response.result!;
        return data;
      } else {
        String apiPath = response.errorResponse!.apiPath;
        List<String> errorMessages = response.errorResponse!.errors;
        final errorMessage =
            errorMessages.isEmpty ? errorMessages.first : response.message;
        throw Exception('$errorMessage occured on $apiPath');
      }
    } catch (e) {
      throw Exception('Create subscription failed: ${e.toString()}');
    }
  }
}
