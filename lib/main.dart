import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_linguage/core/route/app_route.dart';
import 'package:go_linguage/core/theme/app_theme.dart';
import 'package:go_linguage/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:go_linguage/features/home/presentation/bloc/home_bloc.dart';
import 'package:go_linguage/features/main/presentation/bloc/main_bloc.dart';
import 'package:go_linguage/features/payment/presentation/bloc/subscription_bloc.dart';
import 'package:go_linguage/init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
        BlocProvider(create: (_) => serviceLocator<HomeBloc>()),
        BlocProvider(create: (_) => serviceLocator<MainBloc>()),
        BlocProvider(create: (_) => serviceLocator<SubscriptionBloc>()),
      ],
      child: MyApp(),
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
    ));
  }
}
