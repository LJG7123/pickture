import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pickture/models/user_model.dart';
import 'package:pickture/services/auth_service.dart';
import 'package:pickture/utils/validator.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>(
    (ref) => AuthNotifier(AuthService(FirebaseAuth.instance, FirebaseFirestore.instance, FirebaseMessaging.instance, GoogleSignIn())));

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthService authService;

  AuthNotifier(this.authService) : super(const AsyncValue.data(null)) {
    if (authService.currentUser != null) {
      fetchUserData();
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await authService.signIn(email, password);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      await authService.signInWithGoogle();
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> signUp(String email, String password, String dob, String name) async {
    try {
      await authService.signUp(email, password, dob, name);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> signUpWithGoogle(String dob, String name) async {
    try {
      await authService.signUpWithGoogle(dob, name);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> signOut() async {
    try {
      await authService.signOut();
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return;
    }
    state = const AsyncValue.data(null);
  }

  Future<void> fetchUserData() async {
    state = await AsyncValue.guard(() => authService.getCurrentUserData());
  }

  Future<void> updateProfileImage(String? url) async {
    try {
      await authService.updateProfileImage(url);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
    var user = state.value!;
    state = AsyncValue.data(UserModel(
      uid: user.uid,
      name: user.name,
      email: user.email,
      dob: user.dob,
      profileImage: url,
    ));
  }

  Future<UserModel?> getUserData() {
    return authService.getCurrentUserData();
  }

  Future<bool> isEmailAvailable(String email) async {
    if (!Validator.isEmailValid(email)) return false;
    return authService.isEmailAvailable(email);
  }

  bool isPasswordAvailable(String password) {
    return Validator.isPasswordValid(password);
  }
}
