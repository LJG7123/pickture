import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pickture/core/error/app_exception.dart';
import 'package:pickture/core/error/auth_exception.dart';
import 'package:pickture/models/user_model.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;
  UserCredential? userCredential;

  AuthService(this._firebaseAuth, this._firestore, this._googleSignIn);

  Future<UserModel> signIn(String email, String password) async {
    try {
      userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      _handleError(e);
    }
    var snapshot = await _firestore
        .collection('users')
        .doc(userCredential?.user?.uid)
        .get();
    if (snapshot.data() == null) {
      throw AppException(
        '로그인에 실패했습니다.',
        code: 'login_failed',
      );
    }
    return UserModel.fromJson(userCredential!.user!.uid, snapshot.data()!);
  }

  Future<UserModel?> signInWithGoogle() async {
    final googleAccount = await _googleSignIn.signIn();
    if (googleAccount == null) {
      throw AppException(
        '로그인에 실패했습니다.',
        code: 'login_failed',
      );
    }
    final googleAuth = await googleAccount.authentication;
    final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    userCredential = await _firebaseAuth.signInWithCredential(credential);

    var snapshot = await _firestore
        .collection('users')
        .doc(userCredential?.user?.uid)
        .get();
    if (snapshot.data() == null) {
      return null;
    }
    return UserModel.fromJson(userCredential!.user!.uid, snapshot.data()!);
  }

  Future<UserModel?> signUpWithGoogle(String dob, String name) async {
    if (userCredential == null) return null;

    await _firestore.collection('users').doc(userCredential!.user!.uid).set({
      'dob': dob,
      'email': userCredential!.user!.email,
      'name': name,
    });

    var snapshot = await _firestore
        .collection('users')
        .doc(userCredential!.user!.uid)
        .get();
    if (snapshot.data() == null) {
      return null;
    }
    return UserModel.fromJson(userCredential!.user!.uid, snapshot.data()!);
  }

  void _handleError(Object error) {
    if (error is FirebaseAuthException) {
      throw handleAuthException(error);
    } else {
      throw AppException("알 수 없는 오류가 발생했습니다.");
    }
  }
}
