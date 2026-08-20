class WardrobeOptionsModel {
  final List<WardrobeCategory> categories;
  final List<WardrobeOption> seasons;
  final List<WardrobeOption> occasions;

  WardrobeOptionsModel({
    required this.categories,
    required this.seasons,
    required this.occasions,
  });

  factory WardrobeOptionsModel.fromJson(Map<String, dynamic> json) {
    return WardrobeOptionsModel(
      categories: (json['categories'] as List<dynamic>?)
              ?.map(
                (e) => WardrobeCategory.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      seasons: (json['seasons'] as List<dynamic>?)
              ?.map(
                (e) => WardrobeOption.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      occasions: (json['occasions'] as List<dynamic>?)
              ?.map(
                (e) => WardrobeOption.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categories': categories.map((e) => e.toJson()).toList(),
      'seasons': seasons.map((e) => e.toJson()).toList(),
      'occasions': occasions.map((e) => e.toJson()).toList(),
    };
  }
}

class WardrobeCategory {
  final int id;
  final String name;

  WardrobeCategory({
    required this.id,
    required this.name,
  });

  factory WardrobeCategory.fromJson(Map<String, dynamic> json) {
    return WardrobeCategory(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class WardrobeOption {
  final String value;
  final String label;

  WardrobeOption({
    required this.value,
    required this.label,
  });

  factory WardrobeOption.fromJson(Map<String, dynamic> json) {
    return WardrobeOption(
      value: json['value'] as String,
      label: json['label'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'label': label,
    };
  }
}