class OutfitReasoningItem {
  final String title;
  final String description;

  const OutfitReasoningItem({
    required this.title,
    required this.description,
  });

  factory OutfitReasoningItem.fromJson(Map<String, dynamic> json) {
    return OutfitReasoningItem(
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
    };
  }

  OutfitReasoningItem copyWith({
    String? title,
    String? description,
  }) {
    return OutfitReasoningItem(
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'OutfitReasoningItem('
        'title: $title, '
        'description: $description'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OutfitReasoningItem &&
        other.title == title &&
        other.description == description;
  }

  @override
  int get hashCode => Object.hash(
        title,
        description,
      );
}

class OutfitJobModel {
  final int id;
  final DateTime generatedDate;
  final String triggerType;
  final String status;
  final int avatar;
  final List<int> wardrobeItems;
  final String? resultImage;
  final String? reasoningTitle;
  final String? reasoningSubtitle;
  final List<OutfitReasoningItem> reasoningItems;
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
    this.reasoningItems = const [],
    this.reasoningNote,
    this.errorMessage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OutfitJobModel.fromJson(Map<String, dynamic> json) {
    final reasoningItemsJson = json['reasoning_items'];

    return OutfitJobModel(
      id: (json['id'] is int)
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,

      generatedDate: json['generated_date'] != null
          ? DateTime.tryParse(json['generated_date'].toString()) ??
              DateTime.tryParse(json['date']?.toString() ?? '') ??
              DateTime.now()
          : DateTime.tryParse(json['date']?.toString() ?? '') ??
              DateTime.now(),

      triggerType: json['trigger_type']?.toString() ?? 'auto',

      status: json['status']?.toString() ?? 'pending',

      avatar: (json['avatar'] is int)
          ? json['avatar'] as int
          : int.tryParse(json['avatar']?.toString() ?? '') ?? 0,

      wardrobeItems: (json['wardrobe_items'] as List<dynamic>?)
              ?.map(
                (e) => e is int
                    ? e
                    : int.tryParse(e.toString()) ?? 0,
              )
              .toList() ??
          const [],

      resultImage: json['result_image']?.toString(),

      reasoningTitle: json['reasoning_title']?.toString(),

      reasoningSubtitle: json['reasoning_subtitle']?.toString(),

      reasoningItems: reasoningItemsJson is List
          ? reasoningItemsJson
              .whereType<Map>()
              .map(
                (item) => OutfitReasoningItem.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : const [],

      reasoningNote: json['reasoning_note']?.toString(),

      errorMessage: json['error_message']?.toString(),

      createdAt: json['created_at'] != null
          ? DateTime.tryParse(
                json['created_at'].toString(),
              ) ??
              DateTime.now()
          : DateTime.now(),

      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(
                json['updated_at'].toString(),
              ) ??
              DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'generated_date': generatedDate.toIso8601String(),
      'trigger_type': triggerType,
      'status': status,
      'avatar': avatar,
      'wardrobe_items': wardrobeItems,
      'result_image': resultImage,
      'reasoning_title': reasoningTitle,
      'reasoning_subtitle': reasoningSubtitle,
      'reasoning_items': reasoningItems
          .map((item) => item.toJson())
          .toList(),
      'reasoning_note': reasoningNote,
      'error_message': errorMessage,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  OutfitJobModel copyWith({
    int? id,
    DateTime? generatedDate,
    String? triggerType,
    String? status,
    int? avatar,
    List<int>? wardrobeItems,
    String? resultImage,
    String? reasoningTitle,
    String? reasoningSubtitle,
    List<OutfitReasoningItem>? reasoningItems,
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
      reasoningSubtitle:
          reasoningSubtitle ?? this.reasoningSubtitle,
      reasoningItems:
          reasoningItems ?? this.reasoningItems,
      reasoningNote:
          reasoningNote ?? this.reasoningNote,
      errorMessage:
          errorMessage ?? this.errorMessage,
      createdAt:
          createdAt ?? this.createdAt,
      updatedAt:
          updatedAt ?? this.updatedAt,
    );
  }

  bool get isProcessing {
    return status == 'pending' ||
        status == 'processing';
  }

  bool get isCompleted {
    return status == 'completed' ||
        status == 'done';
  }

  bool get isFailed {
    return status == 'failed';
  }

  @override
  String toString() {
    return 'OutfitJobModel('
        'id: $id, '
        'status: $status, '
        'triggerType: $triggerType, '
        'resultImage: $resultImage'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OutfitJobModel &&
        other.id == id &&
        other.generatedDate == generatedDate &&
        other.triggerType == triggerType &&
        other.status == status &&
        other.avatar == avatar &&
        _listEquals(
          other.wardrobeItems,
          wardrobeItems,
        ) &&
        other.resultImage == resultImage &&
        other.reasoningTitle == reasoningTitle &&
        other.reasoningSubtitle == reasoningSubtitle &&
        _listEquals(
          other.reasoningItems,
          reasoningItems,
        ) &&
        other.reasoningNote == reasoningNote &&
        other.errorMessage == errorMessage &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      generatedDate,
      triggerType,
      status,
      avatar,
      Object.hashAll(wardrobeItems),
      resultImage,
      reasoningTitle,
      reasoningSubtitle,
      Object.hashAll(reasoningItems),
      reasoningNote,
      errorMessage,
      createdAt,
      updatedAt,
    );
  }

  static bool _listEquals<T>(
    List<T> a,
    List<T> b,
  ) {
    if (identical(a, b)) return true;

    if (a.length != b.length) {
      return false;
    }

    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }

    return true;
  }
}
