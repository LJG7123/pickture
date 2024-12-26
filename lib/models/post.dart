import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickture/models/comment.dart';
import 'package:pickture/models/like.dart';
import 'package:pickture/models/user_model.dart';

class Post {
  final String postId;
  final String title;
  final String content;
  final List<Like> likes;
  final List<Comment> comments;
  final UserModel creator;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Post({
    required this.postId,
    required this.title,
    required this.content,
    required this.likes,
    required this.comments,
    required this.creator,
    required this.createdAt,
    this.updatedAt,
  });

  factory Post.fromJson(String postId, Map<String, dynamic> json,
      List<Like> likes, List<Comment> comments, UserModel creator) {
    return Post(
      postId: postId,
      title: json["title"],
      content: json["content"],
      likes: likes,
      comments: comments,
      creator: creator,
      createdAt: (json["createdAt"] as Timestamp).toDate(),
      updatedAt: json["updatedAt"] != null
          ? (json["updatedAt"] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "content": content,
      "likes": likes.map((like) => like.toJson()).toList(),
      "comments": comments.map((comment) => comment.toJson()).toList(),
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }

  Post copyWith({
    String? postId,
    String? title,
    String? content,
    List<Like>? likes,
    List<Comment>? comments,
    UserModel? creator,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Post(
      postId: postId ?? this.postId,
      title: title ?? this.title,
      content: content ?? this.content,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      creator: creator ?? this.creator,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
