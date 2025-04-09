import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get_it/get_it.dart';
import 'package:go_linguage/core/network/dio_client.dart';
import 'package:go_linguage/core/network/connectivity_service.dart';
import 'package:go_linguage/core/network/connectivity/connectivity_bloc.dart';
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
import 'package:go_linguage/features/dialog/data/datasources/dialog_data_source.dart';
import 'package:go_linguage/features/dialog/data/repositories/dialog_repository_impl.dart';
import 'package:go_linguage/features/dialog/domain/repositories/dialog_repository.dart';
import 'package:go_linguage/features/dialog/domain/usecases/dialog_view_usecase.dart';
import 'package:go_linguage/features/dialog/domain/usecases/pronoun_dialog_usecase.dart';
import 'package:go_linguage/features/dialog/presentation/bloc/dialog_bloc.dart';
import 'package:go_linguage/features/dialog_list/data/datasources/conversation_data_source.dart';
import 'package:go_linguage/features/dialog_list/data/repositories/conversation_repository_impl.dart';
import 'package:go_linguage/features/dialog_list/domain/repositories/conversation_repository.dart';
import 'package:go_linguage/features/dialog_list/domain/usecases/conversation_view_usecase.dart';
import 'package:go_linguage/features/dialog_list/presentation/bloc/conversation_bloc.dart';
import 'package:go_linguage/features/exam/data/datasources/exam_remote_data_source.dart';
import 'package:go_linguage/features/exam/data/repositories/exam_repository_impl.dart';
import 'package:go_linguage/features/exam/domain/repositories/exam_repository.dart';
import 'package:go_linguage/features/exam/domain/usecases/exam_view_usecase.dart';
import 'package:go_linguage/features/exam/presentation/bloc/exam_bloc.dart';
import 'package:go_linguage/features/home/data/datasources/home_remote_data_source.dart';
import 'package:go_linguage/features/home/data/repositories/home_repository_impl.dart';
import 'package:go_linguage/features/home/domain/repositories/home_repository.dart';
import 'package:go_linguage/features/home/domain/usecases/view_usecase.dart';
import 'package:go_linguage/features/home/presentation/bloc/home_bloc.dart';
import 'package:go_linguage/features/lesson/data/datasources/lesson_data_source.dart';
import 'package:go_linguage/features/lesson/data/repositories/lesson_repository_impl.dart';
import 'package:go_linguage/features/lesson/domain/repositories/lesson_repository.dart';
import 'package:go_linguage/features/lesson/domain/usecases/pronoun_usecase.dart';
import 'package:go_linguage/features/lesson/domain/usecases/view_usecase.dart';
import 'package:go_linguage/features/lesson/presentation/bloc/lesson_bloc.dart';
import 'package:go_linguage/features/main/presentation/bloc/main_bloc.dart';
import 'package:go_linguage/features/payment/data/datasources/subscription_remote_data_source.dart';
import 'package:go_linguage/features/payment/data/repositories/subscription_repository_impl.dart';
import 'package:go_linguage/features/payment/domain/repositories/subscription_repository.dart';
import 'package:go_linguage/features/payment/domain/usecases/create_subscription_usecase.dart';
import 'package:go_linguage/features/payment/domain/usecases/request_payment_usecase.dart';
import 'package:go_linguage/features/payment/presentation/bloc/subscription_bloc.dart';
import 'package:go_linguage/features/song/data/datasources/song_data_source.dart';
import 'package:go_linguage/features/song/data/repositories/song_repository_impl.dart';
import 'package:go_linguage/features/song/domain/repositories/song_repository.dart';
import 'package:go_linguage/features/song/domain/usecases/song_view_usecase.dart';
import 'package:go_linguage/features/song/presentation/bloc/song_bloc.dart';
import 'package:go_linguage/features/subject/data/datasources/subject_data_source.dart';
import 'package:go_linguage/features/subject/data/repositories/subject_repository_impl.dart';
import 'package:go_linguage/features/subject/domain/repositories/subject_repository.dart';
import 'package:go_linguage/features/subject/domain/usecases/subject_view_usecase.dart';
import 'package:go_linguage/features/subject/presentation/bloc/subject_bloc.dart';
import 'package:go_linguage/features/submit/data/datasources/submit_data_source.dart';
import 'package:go_linguage/features/submit/data/repositories/submit_repository_impl.dart';
import 'package:go_linguage/features/submit/domain/repositories/submit_repository.dart';
import 'package:go_linguage/features/submit/domain/usecases/submit_usecase.dart';
import 'package:go_linguage/features/submit/presentation/bloc/submit_bloc.dart';
import 'package:go_linguage/features/user_info/data/datasources/user_data_source.dart';
import 'package:go_linguage/features/user_info/data/repositories/user_repository_impl.dart';
import 'package:go_linguage/features/user_info/domain/repositories/user_repository.dart';
import 'package:go_linguage/features/user_info/domain/usecases/user_view_usecase.dart';
import 'package:go_linguage/features/user_info/presentation/bloc/user_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.I;

