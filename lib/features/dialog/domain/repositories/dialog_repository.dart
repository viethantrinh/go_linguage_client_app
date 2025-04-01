import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/features/dialog/data/models/api_dialog_model.dart';

abstract interface class DialogRepository {
  Future<Either<Failure, List<DialogListResopnseModel>>> getDialogData();
}
