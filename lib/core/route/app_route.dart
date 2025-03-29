import 'package:flutter/material.dart';
import 'package:go_linguage/core/route/app_route_path.dart';
import 'package:go_linguage/features/auth/presentation/pages/on_board_page.dart';
import 'package:go_linguage/features/auth/presentation/pages/sign_in_option_page.dart';
import 'package:go_linguage/features/auth/presentation/pages/sign_in_page.dart';
import 'package:go_linguage/features/auth/presentation/pages/sign_up_option_page.dart';
import 'package:go_linguage/features/auth/presentation/pages/sign_up_page.dart';
import 'package:go_linguage/features/auth/presentation/pages/splash_page.dart';
import 'package:go_linguage/features/exam/data/models/exam_model.dart';
import 'package:go_linguage/features/exam/presentation/pages/dialog_learned.dart';
import 'package:go_linguage/features/exam/presentation/pages/flash_card.dart';
import 'package:go_linguage/features/exam/presentation/pages/vocabulary_learned.dart';
import 'package:go_linguage/features/lesson/presentation/pages/exam_fail.dart';
import 'package:go_linguage/features/lesson/presentation/pages/learn_lesson.dart';
import 'package:go_linguage/features/lesson/presentation/pages/result.dart';
import 'package:go_linguage/features/search/presentation/search_page.dart';
import 'package:go_linguage/features/main/presentation/pages/dialog_page.dart';
import 'package:go_linguage/features/exam/presentation/pages/exam_page.dart';
import 'package:go_linguage/features/home/presentation/pages/home_page.dart';
import 'package:go_linguage/features/main/presentation/pages/lesson_page.dart';
import 'package:go_linguage/features/main/presentation/pages/main_scaffold.dart';
import 'package:go_linguage/features/subject/model/subject_model.dart';
import 'package:go_linguage/features/subject/presentation/pages/subject_page.dart';
import 'package:go_linguage/features/payment/presentation/pages/subscription_page.dart';
import 'package:go_linguage/features/setting/presentation/pages/setting.dart';
import 'package:go_linguage/features/user_info/presentation/pages/user_information_update.dart';
import 'package:go_linguage/features/user_info/presentation/pages/user_page.dart';
import 'package:go_router/go_router.dart';
import 'package:go_linguage/features/home/data/models/home_model.dart';

class AppRoute {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routerNeglect: true,
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
      GoRoute(
        path: AppRoutePath.signUp,
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: AppRoutePath.signInOption,
        builder: (context, state) => const SignInOptionPage(),
      ),
      GoRoute(
        path: AppRoutePath.signIn,
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: AppRoutePath.user,
        builder: (context, state) => const UserPage(),
      ),
      GoRoute(
        path: AppRoutePath.userInformationUpdate,
        builder: (context, state) => const UserInformationUpdate(),
      ),
      GoRoute(
        path: AppRoutePath.search,
        builder: (context, state) {
          final homeData = state.extra as HomeResponseModel?;

          if (homeData == null) {
            return const Scaffold(
              body: Center(
                child: Text('Không có dữ liệu để hiển thị'),
              ),
            );
          }

          return SearchPage(data: homeData);
        },
      ),
      GoRoute(
        path: AppRoutePath.setting,
        builder: (context, state) => const SettingPage(),
      ),
      GoRoute(
        path: AppRoutePath.completeLesson,
        builder: (context, state) {
          final score = state.pathParameters['score'] ?? '0';
          return LessonCompletedScreen(points: int.parse(score));
        },
      ),
      GoRoute(
        path: AppRoutePath.examFail,
        builder: (context, state) {
          final subjectId = state.pathParameters['subjectId'] ?? '1';
          final lessonId = state.pathParameters['lessonId'] ?? '1';
          return ExamFailScreen(
              subjectId: int.parse(subjectId), lessonId: int.parse(lessonId));
        },
      ),
      GoRoute(
        path: AppRoutePath.myVocabulary,
        builder: (context, state) {
          final flashCards = state.extra as List<FlashCard>;
          return MyVocabularyPage(flashCards: flashCards);
        },
      ),
      GoRoute(
        path: AppRoutePath.myDialog,
        builder: (context, state) {
          final dialogues = state.extra as List<Dialogue>;
          return MyDialogPage(dialogues: dialogues);
        },
      ),

      GoRoute(
        path: AppRoutePath.flashCard,
        builder: (context, state) {
          final flashCard = state.extra as List<FlashCard>;
          return FlashCardPage(flashCards: flashCard);
        },
      ),
      GoRoute(
        path: AppRoutePath.subscription,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          transitionsBuilder: (
            context,
            animation,
            secondaryAnimation,
            child,
          ) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          child: const SubscriptionPage(),
        ),
      ),

      // Subject route as a standalone route
      GoRoute(
        path: AppRoutePath.subject,
        builder: (context, state) {
          final subjectData = state.extra as SubjectModel?;

          if (subjectData == null) {
            return const Scaffold(
              body: Center(
                child: Text('Không có dữ liệu để hiển thị'),
              ),
            );
          }
          return SubjectPage(data: subjectData);
        },
      ),
      // GoRoute(
      //   path: AppRoutePath.subject,
      //   parentNavigatorKey: _rootNavigatorKey,
      //   builder: (context, state) {
      //     final subjectId = state.pathParameters['subjectId'] ?? '1';
      //     return SubjectPage(subjectId: subjectId);
      //   },
      // ),

      // // Lesson route as a standalone route
      GoRoute(
        path: AppRoutePath.lesson,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final subjectId = int.parse(state.pathParameters['subjectId'] ?? "1");
          final lessonId = int.parse(state.pathParameters['lessonId'] ?? "1");
          final isExam = state.pathParameters['isExam'] ?? "false";
          return LearnLessonScreen(
              subjectId: subjectId,
              lessonId: lessonId,
              isExam: isExam == "true");
        },
      ),

      // Main app shell route with nested branches
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          // Home branch with nested routes for deeper navigation
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutePath.home,
                builder: (context, state) => const HomePage(),
                routes: [
                  // Subject route as a child of home
                  // GoRoute(
                  //   path: 'subject/:subjectId',
                  //   builder: (context, state) {
                  //     final subjectId =
                  //         state.pathParameters['subjectId'] ?? '1';
                  //     return SubjectPage(subjectId: subjectId);
                  //   },
                  //   // Lesson route as a child of subject
                  //   routes: [
                  //     GoRoute(
                  //       path: 'lesson/:lessonId',
                  //       builder: (context, state) {
                  //         final subjectId =
                  //             state.pathParameters['subjectId'] ?? '1';
                  //         final lessonId =
                  //             state.pathParameters['lessonId'] ?? '1';
                  //         return LessonPage(
                  //           subjectId: subjectId,
                  //           lessonId: lessonId,
                  //         );
                  //       },
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ],
          ),
          // Exam branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutePath.exam,
                builder: (context, state) => const ExamPage(),
              ),
            ],
          ),
          // Dialog branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutePath.dialog,
                builder: (context, state) => const DialogPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
