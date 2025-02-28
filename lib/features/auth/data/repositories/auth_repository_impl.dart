import 'dart:ffi';

import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:go_linguage/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:go_linguage/features/auth/domain/repositories/auth_repository.dart';
import 'package:logger/web.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<Either<Failure, void>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await authRemoteDataSource.signInWithEmailPassword(
        email: email,
        password: password,
      );
      authLocalDataSource.cacheToken(response.token);
      Logger().d('After sign in successful, the token is cached has value: ${await authLocalDataSource.getToken()}');
      // ignore: void_checks
      return Right(Void);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await authRemoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );
      authLocalDataSource.cacheToken(response.token);
      Logger().d('After sign up successful, the token is cached has value: ${await authLocalDataSource.getToken()}');
      // ignore: void_checks
      return Right(Void);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkAuthStatus() async {
    try {
      final token = await authLocalDataSource.getToken();

      if (token == null) {
        return const Right(false);
      }

      final isValid = await authRemoteDataSource.validateToken(token: token);
      return Right(isValid);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getToken() async {
    try {
      final token = await authLocalDataSource.getToken();
      if (token == null) {
        return const Right('');
      }
      return Right(token);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
