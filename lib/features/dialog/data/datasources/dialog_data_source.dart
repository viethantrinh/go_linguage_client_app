import 'dart:io';

import 'package:dio/dio.dart';
import 'package:go_linguage/core/constants/api_constants.dart';
import 'package:go_linguage/core/network/dio_client.dart';
import 'package:go_linguage/features/dialog/data/models/api_dialog_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class IDialogRemoteDataSource {
  Future<List<DialogListResopnseModel>> getDialogData(int conversationId);
  Future<String?> sendToServer(String ogaPath, String conversationLineId);
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
  Future<List<DialogListResopnseModel>> getDialogData(
      int conversationId) async {
    try {
      String? token = await sharedPreferences.getString(tokenKey);
      final response = await dioClient.get<List<DialogListResopnseModel>>(
          url: ApiConstants.getDialogData(conversationId),
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
      print('Error in getDialogData: ${e.toString()}');

      throw Exception('Get dialog data failed: ${e.toString()}');
    }
  }

  @override
  Future<String?> sendToServer(
      String ogaPath, String conversationLineId) async {
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
          contentType: DioMediaType('audio', 'ogg'),
        ),
        "conversationLineId": conversationLineId,
      });

      // Tạo options cho request với token
      final options = Options(
        headers: {
          'Content-Type': 'multipart/form-data',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      String? rs;
      final response = await dioClient.post<dynamic>(
          url: ApiConstants.checkPronoun,
          jsonBody: formData, // Truyền formData thay vì JSON thông thường
          resultFromJson: (dynamic json) {
            return json;
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

class MediaType {}
