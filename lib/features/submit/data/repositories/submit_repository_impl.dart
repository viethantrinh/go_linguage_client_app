import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/features/submit/data/datasources/submit_data_source.dart';
import 'package:go_linguage/features/submit/data/models/api_submit_model.dart';
import 'package:go_linguage/features/submit/domain/model/submit_model.dart';
import 'package:go_linguage/features/submit/domain/repositories/submit_repository.dart';

class SubmitRepositoryImpl implements SubmitRepository {
  final SubmitDataSourceImpl submitRemoteDataSourceImpl;

  SubmitRepositoryImpl({
    required this.submitRemoteDataSourceImpl,
  });

  @override
  Future<Either<Failure, SubmitResopnseModel>> submitData(
      SubmitRequestModel request) async {
    try {
      final response = await submitRemoteDataSourceImpl.submitData(request);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
