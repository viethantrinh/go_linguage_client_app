part of 'subscription_bloc.dart';

sealed class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object> get props => [];
}

final class SubscriptionInitial extends SubscriptionState {}

final class SubscriptionLoadingState extends SubscriptionState {}

final class SubscriptionRequestPaymentSuccessState extends SubscriptionState {}

final class SubscriptionPaymentSheetPresentedState extends SubscriptionState {}

final class SubscriptionPaymentSuccessState extends SubscriptionState {}

final class SubscriptionPaymentCancelledState extends SubscriptionState {}

final class SubscriptionCreateSuccessState extends SubscriptionState {
  final PaymentResult paymentResult;

  const SubscriptionCreateSuccessState({required this.paymentResult});
}

final class SubscriptionFailureState extends SubscriptionState {
  final String failureMessage;

  const SubscriptionFailureState({required this.failureMessage});

  @override
  List<Object> get props => [failureMessage];
}
