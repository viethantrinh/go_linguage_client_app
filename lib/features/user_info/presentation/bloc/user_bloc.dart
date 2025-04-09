import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_linguage/features/user_info/data/models/api_user_model.dart';
import 'package:go_linguage/features/user_info/data/models/api_user_update_model.dart';
import 'package:go_linguage/features/user_info/domain/usecases/user_view_usecase.dart';
part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<ViewEvent, UserState> {
  final UserViewUsecase _viewUsecase;
  final UserUpdateUsecase _updateUsecase;
  UserBloc(UserViewUsecase viewUsecase, UserUpdateUsecase updateUsecase)
      : _viewUsecase = viewUsecase,
        _updateUsecase = updateUsecase,
        super(LoadingData()) {
    on<ViewUserProfile>(_loadData);
    on<UpdateUserInfo>(_updateData);
  }

  Future<void> _loadData(
    ViewUserProfile event,
    Emitter<UserState> emit,
  ) async {
    emit.call(LoadingData());

    final result = await _viewUsecase.call(null);

    result.fold(
      (failure) {
        emit.call(LoadedFailure(message: failure.message));
      },
      (successData) {
        emit.call(LoadedData());
      },
    );
  }

  Future<void> _updateData(
    UpdateUserInfo event,
    Emitter<UserState> emit,
  ) async {
    emit.call(UpdateLoading());

    final result = await _updateUsecase.call(event.name);

    result.fold(
      (failure) {
        emit.call(UpdateFailure(message: failure.message));
      },
      (successData) {
        emit.call(UpdateSuccess(userUpdateResopnseModel: successData));
      },
    );
  }
}
