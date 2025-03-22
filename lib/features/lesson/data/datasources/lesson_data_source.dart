import 'dart:convert';
import 'dart:io';
import 'package:go_linguage/core/constants/api_constants.dart';
import 'package:go_linguage/core/network/dio_client.dart';
import 'package:go_linguage/features/subject/data/models/api_subject_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LessonDataSourceImpl {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  static String tokenKey = 'AUTH_TOKEN';
  static String lastFetchTimeKey = 'LAST_SUBJECT_FETCH_TIME';
  static String subjectCacheFilename = 'subject_data.json';
  static const int cacheExpirationHours = 24; // Thời gian cache hết hạn (giờ)

  LessonDataSourceImpl({
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

  // Đọc dữ liệu từ file cache
  Future<List<LessonModel>?> _readDataFromCache(int id) async {
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
      print('jsonString: $jsonString');
      final jsonData = jsonDecode(jsonString) as List<dynamic>;

      // Chuyển đổi JSON thành danh sách LessonModel
      return jsonData.map((item) => LessonModel.fromJson(item)).toList();
    } catch (e) {
      print('Lỗi khi đọc cache: $e');
      return null;
    }
  }

  Future<LessonModel> getLessonData(int id) async {
    try {
      // Thử đọc dữ liệu từ cache trước
      final cachedData = await _readDataFromCache(id);
      if (cachedData != null) {
        print('Sử dụng dữ liệu từ cache (${cachedData.length} bài học)');
        print('cachedData: $cachedData');
        return cachedData.where((element) => element.id == id).first;
      }
    } catch (e) {}
    throw Exception('Get subject data failed');
  }
}
