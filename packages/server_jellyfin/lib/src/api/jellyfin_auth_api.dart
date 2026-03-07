import 'package:dio/dio.dart';
import 'package:server_core/server_core.dart';

class JellyfinAuthApi implements AuthApi {
  final Dio _dio;

  JellyfinAuthApi(this._dio);

  @override
  Future<Map<String, dynamic>> authenticateByName(
    String username,
    String password,
  ) async {
    final response = await _dio.post(
      '/Users/AuthenticateByName',
      data: {'Username': username, 'Pw': password},
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> authenticateWithQuickConnect(
    String secret,
  ) async {
    final response = await _dio.post(
      '/Users/AuthenticateWithQuickConnect',
      data: {'Secret': secret},
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<void> logout() async {
    await _dio.post('/Sessions/Logout');
  }
}