Future<void> initializeDependencies() async {
  // Connectivity
  serviceLocator.registerLazySingleton<ConnectivityService>(
    () => ConnectivityServiceImpl(),
  );

  serviceLocator.registerFactory<ConnectivityBloc>(
    () => ConnectivityBloc(serviceLocator<ConnectivityService>()),
  );

  // register shared preference
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerSingleton<SharedPreferences>(sharedPreferences);
  // register shared preference

  // register dio http client
  serviceLocator.registerFactory<DioClient>(() => DioClient());
  // register dio http client

  // register google sign in
  GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: AppSecret.androidClientId,
    serverClientId: AppSecret.serverClientId,
  );
  serviceLocator.registerLazySingleton(() => googleSignIn);
  // register google sign in

  // register stripe configuration
  Stripe.publishableKey = AppSecret.stripePublishableKey;
  await Stripe.instance.applySettings();
  // register stripe configuration

  _initAuthDependencies();
  _initSubscriptionDependencies();
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
    )

    ///////////////////////___HOME___///////////////////////
    ..registerFactory<HomeRemoteDataSourceImpl>(
      () => HomeRemoteDataSourceImpl(
        sharedPreferences: serviceLocator<SharedPreferences>(),
        dioClient: serviceLocator<DioClient>(),
      ),
    )
    ..registerFactory<HomeRepository>(
      () => HomeRepositoryImpl(
        homeRemoteDataSource: serviceLocator<HomeRemoteDataSourceImpl>(),
      ),
    )
    ..registerFactory<HomeViewUsecase>(
      () => HomeViewUsecase(serviceLocator<HomeRepository>()),
    )
    ..registerLazySingleton<HomeBloc>(
      () => HomeBloc(
        serviceLocator<HomeViewUsecase>(),
      ),
    )
    ///////////////////////___MAIN___///////////////////////
    ..registerLazySingleton<MainBloc>(
      () => MainBloc(),
    )
    ///////////////////////___SUBJECT___///////////////////////
    ..registerFactory<SubjectRemoteDataSourceImpl>(
      () => SubjectRemoteDataSourceImpl(
        sharedPreferences: serviceLocator<SharedPreferences>(),
        dioClient: serviceLocator<DioClient>(),
      ),
    )
    ..registerFactory<SubjectRepository>(
      () => SubjectRepositoryImpl(
        subjectRemoteDataSourceImpl:
            serviceLocator<SubjectRemoteDataSourceImpl>(),
      ),
    )
    ..registerFactory<SubjectViewUsecase>(
      () => SubjectViewUsecase(serviceLocator<SubjectRepository>()),
    )
    ..registerLazySingleton<SubjectBloc>(
      () => SubjectBloc(serviceLocator<SubjectViewUsecase>()),
    )

    ///////////////////////___LESSON___///////////////////////
    ..registerFactory<LessonDataSourceImpl>(
      () => LessonDataSourceImpl(
        sharedPreferences: serviceLocator<SharedPreferences>(),
        dioClient: serviceLocator<DioClient>(),
      ),
    )
    ..registerFactory<LessonRepository>(
      () => LessonRepositoryImpl(
        lessonRemoteDataSource: serviceLocator<LessonDataSourceImpl>(),
      ),
    )
    ..registerFactory<LessonViewUsecase>(
      () => LessonViewUsecase(serviceLocator<LessonRepository>()),
    )
    ..registerFactory<PronounUsecase>(
      () => PronounUsecase(serviceLocator<LessonRepository>()),
    )
    ..registerLazySingleton<LessonBloc>(
      () => LessonBloc(serviceLocator<LessonViewUsecase>(),
          serviceLocator<PronounUsecase>()),
    )
    ///////////////////////___EXAM___///////////////////////
    ..registerFactory<ExamRemoteDataSourceImpl>(
      () => ExamRemoteDataSourceImpl(
        sharedPreferences: serviceLocator<SharedPreferences>(),
        dioClient: serviceLocator<DioClient>(),
      ),
    )
    ..registerFactory<ExamRepository>(
      () => ExamRepositoryImpl(
        examRemoteDataSource: serviceLocator<ExamRemoteDataSourceImpl>(),
      ),
    )
    ..registerFactory<ExamViewUsecase>(
      () => ExamViewUsecase(serviceLocator<ExamRepository>()),
    )
    ..registerLazySingleton<ExamBloc>(() => ExamBloc(
          serviceLocator<ExamViewUsecase>(),
        ))

    ///////////////////////___CONVERSATION___///////////////////////
    ..registerFactory<ConversationRemoteDataSourceImpl>(
      () => ConversationRemoteDataSourceImpl(
        sharedPreferences: serviceLocator<SharedPreferences>(),
        dioClient: serviceLocator<DioClient>(),
      ),
    )
    ..registerFactory<ConversationRepository>(
      () => ConversationRepositoryImpl(
        conversationRemoteDataSourceImpl:
            serviceLocator<ConversationRemoteDataSourceImpl>(),
      ),
    )
    ..registerFactory<ConversationViewUsecase>(
      () => ConversationViewUsecase(serviceLocator<ConversationRepository>()),
    )
    ..registerLazySingleton<ConversationBloc>(() => ConversationBloc(
          serviceLocator<ConversationViewUsecase>(),
        ))
    ///////////////////////___DIALOG___///////////////////////
    ..registerFactory<DialogRemoteDataSourceImpl>(
      () => DialogRemoteDataSourceImpl(
        sharedPreferences: serviceLocator<SharedPreferences>(),
        dioClient: serviceLocator<DioClient>(),
      ),
    )
    ..registerFactory<DialogRepository>(
      () => DialogRepositoryImpl(
        dialogRemoteDataSourceImpl:
            serviceLocator<DialogRemoteDataSourceImpl>(),
      ),
    )
    ..registerFactory<DialogViewUsecase>(
      () => DialogViewUsecase(serviceLocator<DialogRepository>()),
    )
    ..registerFactory<PronounDialogUsecase>(
      () => PronounDialogUsecase(serviceLocator<DialogRepository>()),
    )
    ..registerLazySingleton<DialogBloc>(() => DialogBloc(
          serviceLocator<DialogViewUsecase>(),
          serviceLocator<PronounDialogUsecase>(),
        ))
    ///////////////////////___SONG___///////////////////////
    ..registerFactory<SongDataSourceImpl>(
      () => SongDataSourceImpl(
        sharedPreferences: serviceLocator<SharedPreferences>(),
        dioClient: serviceLocator<DioClient>(),
      ),
    )
    ..registerFactory<SongRepository>(
      () => SongRepositoryImpl(
        songRemoteDataSourceImpl: serviceLocator<SongDataSourceImpl>(),
      ),
    )
    ..registerFactory<SongViewUsecase>(
      () => SongViewUsecase(serviceLocator<SongRepository>()),
    )
    ..registerLazySingleton<SongBloc>(() => SongBloc(
          serviceLocator<SongViewUsecase>(),
        ))
    ///////////////////////___SUBMIT___///////////////////////
    ..registerFactory<SubmitDataSourceImpl>(
      () => SubmitDataSourceImpl(
        sharedPreferences: serviceLocator<SharedPreferences>(),
        dioClient: serviceLocator<DioClient>(),
      ),
    )
    ..registerFactory<SubmitRepository>(
      () => SubmitRepositoryImpl(
        submitRemoteDataSourceImpl: serviceLocator<SubmitDataSourceImpl>(),
      ),
    )
    ..registerFactory<SubmitUsecase>(
      () => SubmitUsecase(serviceLocator<SubmitRepository>()),
    )
    ..registerLazySingleton<SubmitBloc>(() => SubmitBloc(
          serviceLocator<SubmitUsecase>(),
        ))

    ///////////////////////___USER___///////////////////////
    ..registerFactory<UserRemoteDataSourceImpl>(
      () => UserRemoteDataSourceImpl(
        sharedPreferences: serviceLocator<SharedPreferences>(),
        dioClient: serviceLocator<DioClient>(),
      ),
    )
    ..registerFactory<UserRepository>(
      () => UserRepositoryImpl(
        userRemoteDataSourceImpl: serviceLocator<UserRemoteDataSourceImpl>(),
      ),
    )
    ..registerFactory<UserViewUsecase>(
      () => UserViewUsecase(serviceLocator<UserRepository>()),
    )
    ..registerFactory<UserUpdateUsecase>(
      () => UserUpdateUsecase(serviceLocator<UserRepository>()),
    )
    ..registerLazySingleton<UserBloc>(() => UserBloc(
          serviceLocator<UserViewUsecase>(),
          serviceLocator<UserUpdateUsecase>(),
        ));
}

