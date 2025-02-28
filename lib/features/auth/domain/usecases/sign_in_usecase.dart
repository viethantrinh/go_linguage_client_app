
import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/core/usecase/use_case.dart';
import 'package:go_linguage/features/auth/domain/repositories/auth_repository.dart';

class SignInUsecase implements UseCase<void, UserSignInParams> {
  final AuthRepository authRepository;

  SignInUsecase(this.authRepository);

  @override
  Future<Either<Failure, void>> call(UserSignInParams params) async {
    final res = await authRepository.signInWithEmailPassword(
      email: params.email,
      password: params.password,
    );
    return res;
  }
}

class UserSignInParams {
  final String email;
  final String password;
  UserSignInParams({required this.email, required this.password});
}
