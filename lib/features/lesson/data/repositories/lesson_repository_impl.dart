import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/features/lesson/data/datasources/lesson_data_source.dart';
import 'package:go_linguage/features/lesson/domain/repositories/lesson_repository.dart';
import 'package:go_linguage/features/lesson/presentation/pages/pronoun_assessment.dart';
import 'package:go_linguage/features/subject/data/models/api_subject_model.dart';

class LessonRepositoryImpl implements LessonRepository {
  final LessonDataSourceImpl lessonRemoteDataSource;

  LessonRepositoryImpl({
    required this.lessonRemoteDataSource,
  });

  @override
  Future<Either<Failure, LessonModel>> getLessonData(int id) async {
    try {
      final response = await lessonRemoteDataSource.getLessonData(id);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AssessmentModel>> sendToServer(
      String ogaPath, String text) async {
    try {
      final response = await lessonRemoteDataSource.sendToServer(ogaPath, text);
      if (response != null) {
        return Right(response);
      } else {
        return Left(ServerFailure('Response is null'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
