part of 'home_bloc.dart';

@immutable
sealed class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

final class LoadingData extends HomeState {}

final class LoadedData extends HomeState {
  final HomeResponseModel homeResponseModel;

  LoadedData({required this.homeResponseModel});
  @override
  List<Object> get props => [homeResponseModel];
}

final class LoadedFailure extends HomeState {
  final String message;

  LoadedFailure({required this.message});

  @override
  List<Object> get props => [message];
}
