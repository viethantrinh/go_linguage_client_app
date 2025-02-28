
import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/core/usecase/use_case.dart';
import 'package:go_linguage/features/auth/domain/repositories/auth_repository.dart';

class CheckAuthStatusUsecase implements UseCase<bool, void> {
  final AuthRepository authRepository;

  CheckAuthStatusUsecase(this.authRepository);

  @override
  Future<Either<Failure, bool>> call(_) async {
    return await authRepository.checkAuthStatus();
  }
}
