class AvatarModel {
  final int id;
  final String status;
  final String style;
  final bool isDefault;
  final String? sourcePhoto;
  final String? resultImage;
  final String errorMessage;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AvatarModel({
    required this.id,
    required this.status,
    required this.style,
    required this.isDefault,
    this.sourcePhoto,
    this.resultImage,
    required this.errorMessage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AvatarModel.fromJson(Map<String, dynamic> json) {
    return AvatarModel(
      id: json['id'] as int,
      status: json['status'] as String? ?? 'pending',
      style: json['style'] as String? ?? 'realistic',
      isDefault: json['is_default'] as bool? ?? false,
      sourcePhoto: json['source_photo'] as String?,
      resultImage: json['result_image'] as String?,
      errorMessage: json['error_message'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'style': style,
      'is_default': isDefault,
      'source_photo': sourcePhoto,
      'result_image': resultImage,
      'error_message': errorMessage,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  AvatarModel copyWith({
    int? id,
    String? status,
    String? style,
    bool? isDefault,
    String? sourcePhoto,
    String? resultImage,
    String? errorMessage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AvatarModel(
      id: id ?? this.id,
      status: status ?? this.status,
      style: style ?? this.style,
      isDefault: isDefault ?? this.isDefault,
      sourcePhoto: sourcePhoto ?? this.sourcePhoto,
      resultImage: resultImage ?? this.resultImage,
      errorMessage: errorMessage ?? this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Whether the avatar is still being generated.
  bool get isProcessing => status == 'pending' || status == 'processing';

  /// Whether avatar generation completed successfully.
  bool get isDone => status == 'done';

  /// Whether avatar generation failed.
  bool get isFailed => status == 'failed';

  @override
  String toString() {
    return 'AvatarModel(id: $id, status: $status, style: $style, '
        'isDefault: $isDefault, resultImage: $resultImage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AvatarModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
