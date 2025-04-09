import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/features/user_info/data/models/api_user_model.dart';
import 'package:go_linguage/features/user_info/data/models/api_user_update_model.dart';

abstract interface class UserRepository {
  Future<Either<Failure, UserResopnseModel>> getUserInfo();
  Future<Either<Failure, UserUpdateResopnseModel>> updateUserInfo(String name);
}
