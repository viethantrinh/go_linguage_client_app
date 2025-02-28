import 'package:go_linguage/core/constants/api_constants.dart';
import 'package:go_linguage/core/network/dio_client.dart';
import 'package:go_linguage/features/auth/data/models/introspect_token_response_model.dart';
import 'package:go_linguage/features/auth/data/models/sign_in_response_model.dart';
import 'package:go_linguage/features/auth/data/models/sign_up_response_model.dart';

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

  Future<bool> validateToken({required String token});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

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
