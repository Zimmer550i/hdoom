import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:hdoom/models/feed_model.dart';
import 'package:hdoom/services/api_service.dart';

class FeedController extends GetxController {
  final api = ApiService();

  // ── Observables ──────────────────────────────────────────────────────────

  final RxBool isLoading = RxBool(false);
  final RxBool isMoreLoading = RxBool(false);
  final RxBool isUserPostsLoading = RxBool(false);
  final RxBool isDetailLoading = RxBool(false);
  final RxBool isCreateLoading = RxBool(false);
  final RxBool isUpdateLoading = RxBool(false);
  final RxBool isDeleteLoading = RxBool(false);
  final RxBool isRatingLoading = RxBool(false);

  final RxList<FeedModel> userFeeds = RxList.empty();
  final Rxn<FeedModel> currentPost = Rxn<FeedModel>();
  final Rxn<FeedPostRatingModel> lastRatingResult = Rxn<FeedPostRatingModel>();

  final RxInt totalCount = RxInt(0);
  final RxInt currentPage = RxInt(1);
  final RxBool hasMore = RxBool(true);

  final RxInt userPostsTotalCount = RxInt(0);

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

  List _extractPaginatedResults(dynamic body) {
    if (body is Map && body['data'] is Map && body['data']['results'] is List) {
      return body['data']['results'] as List;
    }
    if (body is Map && body['results'] is List) {
      return body['results'] as List;
    }
    if (body is Map && body['data'] is List) {
      return body['data'] as List;
    }
    if (body is List) return body;
    return [];
  }

  int _extractPaginatedCount(dynamic body) {
    if (body is Map && body['data'] is Map && body['data']['count'] is int) {
      return body['data']['count'] as int;
    }
    if (body is Map && body['count'] is int) {
      return body['count'] as int;
    }
    return 0;
  }

  Map<String, dynamic> _extractObject(dynamic body) {
    if (body is Map && body['data'] is Map) {
      return body['data'] as Map<String, dynamic>;
    }
    if (body is Map) return body as Map<String, dynamic>;
    return <String, dynamic>{};
  }

