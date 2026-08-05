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
      final res = await api.get("auth/profile/", authReq: true);
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
}
