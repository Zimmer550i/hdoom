import 'dart:convert';

import 'package:get/get.dart';
import 'package:hdoom/models/public_user_model.dart';
import 'package:hdoom/services/api_service.dart';

class SocialController extends GetxController {
  final api = ApiService();

  // ── Observables ──────────────────────────────────────────────────────────

  final RxBool isSearchLoading = RxBool(false);
  final RxBool isProfileLoading = RxBool(false);
  final RxBool isFollowersLoading = RxBool(false);
  final RxBool isFollowingLoading = RxBool(false);
  final RxBool isFollowActionLoading = RxBool(false);

  final RxList<PublicUserModel> searchResults = RxList.empty();
  final Rxn<PublicUserModel> viewedProfile = Rxn<PublicUserModel>();
  final RxList<PublicUserModel> followers = RxList.empty();
  final RxList<PublicUserModel> following = RxList.empty();

  /// Total count from paginated search results.
  final RxInt searchTotalCount = RxInt(0);

  /// Total count from paginated followers list.
  final RxInt followersTotalCount = RxInt(0);

  /// Total count from paginated following list.
  final RxInt followingTotalCount = RxInt(0);

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

  /// Extracts the paginated results list from a wrapped API response.
  ///
  /// The API wraps everything in `{ data: { count, next, previous, results } }`.
  List _extractPaginatedResults(dynamic body) {
    // Wrapped: { data: { results: [...] } }
    if (body is Map && body['data'] is Map && body['data']['results'] is List) {
      return body['data']['results'] as List;
    }
    // Direct paginated: { results: [...] }
    if (body is Map && body['results'] is List) {
      return body['results'] as List;
    }
    // Wrapped list: { data: [...] }
    if (body is Map && body['data'] is List) {
      return body['data'] as List;
    }
    // Direct list
    if (body is List) return body;
    return [];
  }

  /// Extracts total count from a paginated response.
  int _extractPaginatedCount(dynamic body) {
    if (body is Map && body['data'] is Map && body['data']['count'] is int) {
      return body['data']['count'] as int;
    }
    if (body is Map && body['count'] is int) {
      return body['count'] as int;
    }
    return 0;
  }

  /// Extracts a single object from a wrapped API response.
  Map<String, dynamic> _extractObject(dynamic body) {
    if (body is Map && body['data'] is Map) {
      return body['data'] as Map<String, dynamic>;
    }
    if (body is Map) return body as Map<String, dynamic>;
    return <String, dynamic>{};
  }

