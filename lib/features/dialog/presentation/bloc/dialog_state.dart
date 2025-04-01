part of 'dialog_bloc.dart';

@immutable
sealed class DialogState extends Equatable {
  @override
  List<Object> get props => [];
}

final class LoadingData extends DialogState {}

final class LoadedData extends DialogState {
  final List<DialogListResopnseModel> dialogModel;

  LoadedData({required this.dialogModel});
  @override
  List<Object> get props => [dialogModel];
}

final class LoadedFailure extends DialogState {
  final String message;

  LoadedFailure({required this.message});

  @override
  List<Object> get props => [message];
}
