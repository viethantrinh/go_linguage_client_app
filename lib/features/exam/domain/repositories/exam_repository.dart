import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/features/exam/data/models/exam_model.dart';

abstract interface class ExamRepository {
  Future<Either<Failure, ExamResopnseModel>> getExamData();
}
