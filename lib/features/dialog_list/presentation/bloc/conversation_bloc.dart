import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_linguage/features/dialog_list/data/models/api_conversation_model.dart';
import 'package:go_linguage/features/dialog_list/domain/usecases/conversation_view_usecase.dart';
import 'package:go_linguage/features/subject/data/models/api_subject_model.dart';
import 'package:go_linguage/features/subject/domain/usecases/subject_view_usecase.dart';
part 'conversation_event.dart';
part 'conversation_state.dart';

class ConversationBloc extends Bloc<ViewEvent, ConversationState> {
  final ConversationViewUsecase _viewUsecase;
  ConversationBloc(ConversationViewUsecase viewUsecase)
      : _viewUsecase = viewUsecase,
        super(LoadingData()) {
    on<ViewData>(_loadData);
  }

  Future<void> _loadData(
    ViewData event,
    Emitter<ConversationState> emit,
  ) async {
    emit.call(LoadingData());

    final result = await _viewUsecase.call(null);

    result.fold(
      (failure) {
        emit.call(LoadedFailure(message: failure.message));
      },
      (successData) {
        emit.call(LoadedData(conversationModel: successData));
      },
    );
  }
}
