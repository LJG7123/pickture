import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pickture/models/user_model.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  UserCredential? userCredential;

  AuthService(this._firebaseAuth, this._firestore);

  Future<UserModel> signIn(String email, String password) async {
    userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    var snapshot = await _firestore
        .collection('users')
        .doc(userCredential?.user?.uid)
        .get();
    if (snapshot.data() == null) {
      throw Exception('login_failed_exception');
    }
    return UserModel.fromJson(userCredential!.user!.uid, snapshot.data()!);
  }
}
