import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/core/usecase/use_case.dart';
import 'package:go_linguage/features/lesson/domain/repositories/home_repository.dart';
import 'package:go_linguage/features/lesson/presentation/pages/pronoun_assessment.dart';

class PronounUsecase implements UseCase<void, List<String>> {
  final LessonRepository lessonRepository;

  PronounUsecase(this.lessonRepository);

  @override
  Future<Either<Failure, AssessmentModel>> call(List<String> params) async {
    final res = await lessonRepository.sendToServer(params[0], params[1]);
    return res;
  }
}
