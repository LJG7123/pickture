import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pickture/models/post.dart';
import 'package:pickture/models/user_model.dart';
import 'package:pickture/providers/auth_provider.dart';

class PostService {
  final FirebaseFirestore _firestore;

  PostService(this._firestore);

  Future<List<Post>> getAllPost() async {
    List<Post> posts = [];
    final snapshot = await _firestore.collection("posts").get();

    if (snapshot.docs.isEmpty) return posts;

    for (var doc in snapshot.docs) {
      final user = await _firestore.collection("users").doc(doc.id).get();

      if (user.exists) {
        final createUserModel = UserModel(
          uid: doc.id,
          name: user.data()!["name"],
          email: user.data()!["email"],
          dob: user.data()!["dob"],
        );

        final userPost = await _firestore
            .collection("posts/${doc.id}/post")
            .orderBy("createdAt", descending: true)
            .get();
        if (userPost.docs.isNotEmpty) {
          for (var userDoc in userPost.docs) {
            posts.add(
                Post.fromJson(userDoc.id, userDoc.data(), createUserModel));
          }
        }
      }
    }

    return posts;
  }

  Future<void> addPost(Post post, WidgetRef ref) async {
    final userId = ref.watch(authProvider)?.uid;

    await _firestore.collection("posts").doc(userId).set({
      "createdAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await _firestore.collection("posts/$userId/post").add(post.toJson());
  }

  Future<void> updatePost(Post post) async {
    await _firestore
        .collection("posts/${post.createUserModel.uid}/post")
        .doc(post.postId)
        .update(post.toJson());
  }

  Future<void> deletePost(Post post) async {
    await _firestore
        .collection("posts/${post.createUserModel.uid}/post")
        .doc(post.postId)
        .delete();
  }
}
