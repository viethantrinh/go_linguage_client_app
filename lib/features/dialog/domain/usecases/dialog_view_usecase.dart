import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/core/usecase/use_case.dart';
import 'package:go_linguage/features/dialog/data/models/api_dialog_model.dart';
import 'package:go_linguage/features/dialog/domain/repositories/dialog_repository.dart';

class DialogViewUsecase implements UseCase<void, int> {
  final DialogRepository dialogRepository;

  DialogViewUsecase(this.dialogRepository);
  @override
  Future<Either<Failure, List<DialogListResopnseModel>>> call(
      int conversationId) async {
    final res = await dialogRepository.getDialogData(conversationId);
    return res;
  }
}
