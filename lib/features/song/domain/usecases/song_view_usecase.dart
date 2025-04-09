import 'package:fpdart/fpdart.dart';
import 'package:go_linguage/core/error/failures.dart';
import 'package:go_linguage/core/usecase/use_case.dart';
import 'package:go_linguage/features/song/data/models/api_song_model.dart';
import 'package:go_linguage/features/song/domain/repositories/song_repository.dart';

class SongViewUsecase implements UseCase<void, void> {
  final SongRepository songRepository;

  SongViewUsecase(this.songRepository);
  @override
  Future<Either<Failure, List<SongResopnseModel>>> call(void params) async {
    final res = await songRepository.getSongData();
    return res;
  }
}
