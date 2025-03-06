part of 'auth_bloc.dart';

@immutable
sealed class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSucess extends AuthState {}

final class AuthFailure extends AuthState {
  final String message;

  AuthFailure({required this.message});

    @override
  List<Object> get props => [message];
}

final class AuthSignedOut extends AuthState {}
