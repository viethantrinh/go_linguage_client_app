import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/features/user_info/data/datasources/user_data_source.dart';
import 'package:go_linguage/features/user_info/data/models/api_user_model.dart';
import 'package:go_linguage/features/user_info/data/models/api_user_update_model.dart';
import 'package:go_linguage/features/user_info/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSourceImpl userRemoteDataSourceImpl;

  UserRepositoryImpl({required this.userRemoteDataSourceImpl});

  @override
  Future<Either<Failure, UserResopnseModel>> getUserInfo() async {
    try {
      final response = await userRemoteDataSourceImpl.getUserInfo();
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserUpdateResopnseModel>> updateUserInfo(
      String name) async {
    try {
      final response = await userRemoteDataSourceImpl.updateUserInfo(name);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
