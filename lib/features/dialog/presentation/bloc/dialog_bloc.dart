import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_linguage/features/dialog/data/models/api_dialog_model.dart';
import 'package:go_linguage/features/dialog/domain/usecases/dialog_view_usecase.dart';
import 'package:go_linguage/features/dialog/domain/usecases/pronoun_dialog_usecase.dart';
import 'package:go_linguage/features/dialog_list/data/models/api_conversation_model.dart';
part 'dialog_event.dart';
part 'dialog_state.dart';

class DialogBloc extends Bloc<ViewEvent, DialogState> {
  final DialogViewUsecase _viewUsecase;
  final PronounDialogUsecase _pronounDialogUsecase;
  DialogBloc(
      DialogViewUsecase viewUsecase, PronounDialogUsecase pronounDialogUsecase)
      : _viewUsecase = viewUsecase,
        _pronounDialogUsecase = pronounDialogUsecase,
        super(LoadingData()) {
    on<ViewData>(_loadData);
    on<SendToServer>(_sendToServer);
  }

  Future<void> _loadData(
    ViewData event,
    Emitter<DialogState> emit,
  ) async {
    emit.call(LoadingData());

    final result = await _viewUsecase.call(null);

    result.fold(
      (failure) {
        emit.call(LoadedFailure(message: failure.message));
      },
      (successData) {
        emit.call(LoadedData(dialogModel: successData));
      },
    );
  }

  Future<void> _sendToServer(
    SendToServer event,
    Emitter<DialogState> emit,
  ) async {
    final result = await _pronounDialogUsecase
        .call([event.ogaPath, event.conversationLineId]);

    result.fold(
      (failure) {
        emit.call(CheckPronounState(message: failure.message));
      },
      (successData) {
        emit.call(CheckPronounState(message: successData));
      },
    );
  }
}
