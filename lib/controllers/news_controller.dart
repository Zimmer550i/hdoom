import 'dart:convert';

import 'package:get/state_manager.dart';
import 'package:hdoom/models/news_model.dart';
import 'package:hdoom/services/api_service.dart';

class NewsController extends GetxController {
  final api = ApiService();

  final RxBool isLoading = RxBool(false);
  final RxList<NewsModel> news = RxList.empty();

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

  Future<String> getNews() async {
    isLoading(true);
    try {
      final res = await api.get("/news");
      final body = _decodeBody(res.body);

      if (res.statusCode == 200) {
        final data = body['data'];

        news.clear();
        for (var i in data) {
          try {
            news.add(NewsModel.fromJson(i));
          } catch (e) {
            return e.toString();
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

  Future<String> getNewsBySlug(String slug) async {
    isLoading(true);
    try {
      final res = await api.get("/news/$slug");
      final body = _decodeBody(res.body);

      if (res.statusCode == 200) {
        final data = body['data'];

        for (int i = 0; i < news.length; i++) {
          if (news[i].slug != slug) continue;
          try {
            news[i] = NewsModel.fromJson(data);
          } catch (e) {
            return e.toString();
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
}
