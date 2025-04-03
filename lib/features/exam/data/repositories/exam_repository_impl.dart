import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/features/exam/data/datasources/exam_remote_data_source.dart';
import 'package:go_linguage/features/exam/data/models/exam_model.dart';
import 'package:go_linguage/features/exam/domain/repositories/exam_repository.dart';

class ExamRepositoryImpl implements ExamRepository {
  final ExamRemoteDataSourceImpl examRemoteDataSource;

  ExamRepositoryImpl({
    required this.examRemoteDataSource,
  });

  @override
  Future<Either<Failure, ExamResopnseModel>> getExamData() async {
    try {
      final response = await examRemoteDataSource.getExamData();
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
