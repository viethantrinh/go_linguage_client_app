class ApiResponseModel<T> {
  final int code;
  final String message;
  final String timestamp;
  final T? result;
  final ErrorResponse? errorResponse;

  ApiResponseModel({
    required this.code,
    required this.message,
    required this.timestamp,
    this.result,
    this.errorResponse,
  });

  factory ApiResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) resultFromJson,
  ) {
    return ApiResponseModel<T>(
      code: json['code'],
      message: json['message'],
      timestamp: json['timestamp'],
      result: json['result'] != null ? resultFromJson(json['result']) : null,
      errorResponse:
          json['errorResponse'] != null
              ? ErrorResponse.fromJson(json['errorResponse'])
              : null,
    );
  }

  bool get isSuccess => code >= 1000 && code < 5000;
}

class ErrorResponse {
  final String apiPath;
  final List<String> errors;

  ErrorResponse({required this.apiPath, required this.errors});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      apiPath: json['apiPath'] ?? '',
      errors: List<String>.from(json['errors'] ?? []),
    );
  }
}
