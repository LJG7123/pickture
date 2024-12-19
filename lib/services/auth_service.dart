import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthService(this._firebaseAuth, this._firestore);

  Future<UserCredential> signIn(String email, String password) => _firebaseAuth
      .signInWithEmailAndPassword(email: email, password: password);
}
