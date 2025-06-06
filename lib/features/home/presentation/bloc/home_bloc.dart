import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_linguage/features/home/data/models/home_model.dart';
import 'package:go_linguage/features/home/domain/usecases/view_usecase.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<ViewEvent, HomeState> {
  final HomeViewUsecase _viewUsecase;
  HomeBloc(HomeViewUsecase viewUsecase)
      : _viewUsecase = viewUsecase,
        super(LoadingData()) {
    on<ViewHomeData>(_loadData);

  }

  Future<void> _loadData(
    ViewHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit.call(LoadingData());

    final result = await _viewUsecase.call(null);

    result.fold(
      (failure) {
        emit.call(LoadedFailure(message: failure.message));
      },
      (successData) {
        emit.call(LoadedData(homeResponseModel: successData));
      },
    );
  }


}
