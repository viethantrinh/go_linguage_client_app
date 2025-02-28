import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AuthLocalDataSource {
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  static String tokenKey = 'AUTH_TOKEN';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheToken(String token) async {
    await sharedPreferences.setString(tokenKey, token);
  }

  @override
  Future<void> clearToken() async {
    await sharedPreferences.remove(tokenKey);
  }

  @override
  Future<String?> getToken() async {
     return sharedPreferences.getString(tokenKey);
  }
}
