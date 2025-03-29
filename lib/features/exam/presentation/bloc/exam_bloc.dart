import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_linguage/features/exam/data/models/exam_model.dart';
import 'package:go_linguage/features/exam/domain/usecases/exam_view_usecase.dart';

part 'exam_event.dart';
part 'exam_state.dart';

class ExamBloc extends Bloc<ViewEvent, ExamState> {
  final ExamViewUsecase _viewUsecase;
  ExamBloc(ExamViewUsecase viewUsecase)
      : _viewUsecase = viewUsecase,
        super(LoadingData()) {
    on<ViewData>(_loadData);
  }

  Future<void> _loadData(
    ViewData event,
    Emitter<ExamState> emit,
  ) async {
    emit.call(LoadingData());

    final result = await _viewUsecase.call(null);

    result.fold(
      (failure) {
        emit.call(LoadedFailure(message: failure.message));
      },
      (successData) {
        emit.call(LoadedData(examResopnseModel: successData));
      },
    );
  }
}
