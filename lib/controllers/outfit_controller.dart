import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hdoom/models/outfit_job_model.dart';
import 'package:hdoom/models/outfit_rating_detail_model.dart';
import 'package:hdoom/models/outfit_rating_model.dart';
import 'package:hdoom/models/saved_outfit_model.dart';
import 'package:hdoom/services/api_service.dart';

class OutfitController extends GetxController {
  final api = ApiService();

  // ── Observables ──────────────────────────────────────────────────────────

  final RxBool isLoading = RxBool(false);
  final RxBool isTodayLoading = RxBool(false);
  final RxBool isSavedLoading = RxBool(false);
  final RxBool isTryOnLoading = RxBool(false);
  final RxBool isRatingLoading = RxBool(false);
  final RxBool isPublicLoading = RxBool(false);
  final RxBool isOutfitOfTheDayLoading = RxBool(false);

  final Rxn<OutfitJobModel> todayOutfit = Rxn<OutfitJobModel>();
  final RxList<SavedOutfitModel> savedOutfits = RxList.empty();
  final RxList<SavedOutfitModel> publicOutfits = RxList.empty();
  final RxList<OutfitJobModel> tryOnJobs = RxList.empty();
  final Rxn<OutfitJobModel> currentTryOnJob = Rxn<OutfitJobModel>();
  final Rxn<OutfitRatingModel> currentOutfitRating = Rxn<OutfitRatingModel>();
  final RxList<OutfitRatingDetailModel> outfitRatings = RxList.empty();
  final RxList<OutfitJobModel> outfitsOfTheDay = RxList.empty();
  final Rx<DateTime> outfitsOfTheDayDate = Rx(DateTime.now());

  // ── Polling internals ────────────────────────────────────────────────────

  Timer? _todayOutfitPollTimer;
  static const List<int> _todayOutfitPollIntervals = [15, 10, 5];
  int _todayOutfitPollStep = 0;

  Timer? _tryOnPollTimer;
  static const List<int> _pollIntervals = [15, 10, 5];
  int _pollStep = 0;

