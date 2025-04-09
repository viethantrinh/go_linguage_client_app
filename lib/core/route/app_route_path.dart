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
  static const String lesson =
      '/home/subject/:subjectId/lesson/:lessonId/:isExam';
  static const String exam = '/exam';
  static const String dialog = '/dialog';
  static const String user = '/user';
  static const String userInformationUpdate = '/user/update';
  static const String setting = '/setting';
  static const String search = '/search';
  static const String completeLesson = '/complete-lesson/:score';
  static const String examFail = '/exam-fail/:subjectId/:lessonId';
  // Standalone routes without bottom navigation
  // static const String subject = '/subject/:subjectId';
  // static const String lesson = '/subject/:subjectId/lesson/:lessonId';

  // Subscription, Payment routes
  static const subscription = '/subscription';
  static const myVocabulary = '/my-vocabulary';
  static const myDialog = '/my-dialog';
  static const flashCard = '/flash-card';
  static const flashCardList = '/flash-card-list';
  static const review = '/review';
  static const song = '/song';
  static const conversation = '/conversation';
  static const songPlayer = '/song-player';
  static const submit = '/submit';
}
