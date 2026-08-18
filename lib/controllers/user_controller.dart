import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:hdoom/models/aesthetic_model.dart';
import 'package:hdoom/models/user_model.dart';
import 'package:hdoom/services/api_service.dart';
import 'package:hdoom/services/shared_prefs_service.dart';

class UserController extends GetxController {
  final api = ApiService();

  final Rxn<UserModel> _userData = Rxn();
  final RxList<AestheticModel> aesthetics = RxList.empty();
  final RxBool isLoading = RxBool(false);
  final RxBool isUpdatingInfo = RxBool(false);
  final RxBool isAestheticLoading = RxBool(false);

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
      } else if (data['id'] != null || data['email'] != null) {
        setUser = data as Map<String, dynamic>;
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
      final body = _decodeBody(res.body);

      if (res.statusCode == 200) {
        await _handleAuthSuccess(body);
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

  Future<String> getAdditionalProfileInfo() async {
    isLoading(true);
    try {
      final response = await api.get("/auth/profile/complete/", authReq: true);
      final body = _decodeBody(response.body);

      if (response.statusCode == 200) {
        final data = (body is Map && body['data'] is Map)
            ? body['data'] as Map<String, dynamic>
            : (body is Map
                  ? body as Map<String, dynamic>
                  : <String, dynamic>{});

        _userData.value = UserModel.fromAdditionalJson(data, baseUser: user);
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

  Future<String> updateAdditionalProfileInfo({
    required String name,
    int? age,
    String? gender,
    int? height,
    String? bodyType,
    String? country,
    List<int>? selectedAesthetic,
    File? image,
  }) async {
    isUpdatingInfo(true);
    try {
      final payload = <String, dynamic>{
        "name": name,
        "age": ?age,
        if (gender != null && gender.isNotEmpty) "gender": gender,
        "height": ?height,
        if (bodyType != null && bodyType.isNotEmpty) "body_type": bodyType,
        if (country != null && country.isNotEmpty) "country": country,
        "aesthetics": selectedAesthetic ?? user!.aesthetics,
        "profile_image": ?image,
      };

      final response = await api.patch(
        "/auth/profile/complete/",
        payload,
        authReq: true,
      );
      final body = _decodeBody(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = (body is Map && body['data'] is Map)
            ? body['data'] as Map<String, dynamic>
            : (body is Map
                  ? body as Map<String, dynamic>
                  : <String, dynamic>{});

        _userData.value = UserModel.fromAdditionalJson(data, baseUser: user);
        return "success";
      } else {
        return _parseError(body);
      }
    } catch (e) {
      return e.toString();
    } finally {
      isUpdatingInfo(false);
    }
  }

  Future<String> getAesthetics() async {
    isAestheticLoading(true);
    try {
      final response = await api.get("/auth/aesthetics/", authReq: true);
      final body = _decodeBody(response.body);

      if (response.statusCode == 200) {
        final data = (body is Map && body['data'] is List)
            ? body['data'] as List
            : (body is List ? body : []);

        aesthetics.clear();
        for (var i in data) {
          if (i is Map<String, dynamic>) {
            aesthetics.add(AestheticModel.fromJson(i));
          } else if (i is Map) {
            aesthetics.add(
              AestheticModel.fromJson(Map<String, dynamic>.from(i)),
            );
          }
        }

        return "success";
      } else {
        return _parseError(body);
      }
    } catch (e) {
      return e.toString();
    } finally {
      isAestheticLoading(false);
    }
  }
}