  @override
  void onClose() {
    _cancelTryOnPolling();
    _cancelTodayOutfitPolling();
    super.onClose();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

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

  // ══════════════════════════════════════════════════════════════════════════
  // TODAY'S OUTFIT API
  // ══════════════════════════════════════════════════════════════════════════

  /// GET /outfits/today/
  /// Retrieves today's auto outfit recommendation.
  /// If the outfit is still processing, polling will continue automatically.
  Future<String> getTodayOutfit({bool forceRefresh = false}) async {
    if (todayOutfit.value != null && !forceRefresh) {
      return "success";
    }

    if (isTodayLoading.value) {
      return "success";
    }

    isTodayLoading(true);

    try {
      final res = await api.get('/outfits/today/', authReq: true);

      final body = _decodeBody(res.body);

      if (res.statusCode == 200) {
        final data = (body is Map && body['data'] is Map)
            ? body['data'] as Map<String, dynamic>
            : (body is Map
                  ? body as Map<String, dynamic>
                  : <String, dynamic>{});

        todayOutfit.value = OutfitJobModel.fromJson(data);

        final status = data['status'] as String? ?? '';

        // Stop polling when processing is finished.
        if (status == 'completed' || status == 'done' || status == 'failed') {
          _cancelTodayOutfitPolling();
        } else {
          // Still processing, continue polling.
          _startTodayOutfitPolling();
        }

        return "success";
      }

      _cancelTodayOutfitPolling();
      return _parseError(body);
    } catch (e) {
      debugPrint('❗ Error fetching today outfit: $e');
      return e.toString();
    } finally {
      isTodayLoading(false);
    }
  }

  /// DELETE /outfits/today/reset/ — Reset today's auto outfit recommendation (debug).
  Future<String> resetTodayOutfit() async {
    isTodayLoading(true);
    try {
      final res = await api.delete('/outfits/today/reset/', authReq: true);
      final body = _decodeBody(res.body);

      if (res.statusCode == 200 || res.statusCode == 204) {
        todayOutfit.value = null;
        return "success";
      } else {
        return _parseError(body);
      }
    } catch (e) {
      return e.toString();
    } finally {
      isTodayLoading(false);
    }
  }

  // ── Today's Outfit Status Polling ────────────────────────────────────────

  void _startTodayOutfitPolling() {
    _cancelTodayOutfitPolling();

    _todayOutfitPollStep = 0;

    _scheduleTodayOutfitPoll();
  }

  void _scheduleTodayOutfitPoll() {
    final int delaySec = _todayOutfitPollStep < _todayOutfitPollIntervals.length
        ? _todayOutfitPollIntervals[_todayOutfitPollStep]
        : _todayOutfitPollIntervals.last;

    debugPrint('⏳ Next today outfit poll in $delaySec seconds');

    _todayOutfitPollTimer = Timer(Duration(seconds: delaySec), () async {
      final result = await getTodayOutfit(forceRefresh: true);

      if (result != 'success' || todayOutfit.value == null) {
        _cancelTodayOutfitPolling();
        return;
      }

      final status = todayOutfit.value?.status ?? '';

      debugPrint('🔄 Today outfit polling status: $status');

      if (status == 'completed' || status == 'done' || status == 'failed') {
        _cancelTodayOutfitPolling();
      } else {
        _todayOutfitPollStep++;

        _scheduleTodayOutfitPoll();
      }
    });
  }

  void _cancelTodayOutfitPolling() {
    _todayOutfitPollTimer?.cancel();
    _todayOutfitPollTimer = null;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SAVED OUTFITS API
  // ══════════════════════════════════════════════════════════════════════════

  /// /api/v1/outfits/1-months/
  Future<String> getOutfitsOfTheDay() async {
    isOutfitOfTheDayLoading(true);
    try {
      final res = await api.get(
        '/outfits/1-months/',
        queryParams: {
          "month": outfitsOfTheDayDate.value.month.toString(),
          "year": outfitsOfTheDayDate.value.year.toString(),
        },
        authReq: true,
      );
      final body = _decodeBody(res.body);

      if (res.statusCode == 200) {
        final data = body['data'];

        outfitsOfTheDay.clear();
        for (var i in data) {
          outfitsOfTheDay.add(OutfitJobModel.fromJson(i));
        }

        return "success";
      } else {
        return _parseError(body);
      }
    } catch (e) {
      return e.toString();
    } finally {
      isOutfitOfTheDayLoading(false);
    }
  }

  Future<String> setOutfitsOfTheDay(int outfitId) async {
    isSavedLoading(true);
    try {
      final res = await api.post('/outfits/daily-selection/', {
        "date":
            "${outfitsOfTheDayDate.value.year}-${outfitsOfTheDayDate.value.month}-${outfitsOfTheDayDate.value.day}",
        "outfit_id": outfitId,
      }, authReq: true);
      final body = _decodeBody(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        return "success";
      } else {
        return _parseError(body);
      }
    } catch (e) {
      return e.toString();
    } finally {
      isSavedLoading(false);
    }
  }

  Future<String> getSavedOutfits() async {
    isSavedLoading(true);
    try {
      final res = await api.get('/outfits/saved/', authReq: true);
      final body = _decodeBody(res.body);

      if (res.statusCode == 200) {
        final data = (body is Map && body['data'] is List)
            ? body['data'] as List
            : (body is List ? body : []);

        savedOutfits.clear();
        for (var item in data) {
          if (item is Map<String, dynamic>) {
            savedOutfits.add(SavedOutfitModel.fromJson(item));
          } else if (item is Map) {
            savedOutfits.add(
              SavedOutfitModel.fromJson(Map<String, dynamic>.from(item)),
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
      isSavedLoading(false);
    }
  }

  /// POST /outfits/saved/ — Save an outfit for a given date.
  Future<String> saveOutfit({
    required int outfitJobId,
    required String savedDate,
    String note = '',
    bool isShared = false,
  }) async {
    isSavedLoading(true);
    try {
      final payload = {
        'outfit_job_id': outfitJobId,
        'saved_date': savedDate,
        'note': note,
        'is_shared': isShared,
      };
      final res = await api.post('/outfits/saved/', payload, authReq: true);
      final body = _decodeBody(res.body);

      if (res.statusCode == 201 || res.statusCode == 200) {
        final data = (body is Map && body['data'] is Map)
            ? body['data'] as Map<String, dynamic>
            : (body is Map
                  ? body as Map<String, dynamic>
                  : <String, dynamic>{});

        final created = SavedOutfitModel.fromJson(data);
        savedOutfits.insert(0, created);
        return "success";
      } else {
        return _parseError(body);
      }
    } catch (e) {
      return e.toString();
    } finally {
      isSavedLoading(false);
    }
  }

  /// GET /outfits/saved/{id}/ — Retrieve single saved outfit details.
  Future<SavedOutfitModel?> getSavedOutfitDetail(int id) async {
    try {
      final res = await api.get('/outfits/saved/$id/', authReq: true);
      final body = _decodeBody(res.body);

      if (res.statusCode == 200) {
        final data = (body is Map && body['data'] is Map)
            ? body['data'] as Map<String, dynamic>
            : (body is Map
                  ? body as Map<String, dynamic>
                  : <String, dynamic>{});
        return SavedOutfitModel.fromJson(data);
      }
    } catch (e) {
      debugPrint('❗ Error fetching saved outfit $id: $e');
    }
    return null;
  }

  /// PATCH /outfits/saved/{id}/ — Update saved outfit metadata.
  Future<String> updateSavedOutfit(
    int id, {
    String? savedDate,
    int? outfitJobId,
    String? note,
    bool? isShared,
  }) async {
    isSavedLoading(true);
    try {
      final payload = <String, dynamic>{
        "saved_date": ?savedDate,
        "outfit_job_id": ?outfitJobId,
        "note": ?note,
        "is_shared": ?isShared,
      };

      final res = await api.patch(
        '/outfits/saved/$id/',
        payload,
        authReq: true,
      );
      final body = _decodeBody(res.body);

      if (res.statusCode == 200) {
        final data = (body is Map && body['data'] is Map)
            ? body['data'] as Map<String, dynamic>
            : (body is Map
                  ? body as Map<String, dynamic>
                  : <String, dynamic>{});

        final updated = SavedOutfitModel.fromJson(data);
        final index = savedOutfits.indexWhere((o) => o.id == id);
        if (index >= 0) {
          savedOutfits[index] = updated;
        }
        return "success";
      } else {
        return _parseError(body);
      }
    } catch (e) {
      return e.toString();
    } finally {
      isSavedLoading(false);
    }
  }

  /// DELETE /outfits/saved/{id}/ — Delete a saved outfit.
  Future<String> deleteSavedOutfit(int id) async {
    isSavedLoading(true);
    try {
      final res = await api.delete('/outfits/saved/$id/', authReq: true);

      if (res.statusCode == 204 || res.statusCode == 200) {
        savedOutfits.removeWhere((o) => o.id == id);
        return "success";
      } else {
        final body = _decodeBody(res.body);
        return _parseError(body);
      }
    } catch (e) {
      return e.toString();
    } finally {
      isSavedLoading(false);
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PUBLIC SAVED OUTFITS API
  // ══════════════════════════════════════════════════════════════════════════

  /// GET /outfits/public/{username}/ — List shared public outfits for user.
  Future<String> getPublicSavedOutfits(
    String username, {
    int page = 1,
    int pageSize = 20,
  }) async {
    isPublicLoading(true);
    try {
      final queryParams = {
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };
      final res = await api.get(
        '/outfits/public/$username/',
        queryParams: queryParams,
        authReq: true,
      );
      final body = _decodeBody(res.body);

      if (res.statusCode == 200) {
        final results = body['data']['results'];

        if (page == 1) publicOutfits.clear();

        for (var item in results) {
          if (item is Map<String, dynamic>) {
            publicOutfits.add(SavedOutfitModel.fromJson(item));
          } else if (item is Map) {
            publicOutfits.add(
              SavedOutfitModel.fromJson(Map<String, dynamic>.from(item)),
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
      isPublicLoading(false);
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // RATINGS API
  // ══════════════════════════════════════════════════════════════════════════

  /// POST /outfits/saved/{id}/rate/ — Rate a saved outfit.
  Future<String> rateOutfit(
    int savedOutfitId, {
    required int colorHarmony,
    required int trendy,
    required int overallMatching,
    required int accessories,
  }) async {
    isRatingLoading(true);
    try {
      final payload = {
        'color_harmony': colorHarmony,
        'trendy': trendy,
        'overall_matching': overallMatching,
        'accessories': accessories,
      };
      final res = await api.post(
        '/outfits/saved/$savedOutfitId/rate/',
        payload,
        authReq: true,
      );
      final body = _decodeBody(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = (body is Map && body['data'] is Map)
            ? body['data'] as Map<String, dynamic>
            : (body is Map
                  ? body as Map<String, dynamic>
                  : <String, dynamic>{});
        currentOutfitRating.value = OutfitRatingModel.fromJson(data);
        return "success";
      } else {
        return _parseError(body);
      }
    } catch (e) {
      return e.toString();
    } finally {
      isRatingLoading(false);
    }
  }

  /// DELETE /outfits/saved/{id}/rate/ — Delete rating on a saved outfit.
  Future<String> deleteOutfitRating(int savedOutfitId) async {
    isRatingLoading(true);
    try {
      final res = await api.delete(
        '/outfits/saved/$savedOutfitId/rate/',
        authReq: true,
      );

      if (res.statusCode == 200 || res.statusCode == 204) {
        return "success";
      } else {
        final body = _decodeBody(res.body);
        return _parseError(body);
      }
    } catch (e) {
      return e.toString();
    } finally {
      isRatingLoading(false);
    }
  }

  /// GET /outfits/saved/{id}/ratings/ — Retrieve rating list (owner only).
  Future<String> getOutfitRatings(
    int savedOutfitId, {
    int page = 1,
    int pageSize = 20,
  }) async {
    isRatingLoading(true);
    try {
      final queryParams = {
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };
      final res = await api.get(
        '/outfits/saved/$savedOutfitId/ratings/',
        queryParams: queryParams,
        authReq: true,
      );
      final body = _decodeBody(res.body);

      if (res.statusCode == 200) {
        final results = (body is Map && body['results'] is List)
            ? body['results'] as List
            : ((body is Map && body['data'] is List)
                  ? body['data'] as List
                  : (body is List ? body : []));

        if (page == 1) outfitRatings.clear();

        for (var item in results) {
          if (item is Map<String, dynamic>) {
            outfitRatings.add(OutfitRatingDetailModel.fromJson(item));
          } else if (item is Map) {
            outfitRatings.add(
              OutfitRatingDetailModel.fromJson(Map<String, dynamic>.from(item)),
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
      isRatingLoading(false);
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TRY-ON API
  // ══════════════════════════════════════════════════════════════════════════

  /// GET /outfits/try-on/ — List all try-on jobs.
  Future<String> getTryOnJobs() async {
    isTryOnLoading(true);
    try {
      final res = await api.get('/outfits/try-on/', authReq: true);
      final body = _decodeBody(res.body);

      if (res.statusCode == 200) {
        final data = (body is Map && body['data'] is List)
            ? body['data'] as List
            : (body is List ? body : []);

        tryOnJobs.clear();
        for (var item in data) {
          if (item is Map<String, dynamic>) {
            tryOnJobs.add(OutfitJobModel.fromJson(item));
          } else if (item is Map) {
            tryOnJobs.add(
              OutfitJobModel.fromJson(Map<String, dynamic>.from(item)),
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
      isTryOnLoading(false);
    }
  }

  /// POST /outfits/try-on/ — Create a new try-on job and start status polling.
  Future<String> createTryOn({
    required int avatarId,
    required List<int> wardrobeItemIds,
  }) async {
    isTryOnLoading(true);
    try {
      final payload = {
        'avatar_id': avatarId,
        'wardrobe_item_ids': wardrobeItemIds,
      };
      final res = await api.post('/outfits/try-on/', payload, authReq: true);
      final body = _decodeBody(res.body);

      if (res.statusCode == 201 || res.statusCode == 200) {
        final data = (body is Map && body['data'] is Map)
            ? body['data'] as Map<String, dynamic>
            : (body is Map
                  ? body as Map<String, dynamic>
                  : <String, dynamic>{});

        // TryOnCreate returns { avatar_id, wardrobe_item_ids } or OutfitJob
        final int? jobId = data['id'] ?? data['outfit_job_id'];
        if (jobId != null) {
          currentTryOnJob.value = OutfitJobModel.fromJson(data);
          tryOnJobs.insert(0, currentTryOnJob.value!);
          _startTryOnPolling(jobId);
        }
        return "success";
      } else {
        return _parseError(body);
      }
    } catch (e) {
      return e.toString();
    } finally {
      isTryOnLoading(false);
    }
  }

  /// POST /outfits/try-on/id/save — Save try-on job as outfit.
  Future<String> saveTryOn() async {
    isTryOnLoading(true);
    try {
      final res = await api.post(
        '/outfits/try-on/${currentTryOnJob.value?.id}/save/',
        {},
        authReq: true,
      );
      final body = _decodeBody(res.body);

      if (res.statusCode == 201 || res.statusCode == 200) {
        final data = body['data'];
        final outfit = SavedOutfitModel.fromJson(data);

        savedOutfits.add(outfit);

        return "success";
      } else {
        return _parseError(body);
      }
    } catch (e) {
      return e.toString();
    } finally {
      isTryOnLoading(false);
    }
  }

  /// GET /outfits/try-on/{id}/status/ — Check try-on job status (DB only).
  Future<String> checkTryOnStatus(int id) async {
    try {
      final res = await api.get('/outfits/try-on/$id/status/', authReq: true);
      final body = _decodeBody(res.body);

      if (res.statusCode == 200) {
        final data = (body is Map && body['data'] is Map)
            ? body['data'] as Map<String, dynamic>
            : (body is Map
                  ? body as Map<String, dynamic>
                  : <String, dynamic>{});

        final status = data['status'] as String? ?? '';
        final resultImage = data['result_image'] as String?;
        final errorMessage = data['error_message'] as String?;

        if (currentTryOnJob.value != null && currentTryOnJob.value!.id == id) {
          final prev = currentTryOnJob.value!;
          currentTryOnJob.value = null;
          currentTryOnJob.value = prev.copyWith(
            status: status,
            resultImage: resultImage,
            errorMessage: errorMessage,
          );
        }

        final index = tryOnJobs.indexWhere((j) => j.id == id);
        if (index >= 0) {
          tryOnJobs[index] = tryOnJobs[index].copyWith(
            status: status,
            resultImage: resultImage,
            errorMessage: errorMessage,
          );
        }

        return status;
      }
      return "failed";
    } catch (e) {
      debugPrint('❗ Error checking try-on status $id: $e');
      return "error";
    }
  }

  // ── Try-On Status Polling ────────────────────────────────────────────────

  void _startTryOnPolling(int jobId) {
    _cancelTryOnPolling();
    _pollStep = 0;
    _scheduleTryOnPoll(jobId);
  }

  void _scheduleTryOnPoll(int jobId) {
    final int delaySec = _pollStep < _pollIntervals.length
        ? _pollIntervals[_pollStep]
        : _pollIntervals.last;

    _tryOnPollTimer = Timer(Duration(seconds: delaySec), () async {
      final status = await checkTryOnStatus(jobId);
      if (status == 'completed' || status == 'done' || status == 'failed') {
        _cancelTryOnPolling();
      } else {
        _pollStep++;
        _scheduleTryOnPoll(jobId);
      }
    });
  }

  void _cancelTryOnPolling() {
    _tryOnPollTimer?.cancel();
    _tryOnPollTimer = null;
  }
}