void _initSubscriptionDependencies() {
  serviceLocator
    // ..registerFactory<AuthLocalDataSource>(
    //   () => AuthLocalDataSourceImpl(
    //     sharedPreferences: serviceLocator<SharedPreferences>(),
    //   ),
    // )
    ..registerFactory<SubscriptionRemoteDataSource>(
      () => SubscriptionRemoteDataSourceImpl(
        dioClient: serviceLocator<DioClient>(),
        authLocalDataSource: serviceLocator<AuthLocalDataSource>(),
      ),
    )
    ..registerFactory<SubscriptionRepository>(
      () => SubscriptionRepositoryImpl(
        subscriptionRemoteDataSource:
            serviceLocator<SubscriptionRemoteDataSource>(),
      ),
    )
    ..registerFactory<RequestPaymentUsecase>(
      () => RequestPaymentUsecase(
        subscriptionRepository: serviceLocator<SubscriptionRepository>(),
      ),
    )
    ..registerFactory<CreateSubscriptionUsecase>(
      () => CreateSubscriptionUsecase(
        subscriptionRepository: serviceLocator<SubscriptionRepository>(),
      ),
    )
    ..registerLazySingleton<SubscriptionBloc>(
      () => SubscriptionBloc(
          requestPaymentUsecase: serviceLocator<RequestPaymentUsecase>(),
          createSubscriptionUsecase:
              serviceLocator<CreateSubscriptionUsecase>()),
    );
}
