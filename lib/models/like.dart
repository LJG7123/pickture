import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickture/models/user_model.dart';

class Like {
  final String userId;
  final DateTime createdAt;
  final UserModel user;

  Like({
    required this.userId,
    required this.createdAt,
    required this.user,
  });

  factory Like.fromJson(Map<String, dynamic> json, UserModel user) {
    return Like(
      userId: json["userId"],
      createdAt: (json["createdAt"] as Timestamp).toDate(),
      user: user,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "createdAt": createdAt,
    };
  }
}
