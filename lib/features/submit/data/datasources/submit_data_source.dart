import 'dart:convert';

import 'package:go_linguage/core/common/global/global_variable.dart';
import 'package:go_linguage/core/constants/api_constants.dart';
import 'package:go_linguage/core/network/dio_client.dart';
import 'package:go_linguage/features/home/data/models/home_model.dart';
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

  SubmitDataSourceImpl({
    required this.dioClient,
    required this.sharedPreferences,
  });

  @override
  Future<SubmitResopnseModel> submitData(SubmitRequestModel request) async {
    try {
      //request.id = 2;
      // request.goPoints = 1000;
      // request.xpPoints = 3;
      String? token = await sharedPreferences.getString(tokenKey);
      final response = await dioClient.post<SubmitResopnseModel>(
          url: request.type == SubmitType.dialog
              ? ApiConstants.submitDialog(request.id)
              : ApiConstants.submitLesson(request.id),
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
        userData.value!.totalGoPoints = userGoPoint.value;
        userData.value!.totalXpPoints += request.xpPoints;
        int? oldScore = scoreData.value[request.id];
        scoreData.value[request.id] = request.xpPoints;

        for (var i = 0; i < homeDataGlobal.value!.levels.length; i++) {
          LevelModel lv = homeDataGlobal.value!.levels[i];
          for (int j = 0; j < lv.topics.length; j++) {
            TopicModel topic = lv.topics[j];
            if (topic.id == lessonMapTopic[request.id]) {
              if (oldScore != null) {
                int diff = scoreData.value[request.id]! - oldScore;
                topic.totalUserXPPoints += diff;
                lv.totalUserXPPoints += diff;
              } else {
                topic.totalUserXPPoints += scoreData.value[request.id]!;
                lv.totalUserXPPoints += scoreData.value[request.id]!;
              }
              break;
            }
          }
        }
        triggerHomeDataUpdate();

        return response.result!;
      } else {
        String apiPath = response.errorResponse!.apiPath;
        List<String> errorMessages = response.errorResponse!.errors;
        final errorMessage =
            errorMessages.isEmpty ? errorMessages.first : response.message;
        throw Exception('$errorMessage occured on $apiPath');
      }
    } catch (e) {
      throw Exception('Submit failed: ${e.toString()}');
    }
  }
}
