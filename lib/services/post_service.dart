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

    await Future.wait(postSnapshot.docs.map((doc) async {
      userIds.add(doc.id);
      await _getUserPost(posts, doc.id, userIds);
    }));

    await _setPostUser(posts, userIds);
    posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return posts;
  }

  Future<List<Post>> getPostByUserId(String userId) async {
    final posts = <Post>[];
    final userIds = <String>{userId};

    await _getUserPost(posts, userId, userIds);
    await _setPostUser(posts, userIds);
    posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return posts;
  }

// #region Post 가져오는 부분

  Future<void> _getUserPost(List<Post> posts, String userId, Set<String> userIds) async {
    final userPost = await _firestore.collection("posts/$userId/post").get();

    for (var postDoc in userPost.docs) {
      final likes = _getLikes(postDoc, userIds);
      final comments = _getComments(postDoc, userIds);
      final post = Post.fromJson(
        postDoc.id,
        postDoc.data(),
        likes,
        comments,
      );
      post.setUser(UserModel(uid: userId, name: "", email: "", dob: "", follow: [], following: []));
      posts.add(post);
    }
  }

  List<Like> _getLikes(QueryDocumentSnapshot<Map<String, dynamic>> doc, Set<String> userIds) {
    final likes = doc.data()["likes"] as List<dynamic>? ?? [];

    return likes.map((like) {
      userIds.add(like["userId"].toString());
      return Like.fromJson(like);
    }).toList();
  }

  List<Comment> _getComments(QueryDocumentSnapshot<Map<String, dynamic>> doc, Set<String> userIds) {
    final comments = doc.data()["comments"] as List<dynamic>? ?? [];
    return comments.map((comment) => _parseComment(comment, userIds)).toList();
  }

  Comment _parseComment(Map<String, dynamic> commentJson, Set<String> userIds) {
    userIds.add(commentJson["userId"].toString());

    final comments = (commentJson["comments"] as List<dynamic>? ?? []).map((comment) {
      return _parseComment(comment, userIds);
    }).toList();

    return Comment.fromJson(commentJson, comments);
  }

  Future<void> _setPostUser(List<Post> posts, Set<String> userIds) async {
    final userMap = await _getUserMap(userIds);

    for (Post post in posts) {
      post.setUser(userMap[post.creator!.uid]!);
      for (Like like in post.likes) {
        like.setUser(userMap[like.userId]!);
      }

      for (Comment comment in post.comments) {
        _setCommentUser(comment, userMap);
      }
    }
  }

  Future<Map<String, UserModel>> _getUserMap(Set<String> userIds) async {
    final userService = UserService();
    final userModels = await userService.getUsersByIds(userIds.toList());

    Map<String, UserModel> userMap = {};
    for (UserModel user in userModels) {
      userMap[user.uid] = user;
    }

    return userMap;
  }

  void _setCommentUser(Comment comment, Map<String, UserModel> userMap) {
    comment.setUser(userMap[comment.userId]!);

    for (var nestedComment in comment.comments) {
      _setCommentUser(nestedComment, userMap);
    }
  }

// #endregion Post 가져오는 부분

  Future<Post> addPost(Post post) async {
    await _firestore.collection("posts").doc(post.creator!.uid).set({
      "createdAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    DocumentReference postRef = await _firestore.collection("posts/${post.creator!.uid}/post").add(post.toJson());

    return post.copyWith(postId: postRef.id);
  }

  Future<void> updatePost(Post post) async {
    await _firestore.collection("posts/${post.creator!.uid}/post").doc(post.postId).update(post.toJson());
  }

  Future<void> deletePost(Post post) async {
    await _firestore.collection("posts/${post.creator!.uid}/post").doc(post.postId).delete();
  }
}
