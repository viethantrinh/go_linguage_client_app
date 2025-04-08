import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_linguage/features/song/data/models/api_song_model.dart';
import 'package:go_linguage/features/song/domain/usecases/song_view_usecase.dart';
part 'song_event.dart';
part 'song_state.dart';

class SongBloc extends Bloc<SongEvent, SongState> {
  final SongViewUsecase _viewUsecase;
  SongBloc(SongViewUsecase viewUsecase)
      : _viewUsecase = viewUsecase,
        super(LoadingData()) {
    on<ViewData>(_loadData);
  }

  Future<void> _loadData(
    ViewData event,
    Emitter<SongState> emit,
  ) async {
    emit.call(LoadingData());

    final result = await _viewUsecase.call(null);

    result.fold(
      (failure) {
        emit.call(LoadedFailure(message: failure.message));
      },
      (successData) {
        emit.call(LoadedData(songListResopnseModel: successData));
      },
    );
  }
}
