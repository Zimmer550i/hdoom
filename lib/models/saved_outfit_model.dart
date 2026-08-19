import 'package:hdoom/models/outfit_job_model.dart';

class SavedOutfitModel {
  final int id;
  final String savedDate;
  final String note;
  final bool isShared;
  final OutfitJobModel? outfitJob;
  final int ratingsCount;
  final double? averageRating;
  final Map<String, double?>? ratingBreakdown;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const SavedOutfitModel({
    required this.id,
    required this.savedDate,
    this.note = '',
    this.isShared = false,
    this.outfitJob,
    this.ratingsCount = 0,
    this.averageRating,
    this.ratingBreakdown,
    required this.createdAt,
    this.updatedAt,
  });

  factory SavedOutfitModel.fromJson(Map<String, dynamic> json) {
    OutfitJobModel? job;
    if (json['outfit_job'] is Map<String, dynamic>) {
      job = OutfitJobModel.fromJson(json['outfit_job'] as Map<String, dynamic>);
    } else if (json['outfit_job'] is Map) {
      job = OutfitJobModel.fromJson(
        Map<String, dynamic>.from(json['outfit_job'] as Map),
      );
    }

    Map<String, double?>? breakdown;
    if (json['rating_breakdown'] is Map) {
      breakdown = (json['rating_breakdown'] as Map).map(
        (key, value) => MapEntry(
          key.toString(),
          value != null ? double.tryParse(value.toString()) : null,
        ),
      );
    }

    return SavedOutfitModel(
      id: (json['id'] is int)
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      savedDate: json['saved_date'] as String? ?? '',
      note: json['note'] as String? ?? '',
      isShared: json['is_shared'] as bool? ?? false,
      outfitJob: job,
      ratingsCount: (json['ratings_count'] is int)
          ? json['ratings_count'] as int
          : int.tryParse(json['ratings_count']?.toString() ?? '') ?? 0,
      averageRating: json['average_rating'] != null
          ? double.tryParse(json['average_rating'].toString())
          : null,
      ratingBreakdown: breakdown,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'saved_date': savedDate,
      'note': note,
      'is_shared': isShared,
      'outfit_job': outfitJob?.toJson(),
      'ratings_count': ratingsCount,
      'average_rating': averageRating,
      'rating_breakdown': ratingBreakdown,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  SavedOutfitModel copyWith({
    int? id,
    String? savedDate,
    String? note,
    bool? isShared,
    OutfitJobModel? outfitJob,
    int? ratingsCount,
    double? averageRating,
    Map<String, double?>? ratingBreakdown,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SavedOutfitModel(
      id: id ?? this.id,
      savedDate: savedDate ?? this.savedDate,
      note: note ?? this.note,
      isShared: isShared ?? this.isShared,
      outfitJob: outfitJob ?? this.outfitJob,
      ratingsCount: ratingsCount ?? this.ratingsCount,
      averageRating: averageRating ?? this.averageRating,
      ratingBreakdown: ratingBreakdown ?? this.ratingBreakdown,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'SavedOutfitModel(id: $id, savedDate: $savedDate, isShared: $isShared)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SavedOutfitModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
