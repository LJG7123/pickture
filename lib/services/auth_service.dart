import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pickture/core/error/app_exception.dart';
import 'package:pickture/core/error/auth_exception.dart';
import 'package:pickture/models/user_model.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final FirebaseMessaging _messaging;
  final GoogleSignIn _googleSignIn;

  User? get currentUser => _firebaseAuth.currentUser;

  AuthService(this._firebaseAuth, this._firestore, this._messaging, this._googleSignIn);

  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> signInWithGoogle() async {
    final googleAccount = await _googleSignIn.signIn();
    if (googleAccount == null) {
      throw AppException(
        '로그인에 실패했습니다.',
        code: 'login_failed',
      );
    }
    final googleAuth = await googleAccount.authentication;
    final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    await _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> signUp(String email, String password, String dob, String name) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      _handleError(e);
    }

    var userUid = currentUser?.uid;
    if (userUid == null) {
      throw AppException('회원가입에 실패했습니다.', code: 'signup_failed');
    }
    _firestore.collection('users').doc(userUid).set({
      'dob': dob,
      'email': email,
      'name': name,
    });
  }

  Future<void> signUpWithGoogle(String dob, String name) async {
    if (currentUser == null) return;

    await _firestore.collection('users').doc(currentUser!.uid).set({
      'dob': dob,
      'email': currentUser!.email,
      'name': name,
    });
  }

  Future<void> signOut() async {
    try {
      await _firestore.collection('users').doc(currentUser!.uid).update({'fcmToken': null});
      await _firebaseAuth.signOut();
    } catch (e) {
      _handleError(e);
    }
  }

  Future<UserModel?> getCurrentUserData() async {
    if (currentUser == null) return null;
    var snapshot = await _firestore.collection('users').doc(currentUser!.uid).get();

    if (snapshot.data() == null) return null;
    _updateFcmToken();
    return UserModel.fromJson(currentUser!.uid, snapshot.data()!);
  }

  Future<void> updateProfileImage(String? url) async {
    if (currentUser == null) return;
    await _firestore.collection('users').doc(currentUser!.uid).update({'profileImage': url});
  }

  Future<void> updateName(String name) async {
    if (currentUser == null) return;
    await _firestore.collection('users').doc(currentUser!.uid).update({'name': name});
  }

  Future<bool> isEmailAvailable(String email) async {
    var accounts = await _firestore.collection('users').where('email', isEqualTo: email).count().get();
    return accounts.count == 0;
  }

  void _handleError(Object error) {
    if (error is FirebaseAuthException) {
      throw handleAuthException(error);
    } else {
      throw AppException("알 수 없는 오류가 발생했습니다.");
    }
  }

  void _updateFcmToken() async {
    if (currentUser == null) return;
    await _firestore.collection('users').doc(currentUser!.uid).update({'fcmToken': await _messaging.getToken()});
  }
}
