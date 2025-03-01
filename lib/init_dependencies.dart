import 'package:get_it/get_it.dart';
import 'package:go_linguage/core/network/dio_client.dart';
import 'package:go_linguage/core/secret/app_secret.dart';
import 'package:go_linguage/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:go_linguage/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:go_linguage/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:go_linguage/features/auth/domain/repositories/auth_repository.dart';
import 'package:go_linguage/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:go_linguage/features/auth/domain/usecases/google_auth_usecase.dart';
import 'package:go_linguage/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:go_linguage/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:go_linguage/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:go_linguage/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.I;

Future<void> initializeDependencies() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerSingleton<SharedPreferences>(sharedPreferences);
  serviceLocator.registerLazySingleton<DioClient>(() => DioClient());
  GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: AppSecret.iosClientId,
    serverClientId: AppSecret.serverClientId,
  );
  serviceLocator.registerLazySingleton(() => googleSignIn);
  _initAuthDependencies();
}

void _initAuthDependencies() {
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        dioClient: serviceLocator<DioClient>(),
        googleSignIn: serviceLocator<GoogleSignIn>(),
      ),
    )
    ..registerFactory<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(
        sharedPreferences: serviceLocator<SharedPreferences>(),
      ),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        authRemoteDataSource: serviceLocator<AuthRemoteDataSource>(),
        authLocalDataSource: serviceLocator<AuthLocalDataSource>(),
      ),
    )
    ..registerFactory<SignInUsecase>(
      () => SignInUsecase(serviceLocator<AuthRepository>()),
    )
    ..registerFactory<SignUpUsecase>(
      () => SignUpUsecase(serviceLocator<AuthRepository>()),
    )
    ..registerFactory<GoogleAuthUsecase>(
      () => GoogleAuthUsecase(serviceLocator<AuthRepository>()),
    )
    ..registerFactory<CheckAuthStatusUsecase>(
      () => CheckAuthStatusUsecase(serviceLocator<AuthRepository>()),
    )
    ..registerFactory<SignOutUsecase>(
      () => SignOutUsecase(serviceLocator<AuthRepository>()),
    )
    ..registerLazySingleton<AuthBloc>(
      () => AuthBloc(
        serviceLocator<SignInUsecase>(),
        serviceLocator<SignUpUsecase>(),
        serviceLocator<CheckAuthStatusUsecase>(),
        serviceLocator<GoogleAuthUsecase>(),
        serviceLocator<SignOutUsecase>(),
      ),
    );
}
