import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/core/usecase/use_case.dart';
import 'package:go_linguage/features/dialog/domain/repositories/dialog_repository.dart';

class PronounDialogUsecase implements UseCase<void, List<String>> {
  final DialogRepository dialogRepository;

  PronounDialogUsecase(this.dialogRepository);

  @override
  Future<Either<Failure, String?>> call(List<String> params) async {
    final res = await dialogRepository.sendToServer(params[0], params[1]);
    return res;
  }
}
