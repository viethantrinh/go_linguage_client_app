class ApiConstants {
  static const String baseUrl = 'http://localhost:8080/api';

  // authentication endpoints
  static const String signIn = '/auth/sign-in';
  static const String signUp = '/auth/sign-up';
  static const String signOut = '/auth/sign-out';
  static const String introspectToken = '/auth/introspect-token';
  static const String googleBackendAuth = '/auth/google';

  // payment endpoints
  static const String requestPaymentIntent = '/payment/create-payment-intent';
  static const String createSubscription = '/payment/create-stripe-subscription';
}
