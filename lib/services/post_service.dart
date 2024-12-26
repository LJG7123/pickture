import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickture/models/comment.dart';
import 'package:pickture/models/like.dart';
import 'package:pickture/models/post.dart';
import 'package:pickture/models/user_model.dart';

class PostService {
  final FirebaseFirestore _firestore;

  PostService(this._firestore);

  Future<List<Post>> getPost() async {
    List<Post> posts = [];

    final snapshot = await _firestore.collection("posts").get();

    if (snapshot.docs.isEmpty) return posts;

    Set<String> userIds = snapshot.docs.map((doc) => doc.id).toSet();

    Map<String, UserModel> postUserMap = await getUserMap(userIds);

    for (String userId in userIds) {
      final userPost = await _firestore
          .collection("posts/$userId/post")
          .orderBy("createdAt", descending: true)
          .get();

      for (var userPostDoc in userPost.docs) {
        final likes = await getLikes(userPostDoc);
        final comments = await getComments(userPostDoc);

        final post = Post.fromJson(
          userPostDoc.id,
          userPostDoc.data(),
          likes,
          comments,
          postUserMap[userId]!,
        );
        posts.add(post);
      }
    }

    return posts;
  }

  Future<Map<String, UserModel>> getUserMap(Set<String> userIds) async {
    if (userIds.isEmpty) {
      return {};
    }

    final userSnapshots = await _firestore
        .collection("users")
        .where(FieldPath.documentId, whereIn: userIds.toList())
        .get();

    Map<String, UserModel> userMap = {};
    for (var userDoc in userSnapshots.docs) {
      userMap[userDoc.id] = UserModel.fromJson(userDoc.id, userDoc.data());
    }

    return userMap;
  }

  Future<List<Like>> getLikes(
      QueryDocumentSnapshot<Map<String, dynamic>> userPostDoc) async {
    final likeUserMap = await getUserMap(
        (userPostDoc.data()["likes"] as List<dynamic>)
            .map((likeJson) => likeJson["userId"] as String)
            .toSet());

    return (userPostDoc.data()["likes"] as List<dynamic>)
        .map((likeJson) =>
            Like.fromJson(likeJson, likeUserMap[likeJson["userId"] as String]!))
        .toList();
  }

  Future<List<Comment>> getComments(
      QueryDocumentSnapshot<Map<String, dynamic>> userPostDoc) async {
    final commentUserMap =
        await getUserMap(getUser(userPostDoc.data()["comments"]));

    return (userPostDoc.data()["comments"] as List<dynamic>)
        .map((commentJson) => _getCommentWithUser(commentJson, commentUserMap))
        .toList();
  }

  Set<String> getUser(List<dynamic> comments) {
    Set<String> userIds = {};

    for (var commentJson in comments) {
      userIds.add(commentJson["userId"] as String);

      if (commentJson["comments"] != null) {
        userIds.addAll(getUser(commentJson["comments"]));
      }
    }

    return userIds;
  }

  Comment _getCommentWithUser(
    Map<String, dynamic> commentJson,
    Map<String, UserModel> commentUserMap,
  ) {
    final user = commentUserMap[commentJson["userId"] as String]!;

    final List<Comment> comments =
        (commentJson["comments"] as List<dynamic>? ?? [])
            .map((nestedCommentJson) =>
                _getCommentWithUser(nestedCommentJson, commentUserMap))
            .toList();

    return Comment.fromJson(commentJson, user, comments);
  }

  Future<void> addPost(Post post) async {
    await _firestore.collection("posts").doc(post.creator.uid).set({
      "createdAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await _firestore
        .collection("posts/${post.creator.uid}/post")
        .add(post.toJson());
  }

  Future<void> updatePost(Post post) async {
    await _firestore
        .collection("posts/${post.creator.uid}/post")
        .doc(post.postId)
        .update(post.toJson());
  }

  Future<void> deletePost(Post post) async {
    await _firestore
        .collection("posts/${post.creator.uid}/post")
        .doc(post.postId)
        .delete();
  }
}
