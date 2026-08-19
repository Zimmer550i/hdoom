/// Represents a public user profile as returned by social endpoints.
///
/// Maps to the `PublicUser` schema from the API.
class PublicUserModel {
  final int id;
  final String username;
  final String name;
  final String? profileImage;
  final int followersCount;
  final int followingCount;
  final int sharedOutfitsCount;
  final bool isFollowing;

  const PublicUserModel({
    required this.id,
    required this.username,
    required this.name,
    this.profileImage,
    this.followersCount = 0,
    this.followingCount = 0,
    this.sharedOutfitsCount = 0,
    this.isFollowing = false,
  });

  factory PublicUserModel.fromJson(Map<String, dynamic> json) {
    return PublicUserModel(
      id: (json['id'] is int)
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      username: json['username'] as String? ?? '',
      name: json['name'] as String? ?? '',
      profileImage: json['profile_image'] as String?,
      followersCount: (json['followers_count'] is int)
          ? json['followers_count'] as int
          : int.tryParse(json['followers_count']?.toString() ?? '') ?? 0,
      followingCount: (json['following_count'] is int)
          ? json['following_count'] as int
          : int.tryParse(json['following_count']?.toString() ?? '') ?? 0,
      sharedOutfitsCount: (json['shared_outfits_count'] is int)
          ? json['shared_outfits_count'] as int
          : int.tryParse(json['shared_outfits_count']?.toString() ?? '') ?? 0,
      isFollowing: json['is_following'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'profile_image': profileImage,
      'followers_count': followersCount,
      'following_count': followingCount,
      'shared_outfits_count': sharedOutfitsCount,
      'is_following': isFollowing,
    };
  }

  PublicUserModel copyWith({
    int? id,
    String? username,
    String? name,
    String? profileImage,
    int? followersCount,
    int? followingCount,
    int? sharedOutfitsCount,
    bool? isFollowing,
  }) {
    return PublicUserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      sharedOutfitsCount: sharedOutfitsCount ?? this.sharedOutfitsCount,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }

  @override
  String toString() {
    return 'PublicUserModel(id: $id, username: $username, name: $name, '
        'profileImage: $profileImage, followersCount: $followersCount, '
        'followingCount: $followingCount, sharedOutfitsCount: $sharedOutfitsCount, '
        'isFollowing: $isFollowing)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PublicUserModel &&
        other.id == id &&
        other.username == username &&
        other.name == name &&
        other.profileImage == profileImage &&
        other.followersCount == followersCount &&
        other.followingCount == followingCount &&
        other.sharedOutfitsCount == sharedOutfitsCount &&
        other.isFollowing == isFollowing;
  }

  @override
  int get hashCode => Object.hash(
        id,
        username,
        name,
        profileImage,
        followersCount,
        followingCount,
        sharedOutfitsCount,
        isFollowing,
      );
}
