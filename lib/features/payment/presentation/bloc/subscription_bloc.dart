import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_linguage/core/log/log.dart';
import 'package:go_linguage/features/payment/domain/entites/payment_result.dart';
import 'package:go_linguage/features/payment/domain/usecases/create_subscription_usecase.dart';
import 'package:go_linguage/features/payment/domain/usecases/request_payment_usecase.dart';
import 'package:go_linguage/features/payment/presentation/pages/subscription_page.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final RequestPaymentUsecase _requestPaymentUsecase;
  final CreateSubscriptionUsecase _createSubscriptionUsecase;

  SubscriptionBloc({
    required RequestPaymentUsecase requestPaymentUsecase,
    required CreateSubscriptionUsecase createSubscriptionUsecase,
  }) : _requestPaymentUsecase = requestPaymentUsecase,
       _createSubscriptionUsecase = createSubscriptionUsecase,
       super(SubscriptionInitial()) {
    on<SubscriptionPaymentRequestedEvent>(_onSubscriptionPaymentRequested);
    on<SubscriptionPresentPaymentSheetEvent>(_onPresentPaymentSheet);
  }

  Future<void> _onSubscriptionPaymentRequested(
    SubscriptionPaymentRequestedEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit.call(SubscriptionLoadingState());

    final result = await _requestPaymentUsecase.call(
      RequestPaymentParams(subscriptionId: event.subscriptionMonth.getId()),
    );

    result.fold(
      (failure) {
        emit.call(SubscriptionFailureState(failureMessage: failure.message));
      },
      (clientSecret) async {
        emit.call(SubscriptionRequestPaymentSuccessState());
        try {
          await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: clientSecret,
              merchantDisplayName: 'GoLinguage Subscription',
              style: ThemeMode.light,
            ),
          );
          add(
            SubscriptionPresentPaymentSheetEvent(
              subscriptionId: event.subscriptionMonth.getId(),
              paymentIntentId: _getPaymentIntentIdFromSecret(clientSecret)!,
            ),
          );
        } catch (e) {
          Log.getLogger.d(e.toString());
        }
      },
    );
  }

  Future<void> _onPresentPaymentSheet(
    SubscriptionPresentPaymentSheetEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit.call(SubscriptionLoadingState());
    try {
      await Stripe.instance.presentPaymentSheet();
      Log.getLogger.d('payment method id: ${event.paymentIntentId}');
      final subscription = await _createSubscriptionUsecase.call(
        CreateSubscriptionParams(
          subscriptionId: event.subscriptionId,
          paymentMethodId: event.paymentIntentId,
        ),
      );
      subscription.fold(
        (failure) => emit.call(
          SubscriptionFailureState(failureMessage: failure.message),
        ),
        (paymentResult) {
          emit.call(
            SubscriptionCreateSuccessState(paymentResult: paymentResult),
          );
        },
      );
    } on StripeException catch (e) {
      Log.getLogger.d(e.toString());
      emit(SubscriptionPaymentCancelledState());
    }
  }

  // Helper method to extract payment intent ID from client secret
  String? _getPaymentIntentIdFromSecret(String? clientSecret) {
    if (clientSecret == null) return null;

    // Client secret format: pi_1234567890_secret_1234567890
    final parts = clientSecret.split('_');
    if (parts.length >= 3) {
      return '${parts[0]}_${parts[1]}';
    }
    return null;
  }
}
