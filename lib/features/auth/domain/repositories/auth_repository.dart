import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, void>> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, bool>> checkAuthStatus();

  Future<Either<Failure, String?>> getToken();
}
