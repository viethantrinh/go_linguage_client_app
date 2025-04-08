import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/features/song/data/models/api_song_model.dart';

abstract interface class SongRepository {
  Future<Either<Failure, List<SongResopnseModel>>> getSongData();
}
