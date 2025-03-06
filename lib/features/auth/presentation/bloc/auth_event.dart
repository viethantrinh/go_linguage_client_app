part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class AuthSignIn extends AuthEvent {
  final String email;
  final String password;

  AuthSignIn({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
}

final class AuthSignUp extends AuthEvent {
  final String name;
  final String email;
  final String password;

  AuthSignUp({required this.name, required this.email, required this.password});
  @override
  List<Object> get props => [name, email, password];
}

final class AuthWithGoogle extends AuthEvent {}

final class AuthSignOut extends AuthEvent {}

final class AuthStatusCheck extends AuthEvent {}
