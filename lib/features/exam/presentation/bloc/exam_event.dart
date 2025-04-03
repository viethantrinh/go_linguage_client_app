part of 'exam_bloc.dart';

@immutable
sealed class ViewEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class ViewData extends ViewEvent {
  ViewData();
  @override
  List<Object> get props => [];
}
