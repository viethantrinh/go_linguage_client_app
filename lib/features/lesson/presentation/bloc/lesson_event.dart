part of 'lesson_bloc.dart';

@immutable
sealed class ViewEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class ViewData extends ViewEvent {
  final int id;
  ViewData(this.id);
  @override
  List<Object> get props => [id];
}

final class CheckPronounEvent extends ViewEvent {
  final String oggPath;
  final String sentence;
  CheckPronounEvent(this.oggPath, this.sentence);
  @override
  List<Object> get props => [oggPath, sentence];
}
