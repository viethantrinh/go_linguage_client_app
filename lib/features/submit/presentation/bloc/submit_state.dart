part of 'submit_bloc.dart';

@immutable
sealed class SubmitState extends Equatable {
  @override
  List<Object> get props => [];
}

final class Submitting extends SubmitState {}

final class Submitted extends SubmitState {
  final SubmitResopnseModel submitModel;

  Submitted({required this.submitModel});
  @override
  List<Object> get props => [submitModel];
}

final class SubmitFailure extends SubmitState {
  final String message;

  SubmitFailure({required this.message});
}
