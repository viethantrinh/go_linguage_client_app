import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/features/submit/data/models/api_submit_model.dart';
import 'package:go_linguage/features/submit/domain/model/submit_model.dart';

abstract interface class SubmitRepository {
  Future<Either<Failure, SubmitResopnseModel>> submitData(
      SubmitRequestModel request);
}
