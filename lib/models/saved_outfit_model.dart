import 'package:hdoom/models/outfit_job_model.dart';

class SavedOutfitModel {
  final int id;
  final DateTime savedDate;
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
    return SavedOutfitModel(
      id: _parseInt(json['id']),
      savedDate: _parseDateTime(json['saved_date']),
      note: json['note']?.toString() ?? '',
      isShared: _parseBool(json['is_shared']),
      outfitJob: _parseOutfitJob(json['outfit_job']),
      ratingsCount: _parseInt(json['ratings_count']),
      averageRating: _parseDouble(json['average_rating']),
      ratingBreakdown: _parseRatingBreakdown(
        json['rating_breakdown'],
      ),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseNullableDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'saved_date': savedDate.toIso8601String(),
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
    DateTime? savedDate,
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
    return 'SavedOutfitModel('
        'id: $id, '
        'savedDate: $savedDate, '
        'note: $note, '
        'isShared: $isShared, '
        'outfitJob: $outfitJob, '
        'ratingsCount: $ratingsCount, '
        'averageRating: $averageRating, '
        'ratingBreakdown: $ratingBreakdown, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is SavedOutfitModel &&
        other.id == id &&
        other.savedDate == savedDate &&
        other.note == note &&
        other.isShared == isShared &&
        other.outfitJob == outfitJob &&
        other.ratingsCount == ratingsCount &&
        other.averageRating == averageRating &&
        _mapEquals(
          other.ratingBreakdown,
          ratingBreakdown,
        ) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      savedDate,
      note,
      isShared,
      outfitJob,
      ratingsCount,
      averageRating,
      _mapHashCode(ratingBreakdown),
      createdAt,
      updatedAt,
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.toInt();
    }

    return int.tryParse(value.toString()) ?? 0;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is double) {
      return value;
    }

    if (value is int) {
      return value.toDouble();
    }

    return double.tryParse(value.toString());
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is int) {
      return value == 1;
    }

    if (value == null) {
      return false;
    }

    return value.toString().toLowerCase() == 'true';
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is DateTime) {
      return value;
    }

    if (value == null) {
      return DateTime.now();
    }

    final parsed = DateTime.tryParse(value.toString());

    return parsed ?? DateTime.now();
  }

  static DateTime? _parseNullableDateTime(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.tryParse(value.toString());
  }

  static OutfitJobModel? _parseOutfitJob(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is Map<String, dynamic>) {
      return OutfitJobModel.fromJson(value);
    }

    if (value is Map) {
      return OutfitJobModel.fromJson(
        Map<String, dynamic>.from(value),
      );
    }

    return null;
  }

  static Map<String, double?>? _parseRatingBreakdown(
    dynamic value,
  ) {
    if (value == null || value is! Map) {
      return null;
    }

    final result = <String, double?>{};

    value.forEach((key, itemValue) {
      result[key.toString()] = _parseDouble(itemValue);
    });

    return result;
  }

  static bool _mapEquals(
    Map<String, double?>? a,
    Map<String, double?>? b,
  ) {
    if (identical(a, b)) {
      return true;
    }

    if (a == null || b == null) {
      return a == b;
    }

    if (a.length != b.length) {
      return false;
    }

    for (final entry in a.entries) {
      if (!b.containsKey(entry.key)) {
        return false;
      }

      if (b[entry.key] != entry.value) {
        return false;
      }
    }

    return true;
  }

  static int? _mapHashCode(
    Map<String, double?>? map,
  ) {
    if (map == null) {
      return null;
    }

    return Object.hashAll(
      map.entries.map(
        (entry) => Object.hash(
          entry.key,
          entry.value,
        ),
      ),
    );
  }
}