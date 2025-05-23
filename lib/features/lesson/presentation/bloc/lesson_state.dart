part of 'lesson_bloc.dart';

@immutable
sealed class LessonState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class LoadingData extends LessonState {}

final class LoadedData extends LessonState {
  final LessonModel lessonModel;

  LoadedData({required this.lessonModel});
  @override
  List<Object> get props => [lessonModel];
}

final class LoadedFailure extends LessonState {
  final String message;

  LoadedFailure({required this.message});

  @override
  List<Object> get props => [message];
}

final class CheckPronounState extends LessonState {
  final AssessmentModel? result;
  final int status;

  CheckPronounState({required this.result, required this.status});
  @override
  List<Object?> get props => [result, status];
}
