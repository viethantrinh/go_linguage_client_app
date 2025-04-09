import 'package:go_linguage/core/constants/api_constants.dart';
import 'package:go_linguage/core/network/dio_client.dart';
import 'package:go_linguage/features/song/data/models/api_song_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class ISongDataSource {
  Future<List<SongResopnseModel>> getSongData();
}

class SongDataSourceImpl implements ISongDataSource {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  static String tokenKey = 'AUTH_TOKEN';

  SongDataSourceImpl({
    required this.dioClient,
    required this.sharedPreferences,
  });

  @override
  Future<List<SongResopnseModel>> getSongData() async {
    try {
      String? token = await sharedPreferences.getString(tokenKey);
      final response = await dioClient.get<List<SongResopnseModel>>(
          url: ApiConstants.getSongData,
          resultFromJson: (dynamic json) {
            // Xử lý trường hợp json là List
            if (json is List) {
              return List<SongResopnseModel>.from(
                  json.map((x) => SongResopnseModel.fromJson(x)));
            }
            // Xử lý trường hợp json là Map và có key 'result' chứa List
            else if (json is Map<String, dynamic> &&
                json.containsKey('result') &&
                json['result'] is List) {
              return List<SongResopnseModel>.from((json['result'] as List)
                  .map((x) => SongResopnseModel.fromJson(x)));
            }
            // Trường hợp không xác định, trả về danh sách rỗng
            print('Unexpected JSON format: ${json.runtimeType}');
            return <SongResopnseModel>[];
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
      print('Error in getSubjectData: ${e.toString()}');

      throw Exception('Sign in failed: ${e.toString()}');
    }
  }
}
