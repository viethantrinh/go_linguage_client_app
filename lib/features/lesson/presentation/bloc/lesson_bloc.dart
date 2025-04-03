import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_linguage/features/lesson/domain/usecases/pronoun_usecase.dart';
import 'package:go_linguage/features/lesson/domain/usecases/view_usecase.dart';
import 'package:go_linguage/features/lesson/presentation/pages/pronoun_assessment.dart';
import 'package:go_linguage/features/subject/data/models/api_subject_model.dart';
part 'lesson_event.dart';
part 'lesson_state.dart';

class LessonBloc extends Bloc<GetDataEvent, LessonState> {
  final LessonViewUsecase _viewUsecase;
  final PronounUsecase _pronounUsecase;
  LessonBloc(LessonViewUsecase viewUsecase, PronounUsecase pronounUsecase)
      : _viewUsecase = viewUsecase,
        _pronounUsecase = pronounUsecase,
        super(LoadingData()) {
    on<GetData>(_loadData);
    on<CheckPronounEvent>(_checkPronoun);
  }

  Future<void> _loadData(
    GetData event,
    Emitter<LessonState> emit,
  ) async {
    emit.call(LoadingData());

    final result = await _viewUsecase.call(event.id);

    result.fold(
      (failure) {
        emit.call(LoadedFailure(message: failure.message));
      },
      (successData) {
        emit.call(LoadedData(lessonModel: successData));
      },
    );
  }

  Future<void> _checkPronoun(
    CheckPronounEvent event,
    Emitter<LessonState> emit,
  ) async {
    emit.call(CheckPronounState(result: null, status: 0));
    final result = await _pronounUsecase.call([event.oggPath, event.sentence]);
    result.fold(
      (failure) {
        emit.call(CheckPronounState(result: null, status: -1));
      },
      (successData) {
        emit.call(CheckPronounState(result: successData, status: 1));
      },
    );
  }
}
