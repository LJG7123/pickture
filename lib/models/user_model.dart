class UserModel {
  final String uid;
  final String name;
  final String email;
  final String dob;
  final String? profileImage;
  final List<String> follow;
  final List<String> following;

  String get userId => email.split('@')[0];

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.dob,
    this.profileImage,
    required this.follow,
    required this.following,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'dob': dob,
      'profileImage': profileImage,
      'follow': follow,
      'following': following,
    };
  }

  factory UserModel.fromJson(String uid, Map<String, dynamic> json) {
    List<String> follows = [];
    List<String> followings = [];

    if (json['follow'] != null) {
      follows = (json['follow'] as List<dynamic>).map((userId) => userId.toString()).toList();
    }

    if (json['following'] != null) {
      followings = (json['following'] as List<dynamic>).map((userId) => userId.toString()).toList();
    }

    return UserModel(
      uid: uid,
      name: json['name'],
      email: json['email'],
      dob: json['dob'],
      profileImage: json['profileImage'],
      follow: follows,
      following: followings,
    );
  }
}
