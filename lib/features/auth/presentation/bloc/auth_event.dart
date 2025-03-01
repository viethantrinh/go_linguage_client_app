part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignIn extends AuthEvent {
  final String email;
  final String password;

  AuthSignIn({required this.email, required this.password});
}

final class AuthSignUp extends AuthEvent {
  final String name;
  final String email;
  final String password;

  AuthSignUp({required this.name, required this.email, required this.password});
}

final class AuthWithGoogle extends AuthEvent {}

final class AuthSignOut extends AuthEvent {}

final class AuthStatusCheck extends AuthEvent {}
