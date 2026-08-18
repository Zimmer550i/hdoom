class AestheticModel {
  final int id;
  final String name;
  final String image;

  const AestheticModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory AestheticModel.fromJson(Map<String, dynamic> json) {
    return AestheticModel(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}