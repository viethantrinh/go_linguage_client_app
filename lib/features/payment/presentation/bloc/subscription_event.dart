part of 'subscription_bloc.dart';

sealed class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();

  @override
  List<Object?> get props => [];
}

final class SubscriptionPaymentRequestedEvent extends SubscriptionEvent {
  final SubscriptionMonth subscriptionMonth;

  const SubscriptionPaymentRequestedEvent({required this.subscriptionMonth});

  @override
  List<Object?> get props => [subscriptionMonth];
}

final class SubscriptionPresentPaymentSheetEvent extends SubscriptionEvent {
  final int subscriptionId;
  final String paymentIntentId;

  const SubscriptionPresentPaymentSheetEvent({
    required this.subscriptionId,
    required this.paymentIntentId,
  });

  @override
  List<Object?> get props => [subscriptionId, paymentIntentId];
}

final class SubscriptionConfirmPaymentEvent extends SubscriptionEvent {
  final int subscriptionId;
  final String paymentIntentId;

  const SubscriptionConfirmPaymentEvent({
    required this.subscriptionId,
    required this.paymentIntentId,
  });

  @override
  List<Object?> get props => [subscriptionId, paymentIntentId];
}
