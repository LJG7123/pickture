import 'package:cloud_firestore/cloud_firestore.dart';

class Like {
  final String userId;
  final DateTime createdAt;

  Like({
    required this.userId,
    required this.createdAt,
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
}
