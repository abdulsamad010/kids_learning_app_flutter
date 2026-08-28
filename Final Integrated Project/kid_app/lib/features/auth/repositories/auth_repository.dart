import 'package:kid_app/core/network/api_client.dart';
import 'package:kid_app/core/constants/api_constants.dart';
import 'package:kid_app/features/auth/models/user_model.dart';

class AuthRepository {
  final ApiClient _api = ApiClient.instance;

  Map<String, dynamic> _extractData(Map<String, dynamic> json) {
    if (json['data'] is Map<String, dynamic>) {
      return json['data'] as Map<String, dynamic>;
    }
    return json;
  }

  String? _extractToken(Map<String, dynamic> json) {
    final data = _extractData(json);
    return data['token'] as String?;
  }

  Map<String, dynamic>? _extractUser(Map<String, dynamic> json) {
    final data = _extractData(json);
    if (data['user'] is Map<String, dynamic>) {
      return data['user'] as Map<String, dynamic>;
    }
    if (data.containsKey('id') && data.containsKey('email')) {
      return data;
    }
    return null;
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final json = await _api.post(
      ApiConstants.register,
      body: {'name': name, 'email': email, 'password': password},
    );

    final token = _extractToken(json);
    if (token != null && token.isNotEmpty) {
      await _api.setToken(token);
    }

    final userJson = _extractUser(json);
    if (userJson != null) {
      return UserModel.fromJson(userJson);
    }

    throw ApiException(
      statusCode: 200,
      message: 'Registration succeeded, but the server response was invalid.',
    );
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final json = await _api.post(
      ApiConstants.login,
      body: {'email': email, 'password': password},
    );

    final token = _extractToken(json);
    if (token != null && token.isNotEmpty) {
      await _api.setToken(token);
    }

    final userJson = _extractUser(json);
    if (userJson != null) {
      return UserModel.fromJson(userJson);
    }

    throw ApiException(
      statusCode: 200,
      message: 'Login succeeded, but the server response was invalid.',
    );
  }

  Future<void> logout() async {
    try {
      await _api.post(ApiConstants.logout);
    } finally {
      await _api.clearToken();
    }
  }

  Future<void> forgotPassword({required String email}) async {
    await _api.post(
      ApiConstants.forgotPassword,
      body: {'email': email},
    );
  }

  Future<void> resetPassword({
    required String token,
    required String password,
  }) async {
    await _api.post(
      ApiConstants.resetPassword,
      body: {'token': token, 'password': password},
    );
  }

  bool isLoggedIn() {
    return _api.isLoggedIn;
  }
}
