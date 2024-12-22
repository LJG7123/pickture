class UserModel {
  final String uid;
  final String name;
  final String email;
  final String dob;
  final String? profileImage;

  UserModel(
      {required this.uid,
      required this.name,
      required this.email,
      required this.dob,
      this.profileImage});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'dob': dob,
      'profileImage': profileImage,
    };
  }

  factory UserModel.fromJson(String uid, Map<String, dynamic> json) {
    return UserModel(
      uid: uid,
      name: json['name'],
      email: json['email'],
      dob: json['dob'],
      profileImage: json['profileImage'],
    );
  }
}
