import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/features/subject/data/datasources/subject_data_source.dart';
import 'package:go_linguage/features/subject/data/models/api_subject_model.dart';
import 'package:go_linguage/features/subject/domain/repositories/subject_repository.dart';

class SubjectRepositoryImpl implements SubjectRepository {
  final SubjectRemoteDataSourceImpl subjectRemoteDataSourceImpl;

  SubjectRepositoryImpl({required this.subjectRemoteDataSourceImpl});

  @override
  Future<Either<Failure, List<LessonModel>>> getSubjectData() async {
    try {
      final response = await subjectRemoteDataSourceImpl.getSubjectData();
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
