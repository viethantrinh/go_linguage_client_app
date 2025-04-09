import 'dart:convert';
import 'dart:io';
import 'package:go_linguage/core/common/global/global_variable.dart';
import 'package:go_linguage/core/constants/api_constants.dart';
import 'package:go_linguage/core/network/dio_client.dart';
import 'package:go_linguage/features/user_info/data/models/api_user_model.dart';
import 'package:go_linguage/features/user_info/data/models/api_user_update_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class IUserRemoteDataSource {
  Future<UserResopnseModel> getUserInfo();
  Future<UserUpdateResopnseModel> updateUserInfo(String name);
}

class UserRemoteDataSourceImpl implements IUserRemoteDataSource {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  static String tokenKey = 'AUTH_TOKEN';
  static String lastFetchTimeKey = 'LAST_USER_FETCH_TIME';
  static String userCacheFilename = 'user_data.json';
  static const int cacheExpirationHours = 24; // Thời gian cache hết hạn (giờ)

  UserRemoteDataSourceImpl({
    required this.dioClient,
    required this.sharedPreferences,
  });

  @override
  Future<UserResopnseModel> getUserInfo() async {
    try {
      String? token = await sharedPreferences.getString(tokenKey);
      final response = await dioClient.get<UserResopnseModel>(
          url: ApiConstants.getUserInfo,
          resultFromJson: (dynamic json) {
            return UserResopnseModel.fromJson(json);
          },
          token: token);

      if (response.isSuccess && response.result != null) {
        userData.value = response.result!;
        return response.result!;
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
  Future<UserUpdateResopnseModel> updateUserInfo(String name) async {
    try {
      String? token = await sharedPreferences.getString(tokenKey);
      final response = await dioClient.put<UserUpdateResopnseModel>(
          jsonBody: {"name": name, "id": userData.value?.id ?? 0},
          url: ApiConstants.updateUserInfo,
          resultFromJson: (dynamic json) {
            return UserUpdateResopnseModel.fromJson(json);
          },
          token: token);

      if (response.isSuccess && response.result != null) {
        if (userData.value != null) {
          userData.value!.name = response.result!.name;
        }
        return response.result!;
      }
    } catch (e) {}
    throw Exception('Update user info failed');
  }
}
