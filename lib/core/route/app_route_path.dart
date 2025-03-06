class AppRoutePath {
  // Authentication routes
  static const String splash = '/';
  static const String onBoard = '/onboard';
  static const String signUpOption = '/signup-option';
  static const String signUp = '/signup';
  static const String signInOption = '/signin-option';
  static const String signIn = '/signin';

  // Main app routes
  static const String home = '/home';
  static const String subject = '/home/subject/:subjectId';
  static const String lesson = '/home/subject/:subjectId/lesson/:lessonId';
  static const String exam = '/exam';
  static const String dialog = '/dialog';

  // Standalone routes without bottom navigation
  // static const String subject = '/subject/:subjectId';
  // static const String lesson = '/subject/:subjectId/lesson/:lessonId';

  // Subscription, Payment routes
  static const subscription = '/subscription';
}
