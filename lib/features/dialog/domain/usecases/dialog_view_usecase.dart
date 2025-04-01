import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/core/usecase/use_case.dart';
import 'package:go_linguage/features/dialog/domain/repositories/dialog_repository.dart';
import 'package:go_linguage/features/dialog/data/models/api_dialog_model.dart';

class DialogViewUsecase implements UseCase<void, void> {
  final DialogRepository dialogRepository;

  DialogViewUsecase(this.dialogRepository);
  @override
  Future<Either<Failure, List<DialogListResopnseModel>>> call(
      void params) async {
    final res = await dialogRepository.getDialogData();
    return res;
  }
}
