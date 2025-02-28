import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/core/usecase/use_case.dart';
import 'package:go_linguage/features/auth/domain/repositories/auth_repository.dart';

class SignUpUsecase implements UseCase<void, UserSignUpParams> {
  final AuthRepository authRepository;

  SignUpUsecase(this.authRepository);

  @override
  Future<Either<Failure, void>> call(UserSignUpParams params) async {
    final res = await authRepository.signUpWithEmailPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
    return res;
  }
}

class UserSignUpParams {
  final String name;
  final String email;
  final String password;

  UserSignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
