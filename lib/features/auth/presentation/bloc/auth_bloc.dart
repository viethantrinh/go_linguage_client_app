import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_linguage/core/log/log.dart';
import 'package:go_linguage/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:go_linguage/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:go_linguage/features/auth/domain/usecases/sign_up_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUsecase _signInUsecase;
  final SignUpUsecase _signUpUsecase;
  final CheckAuthStatusUsecase _checkAuthStatusUsecase;

  AuthBloc(
    SignInUsecase signInUseCase,
    SignUpUsecase signUpUseCase,
    CheckAuthStatusUsecase checkAuthStatusUseCase,
  ) : _signInUsecase = signInUseCase,
      _signUpUsecase = signUpUseCase,
      _checkAuthStatusUsecase = checkAuthStatusUseCase,
      super(AuthInitial()) {
    on<AuthSignIn>(_signInWithEmailPassword);
    on<AuthSignUp>(_signUpWithEmailPassword);
    on<AuthStatusCheck>(_checkAuthStatus);
  }

  Future<void> _signInWithEmailPassword(
    AuthSignIn event,
    Emitter<AuthState> emit,
  ) async {
    emit.call(AuthLoading());
    final result = await _signInUsecase.call(
      UserSignInParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) {
        emit.call(AuthFailure(message: failure.message));
      },
      (_) {
        emit.call(AuthSucess());
      },
    );
  }

  Future<void> _signUpWithEmailPassword(
    AuthSignUp event,
    Emitter<AuthState> emit,
  ) async {
    emit.call(AuthLoading());
    final result = await _signUpUsecase.call(
      UserSignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) {
        emit.call(AuthFailure(message: failure.message));
      },
      (_) {
        emit.call(AuthSucess());
      },
    );
  }

  Future<void> _checkAuthStatus(
    AuthStatusCheck event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _checkAuthStatusUsecase.call(null);
    result.fold(
      (failure) {
        Log.getLogger.d('Auth status check failed: ${failure.message}');
        emit(AuthFailure(message: failure.message));
      },
      (bool valid) {
        if (valid) {
          Log.getLogger.d('Auth status check: User is authenticated');
          emit(AuthSucess());
        } else {
          Log.getLogger.d('Auth status check: Token is invalid or expired');
          emit(
            AuthFailure(message: 'Authentication token is invalid or expired'),
          );
        }
      },
    );
  }
}
