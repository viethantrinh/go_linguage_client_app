part of 'subject_bloc.dart';

@immutable
sealed class ViewEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class ViewData extends ViewEvent {
  final int id;
  ViewData({required this.id});
  @override
  List<Object> get props => [];
}
