import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/features/subject/data/models/api_subject_model.dart';

abstract interface class LessonRepository {
  Future<Either<Failure, LessonModel>> getLessonData(int id);
}
