import 'package:go_linguage/core/constants/api_constants.dart';
import 'package:go_linguage/core/network/dio_client.dart';
import 'package:go_linguage/features/home/data/models/home_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class IHomeRemoteDataSource {
  Future<HomeResponseModel> getHomeData();
}

class HomeRemoteDataSourceImpl implements IHomeRemoteDataSource {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  static String tokenKey = 'AUTH_TOKEN';
  HomeRemoteDataSourceImpl({
    required this.dioClient,
    required this.sharedPreferences,
  });

  @override
  Future<HomeResponseModel> getHomeData() async {
    try {
      String? token = await sharedPreferences.getString(tokenKey);
      final response = await dioClient.get<HomeResponseModel>(
          url: ApiConstants.getHomeData,
          resultFromJson: (json) => HomeResponseModel.fromJson(json),
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
