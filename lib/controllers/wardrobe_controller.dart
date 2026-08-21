import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/state_manager.dart';
import 'package:hdoom/models/item_model.dart';
import 'package:hdoom/models/wardrobe_options.dart';
import 'package:hdoom/services/api_service.dart';

class WardrobeController extends GetxController {
  final api = ApiService();

  RxMap<WardrobeCategory, RxList<String>> itemCategories = RxMap();
  Rxn<WardrobeOptionsModel> wardrobeOptions = Rxn();
  RxList<ItemModel> items = RxList();
  Rxn<ItemModel> currentItem = Rxn();

  RxBool isWardrobeOptionsLoading = RxBool(false);
  RxBool isWardrobeItemsLoading = RxBool(false);
  RxBool isWardrobeItemCreating = RxBool(false);

  // ── Polling internals ─────────────────────────────────────────────────

  Timer? _pollTimer;

  /// Polling intervals: first at 15s, then 10s, then every 5s.
  static const List<int> _pollIntervals = [25, 20, 15];
  int _pollStep = 0;

  @override
  void onClose() {
    _cancelPolling();
    super.onClose();
  }

  Future<String> getWardrobeOptions() async {
    isWardrobeOptionsLoading(true);
    try {
      final res = await api.get("/wardrobe/options/", authReq: true);
      final body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        final data = body['data'];
        wardrobeOptions.value = WardrobeOptionsModel.fromJson(data);

        for (var i in wardrobeOptions.value!.categories) {
          itemCategories[i] = RxList();
        }

        return "success";
      } else {
        return body['message'] ?? "Something went wrong";
      }
    } catch (e) {
      return e.toString();
    } finally {
      isWardrobeOptionsLoading(false);
    }
  }

  Future<String> getWardrobeItems() async {
    isWardrobeItemsLoading(true);
    try {
      final res = await api.get("/wardrobe-items-ai/items/", authReq: true);
      final body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        final data = body['data'];

        items.clear();
        for (var i in data) {
          items.add(ItemModel.fromJson(i));
        }

        return "success";
      } else {
        return body['message'] ?? "Something went wrong";
      }
    } catch (e) {
      return e.toString();
    } finally {
      isWardrobeItemsLoading(false);
    }
  }

  Future<String> createWardrobeItem(
    File image,
    int category,
    String season,
    String occasion,
    String source,
  ) async {
    isWardrobeItemCreating(true);
    try {
      Map<String, dynamic> payload = {
        "image": image,
        "category": category,
        "season": season,
        "occasion": occasion,
        "purchase_source": source,
      };

      final res = await api.post(
        "/wardrobe-items-ai/items/",
        payload,
        authReq: true,
      );
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = body['data'];

        final item = ItemModel.fromJson(data);
        items.add(item);
        currentItem.value = item;

        _startItemStatusPolling(item.id);

        return "success";
      } else {
        return body['message'] ?? "Something went wrong";
      }
    } catch (e) {
      return e.toString();
    } finally {
      isWardrobeItemCreating(false);
    }
  }

  Future<String> deleteWardrobeItem(int id) async {
    isWardrobeItemsLoading(true);
    // Temporary delete
    int idx = items.indexWhere((val) => val.id == id);
    late ItemModel item;
    if (idx != -1) {
      item = items[idx];
      items.removeAt(idx);
    }
    try {
      final res = await api.delete(
        "/wardrobe-items-ai/items/$id/",
        authReq: true,
      );
      final body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        return "success";
      } else {
        items.insert(idx, item);
        return body['message'] ?? "Something went wrong";
      }
    } catch (e) {
      items.insert(idx, item);
      return e.toString();
    } finally {
      isWardrobeItemsLoading(false);
    }
  }

  Future<String> getWardrobeItemById(int id) async {
    isWardrobeItemsLoading(true);
    try {
      final res = await api.get("/wardrobe-items-ai/items/$id/", authReq: true);
      final body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        final data = body['data'];
        final item = ItemModel.fromJson(data);

        int idx = items.indexWhere((val) => val.id == id);
        if (idx != -1) {
          items[idx];
        } else {
          items.add(item);
        }

        return "success";
      } else {
        return body['message'] ?? "Something went wrong";
      }
    } catch (e) {
      return e.toString();
    } finally {
      isWardrobeItemsLoading(false);
    }
  }

  Future<String> getWardrobeItemStatus(int id) async {
    isWardrobeItemsLoading(true);
    try {
      final res = await api.get(
        "/wardrobe-items-ai/$id/status/",
        authReq: true,
      );
      final body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        final data = body['data'];
        final analysis = ItemAnalysisModel.fromJson(data);

        int idx = items.indexWhere((val) => val.id == analysis.wardrobeItem);
        if (idx != -1) {
          items[idx].analysis = analysis;
        } else {
          return "item not found";
        }

        return "success";
      } else {
        return body['message'] ?? "Something went wrong";
      }
    } catch (e) {
      return e.toString();
    } finally {
      isWardrobeItemsLoading(false);
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
  void _startItemStatusPolling(int itemId) {
    _cancelPolling();
    _pollStep = 0;
    _scheduleNextPoll(() => _pollItemStatus(itemId));
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

  Future<void> _pollItemStatus(int itemId) async {
    final result = await getWardrobeItemStatus(itemId);

    if (result != "success") {
      debugPrint('❗ Item poll error: $result');
      // Continue polling even on network errors
      _pollStep++;
      if (_pollStep < 10) {
        _scheduleNextPoll(() => _pollItemStatus(itemId));
      }
      return;
    }

    final idx = items.indexWhere((a) => a.id == itemId);
    if (idx != -1) {
      _pollStep++;
      if (_pollStep < 10) {
        _scheduleNextPoll(() => _pollItemStatus(itemId));
      }
    } else {
      debugPrint('✅ Items polling complete: ${items[idx].analysis?.status}');
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
