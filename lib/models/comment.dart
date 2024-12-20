import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String userId;
  final String comment;
  final List<Comment> comments;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Comment({
    required this.userId,
    required this.comment,
    required this.comments,
    required this.createdAt,
    this.updatedAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      userId: json["userId"],
      comment: json["comment"],
      comments: (json["comments"] as List<dynamic>)
          .map((comment) => Comment.fromJson(comment))
          .toList(),
      createdAt: (json["createdAt"] as Timestamp).toDate(),
      updatedAt: json["updatedAt"] != null
          ? (json["updatedAt"] as Timestamp).toDate()
          : null,
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
