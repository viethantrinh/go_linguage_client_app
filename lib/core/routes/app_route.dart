import 'package:go_linguage/core/routes/app_route_path.dart';
import 'package:go_linguage/features/auth/presentation/pages/on_board_page.dart';
import 'package:go_linguage/features/auth/presentation/pages/sign_in_option_page.dart';
import 'package:go_linguage/features/auth/presentation/pages/sign_in_page.dart';
import 'package:go_linguage/features/auth/presentation/pages/sign_up_option_page.dart';
import 'package:go_linguage/features/auth/presentation/pages/sign_up_page.dart';
import 'package:go_linguage/features/auth/presentation/pages/splash_page.dart';
import 'package:go_router/go_router.dart';

class AppRoute {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutePath.splash,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutePath.splash,
        builder: (context, state) {
          return const SplashPage();
        },
      ),
      GoRoute(
        path: AppRoutePath.onBoard,
        builder: (context, state) => const OnBoardPage(),
      ),
      GoRoute(
        path: AppRoutePath.signUpOption,
        builder: (context, state) => const SignUpOptionPage(),
      ),
      GoRoute(path: AppRoutePath.signUp, builder: (context, state) => const SignUpPage()),
      GoRoute(
        path: AppRoutePath.signInOption,
        builder: (context, state) => const SignInOptionPage(),
      ),
      GoRoute(path: AppRoutePath.signIn, builder: (context, state) => const SignInPage()),
    ],
  );
}
