import 'dart:convert';
import 'dart:io';
import 'package:go_linguage/core/common/global/global_variable.dart';
import 'package:go_linguage/core/constants/api_constants.dart';
import 'package:go_linguage/core/network/dio_client.dart';
import 'package:go_linguage/features/subject/data/models/api_subject_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class ISubjectRemoteDataSource {
  Future<List<LessonModel>> getSubjectData(int topicId);
}

class SubjectRemoteDataSourceImpl implements ISubjectRemoteDataSource {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  static String tokenKey = 'AUTH_TOKEN';
  static String lastFetchTimeKey = 'LAST_SUBJECT_FETCH_TIME';
  static String subjectCacheFilename = 'subject_data.json';
  static const int cacheExpirationHours = 24; // Thời gian cache hết hạn (giờ)

  SubjectRemoteDataSourceImpl({
    required this.dioClient,
    required this.sharedPreferences,
  });

  // Lấy đường dẫn đến file cache
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$subjectCacheFilename');
  }

  // Lưu dữ liệu vào file cache
  Future<void> _saveDataToCache(List<LessonModel> data) async {
    try {
      final file = await _localFile;
      // Chuyển đổi danh sách LessonModel thành List<Map>
      final jsonData = data.map((lesson) => lesson.toJson()).toList();
      // Lưu vào file
      await file.writeAsString(jsonEncode(jsonData));
      // Lưu thời gian lấy dữ liệu
      await sharedPreferences.setInt(
          lastFetchTimeKey, DateTime.now().millisecondsSinceEpoch);
      print('Đã lưu dữ liệu vào cache: ${file.path}');
    } catch (e) {
      print('Lỗi khi lưu cache: $e');
    }
  }

  // Đọc dữ liệu từ file cache
  Future<List<LessonModel>?> _readDataFromCache() async {
    try {
      final file = await _localFile;
      // Kiểm tra file tồn tại
      if (!await file.exists()) {
        print('File cache không tồn tại');
        return null;
      }

      // Kiểm tra cache đã hết hạn chưa
      final lastFetchTime = sharedPreferences.getInt(lastFetchTimeKey) ?? 0;
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final diffHours = (currentTime - lastFetchTime) / (1000 * 60 * 60);

      if (diffHours > cacheExpirationHours) {
        print('Cache đã hết hạn ($diffHours giờ)');
        return null;
      }

      // Đọc và parse dữ liệu
      final jsonString = await file.readAsString();
      final jsonData = jsonDecode(jsonString) as List<dynamic>;

      // Chuyển đổi JSON thành danh sách LessonModel
      return jsonData.map((item) => LessonModel.fromJson(item)).toList();
    } catch (e) {
      print('Lỗi khi đọc cache: $e');
      return null;
    }
  }

  @override
  Future<List<LessonModel>> getSubjectData(int topicId) async {
    try {
      // Thử đọc dữ liệu từ cache trước
      // final cachedData = await _readDataFromCache();
      // if (cachedData != null) {
      //   print('Sử dụng dữ liệu từ cache (${cachedData.length} bài học)');

      //   return cachedData;
      // }

      // Nếu không có cache hoặc cache hết hạn, gọi API
      print('Gọi API để lấy dữ liệu mới');
      String? token = await sharedPreferences.getString(tokenKey);
      final response = await dioClient.get<List<LessonModel>>(
          url: ApiConstants.getLessonData(topicId),
          resultFromJson: (dynamic json) {
            // Xử lý trường hợp json là List
            if (json is List) {
              return List<LessonModel>.from(
                  json.map((x) => LessonModel.fromJson(x)));
            }
            // Xử lý trường hợp json là Map và có key 'result' chứa List
            else if (json is Map<String, dynamic> &&
                json.containsKey('result') &&
                json['result'] is List) {
              return List<LessonModel>.from(
                  (json['result'] as List).map((x) => LessonModel.fromJson(x)));
            }
            // Trường hợp không xác định, trả về danh sách rỗng
            print('Unexpected JSON format: ${json.runtimeType}');
            return <LessonModel>[];
          },
          token: token);

      if (response.isSuccess && response.result != null) {
        // Lưu kết quả vào cache
        await _saveDataToCache(response.result!);
        for (var item in response.result!) {
          scoreData.value[item.id] = item.totalUserXpPoints;
          lessonMapTopic[item.id] = topicId;
        }
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

      // Nếu gặp lỗi khi gọi API, thử đọc từ cache một lần nữa (ngay cả khi cache đã hết hạn)
      try {
        final file = await _localFile;
        if (await file.exists()) {
          final jsonString = await file.readAsString();
          final jsonData = jsonDecode(jsonString) as List<dynamic>;
          final cachedData =
              jsonData.map((item) => LessonModel.fromJson(item)).toList();
          print(
              'Sử dụng dữ liệu từ cache do lỗi API (${cachedData.length} bài học)');
          return cachedData;
        }
      } catch (cacheError) {
        print('Lỗi khi đọc cache: $cacheError');
      }

      throw Exception('Sign in failed: ${e.toString()}');
    }
  }
}
