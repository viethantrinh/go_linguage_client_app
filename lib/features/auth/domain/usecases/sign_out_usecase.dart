import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/core/usecase/use_case.dart';
import 'package:go_linguage/features/auth/domain/repositories/auth_repository.dart';

class SignOutUsecase implements UseCase<void, NoParams> {
  final AuthRepository authRepository;

  SignOutUsecase(this.authRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await authRepository.signOut();
  }
}
