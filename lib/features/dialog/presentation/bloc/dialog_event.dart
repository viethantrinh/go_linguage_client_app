part of 'dialog_bloc.dart';

@immutable
sealed class ViewEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class ViewData extends ViewEvent {
  final int conversationId;

  ViewData({required this.conversationId});

  @override
  List<Object> get props => [conversationId];
}

final class SendToServer extends ViewEvent {
  final String ogaPath;
  final String conversationLineId;
  SendToServer(this.ogaPath, this.conversationLineId);
}
