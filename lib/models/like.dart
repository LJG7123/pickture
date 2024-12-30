import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickture/models/user_model.dart';

class Like {
  final String userId;
  final DateTime createdAt;
  UserModel? user;

  Like({
    required this.userId,
    required this.createdAt,
    this.user,
  });

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      userId: json["userId"],
      createdAt: (json["createdAt"] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "createdAt": createdAt,
    };
  }

  void setUser(UserModel user) {
    this.user = user;
  }
}
