import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> getUser(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (!doc.exists) return null;
    return UserModel.fromJson(doc.id, doc.data()!);
  }

  Stream<List<UserModel>> searchUsers(String query) {
    if (query.isEmpty) return Stream.value([]);

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
        .limit(20)
        .snapshots()
        .map((snapshot) => snapshot.docs.where((doc) => doc.id != currentUser.uid).map((doc) => UserModel.fromJson(doc.id, doc.data())).toList());
  }

  Future<List<UserModel>> getAllUsers() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) => UserModel.fromJson(doc.id, doc.data())).toList();
  }

  Future<List<UserModel>> getUsersByIds(List<String> userIds) async {
    if (userIds.isEmpty) return [];

    // Firestore는 whereIn 쿼리에서 최대 10개의 값만 허용하므로 청크로 나눠서 처리
    const chunkSize = 10;
    final chunks = <List<String>>[];

    for (var i = 0; i < userIds.length; i += chunkSize) {
      chunks.add(
        userIds.sublist(i, i + chunkSize > userIds.length ? userIds.length : i + chunkSize),
      );
    }

    final results = await Future.wait(
      chunks.map((chunk) => _firestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: chunk)
          .get()
          .then((snapshot) => snapshot.docs.map((doc) => UserModel.fromJson(doc.id, doc.data())).toList())),
    );

    return results.expand((users) => users).toList();
  }

  Future<void> updateFollow(
    Map<String, List<String>> currentUserFollowing,
    Map<String, List<String>> followingUserFollow,
  ) async {
    final currentUserId = currentUserFollowing.keys.first;
    final currentUserFollowingList = currentUserFollowing[currentUserId]!;

    final followingUserId = followingUserFollow.keys.first;
    final followingUserFolloList = followingUserFollow[followingUserId]!;

    await _firestore.collection("users").doc(currentUserId).update({
      "following": currentUserFollowingList,
    });

    await _firestore.collection("users").doc(followingUserId).update({
      "follow": followingUserFolloList,
    });
  }
}
