import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickture/models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore;

  UserService(this._firestore);

  Future<List<UserModel>> getUserModels(List<String> userIds) async {
    List<Future<DocumentSnapshot>> futures = [];

    for (String userId in userIds) {
      futures.add(_firestore.collection("users").doc(userId).get());
    }

    List<DocumentSnapshot> snapshots = await Future.wait(futures);

    List<UserModel> userModels = [];

    for (DocumentSnapshot snapshot in snapshots) {
      if (snapshot.exists && snapshot.data() != null) {
        userModels.add(UserModel.fromJson(
            snapshot.id, snapshot.data() as Map<String, dynamic>));
      }
    }

    return userModels;
  }
}
