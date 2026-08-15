import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hdoom/models/avatar_model.dart';
import 'package:hdoom/models/three_d_conversion_model.dart';
import 'package:hdoom/services/api_service.dart';

class AiImageController extends GetxController {
  final api = ApiService();

  // ── Observable state ──────────────────────────────────────────────────

  final RxBool isLoading = RxBool(false);
  final RxList<AvatarModel> avatars = RxList.empty();
  final Rxn<AvatarModel> defaultAvatar = Rxn<AvatarModel>();
  final RxnInt currentAvatarId = RxnInt();
  final Rxn<ThreeDConversionModel> currentConversion =
      Rxn<ThreeDConversionModel>();

  // ── Polling internals ─────────────────────────────────────────────────

  Timer? _pollTimer;

  /// Polling intervals: first at 15s, then 10s, then every 5s.
  static const List<int> _pollIntervals = [15, 10, 5];
  int _pollStep = 0;

  int getAvatarIndex(int id) {
    return avatars.indexWhere((a) => a.id == id);
  }

  @override
  void onClose() {
    _cancelPolling();
    super.onClose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────

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

  // ═══════════════════════════════════════════════════════════════════════
  // AVATARS API
  // ═══════════════════════════════════════════════════════════════════════

  /// POST /avatars/ — create a new avatar from [sourcePhoto] with [style].
  /// Automatically starts polling for status once creation succeeds.
  Future<String> createAvatar({
    File? sourcePhoto,
    String style = 'cartoon',
  }) async {
    isLoading(true);
    try {
      Map<String, dynamic> data = {'style': style};
      if (sourcePhoto != null) {
        data['source_photo'] = sourcePhoto;
      }
      final res = await api.post('/avatars/', data, authReq: true);
      final body = _decodeBody(res.body);

      if (res.statusCode == 201 || res.statusCode == 200) {
        final newAvatar = AvatarModel.fromJson(body['data']);
        avatars.add(newAvatar);
        currentAvatarId.value = newAvatar.id;
        _startAvatarStatusPolling(currentAvatarId.value!);
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

  /// GET /avatars/{id}/status/ — check the status of an avatar.
  Future<String> getAvatarStatus(int id) async {
    try {
      final res = await api.get('/avatars/$id/status/', authReq: true);
      final body = _decodeBody(res.body);

      if (res.statusCode == 200) {
        final avatar = AvatarModel.fromJson(body['data']);

        // Update in the avatars list if present
        final idx = avatars.indexWhere((a) => a.id == id);
        if (idx != -1) {
          avatars[idx] = avatar;
        } else {
          avatars.add(avatar);
        }

        return "success";
      } else {
        return _parseError(body);
      }
    } catch (e) {
      return e.toString();
    }
  }

  /// GET /avatars/default/ — fetch the user's default avatar.
  Future<String> getDefaultAvatar() async {
    isLoading(true);
    try {
      final res = await api.get('/avatars/default/', authReq: true);
      final body = _decodeBody(res.body);

      if (res.statusCode == 200) {
        defaultAvatar.value = AvatarModel.fromJson(body['data']);
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

  /// GET /avatars/mine/ — fetch all avatars belonging to the current user.
  Future<String> getMyAvatars() async {
    isLoading(true);
    try {
      final res = await api.get('/avatars/mine/', authReq: true);
      final body = _decodeBody(res.body);

      if (res.statusCode == 200) {
        final data = body['data'];
        avatars.clear();
        for (var item in data) {
          try {
            avatars.add(AvatarModel.fromJson(item));
          } catch (e) {
            debugPrint('❗ Error parsing avatar: $e');
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

  // ═══════════════════════════════════════════════════════════════════════
  // MODEL 3D API
  // ═══════════════════════════════════════════════════════════════════════

  /// POST /model3d/convert/ — convert a completed OutfitJob into a 3D model.
  /// Automatically starts polling for conversion status once request succeeds.
  Future<String> convert3D({required int outfitJobId}) async {
    isLoading(true);
    try {
      final res = await api.post('/model3d/convert/', {
        'outfit_job_id': outfitJobId,
      }, authReq: true);
      final body = _decodeBody(res.body);

      if (res.statusCode == 201 || res.statusCode == 200) {
        final conversion = ThreeDConversionModel.fromJson(body);
        currentConversion.value = conversion;

        // Start polling for conversion status
        _startConversionStatusPolling(conversion.id);
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

  /// GET /model3d/conversions/{id}/ — check the status of a 3D conversion.
  Future<String> get3DConversion(int id) async {
    try {
      final res = await api.get('/model3d/conversions/$id/', authReq: true);
      final body = _decodeBody(res.body);

      if (res.statusCode == 200) {
        currentConversion.value = ThreeDConversionModel.fromJson(body);
        return "success";
      } else {
        return _parseError(body);
      }
    } catch (e) {
      return e.toString();
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // PROGRESSIVE STATUS POLLING
  // ═══════════════════════════════════════════════════════════════════════
  //
  // Polling schedule:
  //   1st poll  → 15 seconds after creation
  //   2nd poll  → 10 seconds after the 1st
  //   3rd+ poll → every 5 seconds until done/failed
  //
  // Polling stops automatically when:
  //   • The status is "done" or "failed"
  //   • The controller is disposed
  //   • [cancelPolling] is called manually
  // ═══════════════════════════════════════════════════════════════════════

  /// Start polling avatar status with progressive intervals.
  void _startAvatarStatusPolling(int avatarId) {
    _cancelPolling();
    _pollStep = 0;
    _scheduleNextPoll(() => _pollAvatarStatus(avatarId));
  }

  /// Start polling 3D conversion status with progressive intervals.
  void _startConversionStatusPolling(int conversionId) {
    _cancelPolling();
    _pollStep = 0;
    _scheduleNextPoll(() => _pollConversionStatus(conversionId));
  }

  void _scheduleNextPoll(Future<void> Function() pollFn) {
    final int delay = _pollStep < _pollIntervals.length
        ? _pollIntervals[_pollStep]
        : _pollIntervals.last;

    debugPrint('⏱️ Next poll in ${delay}s (step $_pollStep)');

    _pollTimer = Timer(Duration(seconds: delay), () async {
      await pollFn();
    });
  }

  Future<void> _pollAvatarStatus(int avatarId) async {
    final result = await getAvatarStatus(avatarId);

    if (result != "success") {
      debugPrint('❗ Avatar poll error: $result');
      // Continue polling even on network errors
      _pollStep++;
      if (_pollStep < 10) {
        _scheduleNextPoll(() => _pollAvatarStatus(avatarId));
      }
      return;
    }

    final avatar = avatars.firstWhereOrNull((a) => a.id == avatarId);
    if (avatar == null || avatar.isProcessing) {
      _pollStep++;
      if (_pollStep < 10) {
        _scheduleNextPoll(() => _pollAvatarStatus(avatarId));
      }
    } else {
      debugPrint('✅ Avatar polling complete: ${avatar.status}');
      _cancelPolling();
    }
  }

  Future<void> _pollConversionStatus(int conversionId) async {
    final result = await get3DConversion(conversionId);

    if (result != "success") {
      debugPrint('❗ 3D conversion poll error: $result');
      _pollStep++;
      _scheduleNextPoll(() => _pollConversionStatus(conversionId));
      return;
    }

    final conversion = currentConversion.value;
    if (conversion == null || conversion.isProcessing) {
      _pollStep++;
      _scheduleNextPoll(() => _pollConversionStatus(conversionId));
    } else {
      debugPrint('✅ 3D conversion polling complete: ${conversion.status}');
      _cancelPolling();
    }
  }

  /// Cancel any active status polling.
  void cancelPolling() => _cancelPolling();

  void _cancelPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
    _pollStep = 0;
  }
}
