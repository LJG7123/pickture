import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickture/models/comment.dart';
import 'package:pickture/models/like.dart';
import 'package:pickture/models/post.dart';
import 'package:pickture/models/user_model.dart';
import 'package:pickture/services/user_service.dart';

class PostService {
  final FirebaseFirestore _firestore;

  PostService(this._firestore);

  Future<List<Post>> getPost() async {
    final posts = <Post>[];
    final userIds = <String>{};

    final postSnapshot = await _firestore.collection("posts").get();

    if (postSnapshot.docs.isEmpty) return posts;

    for (var doc in postSnapshot.docs) {
      userIds.add(doc.id);
      final userPost = await _firestore.collection("posts/${doc.id}/post").orderBy("createdAt", descending: true).get();

      for (var postDoc in userPost.docs) {
        final likes = postDoc.data()["likes"] as List<dynamic>? ?? [];
        final comments = postDoc.data()["comments"] as List<dynamic>? ?? [];

        userIds.addAll(likes.map((like) => like["userId"].toString()));
        userIds.addAll(_extractUserIds(comments));
      }
    }

    final userMap = await getUserMap(userIds);

    await Future.wait(postSnapshot.docs.map((doc) async {
      final userPost = await _firestore.collection("posts/${doc.id}/post").orderBy("createdAt", descending: true).get();

      for (var postDoc in userPost.docs) {
        final likes = postDoc.data()["likes"] as List<dynamic>? ?? [];
        final comments = _getComments(postDoc, userMap);
        final post = Post.fromJson(
          postDoc.id,
          postDoc.data(),
          likes.map((like) => Like.fromJson(like, userMap[like["userId"].toString()]!)).toList(),
          comments,
          userMap[doc.id]!,
        );
        posts.add(post);
      }
    }));

    return posts;
  }

  Future<List<Post>> getPostByUserId(String userId) async {
    final posts = <Post>[];
    final userIds = <String>{userId};

    final postSnapshot = await _firestore.collection("posts").get();

    if (postSnapshot.docs.isEmpty) return posts;

    final userPost = await _firestore.collection("posts/$userId/post").orderBy("createdAt", descending: true).get();

    for (var postDoc in userPost.docs) {
      final likes = postDoc.data()["likes"] as List<dynamic>? ?? [];
      final comments = postDoc.data()["comments"] as List<dynamic>? ?? [];

      userIds.addAll(likes.map((like) => like["userId"].toString()));
      userIds.addAll(_extractUserIds(comments));
    }

    final userMap = await getUserMap(userIds);

    for (var postDoc in userPost.docs) {
      final likes = postDoc.data()["likes"] as List<dynamic>? ?? [];
      final comments = _getComments(postDoc, userMap);
      final post = Post.fromJson(
        postDoc.id,
        postDoc.data(),
        likes.map((like) => Like.fromJson(like, userMap[like["userId"].toString()]!)).toList(),
        comments,
        userMap[userId]!,
      );
      posts.add(post);
    }

    return posts;
  }

  List<Comment> _getComments(QueryDocumentSnapshot<Map<String, dynamic>> doc, Map<String, UserModel> userMap) {
    final comments = doc.data()["comments"] as List<dynamic>? ?? [];
    return comments.map((comment) => getComment(comment, userMap)).toList();
  }

  Comment getComment(Map<String, dynamic> commentJson, Map<String, UserModel> userMap) {
    final user = userMap[commentJson["userId"] as String]!;
    final nestedComments = (commentJson["comments"] as List<dynamic>? ?? []).map((nestedCommentJson) => getComment(nestedCommentJson, userMap)).toList();

    return Comment.fromJson(commentJson, user, nestedComments);
  }

  Set<String> _extractUserIds(List<dynamic> comments) {
    final userIds = <String>{};

    for (var comment in comments) {
      userIds.add(comment["userId"].toString());
      if (comment["comments"] != null) {
        userIds.addAll(_extractUserIds(comment["comments"] as List<dynamic>));
      }
    }
    return userIds;
  }

  Future<Map<String, UserModel>> getUserMap(Set<String> userIds) async {
    final userService = UserService();
    final userModels = await userService.getUsersByIds(userIds.toList());

    Map<String, UserModel> userMap = {};
    for (UserModel user in userModels) {
      userMap[user.uid] = user;
    }

    return userMap;
  }

  Future<Post> addPost(Post post) async {
    await _firestore.collection("posts").doc(post.creator.uid).set({
      "createdAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    DocumentReference postRef = await _firestore.collection("posts/${post.creator.uid}/post").add(post.toJson());

    return post.copyWith(postId: postRef.id);
  }

  Future<void> updatePost(Post post) async {
    await _firestore.collection("posts/${post.creator.uid}/post").doc(post.postId).update(post.toJson());
  }

  Future<void> deletePost(Post post) async {
    await _firestore.collection("posts/${post.creator.uid}/post").doc(post.postId).delete();
  }
}
