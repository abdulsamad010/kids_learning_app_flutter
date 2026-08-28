import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kid_app/core/constants/api_constants.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient {
  ApiClient._();
  static final ApiClient _instance = ApiClient._();
  static ApiClient get instance => _instance;

  String? _token;
  String? get token => _token;
  bool get isLoggedIn => _token != null && _token!.isNotEmpty;

  static const String _tokenKey = 'auth_token';

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
  }

  Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Map<String, String> _buildHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  Uri _buildUri(String path) {
    if (path.startsWith('http')) {
      return Uri.parse(path);
    }
    return Uri.parse('${ApiConstants.apiBaseUrl}$path');
  }

  Exception _parseError(http.Response response) {
    String message = 'An unexpected error occurred';
    try {
      final body = jsonDecode(response.body);
      if (body is Map<String, dynamic>) {
        message = body['message'] ?? body['error'] ?? body['msg'] ?? message;
        if (body['errors'] is List && (body['errors'] as List).isNotEmpty) {
          final firstError = (body['errors'] as List).first;
          if (firstError is Map<String, dynamic>) {
            message = firstError['message'] ?? firstError['msg'] ?? message;
          } else {
            message = firstError.toString();
          }
        }
      }
    } catch (_) {
      message = response.body.isNotEmpty ? response.body : message;
    }
    return ApiException(statusCode: response.statusCode, message: message);
  }

  Future<http.Response> _sendRequest(
    String method,
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    http.Response response;
    switch (method) {
      case 'GET':
        response = await http.get(uri, headers: headers ?? _buildHeaders());
        break;
      case 'POST':
        response = await http.post(uri, headers: headers ?? _buildHeaders(), body: body);
        break;
      case 'PUT':
        response = await http.put(uri, headers: headers ?? _buildHeaders(), body: body);
        break;
      case 'DELETE':
        response = await http.delete(uri, headers: headers ?? _buildHeaders());
        break;
      default:
        throw ApiException(statusCode: 0, message: 'Unsupported HTTP method: $method');
    }
    return response;
  }

  Future<Map<String, dynamic>> _handleRequest(
    String method,
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final uri = _buildUri(path);
    try {
      final response = await _sendRequest(
        method,
        uri,
        body: body != null ? jsonEncode(body) : null,
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 401) {
        if (_token != null) {
          await clearToken();
          throw ApiException(
            statusCode: 401,
            message: 'Session expired. Please log in again.',
          );
        }
        throw _parseError(response);
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) return {};
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) return decoded;
        return {'data': decoded};
      }

      throw _parseError(response);
    } on SocketException {
      throw ApiException(
        statusCode: 0,
        message:
            'Cannot connect to server. Please check if the backend is running at ${ApiConstants.apiBaseUrl}',
      );
    } on TimeoutException {
      throw ApiException(
        statusCode: 0,
        message:
            'Connection timed out. Server at ${ApiConstants.apiBaseUrl} may be unreachable.',
      );
    } on FormatException {
      throw ApiException(
        statusCode: 0,
        message: 'Invalid response from server.',
      );
    }
  }

  Future<Map<String, dynamic>> get(String path) async {
    return _handleRequest('GET', path);
  }

  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? body}) async {
    return _handleRequest('POST', path, body: body);
  }

  Future<Map<String, dynamic>> put(String path, {Map<String, dynamic>? body}) async {
    return _handleRequest('PUT', path, body: body);
  }

  Future<Map<String, dynamic>> delete(String path) async {
    return _handleRequest('DELETE', path);
  }
}
