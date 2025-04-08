import 'dart:convert';

import 'package:go_linguage/core/common/global/global_variable.dart';
import 'package:go_linguage/core/constants/api_constants.dart';
import 'package:go_linguage/core/network/dio_client.dart';
import 'package:go_linguage/features/submit/data/models/api_submit_model.dart';
import 'package:go_linguage/features/submit/domain/model/submit_model.dart';

import 'package:shared_preferences/shared_preferences.dart';

abstract interface class ISubmitRemoteDataSource {
  Future<SubmitResopnseModel> submitData(SubmitRequestModel request);
}

class SubmitDataSourceImpl implements ISubmitRemoteDataSource {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  static String tokenKey = 'AUTH_TOKEN';
  static String lastFetchTimeKey = 'LAST_CONVERSATION_FETCH_TIME';
  static String conversationCacheFilename = 'conversation_data.json';
  static const int cacheExpirationHours = 24; // Thời gian cache hết hạn (giờ)

  SubmitDataSourceImpl({
    required this.dioClient,
    required this.sharedPreferences,
  });

  @override
  Future<SubmitResopnseModel> submitData(SubmitRequestModel request) async {
    try {
      String? token = await sharedPreferences.getString(tokenKey);
      final response = await dioClient.post<SubmitResopnseModel>(
          url: request.type == SubmitType.dialog
              ? ApiConstants.submitDialog(request.id)
              : ApiConstants.submitLesson(2),
          resultFromJson: (dynamic json) {
            return SubmitResopnseModel.fromJson(json);
          },
          token: token,
          jsonBody: request.type == SubmitType.dialog
              ? jsonEncode({
                  'goPoints': request.goPoints,
                })
              : jsonEncode({
                  'xpPoints': request.xpPoints,
                  'goPoints': request.goPoints,
                }));
      if (response.isSuccess && response.result != null) {
        userGoPoint.value += request.goPoints;
        return response.result!;
      } else {
        String apiPath = response.errorResponse!.apiPath;
        List<String> errorMessages = response.errorResponse!.errors;
        final errorMessage =
            errorMessages.isEmpty ? errorMessages.first : response.message;
        throw Exception('$errorMessage occured on $apiPath');
      }
    } catch (e) {
      print('Error in submitData: ${e.toString()}');
      throw Exception('Submit failed: ${e.toString()}');
    }
  }
}