  List<PublicUserModel> _parseUserList(List rawList) {
    final List<PublicUserModel> users = [];
    for (var item in rawList) {
      if (item is Map<String, dynamic>) {
        users.add(PublicUserModel.fromJson(item));
      } else if (item is Map) {
        users.add(
          PublicUserModel.fromJson(Map<String, dynamic>.from(item)),
        );
      }
    }
    return users;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SEARCH API
  // ══════════════════════════════════════════════════════════════════════════

  /// GET /social/search/?q={query} — Search users by username or name.
  Future<String> searchUsers(
    String query, {
    int page = 1,
    int pageSize = 20,
  }) async {
    isSearchLoading(true);
    try {
      final queryParams = {
        'q': query,
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };
      final res = await api.get(
        '/social/search/',
        queryParams: queryParams,
        authReq: true,
      );
      final body = _decodeBody(res.body);

      if (res.statusCode == 200) {
        final results = _extractPaginatedResults(body);
        searchTotalCount.value = _extractPaginatedCount(body);

        if (page == 1) searchResults.clear();
        searchResults.addAll(_parseUserList(results));
        return "success";
      } else {
        return _parseError(body);
      }
    } catch (e) {
      return e.toString();
    } finally {
      isSearchLoading(false);
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PUBLIC PROFILE API
  // ══════════════════════════════════════════════════════════════════════════

  /// GET /social/users/{username}/ — Retrieve public profile with follow counts.
  Future<String> getUserProfile(String username) async {
    isProfileLoading(true);
    try {
      final res = await api.get(
        '/social/users/$username/',
        authReq: true,
      );
      final body = _decodeBody(res.body);

      if (res.statusCode == 200) {
        final data = _extractObject(body);
        viewedProfile.value = PublicUserModel.fromJson(data);
        return "success";
      } else {
        return _parseError(body);
      }
    } catch (e) {
      return e.toString();
    } finally {
      isProfileLoading(false);
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // FOLLOW / UNFOLLOW API
  // ══════════════════════════════════════════════════════════════════════════

  /// POST /social/users/{username}/follow/ — Follow a user.
  Future<String> followUser(String username) async {
    isFollowActionLoading(true);
    try {
      final res = await api.post(
        '/social/users/$username/follow/',
        {},
        authReq: true,
      );
      final body = _decodeBody(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        // Update the viewed profile's isFollowing flag if it matches.
        if (viewedProfile.value != null &&
            viewedProfile.value!.username == username) {
          viewedProfile.value = viewedProfile.value!.copyWith(
            isFollowing: true,
            followersCount: viewedProfile.value!.followersCount + 1,
          );
        }

        // Update in search results if present.
        final idx = searchResults.indexWhere((u) => u.username == username);
        if (idx >= 0) {
          searchResults[idx] = searchResults[idx].copyWith(isFollowing: true);
        }

        return "success";
      } else {
        return _parseError(body);
      }
    } catch (e) {
      return e.toString();
    } finally {
      isFollowActionLoading(false);
    }
  }

  /// DELETE /social/users/{username}/follow/ — Unfollow a user.
  Future<String> unfollowUser(String username) async {
    isFollowActionLoading(true);
    try {
      final res = await api.delete(
        '/social/users/$username/follow/',
        authReq: true,
      );
      final body = _decodeBody(res.body);

      if (res.statusCode == 200 || res.statusCode == 204) {
        // Update the viewed profile's isFollowing flag if it matches.
        if (viewedProfile.value != null &&
            viewedProfile.value!.username == username) {
          viewedProfile.value = viewedProfile.value!.copyWith(
            isFollowing: false,
            followersCount:
                (viewedProfile.value!.followersCount - 1).clamp(0, 999999),
          );
        }

        // Update in search results if present.
        final idx = searchResults.indexWhere((u) => u.username == username);
        if (idx >= 0) {
          searchResults[idx] = searchResults[idx].copyWith(isFollowing: false);
        }

        return "success";
      } else {
        return _parseError(body);
      }
    } catch (e) {
      return e.toString();
    } finally {
      isFollowActionLoading(false);
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // FOLLOWERS / FOLLOWING LISTS API
  // ══════════════════════════════════════════════════════════════════════════

  /// GET /social/users/{username}/followers/ — List who follows this user.
  Future<String> getFollowers(
    String username, {
    int page = 1,
    int pageSize = 20,
  }) async {
    isFollowersLoading(true);
    try {
      final queryParams = {
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };
      final res = await api.get(
        '/social/users/$username/followers/',
        queryParams: queryParams,
        authReq: true,
      );
      final body = _decodeBody(res.body);

      if (res.statusCode == 200) {
        final results = _extractPaginatedResults(body);
        followersTotalCount.value = _extractPaginatedCount(body);

        if (page == 1) followers.clear();
        followers.addAll(_parseUserList(results));
        return "success";
      } else {
        return _parseError(body);
      }
    } catch (e) {
      return e.toString();
    } finally {
      isFollowersLoading(false);
    }
  }

  /// GET /social/users/{username}/following/ — List who this user follows.
  Future<String> getFollowing(
    String username, {
    int page = 1,
    int pageSize = 20,
  }) async {
    isFollowingLoading(true);
    try {
      final queryParams = {
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };
      final res = await api.get(
        '/social/users/$username/following/',
        queryParams: queryParams,
        authReq: true,
      );
      final body = _decodeBody(res.body);

      if (res.statusCode == 200) {
        final results = _extractPaginatedResults(body);
        followingTotalCount.value = _extractPaginatedCount(body);

        if (page == 1) following.clear();
        following.addAll(_parseUserList(results));
        return "success";
      } else {
        return _parseError(body);
      }
    } catch (e) {
      return e.toString();
    } finally {
      isFollowingLoading(false);
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // CONVENIENCE
  // ══════════════════════════════════════════════════════════════════════════

  /// Toggle follow/unfollow for the given username based on current state.
  Future<String> toggleFollow(String username, {required bool isFollowing}) {
    return isFollowing ? unfollowUser(username) : followUser(username);
  }

  /// Clears all social data. Call when user logs out.
  void clearSocialData() {
    searchResults.clear();
    viewedProfile.value = null;
    followers.clear();
    following.clear();
    searchTotalCount.value = 0;
    followersTotalCount.value = 0;
    followingTotalCount.value = 0;
  }
}
