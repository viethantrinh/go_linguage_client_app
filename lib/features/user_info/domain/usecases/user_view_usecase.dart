import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/core/usecase/use_case.dart';
import 'package:go_linguage/features/user_info/data/models/api_user_model.dart';
import 'package:go_linguage/features/user_info/data/models/api_user_update_model.dart';
import 'package:go_linguage/features/user_info/domain/repositories/user_repository.dart';

class UserViewUsecase implements UseCase<void, void> {
  final UserRepository userRepository;

  UserViewUsecase(this.userRepository);
  @override
  Future<Either<Failure, UserResopnseModel>> call(void params) async {
    final res = await userRepository.getUserInfo();
    return res;
  }
}

class UserUpdateUsecase implements UseCase<UserUpdateResopnseModel, String> {
  final UserRepository userRepository;
  UserUpdateUsecase(this.userRepository);

  @override
  Future<Either<Failure, UserUpdateResopnseModel>> call(String name) async {
    final res = await userRepository.updateUserInfo(name);
    return res;
  }
}
