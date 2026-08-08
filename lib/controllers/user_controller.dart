import 'dart:convert';

import 'package:get/get.dart';
import 'package:hdoom/models/user_model.dart';
import 'package:hdoom/services/api_service.dart';
import 'package:hdoom/services/shared_prefs_service.dart';

class UserController extends GetxController {
  final api = ApiService();

  final Rxn<UserModel> _userData = Rxn();
  final RxBool isLoading = RxBool(false);

  UserModel? get user => _userData.value;
  set setUser(Map<String, dynamic> data) {
    _userData.value = UserModel.fromJson(data);
  }

  void clearUser() => _userData.value = null;

  dynamic _decodeBody(String body) {
    if (body.trim().isEmpty) return {};
    try {
      return jsonDecode(body);
    } catch (_) {
      return {"message": body};
    }
  }

  String _parseError(dynamic body) {
    if (body is Map) {
      if (body['message'] != null) return body['message'].toString();
      if (body['detail'] != null) return body['detail'].toString();
      if (body['error'] != null) return body['error'].toString();
      for (var entry in body.entries) {
        if (entry.value is List && (entry.value as List).isNotEmpty) {
          return "${entry.key}: ${(entry.value as List).first}";
        } else if (entry.value != null &&
            entry.value is! Map &&
            entry.value is! List) {
          return "${entry.key}: ${entry.value}";
        }
      }
    }
    return "Something went wrong";
  }

  Future<void> _handleAuthSuccess(dynamic body) async {
    if (body is Map) {
      final data = (body['data'] is Map) ? body['data'] as Map : body;

      // Extract user
      if (data['user'] != null && data['user'] is Map) {
        setUser = data['user'] as Map<String, dynamic>;
      } else if (body['user'] != null && body['user'] is Map) {
        setUser = body['user'] as Map<String, dynamic>;
      }

      // Extract tokens
      final accessToken =
          data['access'] ?? data['token'] ?? data['access_token'];
      final refreshToken = data['refresh'] ?? data['refresh_token'];
      if (accessToken != null && accessToken.toString().isNotEmpty) {
        await api.setToken(accessToken.toString());
      }
      if (refreshToken != null && refreshToken.toString().isNotEmpty) {
        await SharedPrefsService.set('refresh_token', refreshToken.toString());
      }
    }
  }

  Future<String> getUserInfo() async {
    isLoading(true);
    try {
      final res = await api.get("/auth/profile/", authReq: true);
      final body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        _handleAuthSuccess(body);
        return "success";
      } else {
        return "Something went wrong";
      }
    } catch (e) {
      return e.toString();
    } finally {
      isLoading(true);
    }
  }

  Future<String> changePassword(
    String oldPassword,
    String newPassword,
    String newPasswordConfirmation,
  ) async {
    isLoading(true);
    try {
      final data = {
        "old_password": oldPassword,
        "new_password": newPassword,
        "new_password_confirm": newPasswordConfirmation,
      };
      final res = await api.post("/auth/change-password/", data, authReq: true);
      final body = _decodeBody(res.body);

      if (res.statusCode == 200) {
        return "success";
      } else {
        return _parseError(body);
      }
    } catch (e) {
      return e.toString();
    } finally {
      isLoading(false);
    }
  }
}
