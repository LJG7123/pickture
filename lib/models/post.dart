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
  final UserModel createUserModel;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Post({
    required this.postId,
    required this.title,
    required this.content,
    required this.likes,
    required this.comments,
    required this.createUserModel,
    required this.createdAt,
    this.updatedAt,
  });

  factory Post.fromJson(
      String postId, Map<String, dynamic> json, UserModel createUserModel) {
    return Post(
      postId: postId,
      title: json["title"],
      content: json["content"],
      likes: (json["likes"] as List<dynamic>)
          .map((likeJson) => Like.fromJson(likeJson))
          .toList(),
      comments: (json["comments"] as List<dynamic>)
          .map((commentJson) => Comment.fromJson(commentJson))
          .toList(),
      createUserModel: createUserModel,
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
    UserModel? createUserModel,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Post(
      postId: postId ?? this.postId,
      title: title ?? this.title,
      content: content ?? this.content,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      createUserModel: createUserModel ?? this.createUserModel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
