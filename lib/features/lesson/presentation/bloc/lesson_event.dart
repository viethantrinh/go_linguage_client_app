part of 'lesson_bloc.dart';

@immutable
sealed class GetDataEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class GetData extends GetDataEvent {
  final int id;
  GetData(this.id);
  @override
  List<Object> get props => [id];
}

final class CheckPronounEvent extends GetDataEvent {
  final String oggPath;
  final String sentence;
  CheckPronounEvent(this.oggPath, this.sentence);
  @override
  List<Object> get props => [oggPath, sentence];
}
