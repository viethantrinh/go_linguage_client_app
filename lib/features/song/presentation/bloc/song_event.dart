part of 'song_bloc.dart';

@immutable
sealed class SongEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class ViewData extends SongEvent {
  ViewData();
  @override
  List<Object> get props => [];
}
