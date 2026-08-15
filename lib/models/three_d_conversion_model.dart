class ThreeDConversionModel {
  final int id;
  final int outfitJob;
  final String status;
  final String? falRequestId;
  final String? resultMeshUrl;
  final String errorMessage;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ThreeDConversionModel({
    required this.id,
    required this.outfitJob,
    required this.status,
    this.falRequestId,
    this.resultMeshUrl,
    required this.errorMessage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ThreeDConversionModel.fromJson(Map<String, dynamic> json) {
    return ThreeDConversionModel(
      id: json['id'] as int,
      outfitJob: json['outfit_job'] as int,
      status: json['status'] as String? ?? 'pending',
      falRequestId: json['fal_request_id'] as String?,
      resultMeshUrl: json['result_mesh_url'] as String?,
      errorMessage: json['error_message'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'outfit_job': outfitJob,
      'status': status,
      'fal_request_id': falRequestId,
      'result_mesh_url': resultMeshUrl,
      'error_message': errorMessage,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ThreeDConversionModel copyWith({
    int? id,
    int? outfitJob,
    String? status,
    String? falRequestId,
    String? resultMeshUrl,
    String? errorMessage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ThreeDConversionModel(
      id: id ?? this.id,
      outfitJob: outfitJob ?? this.outfitJob,
      status: status ?? this.status,
      falRequestId: falRequestId ?? this.falRequestId,
      resultMeshUrl: resultMeshUrl ?? this.resultMeshUrl,
      errorMessage: errorMessage ?? this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Whether the conversion is still being processed.
  bool get isProcessing => status == 'pending' || status == 'processing';

  /// Whether conversion completed successfully.
  bool get isDone => status == 'done';

  /// Whether conversion failed.
  bool get isFailed => status == 'failed';

  @override
  String toString() {
    return 'ThreeDConversionModel(id: $id, outfitJob: $outfitJob, '
        'status: $status, resultMeshUrl: $resultMeshUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ThreeDConversionModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
