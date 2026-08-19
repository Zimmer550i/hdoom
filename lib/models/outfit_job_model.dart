class OutfitJobModel {
  final int id;
  final String generatedDate;
  final String triggerType;
  final String status;
  final int avatar;
  final List<int> wardrobeItems;
  final String? resultImage;
  final String? reasoningTitle;
  final String? reasoningSubtitle;
  final dynamic reasoningItems;
  final String? reasoningNote;
  final String? errorMessage;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OutfitJobModel({
    required this.id,
    required this.generatedDate,
    required this.triggerType,
    required this.status,
    required this.avatar,
    required this.wardrobeItems,
    this.resultImage,
    this.reasoningTitle,
    this.reasoningSubtitle,
    this.reasoningItems,
    this.reasoningNote,
    this.errorMessage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OutfitJobModel.fromJson(Map<String, dynamic> json) {
    return OutfitJobModel(
      id: (json['id'] is int)
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      generatedDate: (json['generated_date'] ?? json['date']) as String? ?? '',
      triggerType: json['trigger_type'] as String? ?? 'auto',
      status: json['status'] as String? ?? 'pending',
      avatar: (json['avatar'] is int)
          ? json['avatar'] as int
          : int.tryParse(json['avatar']?.toString() ?? '') ?? 0,
      wardrobeItems: (json['wardrobe_items'] as List<dynamic>?)
              ?.map((e) => e is int ? e : int.tryParse(e.toString()) ?? 0)
              .toList() ??
          [],
      resultImage: json['result_image'] as String?,
      reasoningTitle: json['reasoning_title'] as String?,
      reasoningSubtitle: json['reasoning_subtitle'] as String?,
      reasoningItems: json['reasoning_items'],
      reasoningNote: json['reasoning_note'] as String?,
      errorMessage: json['error_message'] as String?,
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
      'generated_date': generatedDate,
      'trigger_type': triggerType,
      'status': status,
      'avatar': avatar,
      'wardrobe_items': wardrobeItems,
      'result_image': resultImage,
      'reasoning_title': reasoningTitle,
      'reasoning_subtitle': reasoningSubtitle,
      'reasoning_items': reasoningItems,
      'reasoning_note': reasoningNote,
      'error_message': errorMessage,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  OutfitJobModel copyWith({
    int? id,
    String? generatedDate,
    String? triggerType,
    String? status,
    int? avatar,
    List<int>? wardrobeItems,
    String? resultImage,
    String? reasoningTitle,
    String? reasoningSubtitle,
    dynamic reasoningItems,
    String? reasoningNote,
    String? errorMessage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OutfitJobModel(
      id: id ?? this.id,
      generatedDate: generatedDate ?? this.generatedDate,
      triggerType: triggerType ?? this.triggerType,
      status: status ?? this.status,
      avatar: avatar ?? this.avatar,
      wardrobeItems: wardrobeItems ?? this.wardrobeItems,
      resultImage: resultImage ?? this.resultImage,
      reasoningTitle: reasoningTitle ?? this.reasoningTitle,
      reasoningSubtitle: reasoningSubtitle ?? this.reasoningSubtitle,
      reasoningItems: reasoningItems ?? this.reasoningItems,
      reasoningNote: reasoningNote ?? this.reasoningNote,
      errorMessage: errorMessage ?? this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isProcessing => status == 'pending' || status == 'processing';
  bool get isCompleted => status == 'completed' || status == 'done';
  bool get isFailed => status == 'failed';

  @override
  String toString() {
    return 'OutfitJobModel(id: $id, status: $status, triggerType: $triggerType, resultImage: $resultImage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OutfitJobModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
