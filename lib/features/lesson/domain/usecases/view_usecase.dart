import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/core/usecase/use_case.dart';
import 'package:go_linguage/features/lesson/domain/repositories/lesson_repository.dart';
import 'package:go_linguage/features/subject/data/models/api_subject_model.dart';

class LessonViewUsecase implements UseCase<void, int> {
  final LessonRepository lessonRepository;

  LessonViewUsecase(this.lessonRepository);
  @override
  Future<Either<Failure, LessonModel>> call(int id) async {
    final res = await lessonRepository.getLessonData(id);
    return res;
  }
}
