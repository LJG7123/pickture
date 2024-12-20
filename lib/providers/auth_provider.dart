import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pickture/models/user_model.dart';
import 'package:pickture/services/auth_service.dart';

final authProvider = StateNotifierProvider<AuthNotifier, UserModel?>((ref) =>
    AuthNotifier(
        AuthService(FirebaseAuth.instance, FirebaseFirestore.instance)));

class AuthNotifier extends StateNotifier<UserModel?> {
  final AuthService authService;

  AuthNotifier(this.authService) : super(null);

  Future<void> signIn(String email, String password) async {
    await authService.signIn(email, password).then((user) {
      state = user;
    });
  }

  Future<void> signInWithGoogle() async {
    await authService.signInWithGoogle().then((user) {
      state = user;
    });
  }

  Future<void> signUpWithGoogle(String dob, String name) async {
    await authService.signUpWithGoogle(dob, name).then((user) {
      state = user;
    });
  }
}
