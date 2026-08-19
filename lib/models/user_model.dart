class UserModel {
  final int id;
  final String? username;
  final String name;
  final String email;
  final String? profileImage;
  final bool isEmailVerified;
  final bool isProfileCompleted;
  final DateTime createdAt;

  final int? age;
  final String? gender;
  final int? height;
  final String? bodyType;
  final String? country;
  final List<int>? aesthetics;

  const UserModel({
    required this.id,
    this.username,
    required this.name,
    required this.email,
    this.profileImage,
    required this.isEmailVerified,
    this.isProfileCompleted = false,
    required this.createdAt,
    this.age,
    this.gender,
    this.height,
    this.bodyType,
    this.country,
    this.aesthetics,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] is int)
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      username: json['username'] as String?,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      profileImage: (json['avatar_url'] ?? json['profile_image']) as String?,
      isEmailVerified: json['is_email_verified'] as bool? ?? false,
      isProfileCompleted: json['is_profile_completed'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      age: (json['age'] is int)
          ? json['age'] as int
          : int.tryParse(json['age']?.toString() ?? ''),
      gender: json['gender'] as String?,
      height: (json['height'] is int)
          ? json['height'] as int
          : int.tryParse(json['height']?.toString() ?? ''),
      bodyType: json['body_type'] as String?,
      country: json['country'] as String?,
      aesthetics: (json['aesthetics'] as List<dynamic>?)
          ?.map((e) => e is int ? e : int.tryParse(e.toString()) ?? 0)
          .toList(),
    );
  }

  /// Safely merges additional profile completion data into this [UserModel]
  UserModel mergeWithAdditionalProfile(Map<String, dynamic> json) {
    return copyWith(
      name: json.containsKey('name') && json['name'] != null
          ? json['name'] as String
          : name,
      profileImage: (json['profile_image'] ?? json['avatar_url']) as String? ??
          profileImage,
      age: json.containsKey('age')
          ? (json['age'] is int
              ? json['age'] as int?
              : int.tryParse(json['age']?.toString() ?? ''))
          : age,
      gender: json.containsKey('gender') ? json['gender'] as String? : gender,
      height: json.containsKey('height')
          ? (json['height'] is int
              ? json['height'] as int?
              : int.tryParse(json['height']?.toString() ?? ''))
          : height,
      bodyType: json.containsKey('body_type')
          ? json['body_type'] as String?
          : bodyType,
      country:
          json.containsKey('country') ? json['country'] as String? : country,
      aesthetics: json.containsKey('aesthetics') && json['aesthetics'] != null
          ? (json['aesthetics'] as List<dynamic>)
              .map((e) => e is int ? e : int.tryParse(e.toString()) ?? 0)
              .toList()
          : aesthetics,
      isProfileCompleted: json.containsKey('is_profile_completed')
          ? json['is_profile_completed'] as bool? ?? isProfileCompleted
          : true,
    );
  }

  /// Creates a [UserModel] from additional profile JSON, optionally merging with [baseUser]
  factory UserModel.fromAdditionalJson(
    Map<String, dynamic> json, {
    UserModel? baseUser,
  }) {
    if (baseUser != null) {
      return baseUser.mergeWithAdditionalProfile(json);
    }
    return UserModel(
      id: 0,
      name: json['name'] as String? ?? '',
      email: '',
      profileImage: (json['profile_image'] ?? json['avatar_url']) as String?,
      isEmailVerified: false,
      isProfileCompleted: true,
      createdAt: DateTime.now(),
      age: (json['age'] is int)
          ? json['age'] as int
          : int.tryParse(json['age']?.toString() ?? ''),
      gender: json['gender'] as String?,
      height: (json['height'] is int)
          ? json['height'] as int
          : int.tryParse(json['height']?.toString() ?? ''),
      bodyType: json['body_type'] as String?,
      country: json['country'] as String?,
      aesthetics: (json['aesthetics'] as List<dynamic>?)
          ?.map((e) => e is int ? e : int.tryParse(e.toString()) ?? 0)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'email': email,
      'avatar_url': profileImage,
      'is_email_verified': isEmailVerified,
      'is_profile_completed': isProfileCompleted,
      'created_at': createdAt.toUtc().toIso8601String(),
      'age': age,
      'gender': gender,
      'height': height,
      'body_type': bodyType,
      'country': country,
      'aesthetics': aesthetics,
    };
  }

  UserModel copyWith({
    int? id,
    String? username,
    String? name,
    String? email,
    String? profileImage,
    bool? isEmailVerified,
    bool? isProfileCompleted,
    DateTime? createdAt,
    int? age,
    String? gender,
    int? height,
    String? bodyType,
    String? country,
    List<int>? aesthetics,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isProfileCompleted: isProfileCompleted ?? this.isProfileCompleted,
      createdAt: createdAt ?? this.createdAt,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      bodyType: bodyType ?? this.bodyType,
      country: country ?? this.country,
      aesthetics: aesthetics ?? this.aesthetics,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, name: $name, email: $email, '
        'profileImage: $profileImage, isEmailVerified: $isEmailVerified, '
        'isProfileCompleted: $isProfileCompleted, createdAt: $createdAt, '
        'age: $age, gender: $gender, height: $height, bodyType: $bodyType, '
        'country: $country, aesthetics: $aesthetics)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.username == username &&
        other.name == name &&
        other.email == email &&
        other.profileImage == profileImage &&
        other.isEmailVerified == isEmailVerified &&
        other.isProfileCompleted == isProfileCompleted &&
        other.createdAt == createdAt &&
        other.age == age &&
        other.gender == gender &&
        other.height == height &&
        other.bodyType == bodyType &&
        other.country == country &&
        other.aesthetics == aesthetics;
  }

  @override
  int get hashCode => Object.hash(
        id,
        username,
        name,
        email,
        profileImage,
        isEmailVerified,
        isProfileCompleted,
        createdAt,
        age,
        gender,
        height,
        bodyType,
        country,
        aesthetics,
      );
}