part of 'exam_bloc.dart';

@immutable
sealed class ExamState extends Equatable {
  @override
  List<Object> get props => [];
}

final class LoadingData extends ExamState {}

final class LoadedData extends ExamState {
  final ExamResopnseModel examResopnseModel;

  LoadedData({required this.examResopnseModel});
  @override
  List<Object> get props => [examResopnseModel];
}

final class LoadedFailure extends ExamState {
  final String message;

  LoadedFailure({required this.message});

  @override
  List<Object> get props => [message];
}
