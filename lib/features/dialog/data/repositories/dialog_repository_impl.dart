import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/features/dialog/data/datasources/dialog_data_source.dart';
import 'package:go_linguage/features/dialog/data/models/api_dialog_model.dart';
import 'package:go_linguage/features/dialog/domain/repositories/dialog_repository.dart';

class DialogRepositoryImpl implements DialogRepository {
  final DialogRemoteDataSourceImpl dialogRemoteDataSourceImpl;

  DialogRepositoryImpl({
    required this.dialogRemoteDataSourceImpl,
  });

  @override
  Future<Either<Failure, List<DialogListResopnseModel>>> getDialogData() async {
    try {
      final response = await dialogRemoteDataSourceImpl.getDialogData();
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> sendToServer(
      String ogaPath, String conversationLineId) async {
    try {
      final response = await dialogRemoteDataSourceImpl.sendToServer(
          ogaPath, conversationLineId);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
