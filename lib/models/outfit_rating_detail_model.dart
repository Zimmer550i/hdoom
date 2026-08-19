class RaterModel {
  final int id;
  final String username;
  final String name;
  final String? avatarUrl;

  const RaterModel({
    required this.id,
    required this.username,
    required this.name,
    this.avatarUrl,
  });

  factory RaterModel.fromJson(Map<String, dynamic> json) {
    return RaterModel(
      id: (json['id'] is int)
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      username: json['username'] as String? ?? '',
      name: json['name'] as String? ?? '',
      avatarUrl: (json['avatar_url'] ?? json['profile_image']) as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'avatar_url': avatarUrl,
    };
  }
}

class OutfitRatingDetailModel {
  final int id;
  final RaterModel? rater;
  final int colorHarmony;
  final int trendy;
  final int overallMatching;
  final int accessories;
  final DateTime createdAt;

  const OutfitRatingDetailModel({
    required this.id,
    this.rater,
    required this.colorHarmony,
    required this.trendy,
    required this.overallMatching,
    required this.accessories,
    required this.createdAt,
  });

  factory OutfitRatingDetailModel.fromJson(Map<String, dynamic> json) {
    RaterModel? raterObj;
    if (json['rater'] is Map<String, dynamic>) {
      raterObj = RaterModel.fromJson(json['rater'] as Map<String, dynamic>);
    } else if (json['rater'] is Map) {
      raterObj = RaterModel.fromJson(
        Map<String, dynamic>.from(json['rater'] as Map),
      );
    }

    return OutfitRatingDetailModel(
      id: (json['id'] is int)
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      rater: raterObj,
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
    };
  }
}
