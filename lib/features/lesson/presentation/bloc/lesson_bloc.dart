import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_linguage/features/lesson/domain/usecases/view_usecase.dart';
import 'package:go_linguage/features/subject/data/models/api_subject_model.dart';
part 'lesson_event.dart';
part 'lesson_state.dart';

class LessonBloc extends Bloc<ViewEvent, LessonState> {
  final LessonViewUsecase _viewUsecase;
  LessonBloc(LessonViewUsecase viewUsecase)
      : _viewUsecase = viewUsecase,
        super(LoadingData()) {
    on<ViewData>(_loadData);
  }

  Future<void> _loadData(
    ViewData event,
    Emitter<LessonState> emit,
  ) async {
    emit.call(LoadingData());

    final result = await _viewUsecase.call(1);

    result.fold(
      (failure) {
        emit.call(LoadedFailure(message: failure.message));
      },
      (successData) {
        emit.call(LoadedData(lessonModel: successData));
      },
    );
  }
}
