class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:8080/api';
  static const String baseRemoteUrl =
      'https://go-linguage-server-9ab98bbccd59.herokuapp.com/api';

  // authentication endpoints
  static const String signIn = '/auth/sign-in';
  static const String signUp = '/auth/sign-up';
  static const String signOut = '/auth/sign-out';
  static const String introspectToken = '/auth/introspect-token';
  static const String googleBackendAuth = '/auth/google';

  // payment endpoints
  static const String requestPaymentIntent = '/payment/create-payment-intent';
  static const String createSubscription =
      '/payment/create-stripe-subscription';

  static const String getHomeData = '/main/home';
  static String getLessonData(int id) => '/topics/$id/lessons/detail';
  static const String pronunciationAssessment = "/learns/pronoun-assessment";
  static const String getExamData = '/main/review';
  static const String getConversationData = '/main/conversation';
  static const String getDialogData = '/conversations/1/detail';
  static const String checkPronoun = '/conversations/pronoun-assessment';
  static const String getSongData = '/songs';
  static String submitLesson(int lessonId) => '/lessons/$lessonId/submit';
  static String submitDialog(int conversationId) =>
      '/conversations/$conversationId/submit';
  static const String getUserInfo = '/users/info';
  static const String updateUserInfo = '/users/info';
}
