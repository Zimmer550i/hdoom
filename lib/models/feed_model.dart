import 'package:khzanti/models/public_user_model.dart';

typedef FeedUser = PublicUserModel;

/// Model representing a Feed Post from `/api/v1/feed/posts/`
class FeedModel {
  final int id;
  final PublicUserModel user;
  final String caption;
  final String privacy;
  final List<FeedImage> images;
  final num? avgColorHarmony;
  final num? avgTrendy;
  final num? avgOverallMatching;
  final num? avgAccessories;
  final int totalRatings;
  final String? userRating;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FeedModel({
    required this.id,
    required this.user,
    required this.caption,
    this.privacy = 'public',
    this.images = const [],
    this.avgColorHarmony,
    this.avgTrendy,
    this.avgOverallMatching,
    this.avgAccessories,
    this.totalRatings = 0,
    this.userRating,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FeedModel.fromJson(Map<String, dynamic> json) {
    return FeedModel(
      id: (json['id'] is int)
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      user: json['user'] is Map<String, dynamic>
          ? PublicUserModel.fromJson(json['user'] as Map<String, dynamic>)
          : json['user'] is Map
          ? PublicUserModel.fromJson(
              Map<String, dynamic>.from(json['user'] as Map),
            )
          : const PublicUserModel(id: 0, username: '', name: ''),
      caption: json['caption'] as String? ?? '',
      privacy: json['privacy'] as String? ?? 'public',
      images: (json['images'] as List<dynamic>? ?? [])
          .map(
            (item) => FeedImage.fromJson(
              item is Map<String, dynamic>
                  ? item
                  : Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
      avgColorHarmony: json['avg_color_harmony'] != null
          ? (json['avg_color_harmony'] is num
                ? json['avg_color_harmony'] as num
                : num.tryParse(json['avg_color_harmony'].toString()))
          : null,
      avgTrendy: json['avg_trendy'] != null
          ? (json['avg_trendy'] is num
                ? json['avg_trendy'] as num
                : num.tryParse(json['avg_trendy'].toString()))
          : null,
      avgOverallMatching: json['avg_overall_matching'] != null
          ? (json['avg_overall_matching'] is num
                ? json['avg_overall_matching'] as num
                : num.tryParse(json['avg_overall_matching'].toString()))
          : null,
      avgAccessories: json['avg_accessories'] != null
          ? (json['avg_accessories'] is num
                ? json['avg_accessories'] as num
                : num.tryParse(json['avg_accessories'].toString()))
          : null,
      totalRatings: (json['total_ratings'] is int)
          ? json['total_ratings'] as int
          : int.tryParse(json['total_ratings']?.toString() ?? '') ?? 0,
      userRating: json['user_rating']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'caption': caption,
      'privacy': privacy,
      'images': images.map((item) => item.toJson()).toList(),
      'avg_color_harmony': avgColorHarmony,
      'avg_trendy': avgTrendy,
      'avg_overall_matching': avgOverallMatching,
      'avg_accessories': avgAccessories,
      'total_ratings': totalRatings,
      'user_rating': userRating,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  FeedModel copyWith({
    int? id,
    PublicUserModel? user,
    String? caption,
    String? privacy,
    List<FeedImage>? images,
    num? avgColorHarmony,
    num? avgTrendy,
    num? avgOverallMatching,
    num? avgAccessories,
    int? totalRatings,
    String? userRating,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FeedModel(
      id: id ?? this.id,
      user: user ?? this.user,
      caption: caption ?? this.caption,
      privacy: privacy ?? this.privacy,
      images: images ?? this.images,
      avgColorHarmony: avgColorHarmony ?? this.avgColorHarmony,
      avgTrendy: avgTrendy ?? this.avgTrendy,
      avgOverallMatching: avgOverallMatching ?? this.avgOverallMatching,
      avgAccessories: avgAccessories ?? this.avgAccessories,
      totalRatings: totalRatings ?? this.totalRatings,
      userRating: userRating ?? this.userRating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Model representing a Post Image from `/api/v1/feed/posts/`
class FeedImage {
  final int id;
  final String image;
  final DateTime createdAt;

  const FeedImage({
    required this.id,
    required this.image,
    required this.createdAt,
  });

  factory FeedImage.fromJson(Map<String, dynamic> json) {
    return FeedImage(
      id: (json['id'] is int)
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      image: json['image'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// Model representing a rating submitted to `/api/v1/feed/posts/{id}/rate/`
class FeedPostRatingModel {
  final int id;
  final PublicUserModel? rater;
  final int colorHarmony;
  final int trendy;
  final int overallMatching;
  final int accessories;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FeedPostRatingModel({
    required this.id,
    this.rater,
    required this.colorHarmony,
    required this.trendy,
    required this.overallMatching,
    required this.accessories,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FeedPostRatingModel.fromJson(Map<String, dynamic> json) {
    PublicUserModel? raterModel;
    if (json['rater'] is Map<String, dynamic>) {
      raterModel = PublicUserModel.fromJson(
        json['rater'] as Map<String, dynamic>,
      );
    } else if (json['rater'] is Map) {
      raterModel = PublicUserModel.fromJson(
        Map<String, dynamic>.from(json['rater'] as Map),
      );
    }

    return FeedPostRatingModel(
      id: (json['id'] is int)
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      rater: raterModel,
      colorHarmony: (json['color_harmony'] is int)
          ? json['color_harmony'] as int
          : int.tryParse(json['color_harmony']?.toString() ?? '') ?? 0,
      trendy: (json['trendy'] is int)
          ? json['trendy'] as int
          : int.tryParse(json['trendy']?.toString() ?? '') ?? 0,
      overallMatching: (json['overall_matching'] is int)
          ? json['overall_matching'] as int
          : int.tryParse(json['overall_matching']?.toString() ?? '') ?? 0,
      accessories: (json['accessories'] is int)
          ? json['accessories'] as int
          : int.tryParse(json['accessories']?.toString() ?? '') ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rater': rater?.toJson(),
      'color_harmony': colorHarmony,
      'trendy': trendy,
      'overall_matching': overallMatching,
      'accessories': accessories,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  double get average =>
      (colorHarmony + trendy + overallMatching + accessories) / 4.0;
}
