import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/core/usecase/use_case.dart';
import 'package:go_linguage/features/exam/data/models/exam_model.dart';
import 'package:go_linguage/features/exam/domain/repositories/exam_repository.dart';

class ExamViewUsecase implements UseCase<void, void> {
  final ExamRepository examRepository;

  ExamViewUsecase(this.examRepository);
  @override
  Future<Either<Failure, ExamResopnseModel>> call(void params) async {
    final res = await examRepository.getExamData();
    return res;
  }
}
