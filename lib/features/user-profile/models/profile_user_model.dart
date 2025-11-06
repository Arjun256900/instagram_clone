class ProfileUserModel {
  final String uid; // Returned from Firebase after user creation
  final String username;
  final String name;
  final String email;
  final String dob;
  final String? bio;
  final String? gender;
  final bool isPrivate;
  final List<String> followers;
  final List<String> following;
  final List<String> posts;

  const ProfileUserModel({
    required this.uid,
    required this.username,
    required this.name,
    required this.email,
    required this.dob,
    this.bio,
    this.gender,
    this.isPrivate = false,
    this.followers = const [],
    this.following = const [],
    this.posts = const [],
  });

  // Empty constructor
  const ProfileUserModel.empty()
    : uid = '',
      username = '',
      name = '',
      email = '',
      dob = '',
      bio = null,
      gender = null,
      isPrivate = false,
      followers = const [],
      following = const [],
      posts = const [];

  // CopyWith
  ProfileUserModel copyWith({
    String? uid,
    String? username,
    String? name,
    String? email,
    String? bio,
    String? dob,
    String? gender,
    bool? isPrivate,
    List<String>? followers,
    List<String>? following,
    List<String>? posts,
  }) {
    return ProfileUserModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      isPrivate: isPrivate ?? this.isPrivate,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      posts: posts ?? this.posts,
    );
  }

  // To JSON (for API requests to profile-service)
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'name': name,
      'email': email,
      'bio': bio,
      'gender': gender,
      'isPrivate': isPrivate,
      'followers': followers,
      'following': following,
      'posts': posts,
    };
  }

  // From JSON
  factory ProfileUserModel.fromJson(Map<String, dynamic> json) {
    return ProfileUserModel(
      uid: json['uid'] as String,
      username: json['username'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      bio: json['bio'] as String?,
      dob: json['dob'] as String,
      gender: json['gender'] as String?,
      isPrivate: json['isPrivate'] as bool? ?? false,
      followers: (json['followers'] as List<dynamic>?)?.cast<String>() ?? [],
      following: (json['following'] as List<dynamic>?)?.cast<String>() ?? [],
      posts: (json['posts'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  // Computed properties
  int get followersCount => followers.length;
  int get followingCount => following.length;
  int get postsCount => posts.length;

  @override
  String toString() =>
      'ProfileUserModel(uid: $uid, username: $username, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProfileUserModel && other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;
}
