import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/core/usecase/use_case.dart';
import 'package:go_linguage/features/subject/data/models/api_subject_model.dart';
import 'package:go_linguage/features/subject/domain/repositories/subject_repository.dart';

class SubjectViewUsecase implements UseCase<void, int> {
  final SubjectRepository lessonRepository;

  SubjectViewUsecase(this.lessonRepository);
  @override
  Future<Either<Failure, List<LessonModel>>> call(int topicId) async {
    final res = await lessonRepository.getSubjectData(topicId);
    return res;
  }
}
