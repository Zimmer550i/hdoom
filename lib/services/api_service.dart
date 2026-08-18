import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hdoom/controllers/user_controller.dart';
import 'package:hdoom/services/shared_prefs_service.dart';
import 'package:hdoom/utils/custom_snackbar.dart';
import 'package:hdoom/views/screens/auth/authentication.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String devUrl = "http://10.10.29.50:8086/api/v1";
  final String prodUrl = "";
  static final String imgUrl = "";
  final bool inDevelopment = true;
  final bool showAPICalls = true;

  late final String baseUrl;
  int callCount = 0;

  static Future<bool>? _refreshFuture;

  ApiService() {
    baseUrl = inDevelopment ? devUrl : prodUrl;
  }

  void _logResponse(http.Response response, String method, Uri uri) {
    callCount++;
    debugPrint('🆔 $callCount');
    debugPrint('📥 [$method] Response from ${uri.toString()}');
    debugPrint('✅ Status Code: ${response.statusCode}');
    debugPrint('📦 Body: ${response.body}');
  }

  Future<Map<String, String>> _getHeaders(bool authReq) async {
    Map<String, String> headers = {'Content-Type': 'application/json'};
    if (authReq) {
      final token = await SharedPrefsService.get('token');
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  /// Refreshes the access token using the stored refresh token.
  /// Deduplicates concurrent refresh requests using a shared Future.
  Future<bool> refreshToken() async {
    if (_refreshFuture != null) {
      return _refreshFuture!;
    }

    _refreshFuture = _performTokenRefresh();
    try {
      final result = await _refreshFuture!;
      return result;
    } finally {
      _refreshFuture = null;
    }
  }

  Future<bool> _performTokenRefresh() async {
    try {
      final refreshToken = await SharedPrefsService.get('refresh_token');
      if (refreshToken == null || refreshToken.isEmpty) {
        debugPrint('❗ Refresh token is missing');
        return false;
      }

      final uri = Uri.parse('$baseUrl/auth/token/refresh/');
      final headers = {'Content-Type': 'application/json'};
      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode({'refresh': refreshToken}),
      );

      if (showAPICalls) _logResponse(response, 'POST', uri);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);
        final data = (body is Map && body['data'] is Map)
            ? body['data'] as Map
            : (body is Map ? body : {});

        final newAccessToken =
            data['access'] ?? data['token'] ?? data['access_token'];
        final newRefreshToken = data['refresh'] ?? data['refresh_token'];

        if (newAccessToken != null && newAccessToken.toString().isNotEmpty) {
          await setToken(newAccessToken.toString());
        }
        if (newRefreshToken != null && newRefreshToken.toString().isNotEmpty) {
          await SharedPrefsService.set(
            'refresh_token',
            newRefreshToken.toString(),
          );
        }
        debugPrint('🔑 Token refreshed successfully');
        return true;
      } else {
        debugPrint('❗ Token refresh failed with status ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('❗ Token refresh error: $e');
      return false;
    }
  }

  void _handleSessionExpired() async {
    await SharedPrefsService.remove('token');
    await SharedPrefsService.remove('refresh_token');
    if (Get.isRegistered<UserController>()) {
      Get.find<UserController>().clearUser();
    }
    customSnackBar("Session expired! Please login again...");
    Get.offAll(() => Authentication());
  }

  // Create
  Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> data, {
    bool authReq = false,
    bool isRetry = false,
  }) async {
    try {
      final headers = await _getHeaders(authReq);
      final uri = Uri.parse('$baseUrl$endpoint');

      http.Response response;

      bool hasFile = data.values.any(
        (value) =>
            value is File ||
            (value is List && value.any((item) => item is File)),
      );

      if (hasFile) {
        var request = http.MultipartRequest('POST', uri);
        request.headers.addAll(headers);

        for (var entry in data.entries) {
          final key = entry.key;
          final value = entry.value;

          if (value == null) continue;

          if (value is File) {
            request.files.add(
              await http.MultipartFile.fromPath(key, value.path),
            );
          } else if (value is List) {
            bool hasListFiles = false;
            for (var item in value) {
              if (item is File) {
                hasListFiles = true;
                request.files.add(
                  await http.MultipartFile.fromPath(key, item.path),
                );
              }
            }
            if (!hasListFiles) {
              request.fields[key] = jsonEncode(value);
            }
          } else if (value is Map) {
            request.fields[key] = jsonEncode(value);
          } else {
            request.fields[key] = value.toString();
          }
        }

        var streamedResponse = await request.send();
        response = await http.Response.fromStream(streamedResponse);
      } else {
        response = await http.post(
          uri,
          headers: headers,
          body: jsonEncode(data),
        );
      }

      if (showAPICalls) _logResponse(response, 'POST', uri);

      if (response.statusCode == 401 &&
          authReq &&
          !isRetry &&
          !endpoint.contains('token/refresh')) {
        final refreshed = await refreshToken();
        if (refreshed) {
          return post(
            endpoint,
            data,
            authReq: authReq,
            isRetry: true,
          );
        } else {
          _handleSessionExpired();
        }
      }

      return response;
    } catch (e) {
      debugPrint('❗ POST Error: $e');
      throw Exception('Something went wrong. Please try again.');
    }
  }

  // Read
  Future<http.Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    bool authReq = false,
    bool isRetry = false,
  }) async {
    try {
      final headers = await _getHeaders(authReq);
      final uri = Uri.parse(
        '$baseUrl$endpoint',
      ).replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: headers);

      if (showAPICalls) _logResponse(response, 'GET', uri);

      if (response.statusCode == 401 &&
          authReq &&
          !isRetry &&
          !endpoint.contains('token/refresh')) {
        final refreshed = await refreshToken();
        if (refreshed) {
          return get(
            endpoint,
            queryParams: queryParams,
            authReq: authReq,
            isRetry: true,
          );
        } else {
          _handleSessionExpired();
        }
      }

      return response;
    } catch (e) {
      debugPrint('❗ GET Error: $e');
      throw Exception('Something went wrong. Please try again.');
    }
  }

  // Patch (Update)
  Future<http.Response> patch(
    String endpoint,
    Map<String, dynamic> data, {
    bool authReq = false,
    bool isRetry = false,
  }) async {
    try {
      final headers = await _getHeaders(authReq);
      final uri = Uri.parse('$baseUrl$endpoint');

      http.Response response;

      bool hasFile = data.values.any(
        (value) =>
            value is File ||
            (value is List && value.any((item) => item is File)),
      );

      if (hasFile) {
        var request = http.MultipartRequest('PATCH', uri);
        request.headers.addAll(headers);

        for (var entry in data.entries) {
          final key = entry.key;
          final value = entry.value;

          if (value == null) continue;

          if (value is File) {
            request.files.add(
              await http.MultipartFile.fromPath(key, value.path),
            );
          } else if (value is List) {
            bool hasListFiles = false;
            for (var item in value) {
              if (item is File) {
                hasListFiles = true;
                request.files.add(
                  await http.MultipartFile.fromPath(key, item.path),
                );
              }
            }
            if (!hasListFiles) {
              request.fields[key] = jsonEncode(value);
            }
          } else if (value is Map) {
            request.fields[key] = jsonEncode(value);
          } else {
            request.fields[key] = value.toString();
          }
        }

        var streamedResponse = await request.send();
        response = await http.Response.fromStream(streamedResponse);
      } else {
        response = await http.patch(
          uri,
          headers: headers,
          body: jsonEncode(data),
        );
      }

      if (showAPICalls) _logResponse(response, 'PATCH', uri);

      if (response.statusCode == 401 &&
          authReq &&
          !isRetry &&
          !endpoint.contains('token/refresh')) {
        final refreshed = await refreshToken();
        if (refreshed) {
          return patch(
            endpoint,
            data,
            authReq: authReq,
            isRetry: true,
          );
        } else {
          _handleSessionExpired();
        }
      }

      return response;
    } catch (e) {
      debugPrint('❗ PATCH Error: $e');
      throw Exception('Something went wrong. Please try again.');
    }
  }

  // Delete
  Future<http.Response> delete(
    String endpoint, {
    bool authReq = false,
    bool isRetry = false,
  }) async {
    try {
      final headers = await _getHeaders(authReq);
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http.delete(uri, headers: headers);

      if (showAPICalls) _logResponse(response, 'DELETE', uri);

      if (response.statusCode == 401 &&
          authReq &&
          !isRetry &&
          !endpoint.contains('token/refresh')) {
        final refreshed = await refreshToken();
        if (refreshed) {
          return delete(
            endpoint,
            authReq: authReq,
            isRetry: true,
          );
        } else {
          _handleSessionExpired();
        }
      }

      return response;
    } catch (e) {
      debugPrint('❗ DELETE Error: $e');
      throw Exception('Something went wrong. Please try again.');
    }
  }

  static String? getImgUrl(String? img) {
    if (img == "" || img == null) {
      return null;
    } else {
      return imgUrl + img;
    }
  }

  Future<void> setToken(String token) async {
    await SharedPrefsService.set('token', token);
    debugPrint('💾 Token Saved: $token');
  }
}
