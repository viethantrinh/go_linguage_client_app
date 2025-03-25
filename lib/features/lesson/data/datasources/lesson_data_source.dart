import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:go_linguage/core/constants/api_constants.dart';
import 'package:go_linguage/core/network/dio_client.dart';
import 'package:go_linguage/features/lesson/presentation/pages/pronoun_assessment.dart';
import 'package:go_linguage/features/subject/data/models/api_subject_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

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

  Future<AssessmentModel?> sendToServer(String ogaPath, String text) async {
    try {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? token = await sharedPreferences.getString('AUTH_TOKEN');

      // Tạo file từ đường dẫn
      final File audioFile = File(ogaPath);

      // Kiểm tra file có tồn tại không
      if (!await audioFile.exists()) {
        print("File không tồn tại: $ogaPath");
        throw Exception('Audio file not found');
      }

      // Lưu file vào thư mục Download
      try {
        // Lấy đường dẫn thư mục Download
        Directory? downloadDir;
        if (Platform.isAndroid) {
          downloadDir = Directory('/storage/emulated/0/Download');
          // Tạo thư mục nếu không tồn tại
          if (!await downloadDir.exists()) {
            downloadDir = await getExternalStorageDirectory();
          }
        } else {
          // Trên iOS hoặc các nền tảng khác, sử dụng thư mục Tài liệu
          downloadDir = await getApplicationDocumentsDirectory();
        }

        if (downloadDir != null) {
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final downloadPath =
              '${downloadDir.path}/pronunciation_$timestamp.ogg';

          // Copy file từ thư mục tạm sang Download
          await audioFile.copy(downloadPath);
          print("Đã lưu bản sao vào: $downloadPath");
        }
      } catch (e) {
        // Ghi log nhưng không làm gián đoạn quy trình nếu không lưu được
        print("Không thể lưu file vào Downloads: $e");
      }

      // Tạo FormData object để gửi file
      final formData = FormData.fromMap({
        // Tạo MultipartFile từ file
        "audio": await MultipartFile.fromFile(
          ogaPath,
          filename: 'audio.ogg',
          contentType: MediaType('audio', 'ogg'),
        ),
        "text": text,
      });

      // Tạo options cho request với token
      final options = Options(
        headers: {
          'Content-Type': 'multipart/form-data',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      AssessmentModel? rs;
      final response = await dioClient.post<dynamic>(
          url: ApiConstants.pronunciationAssessment,
          jsonBody: formData, // Truyền formData thay vì JSON thông thường
          resultFromJson: (dynamic json) {
            return AssessmentModel.fromJson(json);
            //print('json: $json');
          },
          options: options, // Sử dụng options đã tạo
          token: token);

      print('response: $response');
      rs = response.result;
      return rs;
    } catch (e) {
      print("Error in sending to server: $e");
      throw Exception('Send to server failed');
    }
  }
}
