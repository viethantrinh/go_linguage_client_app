part of 'subject_bloc.dart';

@immutable
sealed class SubjectState extends Equatable {
  @override
  List<Object> get props => [];
}

final class LoadingData extends SubjectState {}

final class LoadedData extends SubjectState {
  final List<LessonModel> lessonModel;

  LoadedData({required this.lessonModel});
  @override
  List<Object> get props => [lessonModel];
}

final class LoadedFailure extends SubjectState {
  final String message;

  LoadedFailure({required this.message});

  @override
  List<Object> get props => [message];
}
