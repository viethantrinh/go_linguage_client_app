part of 'submit_bloc.dart';

@immutable
sealed class SubmitEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class SubmitData extends SubmitEvent {
  final SubmitRequestModel request;
  SubmitData(this.request);

  @override
  List<Object> get props => [request];
}
