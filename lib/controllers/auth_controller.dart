import 'dart:convert';

import 'package:get/get.dart';
import 'package:hdoom/controllers/user_controller.dart';
import 'package:hdoom/services/api_service.dart';
import 'package:hdoom/services/shared_prefs_service.dart';

class AuthController extends GetxController {
  final api = ApiService();
  final userController = Get.find<UserController>();
  final RxBool isLoading = RxBool(false);

  String? currentResetToken;

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
        userController.setUser = data['user'] as Map<String, dynamic>;
      } else if (body['user'] != null && body['user'] is Map) {
        userController.setUser = body['user'] as Map<String, dynamic>;
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

  // 1. Signup
  Future<String> signup(String name, String email, String password) async {
    isLoading(true);
    try {
      final data = {"name": name, "email": email, "password": password};
      final res = await api.post("auth/signup/", data);
      final body = _decodeBody(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
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

  // 2. Login
  Future<String> login(String email, String password) async {
    isLoading(true);
    try {
      final data = {"email": email, "password": password};
      final res = await api.post("auth/login/", data);
      final body = _decodeBody(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
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

  // 3. Logout
  Future<String> logout() async {
    isLoading(true);
    try {
      final token = await SharedPrefsService.get('refresh_token');
      final res = await api.post("auth/logout/", {
        "refresh": token,
      }, authReq: true);
      await SharedPrefsService.remove('token');
      await SharedPrefsService.remove('refresh_token');
      userController.clearUser();

      if (res.statusCode == 200 || res.statusCode == 204) {
        return "success";
      } else {
        return _parseError(_decodeBody(res.body));
      }
    } catch (e) {
      // Ensure session is cleared locally even if network fails during logout
      await SharedPrefsService.remove('token');
      await SharedPrefsService.remove('refresh_token');
      userController.clearUser();
      return e.toString();
    } finally {
      isLoading(false);
    }
  }

  // 4. Verify Email
  Future<String> verifyEmail(String email, String otp) async {
    isLoading(true);
    try {
      final data = {"email": email, "otp": otp};
      final res = await api.post("auth/verify-email/", data);
      final body = _decodeBody(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
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

  // 5. Resend OTP
  Future<String> resendOtp(
    String email, {
    String purpose = 'email_verification',
  }) async {
    isLoading(true);
    try {
      final data = {"email": email, "purpose": purpose};
      final res = await api.post("auth/resend-otp/", data);
      final body = _decodeBody(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
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

  // 6. Forgot Password
  Future<String> forgotPassword(String email) async {
    isLoading(true);
    try {
      final data = {"email": email};
      final res = await api.post("auth/forgot-password/", data);
      final body = _decodeBody(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
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

  // 7. Verify Reset OTP
  Future<String> verifyResetOtp(String email, String otp) async {
    isLoading(true);
    try {
      final data = {"email": email, "otp": otp};
      final res = await api.post("auth/verify-reset-otp/", data);
      final body = _decodeBody(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        if (body is Map) {
          final dataMap = (body['data'] is Map) ? body['data'] as Map : body;
          if (dataMap['reset_token'] != null) {
            currentResetToken = dataMap['reset_token'].toString();
          } else if (body['reset_token'] != null) {
            currentResetToken = body['reset_token'].toString();
          }
        }
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

  // 8. Reset Password
  Future<String> resetPassword(
    String newPassword,
    String confirmPassword, {
    String? resetToken,
  }) async {
    isLoading(true);
    try {
      final token = resetToken ?? currentResetToken;
      if (token == null || token.isEmpty) {
        return "Missing password reset token. Please verify OTP first.";
      }
      final data = {
        "reset_token": token,
        "new_password": newPassword,
        "new_password_confirm": confirmPassword,
      };
      final res = await api.post("auth/reset-password/", data);
      final body = _decodeBody(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        currentResetToken = null;
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

  // 9. Refresh Token
  Future<String> refreshToken({String? token}) async {
    isLoading(true);
    try {
      final storedRefresh =
          token ?? await SharedPrefsService.get('refresh_token');
      if (storedRefresh == null || storedRefresh.isEmpty) {
        return "No refresh token available.";
      }
      final data = {"refresh": storedRefresh};
      final res = await api.post("auth/token/refresh/", data);
      final body = _decodeBody(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
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

  // 10. Delete Account
  Future<String> deleteAccount(String password) async {
    isLoading(true);
    try {
      final data = {"password": password};
      final res = await api.post("auth/delete-account/", data, authReq: true);
      final body = _decodeBody(res.body);

      if (res.statusCode == 200 ||
          res.statusCode == 204 ||
          res.statusCode == 201) {
        await SharedPrefsService.remove('token');
        await SharedPrefsService.remove('refresh_token');
        userController.clearUser();
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
