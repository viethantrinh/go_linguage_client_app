part of 'user_bloc.dart';

@immutable
sealed class UserState extends Equatable {
  @override
  List<Object> get props => [];
}

final class LoadingData extends UserState {}

final class LoadedData extends UserState {
  LoadedData();
  @override
  List<Object> get props => [];
}

final class LoadedFailure extends UserState {
  final String message;

  LoadedFailure({required this.message});

  @override
  List<Object> get props => [message];
}

final class UpdateSuccess extends UserState {
  final UserUpdateResopnseModel userUpdateResopnseModel;

  UpdateSuccess({required this.userUpdateResopnseModel});
}

final class UpdateFailure extends UserState {
  final String message;

  UpdateFailure({required this.message});
}

final class UpdateLoading extends UserState {}
