part of 'song_bloc.dart';

@immutable
sealed class SongState extends Equatable {
  @override
  List<Object> get props => [];
}

final class LoadingData extends SongState {}

final class LoadedData extends SongState {
  final List<SongResopnseModel> songListResopnseModel;

  LoadedData({required this.songListResopnseModel});
  @override
  List<Object> get props => [songListResopnseModel];
}

final class LoadedFailure extends SongState {
  final String message;

  LoadedFailure({required this.message});

  @override
  List<Object> get props => [message];
}
