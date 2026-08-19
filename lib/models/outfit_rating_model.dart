class OutfitRatingModel {
  final int colorHarmony;
  final int trendy;
  final int overallMatching;
  final int accessories;

  const OutfitRatingModel({
    required this.colorHarmony,
    required this.trendy,
    required this.overallMatching,
    required this.accessories,
  });

  factory OutfitRatingModel.fromJson(Map<String, dynamic> json) {
    return OutfitRatingModel(
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'color_harmony': colorHarmony,
      'trendy': trendy,
      'overall_matching': overallMatching,
      'accessories': accessories,
    };
  }

  double get average =>
      (colorHarmony + trendy + overallMatching + accessories) / 4.0;
}
