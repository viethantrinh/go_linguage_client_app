class ApiConstants {
  static const String baseUrl =
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
}
