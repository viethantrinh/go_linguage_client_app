import 'package:go_linguage/core/constants/api_constants.dart';
import 'package:go_linguage/core/log/log.dart';
import 'package:go_linguage/core/network/dio_client.dart';
import 'package:go_linguage/features/auth/data/models/google_auth_response_model.dart';
import 'package:go_linguage/features/auth/data/models/introspect_token_response_model.dart';
import 'package:go_linguage/features/auth/data/models/sign_in_response_model.dart';
import 'package:go_linguage/features/auth/data/models/sign_up_response_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract interface class AuthRemoteDataSource {
  Future<SignInResponseModel> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<SignUpResponseModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<GoogleAuthResponseModel> authenticationWithGoogle();

  Future<bool> validateToken({required String token});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl({
    required this.dioClient,
    required this.googleSignIn,
  });

  @override
  Future<SignInResponseModel> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioClient.post<SignInResponseModel>(
        url: ApiConstants.signIn,
        resultFromJson: (json) => SignInResponseModel.fromJson(json),
        jsonBody: {'email': email, 'password': password},
      );

      if (response.isSuccess && response.result != null) {
        return SignInResponseModel(token: response.result!.token);
      } else {
        String apiPath = response.errorResponse!.apiPath;
        List<String> errorMessages = response.errorResponse!.errors;
        final errorMessage =
            errorMessages.isEmpty ? errorMessages.first : response.message;
        throw Exception('$errorMessage occured on $apiPath');
      }
    } catch (e) {
      throw Exception('Sign in failed: ${e.toString()}');
    }
  }

  @override
  Future<SignUpResponseModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioClient.post(
        url: ApiConstants.signUp,
        resultFromJson: (json) => SignUpResponseModel.fromJson(json),
        jsonBody: {'name': name, 'email': email, 'password': password},
      );

      if (response.isSuccess && response.result != null) {
        return SignUpResponseModel(token: response.result!.token);
      } else {
        String apiPath = response.errorResponse!.apiPath;
        List<String> errorMessages = response.errorResponse!.errors;
        final errorMessage =
            errorMessages.isEmpty ? errorMessages.first : response.message;
        throw Exception('$errorMessage occured on $apiPath');
      }
    } catch (e) {
      throw Exception('Sign up failed: ${e.toString()}');
    }
  }

  @override
  Future<GoogleAuthResponseModel> authenticationWithGoogle() async {
    try {
      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google Sign-In was cancelled by the user');
      }

      // if success, get authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? idToken = googleAuth.idToken;

      Log.getLogger.d('The id token from google is $idToken');

      if (idToken == null) {
        throw Exception('Failed to get ID token from Google');
      }

      final response = await dioClient.post(
        url: ApiConstants.googleBackendAuth,
        resultFromJson: (json) => GoogleAuthResponseModel.fromJson(json),
        jsonBody: {'idToken': idToken},
      );

      if (response.isSuccess && response.result != null) {
        return GoogleAuthResponseModel(token: response.result!.token);
      } else {
        String apiPath = response.errorResponse!.apiPath;
        List<String> errorMessages = response.errorResponse!.errors;
        final errorMessage =
            errorMessages.isEmpty ? errorMessages.first : response.message;
        throw Exception('$errorMessage occured on $apiPath');
      }
    } catch (e) {
      throw Exception('Authentication with google failed: ${e.toString()}');
    }
  }

  @override
  Future<bool> validateToken({required String token}) async {
    try {
      final response = await dioClient.post(
        url: ApiConstants.introspectToken,
        resultFromJson: (json) => IntrospectTokenResponseModel.fromJson(json),
        jsonBody: {'token': token},
      );

      if (response.isSuccess && response.result != null) {
        return response.result!.valid;
      } else {
        String apiPath = response.errorResponse!.apiPath;
        List<String> errorMessages = response.errorResponse!.errors;
        final errorMessage =
            errorMessages.isEmpty ? errorMessages.first : response.message;
        throw Exception('$errorMessage occured on $apiPath');
      }
    } catch (e) {
      throw Exception('Introspect token failed: ${e.toString()}');
    }
  }
}
