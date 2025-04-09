import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_linguage/features/submit/data/models/api_submit_model.dart';
import 'package:go_linguage/features/submit/domain/model/submit_model.dart';
import 'package:go_linguage/features/submit/domain/usecases/submit_usecase.dart';
part 'submit_event.dart';
part 'submit_state.dart';

class SubmitBloc extends Bloc<SubmitEvent, SubmitState> {
  final SubmitUsecase _submitUsecase;
  SubmitBloc(SubmitUsecase submitUsecase)
      : _submitUsecase = submitUsecase,
        super(Submitting()) {
    on<SubmitData>(_submitData);
  }

  Future<void> _submitData(
    SubmitData event,
    Emitter<SubmitState> emit,
  ) async {
    emit.call(Submitting());

    final result = await _submitUsecase.call(event.request);

    result.fold(
      (failure) {
        emit.call(SubmitFailure(message: failure.message));
      },
      (successData) {
        emit.call(Submitted(submitModel: successData));
      },
    );
  }
}
