class UserModel {
  final String uid;
  final String name;
  final String email;
  final String dob;

  UserModel(
      {required this.uid,
      required this.name,
      required this.email,
      required this.dob});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'dob': dob,
    };
  }

  factory UserModel.fromJson(String uid, Map<String, dynamic> json) {
    return UserModel(
      uid: uid,
      name: json['name'],
      email: json['email'],
      dob: json['dob'],
    );
  }
}
