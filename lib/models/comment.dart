import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickture/models/user_model.dart';

class Comment {
  final String userId;
  final String comment;
  final List<Comment> comments;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final UserModel user;

  Comment({
    required this.userId,
    required this.comment,
    required this.comments,
    required this.createdAt,
    required this.user,
    this.updatedAt,
  });

  factory Comment.fromJson(
      Map<String, dynamic> json, UserModel user, List<Comment> comments) {
    return Comment(
      userId: json["userId"],
      comment: json["comment"],
      comments: comments,
      createdAt: (json["createdAt"] as Timestamp).toDate(),
      updatedAt: json["updatedAt"] != null
          ? (json["updatedAt"] as Timestamp).toDate()
          : null,
      user: user,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "comment": comment,
      "comments": comments.map((comment) => comment.toJson()).toList(),
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }
}
