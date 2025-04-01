part of 'conversation_bloc.dart';

@immutable
sealed class ConversationState extends Equatable {
  @override
  List<Object> get props => [];
}

final class LoadingData extends ConversationState {}

final class LoadedData extends ConversationState {
  final List<ConversationListResopnseModel> conversationModel;

  LoadedData({required this.conversationModel});
  @override
  List<Object> get props => [conversationModel];
}

final class LoadedFailure extends ConversationState {
  final String message;

  LoadedFailure({required this.message});

  @override
  List<Object> get props => [message];
}
