import 'dart:convert';
import 'dart:io';
import 'package:go_linguage/core/constants/api_constants.dart';
import 'package:go_linguage/core/network/dio_client.dart';
import 'package:go_linguage/features/dialog/data/models/api_dialog_model.dart';


import 'package:shared_preferences/shared_preferences.dart';

abstract interface class IDialogRemoteDataSource {
  Future<List<DialogListResopnseModel>> getDialogData();
}

class DialogRemoteDataSourceImpl implements IDialogRemoteDataSource {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  static String tokenKey = 'AUTH_TOKEN';
  static String lastFetchTimeKey = 'LAST_CONVERSATION_FETCH_TIME';
  static String conversationCacheFilename = 'conversation_data.json';
  static const int cacheExpirationHours = 24; // Thời gian cache hết hạn (giờ)

  DialogRemoteDataSourceImpl({
    required this.dioClient,
    required this.sharedPreferences,
  });

  @override
  Future<List<DialogListResopnseModel>> getDialogData() async {
    try {
      String? token = await sharedPreferences.getString(tokenKey);
      final response = await dioClient.get<List<DialogListResopnseModel>>(
          url: ApiConstants.getDialogData,
          resultFromJson: (dynamic json) {
            // Xử lý trường hợp json là List
            if (json is List) {
              return List<DialogListResopnseModel>.from(
                  json.map((x) => DialogListResopnseModel.fromJson(x)));
            }
            // Xử lý trường hợp json là Map và có key 'result' chứa List
            else if (json is Map<String, dynamic> &&
                json.containsKey('result') &&
                json['result'] is List) {
              return List<DialogListResopnseModel>.from((json['result'] as List)
                  .map((x) => DialogListResopnseModel.fromJson(x)));
            }
            // Trường hợp không xác định, trả về danh sách rỗng
            print('Unexpected JSON format: ${json.runtimeType}');
            return <DialogListResopnseModel>[];
          },
          token: token);

      if (response.isSuccess && response.result != null) {
        return response.result!;
      } else {
        String apiPath = response.errorResponse!.apiPath;
        List<String> errorMessages = response.errorResponse!.errors;
        final errorMessage =
            errorMessages.isEmpty ? errorMessages.first : response.message;
        throw Exception('$errorMessage occured on $apiPath');
      }
    } catch (e) {
      print('Error in getConversationData: ${e.toString()}');

      throw Exception('Sign in failed: ${e.toString()}');
    }
  }
}
