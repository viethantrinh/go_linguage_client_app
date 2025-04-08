import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/core/usecase/use_case.dart';
import 'package:go_linguage/features/submit/data/models/api_submit_model.dart';
import 'package:go_linguage/features/submit/domain/model/submit_model.dart';

import 'package:go_linguage/features/submit/domain/repositories/submit_repository.dart';

class SubmitUsecase
    implements UseCase<SubmitResopnseModel, SubmitRequestModel> {
  final SubmitRepository submitRepository;

  SubmitUsecase(this.submitRepository);
  @override
  Future<Either<Failure, SubmitResopnseModel>> call(
      SubmitRequestModel params) async {
    final res = await submitRepository.submitData(params);
    return res;
  }
}
