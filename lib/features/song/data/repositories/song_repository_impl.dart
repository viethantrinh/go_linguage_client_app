import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/features/song/data/datasources/song_data_source.dart';
import 'package:go_linguage/features/song/data/models/api_song_model.dart';
import 'package:go_linguage/features/song/domain/repositories/song_repository.dart';

class SongRepositoryImpl implements SongRepository {
  final SongDataSourceImpl songRemoteDataSourceImpl;

  SongRepositoryImpl({required this.songRemoteDataSourceImpl});

  @override
  Future<Either<Failure, List<SongResopnseModel>>> getSongData() async {
    try {
      final response = await songRemoteDataSourceImpl.getSongData();
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
