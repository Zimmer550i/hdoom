import 'package:hdoom/models/wardrobe_options.dart';

class ItemModel {
  final int id;
  final String image;
  final WardrobeCategory category;
  final String season;
  final String occasion;
  final String purchaseSource;
  ItemAnalysisModel? analysis;
  final DateTime createdAt;

  ItemModel({
    required this.id,
    required this.image,
    required this.category,
    required this.season,
    required this.occasion,
    required this.purchaseSource,
    this.analysis,
    required this.createdAt,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as int,
      image: json['image'] as String? ?? '',
      category: WardrobeCategory.fromJson(
        json['category'] as Map<String, dynamic>,
      ),
      season: json['season'] as String? ?? '',
      occasion: json['occasion'] as String? ?? '',
      purchaseSource: json['purchase_source'] as String? ?? '',
      analysis: json['analysis'] != null
          ? ItemAnalysisModel.fromJson(json['analysis'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'category': category.toJson(),
      'season': season,
      'occasion': occasion,
      'purchase_source': purchaseSource,
      'analysis': analysis?.toJson(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class ItemAnalysisModel {
  final int id;
  final int wardrobeItem;
  final String status;
  final String displayUrl;
  final String falCdnUrl;
  final String processedImage;
  final String color;
  final String description;
  final String errorMessage;
  final DateTime createdAt;
  final DateTime updatedAt;

  ItemAnalysisModel({
    required this.id,
    required this.wardrobeItem,
    required this.status,
    required this.displayUrl,
    required this.falCdnUrl,
    required this.processedImage,
    required this.color,
    required this.description,
    required this.errorMessage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ItemAnalysisModel.fromJson(Map<String, dynamic> json) {
    return ItemAnalysisModel(
      id: json['id'] as int,
      wardrobeItem: json['wardrobe_item'] as int,
      status: json['status'] as String? ?? '',
      displayUrl: json['display_url'] as String? ?? '',
      falCdnUrl: json['fal_cdn_url'] as String? ?? '',
      processedImage: json['processed_image'] as String? ?? '',
      color: json['color'] as String? ?? '',
      description: json['description'] as String? ?? '',
      errorMessage: json['error_message'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wardrobe_item': wardrobeItem,
      'status': status,
      'display_url': displayUrl,
      'fal_cdn_url': falCdnUrl,
      'processed_image': processedImage,
      'color': color,
      'description': description,
      'error_message': errorMessage,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
