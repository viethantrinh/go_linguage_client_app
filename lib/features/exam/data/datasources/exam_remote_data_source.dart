import 'package:go_linguage/core/constants/api_constants.dart';
import 'package:go_linguage/core/network/dio_client.dart';
import 'package:go_linguage/features/exam/data/models/exam_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class IExamRemoteDataSource {
  Future<ExamResopnseModel> getExamData();
}

class ExamRemoteDataSourceImpl implements IExamRemoteDataSource {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  static String tokenKey = 'AUTH_TOKEN';
  ExamRemoteDataSourceImpl({
    required this.dioClient,
    required this.sharedPreferences,
  });

  @override
  Future<ExamResopnseModel> getExamData() async {
    try {
      String? token = await sharedPreferences.getString(tokenKey);
      final response = await dioClient.get<ExamResopnseModel>(
          url: ApiConstants.getExamData,
          resultFromJson: (json) => ExamResopnseModel.fromJson(json),
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
      throw Exception('Sign in failed: ${e.toString()}');
    }
  }
}
