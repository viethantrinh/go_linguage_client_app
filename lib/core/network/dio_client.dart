import 'package:dio/dio.dart';
import 'package:go_linguage/core/constants/api_constants.dart';
import 'package:go_linguage/core/model/api_response.dart';

class DioClient {
  final Dio _dio;
  static final String authorizationHeader = 'Authorization';

  DioClient() : _dio = Dio() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = Duration(seconds: 30);
    _dio.options.receiveTimeout = Duration(seconds: 30);
  }

  Future<ApiResponseModel<T>> get<T>({
    required String url,
    required T Function(Map<String, dynamic>) resultFromJson,
    Map<String, dynamic>? queryParams,
    Options? options,
    String? token,
  }) async {
    try {
      if (token != null) {
        _dio.options.headers[authorizationHeader] = 'Bearer $token';
      }
      
      final response = await _dio.get(
        url,
        queryParameters: queryParams,
        options: options,
      );

      return ApiResponseModel<T>.fromJson(response.data, resultFromJson);
    } on DioException catch (e) {
      if (e.response != null) {
        return ApiResponseModel<T>.fromJson(e.response!.data, resultFromJson);
      }
      rethrow;
    }
  }

  Future<ApiResponseModel<T>> post<T>({
    required String url,
    required T Function(Map<String, dynamic>) resultFromJson,
    required dynamic jsonBody,
    Map<String, dynamic>? queryParams,
    Options? options,
    String? token,
  }) async {
    try {
      if (token != null) {
        _dio.options.headers[authorizationHeader] = 'Bearer $token';
      }

      final response = await _dio.post(
        url,
        data: jsonBody,
        queryParameters: queryParams,
        options: options,
      );
      return ApiResponseModel<T>.fromJson(response.data, resultFromJson);
    } on DioException catch (e) {
      if (e.response != null) {
        return ApiResponseModel<T>.fromJson(e.response!.data, resultFromJson);
      }
      rethrow;
    }
  }
}
