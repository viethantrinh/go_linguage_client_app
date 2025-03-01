import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/core/usecase/use_case.dart';
import 'package:go_linguage/features/auth/domain/repositories/auth_repository.dart';

class GoogleAuthUsecase implements UseCase<void, NoParams> {
  final AuthRepository authRepository;

  GoogleAuthUsecase(this.authRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    final result = await authRepository.authenticationWithGoogle();
    return result;
  }
}
