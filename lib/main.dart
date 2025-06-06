import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_linguage/core/common/widgets/connectivity_wrapper.dart';
import 'package:go_linguage/core/network/connectivity/connectivity_bloc.dart';
import 'package:go_linguage/core/route/app_route.dart';
import 'package:go_linguage/core/services/notification_service.dart';
import 'package:go_linguage/core/theme/app_theme.dart';
import 'package:go_linguage/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:go_linguage/features/dialog/presentation/bloc/dialog_bloc.dart';
import 'package:go_linguage/features/dialog_list/presentation/bloc/conversation_bloc.dart';
import 'package:go_linguage/features/exam/presentation/bloc/exam_bloc.dart';
import 'package:go_linguage/features/home/presentation/bloc/home_bloc.dart';
import 'package:go_linguage/features/lesson/presentation/bloc/lesson_bloc.dart';
import 'package:go_linguage/features/main/presentation/bloc/main_bloc.dart';
import 'package:go_linguage/features/payment/presentation/bloc/subscription_bloc.dart';
import 'package:go_linguage/features/song/presentation/bloc/song_bloc.dart';
import 'package:go_linguage/features/subject/presentation/bloc/subject_bloc.dart';
import 'package:go_linguage/features/submit/presentation/bloc/submit_bloc.dart';
import 'package:go_linguage/features/user_info/presentation/bloc/user_bloc.dart';
import 'package:go_linguage/init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();

  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.init();

  // Restore notifications if they were enabled
  await notificationService.restoreNotificationsIfEnabled();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
        BlocProvider(create: (_) => serviceLocator<MainBloc>()),
        BlocProvider(create: (_) => serviceLocator<SubscriptionBloc>()),
        BlocProvider(create: (_) => serviceLocator<HomeBloc>()),
        BlocProvider(create: (_) => serviceLocator<ConnectivityBloc>()),
        BlocProvider(create: (_) => serviceLocator<SubjectBloc>()),
        BlocProvider(create: (_) => serviceLocator<LessonBloc>()),
        BlocProvider(create: (_) => serviceLocator<ExamBloc>()),
        BlocProvider(create: (_) => serviceLocator<ConversationBloc>()),
        BlocProvider(create: (_) => serviceLocator<DialogBloc>()),
        BlocProvider(create: (_) => serviceLocator<SongBloc>()),
        BlocProvider(create: (_) => serviceLocator<SubmitBloc>()),
        BlocProvider(create: (_) => serviceLocator<UserBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.themeLightData,
        routerConfig: AppRoute.router,
        builder: (context, child) {
          return ConnectivityWrapper(child: child ?? const SizedBox.shrink());
        },
      ),
    );
  }
}
