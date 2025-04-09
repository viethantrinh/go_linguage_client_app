part of 'user_bloc.dart';

@immutable
sealed class ViewEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class ViewUserProfile extends ViewEvent {
  ViewUserProfile();
  @override
  List<Object> get props => [];
}

final class UpdateUserInfo extends ViewEvent {
  final String name;
  UpdateUserInfo(this.name);
  @override
  List<Object> get props => [name];
}