  List<FeedModel> _parseFeedList(List rawList) {
    final List<FeedModel> list = [];
    for (var item in rawList) {
      if (item is Map<String, dynamic>) {
        list.add(FeedModel.fromJson(item));
      } else if (item is Map) {
        list.add(FeedModel.fromJson(Map<String, dynamic>.from(item)));
      }
    }
    return list;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // FEED POSTS API (LIST & PAGINATION)
  // ══════════════════════════════════════════════════════════════════════════

  /// GET /feed/posts/ — Retrieve paginated feed posts.
  ///
  /// Can optionally filter by [username] or page number [page].

  /// GET /feed/posts/?username={username} — Retrieve user-specific feed posts.
  Future<String> getUserPosts(
    String username, {
    int page = 1,
    int pageSize = 20,
    bool refresh = false,
  }) async {
    isUserPostsLoading(true);
    try {
      final queryParams = <String, String>{
        'username': username,
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };

      final res = await api.get(
        '/feed/posts/',
        queryParams: queryParams,
        authReq: true,
      );
      final body = _decodeBody(res.body);

      if (res.statusCode == 200) {
        final results = _extractPaginatedResults(body);
        userPostsTotalCount.value = _extractPaginatedCount(body);

        final parsed = _parseFeedList(results);
        if (page == 1 || refresh) {
          userFeeds.clear();
        }
        userFeeds.addAll(parsed);
        return "success";
      } else {
        return _parseError(body);
      }
    } catch (e) {
      return e.toString();
    } finally {
      isUserPostsLoading(false);
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SINGLE POST & CRUD OPERATIONS
  // ══════════════════════════════════════════════════════════════════════════

  /// GET /feed/posts/{id}/ — Retrieve a single post by ID.
  Future<String> getPostDetails(int id) async {
    isDetailLoading(true);
    try {
      final res = await api.get('/feed/posts/$id/', authReq: true);
      final body = _decodeBody(res.body);

      if (res.statusCode == 200) {
        final data = _extractObject(body);
        currentPost.value = FeedModel.fromJson(data);
        return "success";
      } else {
        return _parseError(body);
      }
    } catch (e) {
      return e.toString();
    } finally {
      isDetailLoading(false);
    }
  }

  /// POST /feed/posts/ — Create a new feed post.
  ///
  /// Supports [caption], [privacy] ('public' | 'private'), and a list of [images] (`List<File>`).
  Future<String> createPost({
    required String caption,
    String privacy = 'public',
    required List<File> images,
  }) async {
    isCreateLoading(true);
    try {
      final data = <String, dynamic>{
        'caption': caption,
        'privacy': privacy,
        'uploaded_images': images,
      };

      final res = await api.post('/feed/posts/', data, authReq: true);
      final body = _decodeBody(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        final newPost = FeedModel.fromJson(_extractObject(body));
        userFeeds.insert(0, newPost);
        totalCount.value += 1;
        return "success";
      } else {
        return _parseError(body);
      }
    } catch (e) {
      return e.toString();
    } finally {
      isCreateLoading(false);
    }
  }

  /// PATCH /feed/posts/{id}/ — Update an existing post.
  Future<String> updatePost(
    int id, {
    String? caption,
    String? privacy,
    List<File>? images,
  }) async {
    isUpdateLoading(true);
    try {
      final data = <String, dynamic>{};
      if (caption != null) data['caption'] = caption;
      if (privacy != null) data['privacy'] = privacy;
      if (images != null && images.isNotEmpty) {
        data['uploaded_images'] = images;
      }

      final res = await api.patch('/feed/posts/$id/', data, authReq: true);
      final body = _decodeBody(res.body);

      if (res.statusCode == 200) {
        final updatedPost = FeedModel.fromJson(_extractObject(body));

        // Update in userFeeds list if present
        final idx = userFeeds.indexWhere((p) => p.id == id);
        if (idx >= 0) userFeeds[idx] = updatedPost;

        // Update in userFeeds list if present
        final userIdx = userFeeds.indexWhere((p) => p.id == id);
        if (userIdx >= 0) userFeeds[userIdx] = updatedPost;

        if (currentPost.value?.id == id) {
          currentPost.value = updatedPost;
        }

        return "success";
      } else {
        return _parseError(body);
      }
    } catch (e) {
      return e.toString();
    } finally {
      isUpdateLoading(false);
    }
  }

  /// DELETE /feed/posts/{id}/ — Delete a post by ID.
  Future<String> deletePost(int id) async {
    int index = userFeeds.indexWhere((p) => p.id == id);
    FeedModel deletedFeed = userFeeds.elementAt(index);
    userFeeds.removeAt(index);
    isDeleteLoading(true);
    try {
      final res = await api.delete('/feed/posts/$id/', authReq: true);
      final body = _decodeBody(res.body);

      if (res.statusCode == 200 || res.statusCode == 204) {
        if (currentPost.value?.id == id) {
          currentPost.value = null;
        }
        totalCount.value = (totalCount.value - 1).clamp(0, 999999);
        return "success";
      } else {
        userFeeds.insert(index, deletedFeed);
        return _parseError(body);
      }
    } catch (e) {
      userFeeds.insert(index, deletedFeed);
      return e.toString();
    } finally {
      isDeleteLoading(false);
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // POST RATING API
  // ══════════════════════════════════════════════════════════════════════════

  /// POST /feed/posts/{id}/rate/ — Rate a feed post.
  ///
  /// Ratings are integers from 0 to 10 for each dimension:
  /// [colorHarmony], [trendy], [overallMatching], [accessories].
  Future<String> ratePost(
    int id, {
    required int colorHarmony,
    required int trendy,
    required int overallMatching,
    required int accessories,
  }) async {
    isRatingLoading(true);
    try {
      final payload = {
        'color_harmony': colorHarmony.clamp(0, 10),
        'trendy': trendy.clamp(0, 10),
        'overall_matching': overallMatching.clamp(0, 10),
        'accessories': accessories.clamp(0, 10),
      };

      final res = await api.post(
        '/feed/posts/$id/rate/',
        payload,
        authReq: true,
      );
      final body = _decodeBody(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        final rating = FeedPostRatingModel.fromJson(_extractObject(body));
        lastRatingResult.value = rating;

        // Optionally refresh post details or update post rating locally
        final avg = rating.average;
        final idx = userFeeds.indexWhere((p) => p.id == id);
        if (idx >= 0) {
          userFeeds[idx] = userFeeds[idx].copyWith(
            userRating: avg.toStringAsFixed(1),
            totalRatings: userFeeds[idx].totalRatings + 1,
          );
        }

        if (currentPost.value?.id == id) {
          currentPost.value = currentPost.value!.copyWith(
            userRating: avg.toStringAsFixed(1),
            totalRatings: currentPost.value!.totalRatings + 1,
          );
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
  // STATE MANAGEMENT
  // ══════════════════════════════════════════════════════════════════════════

  /// Clears all feed cached data.
  void clearFeedData() {
    userFeeds.clear();
    currentPost.value = null;
    lastRatingResult.value = null;
    totalCount.value = 0;
    currentPage.value = 1;
    hasMore.value = true;
    userPostsTotalCount.value = 0;
  }
}
