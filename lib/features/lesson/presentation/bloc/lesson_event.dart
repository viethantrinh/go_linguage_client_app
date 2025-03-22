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
