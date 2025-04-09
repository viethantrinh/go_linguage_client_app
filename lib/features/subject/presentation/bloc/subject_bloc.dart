import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_linguage/features/subject/data/models/api_subject_model.dart';
import 'package:go_linguage/features/subject/domain/usecases/subject_view_usecase.dart';
part 'subject_event.dart';
part 'subject_state.dart';

class SubjectBloc extends Bloc<ViewEvent, SubjectState> {
  final SubjectViewUsecase _viewUsecase;
  SubjectBloc(SubjectViewUsecase viewUsecase)
      : _viewUsecase = viewUsecase,
        super(LoadingData()) {
    on<ViewData>(_loadData);
  }

  Future<void> _loadData(ViewData event, Emitter<SubjectState> emit) async {
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
